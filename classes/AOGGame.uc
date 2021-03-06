/**
* Generic AOG game mode
*/

class AOGGame extends AOCGame;

//SetGameType returns which game mode should be used for which map prefix
//You can do whatever you want with this. You can even use Options 
// (options => the ?blah=blah things added after the map name when launching a server or in the map list)
//to add even more variety. See the ParseOption function in Src\Engine\Classes\GameInfo.uc
var config array<GameTypePrefix>	SDKPrefixes;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local string ThisMapPrefix;
	local int i,pos;
	local class<GameInfo> NewGameType;
	
	LogAlwaysInternal("SetGameType is being called on"@default.Class);
	
	MapName = StripPlayOnPrefix( MapName );

	// replace self with appropriate gametype if no game specified
	pos = InStr(MapName,"-");
	ThisMapPrefix = left(MapName,pos);
	
	for (i = 0; i < default.SDKPrefixes.length; i++)
	{
		if (default.SDKPrefixes[i].Prefix ~= ThisMapPrefix)
		{
			NewGameType = class<GameInfo>(DynamicLoadObject(default.SDKPrefixes[i].GameType,class'Class'));
			if ( NewGameType != None )
			{
				return NewGameType;
			}
		}
	}
	
	LogAlwaysInternal("SetGameType could not find a game");
	
	return super.SetGameType(MapName, Options, Portal);
}

function ScoreKill(Controller Killer, Controller Other)
{
	super.ScoreKill(Killer, Other);
}

DefaultProperties
{
    PlayerControllerClass=class'AOGPlayerController'
    DefaultPawnClass=class'AOGMobilePawn'
	
	//This is the name that shows in the server browser for this mod:
	ModDisplayString="Age of Giants v1.0"
	
	//SPAWN FASTER
	SpawnWaveInterval=1
	MinimumRespawnTime=0
}