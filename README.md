# Echoes of the Hollow

A 2D pixel art Metroidvania game built with Godot and C#. Play as "Remn", a conscious skeleton who must collect Echoes to gradually transform back into human form.

## 🎮 Game Overview

You are **Remn**, a conscious skeleton reanimated by a mysterious energy called **The Hollow**. The world has ended, but something lingers — **Echoes**, fragments of memories from long-lost humans. The more you collect, the more you remember... and the more human you become.

### 🌟 Core Features

- **Transformation System**: Evolve through 4 stages (Skeleton → Muscle → Flesh → Human)
- **Echo Collection**: Gather memory fragments to unlock abilities and progress
- **Metroidvania Gameplay**: Explore interconnected world regions with progression-gated areas
- **Combat System**: Fight corrupted enemies with stage-appropriate abilities
- **Memory-Based Narrative**: Uncover the story through collected echoes

### 🎯 Transformation Stages

| Stage | Description | Abilities | Limitations |
|-------|------------|-----------|-------------|
| 🦴 **Skeleton** | Starting state | Light & fast, enhanced jumping | Fragile, can't use tools, no dialogue |
| 💪 **Muscle** | Mid-evolution | Melee damage, push heavy objects | Vulnerable to cold environments |
| 🩹 **Flesh** | Near-human | Use tools, communicate with NPCs | Slower movement |
| 🧠 **Human** | Final form | Hack terminals, full empathy, complete dialogue | Physically weaker |

### 🗺️ World Regions

1. **🌲 Wistwood Grove**: Overgrown forest, home to feral spirits
2. **🏢 Rustline City**: Ruined urban sprawl, broken technology everywhere
3. **🌊 Floodspire**: Sunken laboratories with underwater segments
4. **🌋 Ashvale Crater**: Molten biome filled with failed reanimations
5. **🧬 Seedvault-0**: Final location with AI puzzles and the cryopod

## 🛠️ Technical Setup

### Prerequisites

- **Godot 3.5+** with Mono/C# support
- **.NET Framework 4.7.2** or higher
- **Visual Studio** or **VS Code** (recommended for C# development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/EchoesOfTheHollow.git
   cd EchoesOfTheHollow
   ```

2. **Open in Godot:**
   - Open Godot
   - Click "Import" and select the `project.godot` file
   - Allow Godot to import and build the C# project

3. **Install NuGet Dependencies:**
   ```bash
   # If using command line
   nuget restore
   ```
   Or let Visual Studio/Godot handle it automatically.

4. **Run the game:**
   - Press F5 in Godot or click the Play button
   - Use the test level to explore the mechanics

## 🎮 Controls

| Action | Key | Description |
|--------|-----|-------------|
| Move | WASD / Arrow Keys | Move left/right, climb |
| Jump | Space | Jump (enhanced in Skeleton form) |
| Attack | Z | Melee attack (varies by form) |
| Roll | X | Dodge roll with i-frames |
| Interact | E | Examine echoes, use objects |
| Pause | ESC | Open pause menu |

## 🏗️ Project Structure

```
EchoesOfTheHollow/
├── Scripts/           # C# gameplay scripts
│   ├── GameManager.cs    # Central game state management
│   ├── Player.cs         # Player controller and mechanics
│   ├── Enemy.cs         # Base enemy AI system
│   ├── Echo.cs          # Collectible memory fragments
│   └── UIManager.cs     # User interface management
├── Scenes/            # Godot scene files
│   ├── Main.tscn        # Main game scene
│   ├── Player.tscn      # Player character setup
│   ├── Echo.tscn        # Echo collectible prefab
│   └── TestLevel.tscn   # Demo level for testing
├── Sprites/           # Placeholder sprite files
├── Audio/             # Sound effects and music
├── Maps/              # Level design files
└── UI/                # User interface assets
```

## 🔧 Key Systems

### Game Manager
- **Save/Load System**: JSON-based progression saving
- **Echo Management**: Tracks collected memories and unlocked abilities
- **Transformation Logic**: Handles player evolution between stages

### Player Controller
- **Advanced Movement**: Jump buffering, coyote time, wall jumping
- **Combat System**: Stage-appropriate attacks and abilities
- **Transformation Visuals**: Dynamic sprite changing based on current form

### Echo System
- **Interactive Collection**: Two-step interaction (examine, then collect)
- **Memory Fragments**: Voiced/text narrative snippets
- **Ability Unlocking**: Progression-based skill acquisition

### Enemy AI
- **State Machine**: Patrol, Chase, Attack, Stunned states
- **Specialized Behaviors**: Each enemy type has unique abilities
- **Dynamic Difficulty**: Enemies adapt to player's current stage

## 🎨 Art Style

- **32x32 Pixel Art**: Consistent tile-based visuals
- **Muted Palette**: Post-apocalyptic desaturated colors
- **Dynamic Weather**: Fog, ash, acid rain effects
- **Transformation Feedback**: Visual evolution of player character

## 📝 Development Notes

### Current Status
- ✅ Core player movement and combat
- ✅ Echo collection and transformation system
- ✅ Basic enemy AI and behaviors
- ✅ Save/load functionality
- ✅ UI and menu systems
- 🔄 Level design and world building
- 🔄 Audio implementation
- 🔄 Sprite art creation

### Future Enhancements
- **Full Sprite Art**: Replace placeholder sprites with proper pixel art
- **Audio System**: Ambient music and sound effects
- **Advanced Enemies**: More enemy types with unique behaviors
- **World Expansion**: Complete all 5 regions with unique mechanics
- **Narrative System**: Full dialogue and cutscene implementation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Godot Engine**: Amazing open-source game engine
- **Metroidvania Community**: Inspiration for game design
- **Pixel Art Community**: Art style references and techniques

---

*"In the ruins of tomorrow, memories are the only currency that matters."* 