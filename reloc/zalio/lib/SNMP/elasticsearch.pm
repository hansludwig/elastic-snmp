use LWP::Simple;
use JSON::XS;

do "elasticsearch-snmp.conf";

my $_clusterTable = {};
my $_nodeTable = {};
my $_indicesTable = {};
my $_time = ();

printf STDERR "DEBUG: %s, %d: \$RealBin %s\n", __FILE__, __LINE__, $RealBin if ( $debug );

# -------------------------------------------------------
# Loader for table zalEsClusterTable
# Edit this function to load the data needed for zalEsClusterTable
# This function gets called for every request to columnar
# data in the zalEsClusterTable table
# -------------------------------------------------------
sub load_zalEsClusterTable { 
  my $uri = shift || $conf{url}->{cluster_table};
  my $ref = shift || $_clusterTable;

  return() if ( $_time && $_time + $conf{reload_timer} < time() );

  $uri = URI->new($uri);
  $uri->host($conf{url}->{host}) if ( defined($conf{url}->{host}) );
  $uri->port($conf{url}->{port}) if ( defined($conf{url}->{port}) );

  printf STDERR "DEBUG: reload $uri\n" if ( $debug );
  $_time = time();
  $ref = decode_json(get($uri));

  # ZalEsClusterEntry ::= SEQUENCE {
  #     zalEsClusterIndex                  Integer32,     n/a
  #     zalEsStatus                        EsStatusTC,    _cluster/health
  #     zalEsClusterName                   DisplayString, _cluster/health
  #     zalEsMaster                        DisplayString, "n/a"
  #     zalEsNrNodes                       Integer32,     _cluster/health
  #     zalEsDocsCount                     Gauge32,       _nodes/stats
  #     zalEsDocsDel                       Gauge32,       _nodes/stats
  #     zalEsStoreSize                     Gauge32,       _nodes/stats
  #     zalEsStoreThr                      Gauge32        _nodes/stats
  # }

  return($ref);  
}  
# -------------------------------------------------------
# Index validation for table zalEsClusterTable
# Checks the supplied OID is in range
# Returns 1 if it is and 0 if out of range
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub check_zalEsClusterTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Check the index is in range and valid
  return 1;
}

# -------------------------------------------------------
# Index walker for table zalEsClusterTable
# Given an OID for a table, returns the next OID in range, 
# or if no more OIDs it returns 0.
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub next_zalEsClusterTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.2
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($conf{statusnr}->{lc($_clusterTable->{status})});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsClusterName' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.3
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsClusterName { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  printf STDERR "DEBUG: %s: \$oid %s

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_clusterTable->{cluster_name});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMaster' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.4
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsMaster { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return("foobar");
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsNrNodes' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.5
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsNrNodes { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_clusterTable->{number_of_nodes});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDocsCount' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.6
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsDocsCount { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{indices}->{docs}->{count});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDocsDel' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.7
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsDocsDel { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{indices}->{docs}->{deleted});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsStoreSize' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.8
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsStoreSize { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{indices}->{store}->{size_in_bytes});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsStoreThr' 
# OID: .1.3.6.1.4.1.43278.10.10.1.1.1.9
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsClusterTable
# Index: zalEsClusterIndex
# -------------------------------------------------------
sub get_zalEsStoreThr { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );

  # Load the zalEsClusterTable table data
  load_zalEsClusterTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{indices}->{store}->{throttle_time_in_millis});
}
# -------------------------------------------------------
# Loader for table zalEsIndicesTable
# Edit this function to load the data needed for zalEsIndicesTable
# This function gets called for every request to columnar
# data in the zalEsIndicesTable table
# -------------------------------------------------------
sub load_zalEsIndicesTable { 
  $_indicesTable = $_indicesTable->{indices} if
    load_zalEsClusterTable($conf{url}->{index_table}, $_indicesTable);
}  
# -------------------------------------------------------
# Index validation for table zalEsIndicesTable
# Checks the supplied OID is in range
# Returns 1 if it is and 0 if out of range
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub check_zalEsIndicesTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Check the index is in range and valid
  return 1;
}

