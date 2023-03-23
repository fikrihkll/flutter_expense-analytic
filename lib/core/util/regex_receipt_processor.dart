import 'package:expense_app/features/domain/entities/receipt_result.dart';

class RegexReceiptProcessor {

  List<ReceiptResult> convertTextToReceipt(String text) {
    List<ReceiptResult> listResult = [];
    for (String line in text.split("\n")) {
      RegExp regex = RegExp(r'^.+\s.*\d$', multiLine: false, caseSensitive: false);
      var result = regex.firstMatch(line)?.group(0);
      if (result != null) {
        var data = result.split(" ");
        if (data.length >= 2) {
          try {
            listResult.add(
                ReceiptResult(name: data.first, nominal: int.parse(data.last).toDouble())
            );
          } catch(e) {}
        }
      }
    }
    return listResult;
  }

}