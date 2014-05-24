# NAME

Automatic-GDN-YDN

# DESCRIPTION

Automatic operation enable / pause of GDN, YDN

# SYNOPSYS

       java -jar ./selenium-server-standalone.jar
       carton exec -- ./adwords.pl sample.tsv

# INSTALLATION

First, git clone.

       git clone https://github.com/masutaro/Automatic-GDN-YDN.git

Second, install cpanm.

       cd ~/bin
       curl -LO http://xrl.us/cpanm
       chmod +x cpanm   

Third, install Carton.

       cpanm -l ~/local Carton

Fourth, set environment variable.

       export PERL5LIB=~/local/lib/perl5
       export PATH=$PATH:~/local/bin

Fifth, install CPAN modules.

       cd Automatic-GDN-YDN
       carton

Sixth, modify gdn.pl, $email and $passwd.

       my $email  = '';
       my $passwd = '';