separate;
pragma annotate( summary, "SparCanto" )
              @( description, "A CMS and Web Framework for SparForte." )
              @( description, "Include this library into a SparForte script" )
              @( description, "using 'with include'." )
              @( author, "Ken O. Burtch" );
-- TODO: can't set software model or license twice, but should be able to
-- in an include file..
--pragma software_model( http_framework );
--pragma license( unrestricted );

pragma restriction( no_external_commands );
pragma assert( System.System_Version >= "2.0.3" );

type a_content_entry is record
  id           : html_id;       -- html id where it goes
  content      : raw_content;   -- the raw content
  tags         : raw_content;   -- content tags
  description  : raw_content;   -- comments on content
  owner        : user_id;       -- who owns it
  created_on_year     : calendar.year_number;  -- when was it created
  created_on_month    : calendar.month_number; -- when was it created
  created_on_day      : calendar.day_number;   -- when was it created
  created_on_seconds  : calendar.day_duration; -- when was it created
  published_on_year   : calendar.year_number;  -- when it should appear
  published_on_month  : calendar.month_number; -- when it should appear
  published_on_day    : calendar.day_number;   -- when it should appear
  published_on_seconds : calendar.day_duration; -- when it should appear
  expired_on_year     : calendar.year_number;  -- when it is obsolete
  expired_on_month    : calendar.month_number; -- when it is obsolete
  expired_on_day      : calendar.day_number;   -- when it is obsolete
  expired_on_seconds  : calendar.day_duration; -- when it is obsolete
  can_cache    : boolean;       -- can it be cached
end record;

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

canto_version : constant universal_string := "0.1";


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
pragma annotate( todo, "Cleanup of content file, subprograms" );

type canto_file_type is (btree,local,memcache);

--cms_dir  : constant string := "/usr/lib/skiffmouse";
--cms_path : constant string := "/usr/lib/skiffmouse/cms_content.btree";
--cms_max_key_length : constant positive := 80;
--cms_max_content_length : constant positive := 32768;

canto_content_file : btree_io.file( a_content_entry );

--cms_snippet_path : string := "/usr/lib/skiffmouse/cms_snippet.btree";
canto_snippet_file : btree_io.file( a_snippet );

CANTO_KEY_ERROR : exception;
CANTO_ID_ERROR  : exception;
SESSION_KEY_ERROR : exception;
CONFIG_ERROR : exception;

-----------------------------------------------------------------------------
-- Begin and End Page Cache
-----------------------------------------------------------------------------

id_table : dynamic_hash_tables.table( html_id );

begin_page_list : doubly_linked_lists.list( raw_content );
end_page_list   : doubly_linked_lists.list( raw_content );

-----------------------------------------------------------------------------
-- Cookies
-----------------------------------------------------------------------------

-- KLUDGE: this is here because of a bug in new_file, new_list, new_table

--procedure canto_initialize_generics is
--begin
--  btree_io.new_file( canto_content_file, a_content_entry );
--  btree_io.new_file( canto_snippet_file, a_snippet );
--
--  doubly_linked_lists.new_list( begin_page_list, raw_content );
--  doubly_linked_lists.new_list( end_page_list, raw_content );
--
--  dynamic_hash_tables.new_table( id_table, html_id );
--end canto_initialize_generics;


-----------------------------------------------------------------------------

-- Low-level content functions

procedure canto_get( key : string; content : in out a_content_entry ) is
  ce : a_content_entry;
begin
   btree_io.get( canto_content_file, key, ce );
end canto_get;

procedure canto_set( key : string; content : in out a_content_entry ) is
begin
   if key = "" then
      raise CANTO_KEY_ERROR with "empty key";
   elsif strings.length( key ) > canto_max_key_length then
      raise CANTO_KEY_ERROR with "key too long";
   elsif not strings.is_alphanumeric( key ) then
      raise CANTO_KEY_ERROR with "key is not alphanumeric";
   end if;
   btree_io.set( canto_content_file, key, content );
end canto_set;

