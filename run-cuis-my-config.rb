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

# ==================================================
# ==== Cuis Startup Configuration 
# ==================================================
# . cuis config string. To avoid making another file 
#   this is Smalltalk code. 
cuisConfig = %q@

" . The block+value is for making a local variables context "
 
[ |list tbar area morph vmDir pathStr1 file1 fileoutDir| 

 "-] suggested by Hilaire on the mailing list. 
     without this the existing morph on boot do not get cancelled.
 "
 self runningWorld doOneCycle.

 "-] get rid of all the morph except taskbar "
 list _ UISupervisor ui submorphs reject: [ :aMo | aMo is: #TaskbarMorph ].
 list do: [ :x | x delete ] .

 "-] font size i like" 
 Preferences veryBigFonts .

 "-] open a Workspace "
 Workspace openWorkspace. 

 "-] Install newest updates still not in the image, in: CoreUpdates "
 ChangeSet installNewUpdates.

 "-] Install fature "
 Feature require: 'WebClient'.    
 Feature require: 'JSON'. 
 Feature require: 'OSProcess'.
 Feature require: 'TerseGuide'.
 " Feature require: 'StyledText'. "
 Feature require: 'SqueakCompatibility'. 
 Feature require: 'CommandShell'.
 Feature require: 'Regex'. 


 " TODO -- font, monospace. "

  ". Set my user, it is asked when you do edits. "
  Utilities setAuthorName: 'Nicola Mingotti' initials: 'NM'. 
 
  ". When I quit I don't want to be asked to save the image. "
  " Preferences disable: #askForSaveOnQuit.     "

  " . ----- my ChangeSets -------------- "
  ". when i quit i don't want to be asked to save packages . " 
  " fileoutDir _(DirectoryEntry smalltalkImageDirectory parent asString, '/fileout-to-keep') asDirectoryEntry . "
  " ChangeSet install: (fileoutDir fileMatching: '*NicolaMingotti-2021Aug15-12h20m*.cs.st' ). "

 "-] At the end do a Restore Display to redraw the World. " 
 UISupervisor ui restoreDisplay .

] value.

@

# ==================================================
# ==================================================


# . run cuis 
Dir.chdir '../'
# cmd = %q{
# ./sqcogspur64linuxht/squeak Cuis-Smalltalk-Dev/Cuis5.0-4689.image -d 'Preferences veryBigFonts.' 
# }
puts "Running Cuis with configuration string ... "
system("./sqcogspur64linuxht/squeak", "Cuis-Smalltalk-Dev/#{cuisImage64bit}", "-d", cuisConfig )

