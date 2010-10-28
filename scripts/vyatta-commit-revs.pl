#!/usr/bin/perl
#
# **** License ****
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# A copy of the GNU General Public License is available as
# `/usr/share/common-licenses/GPL' in the Debian GNU/Linux distribution
# or on the World Wide Web at `http://www.gnu.org/copyleft/gpl.html'.
# You can also obtain it by writing to the Free Software Foundation,
# Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# This code was originally developed by Vyatta, Inc.
# Portions created by Vyatta are Copyright (C) 2010 Vyatta, Inc.
# All Rights Reserved.
#
# Author: Stig Thormodsrud
# Date: October 2010
# Description: Script to create config.boot revision backups.
#
# **** End License ****
#

use strict;
use warnings;
use lib '/opt/vyatta/share/perl5/';

use Vyatta::Config;
use Vyatta::ConfigMgmt;

#
# main
#

my $archive_dir   = cm_get_archive_dir();
my $lr_state_file = cm_get_lr_state_file();
my $lr_conf_file  = cm_get_lr_conf_file();

if (! -d $archive_dir) {
    system("sudo mkdir $archive_dir");
}

my $tmp_config_file = "/tmp/config.boot.$$";
system("/opt/vyatta/sbin/vyatta-save-config.pl $tmp_config_file > /dev/null");
system("sudo mv $tmp_config_file $archive_dir/config.boot");
system("sudo logrotate -f -s $lr_state_file $lr_conf_file");
my ($user) = getpwuid($<);
cm_commit_add_log($user, 'cli', $ARGV[0]);

exit 0;

# end of file