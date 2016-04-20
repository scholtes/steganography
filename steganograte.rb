require 'chunky_png'

module Steganogrator
    include ChunkyPNG

    def self.steganograte(host, symbiont, depth)
        # copy
        norm = 256/depth
        png = dither(host, norm)
        # hide
        symbio_dither = dither(symbiont, depth)
        for x in 1...(host.width-1)
            for y in 0...(host.height-1)
                png[x, y] = Color.rgb(
                    Color.r(png[x, y])/depth*depth + Color.r(symbio_dither[x, y])/norm,
                    Color.g(png[x, y])/depth*depth + Color.g(symbio_dither[x, y])/norm,
                    Color.b(png[x, y])/depth*depth + Color.b(symbio_dither[x, y])/norm
                )
            end
        end
        png
    end

    def self.dither(img, depth)
        png = Image.new(img.width, img.height, Color.rgb(0,0,0))
        # copy
        for x in 0...img.width
            for y in 0...img.height
                png[x, y] = img[x, y]
            end
        end
        # end copy, begin dither
        for y in 1...(png.height-1)
            for x in 1...(png.width-1)
                oldpixel = png[x, y]
                newpixel = find_closest_palette_color(oldpixel, depth)
                png[x, y] = newpixel
                quant_error_r = Color.r(oldpixel) - Color.r(newpixel)
                quant_error_g = Color.g(oldpixel) - Color.g(newpixel)
                quant_error_b = Color.b(oldpixel) - Color.b(newpixel)
                png[x+1, y] = Color.rgb(
                    squeeze_range(Color.r(png[x+1, y]) + quant_error_r * 7/16),
                    squeeze_range(Color.g(png[x+1, y]) + quant_error_g * 7/16),
                    squeeze_range(Color.b(png[x+1, y]) + quant_error_b * 7/16)
                )
                png[x-1, y+1] = Color.rgb(
                    squeeze_range(Color.r(png[x-1, y+1]) + quant_error_r * 3/16),
                    squeeze_range(Color.g(png[x-1, y+1]) + quant_error_g * 3/16),
                    squeeze_range(Color.b(png[x-1, y+1]) + quant_error_b * 3/16)
                )
                png[x, y+1] = Color.rgb(
                    squeeze_range(Color.r(png[x, y+1]) + quant_error_r * 5/16),
                    squeeze_range(Color.g(png[x, y+1]) + quant_error_g * 5/16),
                    squeeze_range(Color.b(png[x, y+1]) + quant_error_b * 5/16)
                )
                png[x+1, y+1] = Color.rgb(
                    squeeze_range(Color.r(png[x+1, y+1]) + quant_error_r * 1/16),
                    squeeze_range(Color.g(png[x+1, y+1]) + quant_error_g * 1/16),
                    squeeze_range(Color.b(png[x+1, y+1]) + quant_error_b * 1/16)
                )
            end
        end
        png
    end

    def self.find_closest_palette_color(oldpixel, depth)
        norm = 256/depth
        r = Color.r(oldpixel)/norm*norm # to be 0, 1, 2, 3 => color(....)/norm (just without the *norm part)
        g = Color.g(oldpixel)/norm*norm
        b = Color.b(oldpixel)/norm*norm
        Color.rgb(r,g,b)
    end

    def self.squeeze_range(n)
        n > 255 ? 255 : (n < 0 ? 0 : n)
    end
end

if __FILE__ == $0

    if ARGV.size != 4
        puts "Usage: steganograte [HOST FILENAME] [SYMBIONT FILENAME] [OUTPUT FILENAME] [DEPTH (1, 2, 4, 8, ...)]"
        exit
    end

#    img = ChunkyPNG::Image.from_file(ARGV[0])
#    Stenogrator.dither(img, 4).save("output.png")



#=begin
    host = ChunkyPNG::Image.from_file(ARGV[0])
    symbiont = ChunkyPNG::Image.from_file(ARGV[1])
    Steganogrator.steganograte(host, symbiont, ARGV[3].to_i).save(ARGV[2])
#=end

end