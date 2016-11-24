#authors: Panchami Rudrakshi, Ranjani Suresh
import sys
import ReadFile
import Algorithm
import BinaryTreeFormat
PruneValue = int(sys.argv[1])
training_filename=str(sys.argv[2]) ;
test_filename=str(sys.argv[3]);
fileResult = ReadFile.readfile(training_filename)
#validationFile = ReadFile.readfile(validation_filename)
targetAttribute = fileResult.attributes[-1]
del(fileResult.attributes[-1])
root = Algorithm.ID3Algorithm(fileResult.trainingValues, fileResult.attributes, BinaryTreeFormat.BinTree(), targetAttribute)

def maxDepth(root):
    if root == None:
        return 0
    return max(maxDepth(root.left),maxDepth(root.right))+1

def totalDepth(root,level=0):
    if root == None:
        return 0
    if root.left is None:
        if root.right is None:
            return level
    else:
        return totalDepth(root.left,level+1) + totalDepth(root.right,level+1)
'''def totalDepth(root,accumulated=0,depth=0):
    if root == None:
        return 0
    if root.left is None:
        if root.right is None:
            accumulated += depth
    depth += 1
    totalDepth(root.right,accumulated,depth)
    return totalDepth(root.left,accumulated,depth)'''
'''print(maxDepth(root))'''
def DT_size(root, count = 0):
    if root is None:
        return count

    return DT_size(root.left, DT_size(root.right, count + 1))

def DT_leaf_nodes(root):
    if root is None:
        return 0
    if root.left is None:
        if root.right is None:
            return 1

    return (DT_leaf_nodes(root.left) + DT_leaf_nodes(root.right))

print("Number of nodes in a DT:")
print(DT_size(root,count=0))
print("Number of leaf nodes in a DT:")
print(DT_leaf_nodes(root))
bestDecisionTree = Algorithm.pruningAlgorithm(root, PruneValue, test_filename)

def printTree(tempNode,spaceVal):
    if bool(tempNode):
     if tempNode.testAttrForCurrentNode == "class":
         if str(tempNode.label) == "+":
             print(str(spaceVal) + " : 1")
         else:
             print(str(spaceVal) + " : 0")
         return
     print(str(spaceVal)+str(tempNode.testAttrForCurrentNode)+str(" : 1"))
     printTree(tempNode.left,spaceVal+" | ")
     print(str(spaceVal)+str(tempNode.testAttrForCurrentNode)+str(" : 0"))
     printTree(tempNode.right,spaceVal+" | ")

print("\n")
printTree(root,"")
print("\nDecision Tree Built Successfully")