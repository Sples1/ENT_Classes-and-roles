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

//Global
ConVar gH_Cvar_CNR_BlockWeapons_T;
ConVar gH_Cvar_CNR_BlockWeapons_CT;
ConVar gH_Cvar_CNR_ForceFist;
ConVar gH_Cvar_CNR_Announce;

char gShadow_CNR_ConfigFile_T[PLATFORM_MAX_PATH];
char gShadow_CNR_ConfigFile_CT[PLATFORM_MAX_PATH];

char gShadow_CNR_BlockedWeapons[128];
bool gShadow_CNR_BlockWeapons_CT = true;
bool gShadow_CNR_BlockWeapons_T = false;
bool gShadow_CNR_ForceFist = false;
bool gShadow_CNR_Announce = true;

//Client Class
Handle gCookie_CNR_ChoosenClass_T = INVALID_HANDLE;
Handle gCookie_CNR_ChoosenClass_CT = INVALID_HANDLE;

char gShadow_CNR_Client_TemporaryChoose[MAXPLAYERS+1][32];
char gShadow_CNR_Client_CanUseTemp[MAXPLAYERS+1][64];
char gShadow_CNR_Client_LoadoutTemp[MAXPLAYERS+1][64];
char gShadow_CNR_Client_ChoosenClassName_T[MAXPLAYERS+1][32];
char gShadow_CNR_Client_ChoosenClassName_CT[MAXPLAYERS+1][32];
bool gShadow_CNR_Client_PickupHandled[MAXPLAYERS+1];
bool gShadow_CNR_Client_HasAccess[MAXPLAYERS+1];

Handle gShadow_CNR_Client_OverHeal_Checker[MAXPLAYERS+1] = INVALID_HANDLE;

int gShadow_CNR_SizeOfList[MAXPLAYERS+1];
char gShadow_CNR_WeaponList[MAXPLAYERS+1][16][32];
char gShadow_CNR_WeaponList_Restrict[16][32];

//Client CT Class
int gShadow_CNR_Client_CT_HP[MAXPLAYERS+1];
int gShadow_CNR_Client_CT_ARMOR[MAXPLAYERS+1];
int gShadow_CNR_Client_CT_HELMET[MAXPLAYERS+1];
int gShadow_CNR_Client_CT_HS[MAXPLAYERS+1];
float gShadow_CNR_Client_CT_SPEED[MAXPLAYERS+1];
char gShadow_CNR_Client_CT_Specials[MAXPLAYERS+1][128];
char gShadow_CNR_Client_CT_AccessTo[MAXPLAYERS+1][128];
char gShadow_CNR_Client_CT_Model[MAXPLAYERS+1][PLATFORM_MAX_PATH];

//Client T Class
int gShadow_CNR_Client_T_HP[MAXPLAYERS+1];
int gShadow_CNR_Client_T_ARMOR[MAXPLAYERS+1];
int gShadow_CNR_Client_T_HELMET[MAXPLAYERS+1];
int gShadow_CNR_Client_T_HS[MAXPLAYERS+1];
float gShadow_CNR_Client_T_SPEED[MAXPLAYERS+1];
char gShadow_CNR_Client_T_Specials[MAXPLAYERS+1][128];
char gShadow_CNR_Client_T_AccessTo[MAXPLAYERS+1][128];
char gShadow_CNR_Client_T_Model[MAXPLAYERS+1][PLATFORM_MAX_PATH];

public void Classes_OnPluginStart()
{
	BuildPath(Path_SM, gShadow_CNR_ConfigFile_T, sizeof(gShadow_CNR_ConfigFile_T), "configs/cnr/jb_t_classes.txt");
	BuildPath(Path_SM, gShadow_CNR_ConfigFile_CT, sizeof(gShadow_CNR_ConfigFile_CT), "configs/cnr/jb_ct_classes.txt");

	gH_Cvar_CNR_BlockWeapons_CT = CreateConVar("sm_cnr_only_classweapons_ct", "1", "Enable or disable weapon restrictions for CT:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_BlockWeapons_T = CreateConVar("sm_cnr_only_classweapons_t", "0", "Enable or disable weapon restrictions for T:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_ForceFist = CreateConVar("sm_cnr_forcefist", "1", "Forces Fists instead of knife at spawn", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Announce = CreateConVar("sm_cnr_spawnmessage", "1", "Announce CNR in roundstart", 0, true, 0.0, true, 1.0);
	
	HookConVarChange(gH_Cvar_CNR_BlockWeapons_CT, OnCvarChange_Settings);
	HookConVarChange(gH_Cvar_CNR_BlockWeapons_T, OnCvarChange_Settings);
	HookConVarChange(gH_Cvar_CNR_ForceFist, OnCvarChange_Settings);
	HookConVarChange(gH_Cvar_CNR_Announce, OnCvarChange_Settings);
	
	gCookie_CNR_ChoosenClass_T = RegClientCookie("CNR_ChoosenClass_T", "CNR TClassNew", CookieAccess_Private);	
	gCookie_CNR_ChoosenClass_CT = RegClientCookie("CNR_ChoosenClass_CT", "CNR CTClassNew", CookieAccess_Private);
	
	ConVar g_cvSvSuit = FindConVar("mp_weapons_allow_heavyassaultsuit");
	
	SetConVarInt(g_cvSvSuit, 1, true, false);
}

public Action Timer_Analyze(Handle timer, int client)
{
	PlayerInformations(client);
	return Plugin_Stop;
}

public void Classes_OnConfigsExecuted()
{
	ConVar g_cvSvSuit = FindConVar("mp_weapons_allow_heavyassaultsuit");
	SetConVarInt(g_cvSvSuit, 1, true, false);

	gShadow_CNR_BlockWeapons_T = view_as<bool>(GetConVarInt(gH_Cvar_CNR_BlockWeapons_T));
	gShadow_CNR_BlockWeapons_CT = view_as<bool>(GetConVarInt(gH_Cvar_CNR_BlockWeapons_CT));
	gShadow_CNR_ForceFist = view_as<bool>(GetConVarInt(gH_Cvar_CNR_ForceFist));
	gShadow_CNR_Announce = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Announce));
	
	if (gShadow_CNR_BlockWeapons_T || gShadow_CNR_BlockWeapons_CT)
	{
		SearchRestrictedWeapons();
	}
}

