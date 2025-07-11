using Godot;

public partial class Enemy : CharacterBody2D
{
    [Export]
    public float Speed = 100.0f;
    
    [Export]
    public int Health = 100;
    
    protected AnimatedSprite2D animatedSprite;
    
    public override void _Ready()
    {
        animatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
    }
    
    public virtual void TakeDamage(int damage)
    {
        Health -= damage;
        GD.Print($"Enemy took {damage} damage. Health: {Health}");
        
        if (Health <= 0)
        {
            Die();
        }
    }
    
    protected virtual void Die()
    {
        GD.Print("Enemy died");
        QueueFree();
    }
} 