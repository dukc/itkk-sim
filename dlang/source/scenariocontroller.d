import godot, godot.engine, godot.node;
import missionsettings, pistol;

import std.conv : text;

class ScenarioController : GodotScript!Node
{   @Property Pistol gun;

    @Method void _ready()
    {   import godot.resourceloader;
        if (Engine.isEditorHint()) return;

        auto receiver = getNode("../SceneSwitcher");
        if(auto inNode = receiver.getNodeOrNull("In"))
        {   auto settings = inNode.as!MissionSettingsNode;
            gun.ammoSpace = settings.beltLength;
        }

    }
}
