# orkelya_scoreboard

Scoreboard estilo **Liquid Glass** para servidores de rol FiveM: lista de jugadores con ping, monocromo oscuro, 0 dependencias.

- **Hold o toggle** — `Config.Mode` + tecla configurable (Z por defecto)
- **Fila**: ID de server, nombre, ping con semáforo sutil (verde/gris)
- **Tu fila resaltada** + contador `X/Max` + hostname automático
- **Staff online**: cualquier recurso lo alimenta via `TriggerClientEvent('orkelya_score:staff', src, n)`
- 4 estilos: `glass` / `solid` / `line` / `bare` (100% transparente, outline oscuro)
- ~0.00 ms/tick cerrado; refresco a 400 ms solo mientras está abierto
- `exports.orkelya_scoreboard:SetOpen(true)` para abrirlo desde otros recursos

## Install

1. Copiá `orkelya_scoreboard` a `resources/`.
2. `ensure orkelya_scoreboard` en tu `server.cfg`.
3. Ajustá `config.lua` (tecla, modo, estilo, footer).

## Marcar staff online

```lua
-- desde tu recurso de staff (server → cliente del jugador que abre el board):
TriggerClientEvent('orkelya_score:staff', src, staffOnlineCount)
```
