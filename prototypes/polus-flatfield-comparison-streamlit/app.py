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

#normalize the image data
img1 = (img1 - np.min(img1)) / (np.max(img1) - np.min(img1)) * 255
img2 = (img2 - np.min(img2)) / (np.max(img2) - np.min(img2)) * 255

#convert the image data to uint8
img1 = img1.astype(np.uint8)
img2 = img2.astype(np.uint8)

# Display the images using Streamlit
st.image([img1, img2], caption=['Image 1', 'Image 2'])

image_comparison(
img1=img1,
img2=img2,
label1="raw",
label2="corrected"
)