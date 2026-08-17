Map<String, String> bengali2itran_vowels = {
  "অ": "a",
  "আ": "aa",
  "ই": "i",
  "ঈ": "i",
  "উ": "u",
  "ঊ": "oo",
  "এ": "e",
  "ঐ": "ai",
  "ও": "o",
  "ঔ": "au",
  "ঃ": "h",
  "ি": "i",
  "া": "aa",
  "ে": "e",
  "ু": "u",
  "ো": "o",
  "ী": "i",
  "ং": "n",
  "ূ": "oo",
  "ৈ": "ai",
  "ৃ": "ri",
  "ৄ": "ri",
  "ৌ": "au",
  "্": "",
  "ঁ": "an",
  "়": ""
};
Map<String, String> bengali2itranAll = {
  "অ": "a",
  "আ": "aa",
  "ই": "i",
  "ঈ": "i",
  "উ": "u",
  "ঊ": "oo",
  "এ": "e",
  "ঐ": "ai",
  "ও": "o",
  "ঔ": "au",
  "ঃ": "h",
  "ি": "i",
  "া": "aa",
  "ে": "e",
  "ু": "u",
  "ো": "o",
  "ী": "i",
  "ং": "n",
  "ূ": "oo",
  "ৈ": "ai",
  "ৃ": "ri",
  "ৄ": "ri",
  "ৌ": "au",
  "্": "",
  "ঁ": "an",
  "়": "",
  "ঋ": "ri",
  "ৠ": "ri",
  "ঌ": "li",
  "ৡ": "li",
  "ক": "k",
  "খ": "kh",
  "গ": "g",
  "ঘ": "gh",
  "ঙ": "n",
  "চ": "ch",
  "ছ": "chh",
  "জ": "j",
  "ঝ": "jh",
  "ঞ": "n",
  "ট": "t",
  "ঠ": "th",
  "ড": "d",
  "ঢ": "dh",
  "ণ": "n",
  "ত": "t",
  "থ": "th",
  "দ": "d",
  "ধ": "dh",
  "ন": "n",
  "প": "p",
  "ফ": "ph",
  "ব": "b",
  "ভ": "bh",
  "ম": "m",
  "য": "y",
  "র": "r",
  "ল": "l",
  "শ": "sh",
  "ষ": "sh",
  "স": "s",
  "হ": "h",
  // "ড়": "dh",
  "ড়": "dh",
  "ঢ়": "rh",
  "ক্ষ": "x",
  "জ্ঞ": "gy",
  "শ্র": "shr",
  "য়": "y",
  "ৎ": "t",
  "০": "0",
  "১": "1",
  "২": "2",
  "৩": "3",
  "৪": "4",
  "৫": "5",
  "৬": "6",
  "৭": "7",
  "৮": "8",
  "৯": "9",
  "।": "."
};

bool isVowelBengali(String char) {
  return bengali2itran_vowels.containsKey(char);
}

String bengali2itran(String? bengaliString) {
  if (bengaliString == null) {
    return '';
  }

  List<String> itranString = [];
  bool capitalizeNext = true;
  // bool continuousVowel = false;
  for (int i = 0; i < bengaliString.length; i++) {
    String currentChar = bengaliString[i];
    if (bengali2itranAll.containsKey(currentChar)) {
      String transliteratedChar = bengali2itranAll[currentChar]!;
      if (capitalizeNext) {
        if (transliteratedChar != ' ') {
          if(transliteratedChar.length>=2){
            transliteratedChar = transliteratedChar[0].toUpperCase() + transliteratedChar.substring(1);
          }
          else{
            transliteratedChar = transliteratedChar.toUpperCase();
          }
          capitalizeNext = false;
        }
      }

      itranString.add(transliteratedChar);
      if (!isVowelBengali(currentChar)) {
        // Check if the next character is not a combining vowel (‌্) and is also not a vowel
        if (i + 1 < bengaliString.length && bengaliString[i + 1] != "‌্" && bengaliString[i + 1] != " " && !isVowelBengali(bengaliString[i + 1])) {
          // Append the transliterated equivalent of "अ" to itranString
          itranString.add(bengali2itran_vowels["অ"]!);
        }
      }
      if (currentChar == "।" || currentChar == "?") {
        capitalizeNext = true;
      }
    }
    else {
      if (currentChar == "।" || currentChar == "?") {
        capitalizeNext = true;
      }
      itranString.add(currentChar);
    }
  }

  return itranString.join();
}

