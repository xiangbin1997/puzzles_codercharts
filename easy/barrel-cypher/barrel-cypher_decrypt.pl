#!/usr/bin/perl
#Enter your code here
use strict;
unless(@ARGV){ die "wrong parameter!";}
open(my $IN_FD, "<", $ARGV[0]) or die "open error!";
my @contents = ();
while(<$IN_FD>){
    chomp;
    push @contents, $_;
}
my @charmap = reverse (('a'..'z') x 2);
my $cases = shift @contents;
while(@contents){
    my ($keys, $in) =splice @contents,0,2;
    my @keys_a = split //, $keys;
    my @in_a = split //,$in;
    push @keys_a, reverse @keys_a;
    my @out = ();
    foreach(@in_a){
        if($_ eq ' '){
            push @out, $_;
            next;
        }
        my $key = shift @keys_a;
        push @keys_a, $key;
        my $index = ord('z') - ord( $_) + $key;
        push @out, $charmap[$index];
    }
    my $result = join '', @out;
    print "$result" . "\n";
}