public Action OnRoundEnd_Class(Event event, const char[] name, bool dontBroadcast)
{
	for (int idx = 1; idx <= MaxClients ; idx++)
	{
		if (IsValidClient(idx))
		{
			SDKUnhook(idx, SDKHook_WeaponCanUse, RestrictWeapon);
		
			if (gShadow_CNR_Client_OverHeal_Checker[idx] != INVALID_HANDLE)
			{
				KillTimer(gShadow_CNR_Client_OverHeal_Checker[idx]);
				gShadow_CNR_Client_OverHeal_Checker[idx] = INVALID_HANDLE;
			}
		}
	}
}

stock void SearchRestrictedWeapons()
{
	char buffer[256];
	KeyValues kv = CreateKeyValues("jailbreak_classes");
	kv.ImportFromFile(gShadow_CNR_ConfigFile_T);

	if (!kv.GotoFirstSubKey())
		return;
		
	do
	{
		kv.GetString("access_to", buffer, sizeof(buffer));
		
		if (!StrEqual(buffer, ""))
		{
			if (StrContains(buffer, ",") != -1)
			{
				int gShadow_CNR_SizeOfList_Restrict = ExplodeWeapons(buffer);
				
				for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList_Restrict; Tidx++)
				{
					if (StrContains(gShadow_CNR_BlockedWeapons, gShadow_CNR_WeaponList_Restrict[Tidx]) == -1)
					{
						if (StrEqual(gShadow_CNR_BlockedWeapons, ""))
							Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s", gShadow_CNR_WeaponList_Restrict[Tidx]);
						else
							Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s,%s", gShadow_CNR_BlockedWeapons, gShadow_CNR_WeaponList_Restrict[Tidx]);
					}
				}
			}
			else
			{
				if (StrEqual(gShadow_CNR_BlockedWeapons, ""))
					Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s", buffer);
				else
					Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s,%s", gShadow_CNR_BlockedWeapons, buffer);
			}

		}
	}
	while (kv.GotoNextKey());
	delete kv;
	
	KeyValues kvc = CreateKeyValues("jailbreak_classes");
	kvc.ImportFromFile(gShadow_CNR_ConfigFile_CT);
	if (!kvc.GotoFirstSubKey())
		return;
		
	do
	{
		kvc.GetString("access_to", buffer, sizeof(buffer));
		
		if (!StrEqual(buffer, ""))
		{
			if (StrContains(buffer, ",") != -1)
			{
				int gShadow_CNR_SizeOfList_Restrict = ExplodeWeapons(buffer);
				
				for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList_Restrict; Tidx++)
				{
					if (StrContains(gShadow_CNR_BlockedWeapons, gShadow_CNR_WeaponList_Restrict[Tidx]) == -1)
					{
						if (StrEqual(gShadow_CNR_BlockedWeapons, ""))
							Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s", gShadow_CNR_WeaponList_Restrict[Tidx]);
						else
							Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s,%s", gShadow_CNR_BlockedWeapons, gShadow_CNR_WeaponList_Restrict[Tidx]);
					}
				}
			}
			else
			{
				if (StrEqual(gShadow_CNR_BlockedWeapons, ""))
					Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s", buffer);
				else
					Format(gShadow_CNR_BlockedWeapons, sizeof(gShadow_CNR_BlockedWeapons), "%s,%s", gShadow_CNR_BlockedWeapons, buffer);
			}

		}
	}
	while (kvc.GotoNextKey());
	delete kvc;
}

public void OnCvarChange_Settings(ConVar cvar, char[] oldvalue, char[] newvalue)
{
	if (cvar == gH_Cvar_CNR_BlockWeapons_T)
		gShadow_CNR_BlockWeapons_T = view_as<bool>(GetConVarInt(gH_Cvar_CNR_BlockWeapons_T));
	else if (cvar == gH_Cvar_CNR_BlockWeapons_CT)
		gShadow_CNR_BlockWeapons_CT = view_as<bool>(GetConVarInt(gH_Cvar_CNR_BlockWeapons_CT));
	else if (cvar == gH_Cvar_CNR_ForceFist)
		gShadow_CNR_ForceFist = view_as<bool>(GetConVarInt(gH_Cvar_CNR_ForceFist));
	else if (cvar == gH_Cvar_CNR_Announce)
		gShadow_CNR_Announce = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Announce));
		
	if (gShadow_CNR_BlockWeapons_T || gShadow_CNR_BlockWeapons_CT)
	{
		SearchRestrictedWeapons();
	}
}

