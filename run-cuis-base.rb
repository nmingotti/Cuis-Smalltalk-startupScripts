#!/usr/bin/ruby

require 'fileutils' 

=begin
. Si deve lanciare Cuis ma si vuole che:
1. il file di changes sia sempre lo stesso che gira, quello che e' arrivato
   durante l'installazione di Cuis.

2. Quindi

=end 

# Tova ll file con nome piu' corto che inizia con Cuis e finisce con '.image'
# quella e' l'immagine a 64 bit. 

# . Find Cuis base name image 
Dir.chdir 'Cuis-Smalltalk-Dev'
allCuisImageFiles = Dir.glob "Cuis*.image"
cuisImage64bit = (allCuisImageFiles.sort {|x,y| x.size <=> y.size })[0]
# 'imageName' will be something like: "Cuis5.0-4689"
imageName = cuisImage64bit.sub(/\.image/,'')
# check if my copy of the original file ".changes" already exist
# if not, make it 
if File.file? "original-#{imageName}.changes" then 
  nil
else
  FileUtils.cp("#{imageName}.changes", "original-#{imageName}.changes")
end 

# . remove all  'Cuis-xxx.changes' file 
# toDelete = Dir.glob "#{imageName}*.changes"
# puts "Deleting: #{toDelete}"
# FileUtils.rm toDelete

# . run cuis 
Dir.chdir '../'
puts "Running Cuis base config + veryBigFonts ... "
system("./sqcogspur64linuxht/squeak", "Cuis-Smalltalk-Dev/#{cuisImage64bit}", "-d", "Preferences veryBigFonts." )



