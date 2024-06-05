import godot, godot.animationplayer, godot.engine,
    godot.input, godot.inputevent, godot.node;

class MouseCapturer : GodotScript!Node
{   bool _inputCaptured = false;

    @safe inputCaptured() => _inputCaptured;
    auto inputCaptured(bool b)
    {   _inputCaptured = b;
        Input.setMouseMode(b? Input.MouseMode.mouseModeCaptured:
            Input.MouseMode.mouseModeVisible);
    }

    @Method void _input(InputEvent event)
    {   if(Engine.isEditorHint()) return;

        if(event.isActionPressed("ui_accept")) inputCaptured = true;
        if(event.isActionPressed("ui_cancel")) inputCaptured = false;
    }
}
