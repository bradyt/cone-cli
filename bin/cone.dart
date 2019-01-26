import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'package:cone/src/version.dart';

main(List<String> arguments) {
  var runner = ConeCommandRunner();
  runner.run(arguments);
}

class ConeCommandRunner extends CommandRunner {
  ConeCommandRunner() : super('cone', 'A ledger-like implemented in Dart') {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'Input file',
      valueHelp: 'FILE',
      defaultsTo: '~/.cone.ledger',
    );
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Show version',
      negatable: false,
    );
    addCommand(BalanceCommand());
    addCommand(RegisterCommand());
    addCommand(TestingCommand());
  }
  run(Iterable<String> args) async {
    ArgResults results = super.parse(args);
    if (results['version']) {
      print('cone $packageVersion');
    } else {
      super.run(args);
    }
  }
}

class ConeCommand extends Command {
  String description;
  String name;
  ConeCommand() : super() {}
}

class BalanceCommand extends ConeCommand {
  final String name = 'balance';
  final String description = 'Show accounts and balances (bal)';
  final List<String> aliases = ['bal'];
  void run() {
    print('balance is \$0.00');
  }
}

class RegisterCommand extends ConeCommand {
  final String name = 'register';
  final String description = 'Show accounts and registers (reg)';
  final List<String> aliases = ['reg'];
  void run() {
    print('You have mail');
  }
}

class TestingCommand extends ConeCommand {
  final String name = 'testing';
  final String description = 'This command is reserved for debugging purposes';
  final List<String> aliases = ['test'];
  void run() {
    print(this.globalResults['file']);
    print(this.globalResults.wasParsed('file'));
    print('Goal: print input filename');
    print(Platform.environment['CONE_LEDGER_FILE']);
  }
}
