# SparCanto

## Overview

SparCanto is a web framework.

It is written in the SparForte language.

## Directory Structure

   Unlike some frameworks, SparCanto doesn't tell you where to put your
   files.  All SparCanto files go under the framework directory.

   [document root] - the parent directory

     framework - SparCanto and all its files

       bin - command line executables
       config - configuration files
       cron - a place for cron jobs
       data - a place for SparCanto's data files
       migrations - database migrations
       setup - command line installation scripts (this will not be installed)

     example1  - A SparCanto example website (installed optionally)

## Installation

1. Configuring Apache

1.1. Ensure CGI is active

   This may vary on different operating systems.

   a2enmod cgi

1.2. Treat SparForte files as CGI executables

<Directory /var/www/html/[document root]>
        Options +ExecCGI
        AddHandler cgi-script .sp
        AddHandler cgi-script .cgi
</Directory>

1.3. Secure the framework folder from public viewing.

    Use .htaccess (or similar).

2. Run the SparCanto installer.

   Run framework/setup/install.sh.

## License

COPYING contains information about the GPL licence.

