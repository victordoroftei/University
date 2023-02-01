import re

from BST import Node, insertValue, searchValue, inorderTraversal

separators = [' ', ',', ';', '(', ')', '{', '}', '=', '+', '/', '%', '*', '-', '&', '|', '<', '>', '!']
separatorsAtoms = [',', ';', '(', ')', '{', '}', '&']
algebraicOperators = ['+', '-', '*', '/', '%', '=']
relationalOperators = ['>=', '==', '!=', '<=', '>', '<']
booleanOperators = ['&&', '||']
keywords = ["main", "float", "int", "if", "else", "while", "printf", "scanf", "%d", "%f"]
stringConstantRegex = "^\"[^\"]*\"$"
zeroConstantRegex = "^0$"
numericConstantRegex = "^[1-9][0-9]*$"
realConstantRegexes = ["^[1-9]+\.[0-9]+$", "^0\.[0-9]+$"]
variableNameRegexes = ["^[a-zA-Z]+$", "^[a-zA-Z]+\.[a-zA-Z]+$"]

stringConstantPossibleLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789, "


def writeToFile(fileName, atoms):
    if type(atoms) == list:
        f = open("out/" + fileName, 'w')
        f.write("")
        f.close()

        f = open("out/" + fileName, 'a')
        for atom in atoms:
            f.write(atom + "\n")

        f.close()

    elif type(atoms) == dict:
        f = open("out/" + fileName + "-type", 'w')
        f.write("")
        f.close()

        f = open("out/" + fileName + "-type", 'a')
        for k, v in atoms.items():
            f.write(k + " ~~~ " + v + "\n")

        f.close()


def atomType(atom):
    if atom in separatorsAtoms:
        return "Separator"
    elif atom in keywords:
        return "Keyword"
    elif atom in algebraicOperators:
        return "Algebraic Operator"
    elif atom in relationalOperators:
        return "Relational Operator"
    elif atom in booleanOperators:
        return "Boolean Operator"
    elif re.match(stringConstantRegex, atom):
        for i in range(1, len(atom) - 1):
            ch = atom[i]
            if ch not in stringConstantPossibleLetters:
                return "INCORRECT"
        return "CONST"
    elif re.match(realConstantRegexes[0], atom) or re.match(realConstantRegexes[1], atom) or re.match(numericConstantRegex, atom) or re.match(zeroConstantRegex, atom):
        return "CONST"
    elif re.match(variableNameRegexes[0], atom) or re.match(variableNameRegexes[1], atom):
        if len(atom) > 250:
            return "INCORRECT"
        else:
            return "ID"
    else:
        return "UNKNOWN"


def getAtoms():
    fileName = input("Choose file: ")
    outputFileName = fileName + "-out"
    inputFile = open("in/" + fileName, 'r')

    separatedContent = ""

    line = inputFile.readline()
    lineIndex = 1
    while line:
        i = 0
        while i < len(line):
            ch = line[i]

            if ch == '&' and line[i + 1] == '&':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '!' and line[i + 1] == '=':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '>' and line[i + 1] == '=':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '<' and line[i + 1] == '=':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '|' and line[i + 1] == '|':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '=' and line[i + 1] == '=':
                separatedContent += '\n' + ch + line[i + 1] + '\n'
                i += 1

            elif ch == '"' and (line[i + 1] == '%' and (line[i + 2] == 'd' or line[i + 2] == 'f')):
                separatedContent += '\n' + line[i + 1] + line[i + 2] + '\n'
                i += 4

            elif ch == '"' and not (line[i + 1] == '%' and (line[i + 2] == 'd' or line[i + 2] == 'f')):
                stringConstant = '"'
                j = i + 1

                while line[j] != '"':
                    stringConstant += line[j]
                    j += 1
                stringConstant += '"'
                separatedContent += '\n' + stringConstant + '\n'
                i = j

            elif ch in separators:
                separatedContent += '\n' + ch + '\n'

            else:
                separatedContent += ch

            i += 1

        line = inputFile.readline()
        lineIndex += 1

    rawList = separatedContent.split('\n')
    refinedList = []
    for el in rawList:
        if el != ' ' and el != '':
            refinedList.append(el)

    atoms = list()
    for el in refinedList:
        if el == '!':
            atoms.append(el + '=')
        else:
            atoms.append(el)

    atomDict = {}
    for atom in atoms:
        if atom not in atomDict.keys():
            atomDict[atom] = atomType(atom)

    inputFile = open("in/" + fileName, 'r')
    linesList = []
    line = inputFile.readline()
    lineIndex = 1

    while line:
        linesList.append((line, lineIndex))
        lineIndex += 1
        line = inputFile.readline()

    errorDict = {}
    for ad in atomDict.keys():
        if atomDict[ad] == "INCORRECT" or atomDict[ad] == "UNKNOWN":
            for tup in linesList:
                if ad in tup[0]:
                    if tup[1] not in errorDict.keys():
                        errorDict[tup[1]] = [ad]
                    else:
                        errorDict[tup[1]].append(ad)
                    break

    writeToFile(outputFileName, atoms)
    writeToFile(outputFileName, atomDict)

    return errorDict, fileName


def readFromAtomsFile(filePath):
    file = open(filePath, 'r')
    atoms = []

    line = file.readline()
    while line:
        atoms.append(line.strip('\n'))
        line = file.readline()

    return atoms


def readFromAtomDictFile(filePath):
    file = open(filePath, 'r')
    atomDict = {}

    line = file.readline()
    while line:
        lineContent = line.strip('\n').split(" ~~~ ")
        atomDict[lineContent[0]] = lineContent[1]
        line = file.readline()

    return atomDict


def __main__():
    fip = []
    ts = {}
    currentTsValue = 1000

    errorDict, fileName = getAtoms()
    atoms = readFromAtomsFile("out/" + fileName + "-out")
    atomDict = readFromAtomDictFile("out/" + fileName + "-out-type")

    numberMap = {}
    current = 2
    for key in atomDict.keys():
        if atomDict.get(key) != "ID" and atomDict.get(key) != "CONST":
            numberMap[key] = current
            current += 1
        else:
            if atomDict.get(key) == "ID":
                if key not in numberMap.keys():
                    numberMap[key] = 0
            else:
                if key not in numberMap.keys():
                    numberMap[key] = 1

    rootSet = False
    for atom in numberMap.keys():
        if numberMap.get(atom) == 0 or numberMap.get(atom) == 1:
            if not rootSet:
                ts = Node(atom, currentTsValue)
                currentTsValue += 1
                rootSet = True
            else:
                if searchValue(ts, atom) is None:
                    insertValue(ts, atom, currentTsValue)
                    currentTsValue += 1

    print("\nTabela de simboluri: ")
    inorderTraversal(ts)
    print()

    if errorDict == {}:
        for atom in atoms:
            if numberMap.get(atom) == 0 or numberMap.get(atom) == 1:
                fip.append([numberMap.get(atom), searchValue(ts, atom).code])
            else:
                fip.append(numberMap.get(atom))

        print("Forma Interna a Programului: ", fip)
    else:
        for error in errorDict.keys():
            print(f"Errors on line {error}: ", end="")
            for e in errorDict[error]:
                print(f"{e} ", end="")
            print()


__main__()
