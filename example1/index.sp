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
  with separate "/var/www/html/sparcanto/framework/config/config.sp";
  with separate "/var/www/html/sparcanto/framework/config/team.sp";
  with separate "/var/www/html/sparcanto/framework/server_consts.sp";
  with separate "/var/www/html/sparcanto/framework/types.sp";
  with separate "/var/www/html/sparcanto/framework/sessions.sp";
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
     calendar.split( calendar.clock,
        c.created_on_year,
        c.created_on_month,
        c.created_on_day,
        c.created_on_seconds );
     c.published_on_year := c.created_on_year;
     c.published_on_month := c.created_on_month;
     c.published_on_day := c.created_on_day;
     c.published_on_seconds := c.created_on_seconds;
     c.expired_on_year := c.created_on_year;
     c.expired_on_month := c.created_on_month;
     c.expired_on_day := c.created_on_day;
     c.expired_on_seconds := c.created_on_seconds;
     c.can_cache    := false;
     canto_save_static_content( "ken", c );
   end;

   -- TODO: all variables should be populated here and then canto_close
end canto_ex1_index;

-- VIM editor formatting instructions
-- vim: ft=spar

