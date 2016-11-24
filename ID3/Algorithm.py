#authors: Panchami Rudrakshi, Ranjani Suresh
import math
import random
import copy
import BinaryTreeFormat
import ReadFile

def totalDepth(root,level=0):
    if root == None:
        return 0
    if root.left is None:
        if root.right is None:
            return level
    else:
        return totalDepth(root.left,level+1) + totalDepth(root.right,level+1)

def DT_leaf_nodes(root):
    if root is None:
        return 0
    if root.left is None:
        if root.right is None:
            return 1

    return (DT_leaf_nodes(root.left) + DT_leaf_nodes(root.right))

def ID3Algorithm(trainingValues,inputAttributes,binaryTreeNode,targetAttribute):
    plusCount = 0
    minusCount = 0
    totalRecords = 0
    inputSetToCheckCount = trainingValues.copy()
    for key1 in inputSetToCheckCount:
      if key1 != "tested":
        if inputSetToCheckCount[key1]["class"] == '1':
           plusCount += 1
        else:
           minusCount += 1
        totalRecords += 1

    if plusCount == totalRecords:
        binaryTreeNode.testAttrForCurrentNode = "class"
        binaryTreeNode.label = "+"
        return binaryTreeNode

    elif minusCount == totalRecords:
        binaryTreeNode.testAttrForCurrentNode = "class"
        binaryTreeNode.label = "-"
        return binaryTreeNode

    elif len(trainingValues["tested"]) == len(inputAttributes):
        inputSetToCheckCount = trainingValues.copy()
        plusCount = 0
        minusCount = 0
        for key1 in inputSetToCheckCount:
           if key1 != "tested":
             if inputSetToCheckCount[key1]["class"] == '1':
                plusCount += 1
             else:
                minusCount += 1
        if plusCount > minusCount:
             binaryTreeNode.testAttrForCurrentNode = "class"
             binaryTreeNode.label = "+"
        else:
             binaryTreeNode.testAttrForCurrentNode = "class"
             binaryTreeNode.label = "-"
        return binaryTreeNode

    else:
        resultOfBestAttribute = findBestAttribute(trainingValues,inputAttributes)
        binaryTreeNode.testAttrForCurrentNode = resultOfBestAttribute.decisionAttribute
        binaryTreeNode.dataForPruning = trainingValues.copy()

        if bool(resultOfBestAttribute.leftSet):
            binaryTreeNode.left = BinaryTreeFormat.BinTree()
            ID3Algorithm(resultOfBestAttribute.leftSet,inputAttributes,binaryTreeNode.left,targetAttribute)


        if bool(resultOfBestAttribute.rightSet):
            binaryTreeNode.right = BinaryTreeFormat.BinTree()
            ID3Algorithm(resultOfBestAttribute.rightSet,inputAttributes,binaryTreeNode.right,targetAttribute)

    return binaryTreeNode

'''def findRandomAttribute(inputAttributes):
    return resultAttr'''

def findBestAttribute(inputSet,inputAttributes):
    entropyOfParent = findentropy(inputSet)
    maxGain = 0
    bestAttribute = ""
    testedAttributes = {}
    result = None
    i = 0
    for eachAttribute in inputAttributes:
        if eachAttribute not in testedAttributes.values() and eachAttribute not in inputSet["tested"].values() and eachAttribute != "class":
            currentSet = inputSet.copy()
            leftSet = {}
            rightSet = {}
            leftSetIndex = 0
            rightSetIndex = 0
            for eachSet in currentSet:
                if eachSet != "tested":
                   if currentSet[eachSet][eachAttribute] == "1":
                       leftSet[leftSetIndex] = {}
                       leftSet[leftSetIndex] = currentSet[eachSet].copy()
                       leftSetIndex += 1
                   else:
                       rightSet[rightSetIndex] = {}
                       rightSet[rightSetIndex] = currentSet[eachSet].copy()
                       rightSetIndex += 1
            currentGain = informationGain(entropyOfParent,leftSet,rightSet)
            if maxGain < currentGain:
                result = BestAttributeResult()
                maxGain = currentGain
                bestAttribute = eachAttribute
                result.decisionAttribute = bestAttribute
                result.leftSet = leftSet
                result.rightSet = rightSet
            testedAttributes[i] = eachAttribute
            i += 1

    if not bool(result):
        attrIndex = random.randint(0,len(testedAttributes)-1)
        currentAttribute = testedAttributes[attrIndex]
        currentSet = inputSet.copy()
        leftSet = {}
        rightSet = {}
        leftSetIndex = 0
        rightSetIndex = 0
        result = BestAttributeResult()
        for eachSet in currentSet:
            if eachSet != "tested":
                if currentSet[eachSet][currentAttribute] == "1":
                    leftSet[leftSetIndex] = {}
                    leftSet[leftSetIndex] = currentSet[eachSet].copy()
                    leftSetIndex += 1
                else:
                    rightSet[rightSetIndex] = {}
                    rightSet[rightSetIndex] = currentSet[eachSet].copy()
                    rightSetIndex += 1
        result.decisionAttribute = currentAttribute
        result.leftSet = leftSet
        result.rightSet = rightSet

    if bool(result.leftSet):
        result.leftSet["tested"] = inputSet["tested"].copy()
        result.leftSet["tested"][len(result.leftSet["tested"])] = result.decisionAttribute
    if bool(result.rightSet):
        result.rightSet["tested"] = inputSet["tested"].copy()
        result.rightSet["tested"][len(result.rightSet["tested"])] = result.decisionAttribute

    return result


