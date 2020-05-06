# Polus Neuroglancer Viewer Prototype

This repository consists of the `Neuroglancer.ipynb` notebook which serves as an interface between the WIPP-CI deployment of `polus-volume`
and the WIPP CI backend. Polus Volume leverages the Google Neuroglancer project for 2D and 3D visualization of image data in the web browser.

For more information about Neuroglancer : https://github.com/google/neuroglancer  
  
For more information about Polus-volume : https://github.com/LabShare/polus-volume

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
