THE RCSP Matlab Toolbox version 0.1

This toolbox contains Matlab code to use and explore
(Regularized) Common Spatial Patterns (CSP) algorithms for EEG classification
and Brain-Computer Interfaces, as described in the following paper:

F. Lotte, C.T. Guan, "Regularizing Common Spatial Patterns to Improve BCI Designs: Unified Theory and New Algorithms", IEEE Transactions on Biomedical Engineering, 2010

The directories in this toolbox are the following:

CSP_Algorithms:

Contain all the matlab code of each (Regularized) CSP algorithm described in the paper above.
This is essentially what you are looking for :-)

EEG_Data:

If you want to reproduce the results in the paper, you should download the BCI competition
data sets (http://www.bbci.de/competition/iii/ and http://www.bbci.de/competition/iv/), unzip them if needed, and copy each data set into the corresponding subdirectory in the "OriginalData" directory (located itself in "EEG_data")
The data sets used are:
- BCI competition III data IIIa
- BCI competition III data IVa
- BCI competition IV data IIa

Evaluations:

the code to reproduce the paper result.
Read the function header for details on how to use it

GeneratedData:

TO store some data that you may want to generate (performances, topographies, etc.), 
especially if you ran the code in Evaluations

LDA_Classification:

Matlab code for an LDA (Linear Discriminant Analysis) classifier.

Paper:

The PDF of the paper mentioned above

Utilities:

Various small but useful matlab code (e.g., to display filter topographies)

This toolbox is distributed under the open source GPL license.

if you use this code for a publication, please cite the paper mentioned above.

Feedback is welcome. If you have any question or comment please e-mail me: fabien.lotte@gmail.com