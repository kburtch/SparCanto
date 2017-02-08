#!/usr/local/bin/spar

pragma annotate( summary, "SparCanto - Example 1 - Home" )
              @( description, "Home page for SparCanto Example." )
              @( description, "http://localhost/sparcanto/projects/example1/home.sp" )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( http_site_internal );
pragma license( gplv3 );

procedure canto_ex1_index is
  pragma template( html, "templates/canto_ex1_home.tmpl" );
  with separate "/var/www/html/sparcanto/config/config.sp";
  with separate "/var/www/html/sparcanto/framework/server_consts.sp";
  with separate "/var/www/html/sparcanto/framework/sparcanto.sp";
begin
   kludge_session := ""; -- kludge: must be written to outside of ``
   canto_open;
end canto_ex1_index;

-- VIM editor formatting instructions
-- vim: ft=spar

