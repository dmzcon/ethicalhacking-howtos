#!/usr/bin/perl -w
use strict;  # You need this to use more strict syntacsis

###########################################################
################ DMZCON-2023 conference ###################
###########################################################
######### PURPLE-TEAM BOOT CAMP series of events ##########
###########################################################
###########################################################
######## Fast start in PERL-coding for Pentesting #########
###########################################################
###########################################################
#
# This script is educational one for studing Perl
# Algorithm is not optimized
# We show different opportunities of the language
#
#
# DISCUSS AND GET MORE INSIGHTS HERE: t.me/dmzconunited
#
###########################################################
########## FIRST YOU NEED DEFINE VARIABLES ################
###########################################################

my ($nlist,$flist,@namelist,@famlist,$name,$fam);

###########################################################
############### SET NAMES OF FILES HERE ###################
###########################################################

my $names_file="./names.txt";
my $fams_file="./familynames.txt";

###########################################################
############## EASY READ DATA FROM FILES ##################
###########################################################

open(NAMES,"< $names_file") or die "Could not find NAMES file : '$names_file' : $!";
$nlist = join("",<NAMES>);
close(NAMES);

open(FAMS,"< $fams_file") or die "Could not find FAMILYNAMES file : '$fams_file' : $!";
$flist = join("",<FAMS>);
close(FAMS);

###########################################################
############ USE THIS BLOCK TO MAKE CLEANING ##############
###########################################################
#
# REGULAR EXPRESSIONS SYNTACSIS:
#     
#     $variable =~ s/ PATTERN / NEW VALUE / SETTINGS
#
#  [a-z] - all small letters
#  [0-9] - numbers from 0 to 9
#  [a-z0-9] - combine
#  [a-z]{1,5} - at least 1 and less than 5 small letters
#  [\s] - spaces and tabs
#
#  =~ s/ PATTERN / SOME STRICT TO RUN; ""; /e;  - internal scripting
#  
#  =~ s/ (PATTERN) / my $variable=$1; ............ ""; /e;
#  $1 containts the result of the PATTERN search
#
#
#  Ask for additional pattern examples here: t.me/dmzconunited
#

$nlist =~ s/\n/ /gm;   # we have found all '\n' and replaced it with SPACE
$flist =~ s/\n/ /gm;


#  
#
###########################################################
#
# $ - means scalar simple variable
# @ - means an array
# % - means a hash-array

@namelist = split(" ",$nlist);  # getting array from string with 'SPACE' separators
@famlist = split(" ",$flist);

foreach $name (@namelist) {

# Let's clean the name variable from non symbol characters

        $name =~ s/([\W]+)//g;   # Regular expression:  =~ s/  /  /

# Let's check that our name consists of letters:

        if($name =~ m/[a-zA-Z]+/) {   # Regular expression:  =~ m/  /  

                foreach $fam (@famlist) {
                        if($fam =~ m/[a-zA-Z]+/) {
                                $fam =~s/([\W]+)//g;

# We can define variable here if needed
                                my $account = "$name$fam";  # joined two strings into one
#
# Other concatenations examples:
#
#  Try $account = $account.'@somedomainnames.com'; - and you will get emails list 
#
#  Try it and see the difference:
# "$names.$fam" - you will get name.fam
#  $names.$fam - you will get namefam


                                $account =~ tr/[A-Z]/[a-z]/; # when small letters needed

                                print "$account\n";
                        }
                }
        }
}

exit(0);
