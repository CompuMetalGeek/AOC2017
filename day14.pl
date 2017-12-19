use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my $start = <$fh>;
chomp $start;

my @grid;

my $sum = 0;
for(my $i=0; $i < 128; $i++){
	my $string = sprintf("%s-%d",$start,$i);
	my @hash = split "",knotHash($string);
	my @line;
	for (my $j = 0; $j < 128; $j++) {
		push @line, ($hash[$j] == "0") ? "." : "#";
	}
	push @grid, [@line];
	$sum+= scalar grep( /1/, @hash); 
}


print "There are ", colored( $sum, "black on_red" ), " Squares. ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;

my $groups = 1;
for my $i ( 0 .. $#grid ) {
	for my $j ( 0 .. $#{$grid[$i]} ) {
		# print "line $i - element $j -> next";
		$groups = colorNeighbours($i,$j,$groups);
	}
}




print "There are ", colored( $groups-1, "black on_red" ), " Groups. ( ", sprintf ("%.3f",time - $time) ," s )\n";

sub knotHash {
	my @list = (0..255);
	my $skip = 0;
	my $current = 0;
	my $input = shift;
	chomp $input;
	my @input = split ",", $input;

	$time = time;
	@input=();
	push @input, ord($_) foreach (split "", $input);
	push @input, (17,31,73,47,23);

	for (my $round = 0; $round < 64; $round++) {
		for my $length (@input){
			my @toReverse;
			for (my $i = 0; $i < $length; $i++) {
				push @toReverse, $list[($i+$current)% scalar @list];
			}

			@toReverse = reverse @toReverse;

			for (my $i = 0; $i < $length; $i++) {
				$list[($i+$current)% scalar @list]=$toReverse[$i];
			}
			$current+=$length+$skip;
			$current %= scalar @list;
			$skip++;
		}
	}

	my @denseList;
	for (my $densePart = 0; $densePart < 16; $densePart++) {
		my $value = $list[$densePart*16];
		foreach my $x (@list[$densePart*16+1..$densePart*16+15]) {
			$value ^= $x;
		}
		push @denseList, $value;
	}

	my $hex ="";
	$hex .= sprintf("%08b",$_) foreach (@denseList);
	return $hex;
}

sub colorNeighbours {
	#getc;
	my $i = shift;
	my $j = shift;
	my $value = shift;
	if($grid[$i][$j] ne "#"){
		#print "not a good element\n";
		return $value;
	}
	# print "assigned group $value\n";
	$grid[$i][$j] = $value;
	if(0 <= $i-1){
		# printf "line %d - element %d -> continue",$i-1,$j;
		colorNeighbours($i-1,$j,$value);
	}
	if(0 <= $j-1){
		# printf "line %d - element %d -> continue",$i,$j-1;
		colorNeighbours($i,$j-1,$value);
	}
	# printf "line %d - element %d -> continue",$i,$j+1;
	colorNeighbours($i,$j+1,$value);

	# printf "line %d - element %d -> continue",$i+1,$j;
	colorNeighbours($i+1,$j,$value);
	return $value+1;
}