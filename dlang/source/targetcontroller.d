import std.format : format;
import std.math : isNaN;
import godot, godot.rigidbody3d;
import missionresult;

class TargetController : GodotScript!Node
{
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
    {   debug import std.stdio;
        auto rigidbody = getNode("..").as!RigidBody3D;
        slot.targetNames[id] = String(format!"%s (Nop %dm/s Kork %dm)"
            (   getNode("..").name.toDStringName,
                cast(int) (rigidbody.linearVelocity.length + .5),
                cast(int) (rigidbody.position.z + .5)
            ));
        debug writeln(getNode("..").name.length);
    }
}
