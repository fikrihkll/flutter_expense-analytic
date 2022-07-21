class MoneyUtil{

  static String getReadableMoney(int nominal){
    String nominalStr = nominal.toString();
    String finalStr = '';
    int counter = 0;
    for(int i=nominalStr.length-1; i>=0; i--){
      if(counter == 3){
        finalStr += '.';
        finalStr += nominalStr[i];
        counter = 1;
      }else{
        finalStr += nominalStr[i];
        counter++;
      }
    }
    return finalStr.split('').reversed.join('');
  }

}