#: Future instance will have libraries pre-loaded into the node:
#!jupyter labextension install @jupyter-widgets/jupyterlab-manager
#!jupyter labextension install beakerx-jupyterlab
#!pip install py4j
#!pip install beakerx==1.4.1
#!beakerx install

import argparse
from beakerx import *
from beakerx.object import *
from ipywidgets import widgets
import ipywidgets as widgets
from IPython.display import display
from IPython.display import clear_output
import logging
import logging.config
import numpy as np
import pandas as pd
import pathlib
from pathlib import Path
import time
import warnings
warnings.filterwarnings('ignore')
import webbrowser
import wippy

"""This is the basic order in which the functions are run:
get_wipp_csvs(): Access WIPP CI WippPy API to view CSV collection names
on_collection_clicked(): Make file selection box for selected collection
display_widgets(): Displays all ipywidgets
_create_widgets(): Make widget to select file from collection
_on_file_clicked(): Display the selected CSV file as a beakerx table

"""
class BeakerXTable():

    def __init__(self, file_list: str, file_widget):
        """Set the logger and view filenames in file_list ending in csv

        Args:
            file_list: Path to shared folder CSV files
            file_widget: Combobox widget that holds CSV files
        """
        
        #: Set up the logger
        logging.basicConfig()
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.CRITICAL)
        
        #: Store all CSVs in list
        files = Path(file_list).glob('*.csv') 
        self.filenames = [file for file in files]
        self.file_dict = {}
        self.df_names = pd.DataFrame()
        self.sel_file = file_widget

    def _create_widgets(self):
        """Make ComboBox widget to select file from CSV collection
        
        After a CSV collection is selected, a widget is created to allow
        the user to select a CSV file from within that collection. A
        dataframe of file basenames and full Posix filepaths is created,
        so that the user can view only the basename but later the file
        can be opened using the associated full path.
        """
        
        #: Create df of csv filenames and corresponding full Posix path
        df_files = [file for file in self.filenames]
        self.df_names["PosixName"] = df_files
        self.df_names["Stem"] = self.df_names["PosixName"].apply(
            lambda x: x.name)
        
        #: List file basenames from csv collection and display in widget
        filenames_stem = [file.name for file in self.filenames]
        self.sel_file.options=filenames_stem
        self.sel_file.placeholder="Choose a CSV file"
        
        #: Generate a new BeakerX interactive table
        self.sel_file.observe(self._on_file_clicked, 'value')

        
    def _on_file_clicked(self, change):
        """Display the selected CSV file as a beakerx table"""

        #: Clear table that is displayed, if any
        self.out.clear_output() 
        self.file_df_dict = {}

        with self.out:
            #: Get full path for selected file by using df_names df
            csv_full_file_path = self.df_names["PosixName"]\
                [self.df_names["Stem"] == self.sel_file.value].iloc[0]
            df = pd.read_csv(csv_full_file_path)
            
            # Check if first pandas row contains only "F" or "C"
            if df.size > 0:
                test = df.iloc[0].isin(["F","C"]).all()

                # If so, delete first row and convert datatype to float
                if test == True:
                    df = df.iloc[1:]
                    df = df.astype('float64', errors='raise')

            #: Display dataframe of selected csv file as BeakerX table
            beakerx_table = TableDisplay(df)
            beakerx_table.loadingMode = 'ENDLESS' 
            display(HBox([beakerx_table]))
                
    def display_widgets(self):
        """Display ComboBox for selecting files"""

        self._create_widgets()

        #:This is the output widget in which the df is displayed
        self.out = widgets.Output()  

        #: List widgets to be displayed
        display(VBox([self.out]))

def get_wipp_csvs():
    """Access WIPP CI WippPy API to view CSV collection names

    Be sure to change wipp_api_url accordingly, depending on
    whether you are using the CI or QA deployment of JupyterLab.

    Returns:
        Dict: Dict of image collection unique ids and names
    """
    #: Set logging level for more details (DEBUG, INFO, WARNING)
    wippy.logger.setLevel(logging.WARNING)

    #: URL to WIPP API
    wipp_api_url = 'http://wipp-ui.ci.aws.labshare.org/api/' #: CI
    #wipp_api_url = 'http://wipp-ui.test.aws.labshare.org/api/' #: QA

    wippy.WippData.setWippUrl(wipp_api_url)

    #: Return dict of image collection unique ids and names
    return wippy.WippCsvCollection.all()

def on_collection_clicked(*args):
    """When change in collections widget detected, make next widget.
    """
    file_widget.index = None

    #: Clear output
    output.clear_output()
    logging.basicConfig()
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG) 

    with output:
        if __name__=="__main__":
            cid = ""
            id_csvname_dict = get_wipp_csvs()
            for each_id, each_csvname in id_csvname_dict.items():
                id_csvname_dict[each_id] = str(each_csvname).split()[0]
            for each_id, each_csvname in id_csvname_dict.items():
                if args[0]['new'] == each_csvname:
                    cid = each_id
            p = pathlib.Path("../../shared/wipp/csv-collections/")
            if not p.is_dir():
                logger.error("The csv-collections directory does not exist in JupyterLab")
            elif p.is_dir():
                subdirectories = [x.name for x in p.iterdir() if x.is_dir()]

                if cid in subdirectories: 

                    #: Define the path
                    pathlib_directory = pathlib.Path(
                        "../../shared/wipp/csv-collections") / cid
                    show_files = BeakerXTable(pathlib_directory, file_widget)
                    show_files.display_widgets()

                elif cid not in subdirectories:
                    logger.error("Selected CSV collection not found in JupyterLab.")
                    logger.error(args[0])

                else:
                    logger.critical("Unknown error.")  

id_csvname_dict = get_wipp_csvs()
for each_id, each_csvname in id_csvname_dict.items():
    each_csvname = str(each_csvname).split()[0]
    id_csvname_dict[each_id] = each_csvname

csv_collection_widget = widgets.Combobox(
    placeholder='Choose a CSV collection',
    options=list(id_csvname_dict.values()), #: CSV collection names
    description='Collection: ',
    ensure_option=True,
    disabled=False,
    layout=widgets.Layout(width='550px', height='40px')
)

file_widget = widgets.Combobox(
    placeholder='Choose a CSV collection first',
    options=[], #: Collection file names will go here
    description='Files: ',
    ensure_option=True,
    disabled=False,
    layout=widgets.Layout(width='550px', height='40px')
    )

output = widgets.Output()

display(widgets.HBox(
    [widgets.VBox([csv_collection_widget]), widgets.VBox([file_widget])]))
display(widgets.VBox([output]))
csv_collection_widget.observe(on_collection_clicked, 'value')