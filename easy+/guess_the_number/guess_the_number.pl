#!/usr/bin/perl
#Enter your code here
use strict;
use IO::Handle;
use IO::Select;

my $g_LISTEN_F = shift;
my $g_SPEAK_F = shift;
my $g_LISTEN_FD;
my $g_SPEAK_FD;
my $g_select;

my @g_RESP_TYPE = qw(
    START_GUESS
    END_GAME
    GUESS_RESULT
    NOTHING
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
   $g_LISTEN_FD->autoflush(1);
   $g_SPEAK_FD->autoflush(1);
   $g_select = new IO::Select();
   $g_select->add($g_LISTEN_FD);
}

sub lis
{
    # TODO: handle block
    my ($ready) = $g_select->can_read();
    my $msg = <$ready>;
    my %resp = ();

    if ($msg =~ m/^n\s+(\d)\s+(\d)/)
    {
        $resp{'type'} = "START_GUESS";
        $resp{'data'} = "$1:$2";
    }
    elsif($msg =~ /^e/)
    {
        $resp{'type'} = "END_GAME";
    }
    elsif($msg =~ /^(<|>|=)/)
    {
        $resp{'type'} = "GUESS_RESULT";
        my $clue;

        if($1 eq "<")
        {
            $clue = "LITTLE";
        }
        elsif($1 eq ">")
        {
            $clue = "GREAT";
        }
        elsif($1 eq "=")
        {
            $clue = "EQUAL";
        }
        else
        {
            # TODO: bug catch
            $clue = "UNKNOWN";
        }

        $resp{'data'} = $clue;
    }
    else
    {
        # TODO: bug catch
    }

    return \%resp;
}

sub speak
{
    my $guess = shift;

    print $g_SPEAK_FD $guess;
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
            $g_a = $g_lastanswer;
            $answer = ($g_a + $g_b)/2;
        }
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
            $g_b = $g_lastanswer;
            $answer = ($g_a + $g_b)/2;
        }
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

sub main
{
    while(1)
    {
        my $resp = lis();

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

