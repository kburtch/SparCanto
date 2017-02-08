#!/usr/local/bin/spar
pragma annotate( summary, "system_check" )
              @( description, "Check the system configuration." )
              @( author, "Ken O. Burtch" );

pragma software_model( shell_script );
pragma license( gplv3 );

pragma annotate( todo, "load and check the configuration" );

procedure system_check is
  type perms_string is new string;

  shell_cmd  : constant perms_string := "-rwx------";
  shell_only : constant perms_string := "drwx------";
  read_only  : constant perms_string := "drwxr-x---";
  read_write : constant perms_string := "drwxrwx---";

  minimum_spar_version : constant string := "2.0.3";

  has_memcached : boolean := false;

  ok : boolean := true;

  procedure check_shell_command ( file : string ) is
    perms : perms_string;
  begin
    -- TODO: check for existence
    perms := `ls -ld "$file" | cut -c1-10;`;
    if $? /= 0  then
       put_line( standard_error, file & " was not found or cannot be read" );
       ok := false;
    elsif perms /= shell_cmd then
       put_line( standard_error, file & " was excepted to have " &
          string( shell_cmd ) & " permissions not " & string( perms ) );
       ok := false;
    end if;
  end check_shell_command;

  procedure check_command_directory ( dir : string ) is
    perms : perms_string;
  begin
    -- TODO: check for existence
    perms := `ls -ld "$dir" | cut -c1-10;`;
    if $? /= 0  then
       put_line( standard_error, dir & " was not found or cannot be read" );
       ok := false;
    elsif perms /= shell_only then
       put_line( standard_error, dir & " was excepted to have " &
          string( shell_only ) & " permissions not " & string( perms ) );
       ok := false;
    end if;
  end check_command_directory;

  procedure check_read_directory ( dir : string ) is
    perms : perms_string;
  begin
    -- TODO: check for existence
    perms := `ls -ld "$dir" | cut -c1-10;`;
    if $? /= 0  then
       put_line( standard_error, dir & " was not found or cannot be read" );
       ok := false;
    elsif perms /= read_only then
       put_line( standard_error, dir & " was excepted to have " &
          string( read_only ) & " permissions not " & string( perms ) );
       ok := false;
    end if;
  end check_read_directory;

  procedure check_write_directory ( dir : string ) is
    perms : perms_string;
  begin
    -- TODO: check for existence
    perms := `ls -ld "$dir" | cut -c1-10;`;
    if $? /= 0  then
       put_line( standard_error, dir & " was not found or cannot be read" );
       ok := false;
    elsif perms /= read_write then
       put_line( standard_error, dir & " was excepted to have " &
          string( read_write ) & " permissions not " & string( perms ) );
       ok := false;
    end if;
  end check_write_directory;

begin
  -- top-level directory check
  check_command_directory( "../bin/" );
  check_shell_command( "../bin/migrations.sp" );
  check_shell_command( "../bin/snippet_add.sp" );
  check_shell_command( "../bin/snippet_init.sp" );
  check_shell_command( "../bin/snippet_list.sp" );
  check_shell_command( "../bin/system_check.sp" );
  check_read_directory( "../config/" );
  check_command_directory( "../cron/" );
  check_write_directory( "../data/" );
  check_read_directory( "../framework/" );
  check_command_directory( "../migrations/" );
  check_read_directory( "../projects/" );
  check_read_directory( "../projects/web/" );
  check_read_directory( "../projects/web/css/" );
  check_read_directory( "../projects/web/js/" );
  check_read_directory( "../projects/web/img/" );
  check_command_directory( "../setup/" );

  -- sparforte version check
  if System.System_Version < minimum_spar_version then
     put_line( standard_error, "SparForte " & minimum_spar_version &
        " or newer required not " & System.System_Version );
  end if;

  -- sparforte feature check (to be written)

  declare
    mc : memcache.memcache_cluster;
    version : string;
  begin
    has_memcached := true;
    mc := memcache.new_cluster;
    memcache.register_server( mc, "localhost", 11211 );
    version := memcache.version( mc );
  exception when others =>
    has_memcached := false;
  end;
  if not has_memcached then
     put_line( standard_error, "memcached is not responding" );
     ok := false;
  end if;

  pragma annotate( todo, "btree test needed" );

  -- results of the test

  if ok then
     put_line( "Your system looks OK" );
     command_line.set_exit_status( 0 );
  else
     command_line.set_exit_status( 192 );
  end if;
end system_check;

-- VIM editor formatting instructions
-- vim: ft=spar

