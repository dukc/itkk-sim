import godot, godot.engine, godot.node, godot.resourcepreloader;

class MainMenu : GodotScript!Control
{   @Method void _enter_tree()
    {   if (Engine.isEditorHint()) return;

        auto data = getNodeOrNull("./SceneSwitcher/Settings");

        if(data)
        {   auto output = getNode("./SceneSwitcher/Out");
            auto oldData = getNodeOrNull("./SceneSwitcher/Out/Settings");
            if(oldData)
            {   output.removeChild(oldData);
                oldData.queueFree();
            }

            getNode("./SceneSwitcher").removeChild(data);
            output.addChild(data);
        }
    }
}
