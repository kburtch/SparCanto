#!/usr/local/bin/spar

pragma annotate( summary, "SparAdagio" )
              @( description, "A CMS and Web Framework for SparForte." )
              @( description, "Include this library into a SparForte script" )
              @( description, "using 'with include'." )
              @( author, "Ken O. Burtch" );

procedure snippet_list is
  with separate "../config/config.sp";
  with separate "../framework/sparadagio.sp";
  snippet_cursor : btree_io.cursor;
  key : string;
  snippet : a_snippet;
begin
  cd( project_path & "/bin/" );

  btree_io.new_cursor( snippet_cursor, a_snippet );
  btree_io.get_first( cms_snippet_file, snippet_cursor, key, snippet );
  ? snippet.id;
  loop
     btree_io.get_next( cms_snippet_file, snippet_cursor, key, snippet );
     ? snippet.id;
  end loop;
exception when others =>
  btree_io.close_cursor( cms_snippet_file, snippet_cursor );
end snippet_list;

-- VIM editor formatting instructions
-- vim: ft=spar

