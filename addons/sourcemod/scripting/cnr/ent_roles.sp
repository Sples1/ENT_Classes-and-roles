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
ConVar gH_Cvar_CNR_Role_Pacific_Enabled;
ConVar gH_Cvar_CNR_Role_Survivor_Enabled;
ConVar gH_Cvar_CNR_Role_Rebel_Enabled;
ConVar gH_Cvar_CNR_Role_Assassin_Enabled;
ConVar gH_Cvar_CNR_Role_Sniper_Enabled;
ConVar gH_Cvar_CNR_Role_Ninja_Enabled;
ConVar gH_Cvar_CNR_Role_Gunslinger_Enabled;
ConVar gH_Cvar_CNR_Role_Blaster_Enabled;
ConVar gH_Cvar_CNR_Role_Butcher_Enabled;
ConVar gH_Cvar_CNR_Role_LR_Master_Enabled;
ConVar gH_Cvar_CNR_Role_Sufferer_Enabled;
ConVar gH_Cvar_CNR_Role_Headhunter_Enabled;

ConVar gH_Cvar_CNR_Role_Pacific_Reward;
ConVar gH_Cvar_CNR_Role_Survivor_Reward;
ConVar gH_Cvar_CNR_Role_Rebel_Reward;
ConVar gH_Cvar_CNR_Role_Assassin_Reward;
ConVar gH_Cvar_CNR_Role_Sniper_Reward;
ConVar gH_Cvar_CNR_Role_Ninja_Reward;
ConVar gH_Cvar_CNR_Role_Gunslinger_Reward;
ConVar gH_Cvar_CNR_Role_Blaster_Reward;
ConVar gH_Cvar_CNR_Role_Butcher_Reward;
ConVar gH_Cvar_CNR_Role_LR_Master_Reward;
ConVar gH_Cvar_CNR_Role_Sufferer_Reward;
ConVar gH_Cvar_CNR_Role_Headhunter_Reward;

bool gShadow_CNR_Role_Pacific_Enabled;
bool gShadow_CNR_Role_Survivor_Enabled;
bool gShadow_CNR_Role_Rebel_Enabled;
bool gShadow_CNR_Role_Assassin_Enabled;
bool gShadow_CNR_Role_Sniper_Enabled;
bool gShadow_CNR_Role_Ninja_Enabled;
bool gShadow_CNR_Role_Gunslinger_Enabled;
bool gShadow_CNR_Role_Blaster_Enabled;
bool gShadow_CNR_Role_Butcher_Enabled;
bool gShadow_CNR_Role_LR_Master_Enabled;
bool gShadow_CNR_Role_Sufferer_Enabled;
bool gShadow_CNR_Role_Headhunter_Enabled;

int gShadow_CNR_Role_Pacific_Reward;
int gShadow_CNR_Role_Survivor_Reward;
int gShadow_CNR_Role_Rebel_Reward;
int gShadow_CNR_Role_Assassin_Reward;
int gShadow_CNR_Role_Sniper_Reward;
int gShadow_CNR_Role_Ninja_Reward;
int gShadow_CNR_Role_Gunslinger_Reward;
int gShadow_CNR_Role_Blaster_Reward;
int gShadow_CNR_Role_Butcher_Reward;
int gShadow_CNR_Role_LR_Master_Reward;
int gShadow_CNR_Role_Sufferer_Reward;
int gShadow_CNR_Role_Headhunter_Reward;


//Client
Handle gCookie_CNR_ChoosenRole_T = INVALID_HANDLE;
Handle gCookie_CNR_ChoosenRole_CT = INVALID_HANDLE;

char gShadow_CNR_Client_Temp_Choosen[MAXPLAYERS+1][32];
char gShadow_CNR_Client_ChoosenRole_T[MAXPLAYERS+1][32];
char gShadow_CNR_Client_ChoosenRole_CT[MAXPLAYERS+1][32];

//Class
bool gShadow_CNR_Client_Pacific_Reward[MAXPLAYERS+1] = true;
bool gShadow_CNR_Client_Ninja_Reward[MAXPLAYERS+1] = true;
int gShadow_CNR_Client_Dealt_Damage_ToCT[MAXPLAYERS+1] = 0;
int gShadow_CNR_Client_Suffer_Damage[MAXPLAYERS+1] = 0;