String transliterateBengali(String? text) {
  return bengali2itran(text);
}
Map<String, String> hindi2itran_vowels = {
  "अ": "a",
  "आ": "aa",
  "इ": "i",
  "ई": "i",
  "उ": "u",
  "ऊ": "oo",
  "ए": "e",
  "ऐ": "ai",
  "ओ": "o",
  "औ": "au",
  "ः": "h",
  "ि": "i",
  "ा": "aa",
  "े": "e",
  "ु": "u",
  "ो": "o",
  "ी": "i",
  "ं": "n",
  "ू": "oo",
  "ै": "ai",
  "ृ": "ri",
  "ॄ": "ri",
  "ौ": "au",
  "्": "",
  "ँ": "n",
  "़": "",
  ":": "ah",
  ",": ",",
  "-": "-"
};
Map<String, String> hindi2itranAll = {
  "अ": "a",
  "आ": "aa",
  "इ": "i",
  "ई": "i",
  "उ": "u",
  "ऊ": "oo",
  "ए": "e",
  "ऐ": "ai",
  "ओ": "o",
  "औ": "au",
  "ः": "h",
  ":": "ah",
  "ि": "i",
  "ा": "aa",
  "े": "e",
  "ु": "u",
  "ो": "o",
  "ी": "i",
  "ं": "an",
  "ू": "oo",
  "ै": "ai",
  "ृ": "ri",
  "ॄ": "ri",
  "ौ": "au",
  "्": "",
  "ँ": "an",
  "़": "",
  "क": "k",
  "ख": "kh",
  "ग": "g",
  "घ": "gh",
  "ङ": "n",
  "च": "ch",
  "छ": "chh",
  "ज": "j",
  "झ": "jh",
  "ञ": "n",
  "ट": "t",
  "ठ": "th",
  "ड": "d",
  "ढ": "dh",
  "ण": "n",
  "त": "t",
  "थ": "th",
  "द": "d",
  "ध": "dh",
  "न": "n",
  "प": "p",
  "फ": "ph",
  "ब": "b",
  "भ": "bh",
  "म": "m",
  "य": "y",
  "र": "r",
  "ल": "l",
  "व": "v",
  "श": "sh",
  "ष": "sh",
  "स": "s",
  "ह": "h",
  "ड़": "da",
  "ड़": "da",
  "ळ": "l",
  "ढ़": "dha",
  "ज्ञ": "gy",
  "श्र": "shr",
  "य़": "y",
  "ट्र": "tr",
  "ष्ट": "sht",
  "ख्न": "khn",
  "ग्ध": "gdh",
  "द्ध": "ddh",
  "श्ल": "shl",
  "द्म": "dm",
  "ज्व": "jv",
  "०": "0",
  "१": "1",
  "२": "2",
  "३": "3",
  "४": "4",
  "५": "5",
  "६": "6",
  "७": "7",
  "८": "8",
  "९": "9",
  "।": "."
};

bool isVowelHindi(String char) {
  return hindi2itran_vowels.containsKey(char);
}

