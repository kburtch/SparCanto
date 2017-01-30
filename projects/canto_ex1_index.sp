#!/usr/local/bin/spar
procedure canto_ex1_login is
  pragma template( html, "views/canto_ex1_login.tmpl" );
  with separate "../config/config.sp";
  with separate "../framework/sparcanto.sp";
begin
  kludge_session := ""; -- kludge: must be written to outside of ``
  cms_open;
  cms_save_static_content( "ken", "hello & ken" );
  --cms_put_static_content( "ken" );
  --cms_close;
end canto_ex1_login;

-- VIM editor formatting instructions
-- vim: ft=spar

