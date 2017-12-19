use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;
use v5.14;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my @commands;
my %register;
my $lastSound;
my $recovered = undef;

while(my $input = <$fh>){
	my @command = split " ", $input;
	push @commands, \@command;
}

my $index = 0;
while( ! defined $recovered ){
	$index = processCommand($commands[$index]);
}

sub processCommand {
	my $command = shift;
	my @command = @{$command};
	# print join(" ",@command), "\n";

	if($command[0] eq "snd") {
		$lastSound = $register{$command[1]};
	} elsif ($command[0] eq "set") {
		if($command[2] =~ /[a-z]/){
			$register{$command[1]} = $register{$command[2]};
		} else {
			$register{$command[1]} = $command[2];
		}
	} elsif ($command[0] eq "add") {
		if($command[2] =~ /[a-z]/){
			$register{$command[1]} += $register{$command[2]};
		} else {
			$register{$command[1]} += $command[2];
		}
	} elsif ($command[0] eq "mul") {
		if($command[2] =~ /[a-z]/){
			$register{$command[1]} *= $register{$command[2]};
		} else {
			$register{$command[1]} *= $command[2];
		}
	} elsif ($command[0] eq "mod") {
		if($command[2] =~ /[a-z]/){
			$register{$command[1]} %= $register{$command[2]};
		} else {
			$register{$command[1]} %= $command[2];
		}
	} elsif ($command[0] eq "rcv") {
		if($command[1] =~ /[a-z]/){
			$recovered = $lastSound unless $register{$command[1]} == 0;
		} else {
			$recovered = $lastSound unless $register{$command[1]} == 0;
		}
	} elsif ($command[0] eq "jgz") {
		if( $register{$command[1]} > 0){
			return $index + $command[2];
		}
	} else {
		print $command[0], " is not a valid command\n";
		exit;
	}
	return $index+1;
}

print "The first recovered frequency is ", colored( "$recovered", "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;

my %register0 = ("p"=>0);
my %register1 = ("p"=>1);
my @queue0;
my @queue1;
my $blocking0 = 0;
my $blocking1 = 0;
my $index0 = 0;
my $index1 = 0;
my $sndcount0 = 0;
my $sndcount1 = 0;
while ( !($blocking0 && $blocking1) ){
	if( !($blocking0 && scalar @queue0 == 0) ){
		$index0 = processCommand0($commands[$index0]);
	}
	if( !($blocking1 && scalar @queue1 == 0) ){
		$index1 = processCommand1($commands[$index1]);
	}
	#print "$index0 $index1\n";
}

print "Program 1 sent ", colored( $sndcount1, "black on_red" ), " values. ( ", sprintf ("%.3f",time - $time) ," s )\n";

sub processCommand0 {
	my $command = shift;
	my @command = @{$command};
	# print "0: ",join(" ",@command), "\n";

	if($command[0] eq "snd") {
		push @queue1, $register0{$command[1]};
		$sndcount0++;
	} elsif ($command[0] eq "set") {
		if($command[2] =~ /[a-z]/){
			$register0{$command[1]} = $register0{$command[2]};
		} else {
			$register0{$command[1]} = $command[2];
		}
	} elsif ($command[0] eq "add") {
		if($command[2] =~ /[a-z]/){
			$register0{$command[1]} += $register0{$command[2]};
		} else {
			$register0{$command[1]} += $command[2];
		}
	} elsif ($command[0] eq "mul") {
		if($command[2] =~ /[a-z]/){
			$register0{$command[1]} *= $register0{$command[2]};
		} else {
			$register0{$command[1]} *= $command[2];
		}
	} elsif ($command[0] eq "mod") {
		if($command[2] =~ /[a-z]/){
			$register0{$command[1]} %= $register0{$command[2]};
		} else {
			$register0{$command[1]} %= $command[2];
		}
	} elsif ($command[0] eq "rcv") {
		if(scalar @queue0 == 0 ){
			$blocking0 = 1;
			return $index0;
		}
		$register0{$command[1]} = shift @queue0;
		$blocking0 = 0;
	} elsif ($command[0] eq "jgz") {
		my $value = $command[1] =~/[a-z]/ ? $register0{$command[1]} : $command[1];
		if($value > 0){
			if($command[2] =~ /[a-z]/){
				return $index0 + $register0{$command[2]};
			} else {
				return $index0 + $command[2];
			}
		}
	} else {
		print $command[0], " is not a valid command\n";
		exit;
	}
	return $index0+1;
}

sub processCommand1 {
	my $command = shift;
	my @command = @{$command};
	# print "1: ", join(" ",@command), "\n";

	if($command[0] eq "snd") {
		push @queue0, $register1{$command[1]};
		$sndcount1++;
	} elsif ($command[0] eq "set") {
		if($command[2] =~ /[a-z]/){
			$register1{$command[1]} = $register1{$command[2]};
		} else {
			$register1{$command[1]} = $command[2];
		}
	} elsif ($command[0] eq "add") {
		if($command[2] =~ /[a-z]/){
			$register1{$command[1]} += $register1{$command[2]};
		} else {
			$register1{$command[1]} += $command[2];
		}
	} elsif ($command[0] eq "mul") {
		if($command[2] =~ /[a-z]/){
			$register1{$command[1]} *= $register1{$command[2]};
		} else {
			$register1{$command[1]} *= $command[2];
		}
	} elsif ($command[0] eq "mod") {
		if($command[2] =~ /[a-z]/){
			$register1{$command[1]} %= $register1{$command[2]};
		} else {
			$register1{$command[1]} %= $command[2];
		}
	} elsif ($command[0] eq "rcv") {
		if(scalar @queue1 == 0 ){
			$blocking1 = 1;
			return $index1;
		}
		$register1{$command[1]} = shift @queue1;
		$blocking1 = 0;
	} elsif ($command[0] eq "jgz") {
		my $value = $command[1] =~/[a-z]/ ? $register1{$command[1]} : $command[1];
		if($value > 0){
			if($command[2] =~ /[a-z]/){
				return $index1 + $register1{$command[2]};
			} else {
				return $index1 + $command[2];
			}
		}
	} else {
		print $command[0], " is not a valid command\n";
		exit;
	}
	return $index1+1;
}