# -------------------------------------------------------
# Index walker for table zalEsIndicesTable
# Given an OID for a table, returns the next OID in range, 
# or if no more OIDs it returns 0.
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub next_zalEsIndicesTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.2
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsIndexStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: how to bind status to 'index'? (stats and products in our case)
  return($conf{statusnr}->{lc($_indicesTable->{stats}->{status})});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexName' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.3
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsIndexName { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO:
  return "stats";
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.4
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  my $status = $conf{statusnr}->{green};
  foreach my $s (keys(%{$_indicesTable->{stats}->{shards}}) {
    my $s = $conf{statusnr}->{lc($_indicesTable->{stats}->{shards}->{$s}->{status})};
    $status = $s if ( $s > $status ); # This keeps the worst case, red above
                                      # yellow and yellow above green
  }

  # TODO: how to bind status to 'index'? (stats and products in our case)
  return($conf{statusnr}->{lc($status)});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsActive' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.5
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsActive { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: 
  return($_indicesTable->{stats}->{active_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsReloc' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.6
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsReloc { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: 
  return($_indicesTable->{stats}->{relocating_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsInit' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.7
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsInit { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: 
  return($_indicesTable->{stats}->{initializing_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsUnas' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.8
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsUnas { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: 
  return($_indicesTable->{stats}->{initializing_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsPrim' 
# OID: .1.3.6.1.4.1.43278.10.10.1.2.1.9
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsIndicesTable
# Index: zalEsClusterIndex
# Index: zalEsIndicesIndex
# -------------------------------------------------------
sub get_zalEsShardsPrim { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsClusterIndex = getOidElement($oid, 13);
  my $idx_zalEsIndicesIndex = getOidElement($oid, 14);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsClusterIndex if ( $debug );
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsIndicesIndex if ( $debug );

  # Load the zalEsIndicesTable table data
  load_zalEsIndicesTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO: 
  return($_indicesTable->{stats}->{active_primary_shards});
}
# -------------------------------------------------------
# Loader for table zalEsNodeTable
# Edit this function to load the data needed for zalEsNodeTable
# This function gets called for every request to columnar
# data in the zalEsNodeTable table
# -------------------------------------------------------
sub load_zalEsNodeTable { 
  $_nodeTable = $_nodeTable->{nodes}->{(keys(%{$_nodeTable->{nodes}}))[0]} if
    load_zalEsClusterTable($conf{url}->{node_table}, $_nodeTable);
}  
# -------------------------------------------------------
# Index validation for table zalEsNodeTable
# Checks the supplied OID is in range
# Returns 1 if it is and 0 if out of range
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub check_zalEsNodeTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsNodeIndex if ( $debug );

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Check the index is in range and valid
  return 1;
}

# -------------------------------------------------------
# Index walker for table zalEsNodeTable
# Given an OID for a table, returns the next OID in range, 
# or if no more OIDs it returns 0.
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub next_zalEsNodeTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsNodeIndex if ( $debug );

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsNodeName' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.2
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsNodeName { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsNodeIndex if ( $debug );

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{name});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.5
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsIndexOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);
  printf STDERR "DEBUG: %s: oid %s, index %s\n", __SUB__, $oid, $idx_zalEsNodeIndex if ( $debug );

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($_nodeTable->{name});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.6
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsIndexTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFlushOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.7
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsFlushOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFlushTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.8
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsFlushTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsThrottleTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.9
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsThrottleTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDeleteOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.10
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsDeleteOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDeleteTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.11
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsDeleteTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsGetOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.12
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsGetOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsGetTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.13
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsGetTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsExistsOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.14
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsExistsOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsExistsTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.15
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsExistsTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMissingOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.16
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsMissingOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMissingTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.17
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsMissingTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsQueryOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.18
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsQueryOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsQueryTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.19
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsQueryTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFetchOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.20
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsFetchOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFetchTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.21
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsFetchTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMergeOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.22
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsMergeOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMergeTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.23
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsMergeTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}
# -------------------------------------------------------
# Handler for columnar object 'zalEsRefreshOps' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.24
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsRefreshOps { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 64;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsRefreshTime' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.25
# Syntax: ASN_GAUGE
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsRefreshTime { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

}

1;
