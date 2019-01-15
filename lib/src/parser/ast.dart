part of cone.parser;

class Journal {
  List<Transaction> transactions;
  Journal(this.transactions);
}

abstract class Transaction {}

class PlainTransaction extends Transaction {
  Date date;
  Date effectiveDate;
  Status status;
  // String code;
  String description;
  List<Posting> postings;
  PlainTransaction(
    this.date,
    this.effectiveDate,
    this.status,
    this.description,
    this.postings,
  );
}

class Posting {
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

class Amount {
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
