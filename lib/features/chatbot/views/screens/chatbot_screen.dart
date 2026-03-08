import 'dart:io';

import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/core/utilies/styles/app_text_styles.dart';
import 'package:care_link/features/chatbot/models/chat_message_model.dart';
import 'package:care_link/features/chatbot/view_models/cubit/chatbot_cubit.dart';
import 'package:care_link/features/chatbot/view_models/cubit/chatbot_state.dart';
import 'package:care_link/features/chatbot/views/widgets/chat_bubble.dart';
import 'package:care_link/features/chatbot/views/widgets/chat_input_bar.dart';
import 'package:care_link/features/chatbot/views/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _onSend() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;
    _textController.clear();
    context.read<ChatBotCubit>().sendMessage(text);
  }

  Future<void> _onImageSelected(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final text = _textController.text;
    _textController.clear();
    if (!mounted) return;
    context.read<ChatBotCubit>().sendMessageWithImage(
          imageBytes: imageBytes,
          imagePath: imageFile.path,
          text: text.trim().isNotEmpty ? text : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryColor.withOpacity(0.85),
              Colors.grey.shade100,
              Colors.grey.shade100,
            ],
            stops: const [0.0, 0.15, 0.25, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: FadeTransition(
            opacity: _fadeController,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildChatArea()),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width * 0.04,
        vertical: SizeConfig.height * 0.012,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: SizeConfig.width * 0.05,
              ),
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Container(
            padding: EdgeInsets.all(SizeConfig.width * 0.02),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: SizeConfig.width * 0.055,
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.careLinkAI, style: AppTextStyles.title18WhiteBold),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.width * 0.018,
                      height: SizeConfig.width * 0.018,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: SizeConfig.width * 0.012),
                    Text(context.tr.online, style: AppTextStyles.title12White70),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<ChatBotCubit>().resetChat();
            },
            child: Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: SizeConfig.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: BlocConsumer<ChatBotCubit, ChatBotState>(
        listener: (context, state) {
          _scrollToBottom();
        },
        builder: (context, state) {
          if (state.messages.isEmpty) {
            return _buildWelcomeView();
          }
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.02,
            ),
            itemCount:
                state.messages.length + (state is ChatBotLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.messages.length && state is ChatBotLoading) {
                return const TypingIndicator();
              }
              final message = state.messages[index];
              return ChatBubble(
                message: message,
                showTail: _shouldShowTail(state.messages, index),
              );
            },
          );
        },
      ),
    );
  }

  bool _shouldShowTail(List<ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;
    return messages[index].isUser != messages[index + 1].isUser;
  }

  Widget _buildWelcomeView() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.06),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(0.15),
                    AppColors.kPrimaryColor.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: SizeConfig.width * 0.14,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: SizeConfig.height * 0.025),
            Text(
              context.tr.helloCareLink,
              style: AppTextStyles.title20BlackBold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.height * 0.01),
            Text(
              context.tr.personalAssistantDesc,
              style: AppTextStyles.title14Grey,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.height * 0.035),
            _buildSuggestionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      context.tr.explainMedications,
      context.tr.commonColdSymptoms,
      context.tr.understandLabResults,
      context.tr.heartHealthTips,
      context.tr.uploadLabTestImage,
      context.tr.useVoiceToAsk,
    ];

    return Wrap(
      spacing: SizeConfig.width * 0.02,
      runSpacing: SizeConfig.height * 0.01,
      alignment: WrapAlignment.center,
      children: suggestions.map((text) {
        return GestureDetector(
          onTap: () {
            _textController.text =
                text.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '').trim();
            _onSend();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width * 0.04,
              vertical: SizeConfig.height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kPrimaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: SizeConfig.width * 0.032,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputArea() {
    return ChatInputBar(
      controller: _textController,
      onSend: _onSend,
      onImageSelected: _onImageSelected,
    );
  }
}
