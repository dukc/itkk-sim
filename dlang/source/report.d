import missionresult;
import godot, godot.control, godot.engine, godot.label, godot.node;

class Report : GodotScript!Control
{   //
    @Method void _enter_tree()
    {   import std.algorithm, std.array, std.conv;
        if (Engine.isEditorHint()) return;

        auto textNode = getNode("./Text").as!Label;
        auto data = getNode("./SceneSwitcher/Result").as!MissionResult;
        auto settings = getNode("./SceneSwitcher/Settings").as!MissionResult;

        Appender!string builder;

        builder ~= text("Laukauksia ammuttu: ", data.shotsFired, "\n");
        builder ~= "\nTarkkuus: ";

        if (data.shotsFired)
        {   auto hitQuotient = data.hits.sum * 1.0 / data.shotsFired;
            builder ~= text(cast(int) (hitQuotient * 100 + .05), ".",
                cast(int) ((hitQuotient + .0005) % .01 * 1000), "%\n");
        }

        builder ~= "\nOsumia eri maaleihin:\n";

        foreach(i; 0 .. data.targetNames.length)
        {   string step1 = text(data.targetNames[i]);
            builder ~= text("   ", step1, ": ", data.hits[i], "\n");
        }

        textNode.text = String(builder[]);

        getNode("./SceneSwitcher").removeChild(settings.as!Node);
        getNode("./SceneSwitcher/Out").addChild(settings.as!Node);
    }
}
