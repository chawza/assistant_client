import 'package:assistant_client/core/session_storage.dart';
import 'package:flutter/material.dart';

class ModelConfigurationPage extends StatefulWidget {
  const ModelConfigurationPage({super.key});

  @override
  State<ModelConfigurationPage> createState() => _ModelConfigurationPageState();
}

class _ModelConfigurationPageState extends State<ModelConfigurationPage> {
  TextEditingController baseUrlController = TextEditingController();
  TextEditingController modelsController = TextEditingController();
  TextEditingController apiKeyUrlController = TextEditingController();

  SessionStorage? sessionStorage;

  bool _disableUpdateButton = true;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  void loadSession() async {
    sessionStorage = await SessionStorage.get();

    var modelConfig = sessionStorage!.modelConfig;
    baseUrlController.text = modelConfig.baseUrl;
    modelsController.text = modelConfig.model;
    apiKeyUrlController.text = modelConfig.apiKey;

    setState(() {
      _disableUpdateButton = false;
    });
  }

  void updateConfig() async {
    if (sessionStorage == null) return;

    var modelConfig = sessionStorage!.modelConfig;
    modelConfig.apiKey = apiKeyUrlController.value.text;
    modelConfig.baseUrl = baseUrlController.value.text;
    modelConfig.model = modelsController.value.text;
    await sessionStorage!.saveModelConfig();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Model configuration updated')));
  }

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
                controller: baseUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Open AI Base URL',
                ),
              ),
              TextField(
                controller: modelsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Model Name',
                ),
              ),
              TextFormField(
                controller: apiKeyUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OPENAI_API_KEY',
                ),
                obscureText: true,
              ),
              FilledButton(
                onPressed: !_disableUpdateButton
                    ? () {
                        updateConfig();
                      }
                    : null,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
