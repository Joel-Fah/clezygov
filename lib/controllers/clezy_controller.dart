import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/prompt.dart';

class ClezyController extends GetxController {
  Rx<bool> _isClezyDialogShown = false.obs;
  String _textFieldText = '';
  Future<GenerateContentResponse>? _generatedContentFuture;
  final List<Prompt> _prompts = [];
  int _lastUserPromptIndex = -1; // Track the index of the last user prompt

  bool get isClezyDialogShown => _isClezyDialogShown.value;
  String get textFieldText => _textFieldText;
  Future<GenerateContentResponse>? get generatedContentFuture => _generatedContentFuture;
  List<Prompt> get prompts => _prompts;
  int get lastUserPromptIndex => _lastUserPromptIndex;

  final GetStorage storage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    _isClezyDialogShown.value = storage.read('showClezyDialog') ?? false;
  }

  // toggle the visibility of the Clezy dialog
  void toggleClezyDialog() {
    _isClezyDialogShown.value = !_isClezyDialogShown.value;
    update();
  }

  // function to update the text field value
  void getTextFieldValue(String text) {
    _textFieldText = text;
    update();
  }

  // Function to get the value of the text field and return response from model
  Future<void> generateContent(String text) async {
    // Load .env
    await dotenv.load(fileName: ".env");

    // Gemini API key
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      generationConfig: GenerationConfig(
        temperature: 0.8,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 9192,
        responseMimeType: 'text/plain',
      ),
    );

    final content = [Content.text(text)];
    final response = await model.generateContent(content);

    // Add the prompt and generated content to the list
    _prompts.add(Prompt(
      text: text,
      generatedContent: response.text ?? '',
      date: DateTime.now(),
    ));

    _lastUserPromptIndex = _prompts.length - 1; // Update the last user prompt index

    _generatedContentFuture = Future.value(response);
    update();
  }
}