import godot, godot.animationplayer, godot.node,
   godot.packedscene, godot.marker3d, godot.timer;

class Pistol : GodotScript!Node3D
{  @OnReady!"Gun_Barrel" Marker3D gunBarrel;
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

      if (Input.isActionJustPressed("fire") ) triggerPressed = true;
      else if (Input.isActionJustReleased("fire") ) triggerPressed = false;

      if(triggerPressed && cycled && ammo)
      {  import std.algorithm, std.array, std.conv;
         import godot.node3d, godot.rigidbody3d;

         ammo--;
         cycleTimer.start();
         auto bullet = bulletPrefab.instantiate().as!RigidBody3D;
         enviroment.addChild(bullet);
         auto direction = -gunBarrel.globalBasis.elements[]
            .map!(el=>el.z).staticArray!3.Vector3.normalized;
         bullet.position = gunBarrel.globalTransform.origin;
         bullet.lookAt(bullet.position + direction, Vector3(0,1,0));
         bullet.linearVelocity = direction * 820;
         emitSignal("fire");
         emitSignal("s_ammo", ammo);
         cycled = false;
      }

      else if (Input.isActionJustPressed("reload"))
      {  import godot.gdscript;

         cycled = false;
         ammo = 0;
         emitSignal("s_ammo", ammo);
         emitSignal("s_reload", reloadTime);
         reloadTimer.start();
      }
   }

   @Method void _on_timer_timeout()
   {  cycled = true;
   }

   @Method void _on_reloadtimer_timeout()
   {  ammo = ammoSpace;
      cycled = true;
      emitSignal("s_ammo", ammo);
   }
}
