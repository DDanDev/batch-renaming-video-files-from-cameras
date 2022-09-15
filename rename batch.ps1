#Take notes of files in sequence to be renamed and what info to add to their filenames, then run all renames at once after copying files from camera to PC.
#Change strings before and after partofline on definition of $file to mirror the actual files produced by the camera each time.

foreach ($line in Get-Content .\filecodes.txt) {
    $partofline = $line -split " => "
    $file = "9C9A9" + $partofline[0] + ".MOV"
    Get-ChildItem $file | Rename-Item -newname { $partofline[1] + " - Arquivo " + $_.Name }
}


# undo with:
# dir -filter *.mov | rename-item -newname {$_.Name.Substring($_.Name.IndexOf(" - Arquivo ")+(" - Arquivo ").length)}

#The file filecodes.txt will be a list of info to add to each file name, that will be taken note of during filming using any phone or whatever text app. It should look something like this:
#672 => look 1 Belt s090
#673 => look 1 discard this
#674 => look 2 Dress s080
#675 => look 2 discard this
#676 => look 3 Shirt s050
#677 => look 4 Skirt s852
#678 => anything I might wanna add to that file name

#A one liner can then easily delete all files with "discard" for example or simply remove them from the media pool in the video editor.

#-------------------------------------------------
#-------------------------------------------------
#Following are one-liners for when they send me the files in folders, and the product codes are on the folder names. Structure is root/look #/Product code number/video files. When there are multiplie product codes within one look# it means each must zoom in to different products that appear on video. Otherwise it's pretty obvious and usually all clothes as a group sold together or single piece product. Other than that, product code folders with two video files means these videos must be stitched together because they were filmed with clamps on the front of the model in one video and on her back in another. These clamps cannot appear on final edit.

#####Turn all characters + into _
# (dir) | rename-item -newname { $_.Name -replace "\+", "_" }

##### 1 - delete all desktop.ini and .ds_Store and remove all weird attributes
# attrib -s -h -a -r -o -i -x -p -u /s /d
# (dir -recurse -filter desktop.ini) | ri
# (dir -recurse -filter .DS_Store) | ri

#####2 - Delete all empty folders. GetFiles('search string criteria', 1= recursive 0=not recursive)
# (dir -Recurse -Directory) | Where-Object { $_.GetFiles('*',1).Count -eq 0} | Remove-Item -Recurse

#####2.2 - Remove (1) duplicate folders that had empty version. ? is alias for where-object and filters the pipeline objects.
# (dir -recurse -directory) | ? { $_.Name.IndexOf(' (1)') -gt 0 } | rename-item -newname {$_.Name -replace ' \(1\)','' }


#####3 - Add Presilha to all folders with 2 files in same folder
# (dir -Recurse -Directory) | ? { $_.GetFiles('*.mov',0).Count -eq 2} | Rename-Item -newname {$_.Name + ' Presilha'}
#####3.2 - Add Presilha to folders containing folders with Presilha
# (dir -directory) | ? { $_.GetDirectories('*Presilha',0).Count -gt 0 } | rename-item -newname {$_.Name + ' Presilha' }
#####3.3 - Exception to verify by hand, mark folders with more than 2 files
# (dir -Recurse -Directory) | Where-Object { $_.GetFiles('*.mov',0).Count -gt 2} | Rename-Item -newname {$_.Name + ' GT2Files'}
#####3.4 - GT2 on parent-parent folders too
# (dir -directory) | ? { $_.GetDirectories('*GT2Files',0).Count -gt 0 } | rename-item -newname {$_.Name + ' GT2Files' }
#####3.5 - add 2Pieces to parent folders with two folders inside, and exception gt2
# (dir -directory) | ? { $_.GetDirectories('*',0).Count -eq 2 } | rename-item -newname {$_.Name + ' 2Pieces' }
# (dir -directory) | ? { $_.GetDirectories('*',0).Count -gt 2 } | rename-item -newname {$_.Name + ' GT2Pieces' }


#####4 - Name all .mov with look folder name + code number name. Names file with full path ignoring the path up to the root folder from where the command is run. Also removes gt2files and presilha redundancy from code folder + look folders both having the tags.
# (dir -recurse -filter *.mov) | rename-item -newname { (((((($_.Directory.Fullname -replace '\\',' _ ') -replace '\:','') -replace ((($pwd -replace '\\',' _ ') -replace '\:','') + ' _ '),'') + ' - Arquivo ') -replace ' Presilha - Arquivo ',' - Arquivo ') -replace ' GT2Files - Arquivo ',' - Arquivo ') + $_.Name }

##### On rendered files. Replace .mp4 / .mov accordingly and version number.
# (dir -filter *.mov) | rename-item -newname { $_.Name.Substring(0, $_.Name.IndexOf(" - Arquivo")) + " v1" + $_.Name.Substring($_.Name.Length - 4) } 
# (dir -filter *.mp4) | rename-item -newname { $_.Name -replace ' GT2Pieces','' }
# (dir -filter *.mp4) | rename-item -newname { $_.Name -replace ' Presilha','' }
# (dir -filter *.mp4) | rename-item -newname { $_.Name -replace ' 2Pieces','' }