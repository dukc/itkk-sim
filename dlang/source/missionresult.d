import std.algorithm, std.conv, std.range;
import godot, godot.engine, godot.node, godot.rigidbody3d;
import targetcontroller, util;

class MissionResult : GodotScript!Node
{   TargetController[] targets;
    String[] targetNames;
    int shotsFired = 0;
    int[] hits;

    // Koska roskienkeruu ei muuten löydä hits-taulua!
    static const(void)[][] GCroot;

    void initArrays(size_t len)
    {   hits = new int[](len);
        targets = new TargetController[](len);
        targetNames = new String[](len);
        // Tarkoituksellinen muistivuoto - Yäk! Silti mitättömän pieni - eriä pitäisi
        // pelata satoja tuhansia, luultavasti miljoonia kertoja ennen kuin tämä
        // on ongelma. Aion poistaa tämän jos/kun Godot-dlang joskus
        // rekisteröi luokan roskienkeruulle, jolloin tätä ei pitäisi enää tarvita.
        GCroot ~= hits;
        GCroot ~= targetNames;
        GCroot ~= targets;
    }

    @safe @Method void registerShot(){shotsFired++;}

    @Method connectToTargets()
    {   foreach(i, controller; targets)
        {   //auto controller = getNode(targets.ix(i).text).as!TargetController;
            controller.connectResult(this, cast(int) i);
        }
    }

    @Method registerHit(Variant unused, long targetI)
    {   import std.conv;
        if(targetI >= 0 && targetI < hits.length)
        {   hits[targetI]++;
            return;
        }
        printerr(text("Target index ", targetI, "out of bounds!"));
    }
}
