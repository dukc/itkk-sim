import godot, godot.engine, godot.node;

class MissionResult : GodotScript!Node
{   @Property PackedStringArray targetNames;
    int shotsFired = 0;
    int[] hits;

    // Koska roskienkeruu ei muuten löydä hits-taulua!
    static int[][] GCroot;

    @Method void _ready()
    {   if (Engine.isEditorHint()) return;
        hits = new int[](targetNames.length);
        // Tarkoituksellinen muistivuoto - Yäk! Silti mitättömän pieni - eriä pitäisi
        // pelata satoja tuhansia, luultavasti miljoonia kertoja ennen kuin tämä
        // on ongelma. Aion poistaa tämän jos/kun Godot-dlang joskus
        // rekisteröi luokan roskienkeruulle, jolloin tätä ei pitäisi enää tarvita.
        GCroot ~= hits;
    }

    @safe @Method void registerShot()
    {   shotsFired++;
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
