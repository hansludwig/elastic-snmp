use JSON::XS;
use LWP::Simple;

our $state_ref = ();
our $node_ref = ();

# Skeleton accessor functions.
# DO NOT EDIT 
# This file will be overwritten next time mib2c is run.
# Copy this file to functions.pl and then edit it.
# -------------------------------------------------------
# Loader for table zalEsStateTable
# Edit this function to load the data needed for zalEsStateTable
# This function gets called for every request to columnar
# data in the zalEsStateTable table
# -------------------------------------------------------
sub load_zalEsStateTable { 
  my $url = "http://tdl-1901:9200/_cluster/health";

  $state_ref = decode_json(get($url));

  return($state_ref);
}  
# -------------------------------------------------------
# Index validation for table zalEsStateTable
# Checks the supplied OID is in range
# Returns 1 if it is and 0 if out of range
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub check_zalEsStateTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Check the index is in range and valid
  return 1;
}

# -------------------------------------------------------
# Index walker for table zalEsStateTable
# Given an OID for a table, returns the next OID in range, 
# or if no more OIDs it returns 0.
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub next_zalEsStateTable {
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);
  printf "next_zalEsStateTable oid %s, idx_zalEsStateIndex %s\n", $oid, $idx_zalEsStateIndex;

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsClusterName' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.2
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsClusterName { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return "$data_ref->{cluster_name}";
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMaster' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.3
# Syntax: ASN_OCTET_STR
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsMaster { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  # TODO
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsStatus' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.4
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsStatus { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;
  my %status = qw(green 2 yellow 1 red 0);

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($status{lc($data_ref->{status})});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsNrNodes' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.5
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsNrNodes { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return 32; # TODO
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsActive' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.6
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsShardsActive { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($data_ref->{active_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsReloc' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.7
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsShardsReloc { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($data_ref->{relocating_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsInit' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.8
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsShardsInit { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($data_ref->{relocating_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsUnas' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.9
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsShardsUnas { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($data_ref->{unassigned_shards});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsShardsPrim' 
# OID: .1.3.6.1.4.1.43278.10.10.2.1.1.10
# Syntax: ASN_INTEGER
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsStateTable
# Index: zalEsStateIndex
# -------------------------------------------------------
sub get_zalEsShardsPrim { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsStateIndex = getOidElement($oid, 13);

  # Load the zalEsStateTable table data
  load_zalEsStateTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($data_ref->{active_primary_shards});
}

# -------------------------------------------------------
# -------------------------------------------------------
# -------------------------------------------------------

# -------------------------------------------------------
# Loader for table zalEsNodeTable
# Edit this function to load the data needed for zalEsNodeTable
# This function gets called for every request to columnar
# data in the zalEsNodeTable table
# -------------------------------------------------------
sub load_zalEsNodeTable { 
  my $url = "http://tdl-1901:9200/_nodes/_local";
  my $uuid = ();

  $node_ref = decode_json(get($url));
  $uuid = (keys(%{$node_ref->{nodes}}))[0];
  $node_ref = $node_ref->{nodes}->{$uuid};

  return($node_ref);
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

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Return the next OID if there is one
  # or return 0 if no more OIDs in this table
  return 0;
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsNodeName' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.2
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

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($node_ref->{name});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsStoreSize' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.3
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsStoreSize { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($node_ref->{indices}->{store}->{size_in_bytes});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDocs' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.4
# Syntax: ASN_COUNTER64
# From: ZALIO-elasticsearch-MIB
# In Table: zalEsNodeTable
# Index: zalEsNodeIndex
# -------------------------------------------------------
sub get_zalEsDocs { 
  # The OID is passed as a NetSNMP::OID object
  my ($oid) = shift;

  # The values of the oid elements for the indexes
  my $idx_zalEsNodeIndex = getOidElement($oid, 13);

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($node_ref->{indices}->{docs}->{count});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.5
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

  # Load the zalEsNodeTable table data
  load_zalEsNodeTable();

  # Code here to read the required variable from the loaded table
  # using whatever indexing you need.
  # The index has already been checked and found to be valid

  return($node_ref->{indices}->{indexing}->{index_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsIndexTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.6
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

  # TODO
  return($node_ref->{indices}->{indexing}->{index_time_in_millis});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFlushOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.7
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

  return($node_ref->{indices}->{flush}->{total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFlushTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.8
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

  # TODO
  return($node_ref->{indices}->{flush}->{total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsThrottleTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.9
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

  # TODO
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDeleteOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.10
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

  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsDeleteTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.11
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsGetOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.12
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

  return($node_ref->{indices}->{get}->{total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsGetTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.13
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsExistsOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.14
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

  return($node_ref->{indices}->{get}->{exists_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsExistsTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.15
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
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.16
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

  return($node_ref->{indices}->{get}->{missing_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMissingTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.17
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsQueryOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.18
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

  return($node_ref->{indices}->{search}->{query_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsQueryTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.19
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFetchOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.20
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

  return($node_ref->{indices}->{search}->{fetch_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsFetchTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.21
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMergeOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.22
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

  return($node_ref->{indices}->{merges}->{total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsMergeTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.23
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsRefreshOps' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.24
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

  return($node_ref->{indices}->{refresh}->{total});
}
# -------------------------------------------------------
# Handler for columnar object 'zalEsRefreshTime' 
# OID: .1.3.6.1.4.1.43278.10.10.3.1.1.25
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

  # TODO
  return($node_ref->{indices}->{indexing}->{delete_total});
}
__END__
$state = {
  'blocks' => {},
  'version' => 22,
  'allocations' => [],
  'master_node' => 'mhk0kGn-TCyr2ZWwPa35cA',
  'cluster_name' => 'elasticsearch',
  'routing_table' => {
    'indices' => {
      'stats' => {
        'shards' => {
          '1' => [
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 1,
              'primary' => bless( do{\(my $o = 1)}, 'JSON::XS::Boolean' ),
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 1,
              'primary' => bless( do{\(my $o = 0)}, 'JSON::XS::Boolean' ),
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '4' => [
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 4,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 4,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '3' => [
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 3,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 3,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '0' => [
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 0,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 0,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '2' => [
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 2,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'stats',
              'shard' => 2,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ]
        }
      },
      'products' => {
        'shards' => {
          '1' => [
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 1,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 1,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '4' => [
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 4,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 4,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '3' => [
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 3,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 3,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '0' => [
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 0,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 0,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ],
          '2' => [
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 2,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
              'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
              'state' => 'STARTED'
            },
            {
              'relocating_node' => undef,
              'index' => 'products',
              'shard' => 2,
              'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
              'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
              'state' => 'STARTED'
            }
          ]
        }
      }
    }
  },
  'routing_nodes' => {
    'unassigned' => [],
    'nodes' => {
      'mhk0kGn-TCyr2ZWwPa35cA' => [
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 4,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 0,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 3,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 1,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 2,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 4,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 0,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 3,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 1,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 2,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
          'node' => 'mhk0kGn-TCyr2ZWwPa35cA',
          'state' => 'STARTED'
        }
      ],
      'JGms_S3ARPuWKwXqwvIeCQ' => [
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 4,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 0,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 3,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 1,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'stats',
          'shard' => 2,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 4,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 0,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 3,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 1,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        },
        {
          'relocating_node' => undef,
          'index' => 'products',
          'shard' => 2,
          'primary' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
          'node' => 'JGms_S3ARPuWKwXqwvIeCQ',
          'state' => 'STARTED'
        }
      ]
    }
  },
  'nodes' => {
    'mhk0kGn-TCyr2ZWwPa35cA' => {
      'transport_address' => 'inet[/172.30.129.130:9300]',
      'name' => 'Roughhouse',
      'attributes' => {}
    },
    'JGms_S3ARPuWKwXqwvIeCQ' => {
      'transport_address' => 'inet[/172.30.129.129:9300]',
      'name' => 'Super Rabbit',
      'attributes' => {}
    }
  },
  'metadata' => {
    'indices' => {
      'stats' => {
        'mappings' => {
          'query' => {
            '_source' => {
              'compress' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
            },
            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
            'properties' => {
              'geo' => {
                'type' => 'geo_point'
              },
              'src' => {
                'type' => 'ip',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'ts' => {
                'format' => 'dateOptionalTime',
                'type' => 'date',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'locale' => {
                'index' => 'not_analyzed',
                'type' => 'string',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'duration' => {
                'type' => 'long',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'uuid' => {
                'index' => 'not_analyzed',
                'type' => 'string',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'term' => {
                'index' => 'not_analyzed',
                'type' => 'string',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'sort' => {
                'index' => 'not_analyzed',
                'type' => 'string',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'timestamp' => {
                'format' => 'dateOptionalTime',
                'type' => 'date',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'limit' => {
                'type' => 'long',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'start' => {
                'type' => 'long',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              }
            }
          }
        },
        'aliases' => [],
        'settings' => {
          'index' => {
            'number_of_replicas' => '1',
            'version' => {
              'created' => '900399'
            },
            'number_of_shards' => '5'
          }
        },
        'state' => 'open'
      },
      'products' => {
        'mappings' => {
          'location' => {
            '_source' => {
              'compress' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
            },
            'properties' => {
              'parent' => {
                'index' => 'not_analyzed',
                'type' => 'string'
              },
              'coordinates' => {
                'type' => 'geo_point'
              },
              'name' => {
                'index' => 'no',
                'type' => 'string'
              },
              'openingHours' => {
                'properties' => {
                  'closed' => {
                    'properties' => {
                      'weekly' => {
                        'type' => 'long'
                      },
                      'range' => {
                        'properties' => {
                          'to' => {
                            'type' => 'long'
                          },
                          'from' => {
                            'type' => 'long'
                          }
                        }
                      }
                    }
                  },
                  'open' => {
                    'properties' => {
                      'weekly' => {
                        'type' => 'long'
                      },
                      'range' => {
                        'properties' => {
                          'to' => {
                            'type' => 'long'
                          },
                          'from' => {
                            'type' => 'long'
                          }
                        }
                      },
                      'always' => {
                        'type' => 'boolean'
                      }
                    }
                  }
                }
              },
              'phone' => {
                'index' => 'no',
                'type' => 'string'
              },
              'paymentMethods' => {
                'properties' => {
                  'method' => {
                    'index' => 'not_analyzed',
                    'type' => 'string'
                  }
                }
              },
              'sources' => {
                'properties' => {
                  'source' => {
                    'type' => 'string'
                  }
                }
              },
              'url' => {
                'index' => 'no',
                'type' => 'string'
              },
              'address' => {
                'index' => 'no',
                'type' => 'string'
              }
            }
          },
          'ad' => {
            '_source' => {
              'compress' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
            },
            '_id' => {
              'path' => 'id.uuid'
            },
            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
            'properties' => {
              'sources' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'source' => {
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              },
              'frontPage' => {
                'type' => 'boolean'
              },
              'timestamp' => {
                'index' => 'no',
                'type' => 'long',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
              },
              'dimension' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'width' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'maxWidth' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'minHeight' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'maxHeight' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'minWidth' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'height' => {
                    'type' => 'long',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              },
              'type' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'format' => {
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'minVersion' => {
                    'type' => 'double',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              },
              'data' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'zip' => {
                    'index' => 'no',
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  },
                  'url' => {
                    'index' => 'no',
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              },
              'id' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'uuid' => {
                    'index' => 'not_analyzed',
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              }
            }
          },
          'item' => {
            '_source' => {
              'compress' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
            },
            '_id' => {
              'path' => 'id.uuid'
            },
            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
            'properties' => {
              'images' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'image' => {
                    'type' => 'nested',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      '$' => {
                        'index' => 'no',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      },
                      '@lang' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      }
                    }
                  }
                }
              },
              'locations' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'refs' => {
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      'ref' => {
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                        'properties' => {
                          'active' => {
                            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                            'properties' => {
                              'weekly' => {
                                'type' => 'long',
                                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                              },
                              'range' => {
                                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                                'properties' => {
                                  'to' => {
                                    'type' => 'long',
                                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                                  },
                                  'from' => {
                                    'type' => 'long',
                                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                                  }
                                }
                              },
                              'always' => {
                                'type' => 'boolean'
                              }
                            }
                          },
                          'name' => {
                            'index' => 'no',
                            'type' => 'string',
                            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                          },
                          'price' => {
                            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                            'properties' => {
                              'currency' => {
                                'index' => 'no',
                                'type' => 'string',
                                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                              },
                              'price' => {
                                'type' => 'double',
                                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                              },
                              'unitprice' => {
                                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                                'properties' => {
                                  'unit' => {
                                    'index' => 'no',
                                    'type' => 'string',
                                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                                  },
                                  'unitprice' => {
                                    'type' => 'double',
                                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                                  }
                                }
                              }
                            }
                          },
                          'uuid' => {
                            'index' => 'no',
                            'type' => 'string',
                            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                          },
                          'stock' => {
                            'type' => 'long',
                            'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                          }
                        }
                      }
                    }
                  }
                }
              },
              'names' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'name' => {
                    'type' => 'nested',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                    'properties' => {
                      'shortname' => {
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      },
                      'longname' => {
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      },
                      'brand' => {
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      },
                      '@lang' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      },
                      'line' => {
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      }
                    }
                  }
                }
              },
              'tags' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                'properties' => {
                  'tag' => {
                    'type' => 'nested',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                    'properties' => {
                      '@lang' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      }
                    }
                  }
                }
              },
              'sources' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'source' => {
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                  }
                }
              },
              'timestamp' => {
                'type' => 'long',
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
              },
              'infos' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'info' => {
                    'type' => 'nested',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      '$' => {
                        'index' => 'no',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      },
                      '@lang' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      }
                    }
                  }
                }
              },
              'ratings' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'eco' => {
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      'rating' => {
                        'type' => 'double',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      }
                    }
                  },
                  'user' => {
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      'count' => {
                        'index' => 'no',
                        'type' => 'long',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      },
                      'rating' => {
                        'type' => 'double',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      }
                    }
                  }
                }
              },
              'id' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'eans' => {
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'},
                    'properties' => {
                      'ean' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      }
                    }
                  },
                  'uuid' => {
                    'index' => 'no',
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                  }
                }
              },
              'links' => {
                'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                'properties' => {
                  'link' => {
                    'type' => 'nested',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'},
                    'properties' => {
                      'url' => {
                        'index' => 'no',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      },
                      'name' => {
                        'index' => 'no',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      },
                      '@lang' => {
                        'index' => 'not_analyzed',
                        'type' => 'string',
                        'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[1]{'primary'}
                      }
                    }
                  }
                }
              }
            }
          },
          'rating' => {
            '_source' => {
              'compress' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
            },
            '_id' => {
              'path' => 'id.uuid'
            },
            'properties' => {
              'parent' => {
                'index' => 'not_analyzed',
                'type' => 'string'
              },
              'date' => {
                'format' => 'dateOptionalTime',
                'type' => 'date'
              },
              'rating' => {
                'index' => 'no',
                'type' => 'double'
              },
              'sources' => {
                'properties' => {
                  'source' => {
                    'type' => 'string'
                  }
                }
              },
              'timestamp' => {
                'index' => 'no',
                'type' => 'long'
              },
              'comment' => {
                'index' => 'no',
                'type' => 'string'
              },
              'user' => {
                'index' => 'no',
                'type' => 'string'
              },
              'id' => {
                'properties' => {
                  'uuid' => {
                    'index' => 'not_analyzed',
                    'type' => 'string',
                    'include_in_all' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                  }
                }
              }
            }
          }
        },
        'aliases' => [],
        'settings' => {
          'index' => {
            'number_of_replicas' => '1',
            'version' => {
              'created' => '900999'
            },
            'number_of_shards' => '5',
            'uuid' => 'DLsFsB-7Qq6fgsUDggdH2Q'
          }
        },
        'state' => 'open'
      }
    },
    'templates' => {
      'marvel' => {
        'template' => '.marvel*',
        'mappings' => {
          '_default_' => {
            'dynamic_templates' => [
              {
                'string_fields' => {
                  'match_mapping_type' => 'string',
                  'mapping' => {
                    'fields' => {
                      '{name}' => {
                        'index' => 'analyzed',
                        'type' => 'string',
                        'omit_norms' => $state->{'routing_table'}{'indices'}{'stats'}{'shards'}{'1'}[0]{'primary'}
                      },
                      'raw' => {
                        'ignore_above' => 256,
                        'index' => 'not_analyzed',
                        'type' => 'string'
                      }
                    },
                    'type' => 'multi_field'
                  },
                  'match' => '*'
                }
              }
            ]
          },
          'index_stats' => {
            'properties' => {
              'total' => {
                'properties' => {
                  'percolate' => {
                    'properties' => {
                      'time_in_millis' => {
                        'type' => 'long'
                      },
                      'queries' => {
                        'type' => 'long'
                      },
                      'memory_size_in_bytes' => {
                        'type' => 'long'
                      },
                      'total' => {
                        'type' => 'long'
                      }
                    }
                  }
                }
              }
            }
          },
          'node_stats' => {
            'properties' => {
              'indices' => {
                'properties' => {
                  'percolate' => {
                    'properties' => {
                      'time_in_millis' => {
                        'type' => 'long'
                      },
                      'queries' => {
                        'type' => 'long'
                      },
                      'memory_size_in_bytes' => {
                        'type' => 'long'
                      },
                      'total' => {
                        'type' => 'long'
                      }
                    }
                  }
                }
              },
              'jvm' => {
                'properties' => {
                  'buffer_pools' => {
                    'properties' => {
                      'direct' => {
                        'properties' => {
                          'used_in_bytes' => {
                            'type' => 'long'
                          }
                        }
                      },
                      'mapped' => {
                        'properties' => {
                          'used_in_bytes' => {
                            'type' => 'long'
                          }
                        }
                      }
                    }
                  },
                  'gc' => {
                    'properties' => {
                      'collectors' => {
                        'properties' => {
                          'young' => {
                            'properties' => {
                              'collection_time_in_millis' => {
                                'type' => 'long'
                              },
                              'collection_count' => {
                                'type' => 'long'
                              }
                            }
                          },
                          'old' => {
                            'properties' => {
                              'collection_time_in_millis' => {
                                'type' => 'long'
                              },
                              'collection_count' => {
                                'type' => 'long'
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              },
              'fs' => {
                'properties' => {
                  'total' => {
                    'properties' => {
                      'disk_io_op' => {
                        'type' => 'long'
                      },
                      'disk_reads' => {
                        'type' => 'long'
                      },
                      'disk_io_size_in_bytes' => {
                        'type' => 'long'
                      },
                      'disk_writes' => {
                        'type' => 'long'
                      },
                      'disk_write_size_in_bytes' => {
                        'type' => 'long'
                      },
                      'disk_read_size_in_bytes' => {
                        'type' => 'long'
                      }
                    }
                  }
                }
              },
              'os' => {
                'properties' => {
                  'load_average' => {
                    'properties' => {
                      '15m' => {
                        'type' => 'float'
                      },
                      '1m' => {
                        'type' => 'float'
                      },
                      '5m' => {
                        'type' => 'float'
                      }
                    }
                  }
                }
              }
            }
          }
        },
        'order' => 0,
        'settings' => {
          'index' => {
            'number_of_replicas' => '1',
            'mapper' => {
              'dynamic' => 'true'
            },
            'marvel' => {
              'index_format' => '1'
            },
            'number_of_shards' => '1',
            'analysis' => {
              'analyzer' => {
                'default' => {
                  'stopwords' => '_none_',
                  'type' => 'standard'
                }
              }
            }
          }
        }
      }
    }
  }
};
