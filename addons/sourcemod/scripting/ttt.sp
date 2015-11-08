// Credits? Look here: http://git.tf/TTT/Plugin/blob/master/CREDITS.md


#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <multicolors>
#include <emitsoundany>
#include <ttt>

#pragma newdecls required

#define SND_TCHAT "buttons/button18.wav"
#define SND_FLASHLIGHT "items/flashlight1.wav"
#define SND_BLIP "buttons/blip2.wav"
#define SND_BURST "training/firewerks_burst_02.wav"
#define SND_BEEP "weapons/c4/c4_beep1.wav"
#define SND_DISARM "weapons/c4/c4_disarm.wav"
#define SND_WARNING "resource/warning.wav"

#define MDL_C4 "models/weapons/w_c4_planted.mdl"

enum eConfig
{
	i_shopKEVLAR,
	i_shop1KNIFE,
	i_shopDNA,
	i_shopID,
	i_shopFAKEID,
	i_shopRadar,
	i_shopT,
	i_shopD,
	i_shopTASER,
	i_shopUSP,
	i_shopM4A1,
	i_shopJIHADBOMB,
	i_shopC4,
	i_shopHEALTH,
	i_requiredPlayersD,
	i_requiredPlayers,
	i_startKarma,
	i_karmaBan,
	i_karmaBanLength,
	i_maxKarma,
	i_spawnHPT,
	i_spawnHPD,
	i_spawnHPI,
	i_karmaII,
	i_karmaIT,
	i_karmaID,
	i_karmaTI,
	i_karmaTT,
	i_karmaTD,
	i_karmaDI,
	i_karmaDT,
	i_karmaDD,
	i_creditsII,
	i_creditsIT,
	i_creditsID,
	i_creditsTI,
	i_creditsTT,
	i_creditsTD,
	i_creditsDI,
	i_creditsDT,
	i_creditsDD,
	i_creditsFoundBody,
	i_creditsTaserHurtTraitor,
	i_traitorloseAliveNonTraitors,
	i_traitorloseDeadNonTraitors,
	i_traitorwinAliveTraitors,
	i_traitorwinDeadTraitors,
	bool:b_showDeathMessage,
	bool:b_showKillMessage,
	bool:b_showEarnKarmaMessage,
	bool:b_showEarnCreditsMessage,
	bool:b_showLoseKarmaMessage,
	bool:b_showLoseCreditsMessage,
	i_messageTypKarma,
	i_messageTypCredits,
	bool:b_blockSuicide,
	bool:b_allowFlash,
	bool:b_blockLookAtWeapon,
	bool:b_blockGrenadeMessage,
	bool:b_blockRadioMessage,
	bool:b_enableNoBlock,
	String:s_pluginTag[MAX_MESSAGE_LENGTH],
	bool:b_kadRemover,
	i_rulesClosePunishment,
	i_punishInnoKills,
	i_timeToReadRules,
	i_timeToReadDetectiveRules,
	bool:b_showRulesMenu,
	bool:b_showDetectiveMenu,
	String:s_kickImmunity[16],
	bool:b_updateClientModel,
	bool:b_removeHostages,
	bool:b_removeBomb,
	bool:b_roleAgain,
	i_traitorRatio,
	i_detectiveRatio,
	bool:b_taserAllow,
	Float:f_jihadPreparingTime,
	bool:b_newConfig
};

int g_iConfig[eConfig];

char g_sConfigFile[PLATFORM_MAX_PATH + 1];
char g_sRulesFile[PLATFORM_MAX_PATH + 1];

int g_iCredits[MAXPLAYERS + 1] =  { 800, ... };

bool g_bHasC4[MAXPLAYERS + 1] =  { false, ... };

int g_iRDMAttacker[MAXPLAYERS + 1] =  { -1, ... };
Handle g_hRDMTimer[MAXPLAYERS + 1] =  { null, ... };
bool g_bImmuneRDMManager[MAXPLAYERS + 1] =  { false, ... };
bool g_bHoldingProp[MAXPLAYERS + 1] =  { false, ... };
bool g_bHoldingSilencedWep[MAXPLAYERS + 1] =  { false, ... };

int g_iAccount;

Handle g_hExplosionTimer[MAXPLAYERS + 1] =  { null, ... };
bool g_bHasActiveBomb[MAXPLAYERS + 1] =  { false, ... };
int g_iWire[MAXPLAYERS + 1] =  { -1, ... };
int g_iDefusePlayerIndex[MAXPLAYERS + 1] =  { -1, ... };

int g_iHealthStationCharges[MAXPLAYERS + 1] =  { 0, ... };
int g_iHealthStationHealth[MAXPLAYERS + 1] =  { 0, ... };
bool g_bHasActiveHealthStation[MAXPLAYERS + 1] =  { false, ... };
bool g_bOnHealingCoolDown[MAXPLAYERS + 1] =  { false, ... };
Handle g_hRemoveCoolDownTimer[MAXPLAYERS + 1] =  { null, ... };

bool g_b1Knife[MAXPLAYERS + 1] =  { false, ... };
bool g_bScan[MAXPLAYERS + 1] =  { false, ... };
bool g_bJihadBomb[MAXPLAYERS + 1] =  { false, ... };
bool g_bID[MAXPLAYERS + 1] =  { false, ... };
// bool g_bRadar[MAXPLAYERS + 1] =  { false, ... };
Handle g_hJihadBomb[MAXPLAYERS + 1] =  { null, ... };
int g_iRole[MAXPLAYERS + 1] =  { 0, ... };

int g_iInnoKills[MAXPLAYERS + 1];

Handle g_hGraceTime = null;

Handle g_hStartTimer = null;

float g_fRealRoundStart;
Handle g_hCountdownTimer = null;

Handle g_hPlayerArray = null;

Handle g_hDetectives = null;
Handle g_hTraitores = null;

int g_iIcon[MAXPLAYERS + 1] =  { 0, ... };

bool g_bRoundStarted = false;

Handle g_hRoundTimer = null;

bool g_bInactive = false;

int g_iCollisionGroup = -1;

bool g_bKarma[MAXPLAYERS + 1] =  { false, ... };
int g_iKarma[MAXPLAYERS + 1] =  { 0, ... };

Handle g_hRagdollArray = null;

int g_iBeamSprite = -1;
int g_iHaloSprite = -1;

bool g_bFound[MAXPLAYERS + 1] = {false, ...};
bool g_bDetonate[MAXPLAYERS + 1] = {false, ...};

int g_iAlive = -1;
int g_iKills = -1;
int g_iDeaths = -1;
int g_iAssists = -1;
int g_iMVPs = -1;

char g_sBadNames[256][MAX_NAME_LENGTH];
int g_iBadNameCount = 0;

Handle g_hDatabase = null;

enum Ragdolls
{
	ent,
	victim,
	attacker,
	String:victimName[32],
	String:attackerName[32],
	bool:scanned,
	Float:gameTime,
	String:weaponused[32],
	bool:found
}

bool g_bReceivingLogs[MAXPLAYERS+1];

Handle g_hLogsArray;

bool g_bReadRules[MAXPLAYERS + 1] =  { false, ... };
bool g_bKnowRules[MAXPLAYERS + 1] =  { false, ... };

bool g_bConfirmDetectiveRules[MAXPLAYERS + 1] =  { false, ... };

Handle g_hOnRoundStart = null;
Handle g_hOnRoundStartFailed = null;
Handle g_hOnClientGetRole = null;
Handle g_hOnClientDeath = null;
Handle g_hOnBodyFound = null;
Handle g_hOnBodyScanned = null;

char g_sShopCMDs[][] = {
	"menu",
	"shop"
};

char g_sRadioCMDs[][] = {
	"coverme",
	"takepoint",
	"holdpos",
	"regroup",
	"followme",
	"takingfire",
	"go",
	"fallback",
	"sticktog",
	"getinpos",
	"stormfront",
	"report",
	"roger",
	"enemyspot",
	"needbackup",
	"sectorclear",
	"inposition",
	"reportingin",
	"getout",
	"negative",
	"enemydown",
	"compliment",
	"thanks",
	"cheer"
};

char g_sRemoveEntityList[][] = {
	"func_bomb_target",
	"hostage_entity",
	"func_hostage_rescue",
	"info_hostage_spawn"
};