public void Roles_OnPluginStart()
{
	gH_Cvar_CNR_Role_Pacific_Enabled = CreateConVar("sm_cnr_role_pacific_enabled", "1", "Enable or disable pacific role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Survivor_Enabled = CreateConVar("sm_cnr_role_survivor_enabled", "1", "Enable or disable survivor role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Rebel_Enabled = CreateConVar("sm_cnr_role_rebel_enabled", "1", "Enable or disable rebel role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Assassin_Enabled = CreateConVar("sm_cnr_role_assassin_enabled", "1", "Enable or disable assassin role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Sniper_Enabled = CreateConVar("sm_cnr_role_sniper_enabled", "1", "Enable or disable sniper role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Ninja_Enabled = CreateConVar("sm_cnr_role_ninja_enabled", "1", "Enable or disable ninja role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Gunslinger_Enabled = CreateConVar("sm_cnr_role_gunslinger_enabled", "1", "Enable or disable gunslinger role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Blaster_Enabled = CreateConVar("sm_cnr_role_blaster_enabled", "1", "Enable or disable blaster role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Butcher_Enabled = CreateConVar("sm_cnr_role_butcher_enabled", "1", "Enable or disable butcher role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_LR_Master_Enabled = CreateConVar("sm_cnr_role_lr_master_enabled", "1", "Enable or disable butcher role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Sufferer_Enabled = CreateConVar("sm_cnr_role_sufferer_enabled", "1", "Enable or disable butcher role:", 0, true, 0.0, true, 1.0);
	gH_Cvar_CNR_Role_Headhunter_Enabled = CreateConVar("sm_cnr_role_headhunter_enabled", "1", "Enable or disable butcher role:", 0, true, 0.0, true, 1.0);
	
	gH_Cvar_CNR_Role_Pacific_Reward = CreateConVar("sm_cnr_role_pacific_reward", "250", "Set the reward for Pacific:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Survivor_Reward = CreateConVar("sm_cnr_role_survivor_reward", "100", "Set the reward for Survivor:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Rebel_Reward = CreateConVar("sm_cnr_role_rebel_reward", "25", "Set the reward for Rebel:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Assassin_Reward = CreateConVar("sm_cnr_role_assassin_reward", "400", "Set the reward for Assassin:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Sniper_Reward = CreateConVar("sm_cnr_role_sniper_reward", "75", "Set the reward for Sniper:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Ninja_Reward = CreateConVar("sm_cnr_role_ninja_reward", "350", "Set the reward for Ninja:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Gunslinger_Reward = CreateConVar("sm_cnr_role_gunslinger_reward", "60", "Set the reward for Gunslinger:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Blaster_Reward = CreateConVar("sm_cnr_role_blaster_reward", "750", "Set the reward for Blaster:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Butcher_Reward = CreateConVar("sm_cnr_role_butcher_reward", "150", "Set the reward for Butcher:", 0, true, 0.0);
	gH_Cvar_CNR_Role_LR_Master_Reward = CreateConVar("sm_cnr_role_lr_master_reward", "250", "Set the reward for LR Master:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Sufferer_Reward = CreateConVar("sm_cnr_role_sufferer_reward", "50", "Set the reward for Sufferer:", 0, true, 0.0);
	gH_Cvar_CNR_Role_Headhunter_Reward = CreateConVar("sm_cnr_role_headhunter_reward", "35", "Set the reward for Headhunter:", 0, true, 0.0);

	gCookie_CNR_ChoosenRole_T = RegClientCookie("CNR_ChoosenRole_T", "CNR TRoleNew", CookieAccess_Private);	
	gCookie_CNR_ChoosenRole_CT = RegClientCookie("CNR_ChoosenRole_CT", "CNR CTRoleNew", CookieAccess_Private);

	HookConVarChange(gH_Cvar_CNR_Role_Pacific_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Survivor_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Rebel_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Assassin_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Sniper_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Ninja_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Gunslinger_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Blaster_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Butcher_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_LR_Master_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Sufferer_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Headhunter_Enabled, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Pacific_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Survivor_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Rebel_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Assassin_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Sniper_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Ninja_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Gunslinger_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Blaster_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Butcher_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_LR_Master_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Sufferer_Reward, OnCvarChange_Roles);
	HookConVarChange(gH_Cvar_CNR_Role_Headhunter_Reward, OnCvarChange_Roles);

	// Account for late loading
	for (int idx = 1; idx <= MaxClients ; idx++)
	{
		if (IsValidClient(idx))
		{
			SDKHook(idx, SDKHook_TraceAttack, CheckHeadshot_Role);
			ValidatePlayer(idx);
		}
	}

	HookEvent("player_hurt", PlayerHurt);
	HookEvent("player_death", OnPlayerDeath_Role);
}

public void Roles_ClientPutInServer(int client)
{
	SDKHook(client, SDKHook_TraceAttack, CheckHeadshot_Role);
	ValidatePlayer(client);
}

public void Role_OnClientDisconnect(int client)
{
	ClearLocalRoles(client);
}

void ClearLocalRoles(int client)
{
	gShadow_CNR_Client_Temp_Choosen[client] = "";
	gShadow_CNR_Client_ChoosenRole_T[client] = "";
	gShadow_CNR_Client_ChoosenRole_CT[client] = "";
	gShadow_CNR_Client_Pacific_Reward[client] = true;
	gShadow_CNR_Client_Ninja_Reward[client] = true;
	gShadow_CNR_Client_Dealt_Damage_ToCT[client] = 0;
	gShadow_CNR_Client_Suffer_Damage[client] = 0;
}

public Action CheckHeadshot_Role(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int HitGroup)
{
	if (IsValidClient(victim) && IsValidClient(attacker))
	{
		if (GetClientTeam(victim) != GetClientTeam(attacker))
		{
			if (HitGroup == 1)
			{
				if ((StrEqual(gShadow_CNR_Client_ChoosenRole_CT[attacker], "headhunter") && GetClientTeam(attacker) == CS_TEAM_CT) ||
					(StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "headhunter") && GetClientTeam(attacker) == CS_TEAM_T))
				{
					CNR_AddCredit(attacker, gShadow_CNR_Role_Headhunter_Reward);
					CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Headhunter_Reward);
					if (gShadow_CNR_Logging)
					{
						if (GetClientTeam(attacker) == CS_TEAM_T)
							LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Headhunter_Reward, gShadow_CNR_Client_ChoosenRole_T[attacker]);
						else
							LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Headhunter_Reward, gShadow_CNR_Client_ChoosenRole_CT[attacker]);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public void OnStartLR(int PrisonerIndex, int GuardIndex)
{
	if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[PrisonerIndex], "lrmaster"))
	{
		CreateTimer(1.0, Timer_CheckLR, PrisonerIndex, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
	
	if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[GuardIndex], "lrmaster"))
	{
		CreateTimer(1.0, Timer_CheckLR, GuardIndex, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_CheckLR(Handle timer, int client)
{
	if (IsValidClient(client))
	{
		if (!IsClientInLastRequest(client) && IsPlayerAlive(client))
		{
			CNR_AddCredit(client, gShadow_CNR_Role_LR_Master_Reward);
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_LR_Master_Reward);
			if (gShadow_CNR_Logging)
			{
				if (GetClientTeam(client) == CS_TEAM_T)
					LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", client, gShadow_CNR_Role_LR_Master_Reward, gShadow_CNR_Client_ChoosenRole_T[client]);
				else
					LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", client, gShadow_CNR_Role_LR_Master_Reward, gShadow_CNR_Client_ChoosenRole_CT[client]);
			}
			return Plugin_Stop;
		}
		else if (!IsPlayerAlive(client))
		{
			return Plugin_Stop;
		}
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action OnPlayerSpawn_Role(Event event, char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		ValidatePlayer(client);
		
		if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[client], "pacific") && GetClientTeam(client) == CS_TEAM_T)
			gShadow_CNR_Client_Pacific_Reward[client] = true;
		else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[client], "rebel") && GetClientTeam(client) == CS_TEAM_T)
			gShadow_CNR_Client_Dealt_Damage_ToCT[client] = 0;
		else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[client], "ninja") || StrEqual(gShadow_CNR_Client_ChoosenRole_CT[client], "ninja"))
			gShadow_CNR_Client_Ninja_Reward[client] = true;
		else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[client], "sufferer") || StrEqual(gShadow_CNR_Client_ChoosenRole_CT[client], "sufferer"))
			gShadow_CNR_Client_Suffer_Damage[client] = 0;
	}
}

public Action OnPlayerDeath_Role(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	
	char weaponname[64];
	GetEventString(event, "weapon", weaponname, sizeof(weaponname));
	
	if ((victim != attacker) && (victim > 0) && (victim <= MaxClients) && (attacker > 0) && (attacker <= MaxClients))
	{
		if (victim != attacker)
		{
			if (GetClientTeam(victim) != GetClientTeam(attacker))
			{
				if (GetClientTeam(attacker) == CS_TEAM_T)
				{
					if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "assassin"))
					{
						if (StrEqual(weaponname, "fists") || StrEqual(weaponname, "knife"))
						{
							CNR_AddCredit(attacker, gShadow_CNR_Role_Assassin_Reward);
							CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Assassin_Reward);
							if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Assassin_Reward, gShadow_CNR_Client_ChoosenRole_T[attacker]);
						}
					}
					else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "gunslinger"))
					{
						if (StrEqual(weaponname, "glock") || StrEqual(weaponname, "elite") || StrEqual(weaponname, "p250") || StrEqual(weaponname, "tec9") || \
							StrEqual(weaponname, "cz75a") || StrEqual(weaponname, "deagle") || StrEqual(weaponname, "revolver") || StrEqual(weaponname, "usp_silencer") || \
							StrEqual(weaponname, "hkp2000") || StrEqual(weaponname, "fiveseven"))
						{
							CNR_AddCredit(attacker, gShadow_CNR_Role_Gunslinger_Reward);
							CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Gunslinger_Reward);
							if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Gunslinger_Reward, gShadow_CNR_Client_ChoosenRole_T[attacker]);
						}
					}
					else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "blaster"))
					{
						if (StrEqual(weaponname, "molotov") || StrEqual(weaponname, "decoy") || StrEqual(weaponname, "flashbang") || StrEqual(weaponname, "hegrenade") || \
							StrEqual(weaponname, "smokegrenade") || StrEqual(weaponname, "incgrenade"))
						{
							CNR_AddCredit(attacker, gShadow_CNR_Role_Blaster_Reward);
							CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Blaster_Reward);
							if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Blaster_Reward, gShadow_CNR_Client_ChoosenRole_T[attacker]);
						}
					}
					else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "butcher"))
					{
						CNR_AddCredit(attacker, gShadow_CNR_Role_Butcher_Reward);
						CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Butcher_Reward);
						if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Butcher_Reward, gShadow_CNR_Client_ChoosenRole_T[attacker]);
					}
				}
				else if (GetClientTeam(attacker) == CS_TEAM_CT)
				{
					if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[attacker], "sniper"))
					{
						if (StrEqual(weaponname, "awp") || StrEqual(weaponname, "g3sg1") || StrEqual(weaponname, "scar20") || StrEqual(weaponname, "ssg08"))
						{
							CNR_AddCredit(attacker, gShadow_CNR_Role_Sniper_Reward);
							CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Sniper_Reward);
							if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Sniper_Reward, gShadow_CNR_Client_ChoosenRole_CT[attacker]);
						}
					}
					else if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[attacker], "gunslinger"))
					{
						if (StrEqual(weaponname, "glock") || StrEqual(weaponname, "elite") || StrEqual(weaponname, "p250") || StrEqual(weaponname, "tec9") || \
							StrEqual(weaponname, "cz75a") || StrEqual(weaponname, "deagle") || StrEqual(weaponname, "revolver") || StrEqual(weaponname, "usp_silencer") || \
							StrEqual(weaponname, "hkp2000") || StrEqual(weaponname, "fiveseven"))
						{
							CNR_AddCredit(attacker, gShadow_CNR_Role_Gunslinger_Reward);
							CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Gunslinger_Reward);
							if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", attacker, gShadow_CNR_Role_Gunslinger_Reward, gShadow_CNR_Client_ChoosenRole_CT[attacker]);
						}
					}
				}
			}
		}
	}
}

