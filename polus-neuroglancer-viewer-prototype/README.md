# Polus Neuroglancer Viewer Prototype

This repository consists of the `Neuroglancer.ipynb` notebook which serves as an interface between `polus-volume`
and the WIPP backend. Polus Volume leverages the Google Neuroglancer project for 2D and 3D visualization of image data in the web browser.

Contact [Nick Schaub](mailto:nick.schaub@nih.gov)  or [Gauhar Bains](mailto:gauhar.bains@labshare.org) for more information.
 
For more information about Neuroglancer : https://github.com/google/neuroglancer  
  
For more information about Polus-volume : https://github.com/LabShare/polus-volume

## Setup 
To use this notebook for a particular deployment of WIPP, make the following changes:

1. In cell 1, under `class WippData` set the value of the variable `api_route`.
2. In cell 2, at the beginning, set the value of the variable `WIPP_API_URL`. This url should be a general link pointing to the info file of an image in a pyramid collection. Example : `https://wipp-api-Link/pyramid-files/{}/{}`. The two braces at the end of the url are important. The first brace is for the name of the pyramid collection and the second is for the name of the image within that collection.
3. Just below `WIPP_API_URL` (stated in step 2), set the value of the variable `NEUROGLANCER_URL`. This should be a link to your local neuroglancer deployment. 


## Description

 The notebook enables the user to visualize pyramids located in the WIPP backend in Neuroglancer. The UI consists of the following widgets:

1. `Select pyramid accordion menu `: This menu helps users to select a pyramid collection and subsequently the image which they want to view.
The `Pyramid` dropdown menu enlists only 'Neuroglancer type' pyramids i.e only pyramids which are compatible with Neuroglancer. The users can
select an image within that pyramid collection using the Image dropdown menu. Once the image is loaded: Brightness, Contrast and Color widgets
can be used the adjust the visualization.

2. `Navigation Panel`: The widgets in this menu enable the user to move around the image. It includes sliders to- zoom in/out, change x and y location.

3. `Selection Panel` : The selection panel enables the user to do the following: hide/view channels (if multiple channels are loaded, the user can view any combination of the loaded channels), and change the layout
to view xy,yz,xz or 4 pannel view (showing all 3 planes and 3d view). The default configuration loads an image in the xy plane.  

4. `Copy Url`: The copy url button permits the user to share a visualization. Clicking on the copy-url button will display the current iframe url.

  
    
      
<img width="940" alt="Neuroglancer1" src="https://user-images.githubusercontent.com/48079888/81192010-b3e97580-8f87-11ea-94f2-290f056e1e88.PNG">
