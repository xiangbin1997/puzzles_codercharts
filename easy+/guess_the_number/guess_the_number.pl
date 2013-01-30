#!/usr/bin/perl
#Enter your code here
use strict;

my $g_LISTEN_F = shift;
my $g_SPEAK_F = shift;
my $g_LISTEN_FD;
my $g_SPEAK_FD;

my @g_RESP_TYPE = qw(
    START_GUESS
    END_GAME
    GUESS_RESULT
);

my @g_GUESS_CLUE = qw(
    NOTHING
    LITTLE
    GREAT
    EQUAL
);

my $g_a;
my $g_b;
my $g_lastanswer;

sub init
{
   open($g_LISTEN_FD, "<", $g_LISTEN_F) or die "open file failed!";
   open($g_SPEAK_FD, ">>", $g_SPEAK_F) or die "open file failed!";
}

sub guessinit
{
    $g_a = shift;
    $g_b = shift;
}

sub guess
{
    my $clue = shift;
    my $answer;

    if ( $clue = "NOTHING")
    {
        $answer = ($g_a + $g_b)/2;
    }
    elsif($clue eq "LITTLE")
    {
        if($g_a eq $g_lastanswer)
        {
            # means $b=$a+1
            $answer = $g_b;
        }
        else
        {
            $answer = ($g_a + $g_b)/2;
        }

        $g_a = $g_lastanswer;
    }
    elsif($clue eq "GREAT")
    {
        if($g_b eq $g_lastanswer)
        {
            # means $b=$a+1
            $answer = $g_a;
        }
        else
        {
            $answer = ($g_a + $g_b)/2;
        }

        $g_b = $g_lastanswer;
    }
    elsif($clue eq "EQUAL")
    {
        $answer =  $g_lastanswer;
    }
    else
    {
        # TODO : report an error
        $answer =  $g_lastanswer;
    }

    $g_lastanswer = $answer;

    return $answer;
}

sub lis
{

}

sub speak
{

}

sub main
{
    while(1)
    {
        my $resp = lis();
        my $a;
        my $b;

        if ( $resp->type eq "START_GUESS" )
        {
            my ($a,$b) = split /:/, $resp->data;
            guessinit($a,$b);
            my $guess = guess("NOTHING");
            speak($guess);
        }
        elsif($resp->type eq "END_GAME")
        {
            return 0;
        }
        elsif($resp->type eq "GUESS_RESULT")
        {
            my $clue = $resp->data;
            my $guess = guess($clue);
            speak($guess);
        }
        else
        {
            return 1;
        }
    }
}

main;