public Action OnRoundEnd_Role(Event event, const char[] name, bool dontBroadcast)
{
	for (int idx = 1; idx <= MaxClients ; idx++)
	{
		if (IsValidClient(idx))
		{
			if (GetClientTeam(idx) == CS_TEAM_T)
			{
				if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[idx], "pacific") && gShadow_CNR_Client_Pacific_Reward[idx] == true)
				{
					CNR_AddCredit(idx, gShadow_CNR_Role_Pacific_Reward);
					CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Pacific_Reward);
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, gShadow_CNR_Role_Pacific_Reward, gShadow_CNR_Client_ChoosenRole_T[idx]);
				}
				else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[idx], "survivor") && IsPlayerAlive(idx))
				{
					CNR_AddCredit(idx, gShadow_CNR_Role_Survivor_Reward);
					CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Survivor_Reward);
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, gShadow_CNR_Role_Survivor_Reward, gShadow_CNR_Client_ChoosenRole_T[idx]);
				}
				else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[idx], "rebel"))
				{
					int money = ((gShadow_CNR_Client_Dealt_Damage_ToCT[idx] / 25) * gShadow_CNR_Role_Rebel_Reward);
					if (money != 0)
					{
						CNR_AddCredit(idx, money);
						CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", money);
						if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, money, gShadow_CNR_Client_ChoosenRole_T[idx]);
					}
					else
					{
						CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Rebel NoDamage");
					}
				}
				else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[idx], "ninja") && gShadow_CNR_Client_Ninja_Reward[idx])
				{
					CNR_AddCredit(idx, gShadow_CNR_Role_Ninja_Reward);
					CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Ninja_Reward);
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, gShadow_CNR_Role_Ninja_Reward, gShadow_CNR_Client_ChoosenRole_T[idx]);
				}
				else if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[idx], "sufferer"))
				{
					int money = ((gShadow_CNR_Client_Suffer_Damage[idx] / 25) * gShadow_CNR_Role_Sufferer_Reward);
					if (money != 0)
					{
						CNR_AddCredit(idx, money);
						CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", money);
						if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, money, gShadow_CNR_Client_ChoosenRole_T[idx]);
					}
					else
					{
						CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Sufferer NoDamage");
					}
				}
			}
			else if (GetClientTeam(idx) == CS_TEAM_CT)
			{
				if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[idx], "survivor") && IsPlayerAlive(idx))
				{
					CNR_AddCredit(idx, gShadow_CNR_Role_Survivor_Reward);
					CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Survivor_Reward);
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, gShadow_CNR_Role_Survivor_Reward, gShadow_CNR_Client_ChoosenRole_CT[idx]);
				}
				else if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[idx], "ninja") && gShadow_CNR_Client_Ninja_Reward[idx])
				{
					CNR_AddCredit(idx, gShadow_CNR_Role_Ninja_Reward);
					CPrintToChat(idx, "%s %t", gShadow_CNR_ChatBanner, "CNR Got Credits", gShadow_CNR_Role_Ninja_Reward);
					if (gShadow_CNR_Logging) LogToFileEx(gShadow_CNR_LogFile, "Player %L gained %i credits from %s role.", idx, gShadow_CNR_Role_Ninja_Reward, gShadow_CNR_Client_ChoosenRole_CT[idx]);
				}
			}
		}
	}
}