def findentropy(inputValues):

    pos = 0
    neg = 0

    copyInput = inputValues.copy()
    for key1 in copyInput:
        if key1 != "tested":
          if int(inputValues[key1]["class"]) == 1:
              pos += 1
          else:
              neg += 1

    ppos = float(pos) / float(pos+neg)
    pneg = float(neg) / float(pos+neg)

    if ppos == 0 or pneg == 0:
        return 0.0

    return -ppos*math.log10(ppos) - pneg*math.log10(pneg)


def informationGain(parentSetEntropy,leftSet,rightSet):
    leftCount = findProportion(leftSet)
    rightCount = findProportion(rightSet)
    leftSetEntropy = rightSetEntropy = 0
    if bool(leftSet):
     leftSetEntropy = findentropy(leftSet)
    if bool(rightSet):
     rightSetEntropy = findentropy(rightSet)

    return float(parentSetEntropy) - (float(leftCount) / float(leftCount+rightCount))*float(leftSetEntropy) - (float(rightCount) / float(leftCount+rightCount))*float(rightSetEntropy)


def findProportion(inputSet):
    count = 0

    copyInput = inputSet.copy()
    for key1 in copyInput:
        if key1 != "tested":
          count += 1

    return count

class BestAttributeResult:
    decisionAttribute = ""
    leftSet = {}
    rightSet = {}

def findClassWithDecisionTree(dTree, eachSet):
    if bool(dTree):
      if str(dTree.testAttrForCurrentNode) == "class":
          if dTree.label == "+":
             return 1
          else:
             return 0
      elif eachSet[str(dTree.testAttrForCurrentNode)] == "1":
          return findClassWithDecisionTree(dTree.left, eachSet)
      else:
          return findClassWithDecisionTree(dTree.right, eachSet)
    else:
      return 0


def accuracyFind(decisionTree, validationSet):
    positiveCount = 0
    totalCount = 0
    for eachSet in validationSet:
        if eachSet != "tested":
          actualClass = validationSet[eachSet]["class"]
          predictedClass = findClassWithDecisionTree(decisionTree, validationSet[eachSet])
          if str(predictedClass) == str(actualClass):
              positiveCount += 1
          totalCount += 1

    return ( float(positiveCount) / float(totalCount) ) * 100.0

def collectAllNodes(tempNode, arrayOfNodes):
    if bool(tempNode):
      if tempNode.testAttrForCurrentNode != "class":
          arrayOfNodes.append(tempNode)
          collectAllNodes(tempNode.left, arrayOfNodes)
          collectAllNodes(tempNode.right, arrayOfNodes)

def pruningAlgorithm(decisionTree,K,validation_filename):
   bestDecisionTree = copy.deepcopy(decisionTree)
   testFile = ReadFile.readfile(validation_filename)
   maxAccuracyWithID3 = accuracyFind(decisionTree, testFile.trainingValues)
   print("Accuracy with ID3 DT against Test set: ")
   print(str(maxAccuracyWithID3))

   pruneDecisionTree = copy.deepcopy(decisionTree)
   arrayOfNodes = []
   collectAllNodes(pruneDecisionTree, arrayOfNodes)
   j = 0
   while j < K:
       N = len(arrayOfNodes)
       P = random.randint(0,N-1)
       pCnt = 0
       nCnt = 0
       arrayOfNodes[P].left = BinaryTreeFormat.BinTree()
       arrayOfNodes[P].right = BinaryTreeFormat.BinTree()
       arrayOfNodes[P].left.testAttrForCurrentNode = "class"
       arrayOfNodes[P].right.testAttrForCurrentNode = "class"

       for eachSet in arrayOfNodes[P].dataForPruning:
           if eachSet != "tested":
             if arrayOfNodes[P].dataForPruning[eachSet]["class"] == "1":
                 pCnt += 1
             else:
                 nCnt += 1

       if pCnt > nCnt:
        arrayOfNodes[P].left.label = "+"
        arrayOfNodes[P].right.label = "+"
       else:
        arrayOfNodes[P].left.label = "-"
        arrayOfNodes[P].right.label = "-"
       j += 1

   currentTreeAccuracy = accuracyFind(pruneDecisionTree, testFile.trainingValues)
   print("Accuracy after Pruning against Test set: ")
   print(currentTreeAccuracy)
   print("Number of nodes in a pruned tree:")
   print(DT_size(pruneDecisionTree,count=0))
   print("Number of Leaf nodes in a pruned tree:")
   print(DT_leaf_nodes(pruneDecisionTree))
   '''print("Average depth: ")
   average = float(totalDepth(pruneDecisionTree,level=0)) / float(DT_leaf_nodes(pruneDecisionTree))
   print(average)'''

   if maxAccuracyWithID3 < currentTreeAccuracy:
       maxAccuracyWithID3 = currentTreeAccuracy
       print("Overfitting deducted: Tree interchanged")
       bestDecisionTree = copy.deepcopy(pruneDecisionTree)

   return bestDecisionTree

def maxDepth(root):
    if root == None:
        return 0
    return max(maxDepth(root.left),maxDepth(root.right))+1

def DT_size(root, count = 0):
    if root is None:
        return count

    return DT_size(root.left, DT_size(root.right, count + 1))

