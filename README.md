# spacepaper

Spacepaper is a set of space-themed wallpapers based on [Simon Lee](https://unsplash.com/@simonppt)'s Pantone Planet series. The original images, covered by the [Unsplash license](https://unsplash.com/license), are available at the following links:

- [Moon](https://unsplash.com/photos/a-black-and-white-photo-of-the-moon-m0p-ALuA1ok)
- [Venus](https://unsplash.com/photos/a-piece-of-paper-with-a-picture-of-a-planet-on-it-O3oIMSvv6O8)
- [Jupiter](https://unsplash.com/photos/a-picture-of-a-planet-with-the-name-jupiter-on-it-_B7LjqNXu5Q)
- [Mars](https://unsplash.com/photos/a-close-up-of-a-picture-of-a-mars-planet-hrOXaenH640)
- [Neptune](https://unsplash.com/photos/a-picture-of-a-blue-object-on-a-blue-background-MzZ4WW3IT_U)
- [Uranus](https://unsplash.com/photos/a-picture-of-a-round-object-with-the-name-uranus-on-it-A6OTC1-Ok-A)
- [Saturn](https://unsplash.com/photos/a-saturn-planet-with-the-name-saturn-on-it-z1vpjHAq1o8)
- [Earth](https://unsplash.com/photos/a-picture-of-the-earth-taken-from-space-eGALMCJ_Cvk)

## Demo

![](https://github.com/piazzai/spacepaper/blob/master/demo.gif)

## Usage

The image generation script requires [GIMP](https://www.gimp.org/) 2.10 or higher. Wallpapers can be generated from any of the images above by running `wallpaper.sh` and specifying the desired width and height in pixels, as in the following examples:

```bash
bash wallpaper.sh 375 812 moon
bash wallpaper.sh 768 1024 earth
bash wallpaper.sh 3072 1920 jupiter
```

It is also possible to generate wallpapers for all of the images at once by omitting the last argument, as in `bash wallpaper.sh 4096 2304`. The generated images are saved to the `wallpaper` folder in PNG format. For convenience, pre-generated images for some common display sizes are included in the `samples` folder.

## Bugs

If you have any trouble using the script, please consider [opening an issue](https://github.com/piazzai/spacepaper/issues).
