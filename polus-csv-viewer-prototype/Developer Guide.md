# Developer's Guide
This tool converts selected CSV files from WIPP CSV collections to 
Pandas dataframes, and displays an interactive table with BeakerX.

## Quick Reference
Here are the basic steps you need to set up the code

## Build 
Before running the code, run the following commands in the terminal from 
within JupyterLab:

* `jupyter labextension install @jupyter-widgets/jupyterlab-manager`
* `jupyter labextension install beakerx-jupyterlab`
* `pip install py4j`
* `pip install beakerx==1.4.1`
* `beakerx install`

These enable the BeakerX ipywidget to work in JupyterLab.

## Run the Program
To run the code directly from JupyterLab, clone the Wippy API
from GitHub. Next, save `CsvViewerTool.ipynb` to the first `wippy` 
folder from within your workspace directory. 

Locate the function `get_wipp_csvs()`. If you are deploying from 
JupyterLab CI, no modifications are needed. However, if you are 
deploying from JupyterLab QA, uncomment the following line:
`#wipp_api_url = 'http://wipp-ui.test.aws.labshare.org/api/' #: QA`

From there, save the change and view the application by selecting 
`View`>`Open with Voila in New Browser Tab` from the JupyterLab GUI.

You will be able to select any CSV collection that exists in WIPP CI,
select a file from within a CSV collection, and visualize the table 
using the interactive BeakerX tool.

![til](csv_table_demo.gif)