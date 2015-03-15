# Introduction #
This page explains how to install the test version of the pack, how to update it, how to commit to it, And how to spawn props not in the spawn menu, it also explains how to report bugs.

# Links #
  * If you need an explanation of the SVN folder layout, please read [Here](DevFolderLayout.md)
  * If you need an explanation of what you should be doing, please read [Here](DevProductionGuide.md)
  * There is a list of handy tools [Here](ToolSet.md)
  * 3ds tips are [here](Maxguide.md)
  * A list of measurements for player movement is [Here](http://developer.valvesoftware.com/wiki/Unit)

# How to install The SVN version #
You will need a SVN client, such as [TortoiseSVN](http://tortoisesvn.tigris.org), you must then create a new folder in your documents folder, and right click it, select the SVN checkout option.
In the box asking for a URL enter
```
https://spacebuildmodelpack.googlecode.com/svn/trunk/
```
Under username enter your Gmail account name, mine would be DarthPJB ( **not** DarthPJB@gmail.com)
For your password you will need to enter your googlecode password, this is a password that only you have access to and can be found [Here on the googlecode settings page](http://code.google.com/hosting/settings)
Click Ok and it will install the latest version of our work.

When it's finished copy the folder called 'AlphaModelpack' to your Garrysmod/addons folder
Before you copy the folder make sure you also:
  * delete any previous versions of the addon (or SVN versions of the addon)
  * delete all files starting with the name 'spacebuild' in the garrysmod/garrysmod/settings/spawnlists/ folder
  * Remove any and all other traces of the old addon, and ensure you copy to a folder in addons, and not a sub folder. to be extra sure check the folder has an info.txt file in it.

Suggested options:
  * in your folder explore window (windows users), select 'tools menu'/'folder options', on the 'view' tab un-check the 'hide protected operating system files', and 'hide file extensions for known file types' options, and select 'show hidden files and folders' options.

# How To commit changes to the SVN version #
After making a change to the SVN (by adding files or alike, or editing existing files) you may wish to update the SVN (best done regularly)
  * Right click the folder in my documents
  * Select SVN Commit
  * Wait for the changes to be added and uploaded
  * Click OK

# How to update the SVN version #
  * Right click on the model pack addon folder you made before, and select 'SVN Update'
  * Wait for the update to finish then click OK

# How to update the SVN version of the addon (after committing changes from the main folder) #
  * Right click on the model pack addon folder you copied before, and select 'SVN Update'
  * Wait for the update to finish then click OK

Make sure you Also:
  * delete all files starting with the name 'spacebuild' in the garrysmod/garrysmod/settings/spawnlists/ folder


# Spawning new props not in the spawnlist #
see [Spawning non lists props](Spawning.md)

# If you find a bug #
Please follow the [bug reporting guide](bugs.md)