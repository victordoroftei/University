def runTests(af, fileName):
    if fileName == "integer":
        assert af.checkSequence("42") is True
        assert af.checkSequence("123") is True
        assert af.checkSequence("052") is True
        assert af.checkSequence("0x2a") is True
        assert af.checkSequence("0X2A") is True
        assert af.checkSequence("0b101010") is True
        assert af.checkSequence("18446744073709550592ull") is True
        assert af.checkSequence("0xE") is True
        assert af.checkSequence("0Xe") is True
        assert af.checkSequence("0x123") is True
        assert af.checkSequence("12345678901234567890ull") is True
        assert af.checkSequence("12345678901234567890u") is True
        assert af.checkSequence("-9223372036854775808u") is True
        assert af.checkSequence("-9223372036854775807") is True

    elif fileName == "float":
        assert af.checkSequence(".0") is True
        assert af.checkSequence("0") is True
        assert af.checkSequence("0x1.2p3") is True
        assert af.checkSequence("1.2e3") is True
        assert af.checkSequence("1.23") is True
        assert af.checkSequence("1.230") is True
        assert af.checkSequence("2.0f") is True
        assert af.checkSequence("1") is True
        assert af.checkSequence("-1") is True
        assert af.checkSequence("+1") is True
        assert af.checkSequence("1e0") is True
        assert af.checkSequence(".1") is True
        assert af.checkSequence("+2.0e+308") is True
        assert af.checkSequence("+1.0e-324") is True
        assert af.checkSequence("-1.0e-324") is True
        assert af.checkSequence("-2.0e+308") is True
        assert af.checkSequence("15.0") is True
        assert af.checkSequence("0x1.ep+3") is True
        assert af.checkSequence("0x1.FFFFFEp128f") is True

    elif fileName == "string":
        assert af.checkSequence("\"hello hello\"") is True
        assert af.checkSequence("\"hello\"") is True
        assert af.checkSequence("\" \"") is True
        assert af.checkSequence("\"\"") is True
        assert af.checkSequence("\"mesaj12424\"") is True
        assert af.checkSequence("\"mesaj 12424 \"") is True

    elif fileName == "op":
        assert af.checkSequence(">=") is True
        assert af.checkSequence("<=") is True
        assert af.checkSequence("==") is True
        assert af.checkSequence("!=") is True
        assert af.checkSequence("&&") is True
        assert af.checkSequence("||") is True

    elif fileName == "var":
        assert af.checkSequence("abc") is True
        assert af.checkSequence("x") is True
        assert af.checkSequence("Y") is True
        assert af.checkSequence("xYz") is True
        assert af.checkSequence("aaa.bbb") is True
        assert af.checkSequence("abc.bca") is True
        assert af.checkSequence("abc.bca") is True
        assert af.checkSequence("aBc.CcA") is True

