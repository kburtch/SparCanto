separate;

--configuration is

project_path : constant string := "/var/www/html/sparcanto";

-- todo: content file should be stored in a database
-- todo: random name for data?
canto_data_dir  : constant string := "../../data";
canto_content_path : constant string := "../../data/cms_content.btree";
canto_max_key_length : constant positive := 80;
canto_max_content_length : constant positive := 32768;

canto_snippet_path : string := "../../data/cms_snippet.btree";

--end configuration;

-- VIM editor formatting instructions
-- vim: ft=spar

