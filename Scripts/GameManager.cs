using Godot;

public partial class GameManager : Node
{
    public static GameManager Instance { get; private set; }
    
    public override void _Ready()
    {
        Instance = this;
        GD.Print("GameManager initialized");
    }
    
    public override void _ExitTree()
    {
        Instance = null;
    }
} 