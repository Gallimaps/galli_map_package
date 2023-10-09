String encrypt(String input) {
  String output = "";
  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    charCode = charCode + 2 + i;
    output += String.fromCharCode(charCode);
  }
  return output;
}

String decrypt(String input) {
  String output = "";
  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    charCode = charCode - 2 - i;
    output += String.fromCharCode(charCode);
  }
  return output;
}