public Plugin myinfo =
{
	name = TTT_PLUGIN_NAME,
	author = TTT_PLUGIN_AUTHOR,
	description = TTT_PLUGIN_DESCRIPTION,
	version = TTT_PLUGIN_VERSION,
	url = TTT_PLUGIN_URL
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_hOnRoundStart = CreateGlobalForward("TTT_OnRoundStart", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_hOnRoundStartFailed = CreateGlobalForward("TTT_OnRoundStartFailed", ET_Ignore, Param_Cell, Param_Cell);
	g_hOnClientGetRole = CreateGlobalForward("TTT_OnClientGetRole", ET_Ignore, Param_Cell, Param_Cell);
	g_hOnClientDeath = CreateGlobalForward("TTT_OnClientDeath", ET_Ignore, Param_Cell, Param_Cell);
	g_hOnBodyFound = CreateGlobalForward("TTT_OnBodyFound", ET_Ignore, Param_Cell, Param_Cell, Param_String);
	g_hOnBodyScanned = CreateGlobalForward("TTT_OnBodyScanned", ET_Ignore, Param_Cell, Param_Cell, Param_String);
	
	CreateNative("TTT_GetClientRole", Native_GetClientRole);
	CreateNative("TTT_GetClientKarma", Native_GetClientKarma);
	CreateNative("TTT_GetClientCredits", Native_GetClientCredits);
	CreateNative("TTT_SetClientRole", Native_SetClientRole);
	CreateNative("TTT_SetClientKarma", Native_SetClientKarma);
	CreateNative("TTT_SetClientCredits", Native_SetClientCredits);
	CreateNative("TTT_WasBodyFound", Native_WasBodyFound);
	CreateNative("TTT_WasBodyScanned", Native_WasBodyScanned);
	
	RegPluginLibrary("ttt");
	
	return APLRes_Success;
}

public void OnPluginStart()
{
	if(GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("Only CS:GO is supported");
		return;
	}
	
	BuildPath(Path_SM, g_sConfigFile, sizeof(g_sConfigFile), "configs/ttt/config.cfg");
	BuildPath(Path_SM, g_sRulesFile, sizeof(g_sRulesFile), "configs/ttt/rules/start.cfg");
	
	if (!SQL_CheckConfig("ttt"))
	{
		char error[255];
		Handle kv = null;
		
		kv = CreateKeyValues("");
		KvSetString(kv, "database", "ttt");
		g_hDatabase = SQL_ConnectCustom(kv, error, sizeof(error), true);  
		delete kv;
		
		if(g_hDatabase == null)
		{
			SetFailState("(OnPluginStart) Database failure: Couldn't find Database entry \"ttt\" and can't use SQlite as default.");
			return;
		}
		
		CheckAndCreateTables("sqlite");
		SQL_SetCharset(g_hDatabase, "utf8");
		LoadClients();
	}
	else SQL_TConnect(SQLConnect, "ttt");
	
	LoadTranslations("ttt.phrases");
	LoadTranslations("common.phrases");
	
	LoadBadNames();
	
	g_hRagdollArray = CreateArray(102);
	g_hPlayerArray = CreateArray();
	g_hLogsArray = CreateArray(512);
	
	g_iCollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	g_iAccount = FindSendPropInfo("CCSPlayer", "m_iAccount");
	

	CreateTimer(0.1, Timer_Adjust, _, TIMER_REPEAT);
	CreateTimer(1.0, healthStationDistanceCheck, _, TIMER_REPEAT);
	CreateTimer(5.0, Timer_5, _, TIMER_REPEAT);
	
	RegAdminCmd("sm_setrole", Command_SetRole, ADMFLAG_ROOT);
	RegAdminCmd("sm_karmareset", Command_KarmaReset, ADMFLAG_ROOT);
	RegAdminCmd("sm_setkarma", Command_SetKarma, ADMFLAG_ROOT);
	RegAdminCmd("sm_setcredits", Command_SetCredits, ADMFLAG_ROOT);
	
	RegConsoleCmd("sm_status", Command_Status);
	RegConsoleCmd("sm_karma", Command_Karma);
	RegConsoleCmd("sm_credits", Command_Credits);
	RegConsoleCmd("sm_boom", Command_Detonate); 
	RegConsoleCmd("sm_jihad_detonate", Command_Detonate); 
	RegConsoleCmd("sm_logs", Command_Logs);
	RegConsoleCmd("sm_log", Command_Logs);
	RegConsoleCmd("sm_id", Command_ID);
	
	for (int i = 0; i < sizeof(g_sShopCMDs); i++)
	{
		char sBuffer[64];
		Format(sBuffer, sizeof(sBuffer), "sm_%s", g_sShopCMDs[i]);
		RegConsoleCmd(sBuffer, Command_Shop);
	}
	
	HookEvent("player_death", Event_PlayerDeathPre, EventHookMode_Pre);
	HookEvent("round_start", Event_RoundStartPre, EventHookMode_Pre);
	HookEvent("round_end", Event_RoundEndPre, EventHookMode_Pre);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_changename", Event_ChangeName);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("item_pickup", Event_ItemPickup);
	
	g_hGraceTime = FindConVar("mp_join_grace_time");
	
	AddCommandListener(Command_LAW, "+lookatweapon");
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_SayTeam, "say_team");
	AddCommandListener(Command_InterceptSuicide, "kill");
	AddCommandListener(Command_InterceptSuicide, "explode");
	AddCommandListener(Command_InterceptSuicide, "spectate");
	AddCommandListener(Command_InterceptSuicide, "jointeam");
	AddCommandListener(Command_InterceptSuicide, "joinclass");
	
	for(int i= 0; i < sizeof(g_sRadioCMDs); i++)
	{
		AddCommandListener(Command_RadioCMDs, g_sRadioCMDs[i]);
	}
	
	CreateConVar("ttt2_version", TTT_PLUGIN_VERSION, TTT_PLUGIN_DESCRIPTION, FCVAR_NOTIFY | FCVAR_DONTRECORD);

	g_iConfig[i_creditsII] = AddInt("ttt_credits_killer_innocent_victim_innocent_subtract", 1500, "The amount of credits an innocent will lose for killing an innocent.");
	g_iConfig[i_creditsIT] = AddInt("ttt_credits_killer_innocent_victim_traitor_add", 3000, "The amount of credits an innocent will recieve when killing a traitor.");
	g_iConfig[i_creditsID] = AddInt("ttt_credits_killer_innocent_victim_detective_subtract", 4200, "The amount of credits an innocent will lose for killing a detective.");
	g_iConfig[i_creditsTI] = AddInt("ttt_credits_killer_traitor_victim_innocent_add", 600, "The amount of credits a traitor will recieve for killing an innocent.");
	g_iConfig[i_creditsTT] = AddInt("ttt_credits_killer_traitor_victim_traitor_subtract", 3000, "The amount of credits a traitor will lose for killing a traitor.");
	g_iConfig[i_creditsTD] = AddInt("ttt_credits_killer_traitor_victim_detective_add", 4200, "The amount of credits a traitor will recieve for killing a detective.");
	g_iConfig[i_creditsDI] = AddInt("ttt_credits_killer_detective_victim_innocent_subtract", 300, "The amount of credits a detective will lose for killing an innocent.");
	g_iConfig[i_creditsDT] = AddInt("ttt_credits_killer_detective_victim_traitor_add", 2100, "The amount of credits a detective will recieve for killing a traitor.");
	g_iConfig[i_creditsDD] = AddInt("ttt_credits_killer_detective_victim_detective_subtract", 300, "The amount of credits a detective will lose for killing a detective.");
	g_iConfig[i_karmaII] = AddInt("ttt_karma_killer_innocent_victim_innocent_subtract", 5, "The amount of karma an innocent will lose for killing an innocent.");
	g_iConfig[i_karmaIT] = AddInt("ttt_karma_killer_innocent_victim_traitor_add", 5, "The amount of karma an innocent will recieve for killing a traitor.");
	g_iConfig[i_karmaID] = AddInt("ttt_karma_killer_innocent_victim_detective_subtract", 7, "The amount of karma an innocent will lose for killing a detective.");
	g_iConfig[i_karmaTI] = AddInt("ttt_karma_killer_traitor_victim_innocent_add", 2, "The amount of karma a traitor will recieve for killing an innocent.");
	g_iConfig[i_karmaTT] = AddInt("ttt_karma_killer_traitor_victim_traitor_subtract", 5, "The amount of karma a traitor will lose for killing a traitor.");
	g_iConfig[i_karmaTD] = AddInt("ttt_karma_killer_traitor_victim_detective_add", 3, "The amount of karma a traitor will recieve for killing a detective.");
	g_iConfig[i_karmaDI] = AddInt("ttt_karma_killer_detective_victim_innocent_subtract", 3, "The amount of karma a detective will lose for killing an innocent.");
	g_iConfig[i_karmaDT] = AddInt("ttt_karma_killer_detective_victim_traitor_add", 7, "The amount of karma a detective will recieve for killing a traitor.");
	g_iConfig[i_karmaDD] = AddInt("ttt_karma_killer_detective_victim_detective_subtract", 7, "The amount of karma a detective will lose for killing a detective.");
	g_iConfig[i_startKarma] = AddInt("ttt_start_karma", 100, "The amount of karma new players and players who were karma banned will start with.");
	g_iConfig[i_karmaBan] = AddInt("ttt_with_karma_ban", 75, "The amount of karma needed to be banned for Bad Karma. (0 = Disabled)");
	g_iConfig[i_karmaBanLength] = AddInt("ttt_with_karma_ban_length", 10080, "The length of a Bad Karma ban. (Default = 1 Week)");
	g_iConfig[i_maxKarma] = AddInt("ttt_max_karma", 150, "The maximum amount of karma a player can have.");
	g_iConfig[i_requiredPlayersD] = AddInt("ttt_required_players_detective", 6, "The amount of players required to activate the detective role.");
	g_iConfig[i_requiredPlayers] = AddInt("ttt_required_player", 3, "The amount of players required to start the game.");
	g_iConfig[i_traitorloseAliveNonTraitors] = AddInt("ttt_credits_roundend_traitorlose_alive_nontraitors", 4800, "The amount of credits an innocent or detective will recieve for winning the round if they survived.");
	g_iConfig[i_traitorloseDeadNonTraitors] = AddInt("ttt_credits_roundend_traitorlose_dead_nontraitors", 1200, "The amount of credits an innocent or detective will recieve for winning the round if they died.");
	g_iConfig[i_traitorwinAliveTraitors] = AddInt("ttt_credits_roundend_traitorwin_alive_traitors", 4800, "The amount of credits a traitor will recieve for winning the round if they survived.");
	g_iConfig[i_traitorwinDeadTraitors] = AddInt("ttt_credits_roundend_traitorwin_dead_traitors", 1200, "The amount of credits a traitor will recieve for winning the round if they died.");
	g_iConfig[i_creditsFoundBody] = AddInt("ttt_credits_found_body_add", 1200, "The amount of credits an innocent or detective will recieve for discovering a new dead body.");
	g_iConfig[i_creditsTaserHurtTraitor] = AddInt("ttt_hurt_traitor_with_taser", 2000, "The amount of credits an innocent or detective will recieve for discovering a traitor with their zues/taser.");
	g_iConfig[b_showDeathMessage] = AddBool("ttt_show_death_message", true, "Display a message showing who killed you. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_showKillMessage] = AddBool("ttt_show_kill_message", true, "Display a message showing who you killed. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_showEarnKarmaMessage] = AddBool("ttt_show_message_earn_karma", true, "Display a message showing how much karma you earned. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_showEarnCreditsMessage] = AddBool("ttt_show_message_earn_credits", true, "Display a message showing how many credits you earned. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_showLoseKarmaMessage] = AddBool("ttt_show__message_lose_karmna", true, "Display a message showing how much karma you lost. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_showLoseCreditsMessage] = AddBool("ttt_show_message_lose_credits", true, "Display a message showing how many credits you lost. 1 = Enabled, 0 = Disabled");
	g_iConfig[i_messageTypKarma] = AddInt("ttt_message_typ_karma", 1, "The karma message type. 1 = Hint Text or 2 = Chat Message");
	g_iConfig[i_messageTypCredits] = AddInt("ttt_message_typ_credits", 1, "The credit message type. 1 = Hint Text, 2 = Chat Message");
	g_iConfig[b_blockSuicide] = AddBool("ttt_block_suicide", false, "Block players from suiciding with console. 1 = Block, 0 = Don't Block");
	g_iConfig[b_blockGrenadeMessage] = AddBool("ttt_block_grenade_message", true, "Block grenade messages in chat. 1 = Block, 0 = Don't Block");
	g_iConfig[b_blockRadioMessage] = AddBool("ttt_block_radio_message", true, "Block radio messages in chat. 1 = Block, 0 = Don't Block");
	g_iConfig[b_allowFlash] = AddBool("ttt_allow_flash", true, "Enable Flashlight (+lookatweapon). 1 = Enabled, 0 Disabled");
	g_iConfig[b_blockLookAtWeapon] = AddBool("ttt_block_look_at_weapon", true, "Block weapon inspecting. 1 = Block, 0 = Don't Block)");
	g_iConfig[b_enableNoBlock] = AddBool("ttt_enable_noblock", false, "Enable No Block. 1 = Enabled, 0 = Disabled");
	g_iConfig[b_kadRemover] = AddBool("ttt_kad_remover", true, "Block kills, deaths and assists from appearing on the scoreboard. 1 = Enabled, 0 = Disabled");
	AddString("ttt_plugin_tag", "{orchid}[{green}T{darkred}T{blue}T{orchid}]{lightgreen} %T", "The prefix used in all plugin messages (DO NOT DELETE '%T')", g_iConfig[s_pluginTag], sizeof(g_iConfig[s_pluginTag]));
	g_iConfig[i_shopKEVLAR] = AddInt("ttt_shop_kevlar", 2500, "The price of 'Kevlar' in the shop.");
	g_iConfig[i_shop1KNIFE] = AddInt("ttt_shop_1knife", 5000, "The price of a '1 Hit Knife' in the shop.");
	g_iConfig[i_shopDNA] = AddInt("ttt_shop_dna_scanner", 5000, "The price of a 'DNA Scanner' in the shop.");
	g_iConfig[i_shopID] = AddInt("ttt_shop_id_card", 500, "The price of an 'ID Card' in the shop.");
	// g_iConfig[i_shopRadar] = AddInt("ttt_shop_radar", 7000, "The price of a 'Radar' in the shop.");
	g_iConfig[i_shopFAKEID] = AddInt("ttt_shop_fake_id_card", 3000, "The price of a 'Fake ID Card' in the shop.");
	g_iConfig[i_shopT] = AddInt("ttt_shop_t", 10000, "The price of the 'Traitor Role' in the shop.");
	g_iConfig[i_shopD] = AddInt("ttt_shop_d", 5000, "The price of the 'Detective Role' in the shop.");
	g_iConfig[i_shopTASER] = AddInt("ttt_shop_taser", 3000, "The price of the 'Taser/Zeus' in the shop.");
	g_iConfig[i_shopUSP] = AddInt("ttt_shop_usp", 3000, "The price of the 'USP-S' in the shop.");
	g_iConfig[i_shopM4A1] = AddInt("ttt_shop_m4a1", 6000, "The price of the 'MA41' in the shop.");
	g_iConfig[i_shopJIHADBOMB] = AddInt("ttt_shop_jihad_bomb", 6000, "The price of the 'Jihad Bomb' in the shop.");
	g_iConfig[i_shopC4] = AddInt("ttt_shop_c4", 10000, "The price of 'C4' in the shop.");
	g_iConfig[i_shopHEALTH] = AddInt("ttt_shop_health_station", 3000, "The price of a 'Health Station' in the shop.");
	g_iConfig[i_spawnHPT] = AddInt("ttt_spawn_t", 100, "The amount of health traitors spawn with.");
	g_iConfig[i_spawnHPD] = AddInt("ttt_spawn_d", 100, "The amount of health detectives spawn with.");
	g_iConfig[i_spawnHPI] = AddInt("ttt_spawn_i", 100, "The amount of health innocents spawn with.");
	g_iConfig[i_rulesClosePunishment] = AddInt("ttt_rules_close_punishment", 0, "The punishment for abusing the rules menu by closing it with another menu. 0 = Kick, Anything Else = Do Nothing");
	g_iConfig[i_timeToReadDetectiveRules] = AddInt("ttt_time_to_read_detective_rules", 15, "The time in seconds the detective rules menu will stay open.");
	g_iConfig[i_timeToReadRules] = AddInt("ttt_time_to_read_rules", 30, "The time in seconds the general rules menu will stay open.");
	g_iConfig[b_showDetectiveMenu] = AddBool("ttt_show_detective_menu", true, "Show the detective menu. 1 = Show, 0 = Don't Show");
	g_iConfig[b_showRulesMenu] = AddBool("ttt_show_rules_menu", true, "Show the rules menu. 1 = Show, 0 Don't Show");
	g_iConfig[i_punishInnoKills] = AddInt("ttt_punish_ttt_for_rdm_kils", 3, "The amount of times an innocent will be allowed to kill another innocent before being punished for RDM.");
	AddString("ttt_kick_immunity", "bz", "Admin flags that won't be kicked for not reading the rules.", g_iConfig[s_kickImmunity], sizeof(g_iConfig[s_kickImmunity]));
	g_iConfig[b_updateClientModel] = AddBool("ttt_update_client_model", true, "Update the client model isntantly when they are assigned a role. 1 = Update, 0 = Don't Update");
	g_iConfig[b_removeHostages] = AddBool("ttt_remove_hostages", true, "Remove all hostages from the map to prevent interference. 1 = Remove, 0 = Don't Remove");
	g_iConfig[b_removeBomb] = AddBool("ttt_remove_bomb_on_spawn", true, "Remove the bomb from the map to prevent interference. 1 = Remove, 0 = Don't Remove");
	g_iConfig[b_roleAgain] = AddBool("ttt_role_again", false, "Allow getting the same role twice in a row.");
	g_iConfig[i_traitorRatio] = AddInt("ttt_traitor_ratio", 25, "The chance of getting the traitor role.");
	g_iConfig[i_detectiveRatio] = AddInt("ttt_detective_ratio", 13, "The chance of getting the detective role.");
	g_iConfig[b_taserAllow] = AddBool("ttt_taser_allow", true, "Should the Taser/Zeus be allowed. 1 = Allow, 0 = Don't Allow");
	g_iConfig[f_jihadPreparingTime] = AddFloat("ttt_jihad_preparing_time", 60.0, "The amount of ime in seconds until the jihad bomb is ready after buying it.");
	g_iConfig[b_newConfig] = AddBool("ttt_new_config", false, "IMPORTANT, Please set this cvar to 1 to use the new config, otherwise you can't run TTT anymore!");
	
	if(!g_iConfig[b_newConfig])
	{
		SetFailState("Please use the new config file! Open %s and set \"ttt_new_config\" to 1", g_sConfigFile);
		return;
	}
}

public void OnConfigsExecuted()
{
	if(g_iConfig[b_blockGrenadeMessage])
		SetConVarBool(FindConVar("sv_ignoregrenaderadio"), false);
}

public Action Command_Logs(int client, int args)
{
	if(!IsPlayerAlive(client) || !g_bRoundStarted)
		ShowLogs(client);
	else
		CPrintToChat(client, g_iConfig[s_pluginTag], "you cant see logs", client);
	return Plugin_Handled;
}

stock void ShowLogs(int client)
{
	int sizearray = GetArraySize(g_hLogsArray);
	if(sizearray == 0)
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "no logs yet", client);
		return;
	}
	if(g_bReceivingLogs[client]) return;
	g_bReceivingLogs[client] = true;
	CPrintToChat(client, g_iConfig[s_pluginTag], "Receiving logs", client);
	PrintToConsole(client, "--------------------------------------");
	PrintToConsole(client, "-------------TTT LOGS---------------");
	char item[512];
	int index = 5;
	bool end = false;
	if(index >= sizearray)
	{
		end = true;
		index = (sizearray -1);
	}
		
	for(int i = 0; i <= index; i++)
	{
		GetArrayString(g_hLogsArray, i, item, sizeof(item));
		PrintToConsole(client, item);
	}
	
	if(end)
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "See your console", client);
		g_bReceivingLogs[client] = false;
		PrintToConsole(client, "--------------------------------------");
		PrintToConsole(client, "--------------------------------------");
		return;
	}
	Handle pack = CreateDataPack();
	RequestFrame(OnCreate, pack);
	WritePackCell(pack, client);
	WritePackCell(pack, index);
}

public void OnCreate(any pack)
{
	int client;
	int index;
	
	
	ResetPack(pack);
	client = ReadPackCell(pack);
	index = ReadPackCell(pack);
	
	if (IsClientInGame(client))
	{
		int sizearray = GetArraySize(g_hLogsArray);
		int old = (index + 1);
		index += 5;
		bool end = false;
		if(index >= sizearray)
		{
			end = true;
			index = (sizearray -1);
		}
		char item[512];
		
		for(int i = old; i <= index; i++)
		{
			GetArrayString(g_hLogsArray, i, item, sizeof(item));
			PrintToConsole(client, item);
		}
		if(end)
		{
			CPrintToChat(client, g_iConfig[s_pluginTag], "See your console", client);
			g_bReceivingLogs[client] = false;
			PrintToConsole(client, "--------------------------------------");
			PrintToConsole(client, "--------------------------------------");
			return;
		}
		Handle pack2 = CreateDataPack();
		RequestFrame(OnCreate, pack2);
		WritePackCell(pack2, client);
		WritePackCell(pack2, index);
	}
}

public Action Command_InterceptSuicide(int client, const char[] command, int args)
{
	if(g_iConfig[b_blockSuicide] && IsPlayerAlive(client))
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "Suicide Blocked", client);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action Command_RadioCMDs(int client, const char[] command, int args)
{
	if(g_iConfig[b_blockRadioMessage])
		return Plugin_Handled;
	return Plugin_Continue;
}

public void OnMapStart()
{
	for(int i; i < g_iBadNameCount; i++)
		g_sBadNames[i] = "";
	g_iBadNameCount = 0;
	
	LoadBadNames();
	
	g_iBeamSprite = PrecacheModel("materials/sprites/bomb_planted_ring.vmt");
	g_iHaloSprite = PrecacheModel("materials/sprites/halo.vtf");
	
	PrecacheModel("props/cs_office/microwave.mdl", true);
	PrecacheModel("weapons/w_c4_planted.mdl", true);
	
	PrecacheSoundAny(SND_BLIP, true); 
	PrecacheSoundAny(SND_TCHAT, true);
	PrecacheSoundAny(SND_FLASHLIGHT, true);
	PrecacheSoundAny(SND_BURST, true);
	PrecacheSoundAny(SND_BEEP, true);
	PrecacheSoundAny(SND_DISARM, true);
	PrecacheSoundAny(SND_WARNING, true);
	
	PrecacheSoundAny("ttt/jihad/explosion.mp3", true);
	PrecacheSoundAny("ttt/jihad/jihad.mp3", true);

	AddFileToDownloadsTable("sound/ttt/jihad/explosion.mp3"); 
	AddFileToDownloadsTable("sound/ttt/jihad/jihad.mp3");
	
	ClearArray(g_hLogsArray);

	AddFileToDownloadsTable("materials/sprites/sg_detective_icon.vmt");
	AddFileToDownloadsTable("materials/sprites/sg_detective_icon.vtf");
	PrecacheModel("materials/sprites/sg_detective_icon.vmt");
	
	AddFileToDownloadsTable("materials/sprites/sg_traitor_icon.vmt");
	AddFileToDownloadsTable("materials/sprites/sg_traitor_icon.vtf");
	PrecacheModel("materials/sprites/sg_traitor_icon.vmt");
	
	AddFileToDownloadsTable("materials/overlays/ttt/innocents_win.vmt");
	AddFileToDownloadsTable("materials/overlays/ttt/innocents_win.vtf");
	PrecacheDecal("overlays/ttt/innocents_win", true);
	
	AddFileToDownloadsTable("materials/overlays/ttt/traitors_win.vmt");
	AddFileToDownloadsTable("materials/overlays/ttt/traitors_win.vtf");
	PrecacheDecal("overlays/ttt/traitors_win", true);
	
	AddFileToDownloadsTable("materials/darkness/ttt/overlayDetective.vmt");
	AddFileToDownloadsTable("materials/darkness/ttt/overlayDetective.vtf");
	PrecacheDecal("darkness/ttt/overlayDetective", true);
	
	AddFileToDownloadsTable("materials/darkness/ttt/overlayTraitor.vmt");
	AddFileToDownloadsTable("materials/darkness/ttt/overlayTraitor.vtf");
	PrecacheDecal("darkness/ttt/overlayTraitor", true);
	
	AddFileToDownloadsTable("materials/darkness/ttt/overlayInnocent.vmt");
	AddFileToDownloadsTable("materials/darkness/ttt/overlayInnocent.vtf");
	PrecacheDecal("darkness/ttt/overlayInnocent", true);
	
 	AddFileToDownloadsTable("materials/overlays/ttt/detectives_win.vmt");
	AddFileToDownloadsTable("materials/overlays/ttt/detectives_win.vtf");
	PrecacheDecal("overlays/ttt/detectives_win", true);
	
	g_iAlive = FindSendPropInfo("CCSPlayerResource", "m_bAlive");
	if (g_iAlive == -1)
		SetFailState("CCSPlayerResource.m_bAlive offset is invalid");
	
	g_iKills = FindSendPropInfo("CCSPlayerResource", "m_iKills");
	if (g_iKills == -1)
		SetFailState("CCSPlayerResource \"m_iKills\" offset is invalid");
	
	g_iDeaths = FindSendPropInfo("CCSPlayerResource", "m_iDeaths");
	if (g_iDeaths == -1)
		SetFailState("CCSPlayerResource \"m_iDeaths\"  offset is invalid");
	
	g_iAssists = FindSendPropInfo("CCSPlayerResource", "m_iAssists");
	if (g_iAssists == -1)
		SetFailState("CCSPlayerResource \"m_iAssists\"  offset is invalid");
	
	g_iMVPs = FindSendPropInfo("CCSPlayerResource", "m_iMVPs");
	if (g_iMVPs == -1)
		SetFailState("CCSPlayerResource \"m_iMVPs\"  offset is invalid");
	
    
	int iPlayerManagerPost = FindEntityByClassname(0, "cs_player_manager"); 
	SDKHook(iPlayerManagerPost, SDKHook_ThinkPost, ThinkPost);
	
	resetPlayers();
}

public void ThinkPost(int entity) 
{
	int isAlive[65];
	
	GetEntDataArray(entity, g_iAlive, isAlive, 65);
	LoopValidClients(i)
	{
		if(IsPlayerAlive(i) || !g_bFound[i])
			isAlive[i] = true;
		else
			isAlive[i] = false;
	}
	SetEntDataArray(entity, g_iAlive, isAlive, 65);
	
	if(g_iConfig[b_kadRemover])
	{
		int iZero[MAXPLAYERS + 1] =  { 0, ... };
		
		SetEntDataArray(entity, g_iKills, iZero, MaxClients + 1);
		SetEntDataArray(entity, g_iDeaths, iZero, MaxClients + 1);
		SetEntDataArray(entity, g_iAssists, iZero, MaxClients + 1);
		SetEntDataArray(entity, g_iMVPs, iZero, MaxClients + 1);
	}
}

