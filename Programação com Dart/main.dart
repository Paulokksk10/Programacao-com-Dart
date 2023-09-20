import 'dart:io';
class Titular {
  static int contadorIds = 1;
  int id;
  String nome;
  String telefone;
  String endereco;
  List<Conta> contas = [];

  Titular(this.nome, this.telefone, this.endereco) : id = contadorIds++;

  void adicionarConta(Conta conta) {
    contas.add(conta);
  }

  @override
  String toString() {
    return 'ID: $id\nNome: $nome\nTelefone: $telefone\nEndereço: $endereco';
  }
}

class Conta {
  static int contadorIds = 1;
  int id;
  double saldo;
  Titular titular;
  String descricao;

  Conta(this.saldo, this.titular, this.descricao) : id = contadorIds++;

  void depositar(double valor) {
    if (valor > 0) {
      saldo += valor;
      print('Depósito de $valor realizado com sucesso. Novo saldo: $saldo');
    } else {
      print('Valor de depósito inválido.');
    }
  }

  void sacar(double valor) {
    if (valor > 0 && valor <= saldo) {
      saldo -= valor;
      print('Saque de $valor realizado com sucesso. Novo saldo: $saldo');
    } else {
      print('Saldo insuficiente ou valor de saque inválido.');
    }
  }

  @override
  String toString() {
    return 'ID da Conta: $id\nSaldo: $saldo\nTitular:\n${titular.nome}\nDescrição:\n$descricao';
  }
}

class Banco {
  List<Titular> titulares;
  List<Conta> contas;

  Banco() : titulares = [], contas = [];

  void cadastrarTitular(Titular titular) {
    titulares.add(titular);
  }

  void abrirConta(Conta conta) {
    contas.add(conta);
    conta.titular.adicionarConta(conta);
  }

  void listarTitulares() {
    print('Lista de Titulares:');
    for (var titular in titulares) {
      print('ID: ${titular.id}, Nome: ${titular.nome}');
    }
  }

  void listarContas() {
    print('Lista de Contas:');
    for (var conta in contas) {
      print('ID da Conta: ${conta.id}, Saldo: ${conta.saldo}, Titular: ${conta.titular.nome}');
    }
  }
}
void main() {
  Banco banco = Banco();
  int opcao = -1;

  do {
    print('Menu Principal:');
    print('1. Cadastro de Titular');
    print('2. Cadastro de Conta');
    print('3. Operar Conta');
    print('4. Sair');
    stdout.write('Escolha uma opção: ');

    try {
      opcao = int.parse(stdin.readLineSync()!);

      switch (opcao) {
        case 1:
          cadastrarTitularMenu(banco);
          break;
        case 2:
          cadastrarContaMenu(banco);
          break;
        case 3:
          operarContaMenu(banco);
          break;
        case 4:
          print('Encerrando o programa.');
          break;
        default:
          print('Opção inválida. Tente novamente.');
      }
    } catch (e) {
      print('Entrada inválida. Tente novamente.');
    }
  } while (opcao != 4);
}

void cadastrarTitularMenu(Banco banco) {
  int opcao = -1;
  do {
    print('\nMenu de Cadastro de Titular:');
    print('1. Cadastrar Titular');
    print('2. Listar Titulares');
    print('3. Voltar ao Menu Principal');
    stdout.write('Escolha uma opção: ');

    try {
      opcao = int.parse(stdin.readLineSync()!);

      switch (opcao) {
        case 1:
          cadastrarTitular(banco);
          break;
        case 2:
          banco.listarTitulares();
          break;
        case 3:
          print('Voltando ao Menu Principal.');
          break;
        default:
          print('Opção inválida. Tente novamente.');
      }
    } catch (e) {
      print('Entrada inválida. Tente novamente.');
    }
  } while (opcao != 3);
}

void cadastrarTitular(Banco banco) {
  stdout.write('Digite o nome do titular: ');
  String nome = stdin.readLineSync()!;
  stdout.write('Digite o telefone do titular: ');
  String telefone = stdin.readLineSync()!;
  stdout.write('Digite o endereço do titular: ');
  String endereco = stdin.readLineSync()!;

  Titular titular = Titular(nome, telefone, endereco);
  banco.cadastrarTitular(titular);
  print('Titular cadastrado com sucesso.');
}

void cadastrarContaMenu(Banco banco) {
  int opcao = -1;
  do {
    print('\nMenu de Cadastro de Conta:');
    print('1. Cadastrar Conta');
    print('2. Listar Contas');
    print('3. Voltar ao Menu Principal');
    stdout.write('Escolha uma opção: ');

    try {
      opcao = int.parse(stdin.readLineSync()!);

      switch (opcao) {
        case 1:
          cadastrarConta(banco);
          break;
        case 2:
          banco.listarContas();
          break;
        case 3:
          print('Voltando ao Menu Principal.');
          break;
        default:
          print('Opção inválida. Tente novamente.');
      }
    } catch (e) {
      print('Entrada inválida. Tente novamente.');
    }
  } while (opcao != 3);
}

