#!/usr/bin/perl
#Enter your code here
#https://github.com/nremond/CoderCharts.com.git
use strict;
use Data::Dumper;

my %enemy = ();
sub mapEnemy
{
    my ($h,$z)=@_;
    $enemy{$h}->{$z} = 1;
}

open(my $FD,"<",shift);
my @input=();
while(<$FD>)
{
    chomp;
    push @input, $_;
}

my ($n,$p) = split / /, $input[0];
# map enemy
foreach (@input[1..$p])
{
    my ($a,$b)=split;
    mapEnemy($a,$b);
    mapEnemy($b,$a);
}

# figure everyone's friends 
foreach($p+2..$#input)
{
    my $one = $input[$_];
    my %friends = ();
    my $enemy_ref = $enemy{$one};
    foreach (keys %$enemy_ref)
    {
        foreach(keys %{$enemy{$_}})
        {
            if(!exists $friends{$_} and $_ ne $one and !exists $enemy_ref->{$_})
            {
                $friends{$_} = 1;
            }
        }
    }
    
    print keys (%friends) . "\n";
}
