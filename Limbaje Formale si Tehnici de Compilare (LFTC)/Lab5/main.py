from copy import deepcopy

separator = "-"
terminalsSeparator = " "

parsedGrammar = dict()
nonterminals = []
terminals = []
startNode = None
indexMap = dict()

first1 = dict()
follow1 = dict()
table = dict()
isLL1 = True


def createRightPartOfRule(rule):
    string = ""

    for r in rule:
        string += f"{r}"

    return string


def createFullRule(nonterminal, rule):
    string = f"{nonterminal}-"

    for r in rule:
        string += f"{r} "

    return string.strip(" ")


def parseFile(fileName):
    global terminals
    global startNode

    file = open(fileName, "r")
    lines = file.readlines()
    file.close()

    startNode = lines[0].strip()

    for i in range(1, len(lines)):
        line = lines[i]
        currentLine = line.strip().split(separator)

        indexMap[line.strip()] = i

        leftPart = currentLine[0].strip()

        if leftPart not in nonterminals:
            nonterminals.append(leftPart)
            terminals = [x for x in terminals if x != leftPart]

        rightPart = currentLine[1].split(terminalsSeparator)
        for rp in rightPart:
            if rp not in terminals and rp not in nonterminals:
                terminals.append(rp)

        if leftPart not in parsedGrammar.keys():
            parsedGrammar[leftPart] = [rightPart]
        else:
            parsedGrammar[leftPart].append(rightPart)


def calculateFirst1():
    global first1

    f0 = dict()
    for nt in parsedGrammar.keys():
        f0[nt] = []
        rules = parsedGrammar[nt]
        for rule in rules:
            firstFromRule = rule[0]
            if firstFromRule in terminals:
                if firstFromRule not in f0[nt]:
                    f0[nt].append(firstFromRule)

    currentF = dict()
    previousF = f0
    hasChanged = True
    while hasChanged:
        hasChanged = False
        currentF = deepcopy(previousF)
        for nt in parsedGrammar.keys():
            rules = parsedGrammar[nt]
            for rule in rules:
                firstFromRule = rule[0]
                if firstFromRule in nonterminals:
                    for elem in previousF[firstFromRule]:
                        if elem != '#':
                            if elem not in currentF[nt]:
                                currentF[nt].append(elem)
                                hasChanged = True
                        else:
                            nonTerminalsCount = 0
                            for pos in range(1, len(rule)):
                                if rule[pos] in terminals:
                                    if rule[pos] not in currentF[nt]:
                                        currentF[nt].append(rule[pos])
                                        hasChanged = True
                                    break
                                else:
                                    ntFirst = previousF[rule[pos]]
                                    for e in ntFirst:
                                        if e != '#':
                                            if e not in currentF[nt]:
                                                currentF[nt].append(e)
                                                hasChanged = True

                                    if '#' not in ntFirst:
                                        break

                                    nonTerminalsCount += 1

                            if nonTerminalsCount == len(rule) - 1:  # daca avem doar neterminali in dreapta
                                if '#' not in currentF[nt]:
                                    currentF[nt].append('#')
                                    hasChanged = True

        previousF = deepcopy(currentF)

    first1 = deepcopy(currentF)


def calculateFollow1():
    global follow1

    follow1[startNode] = ['$']

    for nt in nonterminals:
        if nt != startNode:
            follow1[nt] = []

    hasChanged = True
    while hasChanged:
        hasChanged = False

        for nt in parsedGrammar.keys():
            rules = parsedGrammar[nt]
            for rule in rules:
                for i in range(0, len(rule)):
                    atom = rule[i]  # atom = B
                    if atom in nonterminals:
                        if i == len(rule) - 1:
                            beta = '#'
                        else:
                            beta = rule[i + 1]

                        if beta in terminals or beta == '#':
                            firstBeta = [beta]
                        else:
                            firstBeta = first1[beta]

                        for fb in firstBeta:
                            if fb != '#' and fb not in follow1[atom]:
                                follow1[atom].append(fb)
                                hasChanged = True

                        if beta == '#' or '#' in firstBeta:
                            followA = follow1[nt]
                            for fa in followA:
                                if fa not in follow1[atom]:
                                    follow1[atom].append(fa)
                                    hasChanged = True


