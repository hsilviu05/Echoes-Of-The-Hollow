using Godot;

public partial class Player : CharacterBody2D
{
    [Export]
    public float Speed = 300.0f;
    
    [Export]
    public float JumpVelocity = -400.0f;

    // Get the gravity from the project settings to be synced with RigidBody nodes.
    public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

    private AnimatedSprite2D animatedSprite;

    public override void _Ready()
    {
        animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
    }

    public override void _PhysicsProcess(double delta)
    {
        Vector2 velocity = Velocity;

        // Add the gravity.
        if (!IsOnFloor())
            velocity.Y += gravity * (float)delta;

        // Handle jump.
        if (Input.IsActionJustPressed("jump") && IsOnFloor())
            velocity.Y = JumpVelocity;

        // Get the input direction and handle the movement/deceleration.
        Vector2 direction = Input.GetVector("move_left", "move_right", "move_up", "move_down");
        if (direction != Vector2.Zero)
        {
            velocity.X = direction.X * Speed;
            
            // Flip sprite based on movement direction
            if (animatedSprite != null)
            {
                animatedSprite.FlipH = direction.X < 0;
            }
        }
        else
        {
            velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
        }

        Velocity = velocity;
        MoveAndSlide();
        
        // Simple animation logic
        if (animatedSprite != null)
        {
            if (!IsOnFloor())
            {
                animatedSprite.Play("jump");
            }
            else if (Mathf.Abs(Velocity.X) > 5)
            {
                animatedSprite.Play("run");
            }
            else
            {
                animatedSprite.Play("idle");
            }
        }
    }
} 