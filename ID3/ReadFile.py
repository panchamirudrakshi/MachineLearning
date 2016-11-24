#authors: Panchami Rudrakshi, Ranjani Suresh
def readfile(fileName):
    trainingValues = {}
    trainingFile = open(fileName, "r")
    fLine = trainingFile.readline()
    attributes = fLine[:-1].split('	')
    lineNumber = 0
    for line in trainingFile:
        eachLine = line[:-1].split('	')
        i = 0
        trainingValues[lineNumber] = {}
        while i < len(attributes):
            trainingValues[lineNumber][str(attributes[i])] = eachLine[i]
            i += 1
        lineNumber += 1
    trainingValues["tested"] = {}
    fileResult = TrainingFileResult()
    fileResult.trainingValues = trainingValues
    fileResult.attributes = attributes
    return fileResult

class TrainingFileResult:
    trainingValues = {}
    attributes = ""
