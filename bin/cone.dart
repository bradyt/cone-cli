import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:string_scanner/string_scanner.dart';

import 'package:cone/cone.dart' as cone;

// class Posting {
//   String account;
//   int amount;
//   String currency;
// }

// class Transaction {
//   DateTime dateTime;
//   String description;
//   List<Posting> postings;
//   Transaction(String entity) {
//     dateTime = DateTime.parse(entity.substring(0, 10));
//     print(dateTime);
//   }
// }

class RawPosting {
  String account;
  int amount;
  String currency;
}

class RawTransaction {
  String dateTime;
  String description;
  List<String> postings;
  RawTransaction(String entity) {
    StringScanner scanner = StringScanner(entity);
    scanner.expect(RegExp(r'\d{4}[-/]\d{2}[-/]\d{2}'));
    this.dateTime = scanner.lastMatch[0];
    scanner.expect(RegExp(r' *([^\n]*)'));
    this.description = scanner.lastMatch[1];
    scanner.scan('\n');
    scanner.expect(RegExp(r'.*'));
    this.postings = scanner.lastMatch[0].split('\n');
    // this.description =
  }
  String toString() {
    return """

    datetime: $dateTime
    description: $description
    postings: $postings""";
  }
}

main(List<String> arguments) {
  String home = Platform.environment['UserProfile'];
  File journal = File(p.join(home, '.ledger.journal'));
  String contents = journal.readAsStringSync();
  List<String> entities = contents.split(RegExp(r'\n{2,}'));
  for (String entity in entities) {
    if (entity[0] == ';') {
      print("Comment: " + entity + '\n\n');
    } else {
      RawTransaction rawTxn = RawTransaction(entity);
      print("Transaction: " + rawTxn.toString() + '\n\n');
    }
  }
}