public void Submenu_Classes(int client)
{
	if (gShadow_CNR_Enabled)
	{
		if (IsClientInGame(client))
		{
			PlayerInformations(client);
			
			if (GetClientTeam(client) == CS_TEAM_T)
				ReadClassesToMenu(client, CS_TEAM_T);
			else if (GetClientTeam(client) == CS_TEAM_CT)
				ReadClassesToMenu(client, CS_TEAM_CT);
			else
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Not In Team");
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
}

public Action OnPlayerSpawn_Class(Event event, char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		if (gShadow_CNR_Announce && GameRules_GetProp("m_bWarmupPeriod") == 0)
		{
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Supported");
		}
		
		if (gShadow_CNR_BlockWeapons_T || gShadow_CNR_BlockWeapons_CT)
		{
			SDKHook(client, SDKHook_WeaponCanUse, RestrictWeapon); 
		}
		
		CreateTimer(0.3, Timer_LoadoutFix, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

void ReadClassesToMenu(int client, int team)
{
	KeyValues kv = CreateKeyValues("jailbreak_classes");
	
	if (team == CS_TEAM_T)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_T);
	else if (team == CS_TEAM_CT)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_CT);

	if (!kv.GotoFirstSubKey())
		return;

	gShadow_CNR_BlockCommand[client] = true;
	CreateTimer(5.0, Timer_BlockCommand, client, TIMER_FLAG_NO_MAPCHANGE);

	char gShadow_temp_classname[32], buffer[32]; bool CanShow = false;
	Menu menu = CreateMenu(ClassChoice);
	menu.SetTitle("---=| C.N.R |=---\n ");
		
	do
	{
		kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
		kv.GetString("flag", buffer, sizeof(buffer));
		
		if (StrEqual(buffer, ""))
		{
			menu.AddItem(gShadow_temp_classname, gShadow_temp_classname); CanShow = true;
		}
		else if (StrContains("abcdefghijklmnopqrstz", buffer) != -1)
		{
			Format(gShadow_temp_classname, sizeof(gShadow_temp_classname), "%s - (VIP)", gShadow_temp_classname);
			
			GetFlagInt(buffer);
			
			int flag = StringToInt(buffer);
			if(Client_HasAdminFlags(client, flag))
			{
				menu.AddItem(gShadow_temp_classname, gShadow_temp_classname);
			}
			else
			{
				menu.AddItem(gShadow_temp_classname, gShadow_temp_classname, ITEMDRAW_DISABLED);
			}
			
			CanShow = true;
		}
	}
	while (kv.GotoNextKey());
	delete kv;
	
	if (CanShow)
	{
		Format(gShadow_temp_classname, sizeof(gShadow_temp_classname), "%t", "CNR Menu NoClass");
		menu.AddItem("noclass", gShadow_temp_classname);
		
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR NoClasses");
	}
}

public int ClassChoice(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		if (!gShadow_CNR_Enabled)
		{
			PrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Disabled");
			return;
		}
		
		int gShadow_temp_team = GetClientTeam(client);
		char gShadow_temp_choosenclass[64];
		GetMenuItem(menu, itemNum, gShadow_temp_choosenclass, sizeof(gShadow_temp_choosenclass));
		
		if (!StrEqual(gShadow_temp_choosenclass, "noclass"))
		{
			ShowDetails(client, gShadow_temp_team, gShadow_temp_choosenclass);
		}
		else if (StrEqual(gShadow_temp_choosenclass, "noclass"))
		{
			if (gShadow_temp_team == CS_TEAM_T)
			{
				SetClientCookie(client, gCookie_CNR_ChoosenClass_T, "");
			}
			else if (gShadow_temp_team == CS_TEAM_CT)
			{
				SetClientCookie(client, gCookie_CNR_ChoosenClass_CT, "");
			}
			
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Removal Next Round");
		}
	}
}

void ShowDetails(int client, int team, char[] choosen)
{
	ReplaceString(choosen, 128, " - (VIP)", "");
	Format(gShadow_CNR_Client_TemporaryChoose[client], sizeof(gShadow_CNR_Client_TemporaryChoose), choosen);
	KeyValues kv = CreateKeyValues("jailbreak_classes");
	
	if (team == CS_TEAM_T)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_T);
	else if (team == CS_TEAM_CT)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_CT);

	if (!kv.GotoFirstSubKey())
		return;

	char gShadow_temp_classname[32], hp[32], armor[32], helmet[32], hs[32], speed[32], buffer[128];
	
	do
	{
		kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
		if (StrEqual(gShadow_CNR_Client_TemporaryChoose[client], gShadow_temp_classname))
		{
			kv.GetString("hp", buffer, sizeof(buffer));
			Format(hp, sizeof(hp), buffer);
			kv.GetString("armor", buffer, sizeof(buffer));
			Format(armor, sizeof(armor), buffer);
			kv.GetString("helmet", buffer, sizeof(buffer));
			if (StrEqual(buffer, "0")) Format(helmet, sizeof(helmet), "%t: %t", "CNR Helmet", "CNR No");
			else if (StrEqual(buffer, "1")) Format(helmet, sizeof(helmet), "%t: %t", "CNR Helmet", "CNR Yes");
			kv.GetString("heavysuit", buffer, sizeof(buffer));
			if (StrEqual(buffer, "0")) Format(hs, sizeof(hs), "%t: %t", "CNR Heavysuit", "CNR No");
			else if (StrEqual(buffer, "1")) Format(hs, sizeof(hs), "%t: %t", "CNR Heavysuit", "CNR Yes");
			kv.GetString("speed", buffer, sizeof(buffer));
			if (StringToFloat(buffer) > 1.0) Format(speed, sizeof(speed), "%t: %t", "CNR Speed", "CNR Faster");
			else if (StringToFloat(buffer) == 1.0) Format(speed, sizeof(speed), "%t: %t", "CNR Speed", "CNR Normal");
			else if (StringToFloat(buffer) < 1.0) Format(speed, sizeof(speed), "%t: %t", "CNR Speed", "CNR Slower");
			
			kv.GetString("spawn_weapons", gShadow_CNR_Client_LoadoutTemp[client], sizeof(gShadow_CNR_Client_LoadoutTemp));
			kv.GetString("access_to", gShadow_CNR_Client_CanUseTemp[client], sizeof(gShadow_CNR_Client_CanUseTemp));
		}
	}
	while (kv.GotoNextKey());
	delete kv;
	Menu menu = CreateMenu(DetailsChoice);
	Format(buffer, sizeof(buffer), "-=| %s |=-\n \n > %t: %s\n > %t: %s\n > %s\n > %s\n > %s\n ", gShadow_CNR_Client_TemporaryChoose[client], "CNR Health", hp, "CNR Armor", armor, helmet, hs, speed);
	menu.SetTitle(buffer);
	
	Format(buffer, sizeof(buffer), "%t", "CNR CanUse Menu");
	menu.AddItem("canuse", buffer);
	Format(buffer, sizeof(buffer), "%t", "CNR Loadout Menu");
	menu.AddItem("loadout", buffer);
	
	if (StrEqual(choosen, gShadow_CNR_Client_ChoosenClassName_T[client]) || StrEqual(choosen, gShadow_CNR_Client_ChoosenClassName_CT[client]))
	{
		Format(buffer, sizeof(buffer), "%t", "CNR Selected");
		menu.AddItem("", buffer, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(buffer, sizeof(buffer), "%t", "CNR Select");
		menu.AddItem("select", buffer);
	}
	
	menu.ExitButton = true;
	menu.ExitBackButton = false;
	
	menu.Display(client, MENU_TIME_FOREVER);
}

