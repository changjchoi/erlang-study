% http://erlang.org/doc/man/app.html
{
  application, usr, 
  [
    {description, "Mobile serice Database"},
    {vsn, "1.0"},
    % systols use this list 'modules'
    {modules, [usr, usr_db, usr_sup, usr_app]},
    % systools uses this list to detect name clashes
    {registered, [usr, usr_sup]},
    % All applications which must be started before this application is allowed
      % to be started.
    {applications, [kernel, stdlib]},
    % Configuration parameters used by the application.
    {env, [{dets_name, "usrDb"}]},
    % Specifies the application callback module and a start argument
    {mod, {usr_app, []}}
  ]
}.

