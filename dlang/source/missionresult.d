import godot, godot.engine, godot.node;

class MissionResult : GodotScript!Node
{   alias owner this;
    @Property PackedStringArray targetNames;
    int shotsFired = 0;
    int[] hits;

    @Method void _ready()
    {   if (Engine.isEditorHint()) return;
        hits = new int[](targetNames.length);
    }

    @safe @Method void registerShot()
    {   shotsFired++;
    }

    @Method registerHit(Variant unused, long targetI)
    {   import std.conv;
        if(targetI >= 0 && targetI < hits.length)
        {   hits[targetI]++;
            return;
        }
        printerr(text("Target index ", targetI, "out of bounds!"));
    }
}
