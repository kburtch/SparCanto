#!/usr/local/bin/spar

pragma annotate( summary, "snippet_list" )
              @( description, "List the available snippets." )
              @( author, "Ken O. Burtch" );
pragma restrictions( no_external_commands );

procedure snippet_list is
  with separate "../config/config.sp";
  with separate "../framework/sparcanto.sp";
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
  cms_open;
  btree_io.open_cursor( cms_snippet_file, snippet_cursor );
  btree_io.get_first( cms_snippet_file, snippet_cursor, key, snippet );
  print_it( snippet );
  btree_io.raise_exceptions( cms_snippet_file, false );
  loop
     btree_io.get_next( cms_snippet_file, snippet_cursor, key, snippet );
     exit when btree_io.last_error( cms_snippet_file ) = bdb.DB_NOTFOUND;
     print_it( snippet );
  end loop;
  btree_io.raise_exceptions( cms_snippet_file, true );
  btree_io.close_cursor( cms_snippet_file, snippet_cursor );
  cms_close;
end snippet_list;

-- VIM editor formatting instructions
-- vim: ft=spar

