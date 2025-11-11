import godot, godot.engine, godot.object, godot.rigidbody3d;
import std.conv;

class Airdrag : GodotScript!Node
{   RigidBody3D piece;

    // Ilmanvastuksen peruskerroin
    @Property @DefaultValue!(0.0) double formFactor;
    // Luodin poikkipinta-ala * ilman tiheys nollakorkeudessa,
    // yksikkö kg/km (tai g/m).
    @Property @DefaultValue!(0.0) double displacedMassPerKm;
    // Ilman tiheyskerroin noustessa kilometrin ylöspäin.
    @Property @DefaultValue!(1.0) double altitudeEffectPerKm;
    // Kerroin ilmanvastuskertoimelle nopeuden mukaan suhteessa peruskertoimeen.
    // Tarkoitus on että tässä olisi jonkin standartiluodin, esim G1, G5 tai
    // G7, kertoimet.
    @Property PackedFloat32Array coefficientTable;
    // Minkä nopeuden välein lukemat coefficientTablessa ovat.
    @Property @DefaultValue!(100.0) double tableSpacingSpeed;

    @Method void _enter_tree()
    {   if (Engine.isEditorHint()) return;
        piece = getNode("..").as!RigidBody3D;
    }

    @Method void _physics_process(float delta)
    {   import std.math;

        if (Engine.isEditorHint()) return;
        if (coefficientTable.length == 0)
        {   printerr("Airdrag drag table not set!");
            coefficientTable.pushBack(1.0);
        }

        if (tableSpacingSpeed < 0.0001)
        {   if (coefficientTable.length > 1) printerr("Airdrag table spacing must be positive!");
            tableSpacingSpeed = 100;
        }

        auto vel = piece.linearVelocity;
        auto spd = vel.length;
        // Haetaan tämänhetkinen ilmanvastuskerroin
        auto coeff = {
            float speedOnTable = spd / tableSpacingSpeed;
            auto tableIndex = cast(size_t) lrint(speedOnTable + .5);
            if(tableIndex + 2 > coefficientTable.length) return formFactor * coefficientTable[$-1];

            float modulus = speedOnTable - tableIndex;
            return formFactor *
            (   modulus * coefficientTable[tableIndex] +
                (1 - modulus) * coefficientTable[tableIndex + 1]
            );
        }();
        piece.applyCentralForce(
            -vel * spd * .0005 * displacedMassPerKm * coeff *
            altitudeEffectPerKm ^^ (piece.position.z / 1000)
        );
    }
}

private alias PHint = Property.Hint;