public Action PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	int damage = GetEventInt(event, "dmg_health");

	if(!victim || !attacker)
        return;

	if ((victim != attacker) && (victim > 0) && (victim <= MaxClients) && (attacker > 0) && (attacker <= MaxClients) && IsValidClient(attacker) && IsValidClient(victim) && (GetClientTeam(attacker) != GetClientTeam(victim)))
	{
		ValidatePlayer(attacker);
		ValidatePlayer(victim);
		
		if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "pacific") && GetClientTeam(attacker) == CS_TEAM_T)
		{
			if (gShadow_CNR_Client_Pacific_Reward[attacker])
			{
				gShadow_CNR_Client_Pacific_Reward[attacker] = false;
				CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Lost Pacific");
			}
		}
		if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[attacker], "rebel") && GetClientTeam(attacker) == CS_TEAM_T)
		{
			if (GetClientTeam(attacker) == CS_TEAM_T && GetClientTeam(victim) == CS_TEAM_CT)
			{
				gShadow_CNR_Client_Dealt_Damage_ToCT[attacker] += damage;
			}
		}
		if ((StrEqual(gShadow_CNR_Client_ChoosenRole_CT[victim], "ninja") && GetClientTeam(victim) == CS_TEAM_CT) ||
		(StrEqual(gShadow_CNR_Client_ChoosenRole_T[victim], "ninja") && GetClientTeam(victim) == CS_TEAM_T) && gShadow_CNR_Client_Ninja_Reward[victim])
		{
			gShadow_CNR_Client_Ninja_Reward[victim] = false;
			CPrintToChat(attacker, "%s %t", gShadow_CNR_ChatBanner, "CNR Lost Ninja");
		}
		if ((StrEqual(gShadow_CNR_Client_ChoosenRole_CT[victim], "sufferer") && GetClientTeam(victim) == CS_TEAM_CT) ||
		(StrEqual(gShadow_CNR_Client_ChoosenRole_T[victim], "sufferer") && GetClientTeam(victim) == CS_TEAM_T))
		{
			gShadow_CNR_Client_Suffer_Damage[victim] += damage;
		}
	}
}

