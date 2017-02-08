separate;

  -- Define standard CGI server variables.

  type server_string is new string;

  CONTEXT_DOCUMENT_ROOT : constant server_string := "";
  pragma import( shell, CONTEXT_DOCUMENT_ROOT );

  CONTEXT_PREFIX : constant server_string := "";
  pragma import( shell, CONTEXT_PREFIX );

  DOCUMENT_ROOT : constant server_string := "";
  pragma import( shell, DOCUMENT_ROOT );

  GATEWAY_INTERFACE : constant server_string := "";
  pragma import( shell, GATEWAY_INTERFACE );

  HTTP_ACCEPT : constant server_string := "";
  pragma import( shell, HTTP_ACCEPT );

  HTTP_ACCEPT_ENCODING : constant server_string := "";
  pragma import( shell, HTTP_ACCEPT_ENCODING );

  HTTP_ACCEPT_LANGUAGE : constant server_string := "";
  pragma import( shell, HTTP_ACCEPT_LANGUAGE );

  HTTP_CONNECTION : constant server_string := "";
  pragma import( shell, HTTP_CONNECTION );

  HTTP_COOKIE : constant server_string := "";
  pragma import( shell, HTTP_COOKIE );

  HTTP_HOST : constant server_string := "";
  pragma import( shell, HTTP_HOST );

  HTTP_UPGRADE_INSECURE_REQUESTS : constant server_string := "";
  pragma unchecked_import( shell, HTTP_UPGRADE_INSECURE_REQUESTS );

  HTTP_USER_AGENT : constant server_string := "";
  pragma import( shell, HTTP_USER_AGENT );

  QUERY_STRING : constant server_string := "";
  pragma import( shell, QUERY_STRING );

  REMOTE_ADDR : constant server_string := "";
  pragma import( shell, REMOTE_ADDR );

  REMOTE_PORT : constant server_string := "";
  pragma import( shell, REMOTE_PORT );

  REQUEST_SCHEME : constant server_string := "";
  pragma import( shell, REQUEST_SCHEME );

  REQUEST_METHOD : constant server_string := "";
  pragma import( shell, REQUEST_METHOD );

  REQUEST_URI : constant server_string := "";
  pragma import( shell, REQUEST_URI );

  SERVER_ADDR : constant server_string := "";
  pragma import( shell, SERVER_ADDR );

  SERVER_ADMIN : constant server_string := "";
  pragma import( shell, SERVER_ADMIN );

  SCRIPT_FILENAME : constant server_string := "";
  pragma import( shell, SCRIPT_FILENAME );

  SCRIPT_NAME : constant server_string := "";
  pragma import( shell, SCRIPT_NAME );

  SERVER_PORT : constant server_string := "";
  pragma import( shell, SERVER_PORT );

  SERVER_PROTOCOL : constant server_string := "";
  pragma import( shell, SERVER_PROTOCOL );

  SERVER_SIGNATURE : constant server_string := "";
  pragma import( shell, SERVER_SIGNATURE );

  SERVER_SOFTWARE : constant server_string := "";
  pragma import( shell, SERVER_SOFTWARE );

-- VIM editor formatting instructions
-- vim: ft=spar

