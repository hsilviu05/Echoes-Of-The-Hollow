using System;
using Godot;

namespace EchoesOfTheHollow
{
    public enum TransformationStage
    {
        Skeleton3D,
        Muscle,
        Flesh,
        Human
    }

    public enum EchoType
    {
        Memory,
        Skill,
        Lore,
        WorldRestore
    }

    public enum WeaponType
    {
        None,
        BoneBlade,
        RebarHammer,
        Slingshot,
        Sparkgun
    }

    public enum EnemyType
    {
        CorruptedBot,
        ShadowBeast,
        DefenseSystem,
        WraithbornGuardian
    }

    public enum WorldRegion
    {
        WistwoodGrove,
        RustlineCity,
        Floodspire,
        AshvaleCrater,
        SeedvaultZero
    }

    [Serializable]
    public partial class EchoData
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public EchoType Type { get; set; }
        public string MemoryFragment { get; set; }
        public Vector2 WorldPosition { get; set; }
        public bool IsCollected { get; set; }
        public string[] UnlockedAbilities { get; set; }
    }

    [Serializable]
    public partial class PlayerStats
    {
        public TransformationStage CurrentStage { get; set; }
        public int EchoesCollected { get; set; }
        public int Health { get; set; }
        public int MaxHealth { get; set; }
        public float Speed { get; set; }
        public float JumpPower { get; set; }
        public int AttackDamage { get; set; }
        public WeaponType CurrentWeapon { get; set; }
        public string[] UnlockedAbilities { get; set; }
    }

    [Serializable]
    public partial class GameSaveData
    {
        public PlayerStats PlayerStats { get; set; }
        public EchoData[] CollectedEchoes { get; set; }
        public Vector2 PlayerPosition { get; set; }
        public WorldRegion CurrentRegion { get; set; }
        public string[] CompletedQuests { get; set; }
        public string[] UnlockedRegions { get; set; }
    }
} 