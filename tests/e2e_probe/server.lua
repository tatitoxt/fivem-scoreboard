-- E2E probe para orkelya_scoreboard
local checks = {}
local function check(name, ok, detail)
  checks[#checks + 1] = { name = name, ok = ok == true, detail = detail }
  print(('[SCORETEST] %s %s%s'):format(ok and 'PASS' or 'FAIL', name, detail and (' — ' .. tostring(detail)) or ''))
end
local function fileOk(path)
  local d = LoadResourceFile('orkelya_scoreboard', path)
  return d ~= nil and #d > 0
end
CreateThread(function()
  Wait(3000)
  check('resource_started', GetResourceState('orkelya_scoreboard') == 'started', GetResourceState('orkelya_scoreboard'))
  check('index_html', fileOk('ui/index.html'))
  check('app_js', fileOk('ui/app.js'))
  check('style_css', fileOk('ui/style.css'))
  check('config', fileOk('config.lua'))
  local fx = LoadResourceFile('orkelya_scoreboard', 'fxmanifest.lua') or ''
  check('ui_page', fx:find('ui/index.html') ~= nil)
  check('client_script', fx:find('client/main.lua') ~= nil)
  local app = LoadResourceFile('orkelya_scoreboard', 'ui/app.js') or ''
  check('nui_type', app:find('orkelya_score') ~= nil)
  check('demo_mode', app:find('demo=1') ~= nil)
  local css = LoadResourceFile('orkelya_scoreboard', 'ui/style.css') or ''
  check('pill_bare', css:find('pill%-bare') ~= nil)
  local pass, fail = 0, 0
  for _, c in ipairs(checks) do if c.ok then pass = pass + 1 else fail = fail + 1 end end
  local res = ('[SCORETEST] RESULT status=%s passed=%d failed=%d'):format(fail == 0 and 'PASS' or 'FAIL', pass, fail)
  print(res)
  Wait(500)
  ExecuteCommand('quit')
end)
