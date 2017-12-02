@ARGV = (1..25) unless @ARGV;

for (@ARGV){
	my $filename = "day".($_<10?"0".$_:$_).".pl";
	if(-e $filename){
		printf "Day %2.2d\n------\n",$_;
		system("perl $filename");
		print "\n";
	}
}
