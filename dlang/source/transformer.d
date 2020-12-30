import godot, godot.node, godot.packedscene, godot.spatial;

class Transformer : GodotScript!Node
{  @Property @DefaultValue!(gs!"res://") String replacementPath;
   Ref!PackedScene replacementPrefab;
   
   @Method void _ready()
   {  import godot.resourceloader;
      replacementPrefab= ResourceLoader.load(replacementPath).as!PackedScene;
   }
   
   @Method void _transform()
   {  print("transform called");
      auto replacement = replacementPrefab.instance().as!Spatial;
      getNode("../..").addChild(replacement);
      auto parent = getNode("..").as!Spatial;
      replacement.translation = parent.translation;
      
      parent.queueFree;
   }
}
