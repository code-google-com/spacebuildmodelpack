# Details #

quick reference
  * Texture wise you have to use multi-sub object, even if your model only has one texture, point to a file named the same as the VMF of the final texture, doesn't need to be VMT or VMF, just the same name.
  * Collistion is done based on smoothing groups, each smoothing group is a different 'convex collistion mesh' i'm sure you understand the idea behind that.
  * you may notice there is only 32 smoothing groups, try to keep within that for collistions, if however it's not possible you can go above that, just split the object into TWO editable meshes insted of one, and set the same smoothing group on both, however two smoothing groups of the same number CANNOT touch, else they will merge, and if they go non-convex we all die.
  * you need to export three models, one for graphics (smoothing works in source btw), one for collistions (with mentaly retarded smoothing groups), and one Animation reference (or sequence file) normaly just one frame of blankness.
  * Finally You dont need bones for anything, apart from vehicles, however if you do apply them use a physiqe modifer on the very base bone, and have all the bones after that come off that one bone (see the strange ball, or neopod ragdoll)
  * you can find the tools you need to export and stuff [Here](ToolSet.md)