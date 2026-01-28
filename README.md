# __Manis_TestFramework__/README.md

# Manis Test Framework

A **lightweight, manual, deterministic test framework** for Factorio 2.0 mod developers.

This mod provides a simple way to write and execute automated tests **inside a running Factorio game**,  
without introducing heavy infrastructure, CI assumptions, or non-deterministic behavior.

---

## Concept

Manis Test Framework is **not** a full CI system  
and **not** an always-on automated test runner.

Instead, it is designed as:

- A **developer tool** for mod authors
- Executed **manually via commands**
- Fully **deterministic and multiplayer-safe**
- Easy to embed into existing mods without restructuring them

The framework itself does **not** test anything by default.  
It only provides the execution engine and utilities.

---

## Key Features

- Simple test runner (`TestRunner`)
- Basic assertions:
  - `assert(condition, message)`
  - `assert_eq(actual, expected, message)`
- Manual execution via console commands
- Output to:
  - Game chat
  - `factorio-current.log`
  - Optional file output via `helpers.write_file`
- Deterministic execution (no use of Lua's `math.random`)
- No global hooks, no automatic scanning

---

## How To Use (Quick Start)

### 1. Add dependency

Add this mod as a dependency in your `info.json`:

```json
"dependencies": [
  "Manis_TestFramework >= 0.0.1"
]
```

### 2. Require TestRunner in your mod
local TestRunner = require("__Manis_TestFramework__/scripts/test/TestRunner")

### 3. Define a test suite in your mod
```
-- scripts/tests/my_suite.lua
return {
  ["example: 1 + 1"] = function(T)
    T.assert_eq(1 + 1, 2, "math broken")
  end,

  ["example: boolean check"] = function(T)
    T.assert(true, "this should never fail")
  end,
}
```

### 4. Register your own command (recommended)

```
local TestRunner = require("__Manis_TestFramework__/scripts/test/TestRunner")
local suite = require("scripts.tests.my_suite")

commands.add_command("my-mod-test", "Run my mod tests", function()
  TestRunner.run_suite("my-mod", suite)
end)
```

### Then run in-game:
```
/my-mod-test
```

## About Sample Suites

This mod may include **sample test suites** (for example, `cap_suite.lua`)  
for **demonstration purposes only**.

These files exist solely to show:

- How a test suite is structured
- How assertions are written
- How the runner executes a suite

They are **not** meant to be extended directly inside this mod.

### Important Notes

- You are **not expected** to add your own tests inside `Manis_TestFramework`
- The normal and recommended workflow is:
  - Each mod defines its **own test suites**
  - Each mod decides **when and how** those tests are executed
- This framework **does not automatically discover or run tests**

This design is intentional.

It avoids:
- Hidden or unexpected test execution
- Performance surprises during gameplay
- Multiplayer desynchronization risks

---

## Why Manual Execution?

Factorio mods run inside a **live simulation environment**.

Automatically executing tests in the background can:
- Interfere with gameplay
- Modify game state unexpectedly
- Cause multiplayer desyncs
- Produce misleading results

For these reasons, Manis Test Framework requires
**explicit user commands** to run tests.

This ensures:
- Tests run only when the developer intends
- The game state is consciously prepared
- Results are reproducible and debuggable

---

## Determinism Policy

- All test execution must be deterministic
- Use Factorio’s `LuaRandomGenerator` when randomness is required
- Do **not** use Lua’s standard `math.random`
- Any non-deterministic behavior is treated as a **bug**

---

## Logging and Output

By default, test results are written to:

- In-game chat via `game.print`
- Log file via `log()` (`factorio-current.log`)

Optional file output can be added using Factorio’s official API:

helpers.write_file("manis_test.log", "message\n", true)

This allows:

- Persistent test logs
- Comparison between runs
- External inspection after crashes

Non-goals## Non-goals

This framework does not aim to:

- Replace CI pipelines
- Automatically run tests on save/load
- Enforce a single test structure across mods
- Mock or simulate Factorio internal systems

It is intentionally minimal and transparent.

Intended Audience## Intended Audience

- Factorio mod developers
- Developers maintaining complex deterministic logic
- Mod authors who want confidence when refactoring or optimizing

## Status and Roadmap

- Initial public release: v0.0.1

### Future Plans
- Minor helper utilities if clearly needed
- No large feature expansion planned

This framework is intended to remain small, stable, and predictable.

--- 

Happy testing.
If your test breaks the game, at least it breaks on purpose 🙂