void cadastrarConta(Banco banco) {
  stdout.write('Digite o saldo da conta: ');
  double saldo = double.parse(stdin.readLineSync()!);
  stdout.write('Digite a descrição da conta: ');
  String descricao = stdin.readLineSync()!;

  banco.listarTitulares();
  stdout.write('Digite o ID do titular para associar a esta conta: ');
  int idTitular = int.parse(stdin.readLineSync()!);

  Titular? titularEncontrado = banco.titulares
      .where((titular) => titular.id == idTitular)
      .firstOrNull; 

  if (titularEncontrado != null) {
    Conta conta = Conta(saldo, titularEncontrado, descricao);
    banco.abrirConta(conta);
    print('Conta cadastrada com sucesso.');
  } else {
    print('Titular não encontrado com o ID fornecido.');
  }
}


void operarContaMenu(Banco banco) {
  int opcao = -1;
  do {
    print('\nMenu de Operações de Conta:');
    print('1. Sacar');
    print('2. Depositar');
    print('3. Transferir');
    print('4. Mostrar Saldo');
    print('5. Voltar ao Menu Principal');
    stdout.write('Escolha uma opção: ');

    try {
      opcao = int.parse(stdin.readLineSync()!);

      switch (opcao) {
        case 1:
          sacar(banco);
          break;
        case 2:
          depositar(banco);
          break;
        case 3:
          transferir(banco);
          break;
        case 4:
          mostrarSaldo(banco);
          break;
        case 5:
          print('Voltando ao Menu Principal.');
          break;
        default:
          print('Opção inválida. Tente novamente.');
      }
    } catch (e) {
      print('Entrada inválida. Tente novamente.');
    }
  } while (opcao != 5);
}

void sacar(Banco banco) {
  banco.listarContas();
  stdout.write('Digite o ID da conta para sacar: ');
  int idConta = int.parse(stdin.readLineSync()!);
   Conta? conta = banco.contas
      .where((conta) => conta.id == idConta)
      .firstOrNull; 

  if (conta != null) {
    stdout.write('Digite o valor para sacar: ');
    double valor = double.parse(stdin.readLineSync()!);

    if (valor > 0) {
      conta.sacar(valor);
    } else {
      print('Valor de saque inválido.');
    }
  } else {
    print('Conta não encontrada com o ID fornecido.');
  }
}

void depositar(Banco banco) {
  banco.listarContas();
  stdout.write('Digite o ID da conta para depositar: ');
  int idConta = int.parse(stdin.readLineSync()!);
   Conta? conta = banco.contas
      .where((conta) => conta.id == idConta)
      .firstOrNull;

  if (conta != null) {
    stdout.write('Digite o valor para depositar: ');
    double valor = double.parse(stdin.readLineSync()!);

    if (valor > 0) {
      conta.depositar(valor);
    } else {
      print('Valor de depósito inválido.');
    }
  } else {
    print('Conta não encontrada com o ID fornecido.');
  }
}

void transferir(Banco banco) {
  banco.listarContas();
  stdout.write('Digite o ID da conta de origem: ');
  int idContaOrigem = int.parse(stdin.readLineSync()!);
  Conta? contaOrigem = banco.contas
      .where((conta) => conta.id == idContaOrigem)
      .firstOrNull; 


  if (contaOrigem != null) {
    stdout.write('Digite o ID da conta de destino: ');
    int idContaDestino = int.parse(stdin.readLineSync()!);
    Conta? contaDestino = banco.contas
    .where((conta) => conta.id == idContaDestino).firstOrNull; 

    if (contaDestino != null) {
      stdout.write('Digite o valor a transferir: ');
      double valor = double.parse(stdin.readLineSync()!);

      if (valor > 0 && valor <= contaOrigem.saldo) {
        contaOrigem.sacar(valor);
        contaDestino.depositar(valor);
        print('Transferência realizada com sucesso.');
      } else {
        print('Valor de transferência inválido ou saldo insuficiente na conta de origem.');
      }
    } else {
      print('Conta de destino não encontrada com o ID fornecido.');
    }
  } else {
    print('Conta de origem não encontrada com o ID fornecido.');
  }
}

void mostrarSaldo(Banco banco) {
  banco.listarContas();
  stdout.write('Digite o ID da conta para mostrar o saldo: ');
  int idConta = int.parse(stdin.readLineSync()!);
   Conta? conta = banco.contas
      .where((conta) => conta.id == idConta)
      .firstOrNull; 

  if (conta != null) {
    print('Saldo da Conta ID ${conta.id}: ${conta.saldo}');
  } else {
    print('Conta não encontrada com o ID fornecido.');
  }
}

