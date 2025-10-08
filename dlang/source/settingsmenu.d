import missionsettings;
import godot, godot.control, godot.engine, godot.label, godot.node, godot.range;

class SettingsMenu : GodotScript!Control
{   import std.algorithm, std.array, std.conv;

    @Method void _enter_tree()
    {   if (Engine.isEditorHint()) return;

        auto data = getNodeOrNull("./SceneSwitcher/Settings");

        if(data) replaceResultWith(data);
        else replaceResultWith(getNode("./DefaultSettings"));
    }

    void replaceResultWith(Node newRes)
    {   newRes = newRes.duplicate();

        auto switcherOut = getNode("./SceneSwitcher/Out");
        auto oldData = getNodeOrNull("./SceneSwitcher/Out/Settings");
        if (oldData)
        {   switcherOut.removeChild(oldData);
            oldData.queueFree();
        }

        if(auto oldParent = newRes.getParent()) oldParent.removeChild(newRes);
        newRes.name = String("Settings");
        switcherOut.addChild(newRes);

        updateUI();
    }

    @Method void resetDefaults()
    {   replaceResultWith(getNode("./DefaultSettings"));
    }

    @Method void updateUI()
    {   auto data = getNodeOrNull("./SceneSwitcher/Out/Settings").as!MissionSettingsNode;
        getNode("BeltLengthSetter").as!Range.value = data.beltLength;
        getNode("BeltLengthLabel").as!Label.text = text(data.beltLength).String;
        getNode("EnemySpeedSetter").as!Range.value = data.enemySpeedFactor;
        getNode("EnemySpeedLabel").as!Label.text = text(data.enemySpeedFactor * 100, "%").String;
    }

    @Method void setBeltLength()
    {   getNode("./SceneSwitcher/Out/Settings").as!MissionSettingsNode.beltLength
            = cast(int) getNode("BeltLengthSetter").as!Range.value;
        updateUI();
    }
    @Method void setEnemySpeedFactor()
    {   getNode("./SceneSwitcher/Out/Settings").as!MissionSettingsNode.enemySpeedFactor
            = getNode("EnemySpeedSetter").as!Range.value;
        updateUI();
    }
}
