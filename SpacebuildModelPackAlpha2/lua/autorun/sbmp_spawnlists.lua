function SpaceBuild_SVN_Init()
if CLIENT then //Make's sure this is running on the client, we don't want dedicated servers doing this.
	if file.Exists("../settings/spawnlist/[smallbridge]corridors, dw.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]corridors, dw.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]corridors, sw.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]corridors, sw.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]elevator parts, large.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]elevator parts, large.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]elevator parts, small.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]elevator parts, small.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]hangars.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]hangars.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]height transfer.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]height transfer.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]panels.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]panels.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]ship parts.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]ship parts.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]ships.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]ship parts.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]splitters.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]splitters.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]station parts.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]station parts.txt" )
	end
	if file.Exists("../settings/spawnlist/[smallbridge]wings, walkways and other parts.txt") then
		file.Delete( "../settings/spawnlist/[smallbridge]wings.txt" )
	end
	if file.Exists("../settings/spawnlist/[SBMP]Slyfo.txt") then
		file.Delete( "../settings/spawnlist/[SBMP]Slyfo.txt" )
	end
	if file.Exists("../settings/spawnlist/[SBMP] WALKWAYS.txt") then
		file.Delete( "../settings/spawnlist/[SBMP] WALKWAYS.txt" )
	end
	if file.Exists("../settings/spawnlist/[SBMP] SHIP MODULES.txt") then
		file.Delete( "../settings/spawnlist/[SBMP] SHIP MODULES.txt" )
	end
	if file.Exists("../settings/spawnlist/[SBMP] MISCELLANEOUS.txt") then
		file.Delete( "../settings/spawnlist/[SBMP] MISCELLANEOUS.txt" )
	end
end
end
hook.Add( "InitPostEntity", "SBMP Cleanup", SpaceBuild_SVN_Init );