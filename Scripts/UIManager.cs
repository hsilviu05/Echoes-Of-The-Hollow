using Godot;

public partial class UIManager : CanvasLayer
{
    private Label healthLabel;
    private Label echoLabel;
    
    public override void _Ready()
    {
        // Try to find UI elements, but don't crash if they don't exist
        healthLabel = GetNodeOrNull<Label>("HealthLabel");
        echoLabel = GetNodeOrNull<Label>("EchoLabel");
        
        if (healthLabel != null)
            healthLabel.Text = "Health: 100";
        
        if (echoLabel != null)
            echoLabel.Text = "Echoes: 0";
    }
    
    public void UpdateHealth(int health)
    {
        if (healthLabel != null)
            healthLabel.Text = $"Health: {health}";
    }
    
    public void UpdateEchoes(int echoes)
    {
        if (echoLabel != null)
            echoLabel.Text = $"Echoes: {echoes}";
    }
} 