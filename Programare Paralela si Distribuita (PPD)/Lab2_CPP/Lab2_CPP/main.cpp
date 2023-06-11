#include <iostream>
#include <fstream>
#include <chrono>
#include <vector>
#include <thread>
#include <cstring>

#include "barrier.h"

using namespace std;

int N, M, n, m, p, borderLine, borderColumn;
vector<vector<int>> mat, kernel;

int calculateValue(int line, int column) {
	int value = 0;

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			int x = line + i - borderLine;
			int y = column + j - borderColumn;

			if (x < 0) {
				x = 0;
			}
			else if (x >= N) {
				x = N - 1;
			}

			if (y < 0) {
				y = 0;
			}
			else if (y >= M) {
				y = M - 1;
			}

			value += kernel[i][j] * mat[x][y];
		}
	}

	return value;
}

void sequential() {
	auto startTime = chrono::high_resolution_clock::now();

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			mat[i][j] = calculateValue(i, j);
		}
	}

	auto endTime = chrono::high_resolution_clock::now();
	cout << chrono::duration<double, milli>(endTime - startTime).count();
}

void addThread(int start, int end, Barrier& barrier) {
	vector<vector<int>> buffer(N, vector<int>(M));	// the buffer will contain the values that the thread will work on
	int bufferLine;
	for (int i = start; i < end; i++) {
		bufferLine = i - start;
		for (int j = 0; j < M; j++) {
			buffer[bufferLine][j] = calculateValue(i, j);
		}
	}

	barrier.wait();
	for (int i = start; i < end; i++) {
		bufferLine = i - start;
		for (int j = 0; j < M; j++) {
			mat[i][j] = buffer[bufferLine][j];
		}
	}
}

void parallelIntervals() {
	vector<thread> threads(p);
	Barrier barrier(p);

	int size, rest;
	size = N / p;
	rest = N % p;

	int start;
	int end = 0;

	auto startTime = chrono::high_resolution_clock::now();

	for (int i = 0; i < p; i++) {
		start = end;
		end = start + size;

		if (rest > 0) {
			end++;
			rest--;
		}

		threads[i] = thread(addThread, start, end, ref(barrier));
	}

	for (int i = 0; i < p; i++) {
		threads[i].join();
	}

	auto endTime = chrono::high_resolution_clock::now();
	cout << chrono::duration<double, milli>(endTime - startTime).count();
}

void readFromFile() {
	string inputFilePath = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab2_Java\\input4.txt";
	ifstream in(inputFilePath);

	in >> N;
	in >> M;
	mat.resize(N, vector<int>(M));

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			in >> mat[i][j];
		}
	}

	in >> n;
	in >> m;
	kernel.resize(n, vector<int>(m));

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			in >> kernel[i][j];
		}
	}

	in.close();

	borderLine = (n - 1) / 2;
	borderColumn = (m - 1) / 2;
}

void writeToFile() {
	string outputFilePath = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab2_Java\\output.txt";
	ofstream out(outputFilePath);

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			out << mat[i][j] << " ";
		}
		out << "\n";
	}

	out.close();
}

bool checkCorrectness() {
	string expectedFilePath = "E:\\__Teme\\Programare Paralela si Distribuita (PPD)\\Lab2_Java\\expected4.txt";
	ifstream in(expectedFilePath);

	vector<vector<int>> expected(N, vector<int>(M));
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			in >> expected[i][j];
		}
	}

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < M; j++) {
			if (expected[i][j] != mat[i][j]) {
				return false;
			}
		}
	}

	return true;
}


int main(int argc, char** argv) {
	srand(time(NULL));

	p = atoi(argv[1]);
	readFromFile();

	parallelIntervals();

	if (checkCorrectness()) {
		writeToFile();
	}
	else {
		cout << "INCORRECT RESULT!";
	}

	return 0;
}