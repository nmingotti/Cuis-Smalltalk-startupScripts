#!/bin/sh 

# . remove existing target files 
rm ../run-cuis-base 
rm ../run-cuis-my-config 

# . create convenience links in the directory where usually 
#   one runs Cuis.

# . for deb4 
# ln run-cuis-base.rb ../run-cuis-base
# ln run-cuis-my-config.rb ../run-cuis-my-config 

# . for euriscom.it 
ln run-cuis-base-euriscom.rb ../run-cuis-base
ln run-cuis-my-config-euriscom.rb ../run-cuis-my-config 


