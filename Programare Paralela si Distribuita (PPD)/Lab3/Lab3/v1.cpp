#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>
#include <thread>
#include <string>

#include "mpi.h"

using namespace std;

void writeResultToFile(string fileName, int result[], int size) {
	ofstream out(fileName);

	out << size << '\n';
	for (int i = size - 1; i >= 0; i--) {
		out << result[i] << ' ';
	}

	out.close();
}

bool checkCorrectness(string fileName, int result[], int size) {
	ifstream in(fileName);

	int digitNum;
	int expected[100001];

	in >> digitNum;
	for (int i = 0; i < digitNum; i++) {
		in >> expected[i];
	}

	in.close();

	if (digitNum != size) {
		return false;
	}

	for (int i = 0; i < size; i++) {
		if (expected[i] != result[size - i - 1]) {
			cout << expected[i] << ' ' << result[i] << '\n';
			return false;
		}
	}

	return true;
}

int main(int argc, char* argv[]) {
	int myRank, worldSize;
	int resultSize, result[100001] = { 0 };

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &worldSize);
	MPI_Comm_rank(MPI_COMM_WORLD, &myRank);

	if (myRank == 0) {
		ifstream in1("Numar1_3.txt");
		ifstream in2("Numar2_3.txt");

		int nr1, nr2;
		in1 >> nr1;
		in2 >> nr2;

		int maxLen = max(nr1, nr2) + 1;
		int resultSize = maxLen;

		auto startTime = chrono::high_resolution_clock::now();

		const int whole = (maxLen - 1) / (worldSize - 1);
		int remainder = (maxLen - 1) % (worldSize - 1);

		int start = 0, end = whole;

		for (int i = 1; i < worldSize; i++) {
			if (remainder > 0) {
				end++;
				remainder--;
			}

			int digit;

			MPI_Send(&start, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
			MPI_Send(&end, 1, MPI_INT, i, 0, MPI_COMM_WORLD);

			for (int j = start; j < end; j++) {
				if (nr1 <= 0) {
					digit = 0;
					MPI_Send(&digit, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
				}

				else {
					in1 >> digit;
					MPI_Send(&digit, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
				}

				nr1--;
			}

			for (int j = start; j < end; j++) {
				if (nr2 <= 0) {
					digit = 0;
					MPI_Send(&digit, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
				}

				else {
					in2 >> digit;
					MPI_Send(&digit, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
				}

				nr2--;
			}

			start = end;
			end = start + whole;
		}

		MPI_Status status;

		for (int i = 1; i < worldSize; i++) {
			MPI_Recv(&start, 1, MPI_INT, i, 0, MPI_COMM_WORLD, &status);
			MPI_Recv(&end, 1, MPI_INT, i, 0, MPI_COMM_WORLD, &status);

			int toRecv = end - start, recvDigit;
			for (int j = 0; j < toRecv; j++) {
				MPI_Recv(&recvDigit, 1, MPI_INT, i, 0, MPI_COMM_WORLD, &status);
				result[start + j] = recvDigit;
			}
		}

		if (result[maxLen - 1] == 0) {
			resultSize--;
		}

		auto endTime = chrono::high_resolution_clock::now();

		if (checkCorrectness("Expected_3.txt", result, resultSize)) {
			cout << chrono::duration<double, milli>(endTime - startTime).count();
			writeResultToFile("Rezultat_3.txt", result, resultSize);
		}
		else {
			cout << "INCORRECT RESULT!\n";
		}

	}

	else {
		int carry = 0;
		MPI_Status status;

		if (myRank != 1) {	// procesul cu ID 1 nu primeste carry
			MPI_Recv(&carry, 1, MPI_INT, myRank - 1, 0, MPI_COMM_WORLD, &status);
		}

		int start, end;
		MPI_Recv(&start, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
		MPI_Recv(&end, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);

		int toRecv = end - start, recvDigit;

		int* recvNum1 = new int[toRecv];
		int* recvNum2 = new int[toRecv];
		int* result = new int[toRecv + 1];

		for (int i = 0; i < toRecv; i++) {
			MPI_Recv(&recvDigit, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
			recvNum1[i] = recvDigit;
		}

		for (int i = toRecv; i < toRecv * 2; i++) {
			MPI_Recv(&recvDigit, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
			recvNum2[i - toRecv] = recvDigit;
		}
		
		for (int i = 0; i < toRecv; i++) {
			int sum = recvNum1[i] + recvNum2[i] + carry;
			result[i] = sum % 10;
			carry = sum / 10;
		}
		
		if (myRank == worldSize - 1) {
			if (carry == 1) {
				end++;
				result[toRecv] = 1;
				toRecv++;
			}
		}
		
		if (myRank != worldSize - 1) {	// trimitem carry mai departe
			MPI_Send(&carry, 1, MPI_INT, myRank + 1, 0, MPI_COMM_WORLD);
		}

		MPI_Send(&start, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
		MPI_Send(&end, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
		for (int i = 0; i < toRecv; i++) {
			int toSend = result[i];
			MPI_Send(&toSend, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
		}
	}
	
	MPI_Finalize();
	return 0;
}