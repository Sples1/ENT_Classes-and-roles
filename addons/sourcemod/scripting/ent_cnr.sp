/*
 * SourceMod Entity Projects
 * by: Entity
 *
 * Copyright (C) 2020 Kőrösfalvi "Entity" Martin
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <multicolors>
#include <clientprefs>
#include <smlib>
#include <hosties>
#include <lastrequest>

#undef REQUIRE_PLUGIN
#undef REQUIRE_EXTENSIONS
#tryinclude <store>
#tryinclude <shop>
#define REQUIRE_EXTENSIONS
#define REQUIRE_PLUGIN

#pragma semicolon								1
#pragma newdecls required

//Enable or Disable the classes module
#define	MODULE_CLASSES							1
//Enable or Disable the roles module
#define	MODULE_ROLES							1
//Store support (0 - Disable Roles, 1 - Zeph Store, 2 - Shop core)
#define	MODULE_SUPPORT							2

//Global
ConVar gH_Cvar_CNR_Enabled;
ConVar gH_Cvar_CNR_ChatPrefix;
ConVar gH_Cvar_CNR_Logging;

char gShadow_CNR_LogFile[PLATFORM_MAX_PATH];
char gShadow_CNR_ChatBanner[256];
bool gShadow_CNR_Logging;

bool gShadow_CNR_Enabled = true;
bool gShadow_CNR_BlockCommand[MAXPLAYERS+1] = false;

#if (MODULE_CLASSES == 1)
#include "cnr/ent_classes.sp"
#endif
#if (MODULE_ROLES == 1)
#include "cnr/ent_roles.sp"
#endif

public Plugin myinfo = 
{
	name = "[CSGO] Jailbreak Classes and Roles", 
	author = "Entity", 
	description = "Jailbreak classes and roles", 
	version = "0.1.1"
};

public void OnClientPostAdminCheck(int client)
{
	#if (MODULE_CLASSES == 1)
	CreateTimer(1.0, Timer_Analyze, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	#endif
	#if (MODULE_ROLES == 1)
	CreateTimer(1.0, Timer_Validate, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	#endif
}

public void OnPluginStart()
{
	LoadTranslations("ent_cnr.phrases");

	gH_Cvar_CNR_Enabled = CreateConVar("sm_cnr_enabled", "1", "Enable or disable jailbreak classes and roles plugin:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_ChatPrefix = CreateConVar("sm_cnr_chat_banner", "{darkblue}[{lightblue}C-N-R{darkblue}]", "Edit ChatTag for CNR (Colors can be used).");
	gH_Cvar_CNR_Logging = CreateConVar("sm_cnr_logging", "0", "Enable or disable CNR logging (credit changes and informations)", 0, true, 0.0, true, 1.0);
	
	HookConVarChange(gH_Cvar_CNR_Enabled, OnCvarChange_Main);
	HookConVarChange(gH_Cvar_CNR_ChatPrefix, OnCvarChange_Main);
	HookConVarChange(gH_Cvar_CNR_Logging, OnCvarChange_Main);

	char Folder[256];
	BuildPath(Path_SM, Folder, sizeof(Folder), "logs/Entity");
	DirExistsEx(Folder);
	
	SetLogFile(gShadow_CNR_LogFile, "CNR-Logs", "Entity");
	
	RegConsoleCmd("sm_cnr", Command_ClassesAndRoles);
	
	#if (MODULE_CLASSES == 1)
	Classes_OnPluginStart();
	if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "CNR Classes module loaded.");
	#endif
	#if (MODULE_ROLES == 1)
	Roles_OnPluginStart();
	if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "CNR Roles module loaded.");
	#endif
	
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("round_end", OnRoundEnd);
	
	if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "CNR Successfully started.");
	AutoExecConfig(true, "ent_cnr");
}

public Action OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	#if (MODULE_CLASSES == 1)
	OnRoundEnd_Class(event, name, dontBroadcast);
	#endif
	#if (MODULE_ROLES == 1)
	OnRoundEnd_Role(event, name, dontBroadcast);
	#endif
}

public Action Timer_BlockCommand(Handle timer, int client)
{
	gShadow_CNR_BlockCommand[client] = false;
	return Plugin_Stop;
}

public void OnClientDisconnect(int client)
{
	#if (MODULE_CLASSES == 1)
	Class_OnClientDisconnect(client);
	#endif
	#if (MODULE_ROLES == 1)
	Role_OnClientDisconnect(client);
	#endif
}

public Action OnPlayerSpawn(Event event, char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	gShadow_CNR_BlockCommand[client] = true;
	CreateTimer(5.0, Timer_BlockCommand, client, TIMER_FLAG_NO_MAPCHANGE);
	
	#if (MODULE_CLASSES == 1)
	OnPlayerSpawn_Class(event, name, dontBroadcast);
	#endif
	#if (MODULE_ROLES == 1)
	OnPlayerSpawn_Role(event, name, dontBroadcast);
	#endif
}

public void OnClientPutInServer(int client)
{
	#if (MODULE_ROLES == 1)
	Roles_ClientPutInServer(client);
	#endif
}

public void OnConfigsExecuted()
{
	#if (MODULE_CLASSES == 1)
	Classes_OnConfigsExecuted();
	#endif
	#if (MODULE_ROLES == 1)
	Roles_OnConfigsExecuted();
	#endif
	gShadow_CNR_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Enabled));
	char buffer[128];
	GetConVarString(gH_Cvar_CNR_ChatPrefix, buffer, sizeof(buffer));
	Format(gShadow_CNR_ChatBanner, sizeof(gShadow_CNR_ChatBanner), "%s{lime} ", buffer);
	gShadow_CNR_Logging = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Logging));
}

public void OnCvarChange_Main(ConVar cvar, char[] oldvalue, char[] newvalue)
{
	if (cvar == gH_Cvar_CNR_Enabled)
		gShadow_CNR_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Enabled));
	else if (cvar == gH_Cvar_CNR_ChatPrefix)
	{
		char buffer[128];
		GetConVarString(gH_Cvar_CNR_ChatPrefix, buffer, sizeof(buffer));
		Format(gShadow_CNR_ChatBanner, sizeof(gShadow_CNR_ChatBanner), "%s{lime} ", buffer);
	}
	else if (cvar == gH_Cvar_CNR_Logging)
		gShadow_CNR_Logging = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Logging));
}

public Action Command_ClassesAndRoles(int client, int args)
{
	if (gShadow_CNR_Enabled)
	{
		if (IsClientInGame(client))
		{
			if (!gShadow_CNR_BlockCommand[client])
			{
				char buffer[64]; bool CanShow = false;
				Menu menu = CreateMenu(MainCNRHandler);
				menu.SetTitle("---=| C.N.R |=---\n ");
				#if (MODULE_CLASSES == 1)
					Format(buffer, sizeof(buffer), "%t", "CNR Classes");
					menu.AddItem("classes", buffer);
					CanShow = true;
				#endif
				#if (MODULE_ROLES == 1 && MODULE_SUPPORT != 0)
					Format(buffer, sizeof(buffer), "%t", "CNR Roles");
					menu.AddItem("roles", buffer);
					CanShow = true;
				#endif
				
				if (CanShow)
				{
					menu.Display(client, MENU_TIME_FOREVER);
				}
				else
				{
					CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR No Modules");
				}
			}
			else
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Wait");
			}
		}
		else
		{
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Not In Team");
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Disabled");
	}
	return Plugin_Handled;
}

public int MainCNRHandler(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		if (!gShadow_CNR_Enabled)
		{
			PrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Disabled");
			return;
		}
		
		char gShadow_temp_choosenitem[64];
		GetMenuItem(menu, itemNum, gShadow_temp_choosenitem, sizeof(gShadow_temp_choosenitem));
		if (StrEqual(gShadow_temp_choosenitem, "classes"))
		{
			#if (MODULE_CLASSES == 1)
			Submenu_Classes(client);
			#endif
		}
		else if (StrEqual(gShadow_temp_choosenitem, "roles"))
		{
			#if (MODULE_ROLES == 1)
			Submenu_Roles(client);
			#endif
		}
	}
}

void RemoveDangerZone(int client)
{
	int Healthshot = Client_GetWeaponPlayerAmmo(client, "weapon_healthshot");
	int Snowball = Client_GetWeaponPlayerAmmo(client, "weapon_snowball");
	int Breachcharge = Client_GetWeaponPlayerAmmo(client, "weapon_breachcharge");
	int Tagrenade = Client_GetWeaponPlayerAmmo(client, "weapon_tagrenade");
	int Shield = Client_GetWeaponPlayerAmmo(client, "weapon_shield");
	int Bumpmine = Client_GetWeaponPlayerAmmo(client, "weapon_bumpmine");
	int Fists = Client_GetWeaponPlayerAmmo(client, "weapon_fists");
	
	if (Healthshot != 0)
		Client_RemoveWeapon(client, "weapon_healthshot", false);
		
	if (Snowball != 0)
		Client_RemoveWeapon(client, "weapon_snowball", false);
		
	if (Breachcharge != 0)
		Client_RemoveWeapon(client, "weapon_breachcharge", false);
		
	if (Tagrenade != 0)
		Client_RemoveWeapon(client, "weapon_tagrenade", false);
		
	if (Shield != 0)
		Client_RemoveWeapon(client, "weapon_shield", false);
		
	if (Bumpmine != 0)
		Client_RemoveWeapon(client, "weapon_bumpmine", false);
		
	if (Fists != 0)
		Client_RemoveWeapon(client, "weapon_fists", false);
}

void GetFlagInt(char buffer[30])
{
	FlagStringToInt(buffer, "a", ADMFLAG_RESERVATION);
	FlagStringToInt(buffer, "b", ADMFLAG_GENERIC);
	FlagStringToInt(buffer, "c", ADMFLAG_KICK);
	FlagStringToInt(buffer, "d", ADMFLAG_BAN);
	FlagStringToInt(buffer, "e", ADMFLAG_UNBAN);
	FlagStringToInt(buffer, "f", ADMFLAG_SLAY);
	FlagStringToInt(buffer, "g", ADMFLAG_CHANGEMAP);
	FlagStringToInt(buffer, "h", 128);
	FlagStringToInt(buffer, "i", ADMFLAG_CONFIG);
	FlagStringToInt(buffer, "j", ADMFLAG_CHAT);
	FlagStringToInt(buffer, "k", ADMFLAG_VOTE);
	FlagStringToInt(buffer, "l", ADMFLAG_PASSWORD);
	FlagStringToInt(buffer, "m", ADMFLAG_RCON);
	FlagStringToInt(buffer, "n", ADMFLAG_CHEATS);
	FlagStringToInt(buffer, "z", ADMFLAG_ROOT);
	FlagStringToInt(buffer, "o", ADMFLAG_CUSTOM1);
	FlagStringToInt(buffer, "p", ADMFLAG_CUSTOM2);
	FlagStringToInt(buffer, "q", ADMFLAG_CUSTOM3);
	FlagStringToInt(buffer, "r", ADMFLAG_CUSTOM4);
	FlagStringToInt(buffer, "s", ADMFLAG_CUSTOM5);
	FlagStringToInt(buffer, "t", ADMFLAG_CUSTOM6);
}

void FlagStringToInt(char StrToReplace[30], char flag[10], int ReplaceWith)
{
	char NewFlagValue[10];
	IntToString(ReplaceWith, NewFlagValue, sizeof(NewFlagValue));
	ReplaceString(StrToReplace, sizeof(StrToReplace), flag, NewFlagValue);
}

stock void CNR_AddCredit(int client, int amount)
{
	#if (MODULE_SUPPORT == 1)
		int CurrentCredits = Store_GetClientCredits(client);
		Store_SetClientCredits(client, (CurrentCredits + amount));
	#endif
	#if (MODULE_SUPPORT == 2)
		Shop_GiveClientCredits(client, amount);
	#endif
}

stock bool IsValidClient(int client)
{
	if((1 <= client <= MaxClients) && IsClientInGame(client) && IsClientConnected(client) && !IsFakeClient(client))
	{
		return true;
	}
	return false;
}

stock void SetLogFile(char path[PLATFORM_MAX_PATH], char[] file, char[] folder)
{
	char sDate[12];
	FormatTime(sDate, sizeof(sDate), "%y-%m-%d");
	Format(path, sizeof(path), "logs/%s/%s-%s.log", folder, file, sDate);

	BuildPath(Path_SM, path, sizeof(path), path);
}

stock bool DirExistsEx(const char[] path)
{
	if (!DirExists(path))
	{
		CreateDirectory(path, 511);

		if (!DirExists(path))
		{
			LogError("Couldn't create folder! (%s)", path);
			return false;
		}
	}

	return true;
}