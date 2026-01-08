import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo à sua Tela Inicial!'),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Ação do botão
              },
              child: const Text('Clique Aqui'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação do botão flutuante
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Nome do Usuário'),
              accountEmail: Text('usuario@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('N'),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Navegue para a tela 1
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Navegue para a tela 2
              },
            ),
          ],
        ),
      ),
    );
  }
}
