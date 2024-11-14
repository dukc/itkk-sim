import godot, godot.engine, godot.node, godot.resourcepreloader;

class MainMenu : GodotScript!Control
{   @Method void _enter_tree()
    {   if (Engine.isEditorHint()) return;

        auto data = getNodeOrNull("./SceneSwitcher/In");

        if(data)
        {   auto switcher = getNode("./SceneSwitcher");
            auto oldData = getNodeOrNull("./SceneSwitcher/Out");
            if(oldData)
            {   switcher.removeChild(oldData);
                oldData.queueFree();
            }

            data.name = String("Out");
        }
    }
}
