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
   // 0 tarkoittaa rajatonta vyötä
   @Property @DefaultValue!16 int ammoSpace;
   @Property @DefaultValue!(1.0) float reloadTime;
   @Property @DefaultValue!(1.0) float ballVelocity;
   @Property @DefaultValue!(1.0) float tracerVelocity;
   @Property Vector3 ballDispersion;
   @Property Vector3 tracerDispersion;
   @Property @DefaultValue!(gs!"res://") String ballPath;
   @Property @DefaultValue!(gs!"res://") String tracerPath;
   @Property NodePath envPath;

   bool cycled = true;

   //jäljellä olevat laukaukset normaalisti
   //käytetään valojuovien annosteluun silloinkin kun laukauksia on rajattomasti
   int ammo = 0;
   Ref!PackedScene ballPrefab;
   Ref!PackedScene tracerPrefab;

   // Ei jostain syystä toimi jos välittää signaalissa kaksi lukua erikseen
   // joten arg on kahden 32-bittisen luvun vektori.
   @Signal @Rename("s_ammo") static void s_ammo2(long arg);
   void s_ammo(int left, int maxCount)
   in(left >= 0)
   in(maxCount >= 0)
   {  emitSignal("s_ammo", (cast(long) left << 32) + maxCount);
   }
   @Signal @Rename("s_reload") static void s_reload2(float r_delay);
   void s_reload(float r_delay){
      emitSignal("s_reload", r_delay);
   }
   @Signal @Rename("fire") static void fire2(int type);
   void fire(int type){
      emitSignal("fire", type);
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
      ballPrefab = ResourceLoader.load(ballPath).as!PackedScene;
      tracerPrefab = ResourceLoader.load(tracerPath).as!PackedScene;
   }

   @Method void _physics_process(float delta)
   {  if (Engine.isEditorHint()) return;

      if(triggerPressed && cycled && (!ammoSpace || ammo))
      {  import std.algorithm, std.array, std.conv, std.functional, std.range;
         import std.mathspecial : normalDistributionInverse;
         import std.random : uniform;
         import godot.node3d, godot.rigidbody3d;

         // Sitä varten kun laukaksia on rajattomasti
         if(--ammo < 0) ammo += 3;
         cycleTimer.start();
         size_t bulletType = ammo % 3 == 0;
         auto bullet = [ballPrefab, tracerPrefab][bulletType].instantiate()
            .as!RigidBody3D;
         enviroment.addChild(bullet);
         auto direction = gunBarrel.globalBasis.elements[]
            .map!(el=>el.z).staticArray!3.Vector3.normalized;
         bullet.position = gunBarrel.globalTransform.origin;
         bullet.lookAt(bullet.position - direction, Vector3(0,1,0));
         bullet.linearVelocity = {
            auto ideal = direction * [ballVelocity, tracerVelocity][bulletType];
            auto deviation = [ballDispersion, tracerDispersion][bulletType]
               .adjoin!(v=>v.x, v=>v.y, v=>v.z)
               .bind!only
               .map!(sigma => sigma * float(normalDistributionInverse(
                  uniform(1, 0x10_0000) / real(0x10_0000))))
               .staticArray!3
               .Vector3;
            return ideal + deviation;
         }();
         fire(cast(int) bulletType);
         s_ammo(ammo, ammoSpace);
         cycled = false;
      }
   }

   @Method void _reload()
   {  import godot.gdscript;

      cycled = false;
      ammo = 0;
      s_ammo(ammo, ammoSpace);
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
      s_ammo(ammo, ammoSpace);
   }
}
