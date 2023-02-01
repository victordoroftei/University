from BST import Node, insertValue, searchValue, inorderTraversal
from main_af import buildAFForFile

separatorsAtoms = [',', ';', '(', ')', '{', '}', '&']
keywords = ["main", "float", "int", "if", "else", "while", "printf", "scanf", "%d", "%f", "cattimp", "executa", "sfcattimp", "struct"]

afStringConstants = buildAFForFile("string")
afVariableNames = buildAFForFile("var")
afIntegerConstants = buildAFForFile("integer")
afRealConstants = buildAFForFile("float")
afOperators = buildAFForFile("op")


def getNumberMapValuesDict():
    numberMapValuesDict = dict()

    numberMapValuesDict["main"] = 2
    numberMapValuesDict["float"] = 3
    numberMapValuesDict["int"] = 4
    numberMapValuesDict["if"] = 5
    numberMapValuesDict["else"] = 6
    numberMapValuesDict["while"] = 7
    numberMapValuesDict["printf"] = 8
    numberMapValuesDict["scanf"] = 9
    numberMapValuesDict["\"%d\""] = 10
    numberMapValuesDict["\"%f\""] = 11
    numberMapValuesDict["cattimp"] = 12
    numberMapValuesDict["executa"] = 13
    numberMapValuesDict["sfcattimp"] = 14

    numberMapValuesDict["++"] = 15
    numberMapValuesDict["--"] = 16
    numberMapValuesDict["=="] = 17
    numberMapValuesDict["="] = 18
    numberMapValuesDict[">="] = 19
    numberMapValuesDict["<="] = 20
    numberMapValuesDict["!="] = 21
    numberMapValuesDict["&&"] = 22
    numberMapValuesDict["||"] = 23
    numberMapValuesDict["+"] = 24
    numberMapValuesDict["-"] = 25
    numberMapValuesDict["*"] = 26
    numberMapValuesDict[";"] = 27
    numberMapValuesDict["("] = 28
    numberMapValuesDict[")"] = 29
    numberMapValuesDict[">"] = 30
    numberMapValuesDict["<"] = 31
    numberMapValuesDict["%"] = 32
    numberMapValuesDict["/"] = 33

    numberMapValuesDict[","] = 34
    numberMapValuesDict["{"] = 35
    numberMapValuesDict["}"] = 36
    numberMapValuesDict["&"] = 37
    numberMapValuesDict["struct"] = 38

    return numberMapValuesDict


def getUniqueAtoms(allLines):
    uniqueAtoms = dict()

    for line in allLines:
        for tup in line:
            atom = tup[1]
            if atom not in uniqueAtoms.keys():
                uniqueAtoms[atom] = tup[2]

    return uniqueAtoms


def parseLine(line, lineIndex):
    line = line.strip()
    atoms = []

    while len(line) > 0:
        if line[0] == " ":
            line = line[1:]

        elif afStringConstants.determinePrefix(line) is not None:
            validSequence = afStringConstants.determinePrefix(line)

            if validSequence in ["\"%d\"", "\"%f\""]:
                atoms.append((lineIndex, validSequence, "Keyword"))
            else:
                atoms.append((lineIndex, validSequence, "CONST"))
            line = line[len(validSequence):]

        elif afVariableNames.determinePrefix(line) is not None:
            validSequence = afVariableNames.determinePrefix(line)

            if validSequence in keywords:
                atoms.append((lineIndex, validSequence, "Keyword"))
            else:
                if len(validSequence) > 250:
                    atoms.append((lineIndex, validSequence, "UNKNOWN"))
                else:
                    atoms.append((lineIndex, validSequence, "ID"))
            line = line[len(validSequence):]

        elif afRealConstants.determinePrefix(line) is not None:
            validSequence = afRealConstants.determinePrefix(line)
            atoms.append((lineIndex, validSequence, "CONST"))
            line = line[len(validSequence):]

        elif afIntegerConstants.determinePrefix(line) is not None:
            validSequence = afIntegerConstants.determinePrefix(line)
            atoms.append((lineIndex, validSequence, "CONST"))
            line = line[len(validSequence):]

        elif afOperators.determinePrefix(line) is not None:
            validSequence = afOperators.determinePrefix(line)
            atoms.append((lineIndex, validSequence, "Operator"))
            line = line[len(validSequence):]

        elif line[0] in separatorsAtoms:
            atoms.append((lineIndex, line[0], "Separator"))
            line = line[1:]

        else:
            atoms.append((lineIndex, line[0], "UNKNOWN"))
            line = line[1:]

    return atoms