public int DetailsChoice(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Cancel)
	{
		ReadClassesToMenu(client, GetClientTeam(client));
	}
	else if (action == MenuAction_Select)
	{
		char info[64];
		int gShadow_temp_team = GetClientTeam(client);
		GetMenuItem(menu, itemNum, info, sizeof(info));
		if (StrEqual(info, "select"))
		{
			if (T_Class_Exist(gShadow_CNR_Client_TemporaryChoose[client]) && (gShadow_temp_team == CS_TEAM_T))
			{
				SetClientCookie(client, gCookie_CNR_ChoosenClass_T, gShadow_CNR_Client_TemporaryChoose[client]);
			}
			else if (CT_Class_Exist(gShadow_CNR_Client_TemporaryChoose[client]) && (gShadow_temp_team == CS_TEAM_CT))
			{
				SetClientCookie(client, gCookie_CNR_ChoosenClass_CT, gShadow_CNR_Client_TemporaryChoose[client]);
			}
			
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Apply Next Round");
		}
		else if (StrEqual(info, "canuse"))
		{
			if (StrEqual(gShadow_CNR_Client_CanUseTemp[client], ""))
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Can Use Text Empty", gShadow_CNR_Client_TemporaryChoose[client]);
			}
			else
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Can Use Text", gShadow_CNR_Client_TemporaryChoose[client], gShadow_CNR_Client_CanUseTemp[client]);
			}
		}
		else if (StrEqual(info, "loadout"))
		{
			if (StrEqual(gShadow_CNR_Client_LoadoutTemp[client], ""))
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Loadout Text Empty", gShadow_CNR_Client_TemporaryChoose[client]);
			}
			else
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Loadout Text", gShadow_CNR_Client_TemporaryChoose[client], gShadow_CNR_Client_LoadoutTemp[client]);
			}
		}
	}
}

public void Class_OnClientDisconnect(int client)
{
	ClearLocalClass(client, CS_TEAM_CT);
	ClearLocalClass(client, CS_TEAM_T);
	
	if (gShadow_CNR_Client_OverHeal_Checker[client] != INVALID_HANDLE)
	{
		KillTimer(gShadow_CNR_Client_OverHeal_Checker[client]);
		gShadow_CNR_Client_OverHeal_Checker[client] = INVALID_HANDLE;
	}
}

void ClearLocalClass(int client, int team)
{
	if (team == CS_TEAM_T)
	{
		gShadow_CNR_Client_ChoosenClassName_T[client] = "";
		gShadow_CNR_Client_T_HP[client] = 100;
		gShadow_CNR_Client_T_ARMOR[client] = 0;
		gShadow_CNR_Client_T_HELMET[client] = 0;
		gShadow_CNR_Client_T_HS[client] = 0;
		gShadow_CNR_Client_T_SPEED[client] = 1.0;
		gShadow_CNR_Client_T_Specials[client] = "";
		gShadow_CNR_Client_T_Model[client] = "";
	}
	else if (team == CS_TEAM_CT)
	{
		gShadow_CNR_Client_ChoosenClassName_CT[client] = "";
		gShadow_CNR_Client_CT_HP[client] = 100;
		gShadow_CNR_Client_CT_ARMOR[client] = 0;
		gShadow_CNR_Client_CT_HELMET[client] = 0;
		gShadow_CNR_Client_CT_HS[client] = 0;
		gShadow_CNR_Client_CT_SPEED[client] = 1.0;
		gShadow_CNR_Client_CT_Specials[client] = "";
		gShadow_CNR_Client_CT_Model[client] = "";
	}
}

