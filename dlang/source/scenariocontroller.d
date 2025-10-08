import godot, godot.engine, godot.node;
import missionresult, missionsettings, pistol, targetcontroller, util;

import std.conv : text;

class ScenarioController : GodotScript!Node
{   @Property Pistol gun;
    // TypedArray ei toimi @Propertynä tällä hetkellä
    @Property PackedStringArray targets;

    @Method void _ready()
    {   import godot.resourceloader;
        if (Engine.isEditorHint) return;

        auto receiver = getNode("../SceneSwitcher");
        auto outNode = receiver.getNode("Out/Result").as!MissionResult;
        outNode.initArrays(targets.length);

        float speedFactor = 1.0f;
        if(auto inNode = receiver.getNodeOrNull("Settings"))
        {   auto settings = inNode.as!MissionSettingsNode;
            gun.ammoSpace = settings.beltLength;
            speedFactor = settings.enemySpeedFactor;
            receiver.removeChild(inNode);
            receiver.getNode("Out").addChild(inNode);
        }

        foreach(i; 0 .. targets.length)
        {   auto path = targets.ix(i).text;
            auto controllerNode = getNodeOrNull(path);
            if (!controllerNode)
            {
                printerr(text(path, " not found!"));
                continue;
            }
            auto controller = controllerNode.as!TargetController;
            outNode.targets[i] = controller;
            controller.set(speedFactor);
        }

        outNode.connectToTargets();
    }
}
