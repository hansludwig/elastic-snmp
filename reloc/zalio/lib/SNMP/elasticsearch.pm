#!/usr/bin/env perl

package SNMP::elasticsearch;

#
# -----------------------------------------------------------------------------
use strict;
use Sys::Hostname;
use LWP::Simple;
use URI;
use JSON::XS;
use NetSNMP::OID;
use vars qw(@EXPORT @EXPORT_OK %EXPORT_TAGS @ISA $AUTOLOAD %config %oidmap);
use lib (
          "$ENV{HOME}/rpm/BUILD/elasticsearch-snmp/reloc/zalio/etc",
          "reloc/zalio/etc",
        );
use Data::Dumper;
require SNMP::elasticsearch::oidmap;
require Exporter;
require "elasticsearch-snmp.conf";

@ISA = qw(Exporter);
@EXPORT = qw(&substitute &insert &remove);

#
# -----------------------------------------------------------------------------
# variables you want to export, don't use my to declare them!!!
my %default_params = (
                 refresh_timer => 5, # refresh ever N seconds
                 calc_steps => 1,    # calculated values are calculated per sec
               );
my %statusnr = (
                 green  => 1,
                 yellow => 2,
                 red    => 3,
                 1      => 1,
                 2      => 2,
                 3      => 3,
               );
my %statusstr = (
                 1      => "green",
                 2      => "yellow",
                 3      => "red",
                 green  => "green",
                 yellow => "yellow",
                 red    => "red",
               );
my $cluster_health = {};
my $cluster_state = {};
my $cluster_stats = {};
my $nodes_stats = {};
my $node_stats = {};
my $last_cluster_health = {};
my $last_cluster_state = {};
my $last_nodes_stats = {};
my $last_node_stats = {};


#
# -----------------------------------------------------------------------------
# package methods
sub new {
  my $self = {};
  my $class = shift;
     $self->{es_data} = shift;
  unless ( defined($self->{es_data}) && ref($self->{es_data}) eq "HASH" ) {
    printf STDERR "%s: expects a HASH ref as argument to the constructor\n", __PACKAGE__;
    return();
  }
  # use values from default_params, the command line and
  # last what we might have 'shifted' off above
  %{$self} = ((%default_params), (%config), @_, (%{$self}));

  printf STDERR "DEBUG: %s: %s\n", (caller(0))[3], Data::Dumper->Dump([$self], [qw(self)]) if ( $self->{debug} );

  bless($self, $class);
  $self->{last_load} = 0;
  $self->update_stats();

  return($self);
}

