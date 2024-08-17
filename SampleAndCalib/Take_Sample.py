"""  Created by Tran Dang Trung Duc - 06/12/2021
     Description: Sampling with Camera Kinect XBox 360

     Height: 73 cm
     Distance: 56.5 cm   (Camera to wall)
"""
# Libraries
import cv2 # OpenCV for computer vision
import numpy as np # Library for linear algebra
from openni import openni2 # Library for function of camera

openni2.initialize('C:\Program Files\OpenNI2\Redist') # Path of the OpenNI redistribution

dev = openni2.Device.open_any() # Grab camera 
# print(dev.get_device_info()) # Info of camera
color_stream = dev.create_color_stream() # Create BGR stream
color_stream.start() # Start stream

# Take 10 samples for each style
for i in range(10):

    frame = color_stream.read_frame() # Get frame from camera
    frame_data = frame.get_buffer_as_uint8() # Get data and cast type to uint8
    
    # Get data and create BGR image
    create_image = np.frombuffer(frame_data, dtype=np.uint8).reshape((480,640,3)) # Get data
    img = cv2.cvtColor(create_image, cv2.COLOR_RGB2BGR) # Convert to BGR
    print(img)
    
    # Store samples
    cv2.imwrite('G:/1510815/Sample_Calibration/test/' + 'test_'+str(i)+'.png', img)

color_stream.stop() # Stop stream
openni2.unload() # Unload Openni2 library
cv2.destroyAllWindows() # Close the panel