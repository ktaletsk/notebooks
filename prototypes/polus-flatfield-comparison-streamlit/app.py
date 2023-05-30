import streamlit as st
from streamlit_image_comparison import image_comparison
import numpy as np
import tifffile

#tifffile
#set the paths to OME-TIFF files
img_path1 = '/Users/aditipatel/Desktop/examples/prototypes/streamlit-comp/data/original/p001_x01_y08_wx3_wy3_c2.ome.tif'
img_path2 = '/Users/aditipatel/Desktop/examples/prototypes/streamlit-comp/data/corrected/p001_x01_y08_wx3_wy3_c2.ome.tif'

#read OME-TIFF files using tifffile
img1 = tifffile.imread(img_path1)
img2 = tifffile.imread(img_path2)

values = st.slider('Dynamic range', 0, 65535, (0, 800), step=100)

#normalize the image data
img1 = (img1 - values[0]) / (values[1] - values[0]) * 255
img2 = (img2 - values[0]) / (values[1] - values[0]) * 255

#convert the image data to uint8
img1 = img1.astype(np.uint8)
img2 = img2.astype(np.uint8)

# Display the image comparison using Streamlit
image_comparison(
img1=img1,
img2=img2,
label1="raw",
label2="corrected"
)