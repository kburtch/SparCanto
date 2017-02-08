#!/usr/local/bin/spar

pragma annotate( summary, "SparCanto - Example 1 - Index" )
              @( description, "Index page for SparCanto Example." )
              @( description, "http://localhost/sparcanto/projects/example1/index.sp" )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( http_site_internal );
pragma license( gplv3 );

procedure canto_ex1_index is
  pragma template( html, "templates/canto_ex1_index.tmpl" );
  with separate "/var/www/html/sparcanto/config/config.sp";
  with separate "/var/www/html/sparcanto/config/team.sp";
  with separate "/var/www/html/sparcanto/framework/server_consts.sp";
  with separate "/var/www/html/sparcanto/framework/sparcanto.sp";
begin
   kludge_session := ""; -- kludge: must be written to outside of ``
   setup_team;
   canto_open;

   declare
     c : a_content_entry;
   begin
     c.id := "ken";
     c.content := "hello & ken";
     c.tags := "test";
     c.description  := "";
     c.owner        := 1;
     c.created_on   := calendar.clock;
     c.published_on := calendar.clock;
     c.expired_on   := calendar.clock;
     c.can_cache    := false;
     canto_save_static_content( "ken", c );
   end;

   -- TODO: all variables should be populated here and then canto_close
end canto_ex1_index;

-- VIM editor formatting instructions
-- vim: ft=spar

