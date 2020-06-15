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
1. `Select image menu` : This menu helps the user to select an image collection and subsequently the image from that collection which they want to view
. Once the image is loaded, the user can adjust the brightness and contrast of the image.
`Note : The user can upload upto 3 images. Images loaded after the first image should have the same size as the first image. `
2. `Image list menu` : This menu enables the user to view or hide an image.
3. `Image Metadata`: The user can see the metadata attached to an image under this menu.   
  
    


<img width="713" alt="image-viewer" src="https://user-images.githubusercontent.com/48079888/84699521-a5479400-af1f-11ea-8faa-bbfff064014a.PNG">
