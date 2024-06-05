import godot, godot.subviewport, godot.engine, godot.node, godot.resourcepreloader;

import std.conv;

class SceneSwitcher : GodotScript!Node
{   @Method void _quit()
    {   // todo
    }

    @Method void _switchTo(StringName sceneName)
    {   if(auto mainScene = getNodeOrNull("/root/Main").as!ResourcePreloader)
        {   getParent.queueFree();
            getTree.root.addChild(mainScene.getResource(sceneName)
                .as!PackedScene.instantiate());

        } else
        {   print("seemingly this scene was run as the master scene, so quitting");
            _quit();
        }
    }
}
