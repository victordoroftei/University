fipDict = dict()
fipDict["ID"] = 0
fipDict["ID_SIMPLU"] = 0
fipDict["CONST_STRING"] = 1
fipDict["CONST_INT"] = 1
fipDict["CONST_FLOAT"] = 1
fipDict["INT"] = 2
fipDict["FLOAT"] = 3
fipDict["MAIN"] = 4
fipDict["IF"] = 5
fipDict["ELSE"] = 6
fipDict["WHILE"] = 7
fipDict["CIN"] = 8
fipDict["COUT"] = 9
fipDict["STRUCT"] = 10
fipDict["OP_INP"] = 11
fipDict["OP_OUT"] = 12
fipDict["PLUS"] = 13
fipDict["MINUS"] = 14
fipDict["INMUL"] = 15
fipDict["DIV"] = 16
fipDict["MOD"] = 17
fipDict["AND"] = 18
fipDict["OR"] = 19
fipDict["MIC"] = 20
fipDict["MARE"] = 21
fipDict["DIFERIT"] = 22
fipDict["EGAL_EGAL"] = 23
fipDict["EGAL"] = 24
fipDict["PD"] = 25
fipDict["PI"] = 26
fipDict["AD"] = 27
fipDict["AI"] = 28
fipDict["PV"] = 29
fipDict["VIRGULA"] = 30
fipDict["CATTIMP"] = 31
fipDict["EXECUTA"] = 32
fipDict["SFCATTIMP"] = 33


def convertToFipValue(fileName):
    file = open(fileName, "r")
    lines = file.readlines()
    file.close()

    newLines = []
    for line in lines:
        for k in fipDict.keys():
            line = line.replace(k, str(fipDict[k]))
        newLines.append(line)

    outputFile = open(fileName + "-out.txt", "w")
    for line in newLines:
        outputFile.write(line)
    outputFile.close()


convertToFipValue("input/specificare.txt")