def calculateLL1Table():
    global table

    # Map<Tuple, List<Tuple/String>>
    # None -> error
    # M(X, a), X - terminal or non-terminal, a - terminal
    # X = a -> pop
    # X = $, a = $ -> acc

    for X in nonterminals + terminals + ['$']:
        for a in terminals + ['$']:
            if X != '#' and a != '#':
                table[(X, a)] = []
                if X == a:
                    table[(X, a)] = ["pop"]

                if X == '$' and a == '$':
                    table[(X, a)] = ["acc"]

    for k in table.keys():
        X, a = k[0], k[1]

        if X in nonterminals:
            rules = parsedGrammar[X]
            for rule in rules:
                atom = rule[0]
                if atom in terminals:
                    firstAtom = [atom]
                else:
                    firstAtom = first1[atom]

                if a in firstAtom or ('#' in firstAtom and a in follow1[X]):
                    #rightPart = createRightPartOfRule(rule)
                    rightPart = rule
                    i = indexMap[createFullRule(X, rule)]
                    if (rightPart, i) not in table[k]:
                        table[k].append((rightPart, i))

    for k in table.keys():
        if len(table[k]) == 0:  # daca celula e goala -> err
            table[k] = ["err"]


def checkIfLL1():
    global isLL1

    for k in table.keys():
        if len(table[k]) >= 2:
            print("Error! ", table[k])
            isLL1 = False


def runLL1Algorithm(sequence):
    inputStack = ['$']
    for atom in reversed(sequence):
        if atom not in terminals:
            return []

        inputStack.append(atom)

    workStack = ['$', startNode]
    ruleList = []

    while not (inputStack == ['$'] and workStack == ['$']):
        currentInput = inputStack[-1]
        currentWork = workStack[-1]

        print(f"({list(reversed(inputStack))}, {list(reversed(workStack))}, {ruleList})")

        if currentWork == currentInput:  # pop case
            inputStack.pop()
            workStack.pop()

        else:
            tableKey = (currentWork, currentInput)
            tableValue = table[tableKey]
            if tableValue == ["err"]:
                return []

            else:
                workStack.pop()

                ruleList.append(table[tableKey][0][1])
                rightPart = table[tableKey][0][0]

                for rp in reversed(rightPart):
                    if rp != '#':
                        workStack.append(rp)

    print(f"({list(reversed(inputStack))}, {list(reversed(workStack))}, {ruleList})")
    return ruleList


def printFirst1():
    print("First1 for each non terminal in our grammar:")
    for nt in first1.keys():
        print(nt + ": ", end="")
        for first in first1[nt]:
            print(first + " ", end="")
        print()


def printFollow1():
    print("Follow1 for each non terminal in our grammar:")
    for nt in follow1.keys():
        print(nt + ": ", end="")
        for follow in follow1[nt]:
            print(follow + " ", end="")
        print()


def printLL1Table():
    print("The LL(1) table is:")
    for k in table:
        print(k, table[k])


def readSequenceFromFile(sequenceFile):
    file = open("input/" + sequenceFile, "r")
    lines = file.readlines()
    file.close()

    sequence = []
    for line in lines:
        if line[0] == "[":
            atoms = [line[1]]
        else:
            atoms = line.strip().split(terminalsSeparator)

        sequence += atoms

    return sequence


def menu():
    fileName = input("Insert the input grammar file name: ")
    fileName = "input/" + fileName

    parseFile(fileName)

    calculateFirst1()
    printFirst1()

    calculateFollow1()
    printFollow1()

    calculateLL1Table()
    printLL1Table()

    checkIfLL1()
    print(f"Is LL(1): {isLL1}")

    while isLL1:
        sequenceFile = input("\n\nInsert the input sequence file name: ")
        if sequenceFile.strip() == "STOP":
            break

        sequenceList = readSequenceFromFile(sequenceFile)
        ruleList = runLL1Algorithm(sequenceList)
        if ruleList == []:
            print("\nSequence not accepted!\n")

        else:
            print(f"\nSequence accepted\nRule List: {ruleList}")


def __main__():
    menu()


__main__()