public void OnCvarChange_Roles(ConVar cvar, char[] oldvalue, char[] newvalue)
{
	if (cvar == gH_Cvar_CNR_Role_Pacific_Enabled)
		gShadow_CNR_Role_Pacific_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Pacific_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Survivor_Enabled)
		gShadow_CNR_Role_Survivor_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Survivor_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Rebel_Enabled)
		gShadow_CNR_Role_Rebel_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Rebel_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Assassin_Enabled)
		gShadow_CNR_Role_Assassin_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Assassin_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Sniper_Enabled)
		gShadow_CNR_Role_Sniper_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Sniper_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Ninja_Enabled)
		gShadow_CNR_Role_Ninja_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Ninja_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Gunslinger_Enabled)
		gShadow_CNR_Role_Gunslinger_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Gunslinger_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Blaster_Enabled)
		gShadow_CNR_Role_Blaster_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Blaster_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_LR_Master_Enabled)
		gShadow_CNR_Role_LR_Master_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_LR_Master_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Sufferer_Enabled)
		gShadow_CNR_Role_Sufferer_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Sufferer_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Headhunter_Enabled)
		gShadow_CNR_Role_Headhunter_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Headhunter_Enabled));
	else if (cvar == gH_Cvar_CNR_Role_Pacific_Reward)
		gShadow_CNR_Role_Pacific_Reward = GetConVarInt(gH_Cvar_CNR_Role_Pacific_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Survivor_Reward)
		gShadow_CNR_Role_Survivor_Reward = GetConVarInt(gH_Cvar_CNR_Role_Survivor_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Rebel_Reward)
		gShadow_CNR_Role_Rebel_Reward = GetConVarInt(gH_Cvar_CNR_Role_Rebel_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Assassin_Reward)
		gShadow_CNR_Role_Assassin_Reward = GetConVarInt(gH_Cvar_CNR_Role_Assassin_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Sniper_Reward)
		gShadow_CNR_Role_Sniper_Reward = GetConVarInt(gH_Cvar_CNR_Role_Sniper_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Ninja_Reward)
		gShadow_CNR_Role_Ninja_Reward = GetConVarInt(gH_Cvar_CNR_Role_Ninja_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Gunslinger_Reward)
		gShadow_CNR_Role_Gunslinger_Reward = GetConVarInt(gH_Cvar_CNR_Role_Gunslinger_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Blaster_Reward)
		gShadow_CNR_Role_Blaster_Reward = GetConVarInt(gH_Cvar_CNR_Role_Blaster_Reward);
	else if (cvar == gH_Cvar_CNR_Role_LR_Master_Reward)
		gShadow_CNR_Role_LR_Master_Reward = GetConVarInt(gH_Cvar_CNR_Role_LR_Master_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Sufferer_Reward)
		gShadow_CNR_Role_Sufferer_Reward = GetConVarInt(gH_Cvar_CNR_Role_Sufferer_Reward);
	else if (cvar == gH_Cvar_CNR_Role_Headhunter_Reward)
		gShadow_CNR_Role_Headhunter_Reward = GetConVarInt(gH_Cvar_CNR_Role_Headhunter_Reward);
}

