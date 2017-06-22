#!/usr/local/bin/spar

pragma annotate( summary, "SparCanto - Example 1 - Login" )
              @( description, "Login page for SparCanto Example." )
              @( description, "http://localhost/sparcanto/projects/example1/login.sp" )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( http_site_internal );
pragma license( gplv3 );

procedure canto_ex1_login is
  pragma template( html, "templates/canto_ex1_login.tmpl" );
  with separate "/var/www/html/sparcanto/framework/config/config.sp";
  with separate "/var/www/html/sparcanto/framework/server_consts.sp";
  with separate "/var/www/html/sparcanto/framework/types.sp";
  with separate "/var/www/html/sparcanto/framework/sessions.sp";
  with separate "/var/www/html/sparcanto/framework/sparcanto.sp";

  type import_string is new string;

  username : import_string;
  pragma unchecked_import( cgi, username );

  password : import_string;
  pragma unchecked_import( cgi, password );

  error_message : string := "";
begin
   kludge_session := ""; -- kludge: must be written to outside of ``
   canto_open;
   if REQUEST_METHOD="POST" then
      if username = "admin" and password = "admin" then
         is_logged_in := "1";
put_line( standard_error, "is_logged_in set to " & is_logged_in ); -- DEBUG
         templates.set_http_location(
            files.dirname( string( REQUEST_URI ) ) & "/home.sp"
         );
         templates.put_template_header;
         canto_close;
         --return;
      else
         error_message := "Login incorrect";
      end if;
   end if;
end canto_ex1_login;

-- VIM editor formatting instructions
-- vim: ft=spar

