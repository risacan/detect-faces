require 'opencv'
include OpenCV

EMOJI = IplImage.load './emoji.png', 1

def emoji(image, region)
  resized_image = EMOJI.resize region
  image.set_roi region
  (resized_image.rows * resized_image.cols).times do |i|
    if resized_image[i][0].to_i > 0 or resized_image[i][1].to_i > 0 or resized_image[i][2].to_i > 0
      image[i] = resized_image[i]
    end
  end
  image.reset_roi
end

camera = CvCapture.open(0)

face = CvHaarClassifierCascade::load('./opencv-1.0.0/data/haarcascades/haarcascade_frontalface_alt.xml')
size = CvSize.new(720, 420)

window = GUI::Window.new('camera')

while GUI::wait_key(50).nil?
  image = camera.query
  image = image.resize(size)
  face.detect_objects(image) {|rect_face|
    emoji(image, rect_face)
  }
  window.show image
end

window.destroy