public void Roles_OnConfigsExecuted()
{
	gShadow_CNR_Role_Pacific_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Pacific_Enabled));
	gShadow_CNR_Role_Survivor_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Survivor_Enabled));
	gShadow_CNR_Role_Rebel_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Rebel_Enabled));
	gShadow_CNR_Role_Assassin_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Assassin_Enabled));
	gShadow_CNR_Role_Sniper_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Sniper_Enabled));
	gShadow_CNR_Role_Ninja_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Ninja_Enabled));
	gShadow_CNR_Role_Gunslinger_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Gunslinger_Enabled));
	gShadow_CNR_Role_Blaster_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Blaster_Enabled));
	gShadow_CNR_Role_Butcher_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Butcher_Enabled));
	gShadow_CNR_Role_LR_Master_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_LR_Master_Enabled));
	gShadow_CNR_Role_Sufferer_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Sufferer_Enabled));
	gShadow_CNR_Role_Headhunter_Enabled = view_as<bool>(GetConVarInt(gH_Cvar_CNR_Role_Headhunter_Enabled));
	gShadow_CNR_Role_Pacific_Reward = GetConVarInt(gH_Cvar_CNR_Role_Pacific_Reward);
	gShadow_CNR_Role_Survivor_Reward = GetConVarInt(gH_Cvar_CNR_Role_Survivor_Reward);
	gShadow_CNR_Role_Rebel_Reward = GetConVarInt(gH_Cvar_CNR_Role_Rebel_Reward);
	gShadow_CNR_Role_Assassin_Reward = GetConVarInt(gH_Cvar_CNR_Role_Assassin_Reward);
	gShadow_CNR_Role_Sniper_Reward = GetConVarInt(gH_Cvar_CNR_Role_Sniper_Reward);
	gShadow_CNR_Role_Ninja_Reward = GetConVarInt(gH_Cvar_CNR_Role_Ninja_Reward);
	gShadow_CNR_Role_Gunslinger_Reward = GetConVarInt(gH_Cvar_CNR_Role_Gunslinger_Reward);
	gShadow_CNR_Role_Blaster_Reward = GetConVarInt(gH_Cvar_CNR_Role_Blaster_Reward);
	gShadow_CNR_Role_Butcher_Reward = GetConVarInt(gH_Cvar_CNR_Role_Butcher_Reward);
	gShadow_CNR_Role_LR_Master_Reward = GetConVarInt(gH_Cvar_CNR_Role_LR_Master_Reward);
	gShadow_CNR_Role_Sufferer_Reward = GetConVarInt(gH_Cvar_CNR_Role_Sufferer_Reward);
	gShadow_CNR_Role_Headhunter_Reward = GetConVarInt(gH_Cvar_CNR_Role_Headhunter_Reward);
	
	// Account for late loading
	for (int idx = 1; idx <= MaxClients ; idx++)
	{
		if (IsValidClient(idx))
		{
			SDKHook(idx, SDKHook_TraceAttack, CheckHeadshot_Role);
			ValidatePlayer(idx);
		}
	}
}

