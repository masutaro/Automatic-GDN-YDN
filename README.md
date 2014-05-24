# NAME

Automatic-GDN-YDN

# DESCRIPTION

Automatic operation enable / pause of GDN, YDN

# SYNOPSYS

  java -jar ./selenium-server-standalone.jar
  carton exec -- ./adwords.pl

# INSTALLATION

First, install cpanm.

       cd ~/bin
       curl -LO http://xrl.us/cpanm
       chmod +x cpanm   

Second, install Carton.

        cpanm -l ~/local Carton

Third, set environment variable.

       export PERL5LIB=~/local/lib/perl5
       export PATH=$PATH:~/local/bin