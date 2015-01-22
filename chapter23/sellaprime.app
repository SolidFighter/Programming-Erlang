%% This is the application resource file (.app file) for the 'base'
%% application.
{application, sellaprime, 
 [{description, "The Prime Number Shop"},
  {vsn, "1.0"},
  {modules, [sellaprime_app, sellaprime_supervisor, area_server, 
	     prime_server, lib_lin, lib_primes, my_alarm_handler, prime_test_server]},	
  {registered,[area_server, prime_server, prime_test_server,sellaprime_super]},
  {applications, [kernel,stdlib]},
  {mod, {sellaprime_app,[]}},
  {start_phases, []}
 ]}.