def readFromFile(fileName):
    file = open(f"in/{fileName}", "r")
    line = file.readline()
    lineIndex = 1
    allLines = []

    while line:
        allLines.append(parseLine(line, lineIndex))
        line = file.readline()
        lineIndex += 1

    uniqueAtoms = getUniqueAtoms(allLines)
    return allLines, uniqueAtoms


def writeUniqueAtomsToFile(uniqueAtoms, fileName):
    file = open(f"out/{fileName}-atoms", "w")

    for atom in uniqueAtoms.keys():
        file.write(atom + " ~~~ " + uniqueAtoms[atom] + "\n")

    file.close()


def writeTsToFile(tsForPrint, fileName):
    file = open(f"out/{fileName}-ts", "w")

    file.write("Tabela de Simboluri:\n")
    keyList = list(tsForPrint.keys())
    keyList.sort()
    for atom in keyList:
        file.write(f"({atom}; {tsForPrint[atom]})\n")

    file.close()


def writeFipToFile(fip, fileName):
    file = open(f"out/{fileName}-fip", "w")

    file.write("Forma Interna a Programului:\n")
    for fipElem in fip:
        file.write(f"{fipElem}\n")

    file.close()


def writeErrorsToFile(errorDict, fileName):
    file = open(f"out/{fileName}-errors", "w")

    for lineNumber in errorDict:
        file.write(f"Errors on line {lineNumber}: ")
        for err in errorDict[lineNumber]:
            file.write(f"{err} ")
        file.write("\n")

    file.close()


def getAllAtoms(allLines):
    atoms = []

    for line in allLines:
        for tup in line:
            atoms.append(tup[1])

    return atoms


def getErrorDict(allLines):
    errorDict = dict()

    for line in allLines:
        for tup in line:
            if tup[2] == "UNKNOWN":
                if tup[0] not in errorDict.keys():
                    errorDict[tup[0]] = [tup[1]]
                else:
                    errorDict[tup[0]].append(tup[1])

    return errorDict


def __main__():
    fileName = input("Please enter the file name: ")

    allLines, uniqueAtoms = readFromFile(fileName)
    atoms = getAllAtoms(allLines)
    errorDict = getErrorDict(allLines)

    writeUniqueAtomsToFile(uniqueAtoms, fileName)

    if errorDict == {}:

        fip = []
        ts = {}
        currentTsValue = 1000

        numberMap = {}
        numberMapValuesDict = getNumberMapValuesDict()
        current = 39    # 39 is the first "free" value for the numberMap
        for key in uniqueAtoms.keys():
            if uniqueAtoms.get(key) != "ID" and uniqueAtoms.get(key) != "CONST":
                numberMap[key] = numberMapValuesDict[key]
                current += 1
            else:
                if uniqueAtoms.get(key) == "ID":
                    if key not in numberMap.keys():
                        numberMap[key] = 0
                else:
                    if key not in numberMap.keys():
                        numberMap[key] = 1

        rootSet = False
        tsForPrint = dict()
        for atom in numberMap.keys():
            if numberMap.get(atom) == 0 or numberMap.get(atom) == 1:
                if not rootSet:
                    ts = Node(atom, currentTsValue)
                    tsForPrint[atom] = currentTsValue
                    currentTsValue += 1
                    rootSet = True
                else:
                    if searchValue(ts, atom) is None:
                        insertValue(ts, atom, currentTsValue)
                        tsForPrint[atom] = currentTsValue
                        currentTsValue += 1

        print("\nTabela de Simboluri: ")
        inorderTraversal(ts)
        print()

        writeTsToFile(tsForPrint, fileName)

        for atom in atoms:
            if numberMap.get(atom) == 0 or numberMap.get(atom) == 1:
                fip.append([numberMap.get(atom), searchValue(ts, atom).code])
            else:
                fip.append(numberMap.get(atom))

        print("Forma Interna a Programului: ")
        for fipElem in fip:
            print(fipElem)

        writeFipToFile(fip, fileName)

    else:
        for lineNumber in errorDict:
            print(f"Errors on line {lineNumber}: ", end="")
            for err in errorDict[lineNumber]:
                print(err, end=" ")
            print()

        writeErrorsToFile(errorDict, fileName)


__main__()
