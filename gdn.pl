#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Data::Dumper qw(Dumper);
use Selenium::Remote::Driver;
use File::Slurp qw(read_file);

my $email  = '';
my $passwd = '';
my @line   = read_file('adwords.tsv', binmode => ':utf8');
my %enable = ();
my %pause  = ();

for my $line (@line) {
    chomp $line;

    my ($campaign, $group, $flg) = split "\t", $line;

    $enable{$campaign} ||= [];
    $pause{$campaign}  ||= [];

    if ($flg) {
        push @{ $enable{$campaign} }, $group;
    }
    else {
        push @{ $pause{$campaign} }, $group;
    }
}

#
# 画面オープン -> ログイン
#
my $driver = Selenium::Remote::Driver->new;
$driver->set_implicit_wait_timeout(10000);
$driver->get('https://adwords.google.com/cm/CampaignMgmt');

my $elm = $driver->find_element('//input[@id="Email"]');
$elm->send_keys($email);

$elm = $driver->find_element('//input[@id="Passwd"]');
$elm->send_keys($passwd);
$elm->submit;

#
# 操作
#
change_status( $driver, \%enable, 'enable' );
change_status( $driver, \%pause, 'pause' );

sub change_status {
    my ($driver, $hash, $status) = @_;

    for my $campaign (keys %{ $hash }) {
        $elm = $driver->find_element(
            sprintf('//a[@nodetype="campaign" and text()="%s"]', $campaign)
        );
        $elm->click;

        my @group = @{ $hash->{$campaign} };

        for my $group (@group) {
            $elm = $driver->find_element(
                sprintf('//a[text()="%s"]/parent::div/parent::td/preceding-sibling::td/preceding-sibling::td/input', $group)
            );
            $elm->click;
        }

        $elm = $driver->find_element('//div[text()="編集"]');
        $elm->click;

        if ($status eq 'enable') {
            $elm = $driver->find_element('//div[@gwtdebugid="scripty-bulk-adgroups-enable"]');
            $elm->click;
        }
        elsif ($status eq 'pause') {
            $elm = $driver->find_element('//div[@gwtdebugid="scripty-bulk-adgroups-pause"]');
            $elm->click;
        }
        $driver->pause(5000);

        for my $group (@group) {
            $elm = $driver->find_element(
                sprintf('//a[text()="%s"]/parent::div/parent::td/preceding-sibling::td/preceding-sibling::td/input', $group)
            );
            $elm->click;
        }
    }
}