sub update_stats {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: update_stats(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );
  my $host = ();
  my %table = ();

  $self->load() if ( $self->expired() );

  # Get the node statistics for the local node
  $host = (defined($self->{url}->{host}) && 
           $self->{url}->{host} ? $self->{url}->{host} : hostname());
  $host = (split(/\.+/, $host))[0]; # Use non fully qualified hostname
  foreach my $n (keys(%{$nodes_stats->{nodes}})) {
    if ( $nodes_stats->{nodes}->{$n}->{host} eq $host ) {
       $node_stats = $nodes_stats->{nodes}->{$n};
       $node_stats->{uuid} = $n;
       last;
    }
  }
  
  # Are we the master node
  $node_stats->{master} = ($cluster_state->{master_node} eq $node_stats->{uuid} ? 1 : 0);

  # Fill es_data with life stats, columnar objects (tables) are dealt
  # with in a second step
  foreach my $o (keys(%oidmap)) {
    if ( defined($oidmap{$o}->{table_entry}) ) {
      push(@{$table{$oidmap{$o}->{parent}}}, $o);
      next;
    }
    defined($oidmap{$o}->{index}) and next;
    my $temp = '$node_stats->{transport}->{rx_count}';
    #printf STDERR "TEMP: %04d: %s", __LINE__, Data::Dumper->Dump([$node_stats], [qw(node_stats)]);
    printf STDERR "TEMP: %04d: %s\n", __LINE__, eval($temp);
    $self->_get_oid($o, $oidmap{$o}->{oid});
  }
  
  # Deal with table data
  printf STDERR "TEMP: %04d: table keys '%s'\n", __LINE__ ,join(", ", keys(%table));
  foreach my $t (keys(%table)) {
    my $table_name = "SNMP::elasticsearch::" . $oidmap{$t}->{parent};
    printf STDERR "TEMP: %04d: table_name ='%s'\n", __LINE__, $table_name;
    eval { eval "require $table_name" };
    if ( $@ ) {
      printf STDERR "%s: failed to load table $table_name\n", __PACKAGE__;
      next;
    }
    printf STDERR "DEBUG: %04d: loaded $table_name\n", __LINE__ if ( $self->{debug} >= 2 );
    printf STDERR "TEMP: %04d: %s", __LINE__, Data::Dumper->Dump([$esTable], [qw(esTable)]);
    printf STDERR "TEMP: %04d:  '$oidmap{$t}->{jref}'\n", __LINE__;
    printf STDERR "TEMP: %04d:  %s\n", __LINE__, Data::Dumper->Dump([$cluster_health], [qw(cluster_health)]);
    my $indices = eval($oidmap{$t}->{jref});
    foreach my $i (keys(%{$indices})) {
      my $index = $table_name->new();
      my $numind = ();
      map { $numind += ord($_) } split(//, $i);
      foreach my $o (@{$table{$t}}) {
        $self->{es_data}->{$oidmap{$o}->{oid} . "." . $numind} = $index->get($o);
      }
    }
  }
  
  @{$self->{oids}} = sort { new NetSNMP::OID($a) <=> new NetSNMP::OID($b) } (keys %{$self->{es_data}});

  return(1);
}

sub load {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: load(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );

  # Get information from elasticsearch via REST interface
  $cluster_health = decode_json($self->_get_json("cluster_health"));
  $cluster_state = decode_json($self->_get_json("cluster_state"));
  $cluster_stats = decode_json($self->_get_json("cluster_stats"));
  $nodes_stats = decode_json($self->_get_json("nodes_stats"));

  $self->{last_load} = time();
}

sub oid {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: oid(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid = shift;
  
  #return() unless ( defined(wantarray) );
  printf STDERR "DEBUG: %s", Data::Dumper->Dump([$self->{es_data}], [qw(es_data)]);

}

sub expired {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: expired(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );

  return(((time() - $self->{refresh_timer}) > $self->{last_load} ? 1 : 0));
}

sub _calculate ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: _calculate(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid = shift;
  my($elapsed,$last,$current) = ();

  # This should do a deep copy of the whole hash of hashes.
  %{$last_cluster_health} = %{$cluster_health} unless ( %{$last_cluster_health} );
  %{$last_cluster_state} = %{$cluster_state} unless ( %{$last_cluster_state} );
  %{$last_nodes_stats} = %{$nodes_stats} unless ( %{$last_nodes_stats} );
  %{$last_node_stats} = %{$node_stats} unless ( %{$last_node_stats} );

  # elapsed time in seconds, sys time is returned in millies
  $elapsed = ($node_stats->{process}->{timestamp} - 
             $last_node_stats->{process}->{timestamp}) / 1000;
  $elapsed = 1 if ( $elapsed < 1 );
  printf STDERR "TEMP: %04d: oid = '$oid', %s", __LINE__, Data::Dumper->Dump([$oidmap{$oid}], [qw(oid)]);
  $last = $oidmap{$oid}->{jref};
  $last =~ s/^\$/\$last_/;
  printf STDERR "TEMP: %04d:  '$last'\n", __LINE__;
  $last = eval($last);
  printf STDERR "TEMP: %04d:  '$oidmap{$oid}->{jref}'\n", __LINE__;
  $current = eval($oidmap{$oid}->{jref});
  
  printf STDERR "TEMP: %04d: last = '$last', current = '$current'\n", __LINE__;
  printf STDERR "TEMP: %04d: ($current - $last) / $elapsed * $self->{calc_steps})\n", __LINE__;
  return(($current - $last) / $elapsed * $self->{calc_steps});
}

sub _get_oid ($$) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: _get_oid(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid_str = shift;
  my $oid_num = shift;

  no strict qw(refs vars);
  for (my $i = 0;  $i <= $#_; $i++) {
    $$_[$i++] = ($_[$i] ? $_[$i] : "n/a");
  }

  $cluster_health = $cluster_health;
  $cluster_state = $cluster_state;
  $cluster_stats = $cluster_stats;
  $nodes_stats = $nodes_stats;
  $node_stats = $node_stats;

  printf STDERR "TEMP: %04d: %s\n", __LINE__, $oidmap{$oid_str}->{jref};
  $self->{es_data}->{$oid_num} = ($oid_str =~ /Del$/ ? 
                                 $self->_calculate($oid_str) :
                                 eval($oidmap{$oid_str}->{jref}));
  printf STDERR "TEMP: %04d: %s\n", __LINE__, $self->{es_data}->{$oid_num};

  return(1);
}

sub _get_json ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %04d - %d: _get_json(%s)\n", __LINE__, $self->{debug}, join(", ", @_) if ( $self->{debug} >= 5 );
  my $url = shift;
  my($uri, $json) = ();

  $uri = URI->new($self->{url}->{$url});
  $uri->host($self->{url}->{host}) if ( defined($self->{url}->{host}) );
  $uri->port($self->{url}->{port}) if ( defined($self->{url}->{port}) );

  printf STDERR "DEBUG: reloading $uri\n" if ( $self->{debug} );
  $json = get($uri) or die "$!";

  return($json);
}

1;
