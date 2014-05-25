#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Data::Dumper qw(Dumper);
use Selenium::Remote::Driver;
use File::Slurp qw(read_file);

my $user_name  = '';
my $passwd     = '';
my @line       = read_file($ARGV[0], binmode => ':utf8');
my %enable     = ();
my %pause      = ();

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
# 画面オープン -> ログイン -> キャンペーン管理
#
my $driver = Selenium::Remote::Driver->new;
$driver->set_implicit_wait_timeout(10000);
$driver->get('https://yadui.business.yahoo.co.jp/ols/adv/Top/index');

my $elm = $driver->find_element('//input[@id="user_name"]');
$elm->send_keys($user_name);

$elm = $driver->find_element('//input[@id="password"]');
$elm->send_keys($passwd);
$elm->submit;

$elm = $driver->find_element('//a[text()="キャンペーン管理"]');
$elm->click;

#
# 操作
#
change_status( $driver, \%enable, 'enable' );
change_status( $driver, \%pause, 'pause' );

sub change_status {
    my ($driver, $hash, $status) = @_;

    for my $campaign (keys %{ $hash }) {
        $elm = $driver->find_element(
            sprintf('//a[@mode="CA" and text()="%s"]', $campaign)
        );
        $elm->click;

        my @group = @{ $hash->{$campaign} };
        next if @group == 0;

        for my $group (@group) {
            $elm = $driver->find_element(
                sprintf('//a[contains(@href, "#AG") and text()="%s"]/parent::td/preceding-sibling::th/input[@type="checkbox"]', $group)
            );
            $elm->click;
        }

        $elm = $driver->find_element('//a[@id="yjJtSetAGLumpEditBtn"]');
        $elm->click;

        if ($status eq 'enable') {
            $elm = $driver->find_element('//a[contains(@onclick, "yjJtSetAG") and contains(@onclick, "on")]');
            $elm->click;
        }
        elsif ($status eq 'pause') {
            $elm = $driver->find_element('//a[contains(@onclick, "yjJtSetAG") and contains(@onclick, "off")]');
            $elm->click;
        }
        $driver->pause(5000);
        $driver->refresh;
    }
}
