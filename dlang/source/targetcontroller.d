import std.format : format;
import std.math : isNaN;
import godot, godot.rigidbody3d;
import missionresult;
debug import std.stdio;

class TargetController : GodotScript!Node
{
    // Käyttäisin emosolmun nimeä mutta ilmaisesti jokin Godotin tai
    // Godot-dlanging bugi saa aikaan sen että tulee aina tyhjä merkkijono kun
    // lukee sen (getNode("..").name.toDStringName)
    @Property String name;
    // MissionResult joka jäljittää tätä maalia.
    MissionResult slot;
    uint id = uint.max;
    float speedFactor;

    @Method void set(float speedFactor)
    in(this.speedFactor.isNaN || this.speedFactor == speedFactor, "nopeustekijän saa asettaa vain kerran")
    {   auto rigidBody = getNode("..").as!RigidBody3D;
        if(this.speedFactor.isNaN)
        {   rigidBody.linearVelocity = rigidBody.linearVelocity * speedFactor;
            this.speedFactor = speedFactor;
        }

        if(slot) updateSlot();
    }

    @Method void connectResult(MissionResult mr, uint id)
    {   this.slot = mr;
        this.id = id;
        if(!speedFactor.isNaN) updateSlot();
    }

    void updateSlot()
    {   auto rigidbody = getNode("..").as!RigidBody3D;
        slot.targetNames[id] = String(format!"%s (Nop %dm/s Kork %dm)"
            (   name.toDString,
                cast(int) (rigidbody.linearVelocity.length + .5),
                cast(int) (rigidbody.position.z + .5)
            ));
    }
}
