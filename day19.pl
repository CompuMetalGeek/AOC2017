use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;
use v5.14;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my @grid;

while(my $input = <$fh>){
	my @line = split "", $input;
	push @grid, [@line];
}

my $x = 0, my $y = 0;

while(1){
	if($grid[0][$x] ne " "){
		last;
	}
	$x++;
}

my @text;
my $direction = 3; # 0 = right, 1 = left, 2 = up, 3 = down
my $steps = 0;
while(1){
	if($direction == 0){ # right
		$x++;
	} elsif($direction == 1){ # left
		$x--;
	} elsif($direction == 2){ # up
		$y--;
	} elsif($direction == 3){ # down
		$y++;
	}
	$steps++;
	my $location = $grid[$y][$x];
	if($location eq "+"){
		changeDirection();
	} elsif($location eq " "){
		last;
	} elsif ($location =~ /[A-Z]/){
		push @text, $location;
	}
}


sub changeDirection {
	if($direction < 2){ # currently going left or right
		$direction = ($grid[$y+1][$x] ne " ") ? 3  : 2 ;
	} else {
		$direction = ($grid[$y][$x+1] ne " ") ? 0 : 1 ;
	}
}

print "The path is ", colored( join("", @text) , "black on_red" ), ".\n";
print "The packet takes ", colored( $steps , "black on_red" ), " steps. ( ", sprintf ("%.3f",time - $time) ," s )\n";
