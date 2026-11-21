-- orkelya_scoreboard — config (shared: no hay secretos en este recurso)
Config = Config or {}

-- Tecla para abrir. 'Z' default; 'hold' = visible mientras la mantenés,
-- 'toggle' = abre/cierra con cada pulsación.
Config.Key = 'Z'
Config.Mode = 'hold'      -- 'hold' | 'toggle'

-- Estilo de pill/borde: 'glass' | 'solid' | 'line' | 'bare'
-- ('bare' = 100% transparente con outline oscuro sutil).
Config.PillStyle = 'glass'

-- Qué muestra cada fila.
Config.ShowPing = true
Config.ShowId = true

-- Header: nombre del server y contador. El nombre sale del hostname.
Config.ServerName = ''    -- '' = usa sv_hostname
Config.FooterText = ''    -- texto extra al pie (ej. 'discord.gg/tuserver')

-- Locales
Config.Strings = {
  players = 'JUGADORES', id = 'ID', name = 'NOMBRE', ping = 'PING',
  staff = 'STAFF', you = 'VOS',
}

-- Branding del server: logo en el header + watermark de fondo.
-- Rutas relativas a ui/ (ej. 'assets/logo.png') o URL.
Config.Brand = {
  -- logo = 'assets/logo.png',
  -- watermark = 'assets/logo.png',
}
