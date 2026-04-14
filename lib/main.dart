import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)),
      home: const CalculadoraPage(),
    );
  }
}

// Widget do Display
class DisplayCalculadora extends StatelessWidget {
  final String expressao;
  final String resultado;

  const DisplayCalculadora({
    super.key,
    required this.expressao,
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            expressao,
            style: const TextStyle(fontSize: 22, color: Colors.white54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            resultado,
            style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Widget do Botão
class BotaoCalculadora extends StatelessWidget {
  final String texto;
  final Color corFundo;
  final Color corTexto;
  final VoidCallback aoPressed;
  final bool largo;

  const BotaoCalculadora({
    super.key,
    required this.texto,
    required this.corFundo,
    required this.corTexto,
    required this.aoPressed,
    this.largo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: largo ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: aoPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: corFundo,
            foregroundColor: corTexto,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

// Página principal
class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _expressao = '';
  String _display = '0';
  double _numero1 = 0;
  double _numero2 = 0;
  String _operador = '';
  bool _novaEntrada = false;

  void _pressionarNumero(String numero) {
    setState(() {
      if (_novaEntrada) {
        _display = numero;
        _novaEntrada = false;
      } else {
        _display = _display == '0' ? numero : _display + numero;
      }
    });
  }

  void _pressionarOperador(String operador) {
    setState(() {
      _numero1 = double.tryParse(_display) ?? 0;
      _operador = operador;
      _expressao = '$_display $operador';
      _novaEntrada = true;
    });
  }

  void _calcular() {
    if (_operador.isEmpty) return;

    setState(() {
      _numero2 = double.tryParse(_display) ?? 0;
      double resultado = 0;

      switch (_operador) {
        case '+':
          resultado = _numero1 + _numero2;
          break;
        case '-':
          resultado = _numero1 - _numero2;
          break;
        case 'x':
          resultado = _numero1 * _numero2;
          break;
        case '÷':
          resultado = _numero2 != 0 ? _numero1 / _numero2 : 0;
          break;
      }

      _expressao = '$_numero1 $_operador $_numero2 =';
      _display = resultado % 1 == 0 ? resultado.toInt().toString() : resultado.toString();
      _operador = '';
      _novaEntrada = true;
    });
  }

  void _limpar() {
    setState(() {
      _display = '0';
      _expressao = '';
      _numero1 = 0;
      _numero2 = 0;
      _operador = '';
      _novaEntrada = false;
    });
  }

  void _apagar() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const corEscura = Color(0xFF2D2D2D);
    const corOperador = Color(0xFFFF9500);
    const corClara = Color(0xFF505050);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            DisplayCalculadora(expressao: _expressao, resultado: _display),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: [
                        BotaoCalculadora(texto: 'C', corFundo: const Color(0xFFA5A5A5), corTexto: Colors.black, aoPressed: _limpar),
                        BotaoCalculadora(texto: '⌫', corFundo: corClara, corTexto: Colors.white, aoPressed: _apagar),
                        BotaoCalculadora(texto: '%', corFundo: corClara, corTexto: Colors.white, aoPressed: () => _pressionarNumero('%')),
                        BotaoCalculadora(texto: '÷', corFundo: corOperador, corTexto: Colors.white, aoPressed: () => _pressionarOperador('÷')),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        BotaoCalculadora(texto: '7', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('7')),
                        BotaoCalculadora(texto: '8', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('8')),
                        BotaoCalculadora(texto: '9', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('9')),
                        BotaoCalculadora(texto: 'x', corFundo: corOperador, corTexto: Colors.white, aoPressed: () => _pressionarOperador('x')),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        BotaoCalculadora(texto: '4', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('4')),
                        BotaoCalculadora(texto: '5', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('5')),
                        BotaoCalculadora(texto: '6', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('6')),
                        BotaoCalculadora(texto: '-', corFundo: corOperador, corTexto: Colors.white, aoPressed: () => _pressionarOperador('-')),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        BotaoCalculadora(texto: '1', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('1')),
                        BotaoCalculadora(texto: '2', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('2')),
                        BotaoCalculadora(texto: '3', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('3')),
                        BotaoCalculadora(texto: '+', corFundo: corOperador, corTexto: Colors.white, aoPressed: () => _pressionarOperador('+')),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        BotaoCalculadora(texto: '0', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('0'), largo: true),
                        BotaoCalculadora(texto: '.', corFundo: corEscura, corTexto: Colors.white, aoPressed: () => _pressionarNumero('.')),
                        BotaoCalculadora(texto: '=', corFundo: corOperador, corTexto: Colors.white, aoPressed: _calcular),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
