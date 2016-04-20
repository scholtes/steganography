# steganography
[Wikipedia article.](https://en.wikipedia.org/wiki/Steganography)  Hide and extract images within other images.  For example, you can recover the cat from [this image.](https://en.wikipedia.org/wiki/File:Steganography_original.png)

## Usage

**Console environment**

To encode:

```$ steganograte [HOST FILENAME] [SYMBIONT FILENAME] [OUTPUT FILENAME] [DEPTH]```

`host filename` - The image that you want to hide another image in (i.e., this one will be visible)  
`symbiont filename` - The image that you want to hide inside of another image (i.e, this one will be concealed)  
`output filename` - Where to put the output image after combinging  
`depth` - The number of shades per each of the RGB channels (this should be a power of 2.  E.g., if `depth=4`, then there would be `4^3 = 64` total colors, with `log(4) = 2` of the least significant bits per channel reserved for the hidden image)  

For example:

```steganograte input.png secret.png mashed.png 4```

To decode:

```$ recoverate [INPUT FILENAME] [OUTPUT FILENAME] [DEPTH]```

`input filename` - The image that you wish to extract a secret image from  
`output filename` - Where to put the output image after extraction  
`depth` - Same thing as above  

For example, to recover the image from the above example:

```recoverate mashed.png secret_recovered.png 4```

**Programmatically**

See the ```Steganogrator``` module in ```steganograte.rb``` and ```recoverate.rb```, particularly the ```steganograte``` and ```recoverate``` methods.  There is also a ```dither``` method included as a bonus (it is used in the stenography process to maintain image quality).
