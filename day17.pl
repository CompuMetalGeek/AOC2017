use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);


my $input = <$fh>;
chomp $input;

my @buf = (0);
my $ptr = 0;
my $runtime = 2017;
for (my $i = 1; $i <= $runtime; $i++) {
	$ptr = ($ptr + $input) % scalar @buf;
	splice @buf, $ptr+1, 0, $i;
	$ptr++;
	if($i % ($runtime/100) == 0 ){
		local $| = 1;
		printf "\r%3d %% completed", $i / ($runtime / 100);
	}
}

print "\rThe value after 2017 is ", colored( $buf[$ptr+1], "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;

my $follower = 0;
$ptr = 0;
$runtime = 50_000_000;
for (my $i = 1; $i <= $runtime; $i++) {
	$ptr = ($ptr + $input) % $i;
	if( ! $ptr ){
		$follower = $i;
	}
	$ptr++;
	if($i % ($runtime/100) == 0 ){
		local $| = 1;
		printf "\r%3d %% completed", $i / ($runtime / 100);
	}
}

print "\rThe value after 0 is ", colored( $follower, "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
