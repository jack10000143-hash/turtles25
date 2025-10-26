# Turtle API

Turtles are a robotic device, which can break and place blocks, attack mobs, and move about the world. They have an internal inventory of 16 slots, allowing them to store blocks they have broken or would like to place.

## Movement

Turtles are capable of moving through the world. As turtles are blocks themselves, they are confined to Minecraft's grid, moving a single block at a time.

`turtle.forward` and `turtle.back` move the turtle in the direction it is facing, while `turtle.up` and `turtle.down` move it up and down (as one might expect!). In order to move left or right, you first need to turn the turtle using `turtle.turnLeft`/`turtle.turnRight` and then move forward or backwards.

> **Info:** The name "turtle" comes from [Turtle graphics](https://en.wikipedia.org/wiki/Turtle_graphics), which originated from the Logo programming language. Here you'd move a turtle with various commands like "move 10" and "turn left", much like ComputerCraft's turtles!

Moving a turtle (though not turning it) consumes *fuel*. If a turtle does not have any fuel, it won't move, and the movement functions will return `false`. If your turtle isn't going anywhere, the first thing to check is if you've fuelled your turtle.

> **Tip:** Many turtle functions can fail in various ways. For instance, a turtle cannot move forward if there's already a block there. Instead of erroring, functions which can fail either return `true` if they succeed, or `false` and some error message if they fail. Unexpected failures can often lead to strange behaviour. It's often a good idea to check the return values of these functions, or wrap them in `assert` (for instance, use `assert(turtle.forward())` rather than `turtle.forward()`), so the program doesn't misbehave.

## Turtle Upgrades

While a normal turtle can move about the world and place blocks, its functionality is limited. Thankfully, turtles can be upgraded with upgrades. Turtles have two upgrade slots, one on the left and right sides. Upgrades can be equipped by crafting a turtle with the upgrade, or calling the `turtle.equipLeft`/`turtle.equipRight` functions.

By default, any diamond tool may be used as an upgrade (though more may be added with datapacks). The diamond pickaxe may be used to break blocks (with `turtle.dig`), while the sword can attack entities (`turtle.attack`). Other tools have more niche use-cases, for instance hoes can til dirt.

Some peripherals (namely speakers and Ender and Wireless modems) can also be equipped as upgrades. These are then accessible by accessing the "left" or "right" peripheral.

## Recipes

**Turtle**
- Iron Ingot x8 + Computer + Chest = Turtle

**Advanced Turtle**
- Gold Ingot x8 + Advanced Computer + Chest = Advanced Turtle

## API Functions

### craft([limit=64])
Craft a recipe based on the turtle's inventory.

The turtle's inventory should set up like a crafting grid. For instance, to craft sticks, slots 1 and 5 should contain planks. *All* other slots should be empty, including those outside the crafting "grid".

**Parameters:**
- `limit` (number, optional): The maximum number of crafting steps to run. Default is 64.

**Returns:**
- boolean: If crafting succeeds.
- OR false and string: If crafting fails, with a string describing why.

**Throws:**
- When limit is less than 1 or greater than 64.

### forward()
Move the turtle forward one block.

**Returns:**
- boolean: Whether the turtle could successfully move.
- string or nil: The reason the turtle could not move.

### back()
Move the turtle backwards one block.

**Returns:**
- boolean: Whether the turtle could successfully move.
- string or nil: The reason the turtle could not move.

### up()
Move the turtle up one block.

**Returns:**
- boolean: Whether the turtle could successfully move.
- string or nil: The reason the turtle could not move.

### down()
Move the turtle down one block.

**Returns:**
- boolean: Whether the turtle could successfully move.
- string or nil: The reason the turtle could not move.

### turnLeft()
Rotate the turtle 90 degrees to the left.

**Returns:**
- boolean: Whether the turtle could successfully turn.
- string or nil: The reason the turtle could not turn.

### turnRight()
Rotate the turtle 90 degrees to the right.

**Returns:**
- boolean: Whether the turtle could successfully turn.
- string or nil: The reason the turtle could not turn.

### dig([side])
Attempt to break the block in front of the turtle.

This requires a turtle tool capable of breaking the block. Diamond pickaxes (mining turtles) can break any vanilla block, but other tools (such as axes) are more limited.

**Parameters:**
- `side` (string, optional): The specific tool to use. Should be "left" or "right".

**Returns:**
- boolean: Whether a block was broken.
- string or nil: The reason no block was broken.

### digUp([side])
Attempt to break the block above the turtle. See `dig` for full details.

**Parameters:**
- `side` (string, optional): The specific tool to use.

**Returns:**
- boolean: Whether a block was broken.
- string or nil: The reason no block was broken.

### digDown([side])
Attempt to break the block below the turtle. See `dig` for full details.

**Parameters:**
- `side` (string, optional): The specific tool to use.

**Returns:**
- boolean: Whether a block was broken.
- string or nil: The reason no block was broken.

### place([text])
Place a block or item into the world in front of the turtle.

"Placing" an item allows it to interact with blocks and entities in front of the turtle. For instance, buckets can pick up and place down fluids, and wheat can be used to breed cows. However, you cannot use `place` to perform arbitrary block interactions, such as clicking buttons or flipping levers.

**Parameters:**
- `text` (string, optional): When placing a sign, set its contents to this text.

**Returns:**
- boolean: Whether the block could be placed.
- string or nil: The reason the block was not placed.

### placeUp([text])
Place a block or item into the world above the turtle.

**Parameters:**
- `text` (string, optional): When placing a sign, set its contents to this text.

**Returns:**
- boolean: Whether the block could be placed.
- string or nil: The reason the block was not placed.

### placeDown([text])
Place a block or item into the world below the turtle.

**Parameters:**
- `text` (string, optional): When placing a sign, set its contents to this text.

**Returns:**
- boolean: Whether the block could be placed.
- string or nil: The reason the block was not placed.

### drop([count])
Drop the currently selected stack into the inventory in front of the turtle, or as an item into the world if there is no inventory.

**Parameters:**
- `count` (number, optional): The number of items to drop. If not given, the entire stack will be dropped.

**Returns:**
- boolean: Whether items were dropped.
- string or nil: The reason the no items were dropped.

**Throws:**
- If dropping an invalid number of items.

### dropUp([count])
Drop the currently selected stack into the inventory above the turtle, or as an item into the world if there is no inventory.

**Parameters:**
- `count` (number, optional): The number of items to drop. If not given, the entire stack will be dropped.

**Returns:**
- boolean: Whether items were dropped.
- string or nil: The reason the no items were dropped.

**Throws:**
- If dropping an invalid number of items.

### dropDown([count])
Drop the currently selected stack into the inventory below the turtle, or as an item into the world if there is no inventory.

**Parameters:**
- `count` (number, optional): The number of items to drop. If not given, the entire stack will be dropped.

**Returns:**
- boolean: Whether items were dropped.
- string or nil: The reason the no items were dropped.

**Throws:**
- If dropping an invalid number of items.

### select(slot)
Change the currently selected slot.

The selected slot is determines what slot actions like `drop` or `getItemCount` act on.

**Parameters:**
- `slot` (number): The slot to select.

**Returns:**
- true: When the slot has been selected.

**Throws:**
- If the slot is out of range.

### getItemCount([slot])
Get the number of items in the given slot.

**Parameters:**
- `slot` (number, optional): The slot we wish to check. Defaults to the selected slot.

**Returns:**
- number: The number of items in this slot.

**Throws:**
- If the slot is out of range.

### getItemSpace([slot])
Get the remaining number of items which may be stored in this stack.

For instance, if a slot contains 13 blocks of dirt, it has room for another 51.

**Parameters:**
- `slot` (number, optional): The slot we wish to check. Defaults to the selected slot.

**Returns:**
- number: The space left in this slot.

**Throws:**
- If the slot is out of range.

### detect()
Check if there is a solid block in front of the turtle. In this case, solid refers to any non-air or liquid block.

**Returns:**
- boolean: If there is a solid block in front.

### detectUp()
Check if there is a solid block above the turtle. In this case, solid refers to any non-air or liquid block.

**Returns:**
- boolean: If there is a solid block above.

### detectDown()
Check if there is a solid block below the turtle. In this case, solid refers to any non-air or liquid block.

**Returns:**
- boolean: If there is a solid block below.

### compare()
Check if the block in front of the turtle is equal to the item in the currently selected slot.

**Returns:**
- boolean: If the block and item are equal.

### compareUp()
Check if the block above the turtle is equal to the item in the currently selected slot.

**Returns:**
- boolean: If the block and item are equal.

### compareDown()
Check if the block below the turtle is equal to the item in the currently selected slot.

**Returns:**
- boolean: If the block and item are equal.

### attack([side])
Attack the entity in front of the turtle.

**Parameters:**
- `side` (string, optional): The specific tool to use.

**Returns:**
- boolean: Whether an entity was attacked.
- string or nil: The reason nothing was attacked.

### attackUp([side])
Attack the entity above the turtle.

**Parameters:**
- `side` (string, optional): The specific tool to use.

**Returns:**
- boolean: Whether an entity was attacked.
- string or nil: The reason nothing was attacked.

### attackDown([side])
Attack the entity below the turtle.

**Parameters:**
- `side` (string, optional): The specific tool to use.

**Returns:**
- boolean: Whether an entity was attacked.
- string or nil: The reason nothing was attacked.

### suck([count])
Suck an item from the inventory in front of the turtle, or from an item floating in the world.

This will pull items into the first acceptable slot, starting at the currently selected one.

**Parameters:**
- `count` (number, optional): The number of items to suck. If not given, up to a stack of items will be picked up.

**Returns:**
- boolean: Whether items were picked up.
- string or nil: The reason the no items were picked up.

**Throws:**
- If given an invalid number of items.

### suckUp([count])
Suck an item from the inventory above the turtle, or from an item floating in the world.

**Parameters:**
- `count` (number, optional): The number of items to suck. If not given, up to a stack of items will be picked up.

**Returns:**
- boolean: Whether items were picked up.
- string or nil: The reason the no items were picked up.

**Throws:**
- If given an invalid number of items.

### suckDown([count])
Suck an item from the inventory below the turtle, or from an item floating in the world.

**Parameters:**
- `count` (number, optional): The number of items to suck. If not given, up to a stack of items will be picked up.

**Returns:**
- boolean: Whether items were picked up.
- string or nil: The reason the no items were picked up.

**Throws:**
- If given an invalid number of items.

### getFuelLevel()
Get the maximum amount of fuel this turtle currently holds.

**Returns:**
- number: The current amount of fuel a turtle this turtle has.
- OR "unlimited": If turtles do not consume fuel when moving.

### refuel([count])
Refuel this turtle.

While most actions a turtle can perform (such as digging or placing blocks) are free, moving consumes fuel from the turtle's internal buffer. If a turtle has no fuel, it will not move.

`refuel` refuels the turtle, consuming fuel items (such as coal or lava buckets) from the currently selected slot and converting them into energy. This finishes once the turtle is fully refuelled or all items have been consumed.

**Parameters:**
- `count` (number, optional): The maximum number of items to consume. One can pass `0` to check if an item is combustable or not.

**Returns:**
- true: If the turtle was refuelled.
- OR false and string: If the turtle was not refuelled, with the reason.

**Throws:**
- If the refuel count is out of range.

### compareTo(slot)
Compare the item in the currently selected slot to the item in another slot.

**Parameters:**
- `slot` (number): The slot to compare to.

**Returns:**
- boolean: If the two items are equal.

**Throws:**
- If the slot is out of range.

### transferTo(slot [, count])
Move an item from the selected slot to another one.

**Parameters:**
- `slot` (number): The slot to move this item to.
- `count` (number, optional): The maximum number of items to move.

**Returns:**
- boolean: If some items were successfully moved.

**Throws:**
- If the slot is out of range.
- If the number of items is out of range.

### getSelectedSlot()
Get the currently selected slot.

**Returns:**
- number: The current slot.

### getFuelLimit()
Get the maximum amount of fuel this turtle can hold.

By default, normal turtles have a limit of 20,000 and advanced turtles of 100,000.

**Returns:**
- number: The maximum amount of fuel a turtle can hold.
- OR "unlimited": If turtles do not consume fuel when moving.

### equipLeft()
Equip (or unequip) an item on the left side of this turtle.

This finds the item in the currently selected slot and attempts to equip it to the left side of the turtle. The previous upgrade is removed and placed into the turtle's inventory. If there is no item in the slot, the previous upgrade is removed, but no new one is equipped.

**Returns:**
- true: If the item was equipped.
- OR false and string: If we could not equip the item, with the reason.

### equipRight()
Equip (or unequip) an item on the right side of this turtle.

This finds the item in the currently selected slot and attempts to equip it to the right side of the turtle. The previous upgrade is removed and placed into the turtle's inventory. If there is no item in the slot, the previous upgrade is removed, but no new one is equipped.

**Returns:**
- true: If the item was equipped.
- OR false and string: If we could not equip the item, with the reason.

### getEquippedLeft()
Get the upgrade currently equipped on the left of the turtle.

This returns information about the currently equipped item, in the same form as `getItemDetail`.

**Returns:**
- table or nil: Information about the currently equipped item, or nil if no upgrade is equipped.

### getEquippedRight()
Get the upgrade currently equipped on the right of the turtle.

This returns information about the currently equipped item, in the same form as `getItemDetail`.

**Returns:**
- table or nil: Information about the currently equipped item, or nil if no upgrade is equipped.

### inspect()
Get information about the block in front of the turtle.

**Returns:**
- boolean: Whether there is a block in front of the turtle.
- table or string: Information about the block in front, or a message explaining that there is no block.

### inspectUp()
Get information about the block above the turtle.

**Returns:**
- boolean: Whether there is a block above the turtle.
- table or string: Information about the above below, or a message explaining that there is no block.

### inspectDown()
Get information about the block below the turtle.

**Returns:**
- boolean: Whether there is a block below the turtle.
- table or string: Information about the block below, or a message explaining that there is no block.

### getItemDetail([slot [, detailed]])
Get detailed information about the items in the given slot.

**Parameters:**
- `slot` (number, optional): The slot to get information about. Defaults to the selected slot.
- `detailed` (boolean, optional): Whether to include "detailed" information. When true the method will contain much more information about the item at the cost of taking longer to run.

**Returns:**
- nil or table: Information about the item in this slot, or nil if it is empty.

**Throws:**
- If the slot is out of range.