public Action Command_Karma(int client, int args)
{
	CPrintToChat(client, g_iConfig[s_pluginTag], "Your karma is", client, g_iKarma[client]);
	
	return Plugin_Handled;
}

public Action Event_RoundStartPre(Event event, const char[] name, bool dontBroadcast)
{
	ClearArray(g_hRagdollArray);
	
	g_bInactive = false;
	LoopValidClients(i)
	{
		g_iRole[i] = TTT_TEAM_UNASSIGNED;
		g_bFound[i] = true;
		g_iInnoKills[i] = 0;
		g_bHasC4[i] = false;
		g_bImmuneRDMManager[i] = false;
		
		CS_SetClientClanTag(i, "");
	}

	if(g_hStartTimer != null)
		KillTimer(g_hStartTimer);

	if(g_hCountdownTimer != null)
		KillTimer(g_hCountdownTimer);
	
	float warmupTime = GetConVarFloat(g_hGraceTime) + 5.0;
	g_hStartTimer = CreateTimer(warmupTime, Timer_Selection, _ , TIMER_FLAG_NO_MAPCHANGE);
	
	g_fRealRoundStart = GetGameTime() + warmupTime;
	g_hCountdownTimer = CreateTimer(0.5, Timer_SelectionCountdown, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	g_bRoundStarted = false;
	
	if (g_hRoundTimer != null) 
		CloseHandle(g_hRoundTimer);
		
	g_hRoundTimer = CreateTimer(GetConVarFloat(FindConVar("mp_roundtime")) * 60.0, Timer_OnRoundEnd);
	
	if(g_iConfig[b_removeHostages])
		RemoveHostages();
	
	ShowOverlayToAll("");
	resetPlayers();
	healthStation_cleanUp();
}

stock void RemoveHostages()
{
	int entity = -1;
	while((entity  = FindEntityByClassname(entity, "func_bomb_target")) != -1)
		AcceptEntityInput(entity, "kill");
}

public Action Event_RoundEndPre(Event event, const char[] name, bool dontBroadcast)
{
	LoopValidClients(i)
	{
		g_bFound[i] = true;
		g_iInnoKills[i] = 0;
		g_bImmuneRDMManager[i] = false;
		
		ShowLogs(i);
		TeamTag(i);
	}
		
		
	if (g_hRoundTimer != null) {
		CloseHandle(g_hRoundTimer);
		g_hRoundTimer = null;
	}
	resetPlayers();
	healthStation_cleanUp();
}

public Action Timer_SelectionCountdown(Handle hTimer)
{
	int timeLeft = RoundToFloor(g_fRealRoundStart - GetGameTime());
	
	if (g_fRealRoundStart <= 0.0 || timeLeft <= 0)
	{
		g_hCountdownTimer = null;
		return Plugin_Stop;
	}
	
	char centerText[512];
	Format(centerText, sizeof(centerText), "<font size='32' color='00ff00'>%ds</font>", timeLeft);
	
	LoopValidClients(iClient)
		PrintHintText(iClient, centerText);
	
	return Plugin_Continue;
}

public Action Timer_Selection(Handle hTimer)
{
	g_hStartTimer = null;
	
	ClearArray(g_hPlayerArray);
	
	if(g_hDetectives == null) 
		g_hDetectives = CreateArray(1);
	
	if(g_hTraitores == null) 
		g_hTraitores = CreateArray(1);
	
	int iCount = 0;
	LoopValidClients(i)
	{
		if(GetClientTeam(i) <= CS_TEAM_SPECTATOR)
			continue;
		
		iCount++;
		PushArrayCell(g_hPlayerArray, i);
	}
		
	if(iCount < g_iConfig[i_requiredPlayers]) 
	{
		g_bInactive = true;
		LoopValidClients(i)
			CPrintToChat(i, g_iConfig[s_pluginTag], "MIN PLAYERS REQUIRED FOR PLAY", i, g_iConfig[i_requiredPlayers]);
		
		Call_StartForward(g_hOnRoundStartFailed);
		Call_PushCell(iCount);
		Call_PushCell(g_iConfig[i_requiredPlayers]);
		Call_Finish();
		
		return;
	}
	
	int iDetectives = RoundToNearest(iCount * float(g_iConfig[i_detectiveRatio])/100.0);
	if(iDetectives == 0)
		iDetectives = 1;
	
	bool needDetective = ( iCount >= g_iConfig[i_requiredPlayersD]);
	
	/* Not enough players to allow a detective */
	if(!needDetective)
		iDetectives = 0;
		
	int iTraitores = RoundToNearest(iCount * float(g_iConfig[i_traitorRatio])/100.0);
	if(iTraitores == 0)
		iTraitores = 1;
	
	int index;
	int player;
	while((index = GetRandomArray(g_hPlayerArray)) != -1)
	{
		player = GetArrayCell(g_hPlayerArray, index);
		
		if(iDetectives > 0 && (!g_iConfig[b_showDetectiveMenu] || g_bConfirmDetectiveRules[player]) && !IsPlayerInArray(player, g_hDetectives))
		{
			g_iRole[player] = TTT_TEAM_DETECTIVE;
			iDetectives--;
		}
		else if(iTraitores > 0 && !IsPlayerInArray(player, g_hTraitores))
		{
			g_iRole[player] = TTT_TEAM_TRAITOR;
			iTraitores--;
		}
		else g_iRole[player] = TTT_TEAM_INNOCENT;
		
		while (GetPlayerWeaponSlot(player, CS_SLOT_KNIFE) == -1)
			GivePlayerItem(player, "weapon_knife");
		
		if (GetPlayerWeaponSlot(player, CS_SLOT_SECONDARY) == -1)
			GivePlayerItem(player, "weapon_glock");
		
		g_bFound[player] = false;
		
		RemoveFromArray(g_hPlayerArray, index);
	}
	
	/* Recount roles */
	
	int iTraitors = 0;
	int iInnocent = 0;
	int iDetective = 0;
	
	LoopValidClients(i)
	{
		if (!IsPlayerAlive(i))
			continue;
		
		if(g_iRole[i] == TTT_TEAM_TRAITOR)
			iTraitors++;
		else if(g_iRole[i] == TTT_TEAM_DETECTIVE)
			iDetective++;
		else if(g_iRole[i] == TTT_TEAM_INNOCENT)
			iInnocent++;
	}
	
	/* No detective found, but we need one */
	if(iDetective == 0 && needDetective)
	{
		LoopValidClients(i)
		{
			if(g_iRole[i] != TTT_TEAM_INNOCENT && (!g_bConfirmDetectiveRules[i] && g_iConfig[b_showDetectiveMenu]))
				continue;
				
			iInnocent--;
			iDetective++;
			
			g_iRole[i] = TTT_TEAM_DETECTIVE;
			break;
		}
	}
	
	/* No triaitor found, but we need one */
	if(iTraitors == 0)
	{
		LoopValidClients(i)
		{
			if(g_iRole[i] != TTT_TEAM_INNOCENT)
				continue;
				
			iInnocent--;
			iTraitors++;
			
			g_iRole[i] = TTT_TEAM_TRAITOR;
			break;
		}
	}
	
	/* Remember role, to prevent same role next round for players */
	
	ClearArray(g_hDetectives);
	ClearArray(g_hTraitores);
	
	LoopValidClients(i)
	{
		if(g_iConfig[b_roleAgain])
		{
			if(g_iRole[i] == TTT_TEAM_DETECTIVE)
				PushArrayCell(g_hDetectives, i);
			else if(g_iRole[i] == TTT_TEAM_TRAITOR)
				PushArrayCell(g_hTraitores, i);
		}
	}

	LoopValidClients(i)
	{
		CPrintToChat(i, g_iConfig[s_pluginTag], "TEAMS HAS BEEN SELECTED", i);
		
		if(g_iRole[i] != TTT_TEAM_TRAITOR)
			CPrintToChat(i, g_iConfig[s_pluginTag], "TRAITORS HAS BEEN SELECTED", i, iTraitors);
		else
			listTraitors(i);
		
		if(GetClientTeam(i) <= CS_TEAM_SPECTATOR)
			continue;
			
		if(!IsPlayerAlive(i))
			continue;
			
		TeamInitialize(i);
	}
	
	ClearArray(g_hLogsArray);
	g_bRoundStarted = true;
	
	Call_StartForward(g_hOnRoundStart);
	Call_PushCell(iInnocent);
	Call_PushCell(iTraitors);
	Call_PushCell(iDetective);
	Call_Finish();
	
	ApplyIcons();
}

stock int GetRandomArray(Handle array)
{
	int size = GetArraySize(array);
	if(size == 0)
		return -1;
	return Math_GetRandomInt(0, size-1);
}

stock bool IsPlayerInArray(int player, Handle array)
{
	for(int i = 0;i < GetArraySize(array);i++)
	{
		if(player == GetArrayCell(array, i))
			return true;
	}
	
	return false;
}

stock void TeamInitialize(int client)
{
	if(!TTT_IsClientValid(client))
		return;
	
	if(g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		g_iIcon[client] = CreateIcon(client);
		CS_SetClientClanTag(client, "DETECTIVE");
		
		if(GetClientTeam(client) != CS_TEAM_CT)
			CS_SwitchTeam(client, CS_TEAM_CT);

		if (GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) == -1)
			GivePlayerItem(client, "weapon_m4a1_silencer");
			
		if(g_iConfig[b_taserAllow])
			GivePlayerItem(client, "weapon_taser");
			
		CPrintToChat(client, g_iConfig[s_pluginTag], "Your Team is DETECTIVES", client);
		SetEntityHealth(client, g_iConfig[i_spawnHPD]);
	}
	else if(g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		g_iIcon[client] = CreateIcon(client);
		CPrintToChat(client, g_iConfig[s_pluginTag], "Your Team is TRAITORS", client);
		SetEntityHealth(client, g_iConfig[i_spawnHPT]);
		
		if(GetClientTeam(client) != CS_TEAM_T)
			CS_SwitchTeam(client, CS_TEAM_T);
	}
	else if(g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "Your Team is INNOCENTS", client);
		SetEntityHealth(client, g_iConfig[i_spawnHPI]);
		
		if(GetClientTeam(client) != CS_TEAM_T)
			CS_SwitchTeam(client, CS_TEAM_T);
	}
	
	if(g_iConfig[b_updateClientModel])
		CS_UpdateClientModel(client);
	
	Call_StartForward(g_hOnClientGetRole);
	Call_PushCell(client);
	Call_PushCell(g_iRole[client]);
	Call_Finish();
}

stock void TeamTag(int client)
{
	if (!IsClientInGame(client) || client < 0 || client > MaxClients)
		return;
		
	if(g_iRole[client] == TTT_TEAM_DETECTIVE)
		CS_SetClientClanTag(client, "DETECTIVE");
	else if(g_iRole[client] == TTT_TEAM_TRAITOR)
		CS_SetClientClanTag(client, "TRAITOR");
	else if(g_iRole[client] == TTT_TEAM_INNOCENT)
		CS_SetClientClanTag(client, "INNOCENT");
}

stock void ApplyIcons()
{
	LoopValidClients(i)
		if(IsPlayerAlive(i))
			g_iIcon[i] = CreateIcon(i);
}

public Action Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if(TTT_IsClientValid(client))
	{
		CS_SetClientClanTag(client, "");
		
		g_iInnoKills[client] = 0;
		
		StripAllWeapons(client);
		
		ClearTimer(g_hJihadBomb[client]);
		g_bDetonate[client] = false;
		
		if(g_bInactive)
		{
			int iCount = 0;
			
			LoopValidClients(i)
				if(IsPlayerAlive(i))
					iCount++;
			
			if(iCount >= 3)
				ServerCommand("mp_restartgame 2");
		}
		else
		{
			CPrintToChat(client, g_iConfig[s_pluginTag], "Your credits is", client, g_iCredits[client]);
			CPrintToChat(client, g_iConfig[s_pluginTag], "Your karma is", client, g_iKarma[client]);
		}
		
		g_b1Knife[client] = false;
		g_bScan[client] = false;
		g_bID[client] = false;
		// g_bRadar[client] = false;
		g_bJihadBomb[client] = false;
		
		if(g_iConfig[b_enableNoBlock])
			SetNoBlock(client);
	}
}

