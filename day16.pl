use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my @line = ("a".."p");

my @input = split ",",<$fh>;

my %outputs = {join("",@line) => 0};
my $output;
my $count = 1_000_000_000;

my $i=1;
while (1) {
	foreach (@input) {
		chomp;
		if($_ =~ "s"){
			my ($count) = $_ =~ /(\d+)/;
			# print "spin    : $_ => $count\n";
			for (my $i = 0; $i < $count; $i++) {
				unshift @line, pop(@line);
			}
		} elsif ($_ =~ "x"){
			my @pos = $_ =~ /(\d+)/g;
			# print "exchange: $_ => ($pos[0], $pos[1])\n";
			my $temp = $line[$pos[0]];
			$line[$pos[0]] = $line[$pos[1]];
			$line[$pos[1]] = $temp;
		} elsif ($_ =~ "p"){
			my ($partner1, $partner2) = (split (""))[1,3];
			# print "partner : $_ => ($partner1, $partner2)\n";
			foreach (@line){
				if( $_ eq $partner1 ){
					$_ = $partner2;
				} elsif( $_ eq $partner2 ){
					$_ = $partner1;
				} 
			}
		}
	}
	
	$output = join "",@line;
	
	if($i==1){
		print "The order after 1 dance is ", colored( $output, "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
	}
	
	if(exists $outputs{$output}){
		#print "element $i is a repeated output of element $outputs{$output}.\n";
		last;
	}
	
	$outputs{$output}=$i++;
}

my $period = $i - $outputs{$output};
$count -= {$outputs{$output}-1};
$count %= $period;

while (my ($order,$index) = each %outputs){
	if($index == $count){
		print "The order after 1.000.000.000 dances is ", colored( $order, "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
	}
}


