#!/usr/local/bin/spar

pragma annotate( summary, "snippet_list" )
              @( description, "List the available snippets." )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( shell_script );
pragma license( gplv3 );

procedure snippet_list is
  with separate "../config/config.sp";
  with separate "../sparcanto.sp";
  snippet_cursor : btree_io.cursor;
  key : string;
  snippet : a_snippet;

  procedure print_it( s : in out a_snippet ) is
  begin
     ? "Snippet: " & snippet.id;
     ? "Description: " & snippet.description;
     ? "URL: " & snippet.url;
     new_line;
  end print_it;

begin
  btree_io.new_cursor( snippet_cursor, a_snippet );
  cd( project_path & "/bin/" );
  canto_open;
  btree_io.open_cursor( canto_snippet_file, snippet_cursor );
  btree_io.get_first( canto_snippet_file, snippet_cursor, key, snippet );
  print_it( snippet );
  btree_io.raise_exceptions( canto_snippet_file, false );
  loop
     btree_io.get_next( canto_snippet_file, snippet_cursor, key, snippet );
     exit when btree_io.last_error( canto_snippet_file ) = bdb.DB_NOTFOUND;
     print_it( snippet );
  end loop;
  btree_io.raise_exceptions( canto_snippet_file, true );
  btree_io.close_cursor( canto_snippet_file, snippet_cursor );
  canto_close;
end snippet_list;

-- VIM editor formatting instructions
-- vim: ft=spar

