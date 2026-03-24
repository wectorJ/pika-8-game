# Pika-8 Game Demo

A demonstration project showcasing the [Pika-8](https://github.com/GarniyHlopchik/pika-8) game engine.

## Description

This is a simple game created using the Pika-8 engine. The project demonstrates the core features of the engine:
- Sprite rendering
- User input handling
- Audio playback
- Lua scripting
- Entity-Component system

## Requirements

- CMake 4.0.0 or higher
- C++17 compatible compiler
- Git

## Building the Project

```bash
rm -f CMakeCache.txt
cmake -G "MinGW Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -S . -B build
cmake --build build
```

### Cloning

```bash
git clone --recursive https://github.com/wectorJ/pika-8-game.git
cd pika-8-game
```

If you already cloned the repository without `--recursive`, initialize submodules:

```bash
git submodule update --init --recursive
```

### Running

After building, the executable `pika-8.exe` will be in the project root:

```bash
./pika-8.exe
```

## Project Structure

```
pika-8-game/
├── pika-8-engine/      # Engine submodule (library)
├── scripts/            # Lua game scripts
│   ├── _rungame/       # Main game loop
│   ├── enemy/          # Enemy logic
│   └── libs/           # Helper libraries
├── assets/             # Resources (sprites, sounds, fonts)
├── config.json         # Window and resource configuration
└── CMakeLists.txt      # Build configuration
```

## Usage Examples

### 1. Initialization and Game Loop

```lua
function _init()
    -- Load sprite
    spr = GFX.load("assets/sprites/player/player.png")
    
    -- Load sound
    sound = SFX.load("assets/sounds/pipe.mp3")
    SFX.play(sound)
    
    player_pos = {x = 64, y = 64}
end

function _update(delta)
    -- Clear screen
    GFX.cls()
    
    -- Draw sprite
    GFX.spr(spr, player_pos.x, player_pos.y, 64, 64)
end
```

### 2. Input Handling

```lua
-- Keys: KEY_RIGHT=262, KEY_LEFT=263, KEY_DOWN=264, KEY_UP=265
-- Or: W=87, A=65, S=83, D=68

if Input.btnp(262) or Input.btnp(68) then  -- Right or D
    player_pos.x = player_pos.x + speed * delta
end

if Input.btnp(263) or Input.btnp(65) then  -- Left or A
    player_pos.x = player_pos.x - speed * delta
end
```

### 3. Text Rendering

```lua
GFX.text("Score: " .. score, 10, 30, 2, "default", 0.4)
```

Parameters:
- Text string
- X, Y coordinates
- Size
- Font name (from config.json)
- Scale

### 4. Working with Sprites

```lua
-- Load
sprite = GFX.load("assets/sprites/enemy.png")

-- Draw
GFX.spr(sprite, x, y, width, height)
```

### 5. Audio

```lua
-- Load
sound = SFX.load("assets/sounds/effect.mp3")

-- Play
SFX.play(sound)
```

### 6. Using Vectors (Vec2)

```lua
local Vec2 = require("scripts.libs.vec2")

local position = Vec2:new(100, 200)
local direction = Vec2.RIGHT  -- Predefined constants
local velocity = direction:normalize() * speed

position = position + velocity * delta
```

## Configuration (config.json)

```json
{
    "window_title": "My Game",
    "window_width": 640,
    "window_height": 480,
    "lua_script": "scripts/_rungame/main.lua",
    "fonts": [
        {
            "name": "default",
            "font_texture": "assets/fonts/default_font.png",
            "char_width": 8,
            "char_height": 8,
            "charset": " !\"#$%&'()*+,-./0123456789..."
        }
    ]
}
```

## Engine Features

- **Lua scripting**: All game logic written in Lua
- **OpenGL rendering**: Via GLFW and GLAD
- **Minimalist**: Lightweight engine for 2D games
- **Extensible**: Simple architecture for adding features

## Pika-8 Engine API

### GFX Module (Graphics)
- `GFX.load(path)` - load a sprite
- `GFX.spr(sprite, x, y, w, h)` - draw a sprite
- `GFX.text(text, x, y, size, font, scale)` - draw text
- `GFX.cls()` - clear screen

### SFX Module (Audio)
- `SFX.load(path)` - load a sound
- `SFX.play(sound)` - play sound

### Input Module
- `Input.btnp(key)` - check if key is pressed

### Required Functions
- `_init()` - called on startup
- `_update(delta)` - called every frame

## License

MIT License. See [LICENSE](LICENSE) file for details.

## Author

GarniyHlopchik, KotiasFeet, wectorJ
