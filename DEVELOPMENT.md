# Development Guide - Echoes of the Hollow

This guide explains how to extend and modify the game systems for developers who want to contribute or customize the game.

## 🏗️ Architecture Overview

The game follows a modular architecture with clear separation of concerns:

### Core Systems
- **GameManager**: Central singleton managing game state, saves, and cross-system communication
- **Player**: Character controller with transformation system
- **Enemy**: Base class for all enemy types with extensible AI
- **Echo**: Collectible system with memory/ability unlocking
- **UIManager**: All user interface interactions and feedback

## 🔧 Adding New Content

### Creating New Enemy Types

1. **Inherit from Enemy base class:**
```csharp
public class NewEnemyType : Enemy
{
    public override void _Ready()
    {
        // Set specific stats
        MaxHealth = 120;
        AttackDamage = 25;
        Speed = 60f;
        EnemyType = EnemyType.NewType; // Add to enum first
        
        base._Ready();
    }
}
```

2. **Override behavior methods:**
```csharp
protected override void UpdateState()
{
    // Add custom AI logic here
    if (_currentState == EnemyState.Chasing && HasSpecialCondition())
    {
        PerformSpecialAbility();
        return;
    }
    
    base.UpdateState(); // Call parent behavior
}
```

3. **Create enemy scene** with proper collision layers and attach script

### Adding New Echo Types

1. **Add to EchoType enum** in `GameEnums.cs`
2. **Update GameManager** to include new echoes in `InitializeEchoes()`
3. **Create echo data:**
```csharp
new EchoData
{
    Id = "unique_echo_id",
    Name = "Echo Name",
    Description = "What this echo represents",
    Type = EchoType.NewType,
    MemoryFragment = "Quote or memory text...",
    WorldPosition = new Vector2(x, y),
    UnlockedAbilities = new string[] { "new_ability" }
}
```

### Creating New Player Abilities

1. **Add ability check** in Player.cs:
```csharp
private bool HasAbility(string abilityName)
{
    return _unlockedAbilities.ContainsKey(abilityName) && 
           _unlockedAbilities[abilityName];
}
```

2. **Implement ability method:**
```csharp
public void NewAbility()
{
    if (!HasAbility("new_ability")) return;
    
    // Implement ability logic
    PlaySound("new_ability");
}
```

3. **Add input handling** if needed in `HandleInput()`

### Designing New Levels

1. **Create new scene** inheriting from Node2D
2. **Add essential nodes:**
   - Environment (TileMap, platforms, decorations)
   - Echoes (place Echo instances with unique IDs)
   - Enemies (instance enemy scenes)
   - SpawnPoints (Player spawn location)
   - RegionTransitions (Areas leading to other levels)

3. **Configure collision layers:**
   - Layer 1: Player
   - Layer 2: Enemies  
   - Layer 3: World/Platforms
   - Layer 4: Echoes
   - Layer 5: Items

## 🎨 Art Integration

### Sprite Requirements
- **Player sprites**: 32x32, separate files for each transformation stage
- **Enemy sprites**: 32x32, include all animation states
- **Echo sprites**: 24x24, with glow/particle effects
- **Environment tiles**: 32x32, tileable patterns

### Animation Setup
1. Create SpriteFrames resource
2. Add animations: idle, walk/run, attack, special abilities
3. Set appropriate speeds (idle: 3-5fps, action: 8-15fps)
4. Configure looping for continuous animations

### Particle Effects
```csharp
// Configure particles for different echo types
var material = _particles.ProcessMaterial as ParticlesMaterial;
material.Color = typeColor;
material.EmissionRate = intensity;
material.Lifetime = duration;
```

## 🔊 Audio System

### Sound Categories
- **Player Actions**: footsteps, attacks, transformation sounds
- **Enemy Behaviors**: alerts, attacks, death sounds  
- **Environment**: ambient sounds, echo collection chimes
- **UI**: menu sounds, notifications

### Implementation Pattern
```csharp
private void PlaySound(string soundName)
{
    // Load appropriate sound file based on context
    var audioFile = $"res://Audio/{category}/{soundName}.ogg";
    _audioPlayer.Stream = GD.Load<AudioStream>(audioFile);
    _audioPlayer.Play();
}
```

## 💾 Save System Extension

### Adding New Save Data
1. **Extend GameSaveData class:**
```csharp
public class GameSaveData
{
    // ... existing properties
    public YourNewData[] NewDataArray { get; set; }
    public string[] NewStringArray { get; set; }
}
```

2. **Update save/load logic** in GameManager
3. **Handle backward compatibility** for older save files

### Custom Serialization
For complex data, implement custom JSON converters:
```csharp
[JsonConverter(typeof(CustomDataConverter))]
public CustomData ComplexData { get; set; }
```

## 🎮 Gameplay Balancing

### Transformation Progression
- **Skeleton (0-4 echoes)**: Fast, fragile, basic attacks
- **Muscle (5-9 echoes)**: Stronger, moderate speed, heavy attacks  
- **Flesh (10-14 echoes)**: Balanced, tool usage, social interaction
- **Human (15+ echoes)**: Weakest physically, full abilities, puzzle solving

### Enemy Scaling
Enemies should adapt to player progression:
```csharp
private void AdjustToPlayerStage(TransformationStage playerStage)
{
    switch (playerStage)
    {
        case TransformationStage.Skeleton:
            // Easier AI, lower damage
            break;
        case TransformationStage.Human:
            // More aggressive, higher damage
            break;
    }
}
```

## 🐛 Debugging Tools

### Debug Commands
Add to GameManager for testing:
```csharp
public override void _Input(InputEvent @event)
{
    if (OS.IsDebugBuild())
    {
        if (@event.IsActionPressed("debug_give_echo"))
        {
            CollectEcho("debug_echo_id");
        }
        
        if (@event.IsActionPressed("debug_transform"))
        {
            TransformPlayer(TransformationStage.Human);
        }
    }
}
```

### Performance Monitoring
- Monitor echo collection frequency
- Track enemy spawn/despawn rates  
- Watch for memory leaks in particle systems
- Profile physics collision detection

## 📋 Code Style Guidelines

### Naming Conventions
- **Classes**: PascalCase (`PlayerController`)
- **Methods**: PascalCase (`HandleInput`)  
- **Variables**: camelCase (`_currentHealth`)
- **Constants**: UPPER_CASE (`MAX_ECHOES`)
- **Signals**: PascalCase (`EchoCollected`)

### File Organization
```
Scripts/
├── Core/          # Core systems (GameManager, etc.)
├── Player/        # Player-related scripts
├── Enemies/       # All enemy types
├── Items/         # Collectibles and interactive objects
├── UI/            # User interface scripts
└── Utilities/     # Helper classes and extensions
```

### Documentation
- Use XML comments for public methods
- Add [Signal] and [Export] attributes with descriptions
- Include usage examples for complex systems

## 🚀 Performance Optimization

### Best Practices
1. **Pool objects** instead of frequent instantiation
2. **Use groups** for efficient node queries
3. **Limit particle counts** in dense areas
4. **Optimize collision shapes** (prefer rectangles over complex polygons)
5. **Cache frequently accessed nodes** in _Ready()

### Memory Management
```csharp
// Good: Cache references
private Player _player;
public override void _Ready()
{
    _player = GetTree().GetFirstNodeInGroup("player") as Player;
}

// Bad: Search every frame
public override void _PhysicsProcess(float delta)
{
    var player = GetTree().GetFirstNodeInGroup("player") as Player;
}
```

This architecture provides a solid foundation for expanding "Echoes of the Hollow" into a full-featured Metroidvania experience! 