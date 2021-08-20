#!/bin/sh 

# . remove existing target files 
rm ../run-cuis-base 
rm ../run-cuis-my-config 

# . create convenience links in the directory where usually 
#   one runs Cuis. 
ln run-cuis-base.rb ../run-cuis-base
ln run-cuis-my-config.rb ../run-cuis-my-config 


