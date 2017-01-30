separate;
pragma annotate( summary, "SparAdagio" )
              @( description, "A CMS and Web Framework for SparForte." )
              @( description, "Include this library into a SparForte script" )
              @( description, "using 'with include'." )
              @( author, "Ken O. Burtch" );
-- TODO: can't set software model or license twice, but should be able to
-- in an include file..
--pragma software_model( http_framework );
--pragma license( unrestricted );

pragma restriction( no_external_commands );
pragma assert( System.System_Version >= "2.0.1" );

-- Alternative names:
--  MastheadMouse,MarinerMouse,marinamouse,Mainstaymouse,Midshipmouse,
--  MizzenMouse
--  spar berth -- 2 sailing words together no good
--

--  sprightforte -     0 hits - agile, but can people spell it?
--  sparworkaway -     1 hits - too long?
-- *sparlegro   -      2 hits
--  spargunplay -      2 hits
--  sparhorseplay -    2 hits - too long?
--  sparstingray -     2 hits - too long?
--  sparcastaway -     4 hits - too long?
--  sparsprightly -    4 hits - can people spell it? too long?
--  sparbriskly -      4 hits
--  sparricochet -     5 hits - too long?
-- *sparforay   -      6 hits - too similar to sparforte?
--  sparadagio  -      8 hits
--  sparheadway -      8 hits
--  skiffforte  -      8 hits
--  sparinterplay -   21 hits - too long?
--**sparcanto   -     24 hits
--  sparforestay -    34 hits - too long?
--  sparattache -     35 hits
--  spryforte  -      42 hits
--  sparforza   -     45 hits ("forza = very forte" in music)
--  sparsensei  -    237 hits
--  spartouche  -    267 hits, french
-- *sailforte   -    300 similar to salesforce
-- *sparsoar    -    321
--  craftforte  -    800, taken
--  spardolce   -    833
--  spardante   -  1 000
--  sparmarina  -  1 100 hits (spar marine taken)
-- ?swiftforte  -  1 400 hits
--  spartissimo -  3 000, taken
-- *ironforte   -  3 700, taken - medication
--  sureforte   -  4 200
--  sparsmart   -  4 200, boxing sites
-- *fastforte   -  5 000, taken - gym
--  sparfresh   -  5 700, taken, brand name
--  spararia    - 15 000
--  sparwing    - 16,500 - aircraft wing
--  ironspar    - 18 000 - a mineral
--  rockforte   - 18 600, taken
--  litheforte  - 27 000, similar to life forte
--  MarinaArena - 34 000, taken, writer
--  spartly     - 36 000, taken
--  rigging cms = 350 000 hits
--  knotforte   - 800
--  mizzenforte - 52 000 this
--  knot cms    - 450 000 hits
--  stoneforte  - 570 000 hits, too close to stone fort
--  berth cms   = 1.5 million hits
--  marinaforte - 2 million
--  spar cms    = 2 million hits
--  sparfortress = 1.2 million hits, similar to B-29 Superfortress
--  fort cms    = 11 million hits
  --  too many hits on cms (common letters)
--  sparworks - taken
--  fortecms - taken
--  spartempo - taken
--  spargrande - taken
--  sparmezzo -

-----------------------------------------------------------------------------
-- Data Types
--
-----------------------------------------------------------------------------

type html_id      is new string;
--type html_class   is new string;
type html_content is new string;
type raw_content  is new string;
type csrf_token   is new string;
--type session_string is new string;
type session_string is new string;
type cgi_string is new string;

type snippet_id is new string;

type a_snippet is record
   id          : snippet_id;  -- a name to reference it
   description : raw_content; -- human-readable description
   url         : raw_content; -- human-readable description
   head_html   : raw_content; -- the HTML to be added to the HTML head tag
   foot_html   : raw_content; -- the HTML to be added to the HTML head tag
   begin_html  : raw_content; -- the HTML to start the snippet
   end_html    : raw_content; -- the HTML to end the snippet
end record;

-----------------------------------------------------------------------------
-- Global Constants
--
-----------------------------------------------------------------------------

cms_version : constant universal_string := "0.1";


-----------------------------------------------------------------------------
-- Content Storage
--
-- btree - store in a btree
-- local - store in an in-memory btree or dht
-- memcache - store in a memcache server
-----------------------------------------------------------------------------
-- TODO: should the user provide the file?

-- drwxrwx--- 2 root www-data 4096 Jan  6 20:27 ../skiffmouse/

pragma annotate( todo, "Need content in a database" );

type cms_file_type is (btree,local,memcache);

--cms_dir  : constant string := "/usr/lib/skiffmouse";
--cms_path : constant string := "/usr/lib/skiffmouse/cms_content.btree";
--cms_max_key_length : constant positive := 80;
--cms_max_content_length : constant positive := 32768;

mc_session : memcache.memcache_cluster;
--session_file : btree_io.file;
--session_path : constant string := "/home/ken/cms/session.btree";
session_max_key_length : constant positive := 80;
session_max_content_length : constant positive := 2048;

cms_file : btree_io.file;

--cms_snippet_path : string := "/usr/lib/skiffmouse/cms_snippet.btree";
cms_snippet_file : btree_io.file;

CMS_KEY_ERROR : exception;
CMS_ID_ERROR  : exception;
SESSION_KEY_ERROR : exception;
CONFIG_ERROR : exception;

-----------------------------------------------------------------------------
-- Begin and End Page Cache
-----------------------------------------------------------------------------

id_table : dynamic_hash_tables.table;

begin_page_list : doubly_linked_lists.list;
end_page_list   : doubly_linked_lists.list;

session_openned : boolean := false;

-----------------------------------------------------------------------------

session_token : cgi_string;
pragma unchecked_import( cgi, session_token );

-- KLUDGE: this is here because of a bug in new_file, new_list, new_table

procedure cms_initialize_generics is
begin
  btree_io.new_file( cms_file, raw_content );
  btree_io.new_file( cms_snippet_file, a_snippet );

  doubly_linked_lists.new_list( begin_page_list, raw_content );
  doubly_linked_lists.new_list( end_page_list, raw_content );

  dynamic_hash_tables.new_table( id_table, html_id );
end cms_initialize_generics;


-----------------------------------------------------------------------------

-- Low-level content functions

procedure cms_get( key : string; content : in out raw_content ) is
begin
   btree_io.get( cms_file, key, content );
end cms_get;

procedure cms_set( key : string; content : raw_content ) is
begin
   if key = "" then
      raise CMS_KEY_ERROR with "empty key";
   elsif strings.length( key ) > cms_max_key_length then
      raise CMS_KEY_ERROR with "key too long";
   elsif not strings.is_alphanumeric( key ) then
      raise CMS_KEY_ERROR with "key is not alphanumeric";
   end if;
   btree_io.set( cms_file, key, content );
end cms_set;

-- Session import/export functions
--
-- TODO: these are not complete
-- TODO: kludge variable should be handled better...
-- TODO: session duration not implemented
-- Note: kludge_session is not "written to" only because it is referred to
--       in the backquoted subscript which is not compiled if it is not run
--       it is only checked at syntax checking time.
kludge_session : session_string;

procedure session_open is
  s : string;
begin
  mc_session := memcache.new_cluster;
  memcache.register_server( mc_session, "localhost", 11211 );
  -- no version? then not open
  -- TODO: should I raise a CONFIG_ERROR here?
  s := memcache.version( mc_session );
  session_openned := s /= "";
end session_open;

procedure cms_session_get( key : string; val : in out session_string ) is
  full_key : string;
begin
  if not session_openned then
     session_open;
  end if;
  full_key := string( session_token );
  full_key := @ & "~";
  full_key := @ & string( key );
  val := session_string( memcache.get( mc_session, full_key ) );
end cms_session_get;

pragma session_import_script(
   `kludge_session := session_string( sessions.session_variable_value ); cms_session_get( sessions.session_variable_name, kludge_session );`
);

procedure cms_session_set( key : string; val : session_string ) is
  full_key : string;
begin
   if key = "" then
      raise SESSION_KEY_ERROR with "empty key";
   elsif strings.length( key ) > session_max_key_length then
      raise SESSION_KEY_ERROR with "key too long";
   elsif not strings.is_alphanumeric( key ) then
      raise SESSION_KEY_ERROR with "key is not alphanumeric";
   end if;
   full_key := string( session_token );
   full_key := @ & "~";
   full_key := @ & string( key );
   memcache.set( mc_session, full_key, string( val ) );
end cms_session_set;

pragma session_export_script(
   `cms_session_set( sessions.session_variable_name, sessions.session_variable_value );`
);

-----------------------------------------------------------------------------
-- HTML ID's
-----------------------------------------------------------------------------

function cms_new_id( prefix : string ) return html_id is
   the_id : html_id;
begin
   the_id := html_id( strings.image( numerics.serial ) );
   the_id := html_id( strings.trim( @, trim_end.both ) );
   the_id := html_id( prefix ) & @;
   if dynamic_hash_tables.has_element( id_table, the_id ) then
      raise CMS_ID_ERROR with "duplicate HTML id";
   end if;
   dynamic_hash_tables.add( id_table, the_id, the_id );
   return the_id;
end cms_new_id;

-----------------------------------------------------------------------------
-- Static Content
--
-- Static content is blocks of text encoded when put into a page.  These
-- are pulled from a cache or database.
-----------------------------------------------------------------------------

procedure cms_save_static_content( id : html_id; content : raw_content ) is
begin
   cms_set( string( id ), content );
end cms_save_static_content;

function cms_static_content( id : html_id ) return html_content is
  content : raw_content;
begin
   cms_get( string( id ), content );
   return cgi.html_encode( content );
end cms_static_content;

procedure cms_put_static_content( id : html_id ) is
begin
   put_line( cms_static_content( id ) );
end cms_put_static_content;

-----------------------------------------------------------------------------
-- Snippets
--
-- These are fragments of HTML that are inserted into web pages.
--
-- The design decision is to have one custom css class per snippet, with the
-- goal of nesting more complicated snippets.
--
-- If we have content and style parameters, they must be named and typed in
-- the snippet and we need a way to map and test data types with parameters.
-- This is both for error checking and supporting a visual editor.
--
-- Some CMS' parse the HTML, looking for custom HTML tags, though that may be
-- analogous to <?spar some_fn ?>??.
-----------------------------------------------------------------------------

