-- ===== Orkelya Scoreboard — client =====
-- Lista de jugadores estilo glass. Hold o toggle según Config.Mode.
local open = false

local function rows()
  local me = PlayerId()
  local myServerId = GetPlayerServerId(me)
  local list = {}
  for _, pid in ipairs(GetActivePlayers()) do
    local sid = GetPlayerServerId(pid)
    list[#list + 1] = {
      id = sid,
      name = GetPlayerName(pid) or '?',
      ping = GetPlayerPing(pid),
      me = sid == myServerId,
    }
  end
  table.sort(list, function(a, b) return a.id < b.id end)
  return list
end

local function sendBoard()
  local maxc = GetConvarInt('sv_maxclients', 32)
  local name = Config.ServerName ~= '' and Config.ServerName or GetConvar('sv_hostname', 'FiveM')
  SendNUIMessage({
    type = 'orkelya_score', action = 'board',
    server = name, brand = Config.Brand,
    footer = Config.FooterText or '',
    count = #GetActivePlayers(),
    max = maxc,
    showPing = Config.ShowPing ~= false,
    showId = Config.ShowId ~= false,
    labels = Config.Strings or {},
    rows = rows(),
  })
end

local function setOpen(v)
  if open == v then return end
  open = v
  SetNuiFocus(false, false)
  SendNUIMessage({
    type = 'orkelya_score', action = 'open', on = v,
    pill = Config.PillStyle or 'glass',
  })
  if v then sendBoard() end
end

-- Staff online lo pasa el server (otros recursos pueden marcar admins):
--   TriggerClientEvent('orkelya_score:staff', src, count)
local staffCount = nil
RegisterNetEvent('orkelya_score:staff', function(n) staffCount = tonumber(n) end)

CreateThread(function()
  local key = Config.Key or 'Z'
  local code = ({
    Z = 20, X = 73, F9 = 56, F10 = 57, TAB = 37, HOME = 213,
  })[key] or 20
  while true do
    Wait(0)
    local down = IsControlPressed(0, code)
    if Config.Mode == 'toggle' then
      if IsControlJustPressed(0, code) then setOpen(not open) end
    else
      setOpen(down)
    end
    if open then
      -- refresco barato mientras está abierto
      Wait(400)
      if open then
        local b = { staff = staffCount }
        SendNUIMessage({ type = 'orkelya_score', action = 'refresh',
          count = #GetActivePlayers(), staff = staffCount, rows = rows() })
      end
    end
  end
end)

-- Permite que otros recursos abran/cierren (menús, etc.)
RegisterNetEvent('orkelya_score:open', function(v) setOpen(v == true) end)
exports('SetOpen', setOpen)
exports('IsOpen', function() return open end)
