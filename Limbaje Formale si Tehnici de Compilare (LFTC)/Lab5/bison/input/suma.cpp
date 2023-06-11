main() {
    int n, x, s = 0, i = 0;

    cout << "Introduceti numarul de numere n ";
    cin >> n;

    while (i < n) {
        cout << "Introduceti un numar x ";
        cin >> x;

        s = s + x;
        i = i + 1;
    }

    cout << "Suma numerelor este ";
    cout << s;
}