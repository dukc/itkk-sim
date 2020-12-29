import godot, godot.animationplayer, godot.node,
   godot.packedscene, godot.position3d, godot.timer;

class Pistol : GodotScript!Position3D
{  @OnReady!"Gun_Barrel" Position3D gunBarrel;
   @OnReady!"Timer" Timer cycleTimer;
   @OnReady!"ReloadTimer" Timer reloadTimer;
   @OnReady!envPath Node enviroment;

   @Property @DefaultValue!(1.0) float cycleTime;
   @Property @DefaultValue!16 int ammoSpace;
   @Property @DefaultValue!(1.0) float reloadTime;
   @Property @DefaultValue!(gs!"res://") String bulletPath;
   @Property NodePath envPath;

   bool cycled = true;
   bool triggerPressed = false;
   int ammo = 0;
   Ref!PackedScene bulletPrefab;

   @Signal static void s_ammo(int b_count);
   @Signal static void s_reload(float r_delay);
   @Signal static void fire();

   @Method void _ready()
   {  import godot.resourceloader;
      
      cycleTimer.waitTime = cycleTime;
      reloadTimer.waitTime = reloadTime;
      ammo = ammoSpace;
      bulletPrefab= ResourceLoader.load(bulletPath).as!PackedScene;
   }
      
   @Method void _physics_process(float delta)
   {  import godot.input;
      
      if (Input.isActionJustPressed(gs!"fire") ) triggerPressed = true;
      else if (Input.isActionJustReleased(gs!"fire") ) triggerPressed = false;
      
      if(triggerPressed && cycled && ammo)
      {  import std.algorithm, std.array, std.conv;
         import godot.spatial, godot.rigidbody;
         
         ammo--;
         cycleTimer.start();
         auto bullet = bulletPrefab.instance().as!RigidBody;
         enviroment.addChild(bullet);
         auto direction = -gunBarrel.globalTransform.basis.elements[]
            .map!(el=>el.z).staticArray!3.Vector3.normalized;
         bullet.translation = gunBarrel.globalTransform.origin;
         bullet.lookAt(bullet.translation + direction, Vector3(0,1,0));
         bullet.linearVelocity = direction * 820;
         emitSignal(gs!"fire");
         emitSignal(gs!"s_ammo", ammo);
         print("dir: ", direction.x.to!string, " ", direction.y.to!string, " ", direction.z.to!string);
         cycled = false;
      }
            
      else if (Input.isActionJustPressed(gs!"reload"))
      {  import godot.gdscript;
         
         cycled = false;
         ammo = 0;
         emitSignal(gs!"s_ammo", ammo);
         emitSignal(gs!"s_reload", reloadTime);
         reloadTimer.start();
      }
   }

   @Method void _on_timer_timeout()
   {  cycled = true;
   }
   
   @Method void _on_reloadtimer_timeout()
   {  ammo = ammoSpace;
      cycled = true;
      emitSignal(gs!"s_ammo", ammo);
   }
}
