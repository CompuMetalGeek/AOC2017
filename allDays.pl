use strict;
use Time::HiRes qw/time/;
use Term::ANSIColor;
use Win32::Console::ANSI;

my $time = time;
@ARGV = (1..25) unless @ARGV;

for (@ARGV){
	if($_=~ /(\d)+-(\d+)/){
		push @ARGV, ($1..$2);
	}
	my $filename = "day".($_<10?"0".$_:$_).".pl";
	if(-e $filename){
		printf "Day %2.2d\n------\n",$_;
		system("perl $filename");
		print "\n";
	}
}

print "The complete advent takes ",colored( sprintf("%.3f s",time-$time), "green")," to run.\n";
