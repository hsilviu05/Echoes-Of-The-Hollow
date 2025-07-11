using Godot;

public partial class CorruptedBot : Enemy
{
    [Export]
    public float PatrolDistance = 100.0f;
    
    private Vector2 startPosition;
    private bool movingRight = true;
    
    public override void _Ready()
    {
        base._Ready();
        startPosition = GlobalPosition;
    }
    
    public override void _PhysicsProcess(double delta)
    {
        // Simple patrol movement
        if (movingRight)
        {
            Velocity = new Vector2(Speed, Velocity.Y);
            if (GlobalPosition.X > startPosition.X + PatrolDistance)
            {
                movingRight = false;
                if (animatedSprite != null)
                    animatedSprite.FlipH = true;
            }
        }
        else
        {
            Velocity = new Vector2(-Speed, Velocity.Y);
            if (GlobalPosition.X < startPosition.X - PatrolDistance)
            {
                movingRight = true;
                if (animatedSprite != null)
                    animatedSprite.FlipH = false;
            }
        }
        
        // Add gravity
        if (!IsOnFloor())
        {
            Velocity = new Vector2(Velocity.X, Velocity.Y + 980.0f * (float)delta);
        }
        
        MoveAndSlide();
    }
} 