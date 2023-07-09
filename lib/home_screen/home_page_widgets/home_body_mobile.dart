import 'package:flutter/material.dart';
import 'package:language_translation_app/home_screen/home_page_widgets/translation_button.dart';
import '../../helper_classes/text_translation_service.dart';
import '../language_box_widgets/text_box_input.dart';
import '../language_box_widgets/text_box_translated.dart';
import '../language_selection_widgets/language_selection_row.dart';

class LanguageTranslationBodyMobile extends StatefulWidget {
  const LanguageTranslationBodyMobile({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageTranslationBodyMobileState();
}

class _LanguageTranslationBodyMobileState extends State<LanguageTranslationBodyMobile> {
  final TextTranslationService _textTranslationService = TextTranslationService();
  final TextEditingController _languageController = TextEditingController();
  Future<String> _translatedText = Future.value('Awaiting translation...');
  String _inputText = '';
  String _sourceLanguage = '';
  String _targetLanguage = '';
  List<Map<String, String>> _items = [];

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  @override
  void dispose() {
    super.dispose();
    _languageController.dispose();
  }

  Future<void> _initializeLanguages() async {
    final List<Map<String, String>> languages =
        await _textTranslationService.getLanguages();
    setState(() {
      _items = languages;
      _sourceLanguage = _items.first['code']!;
      _targetLanguage = _items.first['code']!;
    });
  }

  void _controllerCallBack(String text) {
      text = _languageController.text;
    setState(() {
      _inputText = text;
    });
  }

  void _onSourceLanguageChanged(String value) async {
    setState(() {
      _sourceLanguage =
          _items.firstWhere((language) => language['name'] == value)['code']!;
    });
  }

  void _onTargetLanguageChanged(String value) async {
    setState(() {
      _targetLanguage =
          _items.firstWhere((language) => language['name'] == value)['code']!;
    });
  }

  Future<String> _translateText() async {
    setState(() {
      _translatedText = _textTranslationService.translateLanguage(
          _sourceLanguage, _targetLanguage, _inputText);
    });
    return _translatedText;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LanguageSelectionRow(
                  onSourceLanguageChanged: _onSourceLanguageChanged,
                  onTargetLanguageChanged: _onTargetLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputBox(
                  controller: _languageController,
                  function: _controllerCallBack,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TranslationButton(translateLanguage: _translateText),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TranslatedBox(translatedText: _translatedText),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}