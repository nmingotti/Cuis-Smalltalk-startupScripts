#!/usr/bin/ruby

require 'fileutils' 

=begin

-] TODO. i don't want too many log files
-] TODO. i don't want too many changes files

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
 Preferences standardFonts .

 "-] open a Workspace "
 Workspace openWorkspace. 

 "-] Install newest updates still not in the image, in: CoreUpdates "
 ChangeSet installNewUpdates.

 "-] Corrct wheel mouse scrolling bug related to the VM. " 
 "   not necessary if using VM release: 202003021730 "
 " Smalltalk sendMouseWheelEvents: false. "

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
  Preferences disable: #checkLostChangesOnStartUp. 
  Preferences disable: #askConfirmationOnQuit. 

  ". I want to hide by default the taskbar "
  self runningWorld hideTaskbar.

  " . ----- my ChangeSets, if necessary -------------- "
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

