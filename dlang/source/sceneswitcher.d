import godot, godot.subviewport, godot.engine, godot.node, godot.resourcepreloader;

import std.algorithm, std.conv;

class SceneSwitcher : GodotScript!Node
{   @Method void _quit()
    {   getTree.quit(0);
    }

    @Method void _switchTo(StringName sceneName)
    {   if(auto mainScene = getNodeOrNull("/root/Main").as!ResourcePreloader)
        {   getParent.queueFree();
            auto newScene = mainScene.getResource(sceneName)
                .as!PackedScene.instantiate();

            auto receiver = newScene.getNode("SceneSwitcher");
            if(auto outNode = getNodeOrNull("Out"))
                foreach(output; outNode.getChildren.map!(mem => mem.as!Node))
            {   outNode.removeChild(output);
                receiver.addChild(output);
                output.owner = newScene.owner? newScene.owner: newScene;
            }
            getTree.root.addChild(newScene);
        } else
        {   print("seemingly this scene was run as the master scene, so quitting");
            _quit();
        }
    }
}