public void Submenu_Roles(int client)
{
	if (gShadow_CNR_Enabled)
	{
		if (IsValidClient(client))
		{
			int gShadow_temp_team = GetClientTeam(client);
			if (gShadow_temp_team == CS_TEAM_CT || gShadow_temp_team == CS_TEAM_T)
			{
				ValidatePlayer(client);
			
				char buffer[64]; bool CanShow = false;
				Menu menu = CreateMenu(RolesMainHandler);
				menu.SetTitle("---=| C.N.R |=---\n ");
				if (gShadow_temp_team == CS_TEAM_T)
				{
					if (gShadow_CNR_Role_Pacific_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Pacific");
						menu.AddItem("pacific", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Survivor_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Survivor");
						menu.AddItem("survivor", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Rebel_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Rebel");
						menu.AddItem("rebel", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Assassin_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Assassin");
						menu.AddItem("assassin", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Ninja_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Ninja");
						menu.AddItem("ninja", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Gunslinger_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Gunslinger");
						menu.AddItem("gunslinger", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Blaster_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Blaster");
						menu.AddItem("blaster", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Butcher_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Butcher");
						menu.AddItem("butcher", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_LR_Master_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR LR Master");
						menu.AddItem("lrmaster", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Sufferer_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Sufferer");
						menu.AddItem("sufferer", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Headhunter_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Headhunter");
						menu.AddItem("headhunter", buffer); CanShow = true;
					}
				}
				else if (gShadow_temp_team == CS_TEAM_CT)
				{
					if (gShadow_CNR_Role_Survivor_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Survivor");
						menu.AddItem("survivor", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Sniper_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Sniper");
						menu.AddItem("sniper", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Ninja_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Ninja");
						menu.AddItem("ninja", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Gunslinger_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Gunslinger");
						menu.AddItem("gunslinger", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_LR_Master_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR LR Master");
						menu.AddItem("lrmaster", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Sufferer_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Sufferer");
						menu.AddItem("sufferer", buffer); CanShow = true;
					}
					if (gShadow_CNR_Role_Headhunter_Enabled)
					{
						Format(buffer, sizeof(buffer), "%t", "CNR Headhunter");
						menu.AddItem("headhunter", buffer); CanShow = true;
					}
				}
				
				if (CanShow)
				{
					Format(buffer, sizeof(buffer), "%t", "CNR Menu NoRole");
					menu.AddItem("norole", buffer);
					
					menu.Display(client, MENU_TIME_FOREVER);
				}
				else
				{
					CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR NoRoles");
				}
			}
			else
			{
				CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Not In Team");
			}
		}
	}
	else
	{
		CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Disabled");
	}
}

public int RolesMainHandler(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		if (!gShadow_CNR_Enabled)
		{
			PrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Disabled");
			return;
		}
		
		char gShadow_temp_chooserole[16];
		int gShadow_temp_team = GetClientTeam(client);
		GetMenuItem(menu, itemNum, gShadow_temp_chooserole, sizeof(gShadow_temp_chooserole));
		if (!StrEqual(gShadow_temp_chooserole, "norole"))
		{
			ShowRoleDetails(client, gShadow_temp_chooserole);
		}
		else if (StrEqual(gShadow_temp_chooserole, "norole"))
		{
			if (gShadow_temp_team == CS_TEAM_T)
			{
				SetClientCookie(client, gCookie_CNR_ChoosenRole_T, "");
			}
			else if (gShadow_temp_team == CS_TEAM_CT)
			{
				SetClientCookie(client, gCookie_CNR_ChoosenRole_CT, "");
			}
			
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR RoleRemoval Next Round");
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

void ShowRoleDetails(int client, char[] choosen)
{
	Format(gShadow_CNR_Client_Temp_Choosen[client], sizeof(gShadow_CNR_Client_Temp_Choosen), choosen);
	Menu menu = CreateMenu(RolesSubHandler);
	menu.SetTitle("---=| C.N.R |=---\n ");
	
	char buffer[64];
	Format(buffer, sizeof(buffer), "%t", "CNR Description");
	menu.AddItem("description", buffer);
	
	if (StrEqual(choosen, gShadow_CNR_Client_ChoosenRole_T[client]) || StrEqual(choosen, gShadow_CNR_Client_ChoosenRole_CT[client]))
	{
		Format(buffer, sizeof(buffer), "%t", "CNR Selected");
		menu.AddItem("", buffer, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(buffer, sizeof(buffer), "%t", "CNR Select");
		menu.AddItem("select", buffer);
	}
	
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RolesSubHandler(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Cancel)
	{
		FakeClientCommandEx(client, "sm_roles");
	}
	else if (action == MenuAction_Select)
	{
		char info[64];
		GetMenuItem(menu, itemNum, info, sizeof(info));
		int gShadow_temp_team = GetClientTeam(client);
		if (StrEqual(info, "select"))
		{
			if (gShadow_temp_team == CS_TEAM_CT)
				SetClientCookie(client, gCookie_CNR_ChoosenRole_CT, gShadow_CNR_Client_Temp_Choosen[client]);
			else if (gShadow_temp_team == CS_TEAM_T)
				SetClientCookie(client, gCookie_CNR_ChoosenRole_T, gShadow_CNR_Client_Temp_Choosen[client]);
				
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR RoleApply Next Round");
		}
		else if (StrEqual(info, "description"))
		{
			if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "pacific")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Pacific Description", gShadow_CNR_Role_Pacific_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "survivor")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Survivor Description", gShadow_CNR_Role_Survivor_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "rebel")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Rebel Description", gShadow_CNR_Role_Rebel_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "assassin")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Assassin Description", gShadow_CNR_Role_Assassin_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "sniper")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Sniper Description", gShadow_CNR_Role_Sniper_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "ninja")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Ninja Description", gShadow_CNR_Role_Ninja_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "gunslinger")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Gunslinger Description", gShadow_CNR_Role_Gunslinger_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "blaster")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Blaster Description", gShadow_CNR_Role_Blaster_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "butcher")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Butcher Description", gShadow_CNR_Role_Butcher_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "lrmaster")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR LR Master Description", gShadow_CNR_Role_LR_Master_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "sufferer")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Sufferer Description", gShadow_CNR_Role_Sufferer_Reward);
			else if (StrEqual(gShadow_CNR_Client_Temp_Choosen[client], "headhunter")) CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Headhunter Description", gShadow_CNR_Role_Headhunter_Reward);
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public Action Timer_Validate(Handle timer, int client)
{
	ValidatePlayer(client);
	return Plugin_Stop;
}

public void ValidatePlayer(int client)
{
	if (IsValidClient(client) && AreClientCookiesCached(client))
	{
		char TempStorageT[64], TempStorageCT[64];
		GetClientCookie(client, gCookie_CNR_ChoosenRole_T, TempStorageT, sizeof(TempStorageT));
		GetClientCookie(client, gCookie_CNR_ChoosenRole_CT, TempStorageCT, sizeof(TempStorageCT));
		
		if (StrEqual(TempStorageT, "pacific") && gShadow_CNR_Role_Pacific_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "survivor") && gShadow_CNR_Role_Survivor_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "rebel") && gShadow_CNR_Role_Rebel_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "assassin") && gShadow_CNR_Role_Assassin_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "ninja") && gShadow_CNR_Role_Ninja_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "gunslinger") && gShadow_CNR_Role_Gunslinger_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "blaster") && gShadow_CNR_Role_Blaster_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "butcher") && gShadow_CNR_Role_Butcher_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "lrmaster") && gShadow_CNR_Role_LR_Master_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "sufferer") && gShadow_CNR_Role_Sufferer_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		else if (StrEqual(TempStorageT, "headhunter") && gShadow_CNR_Role_Headhunter_Enabled) Format(gShadow_CNR_Client_ChoosenRole_T[client], sizeof(gShadow_CNR_Client_ChoosenRole_T), TempStorageT);
		
		if (StrEqual(TempStorageCT, "survivor") && gShadow_CNR_Role_Survivor_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "sniper") && gShadow_CNR_Role_Sniper_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "ninja") && gShadow_CNR_Role_Ninja_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "gunslinger") && gShadow_CNR_Role_Gunslinger_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "lrmaster") && gShadow_CNR_Role_LR_Master_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "sufferer") && gShadow_CNR_Role_Sufferer_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		else if (StrEqual(TempStorageCT, "headhunter") && gShadow_CNR_Role_Headhunter_Enabled) Format(gShadow_CNR_Client_ChoosenRole_CT[client], sizeof(gShadow_CNR_Client_ChoosenRole_CT), TempStorageCT);
		
		if (StrEqual(gShadow_CNR_Client_ChoosenRole_T[client], "") && !StrEqual(TempStorageT, ""))
		{
			SetClientCookie(client, gCookie_CNR_ChoosenRole_T, "");
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Current Role Disabled");
			LogToFileEx(gShadow_CNR_LogFile, "Player %L role is disabled (%s). Player role set to none.", client, TempStorageT);
		}
		
		if (StrEqual(gShadow_CNR_Client_ChoosenRole_CT[client], "") && !StrEqual(TempStorageCT, ""))
		{
			SetClientCookie(client, gCookie_CNR_ChoosenRole_CT, "");
			CPrintToChat(client, "%s %t", gShadow_CNR_ChatBanner, "CNR Current Role Disabled");
			LogToFileEx(gShadow_CNR_LogFile, "Player %L role is disabled (%s). Player role set to none.", client, TempStorageCT);
		}
	}
}