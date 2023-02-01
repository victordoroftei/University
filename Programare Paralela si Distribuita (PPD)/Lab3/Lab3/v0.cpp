#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>

using namespace std;

vector<int> num1, num2, result;
int len1, len2, maxLen;

void generateVector(int digitNum, string fileName) {
	ofstream out(fileName);
	out << digitNum << '\n';

	for (int i = 0; i < digitNum; i++) {
		int x = rand() % 9 + 1;	// generating digits in the [1, 9] interval
		out << x << ' ';
	}

	out.close();
}

bool checkCorrectness(string fileName) {
	ifstream in(fileName);

	int digitNum;
	int expected[100001];

	in >> digitNum;
	for (int i = 0; i < digitNum; i++) {
		in >> expected[i];
	}

	in.close();

	if (digitNum != result.size()) {
		return false;
	}

	for (int i = 0; i < result.size(); i++) {
		if (expected[i] != result[i]) {
			return false;
		}
	}

	return true;
}

void readVectors(string fileName1, string fileName2) {
	ifstream in(fileName1);

	int digit;
	in >> len1;

	for (int i = 0; i < len1; i++) {
		in >> digit;
		num1.push_back(digit);
	}

	in.close();

	ifstream in2(fileName2);
	in2 >> len2;

	for (int i = 0; i < len2; i++) {
		in2 >> digit;
		num2.push_back(digit);
	}

	in2.close();

	maxLen = max(len1, len2);
	num1.resize(maxLen);
	num2.resize(maxLen);
	result.resize(maxLen);
}

void writeResult(string fileName) {
	ofstream out(fileName);

	out << result.size() << '\n';

	for (int x : result) {
		out << x << ' ';
	}

	out.close();
}

void addVectors() {
	int carry = 0;

	for (int i = 0; i < maxLen; i++) {
		int sum = num1[i] + num2[i] + carry;
		result[i] = sum % 10;
		carry = sum / 10;
	}

	// Accounting for the extra digit
	if (carry == 1) {
		result.resize(maxLen + 1);
		result[maxLen] = 1;
	}
}

int main(int argc, char** argv) {

	//generateVector(100000, "Numar1_4.txt");
	//generateVector(100000, "Numar2_4.txt");

	readVectors("Numar1_4.txt", "Numar2_4.txt");

	auto startTime = chrono::high_resolution_clock::now();

	addVectors();

	auto endTime = chrono::high_resolution_clock::now();

	reverse(result.begin(), result.end());

	if (checkCorrectness("Expected_4.txt")) {
		writeResult("Rezultat_4.txt");
		cout << chrono::duration<double, milli>(endTime - startTime).count();
	}

	else {
		cout << "INCORRECT RESULT!\n";
	}
}