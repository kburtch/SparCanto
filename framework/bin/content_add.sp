#!/usr/local/bin/spar

pragma annotate( summary, "SparCanto" )
              @( description, "A CMS and Web Framework for SparForte." )
              @( description, "Include this library into a SparForte script" )
              @( description, "using 'with include'." )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( shell_script );
pragma license( gplv3 );

procedure content_add is
  with separate "../config/config.sp";
  with separate "../sparcanto.sp";
  key : string;
  snippet : a_snippet;
begin
  cd( project_path & "/bin/" );

  pragma annotate( todo, "not yet written" );

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
     -- Content probably shouldn't expire yet...
     c.expired_on_year := c.created_on_year;
     c.expired_on_month := c.created_on_month;
     c.expired_on_day := c.created_on_day;
     c.expired_on_seconds := c.created_on_seconds;
     c.can_cache    := false;
     canto_save_static_content( "ken", c );
   end;

end content_add;

-- VIM editor formatting instructions
-- vim: ft=spar

