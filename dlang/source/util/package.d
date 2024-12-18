module util;

import godot;

//https://github.com/godot-dlang/godot-dlang/issues/199   varten
pragma(inline, true)
@trusted /+pure nothrow @nogc+/ String ix(ref PackedStringArray arr, size_t index)
{   // Huomaa ero palautustyypeissä (string ja String)
    //return (cast (typeof(&ix)) &ixImpl)(arr, index);

    return *cast(String*) &arr[index];
}


private ref string ixImpl(ref PackedStringArray arr, size_t index) => arr[index];