String hindi2itran(String? hindiString) {
  if (hindiString == null) {
    return '';
  }

  List<String> itranString = [];
  bool capitalizeNext = true;
  bool continuousVowel = false;
  for (int i = 0; i < hindiString.length; i++) {
    String currentChar = hindiString[i];
    // print(currentChar);
    if (hindi2itranAll.containsKey(currentChar)) {
      if (hindi2itran_vowels.containsKey(currentChar) && continuousVowel) {
        if(i + 1 < hindiString.length && (hindiString[i]=='ं' || hindiString[i]=='ँ') && (hindiString[i+1]=="।" || hindiString[i+1]=="?" || hindiString[i+1]==" " || hindiString[i+1]==",")){
          continue;
        }
        if (currentChar == "ं" || currentChar == "ँ") {
          String transliteratedChar = hindi2itran_vowels[currentChar]!;
          itranString.add(transliteratedChar);
          continuousVowel = false;
          continue;
        }
      } else if (hindi2itran_vowels.containsKey(currentChar)) {
        continuousVowel = true;
      } else if (!hindi2itran_vowels.containsKey(currentChar)) {
        continuousVowel = false;
      }
      String transliteratedChar = hindi2itranAll[currentChar]!;
      if (capitalizeNext) {
        if (transliteratedChar != ' ') {
          if(transliteratedChar.length>=2){
            transliteratedChar = transliteratedChar[0].toUpperCase() + transliteratedChar.substring(1);
          }
          else{
            transliteratedChar = transliteratedChar.toUpperCase();
          }
          capitalizeNext = false;
        }
      }

      itranString.add(transliteratedChar);
      if (!isVowelHindi(currentChar)) {
        // Check if the next character is not a combining vowel (‌্) and is also not a vowel
        if (i + 1 < hindiString.length && hindiString[i + 1] != "‌্" && hindiString[i + 1] != " " && !isVowelHindi(hindiString[i + 1])) {
          // Append the transliterated equivalent of "अ" to itranString
          itranString.add(hindi2itran_vowels["अ"]!);
        }
      }
      if (currentChar == "।" || currentChar == "?") {
        capitalizeNext = true;
      }
    }
    else {
      if (currentChar == "।" || currentChar == "?") {
        capitalizeNext = true;
      }
      itranString.add(currentChar);
    }
  }

  return itranString.join();
}
String transliterateHindi(String? text) {
  return hindi2itran(text);
}

String transliterateMarathi(String? text) {
  return hindi2itran(text);
}


Map<String, String> gujarati2itran_volwels = {
  "અ": "a",
  "આ": "aa",
  "ઇ": "i",
  "ઈ": "i",
  "ઉ": "u",
  "ઊ": "oo",
  "એ": "e",
  "ઐ": "ai",
  "ઓ": "o",
  "ઔ": "au",
  "ઃ": "h",
  "િ": "i",
  "ા": "aa",
  "ે": "e",
  "ુ": "u",
  "ો": "o",
  "ી": "i",
  "ં": "n",
  "ૂ": "oo",
  "ૈ": "ai",
  "ૃ": "ri",
  "ૄ": "ri",
  "ૌ": "au",
  "્": "",
  "ઁ": "n",
  "઼": "",
  ",": ",",
  "-": "-"
};
Map<String, String> gujarati2itranAll = {
  "અ": "a",
  "આ": "aa",
  "ઇ": "i",
  "ઈ": "i",
  "ઉ": "u",
  "ઊ": "u",
  "એ": "e",
  "ઐ": "ai",
  "ઓ": "o",
  "ઔ": "au",
  "ઃ": "h",
  "િ": "i",
  "ા": "aa",
  "ે": "e",
  "ુ": "u",
  "ો": "o",
  "ી": "i",
  "ં": "an",
  "ૂ": "oo",
  "ૈ": "ai",
  "ૃ": "ri",
  "ૄ": "ri",
  "ૌ": "au",
  "્": "",
  "ઁ": "an",
  "઼": "",
  "ક": "k",
  "ખ": "kh",
  "ગ": "g",
  "ઘ": "gh",
  "ઙ": "n",
  "ચ": "ch",
  "છ": "chh",
  "જ": "j",
  "ઝ": "jh",
  "ઞ": "n",
  "ટ": "t",
  "ઠ": "th",
  "ડ": "d",
  "ઢ": "dh",
  "ણ": "n",
  "ત": "t",
  "થ": "th",
  "દ": "d",
  "ધ": "dh",
  "ન": "n",
  "પ": "p",
  "ફ": "ph",
  "બ": "b",
  "ભ": "bh",
  "મ": "m",
  "ય": "y",
  "ર": "r",
  "લ": "l",
  "ળ": "l",
  "વ": "v",
  "શ": "sh",
  "ષ": "sh",
  "સ": "s",
  "હ": "h",
  "ડ઼": "da",
  "ઢ઼": "dha",
  "ય્ય": "yy",
  "ર્ય": "ry",
  "જ્ઞ": "gy",
  "વ્ય": "vy",
  "ક્ષ": "ksh",
  "હ્ર": "hr",
  "૧": "1",
  "૨": "2",
  "૩": "3",
  "૪": "4",
  "૫": "5",
  "૬": "6",
  "૭": "7",
  "૮": "8",
  "૯": "9",
  "૦": "0",
};

