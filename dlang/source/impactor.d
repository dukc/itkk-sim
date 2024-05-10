import godot, godot.node, godot.raycast3d, godot.rigidbody3d, godot.node3d;

class Impactor : GodotScript!RigidBody3D
{   RayCast3D ray;

    @Method void _ready()
    {   ray = memnew!RayCast3D;
        addChild(ray);
    }

    /+@Method _integrate_forces(Physics2DDirectBodyState state)
    {   //ray.to = state.velocity * deltaTime
    }+/
}
