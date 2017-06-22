#!/usr/local/bin/spar
pragma restriction( no_external_commands );
pragma software_model( http_site_internal );
pragma license( gplv3 );

procedure canto_ex1_css is
  pragma template( css, "templates/canto_ex1_css.tmpl" );
  with separate "/var/www/html/sparcanto/framework/config/config.sp";
  with separate "/var/www/html/sparcanto/framework/server_consts.sp";

  -- Colours

  rgb_white     : string := "ffffff";
  rgb_black     : string := "000000";
  rgb_fail      : string := "ff0000";
  rgb_caution   : string := "ffff00";
  rgb_success   : string := "00ff00";
  rgb_primary   : string := "0000ff";
  rgb_secondary : string := "000088";

begin
   null;
end canto_ex1_css;

-- VIM editor formatting instructions
-- vim: ft=spar

