# Introduction #
This page explains how to install the test version of the pack, how to update it, And how to spawn props not in the spawn menu, it also explains how to report bugs.

# How to install The SVN version #
You will need a SVN client, such as [TortoiseSVN](http://tortoisesvn.tigris.org), you must then create a new folder in your garrysmod/garrysmod/addons folder, and right click it, select the SVN checkout option.
In the box asking for a URL enter
```
http://spacebuildmodelpack.googlecode.com/svn/trunk/SpacebuildModelPackAlpha2/
```
Click Ok and it will install the latest version.

Make sure you also:
  * delete any previous versions of the addon (or SVN versions of the addon) before checking out
  * delete all files starting with the name 'spacebuild' in the garrysmod/garrysmod/settings/spawnlists/ folder
  * Remove any and all other traces of the old addon, and ensure you checkout that exact URL to a NEW folder in addons, and not a sub folder. to be extra sure check the folder has an info.txt file in it.

Suggested options:
  * in your folder explore window (windows users), select 'tools menu'/'folder options', on the 'view' tab un-check the 'hide protected operating system files', and 'hide file extensions for known file types' options, and select 'show hidden files and folders' options.

# How to update the SVN version #
  * Right click on the model pack addon folder you made before, and select 'SVN Update'
  * Wait for the update to finish then click OK

Make sure you Also:
  * delete all files starting with the name 'spacebuild' in the garrysmod/garrysmod/settings/spawnlists/ folder

# Spawning new props not in the spawnlist #
see [Spawning non lists props](Spawning.md)

# If you find a bug #
Please follow the [bug reporting guide](bugs.md)