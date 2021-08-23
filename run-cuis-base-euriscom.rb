#!/usr/bin/ruby

require 'fileutils' 

=begin

-] TODO. I don't want too many log files
-] TODO. I don't want too many changes files

=end 


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
puts "Running Cuis base config + standardFonts ... "
system("./sqcogspur64linuxht/squeak", "Cuis-Smalltalk-Dev/#{cuisImage64bit}", "-d", "Preferences standardFonts." )