public void OnClientPutInServer(int client)
{
	char steamid[64];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	
	g_bImmuneRDMManager[client] = false;
	
	SDKHook(client, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
	SDKHook(client, SDKHook_TraceAttack, OnTraceAttack);
	SDKHook(client, SDKHook_WeaponSwitchPost, OnWeaponPostSwitch);
	SDKHook(client, SDKHook_PreThink, OnPreThink);
	
	SetEntData(client, g_iAccount, 16000);
		
	g_iCredits[client] = 800;
}

public Action OnPreThink(int client)
{
	if(TTT_IsClientValid(client))
		CS_SetClientContributionScore(client, g_iKarma[client]);
}

stock void AddStartKarma(int client)
{
	setKarma(client, g_iConfig[i_startKarma]);
}

stock void BanBadPlayerKarma(int client)
{
	char sReason[512];
	Format(sReason, sizeof(sReason), "%T", "Your Karma is too low", client);
	
	setKarma(client, g_iConfig[i_startKarma]);
	
	ServerCommand("sm_ban #%d %d \"%s\"", GetClientUserId(client), g_iConfig[i_karmaBanLength], sReason);
}

public Action OnTraceAttack(int iVictim, int &iAttacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if(!g_bRoundStarted)
		return Plugin_Handled;
	
	if(IsWorldDamage(iAttacker, damagetype))
		return Plugin_Continue;
	
	if(!TTT_IsClientValid(iVictim) || !TTT_IsClientValid(iAttacker))
		return Plugin_Continue;
	
	char item[512], sWeapon[64];
	GetClientWeapon(iAttacker, sWeapon, sizeof(sWeapon));
	if(StrEqual(sWeapon, "weapon_taser", false))
	{
		if(g_iRole[iVictim] == TTT_TEAM_TRAITOR)
		{
			Format(item, sizeof(item), "-> [%N tased %N (Traitor)] - TRAITOR DETECTED", iAttacker, iVictim);
			PushArrayString(g_hLogsArray, item);
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You hurt a Traitor", iVictim, iVictim);
			addCredits(iAttacker, g_iConfig[i_creditsTaserHurtTraitor]);
		}
		else if(g_iRole[iVictim] == TTT_TEAM_DETECTIVE) {
			Format(item, sizeof(item), "-> [%N tased %N (Detective)]", iVictim, iAttacker, iVictim);
			PushArrayString(g_hLogsArray, item);
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You hurt a Detective", iVictim, iVictim);
		}
		else if(g_iRole[iVictim] == TTT_TEAM_INNOCENT) {
			Format(item, sizeof(item), "-> [%N tased %N (Innocent)]", iVictim, iAttacker, iVictim);
			PushArrayString(g_hLogsArray, item);
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You hurt an Innocent", iVictim, iVictim);
		}

		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action OnTakeDamageAlive(int iVictim, int &iAttacker, int &inflictor, float &damage, int &damagetype)
{
	if(!g_bRoundStarted)
		return Plugin_Handled;
	
	if(IsWorldDamage(iAttacker, damagetype))
		return Plugin_Continue;
	
	if(!TTT_IsClientValid(iVictim) || !TTT_IsClientValid(iAttacker))
		return Plugin_Continue;

	char sWeapon[64];
	GetClientWeapon(iAttacker, sWeapon, sizeof(sWeapon));
	if(g_b1Knife[iAttacker] && (StrContains(sWeapon, "knife", false) != -1) || (StrContains(sWeapon, "bayonet", false) != -1))
	{
		Remove1Knife(iAttacker);
		damage = float(GetClientHealth(iVictim) + GetClientArmor(iVictim));
		return Plugin_Changed;
	}
	
	/* if(g_iKarma[iAttacker] > 100)
		return Plugin_Continue;
	
	damage = (damage * (g_iKarma[iAttacker] * 0.01));
	
	if(damage < 1.0)
		damage = 1.0; */
	
	return Plugin_Continue;
}

stock bool IsWorldDamage(int iAttacker, int damagetype)
{
	if(damagetype == DMG_FALL
		|| damagetype == DMG_GENERIC
		|| damagetype == DMG_CRUSH
		|| damagetype == DMG_SLASH
		|| damagetype == DMG_BURN
		|| damagetype == DMG_VEHICLE
		|| damagetype == DMG_FALL
		|| damagetype == DMG_BLAST
		|| damagetype == DMG_SHOCK
		|| damagetype == DMG_SONIC
		|| damagetype == DMG_ENERGYBEAM
		|| damagetype == DMG_DROWN
		|| damagetype == DMG_PARALYZE
		|| damagetype == DMG_NERVEGAS
		|| damagetype == DMG_POISON
		|| damagetype == DMG_ACID
		|| damagetype == DMG_AIRBOAT
		|| damagetype == DMG_PLASMA
		|| damagetype == DMG_RADIATION
		|| damagetype == DMG_SLOWBURN
		|| iAttacker == 0
	)
		return true;
	return false;
}

public Action Event_PlayerDeathPre(Event event, const char[] menu, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	g_iInnoKills[client] = 0;
	ClearIcon(client);
	
	ClearTimer(g_hJihadBomb[client]);
	if(g_iRole[client] > TTT_TEAM_UNASSIGNED)
	{
		char playermodel[128];
		GetClientModel(client, playermodel, 128);
	
		float origin[3], angles[3], velocity[3];
	
		GetClientAbsOrigin(client, origin);
		GetClientAbsAngles(client, angles);
		GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);
	
		int iEntity = CreateEntityByName("prop_ragdoll");
		DispatchKeyValue(iEntity, "model", playermodel);
		DispatchSpawn(iEntity);
	
		float speed = GetVectorLength(velocity);
		if(speed >= 500) TeleportEntity(iEntity, origin, angles, NULL_VECTOR); 
		else TeleportEntity(iEntity, origin, angles, velocity); 
	
		SetEntData(iEntity, g_iCollisionGroup, 2, 4, true);
	

		int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
		char name[32];
		GetClientName(client, name, sizeof(name));
		int Items[Ragdolls];
		Items[ent] = EntIndexToEntRef(iEntity);
		Items[victim] = client;
		Format(Items[victimName], 32, name);
		Items[scanned] = false;
		GetClientName(iAttacker, name, sizeof(name));
		Items[attacker] = iAttacker;
		Format(Items[attackerName], 32, name);
		Items[gameTime] = GetGameTime();
		event.GetString("weapon", Items[weaponused], sizeof(Items[weaponused]));
	
		PushArrayArray(g_hRagdollArray, Items[0]);
		
		if (client != iAttacker && iAttacker != 0 && !g_bImmuneRDMManager[iAttacker] && !g_bHoldingProp[client] && !g_bHoldingSilencedWep[client])
		{
			if (g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_TRAITOR)
			{
				if (g_hRDMTimer[client] != null)
					KillTimer(g_hRDMTimer[client]);
				g_hRDMTimer[client] = CreateTimer(3.0, Timer_RDMTimer, GetClientUserId(client));
				g_iRDMAttacker[client] = iAttacker;
			}
			else if (g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_DETECTIVE)
			{
				if (g_hRDMTimer[client] != null)
					KillTimer(g_hRDMTimer[client]);
				g_hRDMTimer[client] = CreateTimer(3.0, Timer_RDMTimer, GetClientUserId(client));
				g_iRDMAttacker[client] = iAttacker;
			}
			else if (g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_DETECTIVE)
			{
				if (g_hRDMTimer[client] != null)
					KillTimer(g_hRDMTimer[client]);
				g_hRDMTimer[client] = CreateTimer(3.0, Timer_RDMTimer, GetClientUserId(client));
				g_iRDMAttacker[client] = iAttacker;
			}
			else if ((g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_INNOCENT) || (g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_INNOCENT)) {
				g_iInnoKills[iAttacker]++;
			}

			if (g_iInnoKills[iAttacker] >= g_iConfig[i_punishInnoKills])
				ServerCommand("sm_slay #%i 5", GetClientUserId(iAttacker));
		}
	}
	if(!dontBroadcast)
	{	
		dontBroadcast = true;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public void OnClientPostAdminCheck(int client)
{
	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	nameCheck(client, name);
	
	LoadClientKarma(GetClientUserId(client));
	
	if(g_iConfig[b_showRulesMenu])
		CreateTimer(3.0, Timer_ShowWelcomeMenu, GetClientUserId(client));
	else if(g_iConfig[b_showDetectiveMenu])
		CreateTimer(3.0, Timer_ShowDetectiveMenu, GetClientUserId(client));
}

public Action Timer_ShowWelcomeMenu(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	
	if(TTT_IsClientValid(client))
	{
		char sText[512], sYes[64];
		Format(sText, sizeof(sText), "%T", "Welcome Menu", client, client, TTT_PLUGIN_AUTHOR);
		Format(sYes, sizeof(sYes), "%T", "WM Yes", client);
		
		Menu menu = new Menu(Menu_ShowWelcomeMenu);
		menu.SetTitle(sText);
		
		// open rule file
		Handle hFile = OpenFile(g_sRulesFile, "rt");
		
		if(hFile == null)
			SetFailState("[TTT] Can't open File: %s", g_sRulesFile);
			
		KeyValues kvRules = CreateKeyValues("Rules");
		
		if(!kvRules.ImportFromFile(g_sRulesFile))
		{
			SetFailState("Can't read rules/start.cfg correctly! (ImportFromFile)");
			return;
		}
		
		if (!kvRules.GotoFirstSubKey())
		{
			SetFailState("Can't read rules/start.cfg correctly! (GotoFirstSubKey)");
			return;
		}
		
		do
		{
			char sNumber[4];
			char sTitle[64];
			
			kvRules.GetSectionName(sNumber, sizeof(sNumber));
			kvRules.GetString("title", sTitle, sizeof(sTitle));
			menu.AddItem(sNumber, sTitle);
		}
		while (kvRules.GotoNextKey());
		
		delete kvRules;
		
		menu.AddItem("yes", sYes);
		menu.ExitButton = false;
		menu.ExitBackButton = false;
		menu.Display(client, g_iConfig[i_timeToReadRules]);
	}
}

public int Menu_ShowWelcomeMenu(Menu menu, MenuAction action, int client, int param) 
{
	if ( action == MenuAction_Select ) 
	{
		char sParam[32];
		GetMenuItem(menu, param, sParam, sizeof(sParam));
		
		if (!StrEqual(sParam, "yes", false))
		{
			g_bKnowRules[client] = false;
			g_bReadRules[client] = true;
		}
		else
		{
			g_bKnowRules[client] = true;
			g_bReadRules[client] = false;
		}
		
		if(g_iConfig[b_showDetectiveMenu])
			AskClientForMicrophone(client);
	}
	else if(action == MenuAction_Cancel)
	{
		if(TTT_IsClientValid(client) && g_iConfig[i_rulesClosePunishment] == 0)
		{
			char sFlags[16];
			AdminFlag aFlags[16];
			
			Format(sFlags, sizeof(sFlags), g_iConfig[s_kickImmunity]);
			FlagBitsToArray(ReadFlagString(sFlags), aFlags, sizeof(aFlags));
			
			if (!TTT_HasFlags(client, aFlags))
			{
				char sMessage[128];
				Format(sMessage, sizeof(sMessage), "%T", "WM Kick Message", client);
				KickClient(client, sMessage);
			}
		}
	}
	else if (action == MenuAction_End)
		delete menu;
	
	return 0;
}

public Action Timer_ShowDetectiveMenu(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	
	if(TTT_IsClientValid(client))
	{
		AskClientForMicrophone(client);
	}
}

stock void AskClientForMicrophone(int client)
{
	char sText[512], sYes[64], sNo[64];
	Format(sText, sizeof(sText), "%T", "AM Question", client);
	Format(sYes, sizeof(sYes), "%T", "AM Yes", client);
	Format(sNo, sizeof(sNo), "%T", "AM No", client);
	
	Menu menu = new Menu(Menu_AskClientForMicrophone);
	menu.SetTitle(sText);
	menu.AddItem("no", sNo);
	menu.AddItem("yes", sYes);
	menu.ExitButton = false;
	menu.ExitBackButton = false;
	menu.Display(client, g_iConfig[i_timeToReadDetectiveRules]);
}


public int Menu_AskClientForMicrophone(Menu menu, MenuAction action, int client, int param) 
{
	if ( action == MenuAction_Select ) 
	{
		char sParam[32];
		GetMenuItem(menu, param, sParam, sizeof(sParam));
		
		if (!StrEqual(sParam, "yes", false))
			g_bConfirmDetectiveRules[client] = false;
		else
			g_bConfirmDetectiveRules[client] = true;
	}
	else if(action == MenuAction_Cancel)
		g_bConfirmDetectiveRules[client] = false;
	else if (action == MenuAction_End)
		delete menu;
	
	return 0;
}

public void OnClientDisconnect(int client)
{
	if(IsClientInGame(client))
	{
		g_bKarma[client] = false;
		
		ClearTimer(g_hRDMTimer[client]);
		ClearTimer(g_hRemoveCoolDownTimer[client]);
		ClearIcon(client);
		
		ClearTimer(g_hJihadBomb[client]);
		
		g_bReceivingLogs[client] = false;
		g_bImmuneRDMManager[client] = false;
	/* 	int iSize = GetArraySize(g_hRagdollArray);
		
		if(iSize == 0) return;
		
		int Items[Ragdolls];
				
		for(int i = 0;i < GetArraySize(g_hRagdollArray);i++)
		{
			GetArrayArray(g_hRagdollArray, i, Items[0]);
					
			if(client == Items[attacker] || client == Items[victim])
			{
				int entity = EntRefToEntIndex(Items[index]);
				if(entity != INVALID_ENT_REFERENCE) AcceptEntityInput(entity, "kill");
						
				RemoveFromArray(g_hRagdollArray, i);
				break;
			}
		}  */
		
		ClearTimer(g_hExplosionTimer[client]);
	}
}

public Action Event_ChangeName(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (!IsClientInGame(client)) return;
		
	char userName[32];
	event.GetString("newname", userName, sizeof(userName));
	nameCheck(client, userName);
	
 	int iSize = GetArraySize(g_hRagdollArray);
	
	if(iSize == 0)
		return;
	
	int Items[Ragdolls];
			
	for(int i = 0;i < GetArraySize(g_hRagdollArray);i++)
	{
		GetArrayArray(g_hRagdollArray, i, Items[0]);
				
		if(client == Items[attacker])
		{
			Format(Items[attackerName], 32, userName);
			SetArrayArray(g_hRagdollArray, i, Items[0]);
		}
		else if(client == Items[victim])
		{
			Format(Items[victimName], 32, userName);
			SetArrayArray(g_hRagdollArray, i, Items[0]);
		}
	} 
}

public Action Timer_Adjust(Handle timer)
{
	int g_iInnoAlive = 0;
	int g_iTraitorAlive = 0;
	int g_iDetectiveAlive = 0;
	float vec[3];
	LoopValidClients(i)
		if(IsPlayerAlive(i))
		{
			if(g_iRole[i] == TTT_TEAM_TRAITOR)
			{
				GetClientAbsOrigin(i, vec);
		
				vec[2] += 10;
				g_iTraitorAlive++;
				int[] clients = new int[MaxClients];
				int index = 0;
				
				LoopValidClients(j)
					if(IsPlayerAlive(j) && j != i && (g_iRole[j] == TTT_TEAM_TRAITOR))
					{
						clients[index] = j;
						index++;
					}
				
				TE_SetupBeamRingPoint(vec, 50.0, 60.0, g_iBeamSprite, g_iHaloSprite, 0, 15, 0.1, 10.0, 0.0, {0, 0, 255, 255}, 10, 0);
				TE_Send(clients, index);
			}
			else if(g_iRole[i] == TTT_TEAM_INNOCENT)
				g_iInnoAlive++;
			else if(g_iRole[i] == TTT_TEAM_DETECTIVE)
				g_iDetectiveAlive++;

			int money = GetEntData(i, g_iAccount);
			if(money != 16000)
				SetEntData(i, g_iAccount, 16000);
		}
		
	if(g_bRoundStarted)
	{
		if(g_iInnoAlive == 0 && g_iDetectiveAlive == 0)
		{
			g_bRoundStarted = false;
			CS_TerminateRound(7.0, CSRoundEnd_TerroristWin);
		}
		else if(g_iTraitorAlive == 0)
		{		
			g_bRoundStarted = false;
			CS_TerminateRound(7.0, CSRoundEnd_CTWin);
		}
	}
}

public Action Command_Credits(int client, int args)
{
	CPrintToChat(client, g_iConfig[s_pluginTag], "Your credits is", client, g_iCredits[client]);
	
	return Plugin_Handled;
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if (!TTT_IsClientValid(client))
		return;
    
	int iRagdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (iRagdoll < 0)
		return;

	AcceptEntityInput(iRagdoll, "Kill");
	
	int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
	if(!TTT_IsClientValid(iAttacker) || iAttacker == client)
		return;
	
	int assister = GetClientOfUserId(event.GetInt("assister"));
	if(!TTT_IsClientValid(assister) || assister == client)
		return;
	
	if (g_iConfig[b_showDeathMessage])
	{
		if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR)
			CPrintToChat(client, g_iConfig[s_pluginTag], "Your killer is a Traitor", client);
		else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE)
			CPrintToChat(client, g_iConfig[s_pluginTag], "Your killer is a Detective", client);
		else if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT)
			CPrintToChat(client, g_iConfig[s_pluginTag], "Your killer is an Innocent", client);
	}
	
	if(g_iConfig[b_showKillMessage])
	{
		if(g_iRole[client] == TTT_TEAM_TRAITOR)
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You killed a Traitor", client);
		else if(g_iRole[client] == TTT_TEAM_DETECTIVE)
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You killed a Detective", client);
		else if(g_iRole[client] == TTT_TEAM_INNOCENT)
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "You killed an Innocent", client);
	}
	
	char item[512];
	
	if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) killed %N (Innocent)] - BAD ACTION", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		subtractKarma(iAttacker, g_iConfig[i_karmaII], true);
		subtractCredits(iAttacker, g_iConfig[i_creditsII], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) killed %N (Traitor)]", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		addKarma(iAttacker, g_iConfig[i_karmaIT], true);
		addCredits(iAttacker, g_iConfig[i_creditsIT], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) killed %N (Detective)] - BAD ACTION", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		subtractKarma(iAttacker, g_iConfig[i_karmaID], true);
		subtractCredits(iAttacker, g_iConfig[i_creditsID], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) killed %N (Innocent)]", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		addKarma(iAttacker, g_iConfig[i_karmaTI], true);
		addCredits(iAttacker, g_iConfig[i_creditsTI], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) killed %N (Traitor)] - BAD ACTION", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		subtractKarma(iAttacker, g_iConfig[i_karmaTT], true);
		subtractCredits(iAttacker, g_iConfig[i_creditsTT], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) killed %N (Detective)]", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		addKarma(iAttacker, g_iConfig[i_karmaTD], true);
		addCredits(iAttacker, g_iConfig[i_creditsTD], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Detective) killed %N (Innocent)] - BAD ACTION", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		subtractKarma(iAttacker, g_iConfig[i_karmaDI], true);
		subtractCredits(iAttacker, g_iConfig[i_creditsDI], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Detective) killed %N (Traitor)]", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		addKarma(iAttacker, g_iConfig[i_karmaDT], true);
		addCredits(iAttacker, g_iConfig[i_creditsDT], true);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Detective) killed %N (Detective)] - BAD ACTION", iAttacker, client);
		PushArrayString(g_hLogsArray, item);
		
		subtractKarma(iAttacker, g_iConfig[i_karmaDD], true);
		subtractCredits(iAttacker, g_iConfig[i_creditsDD], true);
	}
	
	Call_StartForward(g_hOnClientDeath);
	Call_PushCell(client);
	Call_PushCell(iAttacker);
	Call_Finish();
}

stock int CreateIcon(int client) {
  
	ClearIcon(client);
	if(g_iRole[client] < TTT_TEAM_TRAITOR || !g_bRoundStarted)
		return 0;
	
	char iTarget[16];
	Format(iTarget, 16, "client%d", client);
	DispatchKeyValue(client, "targetname", iTarget);

	float origin[3];
  
	GetClientAbsOrigin(client, origin);				
	origin[2] = origin[2] + 80.0;

	int Ent = CreateEntityByName("env_sprite");
	if(!Ent) return -1;

	if(g_iRole[client] == TTT_TEAM_DETECTIVE) DispatchKeyValue(Ent, "model", "sprites/sg_detective_icon.vmt");
	else if(g_iRole[client] == TTT_TEAM_TRAITOR) DispatchKeyValue(Ent, "model", "sprites/sg_traitor_icon.vmt");
	DispatchKeyValue(Ent, "classname", "env_sprite");
	DispatchKeyValue(Ent, "spawnflags", "1");
	DispatchKeyValue(Ent, "scale", "0.08");
	DispatchKeyValue(Ent, "rendermode", "1");
	DispatchKeyValue(Ent, "rendercolor", "255 255 255");
	DispatchSpawn(Ent);
	TeleportEntity(Ent, origin, NULL_VECTOR, NULL_VECTOR);
	SetVariantString(iTarget);
	AcceptEntityInput(Ent, "SetParent", Ent, Ent, 0);
 
	if(g_iRole[client] == TTT_TEAM_TRAITOR)
		SDKHook(Ent, SDKHook_SetTransmit, Hook_SetTransmitT); 
	return Ent;
}

public Action Hook_SetTransmitT(int entity, int client) 
{ 
    if (entity != client && g_iRole[client] != TTT_TEAM_TRAITOR && IsPlayerAlive(client)) 
        return Plugin_Handled;
     
    return Plugin_Continue; 
}  

public void OnMapEnd() 
{
	if (g_hRoundTimer != null) 
	{
		CloseHandle(g_hRoundTimer);
		g_hRoundTimer = null;
	}
	
	g_hStartTimer = null;
	g_hCountdownTimer = null;
	
	resetPlayers();
	
	LoopValidClients(i)
		g_bKarma[i] = false;
}

public Action Timer_OnRoundEnd(Handle timer) 
{
	g_hRoundTimer = null;
	g_bRoundStarted = false;
	CS_TerminateRound(7.0, CSRoundEnd_CTWin);
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	if(g_bRoundStarted)
		return Plugin_Handled;
	
	LoopValidClients(client)
		if(IsPlayerAlive(client))
			ClearIcon(client);
	
	bool bInnoAlive = false;
	
	if(reason == CSRoundEnd_CTWin)
	{
		LoopValidClients(client)
		{
			if(g_iRole[client] != TTT_TEAM_TRAITOR && g_iRole[client] != TTT_TEAM_UNASSIGNED)
			{
				if(IsPlayerAlive(client))
				{
					if(g_iRole[client] == TTT_TEAM_INNOCENT)
						bInnoAlive = true;
					
					addCredits(client, g_iConfig[i_traitorloseAliveNonTraitors]);
				}
				else
					addCredits(client, g_iConfig[i_traitorloseDeadNonTraitors]);
			}
		}
	}
	else if(reason == CSRoundEnd_TerroristWin)
	{
		LoopValidClients(client)
		{
			if(g_iRole[client] == TTT_TEAM_TRAITOR)
			{
				if(IsPlayerAlive(client))
					addCredits(client, g_iConfig[i_traitorwinAliveTraitors]);
				else
					addCredits(client, g_iConfig[i_traitorwinDeadTraitors]);
			}
		}
	}
	
	if(reason == CSRoundEnd_TerroristWin)
		ShowOverlayToAll("overlays/ttt/traitors_win");
	else if(reason == CSRoundEnd_CTWin && bInnoAlive)
		ShowOverlayToAll("overlays/ttt/innocents_win");
	else if(reason == CSRoundEnd_CTWin && !bInnoAlive)
		ShowOverlayToAll("overlays/ttt/detectives_win");
	
	
	healthStation_cleanUp();
	return Plugin_Continue;
}

