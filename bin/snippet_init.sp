#!/usr/local/bin/spar

pragma annotate( summary, "snippit_init" )
              @( description, "Create or clear the snippet database and" )
              @( description, "install the initial collection of snippets." )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );

procedure snippet_init is
  with separate "../config/config.sp";
  with separate "../framework/sparcanto.sp";
  key : string;
  snippet : a_snippet;
begin
  cd( project_path & "/bin/" );

  cms_open;
  btree_io.truncate( cms_snippet_file );

  -- parameters to be determined
  snippet.id := "title-example";
  snippet.description := "an example title";
  snippet.url := "no url";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<h1>";
  snippet.end_html := "<h1>";
  btree_io.set( cms_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap success alert
  snippet.id := "bs-alert-success";
  snippet.description := "Provide contextual feedback messages for typical " &
    "user actions with the handful of available and flexible alert messages.";
  snippet.url := "https://v4-alpha.getbootstrap.com/components/alerts/";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "alert alert-success" &
    ASCII.Quotation &  "role=" & ASCII.Quotation & " alert" & ASCII.Quotation &
    ">";
  snippet.end_html := "</div>";
  btree_io.set( cms_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap info alert
  snippet.id := "bs-alert-info";
  snippet.description := "Provide contextual feedback messages for typical " &
    "user actions with the handful of available and flexible alert messages.";
  snippet.url := "https://v4-alpha.getbootstrap.com/components/alerts/";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "alert alert-info" &
    ASCII.Quotation &  "role=" & ASCII.Quotation & " alert" & ASCII.Quotation &
    ">";
  snippet.end_html := "</div>";
  btree_io.set( cms_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap warning alert
  snippet.id := "bs-alert-warning";
  snippet.description := "Provide contextual feedback messages for typical " &
    "user actions with the handful of available and flexible alert messages.";
  snippet.url := "https://v4-alpha.getbootstrap.com/components/alerts/";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "alert alert-warning" &
    ASCII.Quotation &  "role=" & ASCII.Quotation & " alert" & ASCII.Quotation &
    ">";
  snippet.end_html := "</div>";
  btree_io.set( cms_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap warning alert
  snippet.id := "bs-alert-danger";
  snippet.description := "Provide contextual feedback messages for typical " &
    "user actions with the handful of available and flexible alert messages.";
  snippet.url := "https://v4-alpha.getbootstrap.com/components/alerts/";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "alert alert-danger" &
    ASCII.Quotation &  "role=" & ASCII.Quotation & " alert" & ASCII.Quotation &
    ">";
  snippet.end_html := "</div>";
  btree_io.set( cms_snippet_file, string( snippet.id ), snippet );

  cms_close;
end snippet_init;

-- VIM editor formatting instructions
-- vim: ft=spar

