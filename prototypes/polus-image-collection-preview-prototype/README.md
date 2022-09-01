# polus-prototypes
This repository consists of `polus-image-collection-preview.ipynb` notebook which provides access to the image collections present in WIPP. 
It uses `WippPy` to gain access to the WIPP backend. 

Contact [Nick Schaub](mailto:nick.schaub@nih.gov)  or [Gauhar Bains](mailto:gauhar.bains@labshare.org) for more information.

## Requirements
```
numpy==1.18.1
tifffile==2020.6.3
imagecodecs==2020.5.30
matplotlib==3.1.3
ipywidgets==7.5.1
```
## Setup
To use this notebook for a particular deployment of WIPP : Change value of the variable `api_route` (under `class WippData` in cell 1) to the api url of your deployment.

## Description
The note book enables the user to preview images present in the WIPP backend. The UI (shown in the image below) consists of the following features :
1. `Select image menu` : This menu helps the user to select an image collection and subsequently the image from that collection which they want to view.  
2.  Once the image is loaded, the user can make the following adjustments to the image:  
```
- Brightness slider : adjusts the brighness of the image by adding a value to each pixel in the image.   
- Contrast Slider: multiplies the image with a constant to increase the contrast  
- alpha : changes the transperency level of a layer if multiple images are loaded.   
- Intensity range slider: helps set a min/max range to define the dynamic range of the image. For eg: if the range is set to have a min at 30 and a max at 150    
                          then all pixels with an intensity of 30 or lower would get a value of 0, and the pixels with values higher than 150 would be given a value of 255,   
                          and pixels with values between 30 and 150 would be rescaled to have a range of 0 to 255.
- Threshold range slider: helps set a min/max range to only display values within a particular range. For eg. If the range is set between 20 and 200, then all values  
                           below 20 and and above 200 will be set to 0. 

```
    
2. `Image list menu` : This menu enables the user to view or hide an image.  
3. `Image Histogram Tab`: This tab displays the histogram of pixel intensities of an image. 
4. `Image Metadata Tab`: The user can see the metadata attached to an image under this menu.  

<img width="819" alt="notebook" src="https://user-images.githubusercontent.com/48079888/87474082-7d1b8580-c5f0-11ea-97b6-bf76573c9167.PNG">
  

