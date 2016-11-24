Code is developed using Python.
Authors: Panchami Rudrakshi, Ranjani Suresh

Question: Implementation of ID3 algorithm
Build a binary decision tree classifier using the ID3 algorithm
• The program reads three arguments from the command line – complete path of the training dataset, complete path of the test dataset, and the pruning factor 
• The datasets can contain any number of Boolean attributes and one Boolean class label. The class label will always be the last column.
• The first row will define column names and every subsequent non-blank line will contain a data instance. If there is a blank line, your program should skip it.
• After reading each data instance, it should be incorporated into the tree. This could mean adding more nodes, increasing the depth of the tree, updating the leaf labels, etc.

Files used:
1) Algorithm.py - code for implementing ID3 algorithm
2) BestAttributeResult.py - code to define features of the best attribute
3) BinaryTreeFormat.py - code to construct the tree for the original and pruned data
4) MainFile.py - code of the driver program
5) ReadFile.py - code to read the training and testing data

To execute the program, three arguments are given as a part of the scripts – the pruning factor, path of the training dataset, path of the test dataset
Pruning factor used = 2

Command:
python MainFile.py 2 train2-win.dat test2-win.dat

No additional assumptions are made.

Accomplishment and learning:
Implementation of ID3 algorithm and building a binary decision tree classifier for the given data set.
Analysing accuracy for the original data.
Analysing accuracy after pruning the tree.
Finding the number of nodes and leafes in the original and pruned tree.

