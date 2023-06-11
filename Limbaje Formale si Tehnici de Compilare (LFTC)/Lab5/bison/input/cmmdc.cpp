main() {
    int a, b;

    cout << "Introduceti valoarea lui a ";
    cin >> a;

    cout << "Introduceti valoarea lui b ";
    cin >> b;

    while (b != 0) {
        int r = a % b;
        a = b;
        b = r;
    }

    cout << "CMMDC ";
    cout << a;
}