import 'dart:math';

List<String> getword(List<String> keyword){
  List<String> word=[];

  while(true){
    int num=Random().nextInt(keyword.length);

    if(!word.contains(keyword[num])){
      word.add(keyword[num]);
    }

    if(word.length==4)
      break;
  }

  return word;
}