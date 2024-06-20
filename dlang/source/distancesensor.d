import godot, godot.animationplayer, godot.engine, godot.inputevent, godot.node,
   godot.packedscene, godot.marker3d, godot.timer;

import std.conv : text;

class DistanceSensor : GodotScript!Node
{   @Signal @Rename("s_reportDistance") static void s_reportDistance(float dist);
    void reportDistance(float dist)
    {   emitSignal("s_reportDistance", dist);
    }

    @Method void measureDistance(Vector3 remotePoint)
    {   reportDistance((getParent.as!Node3D.position - remotePoint).length);
    }
}
