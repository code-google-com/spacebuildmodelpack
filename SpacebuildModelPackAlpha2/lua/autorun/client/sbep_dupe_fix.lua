SBEP = SBEP or {}
--fill table from file
--not run on execution as you don't always need to fix dupes
--is a console command in case you made changes and want to try it real-time
function SBEP_LoadReplaceTable()
	print("Loading Filename Changes")
	local repTab = {}
	local tableString = file.Read("../Smallbridge Filename Changes.txt")
	local tableRows = string.Explode("\n",tableString)
	for _,row in pairs(tableRows) do
		--returns the pair of strings matched by this pattern
		--currently only finds models, if we change entity names as well this will need changing
		old,new = string.match(row, "^[ \t]*(models/[0-9A-Za-z/,]*.mdl)[ \t]*\|[ \t]*(models/[0-9A-Za-z/,]*.mdl)[ \t]*$")
		if (old and new) then
			repTab[old] = new
		end
	end
	SBEP_ReplaceTable = repTab
	SBEP.ReplaceTable = repTab
end
SBEP.LoadReplaceTable = SBEP_LoadReplaceTable
concommand.Add("SBEP_LoadReplaceTable",SBEP.LoadReplaceTable)

--replaces all instances of models in the replace table with 
function SBEP_FixDupe(player,command,args)
	--if the replace table hasn't been made yet, remake it
	if not SBEP.ReplaceTable then
		SBEP.LoadReplaceTable()
	end
	--print("FixDupe called")
	local filePath = args[1]
	--print("File Path = ",filePath)
	local fileString = file.Read(filePath)
	for old,new in pairs(SBEP.ReplaceTable) do
		--print("Replacing "..old.." with "..new)
		fileString = string.Replace(fileString,old,new)
		fileString = string.Replace(fileString,string.lower(old),new)
	end
	file.Write(filePath,fileString)
	print(filePath.." fixed.")
end
SBEP.FixDupe = SBEP_FixDupe
concommand.Add("SBEP_FixDupe",SBEP.FixDupe)

function SBEP_RecursiveFix(player,command,args)
	--print("Recursive Fix Called")
	local dir = args[1]
	--print("Directories Found: ")
	local dirs = file.FindDir(dir.."/*")
	--PrintTable(dirs)
	for _,dirPath in pairs(dirs) do
		SBEP_RecursiveFix(player,command,{dir.."/"..dirPath})
	end
	--print("Files Found: ")
	local files = file.Find(dir.."/*")
	--PrintTable(files)
	for _,filePath in pairs(files) do
		if (string.GetExtensionFromFilename(filePath) == "txt") then
			SBEP.FixDupe(player,command,{dir.."/"..filePath})
		end
	end
end
SBEP.RecursiveFix = SBEP_RecursiveFix
concommand.Add("SBEP_FixDupeFolder",SBEP.RecursiveFix)

function SBEP_FixAllDupes(player,command)
	--print("Fix Dupes Called")
	SBEP.RecursiveFix(player,command,{"adv_duplicator"})
end
SBEP.FixAllDupes = SBEP_FixAllDupes
concommand.Add("SBEP_FixAllDupes",SBEP.FixAllDupes)
