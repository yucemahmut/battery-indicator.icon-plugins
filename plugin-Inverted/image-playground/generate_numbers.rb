require 'RMagick'

class NumberImageGenerator
  attr_accessor :image_dir, :font_size, :dimen

  def initialize()
    set_hdpi()
  end

  def set_hdpi()
    @image_dir = 'numbers-hdpi/'
    @font_size = 18
    @dimen = 35
  end

  def set_mdpi()
    @image_dir = 'numbers-mdpi/'
    @font_size = 14
    @dimen = 25
  end

  def generate(text)
    filename = "" + sprintf("%03d", text) + ".png";

    image = Magick::Image.new(@dimen, @dimen) {self.background_color = "transparent"}

    font = Magick::Draw.new();
    font.font_family = 'URW Chancery';
    font.pointsize = @font_size;
    font.gravity = Magick::CenterGravity;
    font.font_weight = 500;

    image.annotate(font, 0,0,0,0, text) {self.fill = 'white';};
    image.write(@image_dir + filename) {self.depth = 8;};
  end
end

ig = NumberImageGenerator.new;
for i in 0..100
  ig.generate(i.to_s);
end

system("for i in numbers-hdpi/[0-9]*.png; do convert $i -roll +3+1 $i; done")
system("gimp numbers-hdpi/100.png")
#system("for i in numbers-hdpi/[0-9]*.png; do convert $i -roll +0+2 $i; done")
#system("for i in numbers-hdpi/[0-9]*.png; do composite $i plug001.png $i; done")
system("cp numbers-hdpi/[0-9]*.png numbers-mdpi");
system("for i in numbers-mdpi/[0-9]*.png; do mogrify -resize 25x25 -sharpen 25x25 $i; done")