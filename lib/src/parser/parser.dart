part of cone.parser;

List<JournalItems> journal = [];

class JournalItems {}

List<Transaction> transactions = [];

class Status {}

class Amount {}

class Posting {
  Status status;
  String account;
  Amount amount;
}

class Transaction {
  DateTime date;
  DateTime eDate;
  Status status;
  String code;
  String description;
  String comment;
  Set<Posting> postings;
  String toString() {
    return '''$date $status $description
''';
  }
}

class LedgerParserDefinition extends LedgerGrammarDefinition {
  Parser int4() => super.int4().flatten();
  Parser int2() => super.int2().flatten();
  Parser date() => super.date().map((it) {
        List<int> result = [];
        if (it[0] != null) {
          result.add(int.parse(it[0][0]));
        }
        result.add(int.parse(it[1]));
        result.add(int.parse(it[3]));
        return result;
      });
  // Parser comment() => comment().pick(1);
  Parser description() => super.description().flatten();
  Parser account() => super.account().flatten();
  Parser amount() => super.amount().flatten();
  // Parser posting() => super.posting().flatten();
}

class LedgerParser extends GrammarParser {
  LedgerParser() : super(LedgerParserDefinition());
}
