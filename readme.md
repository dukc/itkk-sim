Lue `liitteet/käyttöopas.md` yleistietoa ja itse käyttöä varten

Koostamis - ja jakeluohjeet kirjoitettu Linuxin näkökulmasta. Windowsilla koostamisenkin pitäisi onnistua, mutta joudut selvittämään itse miten.

## Koostaminen

Tarvitset Godot 4 - pelimoottorin, D-kääntäjän ja D:n pakettienhallinnan, DUBin.

Käännä D-scriptit projektista: 
```
(cd dlang && dub build) && cp dlang/libfps-godot-modules.so ./libfps-godot-modules.s
```

Tai, jos julkaisuversiota haluat koostaa:
```
(cd dlang && dub build --build=release) && cp dlang/libfps-godot-modules.so ./libfps-godot-modules-release.so
```

Avaa projekti Godotilla ja työstä/aja kuten normaalisti.

## Jakeluversion tekeminen

Käytä Godotin projektinvientimekanismeja. Pakkaa mukaan käyttöopas ja `Tähtäin.png` `liitteet/`-kansiosta.

Jos olet viemässä Windowsille, D-skriptit pitää kääntää dll-tiedostoksi eikä `.so`:ksi. Vaikein osa tässä on saada D-kääntäjän ristiinkääntäminen toimimaan. Suosittelen LDC-kääntäjää, [Tämä artikkeli](https://wiki.dlang.org/Cross-compiling_with_LDC) toivottavasti auttaa.

Kun ristiinkääntö toimii,
```
(cd dlang && dub build --build=release --compiler=ldc2 --arch=x86_64-unknown-windows-msvc) && cp dlang/fps-godot-modules.dll ./fps-godot-modules-release.dll
```
.

Lisäksi joudut lataamaan Winen (Windows-sovellusten ajoympäristön Linuxille) ja jonkun Windows-sovelluksen Internetistä `.wine`-tiedostoihisi jotta kuvakkeen asettaminen Windows-sovellukselle onnistuu. Tämän tekeminen on dokumentoitu hyvin Godotissa - seuraa sen ohjeita.