@authors: Panchami Rudrakshi, Ranjani Suresh

Question: Modification of ID3 Algorithm
Instead of using the ID3 algorithm to choose which attribute to select for splitting the data at each node, write a method that randomly picks attributes for each node. 
Construct a new tree using random selection of attributes and compare the performance (in terms of accuracy) of the tree constructed using this approach to the one constructed 
using ID3. You need to compare the trees without pruning.

Code is developed using Python, To execute the program, use the following command 

python MainFile.py 2 train2-win.dat test2-win.dat 0(or) 1 [based on which algorithm 0- Random 1-ID3]

Result:
Average Depth	- Number of Nodes
Tree constructed using ID3	7	- 213
Tree constructed using random attribute selection	7 -	234


Accuracy: 
Run- Accuracy of the tree constructed using random selection
1	69.0
2	74.0
3	72.0
4	76.0
5	76.0

	