stock void ShowOverlayToClient(int client, const char[] overlaypath)
{
	ClientCommand(client, "r_screenoverlay \"%s\"", overlaypath);
}

stock void ShowOverlayToAll(const char[] overlaypath)
{
	LoopValidClients(i)
		if(!IsFakeClient(i))
			ShowOverlayToClient(i, overlaypath);
}

stock void StripAllWeapons(int client)
{
    int iEnt;
    for (int i = 0; i <= 4; i++)
    {
		while ((iEnt = GetPlayerWeaponSlot(client, i)) != -1)
		{
            RemovePlayerItem(client, iEnt);
            AcceptEntityInput(iEnt, "Kill");
		}
    }
}  

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{	
	int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
	if(!iAttacker)
		return;

	int client = GetClientOfUserId(event.GetInt("userid"));
	
	
	int damage = event.GetInt("dmg_health");
	char item[512];
	if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) damaged %N (Innocent) for %i damage] - BAD ACTION", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) damaged %N (Traitor) for %i damage]", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_INNOCENT && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Innocent) damaged %N (Detective) for %i damage] - BAD ACTION", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) damaged %N (Innocent) for %i damage]", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
		
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) damaged %N (Traitor) for %i damage] - BAD ACTION", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
		
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_TRAITOR && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Traitor) damaged %N (Detective) for %i damage]", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_INNOCENT)
	{
		Format(item, sizeof(item), "-> [%N (Detective) damaged %N (Innocent) for %i damage] - BAD ACTION", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
		
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		Format(item, sizeof(item), "-> [%N (Detective) damaged %N (Traitor) for %i damage]", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
	else if(g_iRole[iAttacker] == TTT_TEAM_DETECTIVE && g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(item, sizeof(item), "-> [%N (Detective) damaged %N (Detective) for %i damage] - BAD ACTION", iAttacker, client, damage);
		PushArrayString(g_hLogsArray, item);
	}
}

public Action Event_ItemPickup(Event event, const char[] name, bool dontBroadcast)
{
	if(!g_iConfig[b_removeBomb])
		return Plugin_Continue;

	char sItem[32];
	event.GetString("item", sItem, sizeof(sItem));
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if(TTT_IsClientValid(client))
	{
		if(!g_bHasC4[client] && !g_bJihadBomb[client])
		{
			int iC4 = GetPlayerWeaponSlot(client, CS_SLOT_C4);
			if(iC4 != -1)
			{
				RemovePlayerItem(client, iC4); 
				AcceptEntityInput(iC4, "Kill");
			}
			
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3])
{
	if(!IsClientInGame(client)) return Plugin_Continue;
	
	if(buttons & IN_USE)
	{
		g_bHoldingProp[client] = true;
		
		int entidad = GetClientAimTarget(client, false);
		if(entidad > 0)
		{
			float OriginG[3], TargetOriginG[3];
			GetClientEyePosition(client, TargetOriginG);
			GetEntPropVector(entidad, Prop_Data, "m_vecOrigin", OriginG);
			if(GetVectorDistance(TargetOriginG,OriginG, false) > 90.0) 
				return Plugin_Continue;
			
		 	int iSize = GetArraySize(g_hRagdollArray);
			if(iSize == 0)
				return Plugin_Continue;
	
			int Items[Ragdolls];
			int entity;
			
			for(int i = 0;i < iSize;i++)
			{
				GetArrayArray(g_hRagdollArray, i, Items[0]);
				entity = EntRefToEntIndex(Items[ent]);
				
				if(entity == entidad)
				{
					MostrarMenu(client, Items[victim], Items[attacker], RoundToNearest(GetGameTime()-Items[gameTime]), Items[weaponused], Items[victimName], Items[attackerName]);
					
					if(!Items[found] && IsPlayerAlive(client))
					{
						Items[found] = true;
						if(IsClientInGame(Items[victim]))
							g_bFound[Items[victim]] = true;
						
						if(g_iRole[Items[victim]] == TTT_TEAM_INNOCENT) 
						{
							LoopValidClients(j)
								CPrintToChat(j, g_iConfig[s_pluginTag], "Found Innocent", j, client, Items[victimName]);
							SetEntityRenderColor(entidad, 0, 255, 0, 255);
						}
						else if(g_iRole[Items[victim]] == TTT_TEAM_DETECTIVE)
						{
							LoopValidClients(j)
								CPrintToChat(j, g_iConfig[s_pluginTag], "Found Detective", j, client, Items[victimName]);
							SetEntityRenderColor(entidad, 0, 0, 255, 255);
						}
						else if(g_iRole[Items[victim]] == TTT_TEAM_TRAITOR) 
						{
							LoopValidClients(j)
								CPrintToChat(j, g_iConfig[s_pluginTag], "Found Traitor", j, client,Items[victimName]);
							SetEntityRenderColor(entidad, 255, 0, 0, 255);
						}
						
						TeamTag(Items[victim]);
						
						Call_StartForward(g_hOnBodyFound);
						Call_PushCell(client);
						Call_PushCell(Items[victim]);
						Call_PushString(Items[victimName]);
						Call_Finish();
						
						addCredits(client, g_iConfig[i_creditsFoundBody]);
					}
					
					if(g_bScan[client] && !Items[scanned] && IsPlayerAlive(client))
					{
						Call_StartForward(g_hOnBodyScanned);
						Call_PushCell(client);
						Call_PushCell(Items[victim]);
						Call_PushString(Items[victimName]);
						Call_Finish();
						
						Items[scanned] = true;
						if(Items[attacker] > 0 && Items[attacker] != Items[victim])
						{
							LoopValidClients(j)
								CPrintToChat(j, g_iConfig[s_pluginTag], "Detective scan found body", j, client, Items[attackerName], Items[weaponused]);
						}
						else
						{
							LoopValidClients(j)
								CPrintToChat(j, g_iConfig[s_pluginTag], "Detective scan found body suicide", j, client);
						}
					}
					SetArrayArray(g_hRagdollArray, i, Items[0]);
					
					break;
				}
			} 
		}
	}
	else g_bHoldingProp[client] = false;
	
	if (buttons & IN_RELOAD && g_iDefusePlayerIndex[client] == -1)
	{
		int target = GetClientAimTarget(client, false);
		if (target > 0)
		{
			float clientEyes[3], targetOrigin[3];
			GetClientEyePosition(client, clientEyes);
			GetEntPropVector(target, Prop_Data, "m_vecOrigin", targetOrigin);
			if (GetVectorDistance(clientEyes, targetOrigin) > 100.0)
				return Plugin_Continue;
				
			int iEnt;
			while ((iEnt = FindEntityByClassname(iEnt, "prop_physics")) != -1)
			{
				int planter = GetEntProp(target, Prop_Send, "m_hOwnerEntity");
				
				if (planter < 1 || planter > MaxClients || !IsClientInGame(planter))
					return Plugin_Continue;
				
				char sModelPath[PLATFORM_MAX_PATH];
				GetEntPropString(iEnt, Prop_Data, "m_ModelName", sModelPath, sizeof(sModelPath));
				
				if(!StrEqual(MDL_C4, sModelPath))
					return Plugin_Continue;
					
				if (target == iEnt)
				{
					g_iDefusePlayerIndex[client] = planter;
					showDefuseMenu(client);
				}
			}
		}
	}
	
	if (buttons & IN_ATTACK2 && !g_bHasActiveBomb[client] && g_bHasC4[client])
	{
		g_bHasActiveBomb[client] = true;
		int bombEnt = CreateEntityByName("prop_physics");
		if (bombEnt != -1)
		{
			float clientPos[3];
			GetClientAbsOrigin(client, clientPos);
			SetEntProp(bombEnt, Prop_Data, "m_CollisionGroup", 1);
			SetEntProp(bombEnt, Prop_Send, "m_hOwnerEntity", client);
			DispatchKeyValue(bombEnt, "model", MDL_C4);
			DispatchSpawn(bombEnt);
			TeleportEntity(bombEnt, clientPos, NULL_VECTOR, NULL_VECTOR);
			showPlantMenu(client);
		}
	}
	return Plugin_Continue;
}

public Action Command_ID(int client, int args)
{
	if(g_bID[client] && IsPlayerAlive(client))
	{
		LoopValidClients(i)
			CPrintToChat(i, g_iConfig[s_pluginTag], "Player Is an Innocent", i, client);
	}
	else
		CPrintToChat(client, g_iConfig[s_pluginTag], "You dont have it!", client);
	
	return Plugin_Handled;

}

public Action Command_Say(int client, const char[] command, int argc)
{
	if(!TTT_IsClientValid(client) || !IsPlayerAlive(client))
		return Plugin_Continue;
	
	char sText[MAX_MESSAGE_LENGTH];
	GetCmdArgString(sText, sizeof(sText));
	
	StripQuotes(sText);
	
	if (sText[0] == '@')
		return Plugin_Continue;
	
	for (int i = 0; i < sizeof(g_sShopCMDs); i++)
	{
		char sBuffer[64];
		Format(sBuffer, sizeof(sBuffer), "!%s", g_sShopCMDs[i]);
		
		if (StrEqual(sText, sBuffer, false))
			return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Command_SayTeam(int client, const char[] command, int argc)
{
	if(!TTT_IsClientValid(client) || !IsPlayerAlive(client))
		return Plugin_Continue;
	
	char sText[MAX_MESSAGE_LENGTH];
	GetCmdArgString(sText, sizeof(sText));
	
	StripQuotes(sText);
	
	if(strlen(sText) < 2)
		return Plugin_Handled;
		
	if (sText[0] == '@')
		return Plugin_Continue;
		
	for (int i = 0; i < sizeof(g_sShopCMDs); i++)
	{
		char sBuffer[64];
		Format(sBuffer, sizeof(sBuffer), "!%s", g_sShopCMDs[i]);
		
		if (StrEqual(sText, sBuffer, false))
			return Plugin_Handled;
	}
	
	if(g_iRole[client] == TTT_TEAM_TRAITOR)
	{
		LoopValidClients(i)
			if(TTT_IsClientValid(i) && (g_iRole[i] == TTT_TEAM_TRAITOR || !IsPlayerAlive(i))) 
			{
				EmitSoundToClient(i, SND_TCHAT);
				CPrintToChat(i, "%T", "T channel", i, client, sText);
			}
			
		return Plugin_Handled;
	}
	else if(g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		LoopValidClients(i)
			if(TTT_IsClientValid(i) && (g_iRole[i] == TTT_TEAM_DETECTIVE || !IsPlayerAlive(i))) 
			{
				EmitSoundToClient(i, SND_TCHAT);
				CPrintToChat(i, "%T", "D channel", i, client, sText);
			}
			
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

public Action Command_Shop(int client, int args)
{
	int team = g_iRole[client];
	if(team != TTT_TEAM_UNASSIGNED)
	{
		char MenuItem[128];
		Handle menu = CreateMenu(Menu_ShopHandler);
		SetMenuTitle(menu, "%T", "TTT Shop", client);
		
		if(team != TTT_TEAM_INNOCENT)
		{
			// Format(MenuItem, sizeof(MenuItem),"%T", "Buy radar", client, g_iConfig[c_shopRadar]);
			// AddMenuItem(menu, "radar", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "Kevlar", client, g_iConfig[i_shopKEVLAR]);
			AddMenuItem(menu, "kevlar", MenuItem);
		}
	
		if(team == TTT_TEAM_TRAITOR)
		{
			Format(MenuItem, sizeof(MenuItem),"%T", "Buy c4", client, g_iConfig[i_shopC4]);
			AddMenuItem(menu, "C4", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "Buy jihadbomb", client, g_iConfig[i_shopJIHADBOMB]);
			AddMenuItem(menu, "jbomb", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "1 hit kill knife (only good for 1 shot)", client, g_iConfig[i_shop1KNIFE]);
			AddMenuItem(menu, "1knife", MenuItem);

			Format(MenuItem, sizeof(MenuItem),"%T", "FAKE ID card (type !id for show your innocence)", client, g_iConfig[i_shopFAKEID]);
			AddMenuItem(menu, "fakeID", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "M4S", client, g_iConfig[i_shopM4A1]);
			AddMenuItem(menu, "m4s", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "USPS", client, g_iConfig[i_shopUSP]);
			AddMenuItem(menu, "usps", MenuItem);
			
		}
		if(team == TTT_TEAM_DETECTIVE)
		{
			Format(MenuItem, sizeof(MenuItem),"%T", "Health Station", client, g_iConfig[i_shopHEALTH]);
			AddMenuItem(menu, "HealthStation", MenuItem);
			
			Format(MenuItem, sizeof(MenuItem),"%T", "DNA scanner (scan a dead body and show who the killer is)", client, g_iConfig[i_shopDNA]);
			AddMenuItem(menu, "scan13", MenuItem);
		}
		if(team == TTT_TEAM_INNOCENT)
		{
/*    		Format(MenuItem, sizeof(MenuItem),"%T", "Buy rol Traitor", client, g_iConfig[i_shopT]);
			AddMenuItem(menu, "buyT", MenuItem);
			
			if(g_bConfirmDetectiveRules[client] || !g_iConfig[b_showDetectiveMenu])
			{
				Format(MenuItem, sizeof(MenuItem),"%T", "Buy rol Detective", client, g_iConfig[i_shopD]);
				AddMenuItem(menu, "buyD", MenuItem);
			}
*/
			
			Format(MenuItem, sizeof(MenuItem),"%T", "ID card (type !id for show your innocence)", client, g_iConfig[i_shopID]);
			AddMenuItem(menu, "ID", MenuItem);
		}
		
		if(g_iConfig[b_taserAllow])
		{
			Format(MenuItem, sizeof(MenuItem),"%T", "Taser", client, g_iConfig[i_shopTASER]);
			AddMenuItem(menu, "taser", MenuItem);
		}
		
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, client, 15);
	
	}
	else
		CPrintToChat(client, g_iConfig[s_pluginTag], "Please wait till your team is assigned", client);
	
	return Plugin_Handled;

}

public int Menu_ShopHandler(Menu menu, MenuAction action, int client, int itemNum) 
{
	if ( action == MenuAction_Select ) 
	{
		if(!IsPlayerAlive(client)) return;
		char info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		if ( strcmp(info,"kevlar") == 0 ) 
		{
			if(g_iCredits[client] >= g_iConfig[i_shopKEVLAR])
			{
				GivePlayerItem( client, "item_assaultsuit");
				subtractCredits(client, g_iConfig[i_shopKEVLAR]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"1knife") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shop1KNIFE])
			{
				if (g_iRole[client] != TTT_TEAM_TRAITOR)
					return;
				Set1Knife(client);
				subtractCredits(client, g_iConfig[i_shop1KNIFE]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"scan13") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopDNA])
			{
				g_bScan[client] = true;
				subtractCredits(client, g_iConfig[i_shopDNA]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"ID") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopID])
			{
				g_bID[client] = true;
				subtractCredits(client, g_iConfig[i_shopID]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		/* else if ( strcmp(info,"radar") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[c_shopRadar])
			{
				g_bRadar[client] = true;
				subtractCredits(client, g_iConfig[c_shopRadar]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		} */
		else if ( strcmp(info,"fakeID") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopFAKEID])
			{
				g_bID[client] = true;
				subtractCredits(client, g_iConfig[i_shopFAKEID]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"buyT") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopT])
			{
				g_iRole[client] = TTT_TEAM_TRAITOR;
				TeamInitialize(client);
				subtractCredits(client, g_iConfig[i_shopT]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"buyD") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopD])
			{
				g_iRole[client] = TTT_TEAM_DETECTIVE;
				TeamInitialize(client);
				subtractCredits(client, g_iConfig[i_shopD]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"taser") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopTASER] && g_iConfig[b_taserAllow])
			{
				GivePlayerItem(client, "weapon_taser");
				subtractCredits(client, g_iConfig[i_shopTASER]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"usps") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopUSP])
			{
				if (g_iRole[client] != TTT_TEAM_TRAITOR)
					return;
				if (GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY) != -1)
					SDKHooks_DropWeapon(client, GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY));
				
				GivePlayerItem(client, "weapon_usp_silencer");
				subtractCredits(client, g_iConfig[i_shopUSP]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"m4s") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopM4A1])
			{
				if (g_iRole[client] != TTT_TEAM_TRAITOR)
					return;
				
				if (GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) != -1)
					SDKHooks_DropWeapon(client, GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY));
				
				GivePlayerItem(client, "weapon_m4a1_silencer");
				subtractCredits(client, g_iConfig[i_shopM4A1]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if ( strcmp(info,"jbomb") == 0 )
		{
			if(g_iCredits[client] >= g_iConfig[i_shopJIHADBOMB])
			{
				if (g_iRole[client] != TTT_TEAM_TRAITOR)
					return;
				g_bJihadBomb[client] = true;
				ClearTimer(g_hJihadBomb[client]);
				g_hJihadBomb[client] = CreateTimer(g_iConfig[f_jihadPreparingTime], Timer_JihadPreparing, client);
				subtractCredits(client, g_iConfig[i_shopJIHADBOMB]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "bomb will arm in 60 seconds, double tab F to explode", client);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if (strcmp(info, "C4") == 0) {
			if (g_iCredits[client] >= g_iConfig[i_shopC4]) {
				if (g_iRole[client] != TTT_TEAM_TRAITOR)
					return;
				g_bHasC4[client] = true;
				subtractCredits(client, g_iConfig[i_shopC4]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Right click to plant the C4", client);
			}
			else CPrintToChat(client, g_iConfig[s_pluginTag], "You don't have enough money", client);
		}
		else if (strcmp(info, "HealthStation") == 0) {
			if (g_iCredits[client] >= g_iConfig[i_shopHEALTH]) {
				if (g_iRole[client] != TTT_TEAM_DETECTIVE)
					return;
				if (g_bHasActiveHealthStation[client]) {
					CPrintToChat(client, g_iConfig[s_pluginTag], "You already have an active Health Station", client);
					return;
				}
				spawnHealthStation(client);
				subtractCredits(client, g_iConfig[i_shopHEALTH]);
				CPrintToChat(client, g_iConfig[s_pluginTag], "Item bought! Your REAL money is", client, g_iCredits[client]);
			}
		}
	}
		
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action Timer_JihadPreparing(Handle timer, any client) 
{ 
	CPrintToChat(client, g_iConfig[s_pluginTag], "Your bomb is now armed.", client);
	EmitAmbientSound(SND_BLIP, NULL_VECTOR, client);
	g_hJihadBomb[client] = null;	
} 

stock void MostrarMenu(int client, int victima2, int atacante2, int tiempo2, const char[] weapon, const char[] victimaname2, const char[] atacantename2)
{
	char team[32];
	if(g_iRole[victima2] == TTT_TEAM_TRAITOR)
		Format(team, sizeof(team), "%T", "Traitors", client);
	else if(g_iRole[victima2] == TTT_TEAM_DETECTIVE)
		Format(team, sizeof(team), "%T", "Detectives", client);
	else if(g_iRole[victima2] == TTT_TEAM_INNOCENT) 
		Format(team, sizeof(team), "%T", "Innocents", client);

	Handle menu = CreateMenu(BodyMenuHandler);
	char Item[128];
	
	SetMenuTitle(menu, "%T", "Inspected body. The extracted data are the following", client);
	
	Format(Item, sizeof(Item), "%T", "Victim name", client, victimaname2);
	AddMenuItem(menu, "", Item);
	
	Format(Item, sizeof(Item), "%T", "Team victim", client, team);
	AddMenuItem(menu, "", Item);
	
	if(g_iRole[client] == TTT_TEAM_DETECTIVE)
	{
		Format(Item, sizeof(Item), "%T", "Elapsed since his death", client, tiempo2);
		AddMenuItem(menu, "", Item);
		
		if(atacante2 > 0 && atacante2 != victima2)
		{
			Format(Item, sizeof(Item), "%T", "The weapon used has been", client, weapon);
			AddMenuItem(menu, "", Item);
		}
		else
		{
			Format(Item, sizeof(Item), "%T", "The weapon used has been: himself (suicide)", client);
			AddMenuItem(menu, "", Item);
		}
	}
	
	if(g_bScan[client])
	{
		if(atacante2 > 0 && atacante2 != victima2)
			Format(Item, sizeof(Item), "%T", "Killer is Player",client, atacantename2);
		else
			Format(Item, sizeof(Item), "%T", "Player committed suicide", client);
		
		AddMenuItem(menu, "", Item);
	}
	
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 15);
	
}

public int BodyMenuHandler(Menu menu, MenuAction action, int client, int itemNum) 
{
	if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

stock void Set1Knife(int client)
{
	g_b1Knife[client] = true;
	int iWeapon = GetPlayerWeaponSlot(client, 2);
	if (iWeapon != INVALID_ENT_REFERENCE) 
	{
		RemovePlayerItem(client, iWeapon);
		AcceptEntityInput(iWeapon, "Kill");
	} 
	GivePlayerItem(client, "weapon_knife");
}

stock void Remove1Knife(int client)
{
	g_b1Knife[client] = false;
	int iWeapon = GetPlayerWeaponSlot(client, 2);
	if (iWeapon != INVALID_ENT_REFERENCE) 
	{
		RemovePlayerItem(client, iWeapon);
		AcceptEntityInput(iWeapon, "Kill");
	} 
	GivePlayerItem(client, "weapon_knife");
}

stock void ClearIcon(int client)
{
	if(g_iIcon[client] > 0 && IsValidEdict(g_iIcon[client]))
	{
		if(g_iRole[client] == TTT_TEAM_TRAITOR) SDKUnhook(g_iIcon[client], SDKHook_SetTransmit, Hook_SetTransmitT);
		AcceptEntityInput(g_iIcon[client], "Kill");
	}
	g_iIcon[client] = 0;
	
}

stock void addKarma(int client, int karma, bool message = false)
{
	g_iKarma[client] += karma;
	
	if(g_iKarma[client] > g_iConfig[i_maxKarma])
		g_iKarma[client] = g_iConfig[i_maxKarma];
	
	if (g_iConfig[b_showEarnKarmaMessage] && message)
	{
		if(g_iConfig[i_messageTypKarma] == 1)
	  		PrintHintText(client, "%T", "karma earned", client, karma, g_iKarma[client]);
	  	else
	  		CPrintToChat(client, "%T", "karma earned", client, karma, g_iKarma[client]);	
	}
	
	UpdateKarma(client, g_iKarma[client]);
}

stock void setKarma(int client, int karma)
{
	g_iKarma[client] = karma;
	
	if(g_iKarma[client] > g_iConfig[i_maxKarma])
		g_iKarma[client] = g_iConfig[i_maxKarma];
	
	UpdateKarma(client, g_iKarma[client]);
}

stock void subtractKarma(int client, int karma, bool message = false)
{
	g_iKarma[client] -= karma;
	
	if (g_iConfig[b_showLoseKarmaMessage] && message)
	{
		if(g_iConfig[i_messageTypKarma] == 1)
	  		PrintHintText(client, "%T", "lost karma", client, karma, g_iKarma[client]);
	  	else
	  		CPrintToChat(client, "%T", "lost karma", client, karma, g_iKarma[client]);	
	}
	
	UpdateKarma(client, g_iKarma[client]);
}

stock void UpdateKarma(int client, int karma)
{
	char sCommunityID[64];
		
	if(!GetClientAuthId(client, AuthId_SteamID64, sCommunityID, sizeof(sCommunityID)))
		return;
	
	char sQuery[2048];
	Format(sQuery, sizeof(sQuery), "UPDATE `ttt` SET `karma`=%d WHERE `communityid`=\"%s\";", karma, sCommunityID);
	
	if(g_hDatabase != null)
		SQL_TQuery(g_hDatabase, Callback_Karma, sQuery, GetClientUserId(client));
}

stock void addCredits(int client, int credits, bool message = false)
{
	credits = RoundToNearest((credits) * (g_iKarma[client] * 0.01));
	
	g_iCredits[client] += credits;
	
	if (g_iConfig[b_showEarnCreditsMessage] && message)
	{
		if(g_iConfig[i_messageTypCredits] == 1)
		{
			char sBuffer[MAX_MESSAGE_LENGTH];
			Format(sBuffer, sizeof(sBuffer), "%T", "credits earned", client, credits, g_iCredits[client]);
			CFormatColor(sBuffer, sizeof(sBuffer), client);
			PrintHintText(client, sBuffer);
		}
		else
			CPrintToChat(client, "%T", "credits earned", client, credits, g_iCredits[client]);
	}
}

stock void subtractCredits(int client, int credits, bool message = false)
{
	g_iCredits[client] -= credits;
	
	if(g_iCredits[client] < 0)
		g_iCredits[client] = 0;
	
	if (g_iConfig[b_showLoseCreditsMessage] && message)
	{
		if(g_iConfig[i_messageTypCredits] == 1)
		{
			char sBuffer[MAX_MESSAGE_LENGTH];
			Format(sBuffer, sizeof(sBuffer), "%T", "lost credits", client, credits, g_iCredits[client]);
			CFormatColor(sBuffer, sizeof(sBuffer), client);
			PrintHintText(client, sBuffer);
		}
		else
			CPrintToChat(client, "%T", "lost credits", client, credits, g_iCredits[client]);
	}
}

stock void setCredits(int client, int credits)
{
	g_iCredits[client] = credits;
	
	if(g_iCredits[client] < 0)
		g_iCredits[client] = 0;
}

stock void ClearTimer(Handle &timer)
{
    if (timer != null)
    {
        KillTimer(timer);
        timer = null;
    }     
} 

stock void Detonate(int client) 
{ 
    int ExplosionIndex = CreateEntityByName("env_explosion"); 
    if (ExplosionIndex != -1) 
    { 
        SetEntProp(ExplosionIndex, Prop_Data, "m_spawnflags", 16384); 
        SetEntProp(ExplosionIndex, Prop_Data, "m_iMagnitude", 1000); 
        SetEntProp(ExplosionIndex, Prop_Data, "m_iRadiusOverride", 600); 

        DispatchSpawn(ExplosionIndex); 
        ActivateEntity(ExplosionIndex); 
         
        float playerEyes[3]; 
        GetClientEyePosition(client, playerEyes); 

        TeleportEntity(ExplosionIndex, playerEyes, NULL_VECTOR, NULL_VECTOR); 
        SetEntPropEnt(ExplosionIndex, Prop_Send, "m_hOwnerEntity", client); 
         
        EmitAmbientSoundAny("ttt/jihad/explosion.mp3", NULL_VECTOR, client, SNDLEVEL_RAIDSIREN); 
         
         
        AcceptEntityInput(ExplosionIndex, "Explode"); 
         
        AcceptEntityInput(ExplosionIndex, "Kill"); 
    } 
    g_bJihadBomb[client] = false;
} 

public Action Command_Detonate(int client, int args) 
{ 
    if (!g_bJihadBomb[client]) 
    { 
		CPrintToChat(client, g_iConfig[s_pluginTag], "You dont have it!", client);
		return Plugin_Handled; 
    } 
	
    if (g_hJihadBomb[client] != null) 
    { 
		CPrintToChat(client, g_iConfig[s_pluginTag], "Your bomb is not armed.", client);
		return Plugin_Handled; 
    } 
     
    EmitAmbientSoundAny("ttt/jihad/jihad.mp3", NULL_VECTOR, client); 
         
    CreateTimer(2.0, TimerCallback_Detonate, client); 
    g_bJihadBomb[client] = false;

    return Plugin_Handled; 
} 

public Action TimerCallback_Detonate(Handle timer, any client) 
{ 
    if(!client || !IsClientInGame(client) || !IsPlayerAlive(client)) 
        return Plugin_Handled;
    
    Detonate(client); 
    return Plugin_Handled; 
} 

public Action Command_LAW(int client, const char[] command, int argc)
{
	if(!TTT_IsClientValid(client))
		return Plugin_Continue;
	
	if(IsPlayerAlive(client) && g_bJihadBomb[client] && g_hJihadBomb[client] == null && g_bDetonate[client])
	{
		EmitAmbientSoundAny("ttt/jihad/jihad.mp3", NULL_VECTOR, client); 
         
		CreateTimer(2.0, TimerCallback_Detonate, client); 
		g_bJihadBomb[client] = false;
		
		return Plugin_Continue;
	}
	else
	{
		g_bDetonate[client] = true;
		CreateTimer(2.0, PasarJ, client);
	}
	
	if(g_iConfig[b_allowFlash])
	{
		EmitSoundToAllAny(SND_FLASHLIGHT, client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.6);
		SetEntProp(client, Prop_Send, "m_fEffects", GetEntProp(client, Prop_Send, "m_fEffects") ^ 4);
	}		
	
	if(g_iConfig[b_blockLookAtWeapon])
		return Plugin_Handled;
	
	return Plugin_Continue;
}

public Action PasarJ(Handle timer, any client) 
{ 
	if(!client || !IsClientInGame(client)) 
		return Plugin_Handled;
	
	g_bDetonate[client] = false;
	return Plugin_Handled; 
} 

stock void manageRDM(int client)
{
	if (!IsClientInGame(client))
		return;
		
	int iAttacker = g_iRDMAttacker[client];
	if (!IsClientInGame(iAttacker) || iAttacker < 0 || iAttacker > MaxClients)
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "The player who RDM'd you is no longer available", client);
		return;
	}
	char sAttackerName[MAX_NAME_LENGTH];
	GetClientName(iAttacker, sAttackerName, sizeof(sAttackerName));
	
	char display[256], sForgive[64], sPunish[64];
	Format(display, sizeof(display), "%T", "You were RDM'd", client, sAttackerName);
	Format(sForgive, sizeof(sForgive), "%T", "Forgive", client);
	Format(sPunish, sizeof(sPunish), "%T", "Punish", client);
	
	Handle menuHandle = CreateMenu(manageRDMHandle);
	SetMenuTitle(menuHandle, display);
	AddMenuItem(menuHandle, "Forgive", sForgive);
	AddMenuItem(menuHandle, "Punish", sPunish);
	DisplayMenu(menuHandle, client, 10);
}

public int manageRDMHandle(Menu menu, MenuAction action, int client, int option)
{
	if (1 > client || client > MaxClients || !IsClientInGame(client))
		return;
		
	int iAttacker = g_iRDMAttacker[client];
	if (1 > iAttacker || iAttacker > MaxClients || !IsClientInGame(iAttacker))
		return;
		
	switch (action)
	{
		case MenuAction_Select:
		{
			char info[100];
			GetMenuItem(menu, option, info, sizeof(info));
			if (StrEqual(info, "Forgive", false))
			{
				CPrintToChat(client, g_iConfig[s_pluginTag], "Choose Forgive Victim", client, iAttacker);
				CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "Choose Forgive Attacker", iAttacker, client);
				g_iRDMAttacker[client] = -1;
			}
			if (StrEqual(info, "Punish", false))
			{
				LoopValidClients(i)
					CPrintToChat(i, g_iConfig[s_pluginTag], "Choose Punish", i, client, iAttacker);
				ServerCommand("sm_slay #%i 2", GetClientUserId(iAttacker));
				g_iRDMAttacker[client] = -1;
			}
		}
		case MenuAction_Cancel:
		{
			CPrintToChat(client, g_iConfig[s_pluginTag], "Choose Forgive Victim", client, iAttacker);
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "Choose Forgive Attacker", iAttacker, client);
			g_iRDMAttacker[client] = -1;
		}
		case MenuAction_End:
		{
			CloseHandle(menu);
			CPrintToChat(client, g_iConfig[s_pluginTag], "Choose Forgive Victim", client, iAttacker);
			CPrintToChat(iAttacker, g_iConfig[s_pluginTag], "Choose Forgive Attacker", iAttacker, client);
			g_iRDMAttacker[client] = -1;
		}
	}
}