bool isVowelGujarati(String char) {
  return gujarati2itran_volwels.containsKey(char);
}

String gujarati2itran(String? gujaratiString) {
  if (gujaratiString == null) {
    return '';
  }

  List<String> itranString = [];
  bool capitalizeNext = true;
  bool continuousVowel = false;
  for (int i = 0; i < gujaratiString.length; i++) {
    String currentChar = gujaratiString[i];
    print(currentChar);

    if (gujarati2itranAll.containsKey(currentChar)) {
      if (gujarati2itran_volwels.containsKey(currentChar) && continuousVowel) {
        if(i + 1 < gujaratiString.length && (gujaratiString[i]=="ं" || gujaratiString[i]=="ँ") && (gujaratiString[i+1]=="." || gujaratiString[i+1]=="?" || gujaratiString[i+1]==" " || gujaratiString[i+1]==",")){
          continue;
        }
        if (currentChar == "ं" || currentChar == "ँ") {
          String transliteratedChar = gujarati2itran_volwels[currentChar]!;
          itranString.add(transliteratedChar);
          continuousVowel = false;
          continue;
        }
      } else if (gujarati2itran_volwels.containsKey(currentChar)) {
        continuousVowel = true;
      } else if (!gujarati2itran_volwels.containsKey(currentChar)) {
        continuousVowel = false;
      }
      String transliteratedChar = gujarati2itranAll[currentChar]!;
      if (capitalizeNext) {
        if (transliteratedChar != ' ') {
          if(transliteratedChar.length>=2){
            transliteratedChar = transliteratedChar[0].toUpperCase() + transliteratedChar.substring(1);
          }
          else{
            transliteratedChar = transliteratedChar.toUpperCase();
          }
          capitalizeNext = false;
        }
      }

      itranString.add(transliteratedChar);
      if (!isVowelGujarati(currentChar)) {
        // Check if the next character is not a combining vowel (‌্) and is also not a vowel
        if (i + 1 < gujaratiString.length && gujaratiString[i + 1] != "‌্" && gujaratiString[i + 1] != " " && !isVowelGujarati(gujaratiString[i + 1])) {
          // Append the transliterated equivalent of "अ" to itranString
          itranString.add(gujarati2itran_volwels["અ"]!);
        }
      }
      if (currentChar == "." || currentChar == "?") {
        capitalizeNext = true;
      }
    } else {
      if (currentChar == "." || currentChar == "?") {
        capitalizeNext = true;
      }
      itranString.add(currentChar);
    }
  }

  return itranString.join();
}

String transliterateGujarati(String? text) {
  return gujarati2itran(text);
}

