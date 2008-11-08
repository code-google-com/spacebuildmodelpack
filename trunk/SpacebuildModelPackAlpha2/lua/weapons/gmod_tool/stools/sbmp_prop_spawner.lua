TOOL.Category = 'SBMP' 
TOOL.Name = '#SBMP Prop Spawner'
TOOL.Command = nil
TOOL.ConfigName = ''

TOOL.ClientConVar[ "SkinNumber" ]       = "1" 
TOOL.ClientConVar[ "glass" ]            = "1"
TOOL.ClientConVar[ "Habitable_Module" ] = "1"

if SERVER then return end

local SBMP_Models = {}

language.Add( "Tool_sbmp_prop_spawner_name" , "SBMP Prop Spawner Tool" )
language.Add( "Tool_sbmp_prop_spawner_desc" , "Easily find and spawn SBMP props." )
language.Add( "Tool_sbmp_prop_spawner_0", "Left click to spawn the selected prop." )

local function DrawIcons()
	for l, n in pairs(SBMP_Models.ALLMODELS) do
		for k, v in pairs(n) do
			if (v[1] != "blank") then
				if (((l == 3) || (l == 4)) && (v[2] == 1))then
					if (k % 4) == 1 then
						v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
					else
						v[3]:SetImage( "SmallBridge/Spawnicons/SBelevator_"..tostring((k - 1) % 4) )
						v[3].DoClick = 	function()
											if v[2] > 0 then
												ValA = 0
												ValB = 1
											else
												ValA = 1
												ValB = 0
											end
											RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/"..v[1].."/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
											Msg("Spawned 1 "..v[1]..".\n")
										end
					end
				elseif l == 14 then
					v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
					v[3].DoClick = 	function()
										if v[2] > 0 then
											ValA = 0
											ValB = 1
										else
											ValA = 1
											ValB = 0
										end
										RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/Ships/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
										Msg("Spawned 1 "..v[1]..".\n")
									end
				else
					v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
					v[3].DoClick = 	function()
										if v[2] > 0 then
											ValA = 0
											ValB = 1
										else
											ValA = 1
											ValB = 0
										end
										RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/"..v[1].."/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
										Msg("Spawned 1 "..v[1]..".\n")
									end
				end
			end
		end
	end
	
	SBMPBanner:SetImage( "SmallBridge/Spawnicons/banner_"..SkinValue )
end

