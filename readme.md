# Easy renaming large numbers of files automatically from a simple list

During recording, take notes of files in sequence to be renamed and what info to add to their filenames. Then run all renames at once after copying files from camera to PC.
Change strings before and after partofline on definition of $file to mirror the actual files produced by the camera each time.

The script run is:

```PowerShell
foreach ($line in Get-Content .\filecodes.txt) {
    $partofline = $line -split " => "
    $file = "9C9A9" + $partofline[0] + ".MOV"
    Get-ChildItem $file | Rename-Item -newname { $partofline[1] + " - Arquivo " + $_.Name }
}
````
<img alt="gif showing renaming happening automatically" height="300" src="https://github.com/DDanDev/batch-renaming-video-files-from-cameras/raw/main/script%20rename.gif" />

If needed, undo with following oneliner on terminal cli:
```PowerShell
dir -filter *.mov | rename-item -newname {$_.Name.Substring($_.Name.IndexOf(" - Arquivo ")+(" - Arquivo ").length)}
```

___

The file filecodes.txt should be in the same root directory as script is being run from. It will be a list of info to add to each file name, that will be taken note of during filming using any phone or whatever text app. It should look something like this:

```
672 => look 1 Belt s090
673 => look 1 discard this
674 => look 2 Dress s080
675 => look 2 discard this
676 => look 3 Shirt s050
677 => look 4 Skirt s852
678 => anything I might wanna add to that file name
```

If needed, a simple one liner can then easily delete all files with "discard" for example or we can simply remove or ignore them from the media pool in the video editor.

---------
The script file also contains a lot of commented one-liners that can be useful for renaming directories and files when working with large collections of video downloaded from camera memory systems and/or organized in a file structure by someone else. Anyone reading this can take those as starting points and make happen what they actually need in their own scenario they're dealing with.
