# Ultimate Giga Master Super Summoner King

https://zortalowa-gra.herokuapp.com/

## Basic rules ##
Players: 2-4
Once 2 players have joined one of two available games the option to start the game will become available in the navigation bar.

The goal of the game is to kill all of enemy minions and bring your opponents mana down to 0 in the process.

Please utilize the "summon" button when its your turn to summon minions using the radio buttons and relevant fields. Minions can be summoned within your specified summoning zone.

Once summoned the minions can be moved using drag and drop over the board, the status of all your minions will be visible under the board and in the battle log to the right of the board.

In order to finish the game one player has to remain at which point the option to reset, generate a new board and re-enable joining will be available.

Once loaded the game will refresh every 15 seconds to "synchronise" between all users connected, it's not a bug, it's a feature (Websockets coming to the necromancer simulator near you soon(tm)), to avoid frustration I highly recommend summoning your minions quickly or right after the refresh.

Should a game be occupied by idle users /reset/*game-number* can be utilized to force reset (Game tiemout coming to the necromancer simulator near you soon(tm))

## Current Version
Web-Alpha 0.0.8

## Ready features of next version:
- Cleared up <games_controller.rb>, added before_action to set game instance✅
- Fixed rendering querying database multiple times instead of using a results array to filter✅

## latest-commit
- View gets rendered twice after drag/drop with only them visible - Bug fixed✅

## Active to-do:
- Implementing turbo_stream/websockets - websocket connection now gets initiated
- Added redis to project for broadcasting
- Implementing turbo_stream/websockets => in progress

Queued bug fixes:

## Doing => Changes planned for the next version
---
- Write public interface tests for all models/requests
- address full page refreshes, make sure only required elements are refreshed( websocket implementation )
- initiate games with board existing not requiring a reset
- Move ending turn to the event logging, revise turn tracking
- Only calculate minion specific information on drag to optimize performance(Testing required)

## Core function to-do list => missing/expected core/basic functionalities or required improvements
- add collision detection between units to prevent "hopping" over
- improve mobile browser display
- enable saving combat log, match history
- replay system (via testing implementation of simulating movements)


## Friendly reminders from past self taht are somewhat relevant
- keep current version as "local" where can be played from one browser


## Technical debt pit of shame and eternal suffering
- revise attack/move SummonedMinion to work natively with drag/drop params passed from js
- line of sight calculation is pretty bad for movement - revise dijkstra implementation(maybe, only affecting with speed 3+ though)

## Things that'd be cool to have and will most likely be prioritised over the core to-do's because they are fun
- implement "attack type" within minion class to enable different kinds of attacks e.g cleave, straight line, artillery, ranged, splash
- implement "movement type" within minion class to enable different kinds of movement e.g flying/teleportation
- implement "spellbook" interface where minions/spells are dragged out onto the board
- floating damage text
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

Version/Release Log:
  v0.0.8 => -

  QUALITY OF LIFE/FEATURES:
  - implement summoning zones:
    - BoardStates have summoning zones assigned on creation✅
    - zones are visible in the player list✅
    - players can only summon to the fields in their zone✅
    -
  TESTS:
   - Added rspec spec testing to the project✅
   - Added FactoryBot and setup initial factories for testing ✅
   - Added db seeding to the rspec setup✅
   - Added DatabaseCleaner to testing environment✅
   - Added logins controller tests✅
   - Added SummonedMinion controller tests:
     - Correct move✅
     - Moving another players minion results in error✅
     - Invalid move results in error✅
     - Attack results in damage taken✅
     - Minions can be correctly summoned✅
   - Style improvements

  ARCHITECTURE/CODE:
  - Implemented summoned zone service manager SummoningZoneManager with services:
    - SummoningZoneManager::GrabAvailableSummoningZoneFromAGame - pulls zone from board✅
    - SummoningZoneManager::ReturnSummoningZoneWhenLeavingOrRemoved - returns zone to board✅
    - SummoningZoneManager::TranslateZoneFromTextToArray - converts zone name to array of values✅
  - Implemented additional service manager in SummonedMinionManager with services:
    - SummonedMinionManager::FindMinionSpeedFromMinionRecord✅
    - SummonedMinionManager::FindMinionHealthFromMinionRecord✅
    - SummonedMinionManager::FindMinionManaFromMinionRecord✅
    - SummonedMinionManager::FindMinionRangeFromMinionType✅
    - SummonedMinionManager::FindMinionStatsFromMinionID✅
    - SummonedMinionManager::CalculateDamage✅
    - SummonedMinionManager::TransformPositionIntoXYHash✅ - added to accept position arrays and convert to the x/y format✅
    - FindMinionsByOwner moved to SummonedMinionManager✅
  - Implemented BoardFieldManager with services:
  - BoardFieldManager::ClearFieldByOccupant (previously JanitorManager::ClearFieldByOccupantID)✅
  - BoardFieldManager::UpdateFieldOccupant✅
  - Implemented game service manager GameManager with services:
    - GameManager::RestartGameWithAnExistingGameID ✅
    - GameManager::SetCurrentPlayer ✅
    - GameManager::RemovePlayer ✅
    - GameManager::AddPlayer ✅
  - Deprecated FinderManager:
    - FindMinionsByOwner moved to SummonedMinionManager✅
    - FindBoardFieldByOccupantId has been deprecated✅
    - FindGameIdByPlayerId moved to GameManager✅
  - Added new service objects:
    - JanitorManager::RemoveGameFromUser✅
  - Wrapper methods for Game model have been separated out into ExistingGame wrapper class✅
  - Changed current player tracking to be accessible from Game✅
  - Review loop in game which assigns valid targets/movement fields - optimised✅
  - Correct/valid moves are now calculated and assigned between turns and not re-checked during update drag✅
  - Removed large duplication and unneccessary database calls in Pathfinding logic, correct moves are now calculated and assigned between turns and not re-checked during update drag✅
  - Improved the SummonedMinion model, partial rewrite, added service objects✅
  - Untangled Game and TurnTracker models✅
  - Untangled Game and PvpPlayer models✅
  - Separated out interfaces for model classes✅
  - large rewrites/refactoring of "legacy" code✅

  BUGFIXES:
    - resolved the bug where first time joining a game resulted in a failure✅

  v0.0.7 => -
  - Re written Game controller for readability, implemented a number of wrapper methods ✅
  - Moved update_drag function from BoardField controller to SummonedMinion model, deleted Board_fields_controller✅
  - Implemented service object template under FinderManager::FindMinionsByOwner✅
  - Implemented additional service objects under:
    - JanitorManager::ClearFieldByOccupantID - clears BoardField entry✅
    - FinderManager::FindGameIdByPlayerId - finds gameID from player ID✅
    - JanitorManager::DeleteSessionsByUserUuid - deletes session based on user uuid✅
  - resolved a bug where conceding will have caused an immediate reset by adding an additional branch to main gameplay loop✅
  - summon no longer requires double click - changes to the menu controller ✅
  - implement sessions verification against database✅ - sessions are now stored in a database and users authenticated against it
  - added rspec, started implementing tests for functions✅
  - First player has a double turn sometimes✅ - resolved
  - Cleared up drag and drop javascript controller removing unneccessary bindings✅
  - Login now required to proceed into the app, employed helper methods for restricting access✅

  v0.0.6 => -
  - cleaned the code base to remove stray comments ✅
  - added basic rule set to the readme.md and a link within the game ✅
  - button are moving on refresh✅
  - Opponent moving PLEASE wait for your turn✅
  - Summoning on same field crashes server and results in adding minion to list (not actually to board)✅ (caused by usage of uninitiated flashing in event logging)

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