-----------------------------------------------------------------------------
-- HTML ID's
-----------------------------------------------------------------------------

function canto_new_id( prefix : string ) return html_id is
   the_id : html_id;
begin
   the_id := html_id( strings.image( numerics.serial ) );
   the_id := html_id( strings.trim( @, trim_end.both ) );
   the_id := html_id( prefix ) & @;
   if dynamic_hash_tables.has_element( id_table, the_id ) then
      raise CANTO_ID_ERROR with "duplicate HTML id";
   end if;
   dynamic_hash_tables.add( id_table, the_id, the_id );
   return the_id;
end canto_new_id;

-----------------------------------------------------------------------------
-- Static Content
--
-- Static content is blocks of text encoded when put into a page.  These
-- are pulled from a cache or database.
-----------------------------------------------------------------------------

procedure canto_save_static_content( id : html_id; content : in out a_content_entry ) is
begin
   canto_set( string( id ), content );
end canto_save_static_content;

function canto_static_content( id : html_id ) return html_content is
  ce : a_content_entry;
begin
   canto_get( string( id ), ce );
   return cgi.html_encode( ce.content );
end canto_static_content;

procedure canto_put_static_content( id : html_id ) is
  content : html_content;
begin
   content := canto_static_content( id );
   put_line( content );
end canto_put_static_content;

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

procedure canto_with_snippet( id : snippet_id ) is
--Registering a snippet at the top of page
begin
  null;
end canto_with_snippet;

procedure canto_begin_snippet( id : snippet_id ) is
-- Insert the start of the snippet
begin
  null;
end canto_begin_snippet;

procedure canto_end_snippet( id : snippet_id ) is
-- Insert the end of the snippet
begin
  null;
end canto_end_snippet;

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

function canto_csrf_token return csrf_token is
begin
  return numerics.sha224_digest_of( strings.image( numerics.rnd( 100000000 ) ) );
end canto_csrf_token;


-----------------------------------------------------------------------------
-- User Sessions
--
-- Logging in, logging out.
-----------------------------------------------------------------------------

-- TODO: handling logins
-- TODO: we may have to generate this earlier
-- TODO: should be begin_form or something like that
--
-- TODO: logins, multiple sessions
-----------------------------------------------------------------------------

login_name : constant session_string := "";
pragma import( session, login_name );
pragma export( session, login_name );

is_logged_in : session_string := "";
pragma import( session, is_logged_in );
pragma export( session, is_logged_in );

-----------------------------------------------------------------------------
-- Housekeeping
--
-- Functions for specifying and connecting to the content storage.
-----------------------------------------------------------------------------

procedure canto_open is
begin

  -- Sanity Checks

  if not files.is_directory( canto_data_dir ) then
     raise CONFIG_ERROR with "data directory does not exist";
  end if;
  -- is_writable is not 100% guaranteed...
  if not files.is_writable( canto_data_dir ) then
     raise CONFIG_ERROR with "data directory is not writable";
  end if;

  -- Initialize Generics

--  canto_initialize_generics;

  -- Open/Create Content File

  begin
    btree_io.open( canto_content_file, canto_content_path, canto_max_key_length, canto_max_content_length );
  exception when others =>
    btree_io.create( canto_content_file, canto_content_path, canto_max_key_length, canto_max_content_length );
  end;

  -- Open/Create Snippet File

  begin
    btree_io.open( canto_snippet_file, canto_snippet_path, canto_max_key_length, canto_max_content_length );
  exception when others =>
    -- TODO: handle exceptions here
    btree_io.create( canto_snippet_file, canto_snippet_path, canto_max_key_length, canto_max_content_length );
  end;
end canto_open;

procedure canto_close is
begin
  if btree_io.is_open( canto_content_file ) then
     btree_io.close( canto_content_file );
  end if;
  doubly_linked_lists.clear( begin_page_list );
  doubly_linked_lists.clear( end_page_list );
  dynamic_hash_tables.reset( id_table );
end canto_close;

-- VIM editor formatting instructions
-- vim: ft=spar

