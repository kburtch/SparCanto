separate;

type session_string is new string;

-----------------------------------------------------------------------------
-- Session Cookies
-----------------------------------------------------------------------------

session_token : cookie_string;


-----------------------------------------------------------------------------
-- Session Memacache
-----------------------------------------------------------------------------

session_openned : boolean := false;

mc_session : memcache.memcache_cluster;
--session_file : btree_io.file;
--session_path : constant string := "/home/ken/cms/session.btree";
session_max_key_length : constant positive := 80;
session_max_content_length : constant positive := 2048;

-- Session import/export functions
--
-- TODO: these are not complete
-- TODO: kludge variable should be handled better...
-- TODO: session duration not implemented
-- Note: kludge_session is not "written to" only because it is referred to
--       in the backquoted subscript which is not compiled if it is not run
--       it is only checked at syntax checking time.
kludge_session : session_string;


-- SESSION_OPEN
--
-- Create a new session token (if necessary) and open the session cache.
-- Store the session token in a cookie.  This is called by the session import
-- handler.  It assumes the session has not yet been openned.
------------------------------------------------------------------------------

procedure session_open is
  s : string;
begin

  -- Get the session token (or create a new one)

  if session_token = "" then
     if cgi.cookie_count > 0 then
        session_token := cookie_string( cgi.cookie_value( "canto_session_token", 1 ) );
     end if;
  end if;
  if session_token = "" then
       session_token := cookie_string( numerics.sha224_digest_of( strings.image( numerics.rnd( 100000000 ) ) ) );
       cgi.set_cookie( "canto_session_token", string( session_token ) );
  end if;

  -- Open the session cache where session data is stored.
  --
  -- Since this is run automatically, I chose not to raise a config error
  -- here...not sure when the exception would be triggered.

  mc_session := memcache.new_cluster;
  memcache.register_server( mc_session, "localhost", 11211 );
  s := memcache.version( mc_session );
  session_openned := s /= "";
end session_open;


-- CANTO SESSION GET
--
-- Get a value from the user's session.  Opens the session if not already
-- open.  This is the session variable import handler.
------------------------------------------------------------------------------

procedure canto_session_get( key : string; val : in out session_string ) is
  full_key : string;
begin
  if not session_openned then
     session_open;
  end if;
  full_key := string( session_token );
  full_key := @ & "__";
  full_key := @ & string( key );
  val := session_string( memcache.get( mc_session, full_key ) );
end canto_session_get;

pragma session_import_script(
   `kludge_session := session_string( sessions.session_variable_value ); canto_session_get( sessions.session_variable_name, kludge_session );`
);
-- CANTO SESSION SET
--
-- Write a value to the user's session.  This is the session variable export
-- handler.
------------------------------------------------------------------------------

procedure canto_session_set( key : string; val : session_string ) is
  full_key : string;

begin
  if not session_openned then
     session_open;
  end if;
   if key = "" then
      put_line( standard_error, source_info.source_location & ": key '" & key & "' is empty" );
      return;
   end if;
   full_key := string( session_token );
   full_key := @ & "__";
   full_key := @ & string( key );
   if strings.length( full_key ) > session_max_key_length then
      put_line( standard_error, source_info.source_location & ": key '" & full_key & "' is too long" );
      return;
   elsif not memcache.is_valid_memcache_key( full_key ) then
      put_line( standard_error, source_info.source_location & ": key '" & full_key & "' has invalid characters" );
      return;
   end if;
   begin
     memcache.set( mc_session, full_key, string( val ) );
   exception when others =>
     put_line( standard_error, exceptions.exception_info );
   end;
end canto_session_set;

pragma session_export_script(
   `kludge_session := session_string( sessions.session_variable_value ); canto_session_set( sessions.session_variable_name, kludge_session );`
);

-- VIM editor formatting instructions
-- vim: ft=spar