procedure cms_with_snippet( id : snippet_id ) is
--Registering a snippet at the top of page
begin
  null;
end cms_with_snippet;

procedure cms_begin_snippet( id : snippet_id ) is
-- Insert the start of the snippet
begin
  null;
end cms_begin_snippet;

procedure cms_end_snippet( id : snippet_id ) is
-- Insert the end of the snippet
begin
  null;
end cms_end_snippet;

-----------------------------------------------------------------------------
-- Layouts
--
-- Layouts are the responsibility of HTML
-----------------------------------------------------------------------------

--type layout_id is new string;

--type a_layout is record
--   id          : layout_id;   -- a name to reference it
--   description : string;      -- human-readable description
--   head_html   : raw_content; -- the HTML to be added to HTML head tag
--   foot_html   : raw_content; -- the HTML to be added to end of the page
--   begin_html  : raw_content; -- the HTML to be added to the page (data type?)
--   end_html    : raw_content; -- the HTML to be added to the page (data type?)
--end record;

--procedure cms_with_layout( id : layout_id ) is
--begin
--  null;
--end cms_with_layout;

--procedure cms_begin_layout( id : layout_id ) is
--begin
--  null;
--end cms_begin_layout;

--procedure cms_end_layout( id : layout_id ) is
--begin
--  null;
--end cms_end_layout;

-- LIST LAYOUTS
--
-- List all layouts in the database

--procedure cms_list_layouts( id : snippet_id ) is
--begin
--  null;
--end cms_list_layouts;

-----------------------------------------------------------------------------
-- Pages
--
-- Insert HTML into the start and end of a page as needed.
-----------------------------------------------------------------------------

procedure begin_page is
begin
  if not doubly_linked_lists.is_empty( begin_page_list ) then
     put( doubly_linked_lists.assemble( begin_page_list ) );
  end if;
end begin_page;

procedure end_page is
begin
  if not doubly_linked_lists.is_empty( end_page_list ) then
     put( doubly_linked_lists.assemble( end_page_list ) );
  end if;
end end_page;

-----------------------------------------------------------------------------
-- Cross-site Request Forgery Token
--
-- A random string to validate forms and other data in HTTP requests.
-----------------------------------------------------------------------------

-- CSRF TOKEN
--
-- The MD5 is only to make the number human-readable...needed?
-----------------------------------------------------------------------------

function cms_csrf_token return csrf_token is
begin
  return numerics.md5( strings.image( numerics.rnd( 100000000 ) ) );
end cms_csrf_token;


-----------------------------------------------------------------------------
-- User Sessions
--
-- Logging in, logging out.
-----------------------------------------------------------------------------

-- TODO: handling logins
-- TODO: we may have to generate this earlier
-- TODO: should be begin_form or something like that
-- TODO: ideally session token should be in cookie

procedure cms_put_session_token is
begin
  if session_token = "" then
     session_token := cgi_string( numerics.md5( strings.image( numerics.rnd( 100000000 ) ) ) );
  end if;
  put_line( "<input name=" & ASCII.Quotation & "session_token" & ASCII.Quotation &
    " type=" & ASCII.Quotation & "hidden" & ASCII.Quotation &
     " value=" & ASCII.Quotation & session_token & ASCII.Quotation & ">" );
end cms_put_session_token;

-- TODO: logins, multiple sessions

-- Session Variables

login_name : constant session_string := "";
pragma import( session, login_name );


-----------------------------------------------------------------------------
-- Housekeeping
--
-- Functions for specifying and connecting to the content storage.
-----------------------------------------------------------------------------

procedure cms_open is
begin
  if not files.is_directory( cms_dir ) then
     raise CONFIG_ERROR with "cms directory does not exist";
  end if;
  -- is_writable is not 100% guaranteed...
  if not files.is_writable( cms_dir ) then
     raise CONFIG_ERROR with "cms directory is not writable";
  end if;

  cms_initialize_generics;

  begin
    btree_io.open( cms_file, cms_path, cms_max_key_length, cms_max_content_length );
  exception when others =>
    raise;
    -- TODO: handle exceptions here
    --btree_io.create( cms_file, cms_path, cms_max_key_length, cms_max_content_length );
  end;

  begin
    btree_io.open( cms_snippet_file, cms_snippet_path, cms_max_key_length, cms_max_content_length );
  exception when others =>
    -- TODO: handle exceptions here
    btree_io.create( cms_snippet_file, cms_snippet_path, cms_max_key_length, cms_max_content_length );
  end;
end cms_open;

procedure cms_close is
begin
  if btree_io.is_open( cms_file ) then
     btree_io.close( cms_file );
  end if;
  doubly_linked_lists.clear( begin_page_list );
  doubly_linked_lists.clear( end_page_list );
  dynamic_hash_tables.reset( id_table );
end cms_close;

-- VIM editor formatting instructions
-- vim: ft=spar

