import godot, godot.engine, godot.object, godot.rigidbody3d;

import std.conv;

class Airdrag : GodotScript!Node
{   RigidBody3D piece;
    @Property @DefaultValue!(1) double strength;

    double dragYEffect = 0.0;
    double dragYVel = 0.0;

    @Method void _enter_tree()
    {   piece = getNode("..").as!RigidBody3D;
    }

    @Method void _physics_process(float delta)
    {   if (Engine.isEditorHint()) return;
        auto vel = piece.linearVelocity;
        piece.applyCentralForce(-vel * vel.length * strength);
    }
}

private alias PHint = Property.Hint;
