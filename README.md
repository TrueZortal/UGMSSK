# Ultimate Giga Master Super Summoner King

https://zortalowa-gra.herokuapp.com/

## Current Version
Web-Alpha 0.0.5

## Ready features of next version
- button are moving on refresh✅
- Opponent moving PLEASE wait for your turn✅
- Summoning on same field crashes server and results in adding minion to list (not actually to board)✅ (caused by usage of uninitiated flashing in event logging)


## Active to-do:
- Full page refresh is very disruptive
- First player has a double turn sometimes
- summon requires double click

## Doing => Changes planned for the next version
committed marked by ✅
---
- initiate games with board existing not requiring a reset
- address full page refreshes, make sure only required elements are refreshed
- Review loop in game which assigns valid targets/movement fields
- implement summoning zones



## Core function to-do list => missing/expected core/basic functionalities or required improvements
- move everything to model <--- update_drag from controller BoardField to model
- add tests, loads of tests
- add collision detection between units to prevent "hopping" over
- improve mobile browser display
- move the game to websocket with turbo(?)
- enable saving combat log, match history
- replay system (via testing implementation of simulating movements)


## Friendly reminders from past self taht are somewhat relevant
- keep current version as "local" where can be played from one browser


## Technical debt pit of shame and eternal suffering
- revise attack/move SummonedMinion to work natively with drag/drop params passed from js
- line of sight calculation is pretty bad for movement - revise dijkstra implementation(maybe, only affecting with speed 3+ though)
- server side processing of move is approaching 1 second need to revise efficiency

## Things that'd be cool to have and will most likely be prioritised over the core to-do's because they are fun
- implement "attack type" within minion class to enable different kinds of attacks e.g cleave, straight line, artillery, ranged, splash
- implement "movement type" within minion class to enable different kinds of movement e.g flying/teleportation
- implement "spellbook" interface where minions/spells are dragged out onto the board
- floating damage text
- revise how database is accessed (?)
- order tokens/models on fiverr and graphics
- implement a mana meter
- add minion health bars/numbers
- add minion hovers with full stats
- make drag snap to cursor on click
- implement spells/spellcasting
- implement buffs/debuffs/minion modifiers
- implement necromancer system with possible impact on the undead: talents? Levels?
- inventory system for necromancer
- revise damage calculation(%defense, types of attack)
- add minions: zombie, mummy, vampire, ghost, lich, standardbearer, undead dragon, slime etc etc

## Bug List:
 - View gets rendered twice after drag/drop with only them visible(?)

 Version/Release Log:

v0.0.5 => -
- style improvements ✅
- enable logged in players joining game(s) ✅
- Added ability to start game when enough players via navigation bar✅
- Add ability to leave joined game before it starts via navigation bar✅
- revise the reaction/logic after the game is finished✅
- Style improvements✅
- Added 10s refresh timer for play✅
- Move most elements to partial renders (Board, Combat log, Status, Players)✅

v0.0.4 => -
- event log should only report based on game_id and order by update date ✅
- add support for multiple combats/landing page ✅
- add user accounts/authentication system and user based rendering ✅

v0.0.3:
- add strong params to all controllers ✅
- highlight valid movement/attack fields on drag✅ => this is deemed more important than maintaining minion coloring (gets reset after refresh anyway ++ will be replaced with color variants)
  - valid movements are now calculated at end/start of turn ✅
  - added valid_movements migration to SummonedMinions ✅
  - implemented separate methods for verifying line of movement and line of sight ✅
- make dragging back to origin cancel move and not result in refresh ✅
- If the last player in the turn passes new turn doesn't automatically generate resulting in an error (p1-> move p2-> pass == error) ✅
- disabled line of movement verification as it was resulting in inconsistent movement => Game::populate_possible_moves (commented out)✅
- fixed a bug where a minion with range of 3 was falling just short of reaching something 3 fields away✅