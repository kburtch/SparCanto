#!/usr/local/bin/spar

pragma annotate( summary, "SparCanto" )
              @( description, "A CMS and Web Framework for SparForte." )
              @( description, "Include this library into a SparForte script" )
              @( description, "using 'with include'." )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( shell_script );
pragma license( gplv3 );

procedure snippet_list is
  with separate "../config/config.sp";
  with separate "../sparcanto.sp";
  key : string;
  snippet : a_snippet;
begin
  cd( project_path & "/bin/" );

  pragma annotate( todo, "not yet written" );

end snippet_list;

-- VIM editor formatting instructions
-- vim: ft=spar

