# EncoreJsonExporter
An Aseprite script that allows you to export JSON files containing animation data to be used for MOTHER: Encore. 
It includes things such as Tags, Frame Lengths, Repeats and Animation Directions.

## How to set up the script

Firstly, you will need to set up the script in order to use it in Aseprite. To do so, follow these simple steps:

1. 	Open Aseprite.

2. 	In the navbar menu at the top navigate to File > Scripts > Open Scripts Folder. 

<img width="498" height="430" alt="image" src="https://github.com/user-attachments/assets/b8cdd597-19ed-41ce-8598-b4319ea057e5" />


3. 	Take the _modules folder and the EncoreJsonExporter.lua file and move them 
    into the Aseprite scripts folder which you have opened previously.

<img width="490" height="378" alt="image" src="https://github.com/user-attachments/assets/0ad3232e-7f35-468d-8bb4-8e40aa159336" />

4. 	In Aseprite, rescan the scripts by pressing File > Scripts > Rescan Scripts Folder.

<img width="487" height="382" alt="image" src="https://github.com/user-attachments/assets/5a7ec826-7e89-440e-9766-c6fce442b362" />

5. (OPTIONAL) Finally, you can add a keyboard shortcut to the script to use the script a lot faster. 
Just press "CTRL+ALT+SHIFT+K", and search for "EncoreJsonExporter" to find the script.

<img width="1433" height="201" alt="image" src="https://github.com/user-attachments/assets/2b0a4419-b351-44fa-9928-5c715245242c" />


## How to use the script

Awesome! So you have set up the script, but how do we use it?
Well luckily, using the script is pretty simple.

Firstly, you will need to add Tags to your Aseprite animation. 
Each Tag will represent one Animation present in the Spritesheet you export. 

If you don't know how to make a Tag on Aseprite, highlight the frames you want in the animation timeline, right click, and select "New Tag".

<img width="1405" height="273" alt="image" src="https://github.com/user-attachments/assets/92fae45b-210c-426b-9a2f-482e2127287a" />

The script will be able to detect animation data such as the **Animation Direction** as well as the **Repeat** count.
So make SURE those are set correctly.

If you have multiple tags of the same name, each tag will represent a different direction that the character will face.
In order from left to right, these tags will be:
1. Down
2. Left
3. Right
4. Up
5. Down + Left
6. Down + Right
7. Up + Left
8. Up + Right

<img width="446" height="136" alt="image" src="https://github.com/user-attachments/assets/14c5371f-f969-438b-824e-166998d9ae17" />


However, if you only have **two** tags of the same name, it will be:
1. Left
2. Right

After setting up your tags correctly, you can then use the script to export the json.

To use the script, go to File > Scripts > JsonExporter. Then it's as simple as filling in the fields.

<img width="500" height="297" alt="image" src="https://github.com/user-attachments/assets/46dd02df-9b63-474f-8dbd-4f173d235411" />

**Json Path:** The path of the exported JSON.

**Horizontal Frames:** The number of columns on the exported spritesheet.

**Vertical Frames:** The number of rows on the exported spritesheet.

**X/Y Offset:** The offset of the sprite.

**Merge Duplicate Frames:** Whether the JSON should use the same index for duplicate frames or not. If you choose to merge duplicate frames, make sure to export the sprite sheet with duplicate frames merged as well.

Finally, right now Encore reads animation data from YAML files, so you'll have to convert the exported JSON into a YAML file. 
Usually you can just search "JSON to YAML converter" online and convert it there. 
We'll probably change it in the future so that you don't need to convert it to YAML.
