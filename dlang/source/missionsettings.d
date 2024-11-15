import godot, godot.engine, godot.node;

class MissionSettingsNode : GodotScript!Node
{   @Property int beltLength;
    @Property double enemySpeedFactor;

    /+@safe pure MissionSettings asVal()
    {   typeof(return) result;
        result.beltLength = this.beltLength;
        result.enemySpeedFactor = this.enemySpeedFactor;

        return result;
    }+/
}

/+struct MissionSettings
{   int beltLength = 50;
    double enemySpeedFactor = 1.0;
}+/