SBMP_Models.CorridorsSWmodels = {}
	SBMP_Models.CorridorsSWmodels[1]  = {"SBcorridorE1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[2]  = {"SBcorridorR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[3]  = {"SBcorridorT" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[4]  = {"SBcorridorX" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[5]  = {"SBcorridorE05" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[6]  = {"SBcorridorE2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[7]  = {"SBcorridorE3" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[8]  = {"SBcorridorE4" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[9]  = {"SBcorridorEnd" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[10] = {"SBcorridorEFlip" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[11] = {"SBcorridorRtri" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[12] = {"SBcorridorCurveS" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[13] = {"SBcorridorEdh" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[14] = {"SBcorridorEdh2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[15] = {"SBcorridorEdh3" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[16] = {"SBcorridorEdh4" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[17] = {"SBcorridorSlantL" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[18] = {"SBcorridorSlantR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[19] = {"SBcorridorSlanthalfL" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[20] = {"SBcorridorSlanthalfR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[21] = {"SBcorridorTdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[22] = {"SBcorridorTdldw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[23] = {"SBcorridorXdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[24] = {"SBcorridorXdldw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[25] = {"SBtriangleE1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[26] = {"SBtriangleE2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsSWmodels[27] = {"SBtriangleE3" , 1 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.CorridorsDWmodels = {}
	SBMP_Models.CorridorsDWmodels[1]  = {"SBcorridorEdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[2]  = {"SBcorridorRdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[3]  = {"SBcorridorTdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[4]  = {"SBcorridorXdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[5]  = {"SBcorridorEdw05" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[6]  = {"SBcorridorEdw2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[7]  = {"SBcorridorEdw3" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[8]  = {"SBcorridorEdw4" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[9]  = {"SBcorridorEnddw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[10] = {"SBcorridorEnddw2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[11] = {"SBcorridorFlipdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[12] = {"blank" }
	SBMP_Models.CorridorsDWmodels[13] = {"SBcorridorEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[14] = {"SBcorridorEdhdw2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[15] = {"SBcorridorEdhdw3" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[16] = {"SBcorridorEdhdw4" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[17] = {"SBcorridorTdwdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[18] = {"SBcorridorTdwsl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.CorridorsDWmodels[19] = {"SBcorridorXdwdl" , 1 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.ElevatorSmallmodels = {}
	SBMP_Models.ElevatorSmallmodels[1]  = { "SBcorridorEnd" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[2]  = { "SBelevBase" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[3]  = { "SBelevMid" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[4]  = { "SBelevTop" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[5]  = { "SBcorridorE1" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[6]  = { "SBelevBaseE" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[7]  = { "SBelevMidE" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[8]  = { "SBelevTopE" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[9]  = { "SBcorridorR" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[10] = { "SBelevBaseR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[11] = { "SBelevMidR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[12] = { "SBelevTopR" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[13] = { "SBcorridorT" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[14] = { "SBelevBaseT" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[15] = { "SBelevMidT" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[16] = { "SBelevTopT" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[17] = { "SBcorridorX" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[18] = { "SBelevBaseX" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[19] = { "SBelevMidX" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[20] = { "SBelevTopX" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[21] = { "SBcorridorEdh" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[22] = { "SBelevBaseEdh" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[23] = { "SBelevMidEdh" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[24] = { "SBelevTopEdh" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[25] = { "SBcorridorEdw" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorSmallmodels[26] = { "SBelevBaseEdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[27] = { "SBelevMidEdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[28] = { "SBelevTopEdl" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[29] = { "SBelevShaft" , 2 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[30] = { "SBelevShaft2" , 2 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[31] = { "SBpanelelev0s" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[32] = { "SBpanelelev1s" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[33] = { "SBpanelelev2s" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[34] = { "SBpanelelev2sE" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorSmallmodels[35] = { "SBpanelelev3s" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.ElevatorLargemodels = {}
	SBMP_Models.ElevatorLargemodels[1]  = { "SBcorridorEnddw2" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[2]  = { "SBelevBasedw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[3]  = { "SBelevMiddw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[4]  = { "SBelevTopdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[5]  = { "SBcorridorEdw2" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[6]  = { "SBelevBaseEdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[7]  = { "SBelevMidEdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[8]  = { "SBelevTopEdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[9]  = { "SBcorridorRdw" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[10] = { "SBelevBaseRdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[11] = { "SBelevMidRdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[12] = { "SBelevTopRdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[13] = { "SBcorridorTdw" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[14] = { "SBelevBaseTdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[15] = { "SBelevMidTdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[16] = { "SBelevTopTdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[17] = { "SBcorridorXdw" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[18] = { "SBelevBaseXdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[19] = { "SBelevMidXdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[20] = { "SBelevTopXdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[21] = { "SBcorridorEdhdw2" , 1 , vgui.Create( "DImage" ) }
	SBMP_Models.ElevatorLargemodels[22] = { "SBelevBaseEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[23] = { "SBelevMidEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[24] = { "SBelevTopEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[25] = { "SBelevShaftdw" , 2 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[26] = { "SBelevShaftdw2" , 2 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[27] = { "SBpanelelev0sdw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[28] = { "SBpanelelev1sdw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[29] = { "SBpanelelev2sdw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[30] = { "SBpanelelev2sEdw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ElevatorLargemodels[31] = { "SBpanelelev3sdw" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.ShipPartsmodels = {}
	SBMP_Models.ShipPartsmodels[1]  = { "SBbridge1s" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[2]  = { "SBbridgeO1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[3]  = { "SBbridgeO1base" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[4]  = { "SBbridgeO1cover" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[5]  = { "SBenginesw1Ls" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[6]  = { "SBenginesw1Ms" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[7]  = { "SBenginesw1Rs" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[8]  = { "SBenginedw1s" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[9]  = { "SBengine1s" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[10] = { "SBengine3" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[11] = { "blank" }
	SBMP_Models.ShipPartsmodels[12] = { "blank" }
	SBMP_Models.ShipPartsmodels[13] = { "SBengine2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[14] = { "SBengine2B" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[15] = { "SBengine2Bramp" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[16] = { "blank" }
	SBMP_Models.ShipPartsmodels[17] = { "SBhullEdoors" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[18] = { "SBhullEdoors2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[19] = { "SBhullEdoorsdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[20] = { "SBhullEdoorsdw2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[21] = { "SBhulldoors" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[22] = { "SBhullTdoors" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[23] = { "SBEdoorsN" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[24] = { "SBEdoorsN2" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[25] = { "SBlanddock1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[26] = { "SBlanddock1dw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[27] = { "SBlanddock1dwdh" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[28] = { "blank" }
	SBMP_Models.ShipPartsmodels[29] = { "SBlanddockramp1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[30] = { "SBlanddockramp1dw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.ShipPartsmodels[31] = { "SBlanddockramp1dwdh" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.HeightTransmodels = {}
	SBMP_Models.HeightTransmodels[1]  = { "SBcorridorRamp" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[2]  = { "SBcorridorRamphalf" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[3]  = { "blank" }
	SBMP_Models.HeightTransmodels[4]  = { "blank" }
	SBMP_Models.HeightTransmodels[5]  = { "SBsrampU" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[6]  = { "SBsrampM" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[7]  = { "SBsrampD" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[8]  = { "blank" }
	SBMP_Models.HeightTransmodels[9]  = { "SBsrampZ" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[10] = { "SBsrampZdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[11] = { "SBCRamp1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.HeightTransmodels[12] = { "SBCRamp2dwD" , 1 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.PanelsDoorsmodels = {}
	SBMP_Models.PanelsDoorsmodels[1]  = { "SBpanelSolidg" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[2]  = { "SBpanelDoor" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[3]  = { "SBpanelSquareDoor" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[4]  = { "SBpanelDoor2dw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[5]  = { "SBpanelSolidgdw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[6]  = { "SBpanelDoordw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[7]  = { "SBpanelSquareDoordw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[8]  = { "SBpanelwideDoor" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[9]  = { "SBpanelDH" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[10]  = { "SBpanelDHDW" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[11]  = { "SBpanelSquareDoordockin" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[12]  = { "SBpanelSquareDoordocko" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[13]  = { "SBdoor" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[14]  = { "SBdoorsquare" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.PanelsDoorsmodels[15]  = { "SBdoorwide" , 1 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.Splittersmodels = {}
	SBMP_Models.Splittersmodels[1]  = { "SBcorridorEStoDW" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[2]  = { "SBcorridorEStoDWangular" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[3]  = { "SBcorridorV" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[4]  = { "SBcorridorVwide" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[5]  = { "SBcorridorEDto2SW" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[6]  = { "SBcorridorE2SWto2SW" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[7]  = { "SBconverterSBtoMB" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[8]  = { "blank" }
	SBMP_Models.Splittersmodels[9]  = { "SBcorridorEStoDHup" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[10] = { "SBcorridorEStoDHmid" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[11] = { "SBcorridorEStoDHdo" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[12] = { "blank" }
	SBMP_Models.Splittersmodels[13] = { "SBcorridorEStoDHdwup" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[14] = { "SBcorridorEStoDHdwmid" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Splittersmodels[15] = { "SBcorridorEStoDHdwdo" , 1 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.Hangarsmodels = {}
	SBMP_Models.Hangarsmodels[1]  = { "SBdropbay1left" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[2]  = { "SBdropbay1leftS" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[3]  = { "SBdropbay1right" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[4]  = { "SBdropbay1rightS" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[5]  = { "SBdropbay1mid" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[6]  = { "SBdropbay1midD" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[7]  = { "SBdropbay1midE" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[8]  = { "blank" }
	SBMP_Models.Hangarsmodels[9]  = { "SBdropbay1S" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[10] = { "SBdropbay1Ss" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[11] = { "blank" }
	SBMP_Models.Hangarsmodels[12] = { "blank" }
	SBMP_Models.Hangarsmodels[13] = { "SBdropbay2left" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[14] = { "SBdropbay2mid" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[15] = { "SBdropbay2middw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[16] = { "SBdropbay2right" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[17] = { "SBdropbay2S" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[18] = { "blank" }
	SBMP_Models.Hangarsmodels[19] = { "blank" }
	SBMP_Models.Hangarsmodels[20] = { "blank" }
	SBMP_Models.Hangarsmodels[21] = { "SBdropbay3mid" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[22] = { "SBdropbay3middw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[23] = { "SBdropbay3midX" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[24] = { "SBdropbay3midXdw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[25] = { "SBdropbay3side" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[26] = { "SBdropbay3S" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[27] = { "blank" }
	SBMP_Models.Hangarsmodels[28] = { "blank" }
	SBMP_Models.Hangarsmodels[29] = { "SBdropbay4left" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[30] = { "SBdropbay4right" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[31] = { "SBdropbay4mid" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[32] = { "SBdropbay4middw" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[33] = { "SBdropbay4S" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Hangarsmodels[34] = { "SBdropbaycomplete1S" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.StationPartsmodels = {}
	SBMP_Models.StationPartsmodels[1]  = { "SBcommandBridge" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[2]  = { "SBcommandBridgedw" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[3]  = { "SBcommandBridgeElev" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[4]  = { "blank" }
	SBMP_Models.StationPartsmodels[5]  = { "SBvisorbridge1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[6]  = { "SBvisorcontrolTop" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[7]  = { "SBspherebridge1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[8]  = { "blank" }
	SBMP_Models.StationPartsmodels[9]  = { "SBcorridorSGC1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[10] = { "SBcorridorSGC2" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[11] = { "SBHUB" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[12] = { "SBocthub1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[13] = { "SBdock1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[14] = { "SBpodbay1" , 1 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[15] = { "blank" }
	SBMP_Models.StationPartsmodels[16] = { "blank" }
	SBMP_Models.StationPartsmodels[17] = { "SBhangardhdw1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[18] = { "SBhangardhdw1D" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[19] = { "SBhangardhdw1UD" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.StationPartsmodels[20] = { "SBhangardhdw2" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.Wingsmodels = {}
	SBMP_Models.Wingsmodels[1]  = { "SBwingS1L" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[2]  = { "SBwingS1R" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[3]  = { "SBwingM1L" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[4]  = { "SBwingM1R" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[5]  = { "SBwingM1Le" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[6]  = { "SBwingM1Re" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[7]  = { "SBwingC1L" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[8]  = { "SBwingC1R" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[9]  = { "SBwingLS1L" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Wingsmodels[10] = { "SBwingLS1R" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.Walkwaysmodels = {}
	SBMP_Models.Walkwaysmodels[1]  = {"SBwalkwayE" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Walkwaysmodels[2]  = {"SBwalkwayR" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Walkwaysmodels[3]  = {"SBwalkwayT" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Walkwaysmodels[4]  = {"SBwalkwayX" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Walkwaysmodels[5]  = {"SBwalkwayE2" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.OtherPartsmodels = {}
	SBMP_Models.OtherPartsmodels[1]  = {"SBconsole1s" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.OtherPartsmodels[2]  = {"SBconsole1low" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.OtherPartsmodels[3]  = {"SBconsoletop1" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.Shipsmodels = {}
	SBMP_Models.Shipsmodels[1]  = {"SBshuttleC1E1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[2]  = {"SBshuttleC1E2" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[3]  = {"SBshuttleC2E2" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[4]  = {"SBfrigate1" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[5]  = {"hysteria_galapagos" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[6]  = {"wilkie1020" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[7]  = {"steakknife" , 0 , vgui.Create( "DImageButton" ) }
	SBMP_Models.Shipsmodels[8]  = {"matthew0623_hydra" , 0 , vgui.Create( "DImageButton" ) }
	
SBMP_Models.ALLMODELS = {}
	SBMP_Models.ALLMODELS[1]  = SBMP_Models.CorridorsSWmodels
	SBMP_Models.ALLMODELS[2]  = SBMP_Models.CorridorsDWmodels
	SBMP_Models.ALLMODELS[3]  = SBMP_Models.ElevatorSmallmodels
	SBMP_Models.ALLMODELS[4]  = SBMP_Models.ElevatorLargemodels
	SBMP_Models.ALLMODELS[5]  = SBMP_Models.ShipPartsmodels
	SBMP_Models.ALLMODELS[6]  = SBMP_Models.HeightTransmodels
	SBMP_Models.ALLMODELS[7]  = SBMP_Models.PanelsDoorsmodels
	SBMP_Models.ALLMODELS[8]  = SBMP_Models.Splittersmodels
	SBMP_Models.ALLMODELS[9]  = SBMP_Models.Hangarsmodels
	SBMP_Models.ALLMODELS[10] = SBMP_Models.StationPartsmodels
	SBMP_Models.ALLMODELS[11] = SBMP_Models.Wingsmodels
	SBMP_Models.ALLMODELS[12] = SBMP_Models.Walkwaysmodels
	SBMP_Models.ALLMODELS[13] = SBMP_Models.OtherPartsmodels
	SBMP_Models.ALLMODELS[14] = SBMP_Models.Shipsmodels
	
   
SBMP_Models.CCSpawnlistTable = {}
	SBMP_Models.CCSpawnlistTable[1]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Corridors: Single Width"         , #SBMP_Models.CorridorsSWmodels   }
	SBMP_Models.CCSpawnlistTable[2]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Corridors: Double Width"         , #SBMP_Models.CorridorsDWmodels   }
	SBMP_Models.CCSpawnlistTable[3]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Elevator Parts: Small"           , #SBMP_Models.ElevatorSmallmodels }
	SBMP_Models.CCSpawnlistTable[4]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Elevator Parts: Large"           , #SBMP_Models.ElevatorLargemodels }
	SBMP_Models.CCSpawnlistTable[5]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Ship Parts"                      , #SBMP_Models.ShipPartsmodels     }
	SBMP_Models.CCSpawnlistTable[6]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Height Transfer"                 , #SBMP_Models.HeightTransmodels   }
	SBMP_Models.CCSpawnlistTable[7]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Panels and Doors"                , #SBMP_Models.PanelsDoorsmodels   }
	SBMP_Models.CCSpawnlistTable[8]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Splitters and Converters"        , #SBMP_Models.Splittersmodels     }
	SBMP_Models.CCSpawnlistTable[9]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Hangars"                         , #SBMP_Models.Hangarsmodels       }
	SBMP_Models.CCSpawnlistTable[10] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Station Parts"                   , #SBMP_Models.StationPartsmodels  }
	SBMP_Models.CCSpawnlistTable[11] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Wings"                           , #SBMP_Models.Wingsmodels         }
	SBMP_Models.CCSpawnlistTable[12] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Walkways"                        , #SBMP_Models.Walkwaysmodels      }
	SBMP_Models.CCSpawnlistTable[13] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Other Parts"                     , #SBMP_Models.OtherPartsmodels    }
	SBMP_Models.CCSpawnlistTable[14] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Ships and Shuttles"              , #SBMP_Models.Shipsmodels         }

local function SetSkinValue()
	SkinValue = GetConVarNumber( "sbmp_prop_spawner_SkinNumber" )
	if !(SkinValue > 0 && SkinValue < 5) then 
		SkinValue = 1 
		RunConsoleCommand( "sbmp_prop_spawner_SkinNumber" , "1" )
	end
	SkinValueNum = SkinValue - 1
	GlassNum = GetConVarNumber("sbmp_prop_spawner_glass")
	if GlassNum == 1 then
		NotGlassNum = 0
	else
		NotGlassNum = 1
	end
	SkinGlassValue = (SkinValue + ((SkinValue - 1) * NotGlassNum) + (SkinValue * GlassNum) - 1)
end

SetSkinValue()

if !GAMEMODE.IsSpacebuildDerived and (GetConVarNumber("sbmp_prop_spawner_Habitable_Module") != 0) then
		RunConsoleCommand( "sbmp_prop_spawner_Habitable_Module" , "0" )
end

local SBMPFrame = vgui.Create( "DFrame" )
SBMPFrame:SetPos( 50,50 )
SBMPFrame:SetSize( 446, 725 )
SBMPFrame:SetTitle( "SBMP Prop Spawner" )  
SBMPFrame:SetVisible( false )  
SBMPFrame:SetDraggable( true )
SBMPFrame:ShowCloseButton( false )
SBMPFrame:MakePopup()

local ModelTabsSheet = vgui.Create( "DPropertySheet" )  
ModelTabsSheet:SetParent( SBMPFrame )  
ModelTabsSheet:SetPos( 10, 30 )  
ModelTabsSheet:SetSize( 426, 685 )

local SmallBridgePanel = vgui.Create( "DPanel" )  
SmallBridgePanel:SetSize( 416,655 )
SmallBridgePanel.Paint = 	function()
								surface.SetDrawColor( 128, 128, 128, 255 )
								surface.DrawRect( 0, 0, SmallBridgePanel:GetWide(), SmallBridgePanel:GetTall() )
							end

local MedBridge2Panel = vgui.Create( "DPanel" )  
MedBridge2Panel:SetSize( 450,655 )
MedBridge2Panel.Paint = 	function()
								surface.SetDrawColor( 128, 128, 128, 255 )
								surface.DrawRect( 0, 0, MedBridge2Panel:GetWide(), MedBridge2Panel:GetTall() )
							end

local SlyfoPanel = vgui.Create( "DPanel" )  
SlyfoPanel:SetSize( 450,655 )
SlyfoPanel.Paint = 	function()
						surface.SetDrawColor( 128, 128, 128, 255 )
						surface.DrawRect( 0, 0, SlyfoPanel:GetWide(), SlyfoPanel:GetTall() )
					end 

ModelTabsSheet:AddSheet( "SmallBridge", SmallBridgePanel     , "gui/silkicons/user"  , false , false , "All Hysteria's SmallBridge Props" )  
ModelTabsSheet:AddSheet( "MedBridge2" , MedBridge2Panel   , "gui/silkicons/group" , false , false , "All GlenSkunk's MedBridge2 Props" ) 
ModelTabsSheet:AddSheet( "Slyfo"      , SlyfoPanel , "gui/silkicons/group" , false , false , "All Slyfo's MedBridge2 Props" )

local SmallBridgeOptionsPanel = vgui.Create( "DPanel" , SmallBridgePanel )
SmallBridgeOptionsPanel:SetPos( 5,5 ) 
SmallBridgeOptionsPanel:SetSize( 100,609 )
SmallBridgeOptionsPanel.Paint = 	function()
										surface.SetDrawColor( 50, 50, 50, 255 )
										surface.DrawRect( 0, 0, SmallBridgeOptionsPanel:GetWide(), SmallBridgeOptionsPanel:GetTall() )
									end 

local SmallBridgePropsPanel = vgui.Create( "DPanelList" , SmallBridgePanel )
SmallBridgePropsPanel:SetPos( 110,5 ) 
SmallBridgePropsPanel:SetSize( 301,609 )
SmallBridgePropsPanel:SetSpacing( 10 )
SmallBridgePropsPanel:EnableHorizontal( false )
SmallBridgePropsPanel:EnableVerticalScrollbar( true )
SmallBridgePropsPanel.Paint = 	function()
									surface.SetDrawColor( 50, 50, 50, 255 )
									surface.DrawRect( 0, 0, SmallBridgePropsPanel:GetWide(), SmallBridgePropsPanel:GetTall() )
								end


local GlassCheckBox = vgui.Create( "DCheckBoxLabel", SmallBridgeOptionsPanel )  
GlassCheckBox:SetPos( 10, 120 )  
GlassCheckBox:SetText( "Windows" )  
GlassCheckBox:SetConVar( "sbmp_prop_spawner_glass" )
GlassCheckBox:SetValue( GetConVarNumber("sbmp_prop_spawner_glass") )
GlassCheckBox:SizeToContents()
GlassCheckBox.OnChange = function()
							SetSkinValue()
							DrawIcons()
						end
	
if GAMEMODE.IsSpacebuildDerived then
	local HabitableCheckBox = vgui.Create( "DCheckBoxLabel", SmallBridgeOptionsPanel )  
	HabitableCheckBox:SetPos( 10, 140 )  
	HabitableCheckBox:SetSize( 90, 30 ) 
	HabitableCheckBox:SetText( "Habitable\nLS Module" )  
	HabitableCheckBox:SetConVar( "sbmp_prop_spawner_Habitable_Module" )
	HabitableCheckBox:SetValue( GetConVarNumber( "sbmp_prop_spawner_Habitable_Module" ) ) 
end
	
local UndoButton = vgui.Create( "DButton", SmallBridgeOptionsPanel )  	
UndoButton:SetSize( 80, 25 )
UndoButton:SetPos( 10, 180 )
UndoButton:SetText( "Undo" )
UndoButton.DoClick = 	function()  		
							RunConsoleCommand("undo" , "" )
						end  

/*-----------------------------------------------------------------------
MaxButton = vgui.Create( "DButton", SmallBridgeOptionsPanel )  	
MaxButton:SetSize( 80, 25 )
MaxButton:SetPos( 10, 205 )
MaxButton:SetText( "Maximise All" )
MaxButton.DoClick = 	function()
							for k, v in pairs(SBMP_Models.CCSpawnlistTable) do
								if SBMP_Models.CCSpawnlistTable[k][2]:GetExpanded( false ) then
									SBMP_Models.CCSpawnlistTable[k][2]:Toggle()
								end
							end
						end

MinButton = vgui.Create( "DButton", SmallBridgeOptionsPanel )  	
MinButton:SetSize( 80, 25 )
MinButton:SetPos( 10, 230 )
MinButton:SetText( "Minimise All" )
MinButton.DoClick = 	function()
							for k, v in pairs(SBMP_Models.CCSpawnlistTable) do
								if SBMP_Models.CCSpawnlistTable[k][2]:GetExpanded( true ) then
									SBMP_Models.CCSpawnlistTable[k][2]:Toggle()
								end
							end
						end
-----------------------------------------------------------------------*/

local SkinComboBox = vgui.Create( "DComboBox", SmallBridgeOptionsPanel )  
SkinComboBox:SetPos( 10, 10 )  
SkinComboBox:SetSize( 80, 100 )  
SkinComboBox:SetMultiple( false )
local SkinSelections = {}
	SkinSelections[1] = SkinComboBox:AddItem( "Scrappers"  )
	SkinSelections[2] = SkinComboBox:AddItem( "Advanced"   )
	SkinSelections[3] = SkinComboBox:AddItem( "Daedalus"   )
	SkinSelections[4] = SkinComboBox:AddItem( "MedBridge2" )

for k,v in pairs(SkinSelections) do
	v.OnMousePressed = 	function(self)
							for k,v in pairs(SkinSelections) do
								if 	(v != self) then
									v:SetSelected(false)
								end
							end
							self:SetSelected(true)
							RunConsoleCommand( "sbmp_prop_spawner_SkinNumber" , k )
							timer.Simple(0.1,	function()
													SetSkinValue()
													SkinName = tostring(SkinSelections[ SkinValue ])
													SkinComboBox:SelectByName( SkinName )
													DrawIcons()
												end)
						end
end

local SBMPFrameCloseButton = vgui.Create("DSysButton", SmallBridgePanel )   
SBMPFrameCloseButton:SetPos( 5,621 )   
SBMPFrameCloseButton:SetSize( 406, 25 )   
SBMPFrameCloseButton:SetType( "close" )
SBMPFrameCloseButton.DoClick = 	function()
									SBMPFrame:SetVisible( false )
								end

local SBMPBanner = vgui.Create("DImage", SmallBridgeOptionsPanel )  
SBMPBanner:SetImage( "SmallBridge/Spawnicons/banner_"..SkinValue )
SBMPBanner:SetPos( 5,280 )
SBMPBanner:SetSize( 90,322 )
	
for k,v in pairs(SBMP_Models.CCSpawnlistTable) do
	v[2]:SetSize( 281, (5 + (69 * (math.ceil(v[4] / 4)))))
	v[2]:SetExpanded( false )
	v[2]:SetLabel( v[3] )

	SmallBridgePropsPanel:AddItem( v[2] )     

	v[1]:SetSize( 281, (5 + (69 * (math.ceil(v[4] / 4)))))
  
	v[2]:SetContents( v[1] )
end

for l, n in pairs(SBMP_Models.ALLMODELS) do
	for k, v in pairs(n) do
		if (v[1] != "blank") then
			if (((l == 3) || (l == 4)) && (v[2] == 1))then
				if (k % 4) == 1 then
					v[3]:SetParent( SBMP_Models.CCSpawnlistTable[l][1] )
					v[3]:SetPos( (5 + ((k - 1) % 4) * 69), (5 + (math.floor((k - 1)/ 4) * 69 )))
					v[3]:SetSize( 64, 64 )
					v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
				else
					v[3]:SetParent( SBMP_Models.CCSpawnlistTable[l][1] )
					v[3]:SetPos( (5 + ((k - 1) % 4) * 69), (5 + (math.floor((k - 1)/ 4) * 69 )))
					v[3]:SetSize( 64, 64 )
					v[3]:SetImage( "SmallBridge/Spawnicons/SBelevator_"..tostring((k - 1) % 4) )
					v[3].DoClick = 	function()
										if v[2] > 0 then
											ValA = 0
											ValB = 1
										else
											ValA = 1
											ValB = 0
										end
										RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/"..v[1].."/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
										Msg("Spawned 1 "..v[1]..".\n")
									end
				end
			elseif l == 14 then
				v[3]:SetParent( SBMP_Models.CCSpawnlistTable[l][1] )
				v[3]:SetPos( (5 + ((k - 1) % 4) * 69), (5 + (math.floor((k - 1)/ 4) * 69 )))
				v[3]:SetSize( 64, 64 )
				v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
				v[3].DoClick = 	function()
									if v[2] > 0 then
										ValA = 0
										ValB = 1
									else
										ValA = 1
										ValB = 0
									end
									RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/Ships/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
									Msg("Spawned 1 "..v[1]..".\n")
								end
			else
				v[3]:SetParent( SBMP_Models.CCSpawnlistTable[l][1] )
				v[3]:SetPos( (5 + ((k - 1) % 4) * 69), (5 + (math.floor((k - 1)/ 4) * 69 )))
				v[3]:SetSize( 64, 64 )
				v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
				v[3].DoClick = 	function()
									if v[2] > 0 then
										ValA = 0
										ValB = 1
									else
										ValA = 1
										ValB = 0
									end
									RunConsoleCommand( "SpawnSBEPProp" , "models/SmallBridge/"..v[1].."/"..v[1]..".mdl" , ((ValB * SkinGlassValue) + (ValA * SkinValueNum)) , GetConVarNumber("sbmp_prop_spawner_Habitable_Module"))
									Msg("Spawned 1 "..v[1]..".\n")
								end
			end
		end
	end
end

/*--------------------
TestModelPanelCC = vgui.Create("DCollapsibleCategory")    
TestModelPanelCC:SetSize( 281, 143 )
TestModelPanelCC:SetExpanded( 1 )
TestModelPanelCC:SetLabel( "TestModelPanel" ) 
SmallBridgePropsPanel:AddItem( TestModelPanelCC )

TestModelPanel = vgui.Create("DPanel")
TestModelPanel:SetSize( 281, 143)
TestModelPanelCC:SetContents( TestModelPanel )
------------*/

local function ShowMenu()
	SBMPFrame:SetVisible( true )
end
concommand.Add("sbmp_prop_spawner_showmenu", ShowMenu)

function TOOL.BuildCPanel(panel)
	local framebutton = {}
	framebutton.Label = "Menu"
	framebutton.Description = "Click to show the SBMP Prop Spawner Menu."
	framebutton.Text = "Menu"
	framebutton.Command = "sbmp_prop_spawner_showmenu"
	panel:AddControl("Button", framebutton)

	local BindLabel = {}
	BindLabel.Text = "\nTo bind the SBMP prop menu to a key, type\n\nbind <key> sbmp_prop_spawner_showmenu\n\nin the console."
	BindLabel.Description = "Shows how to bind the SBMP prop menu to a key."
	panel:AddControl("Label", BindLabel )
end
