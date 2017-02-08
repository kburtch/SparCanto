#!/usr/local/bin/spar

pragma annotate( summary, "snippit_init" )
              @( description, "Create or clear the snippet database and" )
              @( description, "install the initial collection of snippets." )
              @( author, "Ken O. Burtch" );
pragma restriction( no_external_commands );
pragma software_model( shell_script );
pragma license( gplv3 );

procedure snippet_init is
  with separate "../config/config.sp";
  with separate "../framework/sparcanto.sp";
  key : string;
  snippet : a_snippet;
begin
  cd( project_path & "/bin/" );

  canto_open;
  btree_io.truncate( canto_snippet_file );

  ---------------------------------------------------------------------------
  --
  -- SPARCANTO BASIC SNIPPETS
  --
  ---------------------------------------------------------------------------

  -- parameters to be determined
  snippet.id := "title-example";
  snippet.description := "an example title";
  snippet.url := "no url";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<h1>";
  snippet.end_html := "<h1>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  ---------------------------------------------------------------------------
  --
  -- BOOTSTRAP 4 SNIPPETS
  --
  ---------------------------------------------------------------------------

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
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

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
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

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
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

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
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap badge
  snippet.id := "bs-badge";
  snippet.description := "Easily highlight new or unread items by adding a " &
    "<span class=" & ASCII.Quotation & "badge" & ASCII.Quotation & "> to " &
    "links, Bootstrap navs, and more.";
  snippet.url := "http://getbootstrap.com/components/#badges";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "badge" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap breadcrumbs
  snippet.id := "bs-breadcrumb";
  snippet.description := "Indicate the current page's location within a " &
    "navigational hierarchy.";
  snippet.url := "http://getbootstrap.com/components/#breadcrumbs";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<ol class=" & ASCII.Quotation & "breadcrumb" &
    ASCII.Quotation & ">";
  snippet.end_html := "</ol>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap button groups
  snippet.id := "bs-button-group";
  snippet.description := "Indicate the current page's location within a " &
    "navigational hierarchy.";
  snippet.url := "http://getbootstrap.com/components/#btn-groups";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "btn-group" &
    ASCII.Quotation & ">";
  snippet.end_html := "</div>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap jumbotron
  snippet.id := "bs-jumbotron";
  snippet.description := "A lightweight, flexible component that can " &
    "optionally extend the entire viewport to showcase key content on " &
    "your site.";
  snippet.url := "http://getbootstrap.com/components/#jumbotron";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "jumbotron" &
    ASCII.Quotation & ">";
  snippet.end_html := "</div>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (default)
  snippet.id := "bs-label-default";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-default" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (primary)
  snippet.id := "bs-label-primary";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-primary" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (success)
  snippet.id := "bs-label-success";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-succes" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (info)
  snippet.id := "bs-label-info";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-info" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (warning)
  snippet.id := "bs-label-warning";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-warning" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap labels (danger)
  snippet.id := "bs-label-danger";
  snippet.description := "";
  snippet.url := "http://getbootstrap.com/components/#labels";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<span class=" & ASCII.Quotation & "label label-danger" &
    ASCII.Quotation & ">";
  snippet.end_html := "</span>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap nab (tabs)
  snippet.id := "bs-nav-tabs";
  snippet.description := "Navs available in Bootstrap have shared markup, " &
    "starting with the base .nav class, as well as shared states. Swap " &
    "modifier classes to switch between each style.";
  snippet.url := "http://getbootstrap.com/components/#nav-tabs";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<ul class=" & ASCII.Quotation & "nav nav-tabs" &
    ASCII.Quotation & ">";
  snippet.end_html := "</ul>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap nab (pills)
  snippet.id := "bs-nav-pills";
  snippet.description := "Navs available in Bootstrap have shared markup, " &
    "starting with the base .nav class, as well as shared states. Swap " &
    "modifier classes to switch between each style.";
  snippet.url := "http://getbootstrap.com/components/#nav-tabs";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<ul class=" & ASCII.Quotation & "nav nav-pills" &
    ASCII.Quotation & ">";
  snippet.end_html := "</ul>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap nab (pills vertical)
  snippet.id := "bs-nav-pills-vertical";
  snippet.description := "Navs available in Bootstrap have shared markup, " &
    "starting with the base .nav class, as well as shared states. Swap " &
    "modifier classes to switch between each style.";
  snippet.url := "http://getbootstrap.com/components/#nav-tabs";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<ul class=" & ASCII.Quotation & "nav nav-pills nav-stacked" &
    ASCII.Quotation & ">";
  snippet.end_html := "</ul>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap page header
  snippet.id := "bs-page-header";
  snippet.description := "Quick previous and next links for simple " &
    "pagination implementations with light markup and styles. It's " &
    "great for simple sites like blogs or magazines.";
  snippet.url := "http://getbootstrap.com/components/#page-header";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<ul class=" & ASCII.Quotation & "pager" &
    ASCII.Quotation & ">";
  snippet.end_html := "</ul>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  -- Bootstrap pager
  snippet.id := "bs-pager";
  snippet.description := "A simple shell for an h1 to appropriately space " &
     "out and segment sections of content on a page. It can utilize the " &
     "h1's default small element, as well as most other components (with " &
     "additional styles).";
  snippet.url := "http://getbootstrap.com/components/#pagination-pager";
  snippet.head_html := "";
  snippet.foot_html := "";
  snippet.begin_html := "<div class=" & ASCII.Quotation & "page-header" &
    ASCII.Quotation & ">";
  snippet.end_html := "</div>";
  btree_io.set( canto_snippet_file, string( snippet.id ), snippet );

  canto_close;
end snippet_init;

-- VIM editor formatting instructions
-- vim: ft=spar

