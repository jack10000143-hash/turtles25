# Turtles 2025

Starter for vibe coding [CC: Tweaked](
https://github.com/cc-tweaked/CC-Tweaked) turtle scripts with [Aider](
https://aider.chat/).

The plan:

- Get Minecraft running with CC: Tweaked.
- Create a new world.
- Get a turtle.
- Create a file on the turtle (`edit hello.txt`; "hello"; Ctrl; Save) so it
creates a disk directory.
- Find that directory (e.g. .../minecraft/saves/WorldName/computercraft/computer/0).
- Get a terminal window there.
- Clone this repo into the turtle's disk directory.
- Get Aider installed and set up.
- Run Aider.

In Aider:

```aider
aider> /add tower.lua
aider> /read-only docs/*.md
aider> /read-only safe_stairs.lua
aider> Create a turtle script that takes two command line arguments, N and M,
and then builds a hollow M by M tower, N tall, with torches lighting the inside.
The provided save_stairs.lua is an example working turtle script. 
```
