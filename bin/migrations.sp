#!/usr/local/bin/spar

-- Earlier issues:
-- command_name = spar in a script started with "spar..."?
-- chains can hang in a loop if an error occurs before it ... can't duplicate
-- put_line in pragma debug loses line feed

pragma annotate( summary, "migrations.sp" )
              @( description, "apply mysql database changes for a project" )
              @( author, "Ken O. Burtch" )
              @( errors, "" );
pragma license( unrestricted );
pragma software_model( shell_script );

procedure migrations is

  -- Database configuration options
  --
  -- Change these to access your database

  db_host        : constant string := "localhost";
  db_user        : constant string := "ken";
  db_pass        : constant string := "snoofle";
  db_name        : constant string := "testdb";

  -- Default paths

  mig_dir_prefix : constant string := db_name & "_";
  mig_base       : constant string := "snapshot.sql";
  mig_log_path   : constant string := "/usr/share/migrations";
  mig_lock       : constant string := "/usr/share/migrations/migrations.lck";

  -- Command line option flags and variables

  opt_base       : boolean := false;
  opt_create     : boolean := false;
  opt_status     : boolean := false;
  opt_update     : boolean := false;
  opt_help       : boolean := false;
  opt_dbname     : string := db_name;
  opt_migration  : string := "";

  -- These use standard Linux status codes

  no_file_error       : exception with "file not found"   use   2;
  no_permission_error : exception with "access denied"    use  13;
  invalid_arg_error   : exception with "invalid argument" use  22;
  migration_error     : exception with "migration failed" use 192;
  general_error       : exception with "error occurred"   use 193;

  -- Exit status codes

  type status is new short_short_integer;
  no_file_status             : constant status :=   2; -- ENOENT
  no_permission_status       : constant status :=  13; -- EACCES
  invalid_arg_status         : constant status :=  22; -- EINVAL
  general_error_status       : constant status := 192;

  exit_status : status := 0;

  -- Commands

  mkdir : constant command := "/bin/mkdir";
  mysql : constant command := "/usr/bin/mysql";


  -- Default database name (can be overridden with -d)

  target_db      : constant string := db_name;

  mig_log        : string;

  -- we'll need to check the username so load it from the environment

  type import_string is new string;

  LOGNAME : constant import_string := "unknown";
  pragma import( shell, LOGNAME );

  --  SHOW HELP
  --
  -- Display the usage text
  ----------------------------------------------------------------------------

  procedure usage is
  begin
    put_line( "usage: migrations.sp [-b|-c mig|-s|-u] [-d db] [-v]" ) @
            ( "" ) @
            ( " -b apply the baseline database snapshot" ) @
            ( " -c create a unique migration file name from the migration name given" ) @
            ( " -d db specify a different target database name" ) @
            ( " -s status of the current migrations" ) @
            ( " -u update - apply the migraions" );
  end usage;

  --  APPLY BASE SNAPSHOT
  --
  -- -b: Apply the baseline database snapshot
  ----------------------------------------------------------------------------

  procedure apply_base_snapshot is
  begin
    if not files.exists( mig_base ) then
       put_line( standard_error, source_info.source_location & "baseline database " &
         " snapshot '" & mig_base & "' does not exist" );
       exit_status := no_file_status;
    elsif not files.is_readable_file( mig_base ) then
       put_line( standard_error, source_info.source_location & "baseline database " &
         "snapshot '" & mig_base & "' is not readable" );
       exit_status := no_permission_status;
    else
       mysql -u "$db_user" -h "$db_host" -D "$target_db" -p"$db_pass" < "$mig_base" ;
       if $? /= 0 then
          put_line( standard_error, source_info.source_location & "application of " &
            "baseline database snapshot failed" );
            exit_status := general_error_status;
       end if;
    end if;
  end apply_base_snapshot;

  --  CREATE EMPTY MIGRATION
  --
  -- -c: Create a unique migration file name from the migration name given
  ----------------------------------------------------------------------------

  procedure create_empty_migration is
    mig_dir : string;
    now     : constant calendar.time := calendar.clock;
    year    : string;
    month   : string;
    day     : string;
    hours   : string;
    minutes : string;
    seconds : string;
    human_date : string;

    -- GET DATE AND TIME
    --
    -- Get the current date and time

    procedure get_date_and_time is
    begin
      year    := `date '+%Y';`;
      month   := `date '+%m';`;
      day     := `date '+%d';`;
      hours   := `date '+%H';`;
      minutes := `date '+%M';`;
      seconds := `date '+%S';`;
      human_date := `date;`;
    end get_date_and_time;

    -- CREATE MIGRATION DIRECTORY
    --
    -- Create the migration directory for the current year

    procedure create_migration_directory is
    begin
      mig_dir := mig_dir_prefix & year;
      if not files.is_directory( mig_dir ) then
         mkdir -m 777 "$mig_dir";
         if $? /= 0 then
            put_line( standard_error, source_info.file & ": error: Unable to make directory '" & mig_dir & "'" );
            exit_status := no_permission_status;
         else
            pragma debug( `put_line( source_info.file & ": debug: migration directory '" & mig_dir & "' created" );` );
         end if;
      end if;
    end create_migration_directory;

    mig_path : string;
    f : file_type;
  begin
    get_date_and_time;
    create_migration_directory;
    if exit_status = 0 then
       mig_path := mig_dir & "/m" & year & month & '_' & hours & minutes &
          seconds & '_' & opt_migration & ".sql";
       pragma debug( `put_line( source_info.file & ": debug: migration file will be '" & mig_path & "'" );` );
       create( f, out_file, mig_path );
       put_line( f, "/* " & opt_migration ) @
               ( f, "     Date: " & human_date ) @
               ( f, "   Ticket: N/A" ) @
               ( f, "   Author: " & LOGNAME ) @
               ( f, "*/" ) @
               ( f, "" );
       close( f );
       put_line( mig_path & " created" );
    end if;
  end create_empty_migration;

  --  MIGRATION STATUS
  --
  -- -s: status of the current migrations
  ----------------------------------------------------------------------------

  procedure migration_status is
    last_mig : string;
    f1  : file_type;
    dir : string;
    f2  : file_type;
    mig : string;
    found : string;
  begin
    if not files.exists( mig_log ) then
       put_line( "no migrations have been run" );
    else

       -- List migrations that haven't been applied

