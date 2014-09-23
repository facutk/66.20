66.20 Orga 2do 2014
=========

# Mandelbrot

> Mandelbrot fractal renderizer

[Live Demo]


Web Renderizer Setup
--------------

```sh
cd 66.20/tp0/
make
cp tp0 extras
cd extras
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python mandelbrotwrapper.py
```

Web Renderizer Run
--------------

```sh
cd 66.20/tp0/extras
source venv/bin/activate
python mandelbrotwrapper.py
```
Then navigate to [http://localhost:5000]

Run in MIPS Emulator
--------------
> Host OS

```sh
sudo ifconfig lo:0 172.20.0.1
./gxemul -e 3max -d netbsd-pmax.img
```
> Guest OS

```sh
ssh -R 2222:127.0.0.1:22 <user>@172.20.0.1
```
> Host OS

```sh
git clone https://github.com/facutk/66.20.git
cd 66.20
tar -zcvf tp0.tar.gz tp0/ 
scp -P 2222 tp0.tar.gz root@127.0.0.1:
ssh -p 2222 root@127.0.0.1
```
> Guest OS

```sh
tar -zxvf tp0.tar.gz
cd tp0
make tests
```


### Sample Runs

> Command Line

```sh

    $ ./tp0 --center 0+0i --width 2 --height 2
            --resolution 14x11 --output -

    P2
    14
    11
    255
      2   2   2   3   3   4  12  44   3   2   2   1   1   1 
      2   3   3   3   5   9 255  24   4   3   3   2   1   1 
      3   4   5  65  10 255 255 255  30   8   5   2   2   1 
      4   5   8 239 255 255 255 255 255 255   6   3   2   2 
    255  12  52 255 255 255 255 255 255 255   8   3   2   2 
    255 255 255 255 255 255 255 255 255 255   5   3   2   2 
    255 255 255 255 255 255 255 255 255  14   5   3   2   2 
    255  12  52 255 255 255 255 255 255 255   8   3   2   2 
      4   5   8 239 255 255 255 255 255 255   6   3   2   2 
      3   4   5  65  10 255 255 255  30   8   5   2   2   1 
      2   3   3   3   5   9 255  24   4   3   3   2   1   1 
```

> Renderized

![Center=0+0i](https://github.com/facutk/66.20/raw/master/tp0/doc/images/mandelbrot_0.gif)

> Command Line

```sh
    $ ./tp0 --width 0.006089755361389781 --height 0.006089755361389781
            --center -0.16495019360389762+1.0391402340922113i
            --resolution 14x11 --output -

    P2
    14
    11
    255
     26  32  26  31  24  22  21  21  23  25  22  21  22  26 
     47  34  41  29  25  29  24  24  26  29  24  34  25  30 
     30  54  49  34  31  30  27  26  31  28  27  29  34  58 
     27  32  35  56  41  35  36  34  36  32  36  34  72  44 
     22  30  39  33  40  81  45  45  53  45  49  43  55  96 
     22  24  26  32  37  55 127 119 123  63  69 103 117 255 
     39  29  28  30  37  47  84 255 255 255 255 255 255 255 
     22  24  27  30  52  41 103  86 255 255 255 255 255 255 
     21  22  24  27  35  39  78 105 255 255 255 255 255 255 
     21  23  31  30  34  40  50 255 255 255 255 255 255 255 
     23  24  26  32  52  61  76 255 255 255 255 255 255 255 
```

> Renderized

![Center=-0.16495019360389762+1.0391402340922113i](https://github.com/facutk/66.20/raw/master/tp0/doc/images/mandelbrot_1.gif)

> Command Line

```sh
    $ ./tp0 --width 0.00913463304208467 --height 0.00913463304208467
            --center -0.027010582808902495+0.7093001367538602i
            --resolution 14x11 -output -

    P2
    14
    11
    255
    255 255 255 255 255 255 107  84  88  52  39  36  39  64 
    255 255 255 255 255 255  86 125  61  47  40  39  66  52 
    255 255 255 255 255 255 255  63  59  64  42  42  44  63 
    255 255 255 255 255 255 228 255 230  53  45  44  45  46 
    255 255 255 255 255 255 255 202 140  54 110  85  49  52 
    255 255 255 255 255 255 255 179  74  61  58  64  81  90 
    255 255 255 224 255 255 164 139 105  85 100 196 105 117 
    255 149 217 144  73 230 158  71 154 175  92  75  62  49 
    255  90  78  58  53  56  81  58  81  74  97  93 115  61 
    194 255 255 118  48  43  45  49  70  66  97  83  49  55 
     58  64  84  72  47  48  38  55  52  45  43 123  38  34
```

> Renderized

![Center=c=-0.027010582808902495+0.7093001367538602i](https://github.com/facutk/66.20/raw/master/tp0/doc/images/mandelbrot_2.gif)


Version
----

1.0


[Live Demo]:http://home.facu.tk/mandelbrot
[http://localhost:5000]:http://localhost:5000
