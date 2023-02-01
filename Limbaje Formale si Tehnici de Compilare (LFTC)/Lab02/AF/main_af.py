from AF import AF
from test import runTests


def readFromKeyboard():
    content = input("Input: ")

    lines = content.split(";")
    stariLine = lines[0]
    stariList = stariLine.split(",")
    stareInitiala = ""
    stariFinale = []
    stariNormale = []
    stari = []

    for stare in stariList:
        if stare[0] == 'i':
            stareInitiala = stare.replace('i', '')
            stari.append(stare.replace('i', ''))
        elif stare[0] == 'f':
            stariFinale.append(stare.replace('f', ''))
            stari.append(stare.replace('f', ''))
        elif stare[0] == 'a':
            stareInitiala = stare.replace('a', '')
            stariFinale.append(stare.replace('a', ''))
            stari.append(stare.replace('a', ''))
        else:
            stariNormale.append(stare)
            stari.append(stare)

    tranzitii = dict()
    alfabet = []
    for line in lines[1:]:
        if line != "":
            tranzitieLine = line
            tranzitieList = tranzitieLine.split('?')

            src = tranzitieList[0]
            dest = tranzitieList[1]
            reguliString = tranzitieList[2]
            reguli = reguliString.split(",")

            for regula in reguli:
                if regula not in alfabet:
                    alfabet.append(regula)

            if src not in tranzitii.keys():
                tranzitii[src] = []
                for regula in reguli:
                    tranzitii[src].append((dest, regula))
            else:
                for regula in reguli:
                    tranzitii[src].append((dest, regula))

    stari = sorted(stari)
    return stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet


def readFromFile(path):
    file = open(path, "r")
    line = file.readline()

    stariLine = line.strip(";\n")
    stariList = stariLine.split(",")

    stareInitiala = ""
    stariFinale = []
    stariNormale = []
    stari = []

    for stare in stariList:
        if stare[0] == 'i':
            stareInitiala = stare.replace('i', '')
            stari.append(stare.replace('i', ''))
        elif stare[0] == 'f':
            stariFinale.append(stare.replace('f', ''))
            stari.append(stare.replace('f', ''))
        elif stare[0] == 'a':
            stareInitiala = stare.replace('a', '')
            stariFinale.append(stare.replace('a', ''))
            stari.append(stare.replace('a', ''))
        else:
            stariNormale.append(stare)
            stari.append(stare)

    line = file.readline()
    tranzitii = dict()
    alfabet = []
    while line:
        tranzitieLine = line.strip(";\n")
        tranzitieList = tranzitieLine.split('?')

        src = tranzitieList[0]
        dest = tranzitieList[1]
        reguliString = tranzitieList[2]
        reguli = reguliString.split(",")

        for regula in reguli:
            if regula not in alfabet:
                alfabet.append(regula)

        if src not in tranzitii.keys():
            tranzitii[src] = []
            for regula in reguli:
                tranzitii[src].append((dest, regula))
        else:
            for regula in reguli:
                tranzitii[src].append((dest, regula))

        line = file.readline()

    file.close()
    stari = sorted(stari)
    return stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet


def menu(af):
    running = True

    while running:
        print("\n========== MENU ==========\n")
        print("1. Afisare Multime Stari")
        print("2. Afisare Alfabet")
        print("3. Afisare Tranzitii")
        print("4. Afisare Multime Stari Finale")
        print("5. Verificare Secventa")
        print("6. Cel Mai Lung Prefix")
        print("0. Exit\n")

        cmd = input("Introduceti o comanda: ")
        if cmd == '1':
            print(af.stari)

        elif cmd == '2':
            print(af.alfabet)

        elif cmd == '3':
            print(af.tranzitii)

        elif cmd == '4':
            print(af.stariFinale)

        elif cmd == '5':
            if not af.determinist:
                print("\nAutomatul finit nu este determinist!")
            else:
                sequence = input("Introduceti secventa: ")
                if af.checkSequence(sequence):
                    print("\nSecventa valida!")
                else:
                    print("\nSecventa invalida!")

        elif cmd == '6':
            if not af.determinist:
                print("\nAutomatul finit nu este determinist!")
            else:
                sequence = input("Introduceti secventa: ")
                prefix = af.determinePrefix(sequence)

                if prefix is None:
                    print("\nNu exista niciun prefix care sa respecte automatul!")
                else:
                    print("\nCel mai lung prefix este: ", prefix)

        elif cmd == '0':
            running = False

        else:
            print("\nComanda invalida!")


def buildAFForFile(fileName):
    path = f"af_files/{fileName}"

    stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet = readFromFile(path)
    af = AF(stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet)

    return af


def __main__():
    path = input("Fisier input (X pentru citit de la tastatura): ")
    path = f"af_files/{path}"

    if path == "X":
        stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet = readFromKeyboard()

    else:
        stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet = readFromFile(path)

    af = AF(stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet)

    runTests(af, path)

    menu(af)


# __main__()