public Action Timer_RDMTimer(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	g_hRDMTimer[client] = null;
	manageRDM(client);
	return Plugin_Stop;
}

public Action Command_SetRole(int client, int args)
{
	if (args < 2 || args > 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_role <#userid|name> <role>");
		ReplyToCommand(client, "[SM] Roles: 1 - Innocent | 2 - Traitor | 3 - Detective");
		return Plugin_Handled;
	}
	char arg1[32];
	char arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	int target = FindTarget(client, arg1);
	
	if (target == -1)
		return Plugin_Handled;

	if (!IsPlayerAlive(target))
	{
		ReplyToCommand(client, "[SM] This command can only be used to alive players!");
		return Plugin_Handled;
	}
	
	int role = StringToInt(arg2);
	if (role < 1 || role > 3)
	{
		ReplyToCommand(client, "[SM] Roles: 1 - Innocent | 2 - Traitor | 3 - Detective");
		return Plugin_Handled;
	}
	else if (role == TTT_TEAM_INNOCENT)
	{
		g_iRole[target] = TTT_TEAM_INNOCENT;
		TeamInitialize(target);
		ClearIcon(target);
		CS_SetClientClanTag(target, "");
		CPrintToChat(client, g_iConfig[s_pluginTag], "Player is Now Innocent", client, target);
		return Plugin_Handled;
	}
	else if (role == TTT_TEAM_TRAITOR)
	{
		g_iRole[target] = TTT_TEAM_TRAITOR;
		TeamInitialize(target);
		ClearIcon(target);
		ApplyIcons();
		CS_SetClientClanTag(target, "");
		CPrintToChat(client, g_iConfig[s_pluginTag], "Player is Now Traitor", client, target);
		return Plugin_Handled;
	}
	else if (role == TTT_TEAM_DETECTIVE && (g_bConfirmDetectiveRules[target] || !g_iConfig[b_showDetectiveMenu]))
	{
		g_iRole[target] = TTT_TEAM_DETECTIVE;
		TeamInitialize(target);
		ClearIcon(target);
		ApplyIcons();
		CPrintToChat(client, g_iConfig[s_pluginTag], "Player is Now Detective", client, target);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

public Action Command_SetKarma(int client, int args)
{
	if (args < 2 || args > 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setkarma <#userid|name> <karma>");

		return Plugin_Handled;
	}
	
	char arg1[32];
	char arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int target = FindTarget(client, arg1);
	
	if (target == -1)
	{
		ReplyToCommand(client, "[SM] Invalid target.");
		return Plugin_Handled;
	}
		
	if(g_bKarma[client])
	{
		ReplyToCommand(client, "[SM] Player data not loaded yet.");
		return Plugin_Handled;
	}

	int karma = StringToInt(arg2);
	
	setKarma(client, karma);
	
	return Plugin_Continue;
}

public Action Command_SetCredits(int client, int args)
{
	if (args < 2 || args > 3)
	{
		ReplyToCommand(client, "[SM] Usage: sm_setcredits <#userid|name> <credits>");

		return Plugin_Handled;
	}
	char arg1[32];
	char arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	int target = FindTarget(client, arg1);
	
	if (target == -1)
		return Plugin_Handled;

	int credits = StringToInt(arg2);
	
	setCredits(client, credits);
	
	return Plugin_Continue;
}

public Action Command_Status(int client, int args)
{
	if (0 > client || client > MaxClients || !IsClientInGame(client))
		return Plugin_Handled;
		
	if (g_iRole[client] == TTT_TEAM_UNASSIGNED)
		CPrintToChat(client, g_iConfig[s_pluginTag], "You Are Unassigned", client); 
	else if (g_iRole[client] == TTT_TEAM_INNOCENT)
		CPrintToChat(client, g_iConfig[s_pluginTag], "You Are Now Innocent", client);
	else if (g_iRole[client] == TTT_TEAM_DETECTIVE)
		CPrintToChat(client, g_iConfig[s_pluginTag], "You Are Now Traitor", client);
	else if (g_iRole[client] == TTT_TEAM_TRAITOR)
		CPrintToChat(client, g_iConfig[s_pluginTag], "You Are Now Detective", client);
	
	return Plugin_Handled;
}

public Action Timer_5(Handle timer)
{
	LoopValidClients(i)
	{
		if (!IsPlayerAlive(i))
			continue;

		g_iIcon[i] = CreateIcon(i);
		
		if (g_iRole[i] == TTT_TEAM_DETECTIVE)
			ShowOverlayToClient(i, "darkness/ttt/overlayDetective");
		else if (g_iRole[i] == TTT_TEAM_TRAITOR)
			ShowOverlayToClient(i, "darkness/ttt/overlayTraitor");
		else if (g_iRole[i] == TTT_TEAM_INNOCENT)
			ShowOverlayToClient(i, "darkness/ttt/overlayInnocent");
		
		if (g_bHasActiveHealthStation[i] && g_iHealthStationCharges[i] < 9)
			g_iHealthStationCharges[i]++;
			
		if(g_bKarma[i] && g_iConfig[i_karmaBan] != 0 && g_iKarma[i] <= g_iConfig[i_karmaBan])
			BanBadPlayerKarma(i);
	}
	
	if(g_bRoundStarted)
		CheckTeams();
}

#if SOURCEMOD_V_MAJOR >= 1 && (SOURCEMOD_V_MINOR >= 8 || SOURCEMOD_V_MINOR >= 7 && SOURCEMOD_V_RELEASE >= 2)
public void OnEntityCreated(int entity, const char[] name)
#else
public int OnEntityCreated(int entity, const char[] name)
#endif
{
	if (StrEqual(name, "func_button"))
	{
		char targetName[128];
		GetEntPropString(entity, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (StrEqual(targetName, "Destroy_Trigger", false))
			SDKHook(entity, SDKHook_Use, OnUse);
	}
	else
	{
		for (int i = 0; i < sizeof(g_sRemoveEntityList); i++)
		{
			if (!StrEqual(name, g_sRemoveEntityList[i]))
				continue;
			
			if(g_iConfig[b_removeBomb] && StrEqual("func_bomb_target", g_sRemoveEntityList[i], false))
				AcceptEntityInput(entity, "Kill");
			
			if(g_iConfig[b_removeHostages] && (StrEqual("hostage_entity", g_sRemoveEntityList[i], false) || StrEqual("func_hostage_rescue", g_sRemoveEntityList[i], false) || StrEqual("info_hostage_spawn", g_sRemoveEntityList[i], false)))
				AcceptEntityInput(entity, "Kill");
			
			break;
		}
	}
}

public Action OnUse(int entity, int activator, int caller, UseType type, float value)
{
	if (activator < 1 || activator > MaxClients || !IsClientInGame(activator))
		return Plugin_Continue;
		
	if (g_bInactive)
		return Plugin_Handled;
		
	else
	{
		if (g_iRole[activator] == TTT_TEAM_INNOCENT || g_iRole[activator] == TTT_TEAM_DETECTIVE || g_iRole[activator] == TTT_TEAM_UNASSIGNED)
		{
			ServerCommand("sm_slay #%i 2", GetClientUserId(activator));
			
			LoopValidClients(i)
				CPrintToChat(i, g_iConfig[s_pluginTag], "Triggered Falling Building", i, activator);
		}
	}
	return Plugin_Continue;
}

public Action explodeC4(Handle timer, Handle pack)
{
	int clientUserId;
	int bombEnt;
	ResetPack(pack);
	clientUserId = ReadPackCell(pack);
	bombEnt = ReadPackCell(pack);
	
	if(!IsValidEntity(bombEnt))
		return Plugin_Stop;
	
	int client = GetClientOfUserId(clientUserId);
	float explosionOrigin[3];
	GetEntPropVector(bombEnt, Prop_Send, "m_vecOrigin", explosionOrigin);
	if (TTT_IsClientValid(client))
	{
		g_bHasActiveBomb[client] = false;
		g_hExplosionTimer[client] = null;
		g_bImmuneRDMManager[client] = true;
		CPrintToChat(client, g_iConfig[s_pluginTag], "Bomb Detonated", client);
	}
	else return Plugin_Stop;

	int explosionIndex = CreateEntityByName("env_explosion");
	int particleIndex = CreateEntityByName("info_particle_system");
	int shakeIndex = CreateEntityByName("env_shake");
	if (explosionIndex != -1 && particleIndex != -1 && shakeIndex != -1)
	{
		DispatchKeyValue(shakeIndex, "amplitude", "4"); 
		DispatchKeyValue(shakeIndex, "duration", "1"); 
		DispatchKeyValue(shakeIndex, "frequency", "2.5"); 
		DispatchKeyValue(shakeIndex, "radius", "5000");
		DispatchKeyValue(particleIndex, "effect_name", "explosion_c4_500");
		SetEntProp(explosionIndex, Prop_Data, "m_spawnflags", 16384);
		SetEntProp(explosionIndex, Prop_Data, "m_iRadiusOverride", 850);
		SetEntProp(explosionIndex, Prop_Data, "m_iMagnitude", 850);
		SetEntPropEnt(explosionIndex, Prop_Send, "m_hOwnerEntity", client);
		DispatchSpawn(particleIndex);
		DispatchSpawn(explosionIndex);
		DispatchSpawn(shakeIndex);
		ActivateEntity(shakeIndex);
		ActivateEntity(particleIndex);
		ActivateEntity(explosionIndex);
		TeleportEntity(particleIndex, explosionOrigin, NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(explosionIndex, explosionOrigin, NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(shakeIndex, explosionOrigin, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(bombEnt, "Kill");
		AcceptEntityInput(explosionIndex, "Explode");
		AcceptEntityInput(particleIndex, "Start");
		AcceptEntityInput(shakeIndex, "StartShake");
		AcceptEntityInput(explosionIndex, "Kill");
		
		LoopValidClients(i)
		{
			if (!IsPlayerAlive(i))
				continue;
				
			float clientOrigin[3];
			GetEntPropVector(i, Prop_Data, "m_vecOrigin", clientOrigin);
			
			if (GetVectorDistance(clientOrigin, explosionOrigin) <= 275.0)
			{
				Handle killEvent = CreateEvent("player_death", true);
				SetEventInt(killEvent, "userid", GetClientUserId(i));
				SetEventInt(killEvent, "attacker", GetClientUserId(client));
				FireEvent(killEvent, false);
				ForcePlayerSuicide(i);
			}
		}
		
		for (int i = 1; i <= 2; i++)
			EmitAmbientSoundAny(SND_BURST, explosionOrigin, _, SNDLEVEL_RAIDSIREN);
			
		CreateTimer(2.0, UnImmune, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	return Plugin_Continue;
}

public Action UnImmune(Handle timer, any userId)
{
	int client = GetClientOfUserId(userId);
	if (TTT_IsClientValid(client))
		g_bImmuneRDMManager[client] = false;
	return Plugin_Stop;
}

public Action bombBeep(Handle timer, Handle pack)
{
	int bombEnt;
	int beeps;
	ResetPack(pack);
	bombEnt = ReadPackCell(pack);
	beeps = ReadPackCell(pack);
	if (!IsValidEntity(bombEnt))
		return Plugin_Stop;
		
	int owner = GetEntProp(bombEnt, Prop_Send, "m_hOwnerEntity");
	if (!TTT_IsClientValid(owner))
		return Plugin_Stop;
		
	float bombPos[3];
	GetEntPropVector(bombEnt, Prop_Data, "m_vecOrigin", bombPos);
	bool stopBeeping = false;
	if (beeps > 0)
	{
		EmitAmbientSoundAny(SND_BEEP, bombPos);
		beeps--;
		stopBeeping = false;
	}
	else stopBeeping = true;
	
	if (stopBeeping)
		return Plugin_Stop;

	Handle bombBeep2;
	CreateDataTimer(1.0, bombBeep, bombBeep2);
	WritePackCell(bombBeep2, bombEnt);
	WritePackCell(bombBeep2, beeps);
	return Plugin_Stop;
}


stock void showPlantMenu(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	
	char sTitle[128];
	char s10[64], s20[64], s30[64], s40[64], s50[64], s60[64];
	
	Format(sTitle, sizeof(sTitle), "%T", "Set C4 Timer", client);
	Format(s10, sizeof(s10), "%T", "Seconds", client, 10);
	Format(s20, sizeof(s20), "%T", "Seconds", client, 20);
	Format(s30, sizeof(s30), "%T", "Seconds", client, 30);
	Format(s40, sizeof(s40), "%T", "Seconds", client, 40);
	Format(s50, sizeof(s50), "%T", "Seconds", client, 50);
	Format(s60, sizeof(s60), "%T", "Seconds", client, 60);
	
	Handle menuHandle = CreateMenu(plantBombMenu);
	SetMenuTitle(menuHandle, sTitle);
	AddMenuItem(menuHandle, "10", s10);
	AddMenuItem(menuHandle, "20", s20);
	AddMenuItem(menuHandle, "30", s30);
	AddMenuItem(menuHandle, "40", s40);
	AddMenuItem(menuHandle, "50", s50);
	AddMenuItem(menuHandle, "60", s60);
	SetMenuPagination(menuHandle, 6);
	DisplayMenu(menuHandle, client, 10);
}

stock void showDefuseMenu(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	
	char sTitle[128];
	char sWire1[64], sWire2[64], sWire3[64], sWire4[64];
	
	Format(sTitle, sizeof(sTitle), "%T", "Defuse C4", client);
	Format(sWire1, sizeof(sWire1), "%T", "C4 Wire", client, 1);
	Format(sWire2, sizeof(sWire2), "%T", "C4 Wire", client, 2);
	Format(sWire3, sizeof(sWire3), "%T", "C4 Wire", client, 3);
	Format(sWire4, sizeof(sWire4), "%T", "C4 Wire", client, 4);
	
	Handle menuHandle= CreateMenu(defuseBombMenu);
	SetMenuTitle(menuHandle, sTitle);
	AddMenuItem(menuHandle, "1", sWire1);
	AddMenuItem(menuHandle, "2", sWire2);
	AddMenuItem(menuHandle, "3", sWire3);
	AddMenuItem(menuHandle, "4", sWire4);
	SetMenuPagination(menuHandle, 4);
	DisplayMenu(menuHandle, client, 10);
}

public int plantBombMenu(Menu menu, MenuAction action, int client, int option)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return;
		
	switch (action)
	{
		case MenuAction_Select:
		{
			char info[100];
			GetMenuItem(menu, option, info, sizeof(info));
			if (StrEqual(info, "10"))
				plantBomb(client, 10.0);
			else if (StrEqual(info, "20"))
				plantBomb(client, 20.0);
			else if (StrEqual(info, "30"))
				plantBomb(client, 30.0);
			else if (StrEqual(info, "40"))
				plantBomb(client, 40.0);
			else if (StrEqual(info, "50"))
				plantBomb(client, 50.0);
			else if (StrEqual(info, "60"))
				plantBomb(client, 60.0);
			g_bHasC4[client] = false;
		}
		case MenuAction_End:
		{
			CloseHandle(menu);
			g_bHasActiveBomb[client] = false;
			removeBomb(client);
		}
		case MenuAction_Cancel:
		{
			g_bHasActiveBomb[client] = false;
			removeBomb(client);
		}
	}
}

public int defuseBombMenu(Menu menu, MenuAction action, int client, int option)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return;
	
	switch (action)
	{
		case MenuAction_Select:
		{
			char info[100];
			int planter = g_iDefusePlayerIndex[client];	
			g_iDefusePlayerIndex[client] = -1;
			
			if (planter < 1 || planter > MaxClients || !IsClientInGame(planter))
			{
				g_iDefusePlayerIndex[client] = -1;
				return;
			}
			
			int wire;
			int correctWire;
			int planterBombIndex = findBomb(planter);
			float bombPos[3];
			GetEntPropVector(planterBombIndex, Prop_Data, "m_vecOrigin", bombPos);
			correctWire = g_iWire[planter];
			GetMenuItem(menu, option, info, sizeof(info));
			wire = StringToInt(info);
			if (wire == correctWire)
			{
				if (1 <= planter <= MaxClients && IsClientInGame(planter))
				{
					CPrintToChat(client, g_iConfig[s_pluginTag], "You Defused Bomb", client, planter);
					CPrintToChat(planter, g_iConfig[s_pluginTag], "Has Defused Bomb", planter, client);
					EmitAmbientSoundAny(SND_DISARM, bombPos);
					g_bHasActiveBomb[planter] = false;
					ClearTimer(g_hExplosionTimer[planter]);
					SetEntProp(planterBombIndex, Prop_Send, "m_hOwnerEntity", -1);
				}
			}
			else
			{
				CPrintToChat(client, g_iConfig[s_pluginTag], "Failed Defuse", client);
				ForcePlayerSuicide(client);
				g_iDefusePlayerIndex[client] = -1;
			}
		}
		case MenuAction_End:
		{
			CloseHandle(menu);
			g_iDefusePlayerIndex[client] = -1;
		}
		case MenuAction_Cancel:
			g_iDefusePlayerIndex[client] = -1;
	}
}

stock float plantBomb(int client, float time)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
		return;
		
	if (!IsPlayerAlive(client))
	{
		CPrintToChat(client, g_iConfig[s_pluginTag], "Alive to Plant", client);
		return;
	}
	
	CPrintToChat(client, g_iConfig[s_pluginTag], "Will Explode In", client, time);
	
	bool bombFound;
	int bombEnt;
	while ((bombEnt = FindEntityByClassname(bombEnt, "prop_physics")) != -1)
	{
		if (GetEntProp(bombEnt, Prop_Send, "m_hOwnerEntity") != client)
			continue;
			
		char sModelPath[PLATFORM_MAX_PATH];
		GetEntPropString(bombEnt, Prop_Data, "m_ModelName", sModelPath, sizeof(sModelPath));
		
		if(!StrEqual(MDL_C4, sModelPath))
			continue;
		
		Handle explosionPack;
		Handle beepPack;
		if (g_hExplosionTimer[client] != null)
			KillTimer(g_hExplosionTimer[client]);
		g_hExplosionTimer[client] = CreateDataTimer(time, explodeC4, explosionPack);
		CreateDataTimer(1.0, bombBeep, beepPack);
		WritePackCell(explosionPack, GetClientUserId(client));
		WritePackCell(explosionPack, bombEnt);
		WritePackCell(beepPack, bombEnt);
		WritePackCell(beepPack, (time - 1));
		g_bHasActiveBomb[client] = true;
		bombFound = true;
	}
	
	if(!bombFound)
		CPrintToChat(client, g_iConfig[s_pluginTag], "Bomb Was Not Found", client);
	
	g_iWire[client] = Math_GetRandomInt(1, 4);
	CPrintToChat(client, g_iConfig[s_pluginTag], "Wire Is", client, g_iWire[client]);
}

stock int findBombPlanter(int &bomb)
{	
	int iEnt;
	while ((iEnt = FindEntityByClassname(iEnt, "prop_physics")) != -1)
	{
		int iPlanter = GetEntProp(iEnt, Prop_Send, "m_hOwnerEntity");
		
		if (iPlanter <= 0)
			continue;
			
		char sModelPath[PLATFORM_MAX_PATH];
		GetEntPropString(iEnt, Prop_Data, "m_ModelName", sModelPath, sizeof(sModelPath));
		
		if(!StrEqual(MDL_C4, sModelPath))
			continue;
		
		bomb = iEnt;
		return iPlanter;
	}
	
	return -1;
}

stock int findBomb(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
		return -1;
		
	int iEnt;
	while ((iEnt = FindEntityByClassname(iEnt, "prop_physics")) != -1)
	{
		if (GetEntProp(iEnt, Prop_Send, "m_hOwnerEntity") != client)
			continue;
			
		char sModelPath[PLATFORM_MAX_PATH];
		GetEntPropString(iEnt, Prop_Data, "m_ModelName", sModelPath, sizeof(sModelPath));
		
		if(!StrEqual(MDL_C4, sModelPath))
			continue;
		
		return iEnt;
	}
	return -1;
}

stock void removeBomb(int client)
{
	int iEnt;
	while ((iEnt = FindEntityByClassname(iEnt, "prop_physics")) != -1)
	{
		if (GetEntProp(iEnt, Prop_Send, "m_hOwnerEntity") != client)
			continue;
			
		char sModelPath[PLATFORM_MAX_PATH];
		GetEntPropString(iEnt, Prop_Data, "m_ModelName", sModelPath, sizeof(sModelPath));
		
		if(!StrEqual(MDL_C4, sModelPath))
			continue;
		
		AcceptEntityInput(iEnt, "Kill");
	}
}

stock void resetPlayers()
{
	LoopValidClients(i)
	{
		ClearTimer(g_hExplosionTimer[i]);
		g_bHasActiveBomb[i] = false;
	}
}

stock void listTraitors(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client))
		return;
	
	CPrintToChat(client, g_iConfig[s_pluginTag], "Your Traitor Partners", client);
	int iCount = 0;
	
	LoopValidClients(i)
	{
		if (!IsPlayerAlive(i) || client == i || g_iRole[i] != TTT_TEAM_TRAITOR)
			continue;
		CPrintToChat(client, g_iConfig[s_pluginTag], "Traitor List", client, i);
		iCount++;
	}
	
	if(iCount == 0)
		CPrintToChat(client, g_iConfig[s_pluginTag], "No Traitor Partners", client);
}

stock void nameCheck(int client, char name[MAX_NAME_LENGTH])
{
	for(int i; i < g_iBadNameCount; i++)
		if (StrContains(g_sBadNames[i], name, false) != -1)
			KickClient(client, "%T", "Kick Bad Name", client, g_sBadNames[i]);
}

stock void healthStation_cleanUp()
{
	LoopValidClients(i)
	{
		g_iHealthStationCharges[i] = 0;
		g_bHasActiveHealthStation[i] = false;
		g_bOnHealingCoolDown[i] = false;
		
		ClearTimer(g_hRemoveCoolDownTimer[i]);
	}
}

public Action removeCoolDown(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	g_bOnHealingCoolDown[client] = false;
	g_hRemoveCoolDownTimer[client] = null;
	return Plugin_Stop;
}

stock void spawnHealthStation(int client)
{
	if (!IsPlayerAlive(client))
		return;
		
	int healthStationIndex = CreateEntityByName("prop_physics_multiplayer");
	if (healthStationIndex != -1)
	{
		float clientPos[3];
		GetClientAbsOrigin(client, clientPos);
		SetEntProp(healthStationIndex, Prop_Send, "m_hOwnerEntity", client);
		DispatchKeyValue(healthStationIndex, "model", "models/props/cs_office/microwave.mdl");
		DispatchSpawn(healthStationIndex);
		SDKHook(healthStationIndex, SDKHook_OnTakeDamage, OnTakeDamageHealthStation);
		TeleportEntity(healthStationIndex, clientPos, NULL_VECTOR, NULL_VECTOR);
		g_iHealthStationHealth[client] = 10;
		g_bHasActiveHealthStation[client] = true;
		g_iHealthStationCharges[client] = 10;
		CPrintToChat(client, g_iConfig[s_pluginTag], "Health Station Deployed", client);
	}
}

public Action OnTakeDamageHealthStation(int stationIndex, int &iAttacker, int &inflictor, float &damage, int &damagetype)
{
	if (!IsValidEntity(stationIndex) || stationIndex == INVALID_ENT_REFERENCE || stationIndex <= MaxClients || iAttacker < 1 || iAttacker > MaxClients || !IsClientInGame(iAttacker))
		return Plugin_Continue;
	
	int owner = GetEntProp(stationIndex, Prop_Send, "m_hOwnerEntity");
	if (owner < 1 || owner > MaxClients || !IsClientInGame(owner))
		return Plugin_Continue;
		
	g_iHealthStationHealth[owner]--;
	
	if (g_iHealthStationHealth[owner] <= 0)
	{
		AcceptEntityInput(stationIndex, "Kill");
		g_bHasActiveHealthStation[owner] = false;
	}
	return Plugin_Continue;
}

public Action healthStationDistanceCheck(Handle timer)
{
	LoopValidClients(i)
	{
		if (!IsPlayerAlive(i))
			continue;
		
		checkDistanceFromHealthStation(i);
	}
	return Plugin_Continue;
}

stock void checkDistanceFromHealthStation(int client) {
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client)) return;
	float clientPos[3], stationPos[3]; 
	int curHealth, newHealth, iEnt;
	char sModelName[PLATFORM_MAX_PATH];
	while ((iEnt = FindEntityByClassname(iEnt, "prop_physics_multiplayer")) != -1)
	{
		int owner = GetEntProp(iEnt, Prop_Send, "m_hOwnerEntity");
		if (owner < 1 || owner > MaxClients || !IsClientInGame(owner))
			continue;
		
		GetEntPropString(iEnt, Prop_Data, "m_ModelName", sModelName, sizeof(sModelName));

		if (StrContains(sModelName, "microwave") == -1)
			continue;
		
		GetClientEyePosition(client, clientPos);
		GetEntPropVector(iEnt, Prop_Send, "m_vecOrigin", stationPos);
		
		if (GetVectorDistance(clientPos, stationPos) > 200.0)
			continue;
		
		if (g_bOnHealingCoolDown[client]) continue;
		curHealth = GetClientHealth(client);
		
		if (curHealth >= 125)
			continue;
		
		if (g_iHealthStationCharges[owner] > 0)
		{
			newHealth = (curHealth + 15);
			if (newHealth >= 125)
				SetEntityHealth(client, 125);
			else
				SetEntityHealth(client, newHealth);

			CPrintToChat(client, g_iConfig[s_pluginTag], "Healing From", client, owner);
			EmitSoundToClientAny(client, SND_WARNING);
			g_iHealthStationCharges[owner]--;
			g_bOnHealingCoolDown[client] = true;
			g_hRemoveCoolDownTimer[client] = CreateTimer(1.0, removeCoolDown, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			CPrintToChat(client, g_iConfig[s_pluginTag], "Health Station Out Of Charges", client);
			g_bOnHealingCoolDown[client] = true;
			g_hRemoveCoolDownTimer[client] = CreateTimer(1.0, removeCoolDown, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public void OnWeaponPostSwitch(int client, int weapon)
{
	char weaponName[64];
	GetClientWeapon(client, weaponName, sizeof(weaponName));
	if (StrContains(weaponName, "silence") != -1)
		g_bHoldingSilencedWep[client] = true;
	else
		g_bHoldingSilencedWep[client] = false;
}

public Action Command_KarmaReset(int client, int args)
{
	LoopValidClients(i)
		setKarma(g_iKarma[i], 100);
	return Plugin_Handled;
}

// Thanks SMLib ( https://github.com/bcserv/smlib/blob/master/scripting/include/smlib/math.inc#L149 )
stock int Math_GetRandomInt(int min, int max)
{
	int random = GetURandomInt();
	
	if (random == 0) {
		random++;
	}

	return RoundToCeil(float(random) / (float(2147483647) / float(max - min + 1))) + min - 1;
}

stock void CheckTeams()
{
	int iT = 0;
	int iD = 0;
	int iI = 0;
	
	LoopValidClients(i)
	{
		if(IsPlayerAlive(i))
		{
			if(g_iRole[i] == TTT_TEAM_DETECTIVE)
				iD++;
			else if(g_iRole[i] == TTT_TEAM_TRAITOR)
				iT++;
			else if(g_iRole[i] == TTT_TEAM_INNOCENT)
				iI++;
		}
	}
	
	if(iD == 0 && iI == 0)
	{
		g_bRoundStarted = false;
		CS_TerminateRound(7.0, CSRoundEnd_TerroristWin);
	}
	else if(iT == 0)
	{
		g_bRoundStarted = false;
		CS_TerminateRound(7.0, CSRoundEnd_CTWin);
	}
}

stock void SetNoBlock(int client)
{
	SetEntData(client, g_iCollisionGroup, 2, 4, true);
}

stock void LoadBadNames()
{
	char sFile[PLATFORM_MAX_PATH + 1];
	BuildPath(Path_SM, sFile, sizeof(sFile), "configs/ttt/badnames.ini");
	
	Handle hFile = OpenFile(sFile, "rt");
	
	if(hFile == null)
		SetFailState("[TTT] Can't open File: %s", sFile);
	
	char sLine[MAX_NAME_LENGTH];
	
	while(!IsEndOfFile(hFile) && ReadFileLine(hFile, sLine, sizeof(sLine)))
	{
		if(strlen(sLine) > 1)
		{
			strcopy(g_sBadNames[g_iBadNameCount], sizeof(g_sBadNames[]), sLine);
			g_iBadNameCount++;
		}
	}
	
	delete hFile;
}

public void SQLConnect(Handle owner, Handle hndl, const char[] error, any data)
{
	if(hndl == null || strlen(error) > 0)
	{
		SetFailState("(SQLConnect) Connection to database failed!: %s", error);
		return;
	}
	
	char sDriver[16];
	SQL_GetDriverIdent(owner, sDriver, sizeof(sDriver));
	
	if (!StrEqual(sDriver, "mysql", false) && !StrEqual(sDriver, "sqlite", false))
	{
		SetFailState("(SQLConnect) Only mysql/sqlite support!");
		return;
	}

	g_hDatabase = CloneHandle(hndl);
	
	CheckAndCreateTables(sDriver);

	SQL_SetCharset(g_hDatabase, "utf8");
	
	LoadClients();
}

stock void CheckAndCreateTables(const char[] driver)
{
	char sQuery[256];
	if (StrEqual(driver, "mysql", false))
		Format(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS `ttt` ( `id` INT NOT NULL AUTO_INCREMENT , `communityid` VARCHAR(64) NOT NULL , `karma` INT(11) NULL , PRIMARY KEY (`id`), UNIQUE (`communityid`)) ENGINE = InnoDB;");
	else if (StrEqual(driver, "sqlite", false))
		Format(sQuery, sizeof(sQuery), "CREATE TABLE IF NOT EXISTS `ttt` (`communityid` VARCHAR(64) NOT NULL DEFAULT '', `karma` INT NOT NULL DEFAULT 0, PRIMARY KEY (`communityid`))");

	SQL_TQuery(g_hDatabase, Callback_CheckAndCreateTables, sQuery);
}

public void Callback_CheckAndCreateTables(Handle owner, Handle hndl, const char[] error, any userid)
{
	if(hndl == null || strlen(error) > 0)
	{
		LogError("(SQLCallback_Create) Query failed: %s", error);
		return;
	}
}

public void Callback_Karma(Handle owner, Handle hndl, const char[] error, any userid)
{
	if(hndl == null || strlen(error) > 0)
	{
		LogError("(Callback_Karma) Query failed: %s", error);
		return;
	}
}
public void Callback_InsertPlayer(Handle owner, Handle hndl, const char[] error, any userid)
{
	if(hndl == null || strlen(error) > 0)
	{
		LogError("(Callback_InsertPlayer) Query failed: %s", error);
		return;
	}
}

stock void LoadClients()
{
	LoopValidClients(i)
	{
		OnClientPostAdminCheck(i);
		OnClientPutInServer(i);
	}
}

stock void LoadClientKarma(int userid)
{
	int client = GetClientOfUserId(userid);
	
	if(TTT_IsClientValid(client) && !IsFakeClient(client))
	{
		char sCommunityID[64];
		
		if(!GetClientAuthId(client, AuthId_SteamID64, sCommunityID, sizeof(sCommunityID)))
		{
			LogError("(LoadClientKarma) Auth failed: #%d", client);
			return;
		}
		
		char sQuery[2048];
		Format(sQuery, sizeof(sQuery), "SELECT `karma` FROM `ttt` WHERE `communityid`= \"%s\"", sCommunityID);
		
		if(g_hDatabase != null)
			SQL_TQuery(g_hDatabase, SQL_OnClientPostAdminCheck, sQuery, userid);
	}
}

public void SQL_OnClientPostAdminCheck(Handle owner, Handle hndl, const char[] error, any userid)
{
	int client = GetClientOfUserId(userid);
	
	if(!client || !TTT_IsClientValid(client) || IsFakeClient(client))
		return;
	
	if(hndl == null || strlen(error) > 0)
	{
		LogError("(SQL_OnClientPostAdminCheck) Query failed: %s", error);
		return;
	}
	else
	{
		if (!SQL_FetchRow(hndl))
			InsertPlayer(userid);
		else
		{
			char sCommunityID[64];
			
			if(!GetClientAuthId(client, AuthId_SteamID64, sCommunityID, sizeof(sCommunityID)))
			{
				LogError("(SQL_OnClientPostAdminCheck) Auth failed: #%d", client);
				return;
			}
				
			int karma = SQL_FetchInt(hndl, 0);
				
			g_bKarma[client] = true;
			
			if (karma == 0)
				setKarma(client, g_iConfig[i_startKarma]);
			else setKarma(client, karma);
		}
	}
}

stock void InsertPlayer(int userid)
{
	int client = GetClientOfUserId(userid);
	
	if(TTT_IsClientValid(client) && !IsFakeClient(client))
	{
		int karma = g_iConfig[i_startKarma];
		g_iKarma[client] = karma;
		
		char sCommunityID[64];
			
		if(!GetClientAuthId(client, AuthId_SteamID64, sCommunityID, sizeof(sCommunityID)))
			return;
		
		char sQuery[2048];
		Format(sQuery, sizeof(sQuery), "INSERT INTO `ttt` (`communityid`, `karma`) VALUES (\"%s\", %d)", sCommunityID, karma);
		
		if(g_hDatabase != null)
			SQL_TQuery(g_hDatabase, Callback_InsertPlayer, sQuery, userid);
	}
}

public int Native_GetClientRole(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	
	if(TTT_IsClientValid(client))
		return g_iRole[client];
	return 0;
}

public int Native_GetClientKarma(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	
	if(TTT_IsClientValid(client) && g_bKarma[client])
		return g_iKarma[client];
	return 0;
}

public int Native_GetClientCredits(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	
	if(TTT_IsClientValid(client))
		return g_iCredits[client];
	return 0;
}

public int Native_SetClientRole(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int role = GetNativeCell(2);
	
	if(TTT_IsClientValid(client))
	{
		g_iRole[client] = role;
		TeamInitialize(client);
		ClearIcon(client);
		ApplyIcons();
		return g_iRole[client];
	}
	else if(role < TTT_TEAM_UNASSIGNED || role > TTT_TEAM_DETECTIVE)
		ThrowNativeError(SP_ERROR_NATIVE, "Invalid role %d", role);
	return 0;
}

public int Native_SetClientKarma(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int karma = GetNativeCell(2);
	
	if(TTT_IsClientValid(client) && g_bKarma[client])
	{
		setKarma(client, karma);
		return g_iKarma[client];
	}
	return 0;
}

public int Native_SetClientCredits(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int credits = GetNativeCell(2);
	
	if(TTT_IsClientValid(client))
	{
		setCredits(client, credits);
		return g_iCredits[client];
	}
	return 0;
}

public int Native_WasBodyFound(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	
	if(TTT_IsClientValid(client))
	{
		int iSize = GetArraySize(g_hRagdollArray);
		
		if(iSize == 0)
			return false;
		
		int Items[Ragdolls];
		
		for(int i = 0; i < iSize; i++)
		{
			GetArrayArray(g_hRagdollArray, i, Items[0]);
			
			if(Items[victim] == client)
			{
				return Items[found];
			}
		}
	}
	return 0;
}

public int Native_WasBodyScanned(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	
	if(TTT_IsClientValid(client))
	{
		int iSize = GetArraySize(g_hRagdollArray);
		
		if(iSize == 0)
			return false;
		
		int Items[Ragdolls];
		
		for(int i = 0; i < iSize; i++)
		{
			GetArrayArray(g_hRagdollArray, i, Items[0]);
			
			if(Items[victim] == client)
			{
				return Items[scanned];
			}
		}
	}
	return 0;
}

stock int AddInt(const char[] name, int value, const char[] description)
{
	KeyValues kv = CreateKeyValues("TTT");
	
	if(!kv.ImportFromFile(g_sConfigFile))
		LogError("Can't read ttt.cfg correctly! Return the default value!");
	
	if(kv.JumpToKey(name, false))
		value = kv.GetNum("value");
	else
	{
		LogError("Can't find cvar %s! Adding default value to %s", name, g_sConfigFile);
		kv.JumpToKey(name, true);
		kv.SetNum("value", value);
		kv.SetString("description", description);
		kv.Rewind();
		kv.ExportToFile(g_sConfigFile);
	}
	
	delete kv;
	return value;
}

stock bool AddBool(const char[] name, bool value, const char[] description)
{
	KeyValues kv = CreateKeyValues("TTT");
	
	if(!kv.ImportFromFile(g_sConfigFile))
		LogError("Can't read ttt.cfg correctly! Return the default value!");

	if(kv.JumpToKey(name, false))
		value = view_as<bool>(kv.GetNum("value"));
	else
	{
		LogError("Can't find cvar %s! Adding default value to %s", name, g_sConfigFile);
		kv.JumpToKey(name, true);
		kv.SetNum("value", value);
		kv.SetString("description", description);
		kv.Rewind();
		kv.ExportToFile(g_sConfigFile);
	}

	delete kv;
	return value;
}

stock float AddFloat(const char[] name, float value, const char[] description)
{
	KeyValues kv = CreateKeyValues("TTT");
	
	if(!kv.ImportFromFile(g_sConfigFile))
		LogError("Can't read ttt.cfg correctly! Return the default value!");
	
	if(kv.JumpToKey(name, false))
		value = view_as<float>(kv.GetFloat("value"));
	else
	{
		LogError("Can't find cvar %s! Adding default value to %s", name, g_sConfigFile);
		kv.JumpToKey(name, true);
		kv.SetFloat("value", value);
		kv.SetString("description", description);
		kv.Rewind();
		kv.ExportToFile(g_sConfigFile);
	}
	
	delete kv;
	return value;
}

stock void AddString(const char[] name, const char[] value, const char[] description, char[] output, int size)
{
	strcopy(output, size, value);
	
	KeyValues kv = CreateKeyValues("TTT");
	
	if(!kv.ImportFromFile(g_sConfigFile))
		LogError("Can't read ttt.cfg correctly! Return the default value!");
	
	if(kv.JumpToKey(name, false))
		kv.GetString("value", output, size);
	else
	{
		LogError("Can't find cvar %s! Adding default value to %s", name, g_sConfigFile);
		kv.JumpToKey(name, true);
		kv.SetString("value", value);
		kv.SetString("description", description);
		kv.Rewind();
		kv.ExportToFile(g_sConfigFile);
	}
	
	delete kv;
}
