TOOL.Category = 'SBMP' 
TOOL.Name = '#SBMP Prop Spawner'
TOOL.Command = nil
TOOL.ConfigName = ''

if CLIENT then
	language.Add( "Tool_sbmp_prop_spawner_name" , "SBMP Prop Spawner Tool" )
	language.Add( "Tool_sbmp_prop_spawner_desc" , "Easily find and spawn SBMP props." )
	language.Add( "Tool_sbmp_prop_spawner_0", "Left click to spawn the selected prop." )
end

TOOL.ClientConVar[ "SkinNumber" ]       = "1" 
TOOL.ClientConVar[ "glass" ]            = "1"
TOOL.ClientConVar[ "Habitable_Module" ] = "1"

CorridorsSWmodels = {}
	CorridorsSWmodels[1]  = {"SBcorridorE1" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[2]  = {"SBcorridorR" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[3]  = {"SBcorridorT" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[4]  = {"SBcorridorX" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[5]  = {"SBcorridorE05" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[6]  = {"SBcorridorE2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[7]  = {"SBcorridorE3" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[8]  = {"SBcorridorE4" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[9]  = {"SBcorridorEnd" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[10] = {"SBcorridorEFlip" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[11] = {"SBcorridorRtri" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[12] = {"SBcorridorCurveS" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[13] = {"SBcorridorEdh" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[14] = {"SBcorridorEdh2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[15] = {"SBcorridorEdh3" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[16] = {"SBcorridorEdh4" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[17] = {"SBcorridorSlantL" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[18] = {"SBcorridorSlantR" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[19] = {"SBcorridorSlanthalfL" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[20] = {"SBcorridorSlanthalfR" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[21] = {"SBcorridorTdl" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[22] = {"SBcorridorTdldw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[23] = {"SBcorridorXdl" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[24] = {"SBcorridorXdldw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[25] = {"SBtriangleE1" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[26] = {"SBtriangleE2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsSWmodels[27] = {"SBtriangleE3" , 1 , vgui.Create( "DImageButton" ) }
	
CorridorsDWmodels = {}
	CorridorsDWmodels[1]  = {"SBcorridorEdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[2]  = {"SBcorridorRdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[3]  = {"SBcorridorTdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[4]  = {"SBcorridorXdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[5]  = {"SBcorridorEdw05" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[6]  = {"SBcorridorEdw2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[7]  = {"SBcorridorEdw3" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[8]  = {"SBcorridorEdw4" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[9]  = {"SBcorridorEnddw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[10] = {"SBcorridorEnddw2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[11] = {"SBcorridorFlipdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[12] = {"blank" }
	CorridorsDWmodels[13] = {"SBcorridorEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[14] = {"SBcorridorEdhdw2" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[15] = {"SBcorridorEdhdw3" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[16] = {"SBcorridorEdhdw4" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[17] = {"SBcorridorTdwdl" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[18] = {"SBcorridorTdwsl" , 1 , vgui.Create( "DImageButton" ) }
	CorridorsDWmodels[19] = {"SBcorridorXdwdl" , 1 , vgui.Create( "DImageButton" ) }
	
ElevatorSmallmodels = {}
	ElevatorSmallmodels[1]  = { "SBcorridorEnd" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[2]  = { "SBelevBase" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[3]  = { "SBelevMid" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[4]  = { "SBelevTop" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[5]  = { "SBcorridorE1" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[6]  = { "SBelevBaseE" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[7]  = { "SBelevMidE" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[8]  = { "SBelevTopE" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[9]  = { "SBcorridorR" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[10] = { "SBelevBaseR" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[11] = { "SBelevMidR" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[12] = { "SBelevTopR" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[13] = { "SBcorridorT" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[14] = { "SBelevBaseT" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[15] = { "SBelevMidT" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[16] = { "SBelevTopT" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[17] = { "SBcorridorX" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[18] = { "SBelevBaseX" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[19] = { "SBelevMidX" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[20] = { "SBelevTopX" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[21] = { "SBcorridorEdh" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[22] = { "SBelevBaseEdh" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[23] = { "SBelevMidEdh" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[24] = { "SBelevTopEdh" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[25] = { "SBcorridorEdw" , 1 , vgui.Create( "DImage" ) }
	ElevatorSmallmodels[26] = { "SBelevBaseEdl" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[27] = { "SBelevMidEdl" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[28] = { "SBelevTopEdl" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[29] = { "SBelevShaft" , 2 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[30] = { "SBelevShaft2" , 2 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[31] = { "SBpanelelev0s" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[32] = { "SBpanelelev1s" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[33] = { "SBpanelelev2s" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[34] = { "SBpanelelev2sE" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorSmallmodels[35] = { "SBpanelelev3s" , 0 , vgui.Create( "DImageButton" ) }
	
ElevatorLargemodels = {}
	ElevatorLargemodels[1]  = { "SBcorridorEnddw2" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[2]  = { "SBelevBasedw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[3]  = { "SBelevMiddw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[4]  = { "SBelevTopdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[5]  = { "SBcorridorEdw2" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[6]  = { "SBelevBaseEdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[7]  = { "SBelevMidEdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[8]  = { "SBelevTopEdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[9]  = { "SBcorridorRdw" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[10] = { "SBelevBaseRdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[11] = { "SBelevMidRdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[12] = { "SBelevTopRdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[13] = { "SBcorridorTdw" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[14] = { "SBelevBaseTdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[15] = { "SBelevMidTdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[16] = { "SBelevTopTdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[17] = { "SBcorridorXdw" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[18] = { "SBelevBaseXdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[19] = { "SBelevMidXdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[20] = { "SBelevTopXdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[21] = { "SBcorridorEdhdw2" , 1 , vgui.Create( "DImage" ) }
	ElevatorLargemodels[22] = { "SBelevBaseEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[23] = { "SBelevMidEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[24] = { "SBelevTopEdhdw" , 1 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[25] = { "SBelevShaftdw" , 2 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[26] = { "SBelevShaftdw2" , 2 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[27] = { "SBpanelelev0sdw" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[28] = { "SBpanelelev1sdw" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[29] = { "SBpanelelev2sdw" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[30] = { "SBpanelelev2sEdw" , 0 , vgui.Create( "DImageButton" ) }
	ElevatorLargemodels[31] = { "SBpanelelev3sdw" , 0 , vgui.Create( "DImageButton" ) }
	
ShipPartsmodels = {}
	ShipPartsmodels[1]  = { "SBbridge1s" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[2]  = { "SBbridgeO1" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[3]  = { "SBbridgeO1base" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[4]  = { "SBbridgeO1cover" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[5]  = { "SBenginesw1Ls" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[6]  = { "SBenginesw1Ms" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[7]  = { "SBenginesw1Rs" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[8]  = { "SBenginedw1s" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[9]  = { "SBengine1s" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[10] = { "SBengine3" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[11] = { "blank" }
	ShipPartsmodels[12] = { "blank" }
	ShipPartsmodels[13] = { "SBengine2" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[14] = { "SBengine2B" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[15] = { "SBengine2Bramp" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[16] = { "blank" }
	ShipPartsmodels[17] = { "SBhullEdoors" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[18] = { "SBhullEdoors2" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[19] = { "SBhullEdoorsdw" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[20] = { "SBhullEdoorsdw2" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[21] = { "SBhulldoors" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[22] = { "SBhullTdoors" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[23] = { "SBEdoorsN" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[24] = { "SBEdoorsN2" , 1 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[25] = { "SBlanddock1" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[26] = { "SBlanddock1dw" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[27] = { "SBlanddock1dwdh" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[28] = { "blank" }
	ShipPartsmodels[29] = { "SBlanddockramp1" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[30] = { "SBlanddockramp1dw" , 0 , vgui.Create( "DImageButton" ) }
	ShipPartsmodels[31] = { "SBlanddockramp1dwdh" , 0 , vgui.Create( "DImageButton" ) }
	
HeightTransmodels = {}
	HeightTransmodels[1]  = { "SBcorridorRamp" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[2]  = { "SBcorridorRamphalf" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[3]  = { "blank" }
	HeightTransmodels[4]  = { "blank" }
	HeightTransmodels[5]  = { "SBsrampU" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[6]  = { "SBsrampM" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[7]  = { "SBsrampD" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[8]  = { "blank" }
	HeightTransmodels[9]  = { "SBsrampZ" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[10] = { "SBsrampZdw" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[11] = { "SBCRamp1" , 1 , vgui.Create( "DImageButton" ) }
	HeightTransmodels[12] = { "SBCRamp2dwD" , 1 , vgui.Create( "DImageButton" ) }
	
PanelsDoorsmodels = {}
	PanelsDoorsmodels[1]  = { "SBpanelSolidg" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[2]  = { "SBpanelDoor" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[3]  = { "SBpanelSquareDoor" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[4]  = { "SBpanelDoor2dw" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[5]  = { "SBpanelSolidgdw" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[6]  = { "SBpanelDoordw" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[7]  = { "SBpanelSquareDoordw" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[8]  = { "SBpanelwideDoor" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[9]  = { "SBpanelDH" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[10]  = { "SBpanelDHDW" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[11]  = { "SBpanelSquareDoordockin" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[12]  = { "SBpanelSquareDoordocko" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[13]  = { "SBdoor" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[14]  = { "SBdoorsquare" , 1 , vgui.Create( "DImageButton" ) }
	PanelsDoorsmodels[15]  = { "SBdoorwide" , 1 , vgui.Create( "DImageButton" ) }
	
Splittersmodels = {}
	Splittersmodels[1]  = { "SBcorridorEStoDW" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[2]  = { "SBcorridorEStoDWangular" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[3]  = { "SBcorridorV" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[4]  = { "SBcorridorVwide" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[5]  = { "SBcorridorEDto2SW" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[6]  = { "SBcorridorE2SWto2SW" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[7]  = { "SBconverterSBtoMB" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[8]  = { "blank" }
	Splittersmodels[9]  = { "SBcorridorEStoDHup" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[10] = { "SBcorridorEStoDHmid" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[11] = { "SBcorridorEStoDHdo" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[12] = { "blank" }
	Splittersmodels[13] = { "SBcorridorEStoDHdwup" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[14] = { "SBcorridorEStoDHdwmid" , 1 , vgui.Create( "DImageButton" ) }
	Splittersmodels[15] = { "SBcorridorEStoDHdwdo" , 1 , vgui.Create( "DImageButton" ) }
	
Hangarsmodels = {}
	Hangarsmodels[1]  = { "SBdropbay1left" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[2]  = { "SBdropbay1leftS" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[3]  = { "SBdropbay1right" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[4]  = { "SBdropbay1rightS" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[5]  = { "SBdropbay1mid" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[6]  = { "SBdropbay1midD" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[7]  = { "SBdropbay1midE" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[8]  = { "blank" }
	Hangarsmodels[9]  = { "SBdropbay1S" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[10] = { "SBdropbay1Ss" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[11] = { "blank" }
	Hangarsmodels[12] = { "blank" }
	Hangarsmodels[13] = { "SBdropbay2left" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[14] = { "SBdropbay2mid" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[15] = { "SBdropbay2middw" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[16] = { "SBdropbay2right" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[17] = { "SBdropbay2S" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[18] = { "blank" }
	Hangarsmodels[19] = { "blank" }
	Hangarsmodels[20] = { "blank" }
	Hangarsmodels[21] = { "SBdropbay3mid" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[22] = { "SBdropbay3middw" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[23] = { "SBdropbay3midX" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[24] = { "SBdropbay3midXdw" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[25] = { "SBdropbay3side" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[26] = { "SBdropbay3S" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[27] = { "blank" }
	Hangarsmodels[28] = { "blank" }
	Hangarsmodels[29] = { "SBdropbay4left" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[30] = { "SBdropbay4right" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[31] = { "SBdropbay4mid" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[32] = { "SBdropbay4middw" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[33] = { "SBdropbay4S" , 0 , vgui.Create( "DImageButton" ) }
	Hangarsmodels[34] = { "SBdropbaycomplete1S" , 0 , vgui.Create( "DImageButton" ) }
	
StationPartsmodels = {}
	StationPartsmodels[1]  = { "SBcommandBridge" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[2]  = { "SBcommandBridgedw" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[3]  = { "SBcommandBridgeElev" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[4]  = { "blank" }
	StationPartsmodels[5]  = { "SBvisorbridge1" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[6]  = { "SBvisorcontrolTop" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[7]  = { "SBspherebridge1" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[8]  = { "blank" }
	StationPartsmodels[9]  = { "SBcorridorSGC1" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[10] = { "SBcorridorSGC2" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[11] = { "SBHUB" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[12] = { "SBocthub1" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[13] = { "SBdock1" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[14] = { "SBpodbay1" , 1 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[15] = { "blank" }
	StationPartsmodels[16] = { "blank" }
	StationPartsmodels[17] = { "SBhangardhdw1" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[18] = { "SBhangardhdw1D" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[19] = { "SBhangardhdw1UD" , 0 , vgui.Create( "DImageButton" ) }
	StationPartsmodels[20] = { "SBhangardhdw2" , 0 , vgui.Create( "DImageButton" ) }
	
Wingsmodels = {}
	Wingsmodels[1]  = { "SBwingS1L" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[2]  = { "SBwingS1R" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[3]  = { "SBwingM1L" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[4]  = { "SBwingM1R" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[5]  = { "SBwingM1Le" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[6]  = { "SBwingM1Re" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[7]  = { "SBwingC1L" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[8]  = { "SBwingC1R" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[9]  = { "SBwingLS1L" , 0 , vgui.Create( "DImageButton" ) }
	Wingsmodels[10] = { "SBwingLS1R" , 0 , vgui.Create( "DImageButton" ) }
	
Walkwaysmodels = {}
	Walkwaysmodels[1]  = {"SBwalkwayE" , 0 , vgui.Create( "DImageButton" ) }
	Walkwaysmodels[2]  = {"SBwalkwayR" , 0 , vgui.Create( "DImageButton" ) }
	Walkwaysmodels[3]  = {"SBwalkwayT" , 0 , vgui.Create( "DImageButton" ) }
	Walkwaysmodels[4]  = {"SBwalkwayX" , 0 , vgui.Create( "DImageButton" ) }
	Walkwaysmodels[5]  = {"SBwalkwayE2" , 0 , vgui.Create( "DImageButton" ) }
	
OtherPartsmodels = {}
	OtherPartsmodels[1]  = {"SBconsole1s" , 0 , vgui.Create( "DImageButton" ) }
	OtherPartsmodels[2]  = {"SBconsole1low" , 0 , vgui.Create( "DImageButton" ) }
	OtherPartsmodels[3]  = {"SBconsoletop1" , 0 , vgui.Create( "DImageButton" ) }
	
Shipsmodels = {}
	Shipsmodels[1]  = {"SBshuttleC1E1" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[2]  = {"SBshuttleC1E2" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[3]  = {"SBshuttleC2E2" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[4]  = {"SBfrigate1" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[5]  = {"hysteria_galapagos" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[6]  = {"wilkie1020" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[7]  = {"steakknife" , 0 , vgui.Create( "DImageButton" ) }
	Shipsmodels[8]  = {"matthew0623_hydra" , 0 , vgui.Create( "DImageButton" ) }
	
ALLMODELS = {}
	ALLMODELS[1]  = CorridorsSWmodels
	ALLMODELS[2]  = CorridorsDWmodels
	ALLMODELS[3]  = ElevatorSmallmodels
	ALLMODELS[4]  = ElevatorLargemodels
	ALLMODELS[5]  = ShipPartsmodels
	ALLMODELS[6]  = HeightTransmodels
	ALLMODELS[7]  = PanelsDoorsmodels
	ALLMODELS[8]  = Splittersmodels
	ALLMODELS[9]  = Hangarsmodels
	ALLMODELS[10] = StationPartsmodels
	ALLMODELS[11] = Wingsmodels
	ALLMODELS[12] = Walkwaysmodels
	ALLMODELS[13] = OtherPartsmodels
	ALLMODELS[14] = Shipsmodels
	
   
CCSpawnlistTable = {}
	CCSpawnlistTable[1]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Corridors: Single Width"         , #CorridorsSWmodels   }
	CCSpawnlistTable[2]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Corridors: Double Width"         , #CorridorsDWmodels   }
	CCSpawnlistTable[3]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Elevator Parts: Small"           , #ElevatorSmallmodels }
	CCSpawnlistTable[4]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Elevator Parts: Large"           , #ElevatorLargemodels }
	CCSpawnlistTable[5]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Ship Parts"                      , #ShipPartsmodels     }
	CCSpawnlistTable[6]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Height Transfer"                 , #HeightTransmodels   }
	CCSpawnlistTable[7]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Panels and Doors"                , #PanelsDoorsmodels   }
	CCSpawnlistTable[8]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Splitters and Converters"        , #Splittersmodels     }
	CCSpawnlistTable[9]  = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Hangars"                         , #Hangarsmodels       }
	CCSpawnlistTable[10] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Station Parts"                   , #StationPartsmodels  }
	CCSpawnlistTable[11] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Wings"                           , #Wingsmodels         }
	CCSpawnlistTable[12] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Walkways"                        , #Walkwaysmodels      }
	CCSpawnlistTable[13] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Other Parts"                     , #OtherPartsmodels    }
	CCSpawnlistTable[14] = { vgui.Create( "DPanel" ) , vgui.Create("DCollapsibleCategory" ) , "Ships and Shuttles"              , #Shipsmodels         }

function SetSkinValue()
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

SBMPFrame = vgui.Create( "DFrame" )
SBMPFrame:SetPos( 50,50 )
SBMPFrame:SetSize( 446, 725 )
SBMPFrame:SetTitle( "SBMP Prop Spawner" )  
SBMPFrame:SetVisible( false )  
SBMPFrame:SetDraggable( true )
SBMPFrame:ShowCloseButton( false )
SBMPFrame:MakePopup()

ModelTabsSheet = vgui.Create( "DPropertySheet" )  
ModelTabsSheet:SetParent( SBMPFrame )  
ModelTabsSheet:SetPos( 10, 30 )  
ModelTabsSheet:SetSize( 426, 685 )

SmallBridgePanel = vgui.Create( "DPanel" )  
SmallBridgePanel:SetSize( 416,655 )
SmallBridgePanel.Paint = 	function()
								surface.SetDrawColor( 128, 128, 128, 255 )
								surface.DrawRect( 0, 0, SmallBridgePanel:GetWide(), SmallBridgePanel:GetTall() )
							end

MedBridge2Panel = vgui.Create( "DPanel" )  
MedBridge2Panel:SetSize( 450,655 )
MedBridge2Panel.Paint = 	function()
								surface.SetDrawColor( 128, 128, 128, 255 )
								surface.DrawRect( 0, 0, MedBridge2Panel:GetWide(), MedBridge2Panel:GetTall() )
							end

SlyfoPanel = vgui.Create( "DPanel" )  
SlyfoPanel:SetSize( 450,655 )
SlyfoPanel.Paint = 	function()
						surface.SetDrawColor( 128, 128, 128, 255 )
						surface.DrawRect( 0, 0, SlyfoPanel:GetWide(), SlyfoPanel:GetTall() )
					end 

ModelTabsSheet:AddSheet( "SmallBridge", SmallBridgePanel     , "gui/silkicons/user"  , false , false , "All Hysteria's SmallBridge Props" )  
ModelTabsSheet:AddSheet( "MedBridge2" , MedBridge2Panel   , "gui/silkicons/group" , false , false , "All GlenSkunk's MedBridge2 Props" ) 
ModelTabsSheet:AddSheet( "Slyfo"      , SlyfoPanel , "gui/silkicons/group" , false , false , "All Slyfo's MedBridge2 Props" )

SmallBridgeOptionsPanel = vgui.Create( "DPanel" , SmallBridgePanel )
SmallBridgeOptionsPanel:SetPos( 5,5 ) 
SmallBridgeOptionsPanel:SetSize( 100,609 )
SmallBridgeOptionsPanel.Paint = 	function()
										surface.SetDrawColor( 50, 50, 50, 255 )
										surface.DrawRect( 0, 0, SmallBridgeOptionsPanel:GetWide(), SmallBridgeOptionsPanel:GetTall() )
									end 

SmallBridgePropsPanel = vgui.Create( "DPanelList" , SmallBridgePanel )
SmallBridgePropsPanel:SetPos( 110,5 ) 
SmallBridgePropsPanel:SetSize( 301,609 )
SmallBridgePropsPanel:SetSpacing( 10 )
SmallBridgePropsPanel:EnableHorizontal( false )
SmallBridgePropsPanel:EnableVerticalScrollbar( true )
SmallBridgePropsPanel.Paint = 	function()
									surface.SetDrawColor( 50, 50, 50, 255 )
									surface.DrawRect( 0, 0, SmallBridgePropsPanel:GetWide(), SmallBridgePropsPanel:GetTall() )
								end


GlassCheckBox = vgui.Create( "DCheckBoxLabel", SmallBridgeOptionsPanel )  
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
	HabitableCheckBox = vgui.Create( "DCheckBoxLabel", SmallBridgeOptionsPanel )  
	HabitableCheckBox:SetPos( 10, 140 )  
	HabitableCheckBox:SetSize( 90, 30 ) 
	HabitableCheckBox:SetText( "Habitable\nLS Module" )  
	HabitableCheckBox:SetConVar( "sbmp_prop_spawner_Habitable_Module" )
	HabitableCheckBox:SetValue( GetConVarNumber( "sbmp_prop_spawner_Habitable_Module" ) ) 
end
	
UndoButton = vgui.Create( "DButton", SmallBridgeOptionsPanel )  	
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
							for k, v in pairs(CCSpawnlistTable) do
								if CCSpawnlistTable[k][2]:GetExpanded( false ) then
									CCSpawnlistTable[k][2]:Toggle()
								end
							end
						end

MinButton = vgui.Create( "DButton", SmallBridgeOptionsPanel )  	
MinButton:SetSize( 80, 25 )
MinButton:SetPos( 10, 230 )
MinButton:SetText( "Minimise All" )
MinButton.DoClick = 	function()
							for k, v in pairs(CCSpawnlistTable) do
								if CCSpawnlistTable[k][2]:GetExpanded( true ) then
									CCSpawnlistTable[k][2]:Toggle()
								end
							end
						end
-----------------------------------------------------------------------*/

SkinComboBox = vgui.Create( "DComboBox", SmallBridgeOptionsPanel )  
SkinComboBox:SetPos( 10, 10 )  
SkinComboBox:SetSize( 80, 100 )  
SkinComboBox:SetMultiple( false )
	SkinSelections = {}
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

SBMPFrameCloseButton = vgui.Create("DSysButton", SmallBridgePanel )   
SBMPFrameCloseButton:SetPos( 5,621 )   
SBMPFrameCloseButton:SetSize( 406, 25 )   
SBMPFrameCloseButton:SetType( "close" )
SBMPFrameCloseButton.DoClick = 	function()
									SBMPFrame:SetVisible( false )
								end

SBMPBanner = vgui.Create("DImage", SmallBridgeOptionsPanel )  
SBMPBanner:SetImage( "SmallBridge/Spawnicons/banner_"..SkinValue )
SBMPBanner:SetPos( 5,280 )
SBMPBanner:SetSize( 90,322 )
	
for k,v in pairs(CCSpawnlistTable) do
	v[2]:SetSize( 281, (5 + (69 * (math.ceil(v[4] / 4)))))
	v[2]:SetExpanded( false )
	v[2]:SetLabel( v[3] )

	SmallBridgePropsPanel:AddItem( v[2] )     

	v[1]:SetSize( 281, (5 + (69 * (math.ceil(v[4] / 4)))))
  
	v[2]:SetContents( v[1] )
end

for l, n in pairs(ALLMODELS) do
	for k, v in pairs(n) do
		if (v[1] != "blank") then
			if (((l == 3) || (l == 4)) && (v[2] == 1))then
				if (k % 4) == 1 then
					v[3]:SetParent( CCSpawnlistTable[l][1] )
					v[3]:SetPos( (5 + ((k - 1) % 4) * 69), (5 + (math.floor((k - 1)/ 4) * 69 )))
					v[3]:SetSize( 64, 64 )
					v[3]:SetImage( "SmallBridge/Spawnicons/"..v[1].."_"..SkinValue )
				else
					v[3]:SetParent( CCSpawnlistTable[l][1] )
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
				v[3]:SetParent( CCSpawnlistTable[l][1] )
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
				v[3]:SetParent( CCSpawnlistTable[l][1] )
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



function DrawIcons()
	for l, n in pairs(ALLMODELS) do
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

function ShowMenu()
	SBMPFrame:SetVisible( true )
end


concommand.Add("sbmp_prop_spawner_showmenu", ShowMenu)

function TOOL:LeftClick( trace )  

end     



function TOOL:RightClick( trace )  

end     



function TOOL.BuildCPanel( panel ) 
 	

	panel:AddControl("Header", 	
				{ 	
				Text = "Tool_sbmp_prop_spawner_name", 
				Description = "Tool_sbmp_prop_spawner_desc" 
				})

	framebutton = {}
	framebutton.Label = "Menu"
	framebutton.Description = "Click to show the SBMP Prop Spawner Menu."
	framebutton.Text = "Menu"
	framebutton.Command = "sbmp_prop_spawner_showmenu"
	panel:AddControl("Button", framebutton)

	BindLabel = {}
	BindLabel.Text = "\nTo bind the SBMP prop menu to a key, type\n\nbind <key> sbmp_prop_spawner_showmenu\n\nin the console."
	BindLabel.Description = "Shows how to bind the SBMP prop menu to a key."
	panel:AddControl("Label", BindLabel )


end