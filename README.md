# Ultimate Giga Master Super Summoner King

## Current Version
Web-Alpha 0.0.2

## Doing => Changes planned for the next version
- add strong params to all controllers ✅
- highlight valid movement/attack fields on drag✅ => this is deemed more important than maintaining minion coloring (gets reset after refresh anyway ++ will be replaced with color variants)
  - valid movements are now calculated at end/start of turn ✅
  - added valid_movements migration to SummonedMinions ✅
  - implemented separate methods for verifying line of movement and line of sight ✅
- make dragging back to origin cancel move and not result in refresh ✅
- If the last player in the turn passes new turn doesn't automatically generate resulting in an error (p1-> move p2-> pass == error) ✅

## Core function to-do list => missing expected core/basic functionalities
- address full page refreshes, make sure only required elements are refreshed
- add tests, loads of tests
- add support for multiple combats/landing page
- add collision detection between units to prevent "hopping" over
- add user accounts/authentication system and user based rendering
- implement summoning zones
- improve mobile browser display
- move the game to websocket with turbo(?)
- enable saving combat log, match history
- replay system (via testing implementation of simulating movements)

## Friendly reminders from past self taht are somewhat relevant
- keep current version as "local" where can be played from one browser


## Technical debt pit of shame and eternal suffering
- revise attack/move SummonedMinion to work natively with drag/drop params passed from js
- server side processing of move is approaching 1 second need to revise efficiency

## Things that'd be cool to have and will most likely be prioritised over the core to-do's because they are fun
- revise how database is accessed (?)
- implement "attack type" within minion class to enable different kinds of attacks e.g cleave, straight line, artillery, ranged, splash
- implement "movement type" within minion class to enable different kinds of movement e.g flying/teleportation
- implement "spellbook" interface where minions/spells are dragged out onto the board
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
- add minions: zombie, mummy, vampire, ghost, lich, standardbearer, undead dragon, slime

## Bug List:
 - View gets rendered twice after drag/drop with only them visible(?)

 Version/Release Log:
