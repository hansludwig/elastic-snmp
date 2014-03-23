printf STDERR "%s\n", ref($agent);

sub zalio {
  my  ($handler, $registration_info, $request_info, $requests) = @_;
  printf STDERR "TEMP %02d: '%s', '%s', '%s'\n", __LINE__, $handler, $registration_info, $request_info->getMode();
  for ($request = $requests; $request; $request = $request->next()) {
    printf STDERR "TEMP %02d: '%s'\n", __LINE__, $request->getOID();
    $request->setValue(ASN_INTEGER, 123);
  }
}

$agent->register("zalio", ".1.3.6.1.4.1.43278.10.10.2.1.1.6", \&zalio);

1;
