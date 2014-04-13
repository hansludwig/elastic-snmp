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
use NetSNMP::ASN (':all');
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
my $last_cluster_stats = {};
my $last_nodes_stats = {};
my $last_node_stats = {};


#
# -----------------------------------------------------------------------------
# package methods
sub new {
  my $self = {};
  my $class = shift;
     $self->{es_data}->{val} = shift;
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
  printf STDERR "DEBUG: %s - %04d: update_stats(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $host = ();
  my %table = ();
  # without this eval doesn't find the variable
  $cluster_health = $cluster_health;
  $cluster_state = $cluster_state;
  $cluster_stats = $cluster_stats;
  $nodes_stats = $nodes_stats;
  $node_stats = $node_stats;

  return (1) unless ( $self->expired() );

  $self->load();

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
  foreach my $oid_ind (keys(%oidmap)) {
    if ( defined($oidmap{$oid_ind}->{table_entry}) ) {
      push(@{$table{$oidmap{$oid_ind}->{parent}}}, $oid_ind);
      next;
    }
    defined($oidmap{$oid_ind}->{index}) and next;
    my $temp = '$node_stats->{transport}->{rx_count}';
    $self->_get_oid($oid_ind, $oidmap{$oid_ind}->{oid});
  }
  
  # Deal with table data
  #
  # xxxEntry elements are used as keys for all elements of a table. 
  # These keys have been pushed into %table in the processing above.
  printf STDERR "TEMP: %s - %04d: %s", __PACKAGE__, __LINE__, Data::Dumper->Dump([\%table], [qw(table)]);
  foreach my $xxxEntry (keys(%table)) {
    #
    # Get indices via jref field of the xxxEntry oid.
    my $indices = eval($oidmap{$xxxEntry}->{jref});
    foreach my $ind (keys(%{$indices})) {
      printf STDERR "DEBUG: %s - %04d: \$xxxEntry = '%s', \$ind = '%s'\n", __PACKAGE__, __LINE__, $xxxEntry, $ind if ( $self->{debug} >= 2 );
      #
      # calculate the numeric index appended to the numeric OID
      # for this indices member.
      my $index = ();
      map { $index += ord($_) } split(//, $ind);

      #
      # work with the original oid references from %oidmap
      foreach my $oid_ref (@{$table{$xxxEntry}}) {
        my $val = ();
        #
        # our mib2c template adds '$' in fron of the reference
        # string (jref), which in this case we don't want
        $oidmap{$oid_ref}->{jref} =~ s/^\$+//;
        if ( $oidmap{$oid_ref}->{jref} =~ /\bname\b/i ) {
          #
          # {name} is a special case, it's replaced with the
          # value of the actual indices member we are working
          # on ($ind) 
          $val = $ind;
        } else {
          $val = $oidmap{$xxxEntry}->{jref} . '->{' . $ind . '}->' . $oidmap{$oid_ref}->{jref};
          printf STDERR "DEBUG: %s - %04d: table element mapping '%s'\n", __PACKAGE__, __LINE__, $val if ( $self->{debug} >= 2 );
          $val = eval($val);
        }
        printf STDERR "DEBUG: %s - %04d: %s = %s\n", __PACKAGE__, __LINE__, $oidmap{$oid_ref}->{oid} . "." . $index, $val if ( $self->{debug} >= 2 );
        $self->{es_data}->{$oidmap{$oid_ref}->{oid} . "." . $index}->{val} = $val;
        $self->{es_data}->{$oidmap{$oid_ref}->{oid} . "." . $index}->{type} = $oidmap{$oid_ref}->{type};
      }
    }
  }
  
  @{$self->{oids}} = sort { new NetSNMP::OID($a) <=> new NetSNMP::OID($b) } (keys %{$self->{es_data}});

  return(1);
}

sub load {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: load(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );

  # Get information from elasticsearch via REST interface
  $cluster_health = decode_json($self->_get_json("cluster_health"));
  $cluster_state = decode_json($self->_get_json("cluster_state"));
  $cluster_stats = decode_json($self->_get_json("cluster_stats"));
  $nodes_stats = decode_json($self->_get_json("nodes_stats"));

  $self->{last_load} = time();
}

sub oid {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: oid(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid = shift;
  
  return() unless ( defined(wantarray) );
  return(@{$self->{oids}}) if ( wantarray() );
  return(1) if ( $oid && grep(/^$oid$/, @{$self->{oids}}) );

  return();
}

sub val ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: val(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $noid = shift;
  my $val = ();

  $val = $self->{es_data}->{$noid}->{val} if ( defined($self->{es_data}->{$noid}->{val}) );

  return($val);
}

sub type ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: type(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $noid = shift;
  my $type = ();

  $type = $self->{es_data}->{$noid}->{type} if ( defined($self->{es_data}->{$noid}->{type}) );
    
  return($type);
}

sub expired {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: expired(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );

  return(((time() - $self->{refresh_timer}) > $self->{last_load} ? 1 : 0));
}

sub _calculate ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: _calculate(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid = shift;
  my($elapsed,$last,$current) = ();
  # without this eval doesn't find the variable
  $cluster_health = $cluster_health;
  $cluster_state = $cluster_state;
  $cluster_stats = $cluster_stats;
  $nodes_stats = $nodes_stats;
  $node_stats = $node_stats;

  # This should do a deep copy of the whole hash of hashes.
  %{$last_cluster_health} = %{$cluster_health} unless ( %{$last_cluster_health} );
  %{$last_cluster_state} = %{$cluster_state} unless ( %{$last_cluster_state} );
  %{$last_cluster_stats} = %{$cluster_stats} unless ( %{$last_cluster_stats} );
  %{$last_nodes_stats} = %{$nodes_stats} unless ( %{$last_nodes_stats} );
  %{$last_node_stats} = %{$node_stats} unless ( %{$last_node_stats} );

  # elapsed time in seconds, sys time is returned in millies
  $elapsed = ($node_stats->{process}->{timestamp} - 
             $last_node_stats->{process}->{timestamp}) / 1000;
  $elapsed = 1 if ( $elapsed < 1 );
  $last = $oidmap{$oid}->{jref};
  $last =~ s/^\$/\$last_/;
  my $tmp = $last;
  $last = eval($last);
  $current = eval($oidmap{$oid}->{jref});
  
  return(($current - $last) / $elapsed * $self->{calc_steps});
}

sub _get_oid ($$) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: _get_oid(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $oid_str = shift;
  my $oid_num = shift;
  my $val = ();
  # without this eval doesn't find the variable
  $cluster_health = $cluster_health;
  $cluster_state = $cluster_state;
  $cluster_stats = $cluster_stats;
  $nodes_stats = $nodes_stats;
  $node_stats = $node_stats;

  no strict qw(refs vars);
  for (my $i = 0;  $i <= $#_; $i++) {
    $$_[$i++] = ($_[$i] ? $_[$i] : "n/a");
  }

  $val = ($oid_str =~ /Del$/ ? 
          $self->_calculate($oid_str) :
          eval($oidmap{$oid_str}->{jref}));
  $val = $statusnr{$val} if ( defined($statusnr{$val}) );
  $self->{es_data}->{$oid_num}->{val} = $val;
  $self->{es_data}->{$oid_num}->{type} = $oidmap{$oid_str}->{type};

  return(1);
}

sub _get_json ($) {
  my $self = (ref($_[0]) eq __PACKAGE__ ? shift() : "");
  printf STDERR "DEBUG: %s - %04d: _get_json(%s)\n", __PACKAGE__, __LINE__, join(", ", @_) if ( $self->{debug} >= 5 );
  my $url = shift;
  my($uri, $json) = ();

  $uri = URI->new($self->{url}->{$url});
  $uri->host($self->{url}->{host}) if ( defined($self->{url}->{host}) );
  $uri->port($self->{url}->{port}) if ( defined($self->{url}->{port}) );

  printf STDERR "DEBUG: %s - %04d: reloading $uri\n", __PACKAGE__, __LINE__ if ( $self->{debug} );
  $json = get($uri) or die "$!";

  return($json);
}

1;

__END__

ASN_BOOLEAN = 1
ASN_INTEGER = 2
ASN_BIT_STR = 3
ASN_OCTET_STR = 4
ASN_NULL = 5
ASN_OBJECT_ID = 6
ASN_SEQUENCE = 16
ASN_SET = 17
ASN_APPLICATION = 64
ASN_IPADDRESS = 64
ASN_COUNTER = 65
ASN_GAUGE = 66
ASN_UNSIGNED = 66
ASN_TIMETICKS = 67
ASN_OPAQUE = 68
ASN_COUNTER64 = 70
ASN_FLOAT = 72
ASN_DOUBLE = 73
ASN_INTEGER64 = 74
ASN_UNSIGNED64 = 75

