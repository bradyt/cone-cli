part of cone.parser;

abstract class AstNode {}

class Journal extends AstNode {
  List<Transaction> transactions;
  Journal(this.transactions);
}

abstract class Transaction extends AstNode {
  List<Posting> postings;
}

class PlainTransaction extends Transaction {
  DateTime dateTime;
  DateTime secondaryDateTime;
  Status status;
  String code;
  String description;
}

class Posting extends AstNode {
  Status status;
  String account;
  String amount;
  Posting(this.status, this.account, [this.amount]);

  toString() {
    String statusString;
    switch (status) {
      case Status.unmarked:
        statusString = '';
        break;
      case Status.pending:
        statusString = '! ';
        break;
      case Status.cleared:
        statusString = '* ';
        break;
      default:
        break;
    }
    ;
    return '$statusString$account${(amount != null) ? '  ' + amount : ''}';
  }
}

class Amount extends AstNode {
  String currency;
  num number;
}

enum Status { unmarked, pending, cleared }

class Date {
  DateTime dateTime;
  Date(int year, int month, int day) {
    this.dateTime = DateTime(year, month, day);
  }
  toString() => dateTime.toString().substring(0, 10);
}
