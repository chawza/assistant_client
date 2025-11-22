import 'package:flutter/material.dart';

class ModelConfigurationPage extends StatefulWidget {
  const ModelConfigurationPage({super.key});

  @override
  State<ModelConfigurationPage> createState() => _ModelConfigurationPageState();
}

class _ModelConfigurationPageState extends State<ModelConfigurationPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Model Confiugration')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: .all(10.0),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 10.0,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Open AI Base URL',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Model Name',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OPENAI_API_KEY',
                ),
                obscureText: true,
              ),
              FilledButton(onPressed: () {}, child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
