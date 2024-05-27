import godot, godot.animationplayer, godot.engine, godot.inputevent, godot.node,
   godot.packedscene, godot.marker3d, godot.timer;

import std.conv : text;

class Pistol : GodotScript!Node3D
{  @OnReady!"Gun_Barrel" Marker3D gunBarrel;
   @OnReady!"Timer" Timer cycleTimer;
   @OnReady!"ReloadTimer" Timer reloadTimer;
   @OnReady!envPath Node enviroment;

   @Property @DefaultValue!false bool triggerPressed;
   @Property @DefaultValue!(1.0) float cycleTime;
   @Property @DefaultValue!16 int ammoSpace;
   @Property @DefaultValue!(1.0) float reloadTime;
   @Property @DefaultValue!(1.0) float muzzleVelocity;
   @Property @DefaultValue!(gs!"res://") String bulletPath;
   @Property NodePath envPath;

   bool cycled = true;

   int ammo = 0;
   Ref!PackedScene bulletPrefab;


   @Signal @Rename("s_ammo") static void s_ammo2(int b_count);
   void s_ammo(int b_count){
      emitSignal("s_ammo", b_count);
   }
   @Signal @Rename("s_reload") static void s_reload2(float r_delay);
   void s_reload(float r_delay){
      emitSignal("s_reload", r_delay);
   }
   @Signal @Rename("fire") static void fire2();
   void fire(){
      emitSignal("fire");
   }

   // ehkä tähän on olemassa funkio Godotissakin?
   private bool isValid() => gunBarrel && cycleTimer && reloadTimer && enviroment;

   @Method void _ready()
   {  import godot.resourceloader;
      if (!isValid) printerr("Pistol not initialised properly!");
      if (Engine.isEditorHint()) return;

      cycleTimer.waitTime = cycleTime;
      reloadTimer.waitTime = reloadTime;
      ammo = ammoSpace;
      bulletPrefab= ResourceLoader.load(bulletPath).as!PackedScene;
   }

   @Method void _physics_process(float delta)
   {  if (Engine.isEditorHint()) return;

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
         bullet.linearVelocity = direction * muzzleVelocity;
         fire();
         s_ammo(ammo);
         cycled = false;
      }
   }

   @Method void _reload()
   {  import godot.gdscript;

      cycled = false;
      ammo = 0;
      s_ammo(ammo);
      s_reload(reloadTime);
      reloadTimer.start();
   }

   @Method void _unhandled_input(InputEvent event)
   {  if(Engine.isEditorHint()) return;

      if(event.isActionPressed("fire")) triggerPressed = true;
      if(event.isActionReleased("fire")) triggerPressed = false;
      if(cycled && event.isActionPressed("reload")) _reload();
   }

   @Method void _on_timer_timeout()
   {  cycled = true;
   }

   @Method void _on_reloadtimer_timeout()
   {  ammo = ammoSpace;
      cycled = true;
      s_ammo(ammo);
   }
}
