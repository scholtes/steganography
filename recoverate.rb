require 'chunky_png'

module Steganogrator
    include ChunkyPNG

    def self.recoverate(input, depth)
        png = Image.new(input.width, input.height, Color.rgb(0,0,0))
        # extract
        norm = 256/depth
        for x in 1...(input.width-1)
            for y in 1...(input.height-1)
                png[x, y] = Color.rgb(
                    (Color.r(input[x, y])%depth)*norm,
                    (Color.g(input[x, y])%depth)*norm,
                    (Color.b(input[x, y])%depth)*norm
                )
            end
        end
        png
    end
end

if __FILE__ == $0
    if ARGV.size != 3
        puts "Usage: recoverate [INPUT FILENAME] [OUTPUT FILENAME] [DEPTH (1, 2, 4, 8, ...)]"
        exit
    end

    input = ChunkyPNG::Image.from_file(ARGV[0])
    Steganogrator.recoverate(input, ARGV[2].to_i).save(ARGV[1])

end