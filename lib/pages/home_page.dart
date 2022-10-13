import 'package:buscador_cep/models/endereco_model.dart';
import 'package:buscador_cep/repositories/cep_repository.dart';
import 'package:buscador_cep/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  bool loading = false;
  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    cepEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar CEP',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  controller: cepEC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CEP obrigatório';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      final valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          final endereco =
                              await cepRepository.getCep(cepEC.text);
                          setState(() {
                            loading = false;
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            loading = false;
                            enderecoModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao buscar endereço')),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Buscar CEP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
              ),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}',
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
