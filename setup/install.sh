#!/usr/local/bin/spar

procedure install is

begin
put_line( "Administrator Account" );
new_line;
put_line( "First_Name: " );
first_name := get_line;
put_line( "Last_Name: " );
last_name := get_line;
put_line( "Email Address: " );
email_address := get_line;
put_line( "Username: " );
username := get_line;
put_line( "Password: " );
password := get_line;
put_line( "Repeat Passward: " );
password_confirm := get_line;
new_line;

-- TODO: TEAM INFO

put_line( "Install Directory" );
new_line;
put_line( "Install Directory (in the document root): " );
install_folder := get_line;
-- TIME ZONE
new_line;

put_line( "Database Settings" );
new_line
put_line( "Server Hostname: " ):
-- e.g. localhost
db_host := get_line;
put_line( "Database Name: " );
db_name := get_line;
put_line( "Database Username: " );
db_user := get_line;
put_line( "Database Passwrd: " );
db_pass := get_line;
new_line;

-- Sanity Checks

-- User Confirmation

put_line( "Proceed? (Y/N) " );
confirm := get_line;

if confirm /= "Y" and confirm /= "y" then
   put_line( "Aborted" );
end if;
put_line( "Installing..." );

put_line( "Copying files..." );

put_line( "Creating configuration file..." );

put_line( "Creating database tables..." );

put_line( "Creating database tables..." );

put_line( "Creating user account..." );

put_line( "Setup complete" );

end install;

-- VIM editor formatting instructions
-- vim: ft=spar