public void PlayerInformations(int client)
{
	if (IsValidClient(client) && AreClientCookiesCached(client))
	{
		GetClientCookie(client, gCookie_CNR_ChoosenClass_T, gShadow_CNR_Client_ChoosenClassName_T[client], sizeof(gShadow_CNR_Client_ChoosenClassName_T));
		GetClientCookie(client, gCookie_CNR_ChoosenClass_CT, gShadow_CNR_Client_ChoosenClassName_CT[client], sizeof(gShadow_CNR_Client_ChoosenClassName_CT));
		
		if (!StrEqual(gShadow_CNR_Client_ChoosenClassName_T[client], ""))
		{
			if (T_Class_Exist(gShadow_CNR_Client_ChoosenClassName_T[client]))
			{
				ClassHasAccess(client, gShadow_CNR_Client_ChoosenClassName_T[client], CS_TEAM_T);
				if (gShadow_CNR_Client_HasAccess[client])
				{
					Class_GetAttributes_ForTeam(client, gShadow_CNR_Client_ChoosenClassName_T[client], CS_TEAM_T);
				}
				else
				{
					CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR No access");
					SetClientCookie(client, gCookie_CNR_ChoosenClass_T, "");
					gShadow_CNR_Client_ChoosenClassName_T[client] = "";
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L class (%s) has been removed for no permission to use.", client, gShadow_CNR_Client_ChoosenClassName_T[client]);
				}
			}
			else
			{
				char buffer[64];
				Format(buffer, sizeof(buffer), "\x07%s\x06", gShadow_CNR_Client_ChoosenClassName_T[client]);
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Class Not Found", buffer);
				if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L class not found (%s). Player class set to none.", client, gShadow_CNR_Client_ChoosenClassName_T[client]);
				gShadow_CNR_Client_ChoosenClassName_T[client] = "";
				SetClientCookie(client, gCookie_CNR_ChoosenClass_T, "");
			}
		}
		else
		{
			ClearLocalClass(client, CS_TEAM_T);
		}
		
		if (!StrEqual(gShadow_CNR_Client_ChoosenClassName_CT[client], ""))
		{
			if (CT_Class_Exist(gShadow_CNR_Client_ChoosenClassName_CT[client]))
			{
				ClassHasAccess(client, gShadow_CNR_Client_ChoosenClassName_CT[client], CS_TEAM_CT);
				if (gShadow_CNR_Client_HasAccess[client])
				{
					Class_GetAttributes_ForTeam(client, gShadow_CNR_Client_ChoosenClassName_CT[client], CS_TEAM_CT);
				}
				else
				{
					CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR No access");
					SetClientCookie(client, gCookie_CNR_ChoosenClass_CT, "");
					gShadow_CNR_Client_ChoosenClassName_CT[client] = "";
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L class (%s) has been removed for no permission to use.", client, gShadow_CNR_Client_ChoosenClassName_T[client]);
				}
			}
			else
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Class Not Found", "\x07%s\x06", gShadow_CNR_Client_ChoosenClassName_CT[client]);
				if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L class not found (%s). Player class set to none.", client, gShadow_CNR_Client_ChoosenClassName_T[client]);
				gShadow_CNR_Client_ChoosenClassName_CT[client] = "";
				SetClientCookie(client, gCookie_CNR_ChoosenClass_CT, "");
			}
		}
		else
		{
			ClearLocalClass(client, CS_TEAM_CT);
		}
	}
}

void ClassHasAccess(int client, char[] choosen, int team)
{
	KeyValues kv = CreateKeyValues("jailbreak_classes");
	
	if (team == CS_TEAM_T)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_T);
	else if (team == CS_TEAM_CT)
		kv.ImportFromFile(gShadow_CNR_ConfigFile_CT);
		
	if (!kv.GotoFirstSubKey())
		return;
		
	char gShadow_temp_classname[32], buffer[32];
	Menu menu = CreateMenu(ClassChoice);
	menu.SetTitle("---=| C.N.R |=---\n ");
	
	do
	{
		kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
		if (StrEqual(gShadow_temp_classname, choosen))
		{
			kv.GetString("flag", buffer, sizeof(buffer));
			
			if (StrEqual(buffer, ""))
				gShadow_CNR_Client_HasAccess[client] = true;
			else if (StrContains("abcdefghijklmnopqrstz", buffer) != -1)
			{
				GetFlagInt(buffer);
				
				int flag = StringToInt(buffer);
				if(Client_HasAdminFlags(client, flag))
				{
					gShadow_CNR_Client_HasAccess[client] = true;
				}
				else
				{
					gShadow_CNR_Client_HasAccess[client] = false;
				}
			}
		}
	}
	while (kv.GotoNextKey());
	delete kv;
}

