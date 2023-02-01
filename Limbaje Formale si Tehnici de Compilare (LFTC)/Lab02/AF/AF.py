class AF:
    def __init__(self, stareInitiala, stariFinale, stariNormale, stari, tranzitii, alfabet):
        self.stareInitiala = stareInitiala
        self.stariFinale = stariFinale
        self.stariNormale = stariNormale
        self.stari = stari
        self.tranzitii = tranzitii
        self.determinist = None
        self.alfabet = alfabet
        self.adjMatrix = []
        self.determineDeterminism()

    def buildAdjMatrix(self):
        for i in range(0, len(self.stari)):
            self.adjMatrix.append([])

        for i in range(0, len(self.stari)):
            for j in range(0, len(self.stari)):
                self.adjMatrix[i].append([])

        for stare in self.tranzitii.keys():
            for tranzitie in self.tranzitii[stare]:
                dest = tranzitie[0]
                regula = tranzitie[1]
                self.adjMatrix[self.stari.index(stare)][self.stari.index(dest)].append(regula)

    def determineDeterminism(self):
        tabela = dict()
        for stare in self.tranzitii.keys():
            for tranzitie in self.tranzitii[stare]:
                dest = tranzitie[0]
                reg = tranzitie[1]
                k = (stare, reg)

                if k not in tabela.keys():
                    tabela[k] = [dest]
                else:
                    tabela[k].append(dest)

        for tup in tabela.keys():
            if len(tabela[tup]) > 1:
                self.determinist = False
                return

        self.determinist = True
        self.buildAdjMatrix()

    def checkSequence(self, sequence):
        indexStareCurenta = self.stari.index(self.stareInitiala)

        for ch in sequence:

            found = False
            for i in range(0, len(self.adjMatrix[indexStareCurenta])):
                if ch in self.adjMatrix[indexStareCurenta][i]:
                    indexStareCurenta = i
                    found = True
                    break

            if not found:
                return False

        '''ch3 = ""
        for j in range(0, len(sequence)):
            if ch3 != "":
                ch3 = ""
                continue

            ch = sequence[j]
            ch3 = ""

            if j < len(sequence) - 1:
                ch2 = sequence[j + 1]
                if ch == '0' and (ch2 == 'x' or ch2 == 'X' or ch2 == 'b' or ch2 == 'B'):
                    ch3 = ch + ch2

            found = False
            for i in range(0, len(self.adjMatrix[indexStareCurenta])):
                if ch3 != "":
                    if ch3 in self.adjMatrix[indexStareCurenta][i]:
                        indexStareCurenta = i
                        found = True
                        break

                else:
                    if ch in self.adjMatrix[indexStareCurenta][i]:
                        indexStareCurenta = i
                        found = True
                        break

            if not found:
                return False'''

        indecsiStariFinale = []
        for stareFinala in self.stariFinale:
            indecsiStariFinale.append(self.stari.index(stareFinala))

        if indexStareCurenta in indecsiStariFinale:
            return True

        return False

    def determinePrefix(self, sequence):
        prefix = sequence

        while not self.checkSequence(prefix):
            prefix = prefix.rstrip(prefix[-1])  # removes last element from string
            if len(prefix) == 0:
                return None

        return prefix
