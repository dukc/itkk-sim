import godot, godot.engine, godot.node, godot.resourcepreloader;


class MainScene : GodotScript!ResourcePreloader
{   @Property String firstSceneName;
    bool deferring = false;

    @Method void _ready()
    {   if (Engine.isEditorHint()) return;
        deferring = true;
    }

    @Method void _process(double delta)
    {   if(Engine.isEditorHint()) return;
        if(!deferring) return;

        // GodotScriptin Callable.call_deferred olisi parempi, mutta en tiennyt
        // suoralta kädeltä miten käyttää sitä D:stä.
        getParent.addChild(getResource(firstSceneName.StringName).as!PackedScene.instantiate());
        deferring = false;
    }
}
