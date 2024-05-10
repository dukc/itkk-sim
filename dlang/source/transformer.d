import godot, godot.node, godot.packedscene, godot.node3d;

class Transformer : GodotScript!Node
{  @Property @DefaultValue!(gs!"res://") String replacementPath;
   Ref!PackedScene replacementPrefab;

   @Method void _ready()
   {  import godot.resourceloader;
      replacementPrefab= ResourceLoader.load(replacementPath).as!PackedScene;
   }

   @Method void _transform()
   {  print("transform called");
      auto replacement = replacementPrefab.instantiate().as!Node3D;
      getNode("../..").addChild(replacement);
      auto parent = getNode("..").as!Node3D;
      replacement.position = parent.position;

      parent.queueFree;
   }
}
