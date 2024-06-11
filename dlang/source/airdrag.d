import godot, godot.engine, godot.object, godot.rigidbody3d;

import std.conv;

class Airdrag : GodotScript!Node
{   RigidBody3D piece;
    @Property @DefaultValue!(100) float transsonicSpeed;
    @Property @DefaultValue!(2) float transsonicFactor;
    @Property @DefaultValue!(1) float strengthMil;
    @Property @DefaultValue!(1) float altitudeEffectPerKm;

    double dragYEffect = 0.0;
    double dragYVel = 0.0;

    @Method void _enter_tree()
    {   piece = getNode("..").as!RigidBody3D;
    }

    @Method void _physics_process(float delta)
    {   if (Engine.isEditorHint()) return;
        auto vel = piece.linearVelocity;
        auto spd = vel.length;
        piece.applyCentralForce(
            -vel * spd * (strengthMil * .001) *
            (spd > transsonicSpeed? transsonicFactor: 1) *
            altitudeEffectPerKm ^^ (piece.position.z / 1000)
        );
    }
}

private alias PHint = Property.Hint;
