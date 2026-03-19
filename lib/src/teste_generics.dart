abstract class SimuladorClient {
  T formatarDado<T>(String dadoBruto, T Function(String) conversor) {
    print("Log: Recebi do servidor: $dadoBruto");
    return conversor(dadoBruto);
  }
}

class MeuApp extends SimuladorClient {}

void main() {
  var app = MeuApp();

  final dado1 = app.formatarDado<int?>('123', (s) => int.tryParse(s));
  print(dado1);
}
