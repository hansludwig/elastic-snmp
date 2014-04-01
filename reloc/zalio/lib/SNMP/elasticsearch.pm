use LWP::Simple;
use JSON::XS;
use Sys::Hostname;
use vars qw($debug $debugging %conf);

require "elasticsearch-snmp.conf";

my $_health_ref = {};
my $_state_ref = {};
my $_stats_ref = {};
my $_node_ref = {};
my $_indices_ref = {};
my $_time = ();

sub load_json ($$) {
  my $uri = shift;
  my $ref = shift;

  printf STDERR "DEBUG %04d: %d + %d > %d, %d > %d\n", __LINE__, $_time, $conf{reload_timer}, time(), $_time + $conf{reload_timer}, time() if ( $debug );
  return() if ( %{$ref} &&
                $_time && 
                ($_time + $conf{reload_timer}) > time() );

  $uri = URI->new($uri);
  $uri->host($conf{url}->{host}) if ( defined($conf{url}->{host}) );
  $uri->port($conf{url}->{port}) if ( defined($conf{url}->{port}) );

  printf STDERR "DEBUG: reload $uri\n" if ( $debug );
  $ref = decode_json(get($uri));
  $_time = time();

  return($ref);
}

sub load_clusterHealth {
  my $ref = shift;
  my $ret = ();

  printf STDERR "DEBUG: %04d: load_clusterHealth\n", __LINE__ if ( $debug );
  $ret = load_json($conf{url}->{cluster_health}, $_health_ref);
  $_health_ref = $ret if ( $ret );

  # This deals with load_zalEsIndicesTable() which needs parts
  # of '_cluster/health'
  if ( $ref ) {
    %{$ref} = %{$_health_ref};
    return($ref);
  }

  return($_health_ref);
}

sub load_clusterState {
  my $ret = ();

  printf STDERR "DEBUG: %04d: load_clusterState\n", __LINE__ if ( $debug );
  $ret = load_json($conf{url}->{cluster_state}, $_state_ref);
  $_state_ref  = $ret if ( $ret );

  return($_state_ref);
}

sub load_nodeStats {
  my $ret = ();
  my $host = (defined($conf{url}->{host}) && $conf{url}->{host} ? $conf{url}->{host} : hostname());
  $host = (split(/\.+/, $host))[0]; # non fully qualified hostname

  printf STDERR "DEBUG: %04d: load_nodeStats\n", __LINE__ if ( $debug );
  $ret = load_json($conf{url}->{node_stats}, $_stats_ref);
  $_stats_ref  = $ret if ( $ret );
  foreach my $n (keys(%{$_stats_ref->{nodes}})) {
     if ( $_stats_ref->{nodes}->{$n}->{host} eq $host ) {
        $_node_ref = $_stats_ref->{nodes}->{$n};
        $_node_ref->{uuid} = $n;
        break;
     }
  }

  return($_stats_ref);
}

# -------------------------------------------------------
# Loader for table zalEsIndicesTable
# Edit this function to load the data needed for zalEsIndicesTable
# This function gets called for every request to columnar
# data in the zalEsIndicesTable table
# -------------------------------------------------------
sub load_zalEsIndicesTable { 

  load_clusterHealth($_indices_ref);
  $_indices_ref = $_indices_ref->{indices};
  
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, load_zalEsIndicesTable if ( $debug );
  return($_indices_ref);
}  
# -------------------------------------------------------
# Index validation for table zalEsIndicesTable
# Checks the supplied OID is in range
# Returns 1 if it is and 0 if out of range
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub check_zalEsIndicesTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  printf STDERR "DEBUG: %04d: oid %s, index %s\n", __LINE__, $oid, $idx_zalEsIndicesIndex if ( $debug );
  # Check the index is in range and valid
  return 1;
}

