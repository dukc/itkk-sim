import godot, godot.animationplayer, godot.engine, godot.inputevent, godot.node,
   godot.packedscene, godot.marker3d, godot.timer;

import std.conv : text;

class GPS : GodotScript!Node
{   @Signal @Rename("s_reportPosition") static void s_ReportPosition(Vector3 pos);
    void reportPosition(Vector3 pos)
    {   emitSignal("s_reportPosition", pos);
    }

    @Method void _physics_process(float delta)
    {   if (Engine.isEditorHint()) return;
        reportPosition(getParent.as!Node3D.position);
    }
}
