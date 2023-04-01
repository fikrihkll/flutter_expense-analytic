import 'package:expense_app/features/domain/entities/receipt_result.dart';

class RegexReceiptProcessor {

  List<ReceiptResult> convertTextToReceipt(String receiptString) {
    final List<String> lines = receiptString.split('\n');
    final List<double> prices = <double>[];
    final List<ReceiptResult> results = <ReceiptResult>[];

    // Step 1: Find prices in the receipt
    for (final String line in lines) {
      final RegExp regExp = RegExp(r'\d+(?:\.\d+)?');
      final Match? match = regExp.firstMatch(line);
      if (match != null) {
        prices.add(double.parse(match.group(0)!));
      }
    }

    // Step 2: Match prices to item names
    int i = 0;
    for (final double price in prices) {
      while (i < lines.length) {
        final RegExp regExp = RegExp(r'\d+(?:\.\d+)?');
        if (regExp.hasMatch(lines[i])) {
          i++;
          continue;
        }
        results.add(ReceiptResult(name: lines[i], nominal: price));
        i++;
        break;
      }
    }

    // Step 3: Return the results
    return results;
  }

}