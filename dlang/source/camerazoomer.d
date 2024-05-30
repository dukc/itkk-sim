import godot, godot.animationplayer, godot.engine, godot.node,
   godot.packedscene, godot.marker3d, godot.timer;

class CameraZoomer : GodotScript!Node
{   @Property PackedFloat64Array choices;
    @Property size_t choiceI;

    @Signal @Rename("s_zoom") static void s_zoom(float r_arg);

    void zoom(float arg)
    {   emitSignal("s_zoom", arg);
    }

    @Method void _ready()
    {   if (Engine.isEditorHint()) return;
        zoom(choices[choiceI]);
    }

    @Method void _unhandled_input(InputEvent event)
    {   if(Engine.isEditorHint()) return;

        if(event.isActionPressed("zoom_in"))
        {   import std.algorithm;

            choiceI = min(choiceI+1, choices.length - 1);
            zoom(choices[choiceI]);
        }
        if(event.isActionPressed("zoom_out"))
        {   if(choiceI > 0) choiceI--;
            zoom(choices[choiceI]);
        }
    }
}
