using Godot;

public partial class Echo : Area2D
{
	[Export]
	public string EchoId = "default_echo";
	
	private AnimatedSprite2D animatedSprite;
	private CollisionShape2D collisionShape;
	private bool isCollected = false;

	public override void _Ready()
	{
		animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		collisionShape = GetNode<CollisionShape2D>("CollisionShape2D");
		
		// Connect the area entered signal
		BodyEntered += OnBodyEntered;
	}

	public override void _PhysicsProcess(double delta)
	{
		if (isCollected) return;
		
		// Simple floating animation
		Position = new Vector2(Position.X, Position.Y + Mathf.Sin((float)Time.GetUnixTimeFromSystem() * 2.0f) * 0.5f);
	}

	private void OnBodyEntered(Node2D body)
	{
		if (isCollected) return;
		
		if (body.Name.ToString().ToLower().Contains("player"))
		{
			CollectEcho();
		}
	}
	
	private void CollectEcho()
	{
		if (isCollected) return;
		
		isCollected = true;
		
		GD.Print($"Collected echo: {EchoId}");
		
		// Simple collection effect
		var tween = CreateTween();
		tween.TweenProperty(this, "scale", Vector2.Zero, 0.3f);
		tween.TweenCallback(Callable.From(() => QueueFree()));
	}
} 
