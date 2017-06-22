procedure t is
  type cookie_string is new string;
  type session_string is new string;
  with separate "sessions.sp";

  session_test : session_string := "foobar";
  pragma import( session, session_test );
  pragma export( session, session_test );
begin
  kludge_session := "";
  null;
end t;

-- VIM editor formatting instructions
-- vim: ft=spar