-- TODO: if first ls is commented out, the second does not run
-- ls -d "$mig_dir_prefix"*;
-- ls -d "$mig_dir_prefix"* > t.t;
-- ls "migs_"*, ls "$pfx"* both work at command line
-- expands to "ls", "-", "d", "migs_" and no * ... shell expansion didn't trigger here...why?

       echo; -- or new_line ...THIS MUST BE HERE...WHY?  THINK THIS BUG IS FIXED
       -- TODO: this could probably be done better
       ls -d "$mig_dir_prefix"* > t.t;

       open( f1, in_file, "t.t" );
       while not end_of_file( f1 ) loop
           dir := get_line( f1 );
           ls "$dir" > t2.t;
           open( f2, in_file, "t2.t" );
           while not end_of_file( f2 ) loop
              mig := get_line( f2 );
              found := `fgrep "$mig" < "$mig_log";`;
              if found /= "" then
                 -- put_line( "N " & mig & ' ' & NOW & ' ' & LOGNAME );
                 put_line( "N " & mig );
              else
                 -- put_line( ". " & mig & ' ' & NOW & ' ' & LOGNAME );
                 put_line( ". " & mig );
              end if;
           end loop;
           close( f2 );
       end loop;
       close( f1 );
       new_line;

       -- Show the last migration that was applied
       last_mig := `tail -1 "$mig_log";`;
       if last_mig = "" then
          put_line( "no migrations have been run" );
       else
          put_line( "the last migration was '" & last_mig & "'" );
       end if;
    end if;
  end migration_status;

  --  UPDATE PROJECT
  --
  -- -u: update by applying the migraions
  ----------------------------------------------------------------------------

  procedure update_project is
    --last_mig : string;
    f1  : file_type;
    dir : string;
    f2  : file_type;
    mig : string;
    found : string;
  begin
  --mig_log_path   : constant string := "/usr/share/migrations";
  --mig_lock       : constant string := "/usr/share/migrations/migrations.lck";
    ls -d "$mig_dir_prefix"* > t.t;
    if $? /= 0 then
       raise no_file_error with "no migrations directories found";
    else
       open( f1, in_file, "t.t" );
       while not end_of_file( f1 ) loop
           dir := get_line( f1 );
           ls "$dir" > t2.t;
           open( f2, in_file, "t2.t" );
           while not end_of_file( f2 ) loop
              mig := get_line( f2 );
              if not files.exists( mig_log ) then
                 found := "";
              else
                 found := `fgrep "$mig" < "$mig_log";`;
              end if;
              if found = "" then
                 mysql -u "$db_user" -h "$db_host" -D "$target_db" -p"$db_pass" < "$dir/$mig" ;
                 if $? /= 0 then
                    raise migration_error;
                 end if;
              end if;
              --if found /= "" then
              if found = "" then
                  put_line( "N " & mig & ' ' & human_date & ' ' & LOGNAME );
                 put_line( "U " & mig );
              else
                 put_line( ". " & mig & ' ' & human_date & ' ' & LOGNAME );
                 put_line( ". " & mig );
              end if;
           end loop;
           close( f2 );
       end loop;
       close( f1 );
       new_line;
       ls -d "migs_"* > t.t;
    end if;
  end update_project;

  --  HANDLE OPTIONS
  --
  -- Process the command line options.  May return an exit_status error code
  ----------------------------------------------------------------------------

  procedure handle_options is
    argnum : positive := 1;
    arg    : string;
  begin
     if command_line.argument_count = 0 then
        opt_help := true;
     else
        while argnum <= command_line.argument_count loop
           arg := command_line.argument( argnum );
           if arg = "-b" then
              opt_base := true;
           elsif arg = "-c" then
              opt_create := true;
           elsif arg = "d" then
              if argnum = command_line.argument_count then
                 put_line( standard_error, "Database name is missing" );
                 exit_status := invalid_arg_status;
              end if;
              argnum := @+1;
              opt_dbname := command_line.argument( argnum );
           elsif arg = "-s" then
              opt_status := true;
           elsif arg = "-u" then
              opt_update := true;
           elsif arg = "-h" or arg = "--help" then
              opt_help := true;
           elsif argnum = command_line.argument_count then
              opt_migration := arg;
           else
              put_line( standard_error, "Unrecognized option: '" & arg & '"' );
              exit_status := invalid_arg_status;
           end if;
           argnum := @+1;
        end loop;
     end if;
     if ( opt_base and opt_create ) or
        ( opt_base and opt_status ) or
        ( opt_base and opt_update ) or
        ( opt_create and opt_status ) or
        ( opt_create and opt_update ) or
        ( opt_status and opt_update ) then
        put_line( standard_error, "Expected only one of -b, -c, -s or -u" );
        exit_status := invalid_arg_status;
     end if;
     if opt_create and opt_migration = "" then
       put_line( standard_error, "unexpected migration name '" & opt_migration & "'. -c applies to all" );
       exit_status := invalid_arg_status;
     end if;
     if opt_base and opt_migration /= "" then
       put_line( standard_error, "unexpected migration name '" & opt_migration & "'. -b applies to all" );
       exit_status := invalid_arg_status;
     end if;
     if opt_status and opt_migration /= "" then
       put_line( standard_error, "unexpected migration name '" & opt_migration & "'. -s applies to all" );
       exit_status := invalid_arg_status;
     end if;
     if opt_update and opt_migration /= "" then
       put_line( standard_error, "unexpected migration name '" & opt_migration & "'. -u applies to all" );
       exit_status := invalid_arg_status;
     end if;
  end handle_options;