void Class_GetAttributes_ForTeam(int client, char[] classname, int team)
{
	if (team == CS_TEAM_T)
	{
		KeyValues kv = CreateKeyValues("jailbreak_classes");
		kv.ImportFromFile(gShadow_CNR_ConfigFile_T);
		
		if (!kv.GotoFirstSubKey())
			return;

		char gShadow_temp_classname[32], buffer[128];	
		do
		{
			kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
			if (StrEqual(gShadow_temp_classname, classname))
			{
				kv.GetString("hp", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_HP[client] = StringToInt(buffer);
				kv.GetString("armor", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_ARMOR[client] = StringToInt(buffer);
				kv.GetString("helmet", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_HELMET[client] = StringToInt(buffer);
				kv.GetString("heavysuit", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_HS[client] = StringToInt(buffer);
				kv.GetString("speed", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_SPEED[client] = StringToFloat(buffer);
				kv.GetString("spawn_weapons", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_Specials[client] = buffer;
				kv.GetString("custom_model", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_Model[client] = buffer;
				kv.GetString("access_to", buffer, sizeof(buffer));
				gShadow_CNR_Client_T_AccessTo[client] = buffer;
			}
		}
		while (kv.GotoNextKey());
		delete kv;
	}
	else if (team == CS_TEAM_CT)
	{
		KeyValues kv = CreateKeyValues("jailbreak_classes");
		kv.ImportFromFile(gShadow_CNR_ConfigFile_CT);
		
		if (!kv.GotoFirstSubKey())
			return;

		char gShadow_temp_classname[32], buffer[128];	
		do
		{
			kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
			if (StrEqual(gShadow_temp_classname, classname))
			{
				kv.GetString("hp", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_HP[client] = StringToInt(buffer);
				kv.GetString("armor", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_ARMOR[client] = StringToInt(buffer);
				kv.GetString("helmet", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_HELMET[client] = StringToInt(buffer);
				kv.GetString("heavysuit", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_HS[client] = StringToInt(buffer);
				kv.GetString("speed", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_SPEED[client] = StringToFloat(buffer);
				kv.GetString("spawn_weapons", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_Specials[client] = buffer;
				kv.GetString("custom_model", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_Model[client] = buffer;
				kv.GetString("access_to", buffer, sizeof(buffer));
				gShadow_CNR_Client_CT_AccessTo[client] = buffer;
			}
		}
		while (kv.GotoNextKey());
		delete kv;
	}
}

public bool CT_Class_Exist(char[] classname_ct)
{
	bool gShadow_temp_existinct = false;
	KeyValues kv = CreateKeyValues("jailbreak_classes");

	kv.ImportFromFile(gShadow_CNR_ConfigFile_CT);
	if (!kv.GotoFirstSubKey())
		return false;

	char gShadow_temp_classname[32];	
	do
	{
		kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
		if (StrEqual(gShadow_temp_classname, classname_ct))
			gShadow_temp_existinct = true;
	}
	while (kv.GotoNextKey());
	delete kv;
	return gShadow_temp_existinct;
}

public bool T_Class_Exist(char[] classname_t)
{
	bool gShadow_temp_existint = false;
	KeyValues kv = CreateKeyValues("jailbreak_classes");

	kv.ImportFromFile(gShadow_CNR_ConfigFile_T);
	if (!kv.GotoFirstSubKey())
		return false;

	char gShadow_temp_classname[32];	
	do
	{
		kv.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
		if (StrEqual(gShadow_temp_classname,classname_t))
			gShadow_temp_existint = true;
	}
	while (kv.GotoNextKey());
	delete kv;
	return gShadow_temp_existint;
}

public Action RestrictWeapon(int client, int weapon)  
{
	if (!StrEqual(gShadow_CNR_BlockedWeapons, "") && !IsClientInLastRequest(client))
	{
		KeyValues CheckRestrict = CreateKeyValues("jailbreak_classes");
		
		if ((gShadow_CNR_BlockWeapons_T) && (GetClientTeam(client) == CS_TEAM_T))
		{
			if (Weapon_IsValid(weapon))
			{
				char weaponname[64], AccessTo[128]; bool CanPickUp = false;
				GetEdictClassname(weapon, weaponname, sizeof(weaponname));
				ReplaceString(weaponname, sizeof(weaponname), "weapon_", "");
				
				if (StrContains(gShadow_CNR_BlockedWeapons, weaponname) != -1)
				{
					CheckRestrict.ImportFromFile(gShadow_CNR_ConfigFile_T);
					
					if (!CheckRestrict.GotoFirstSubKey())
						return Plugin_Continue;
			
					char gShadow_temp_classname[32];	
					do
					{
						CheckRestrict.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
						CheckRestrict.GetString("access_to", AccessTo, sizeof(AccessTo));
						int gShadow_CNR_SizeOfList_Restrict = ExplodeWeapons(AccessTo);
						
						if (!StrEqual(AccessTo, ""))
						{
							for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList_Restrict; Tidx++)
							{
								if ((StrEqual(gShadow_temp_classname, gShadow_CNR_Client_ChoosenClassName_T[client])) && (StrContains(gShadow_CNR_WeaponList_Restrict[Tidx], weaponname) != -1))
								{
									CanPickUp = true;
								}
							}
						}
					}
					while (CheckRestrict.GotoNextKey());
					
					delete CheckRestrict;
					if (CanPickUp)
						return Plugin_Continue;
					else
					{
						if (!gShadow_CNR_Client_PickupHandled[client])
						{
							gShadow_CNR_Client_PickupHandled[client] = true;
							CreateTimer(5.0, Timer_HandlePickup, client, TIMER_FLAG_NO_MAPCHANGE);
							CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Weapon Restrict");
						}					
						return Plugin_Handled;
					}
				}
			}
		}
		else if ((gShadow_CNR_BlockWeapons_CT) && (GetClientTeam(client) == CS_TEAM_CT))
		{
			if (Weapon_IsValid(weapon))
			{
				char weaponname[64], AccessTo[128]; bool CanPickUp = false;
				GetEdictClassname(weapon, weaponname, sizeof(weaponname));
				ReplaceString(weaponname, sizeof(weaponname), "weapon_", "");
				
				if (StrContains(gShadow_CNR_BlockedWeapons, weaponname) != -1)
				{
					CheckRestrict.ImportFromFile(gShadow_CNR_ConfigFile_CT);
					
					if (!CheckRestrict.GotoFirstSubKey())
						return Plugin_Continue;
			
					char gShadow_temp_classname[32];	
					do
					{
						CheckRestrict.GetSectionName(gShadow_temp_classname, sizeof(gShadow_temp_classname));
						CheckRestrict.GetString("access_to", AccessTo, sizeof(AccessTo));
						int gShadow_CNR_SizeOfList_Restrict = ExplodeWeapons(AccessTo);
						
						if (!StrEqual(AccessTo, ""))
						{
							for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList_Restrict; Tidx++)
							{
								if ((StrEqual(gShadow_temp_classname, gShadow_CNR_Client_ChoosenClassName_CT[client])) && (StrContains(gShadow_CNR_WeaponList_Restrict[Tidx], weaponname) != -1))
								{
									CanPickUp = true;
								}
							}
						}
					}
					while (CheckRestrict.GotoNextKey());
					
					delete CheckRestrict;
					if (CanPickUp)
						return Plugin_Continue;
					else
					{
						if (!gShadow_CNR_Client_PickupHandled[client])
						{
							gShadow_CNR_Client_PickupHandled[client] = true;
							CreateTimer(5.0, Timer_HandlePickup, client, TIMER_FLAG_NO_MAPCHANGE);
							CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Weapon Restrict");
						}
						return Plugin_Handled;
					}
				}
			}
		}
		delete CheckRestrict;
	}
	return Plugin_Continue;
} 

public Action Timer_HandlePickup(Handle timer, int client)
{
	gShadow_CNR_Client_PickupHandled[client] = false;
	return Plugin_Stop;
}

public Action Timer_OverHeal(Handle timer, int client)
{
	if (!IsClientInLastRequest(client))
	{
		if ((GetEntProp(client, Prop_Data, "m_iHealth") > gShadow_CNR_Client_CT_HP[client]) && (GetClientTeam(client) == CS_TEAM_CT))
		{
			SetEntityHealth(client, gShadow_CNR_Client_CT_HP[client]);
		}
		else if ((GetEntProp(client, Prop_Data, "m_iHealth") > gShadow_CNR_Client_T_HP[client]) && (GetClientTeam(client) == CS_TEAM_T))
		{
			SetEntityHealth(client, gShadow_CNR_Client_T_HP[client]);
		}
	}
	return Plugin_Continue;
}

public Action Timer_LoadoutFix(Handle timer, int client)
{
	PlayerInformations(client);

	if (IsValidClient(client))
	{
		int gShadow_temp_team = GetClientTeam(client);
		if (!StrEqual(gShadow_CNR_Client_ChoosenClassName_T[client], "") && (gShadow_temp_team == CS_TEAM_T))
		{
			if (T_Class_Exist(gShadow_CNR_Client_ChoosenClassName_T[client]))
			{	
				Class_GetAttributes_ForTeam(client, gShadow_CNR_Client_ChoosenClassName_T[client], CS_TEAM_T);
				
				SetEntityHealth(client, gShadow_CNR_Client_T_HP[client]);
				Entity_SetMaxHealth(client, gShadow_CNR_Client_T_HP[client]);
				
				if (gShadow_CNR_Client_OverHeal_Checker[client] != INVALID_HANDLE)
				{
					KillTimer(gShadow_CNR_Client_OverHeal_Checker[client]);
					gShadow_CNR_Client_OverHeal_Checker[client] = INVALID_HANDLE;
				}
				
				gShadow_CNR_Client_OverHeal_Checker[client] = CreateTimer(0.5, Timer_OverHeal, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				
				SetEntProp(client, Prop_Send, "m_bHasHelmet", gShadow_CNR_Client_T_HELMET[client]);
				
				if (gShadow_CNR_Client_T_HS[client] == 1)
					GivePlayerItem(client, "item_heavyassaultsuit");
				else
				{
					SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", 0);
					SetEntProp(client, Prop_Send, "m_bWearingSuit", 0);
				}
				
				SetEntProp(client, Prop_Send, "m_ArmorValue", gShadow_CNR_Client_T_ARMOR[client]);
				SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", gShadow_CNR_Client_T_SPEED[client]);
				
				if (!StrEqual(gShadow_CNR_Client_T_Specials[client], ""))
				{
					StripAllWeapons(client);
					RemoveDangerZone(client);
				
					char buffer[32];
					if (StrContains(gShadow_CNR_Client_T_Specials[client], ",") != -1)
					{
						UpdateStartWeapons(client, gShadow_CNR_Client_T_Specials[client]);
						for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList[client]; Tidx++)
						{
							Format(buffer, sizeof(buffer), "weapon_%s", gShadow_CNR_WeaponList[client][Tidx]);
							if (!Client_HasWeapon(client, buffer) && !StrEqual(buffer, "weapon_healthshot"))
								GivePlayerItem(client, buffer);
							else if (StrEqual(buffer, "weapon_healthshot"))
								GivePlayerItem(client, buffer);
						}
					}
					else
					{
						Format(buffer, sizeof(buffer), "weapon_%s", gShadow_CNR_Client_T_Specials[client]);
						if (!Client_HasWeapon(client, buffer) && !StrEqual(buffer, "weapon_healthshot"))
							GivePlayerItem(client, buffer);
						else if (StrEqual(buffer, "weapon_healthshot"))
							GivePlayerItem(client, buffer);
					}
				}
				
				SetPlayerModel(client, gShadow_CNR_Client_T_Model[client]);
			}
		}
		else if (!StrEqual(gShadow_CNR_Client_ChoosenClassName_CT[client], "") && (gShadow_temp_team == CS_TEAM_CT))
		{
			if (CT_Class_Exist(gShadow_CNR_Client_ChoosenClassName_CT[client]))
			{
				Class_GetAttributes_ForTeam(client, gShadow_CNR_Client_ChoosenClassName_CT[client], CS_TEAM_CT);
				
				SetEntityHealth(client, gShadow_CNR_Client_CT_HP[client]);
				Entity_SetMaxHealth(client, gShadow_CNR_Client_CT_HP[client]);
				
				if (gShadow_CNR_Client_OverHeal_Checker[client] != INVALID_HANDLE)
				{
					KillTimer(gShadow_CNR_Client_OverHeal_Checker[client]);
					gShadow_CNR_Client_OverHeal_Checker[client] = INVALID_HANDLE;
				}
				
				gShadow_CNR_Client_OverHeal_Checker[client] = CreateTimer(0.5, Timer_OverHeal, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				
				SetEntProp(client, Prop_Send, "m_bHasHelmet", gShadow_CNR_Client_CT_HELMET[client]);
				
				if (gShadow_CNR_Client_CT_HS[client] == 1)
					GivePlayerItem(client, "item_heavyassaultsuit");
				else
				{
					SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", 0);
					SetEntProp(client, Prop_Send, "m_bWearingSuit", 0);
				}
				
				SetEntProp(client, Prop_Send, "m_ArmorValue", gShadow_CNR_Client_CT_ARMOR[client]);
				SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", gShadow_CNR_Client_CT_SPEED[client]);
				
				if (!StrEqual(gShadow_CNR_Client_CT_Specials[client], ""))
				{
					StripAllWeapons(client);
					RemoveDangerZone(client);
				
					char buffer[32];
					if (StrContains(gShadow_CNR_Client_CT_Specials[client], ",") != -1)
					{
						UpdateStartWeapons(client, gShadow_CNR_Client_CT_Specials[client]);
						for (int Tidx = 0; Tidx < gShadow_CNR_SizeOfList[client]; Tidx++)
						{
							Format(buffer, sizeof(buffer), "weapon_%s", gShadow_CNR_WeaponList[client][Tidx]);
							if (!Client_HasWeapon(client, buffer) && !StrEqual(buffer, "weapon_healthshot"))
								GivePlayerItem(client, buffer);
							else if (StrEqual(buffer, "weapon_healthshot"))
								GivePlayerItem(client, buffer);
						}
					}
					else
					{
						Format(buffer, sizeof(buffer), "weapon_%s", gShadow_CNR_Client_CT_Specials[client]);
						if (!Client_HasWeapon(client, buffer) && !StrEqual(buffer, "weapon_healthshot"))
							GivePlayerItem(client, buffer);
						else if (StrEqual(buffer, "weapon_healthshot"))
							GivePlayerItem(client, buffer);
					}
				}
				
				SetPlayerModel(client, gShadow_CNR_Client_CT_Model[client]);
			}
		}
		else if (StrEqual(gShadow_CNR_Client_ChoosenClassName_CT[client], "") && (gShadow_temp_team == CS_TEAM_CT))
		{
			ClearLocalClass(client, CS_TEAM_CT);
			
			SetEntityHealth(client, gShadow_CNR_Client_CT_HP[client]);
			Entity_SetMaxHealth(client, gShadow_CNR_Client_CT_HP[client]);
				
			if (gShadow_CNR_Client_OverHeal_Checker[client] != INVALID_HANDLE)
			{
				KillTimer(gShadow_CNR_Client_OverHeal_Checker[client]);
				gShadow_CNR_Client_OverHeal_Checker[client] = INVALID_HANDLE;
			}
			
			gShadow_CNR_Client_OverHeal_Checker[client] = CreateTimer(0.5, Timer_OverHeal, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			SetEntProp(client, Prop_Send, "m_bHasHelmet", gShadow_CNR_Client_CT_HELMET[client]);
			
			if (gShadow_CNR_Client_CT_HS[client] == 1)
				GivePlayerItem(client, "item_heavyassaultsuit");
			else
			{
				SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", 0);
				SetEntProp(client, Prop_Send, "m_bWearingSuit", 0);
			}
			
			SetEntProp(client, Prop_Send, "m_ArmorValue", gShadow_CNR_Client_CT_ARMOR[client]);
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", gShadow_CNR_Client_CT_SPEED[client]);
		}
		else if (StrEqual(gShadow_CNR_Client_ChoosenClassName_T[client], "") && (gShadow_temp_team == CS_TEAM_T))
		{
			ClearLocalClass(client, CS_TEAM_T);
			
			SetEntityHealth(client, gShadow_CNR_Client_T_HP[client]);
			Entity_SetMaxHealth(client, gShadow_CNR_Client_T_HP[client]);
			
			if (gShadow_CNR_Client_OverHeal_Checker[client] != INVALID_HANDLE)
			{
				KillTimer(gShadow_CNR_Client_OverHeal_Checker[client]);
				gShadow_CNR_Client_OverHeal_Checker[client] = INVALID_HANDLE;
			}
			
			gShadow_CNR_Client_OverHeal_Checker[client] = CreateTimer(0.5, Timer_OverHeal, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			SetEntProp(client, Prop_Send, "m_bHasHelmet", gShadow_CNR_Client_T_HELMET[client]);
			
			if (gShadow_CNR_Client_T_HS[client] == 1)
				GivePlayerItem(client, "item_heavyassaultsuit");
			else
			{
				SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", 0);
				SetEntProp(client, Prop_Send, "m_bWearingSuit", 0);
			}
			
			SetEntProp(client, Prop_Send, "m_ArmorValue", gShadow_CNR_Client_T_ARMOR[client]);
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", gShadow_CNR_Client_T_SPEED[client]);
		}
		
		if (gShadow_CNR_ForceFist)
		{
			int weapon;
			while((weapon = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE)) != -1)
			{
				RemovePlayerItem(client, weapon);
				AcceptEntityInput(weapon, "Kill");
			}
		
			int iMelee = GivePlayerItem(client, "weapon_fists");
			EquipPlayerWeapon(client, iMelee);
		}
		else
		{
			int iMelee = GivePlayerItem(client, "weapon_knife");
			EquipPlayerWeapon(client, iMelee);
		}
	}
	return Plugin_Stop;
}

void SetPlayerModel(int client, char model_path[PLATFORM_MAX_PATH])
{	
	if(!StrEqual(model_path, ""))
	{
		if(!IsModelPrecached(model_path))
			PrecacheModel(model_path);
		SetEntityModel(client, model_path);
	}
}

void UpdateStartWeapons(int client, char[] explode)
{
	gShadow_CNR_SizeOfList[client] = ExplodeString(explode, ",", gShadow_CNR_WeaponList[client], sizeof(gShadow_CNR_WeaponList), sizeof(gShadow_CNR_WeaponList[]));
}

public int ExplodeWeapons(char[] explode)
{
	int temp = ExplodeString(explode, ",", gShadow_CNR_WeaponList_Restrict, sizeof(gShadow_CNR_WeaponList_Restrict), sizeof(gShadow_CNR_WeaponList_Restrict[]));
	return temp;
}