Map<String, String> telugu2itran_vowels = {
  "అ": "a",
  "ఆ": "aa",
  "ఇ": "i",
  "ఈ": "ee",
  "ఉ": "u",
  "ఊ": "oo",
  "ఎ": "e",
  "ఏ": "e",
  "ఐ": "ai",
  "ఒ": "o",
  "ఓ": "o",
  "ఔ": "au",
  "ః": "h",
  "ి": "i",
  "ీ": "e",
  "ా": "a",
  "ే": "e",
  "ు": "u",
  "ో": "o",
  "ె": "e",
  "ం": "am",
  "ూ": "u",
  "ై": "ai",
  "ృ": "ru",
  "ౄ": "ru",
  "ౌ": "au",
  "్": "",
  "ఁ": "an",
  ",": ",",
  "-": "-"
};
Map<String, String> telugu2itranAll = {
  "్": "",
  "అ": "a",
  "ఆ": "aa",
  "ఇ": "i",
  "ఈ": "i",
  "ఉ": "u",
  "ఊ": "oo",
  "ఎ": "e",
  "ఏ": "e",
  "ఐ": "ai",
  "ఒ": "o",
  "ఓ": "o",
  "ఔ": "au",
  "ం": "am",
  "ః": "h",
  "క": "k",
  "ఖ": "kh",
  "గ": "g",
  "ఘ": "gh",
  "ఙ": "ng",
  "చ": "ch",
  "ఛ": "chh",
  "జ": "j",
  "ఝ": "jh",
  "ఞ": "ny",
  "ట": "t",
  "ఠ": "th",
  "డ": "d",
  "ఢ": "dh",
  "ణ": "n",
  "త": "t",
  "థ": "th",
  "ద": "d",
  "ధ": "dh",
  "న": "n",
  "ప": "p",
  "ఫ": "ph",
  "బ": "b",
  "భ": "bh",
  "మ": "m",
  "య": "y",
  "ర": "r",
  "ల": "l",
  "ళ": "l",
  "వ": "v",
  "శ": "sh",
  "ష": "sh",
  "స": "s",
  "హ": "h",
  "్య": "ya",
  "్ర": "ra",
  "్ల": "la",
  "్ళ": "la",
  "్వ": "va",
  "్శ": "sha",
  "్ష": "sh",
  "్స": "sa",
  "్హ": "ha",
  "ృ": "ru",
  "ౄ": "ru",
  "ై": "ai",
  "ొ": "o",
  "ో": "o",
  "ౌ": "au",
  "ు": "u",
  "ా": "a",
  "ి": "i",
  "ీ": "i",
  "ూ": "u",
  "ె": "e",
  "ే": "e",
};

bool isVowelTelugu(String char) {
  return telugu2itran_vowels.containsKey(char);
}

String telugu2itran(String? teluguString) {
  if (teluguString == null) {
    return '';
  }

  List<String> itranString = [];
  bool capitalizeNext = true;

  for (int i = 0; i < teluguString.length; i++) {
    String currentChar = teluguString[i];
    if (telugu2itranAll.containsKey(currentChar)) {
      String transliteratedChar = telugu2itranAll[currentChar] ?? '';
      if (capitalizeNext) {
        if (transliteratedChar != ' ') {
          if(transliteratedChar.length>=2){
            transliteratedChar = transliteratedChar[0].toUpperCase() + transliteratedChar.substring(1);
          }
          else{
            transliteratedChar = transliteratedChar.toUpperCase();
          }
          capitalizeNext = false;
        }
      }

      itranString.add(transliteratedChar);
      if (!isVowelTelugu(currentChar)) {
        // Check if the next character is not a combining vowel (‌্) and is also not a vowel
        if (i + 1 < teluguString.length && teluguString[i + 1] != "‌্" &&  !isVowelTelugu(teluguString[i + 1])) {
          // Append the transliterated equivalent of "अ" to itranString
          itranString.add(telugu2itran_vowels["અ"] ?? '');
        }
      }
      if (currentChar == "." || currentChar == "?") {
        capitalizeNext = true;
      }
    } else {
      if (currentChar == "." || currentChar == "?") {
        capitalizeNext = true;
      }
      itranString.add(currentChar);
    }
  }

  return itranString.join();
}

String transliterateTelugu(String? text) {
  return telugu2itran(text);
}