begin

  mig_log := mig_log_path & "/" & target_db & "_migration_log.txt";

  --if not files.exists( mig_log_path ) then
  --   put_line( standard_error, source_info.source_location & ": error: migration log directory '" & mig_log_path & "' does not exist" );
  --   exit_status := no_file_status;
  --elsif not files.is_readable_file( mig_log_path ) then
  --   put_line( standard_error, source_info.source_location & ": error: migration log directory '" & mig_log_path & "' is not readable by " & LOGNAME );
  --   exit_status := no_permission_status;
  --elsif not files.is_writable_file( mig_log_path ) then
  --   put_line( standard_error, source_info.source_location & ": error: migration log directory '" & mig_log_path & "' is not writable by " & LOGNAME );
  --   exit_status := no_permission_status;
  --end if;

  -- it's OK for the log not to exist
  --if files.exists( mig_log ) then
  --   if not files.is_readable_file( mig_log ) then
  --      put_line( standard_error, source_info.source_location & ": error: migration log '" & mig_log & "' is not readable by " & LOGNAME );
  --      exit_status := no_permission_status;
  --   elsif not files.is_writable_file( mig_log ) then
  --      put_line( standard_error, source_info.source_location & ": error: migration log directory '" & mig_log & "' is not writable by " & LOGNAME );
  --      exit_status := no_permission_status;
  --   end if;
  --end if;

  if exit_status = 0 then  -- so far, so good?
     handle_options;
  end if;

  if exit_status = 0 then  -- still good?
     if opt_help then
        usage;
     elsif opt_base then
        apply_base_snapshot;
     elsif opt_create then
        create_empty_migration;
     elsif opt_status then
        migration_status;
     elsif opt_update then
        update_project;
     else
        usage;
     end if;
  end if;

  command_line.set_exit_status( short_short_integer( exit_status ) );

end migrations;


-- VIM editor formatting instructions
-- vim: ft=spar

