# Developer's Guide
This tool converts selected CSV files from WIPP CSV collections to 
Pandas dataframes, and displays an interactive table with BeakerX.

## Quick Reference
Here are the basic steps you need to set up the code

## Build 
Before running the code, run the following commands in the terminal from 
within JupyterLab:

* jupyter labextension install @jupyter-widgets/jupyterlab-manager
* jupyter labextension install beakerx-jupyterlab
* pip install py4j
* pip install beakerx==1.4.1
* beakerx install

These enable the BeakerX ipywidget to work in JupyterLab.

## Run the Program
To run the code directly from JupyterLab CI, install the WippPy API
from GitHub. Next, save `CsvViewerTool.ipynb` to the `wippy` folder
from within a local directory. 

From there, the GUI can be viewed by selecting 
`View`>`Render notebook in Voila` from the JupyterLab GUI.

You will be able to select any CSV collection that exists in WIPP CI,
select a file from within a CSV collection, and visualize the table 
using the interactive BeakerX tool.

![til](csv_table_demo.gif)