# -------------------------------------------------------
# Index walker for table zalEsIndicesTable
# Given an OID for a table, returns the next OID in range, 
# or if no more OIDs it returns 0.
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub next_zalEsIndicesTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  printf STDERR "DEBUG: %04d: oid %s, index %s\n", __LINE__, $oid, $idx_zalEsIndicesIndex if ( $debug );
  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.2
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsIndStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $conf{statusnr}->{lc($_indices_ref->{stats}->{status})};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO: how to bind status to 'index'? (stats and products in our case)
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndName' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.3
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsIndName { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = "stats";
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO: how to bind status to 'index'? (stats and products in our case)
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.4
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %04d: %s, index %s\n", __LINE__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  my $status = $conf{statusnr}->{green};
  # TODO: how to bind status to 'index'? (stats and products in our case)
  foreach my $s (keys(%{$_indices_ref->{stats}->{shards}})) {
    my $s = $conf{statusnr}->{lc($_indices_ref->{stats}->{shards}->{$s}->{status})};
    $status = $s if ( $s > $status ); # This keeps the worst case, red above
                                      # yellow and yellow above green
  }

  $ret = $conf{statusnr}->{lc($status)};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdActive' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.5
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdActive { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{active_shards};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdReloc' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.6
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdReloc { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{relocating_shards};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdInit' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.7
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdInit { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{initializing_shards};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdUnas' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.8
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdUnas { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{unassigned_shards};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdPrim' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.9
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdPrim { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{active_primary_shards};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShrdRepl' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.10
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShrdRepl { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my $ret = ();

  # The values of the oid elements for the indexes
  my $idx_zalEsIndicesIndex = getOidElement($oid, 13);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  $ret = $_indices_ref->{stats}->{number_of_replicas};
  printf STDERR "DEBUG: %04d: %s\n", __LINE__, $ret if ( $debug );
  # TODO:
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsStatus
# OID: .1.3.6.1.4.1.43278.10.10.1.1
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsStatus { 
  my $ret = ();

  load_clusterHealth();
  $ret = $conf{statusnr}->{lc($_health_ref->{status})};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsClusterName
# OID: .1.3.6.1.4.1.43278.10.10.1.2
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsClusterName { 
  my $ret = ();

  load_clusterHealth();
  $ret = $_health_ref->{cluster_name};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsNrNodes
# OID: .1.3.6.1.4.1.43278.10.10.1.3
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsNrNodes { 
  my $ret = ();

  load_clusterHealth();
  $ret = $_health_ref->{number_of_nodes};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsNrDataNodes
# OID: .1.3.6.1.4.1.43278.10.10.1.4
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsNrDataNodes { 
  my $ret = ();

  load_clusterHealth();
  $ret = $_health_ref->{number_of_data_nodes};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsDocsCount
# OID: .1.3.6.1.4.1.43278.10.10.1.5
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsDocsCount { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{docs}->{count};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsDocsDel
# OID: .1.3.6.1.4.1.43278.10.10.1.6
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsDocsDel { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{docs}->{deleted};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsStoreSize
# OID: .1.3.6.1.4.1.43278.10.10.1.7
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsStoreSize { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{store}->{size_in_bytes};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsStoreThr
# OID: .1.3.6.1.4.1.43278.10.10.1.8
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsStoreThr { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{store}->{throttle_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsMaster
# OID: .1.3.6.1.4.1.43278.10.10.1.9
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsMaster { 
  my $ret = ();

  load_clusterState();
  load_nodeStats();
  $ret = $_stats_ref->{nodes}->{$_state_ref->{master_node}}->{host};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  # TODO: should we return true or false here?
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsNodeName
# OID: .1.3.6.1.4.1.43278.10.10.2.2
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsNodeName { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{name};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsIndexOps
# OID: .1.3.6.1.4.1.43278.10.10.2.5
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsIndexOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{indexing}->{index_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsIndexTime
# OID: .1.3.6.1.4.1.43278.10.10.2.6
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsIndexTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{indexing}->{index_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsFlushOps
# OID: .1.3.6.1.4.1.43278.10.10.2.7
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsFlushOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{flush}->{total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsFlushTime
# OID: .1.3.6.1.4.1.43278.10.10.2.8
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsFlushTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{flush}->{total_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsThrottleTime
# OID: .1.3.6.1.4.1.43278.10.10.2.9
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsThrottleTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{store}->{throttle_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsDeleteOps
# OID: .1.3.6.1.4.1.43278.10.10.2.10
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsDeleteOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{indexing}->{delete_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsDeleteTime
# OID: .1.3.6.1.4.1.43278.10.10.2.11
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsDeleteTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{indexing}->{delete_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsGetOps
# OID: .1.3.6.1.4.1.43278.10.10.2.12
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsGetOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsGetTime
# OID: .1.3.6.1.4.1.43278.10.10.2.13
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsGetTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsExistsOps
# OID: .1.3.6.1.4.1.43278.10.10.2.14
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsExistsOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{exists_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsExistsTime
# OID: .1.3.6.1.4.1.43278.10.10.2.15
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsExistsTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{exists_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsMissingOps
# OID: .1.3.6.1.4.1.43278.10.10.2.16
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsMissingOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{missing_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsMissingTime
# OID: .1.3.6.1.4.1.43278.10.10.2.17
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsMissingTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{get}->{missing_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsQueryOps
# OID: .1.3.6.1.4.1.43278.10.10.2.18
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsQueryOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{search}->{query_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsQueryTime
# OID: .1.3.6.1.4.1.43278.10.10.2.19
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsQueryTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{search}->{query_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsFetchOps
# OID: .1.3.6.1.4.1.43278.10.10.2.20
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsFetchOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{search}->{fetch_total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsFetchTime
# OID: .1.3.6.1.4.1.43278.10.10.2.21
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsFetchTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{search}->{fetch_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsMergeOps
# OID: .1.3.6.1.4.1.43278.10.10.2.22
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsMergeOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{merges}->{total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsMergeTime
# OID: .1.3.6.1.4.1.43278.10.10.2.23
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsMergeTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{merges}->{total_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsRefreshOps
# OID: .1.3.6.1.4.1.43278.10.10.2.24
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsRefreshOps { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{refresh}->{total};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}
# -------------------------------------------------------
# Handler for scalar object zalEsRefreshTime
# OID: .1.3.6.1.4.1.43278.10.10.2.25
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# -------------------------------------------------------
sub get_zalEsRefreshTime { 
  my $ret = ();

  load_nodeStats();
  $ret = $_node_ref->{indices}->{refresh}->{total_time_in_millis};
  printf STDERR "DEBUG: %04d: ret %s\n", __LINE__, $ret if ( $debug );
  return($ret);
}

1;
