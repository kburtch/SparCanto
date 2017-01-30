#!/usr/lib/cgi-bin/spar
procedure sailcss is
  pragma template( css, "sailcss.tmpl" );
  with separate "sailforte.sp";

  -- Colours

  rgb_white     : string := "ffffff";
  rgb_black     : string := "000000";
  rgb_fail      : string := "ff0000";
  rgb_caution   : string := "ffff00";
  rgb_success   : string := "00ff00";
  rgb_primary   : string := "0000ff";
  rgb_secondary : string := "000088";

begin
  kludge_session := ""; -- kludge: must be written to outside of ``
  cms_open;
  --cms_save_static_content( "ken", "hello & ken" );
  --cms_put_static_content( "ken" );
  --cms_close;
end sailcss;

