import 'dart:io';

import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final void Function(File imageFile) onImageSelected;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onImageSelected,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonScale;
  bool _hasText = false;
  bool _isListening = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sendButtonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
    );
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty || _selectedImage != null;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _sendButtonController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _sendButtonController.forward();
      setState(() => _hasText = true);
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: SizeConfig.height * 0.02),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                context.tr.uploadMedicalImage,
                style: TextStyle(
                  fontSize: SizeConfig.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.005),
              Text(
                context.tr.medicalImageTypes,
                style: TextStyle(
                  fontSize: SizeConfig.width * 0.032,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: SizeConfig.height * 0.025),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: context.tr.camera,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.width * 0.04),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_rounded,
                      label: context.tr.gallery,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.kPrimaryColor,
              size: SizeConfig.width * 0.08,
            ),
            SizedBox(height: SizeConfig.height * 0.008),
            Text(
              label,
              style: TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: SizeConfig.width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.voiceError(error.errorMsg)),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
      );

      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          onResult: (result) {
            widget.controller.text = result.recognizedWords;
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.tr.speechNotAvailablePermission,
              ),
              backgroundColor: Colors.orange.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr.voiceInputFailed,
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _handleSend() {
    if (_selectedImage != null) {
      widget.onImageSelected(_selectedImage!);
      setState(() {
        _selectedImage = null;
        _hasText = widget.controller.text.trim().isNotEmpty;
      });
      if (!_hasText) _sendButtonController.reverse();
    } else {
      widget.onSend();
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _hasText = widget.controller.text.trim().isNotEmpty;
    });
    if (!_hasText) _sendButtonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width * 0.04,
            vertical: SizeConfig.height * 0.01,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image preview
              if (_selectedImage != null) _buildImagePreview(),
              Row(
                children: [
                  // Image picker button
                  _buildActionButton(
                    icon: Icons.image_rounded,
                    onTap: _showImageSourcePicker,
                    isActive: _selectedImage != null,
                  ),
                  SizedBox(width: SizeConfig.width * 0.015),
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: widget.controller,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        minLines: 1,
                        style: TextStyle(
                          fontSize: SizeConfig.width * 0.037,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: _selectedImage != null
                              ? context.tr.addMessageOptional
                              : context.tr.askAboutHealth,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: SizeConfig.width * 0.035,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.width * 0.045,
                            vertical: SizeConfig.height * 0.013,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.width * 0.015),
                  // Voice / Send button
                  if (_hasText || _selectedImage != null)
                    ScaleTransition(
                      scale: _sendButtonScale,
                      child: _buildSendButton(),
                    )
                  else
                    _buildVoiceButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.height * 0.01),
      padding: EdgeInsets.all(SizeConfig.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedImage!,
              width: SizeConfig.width * 0.15,
              height: SizeConfig.width * 0.15,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: SizeConfig.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.imageAttached,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.width * 0.035,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  context.tr.readyToAnalyze,
                  style: TextStyle(
                    fontSize: SizeConfig.width * 0.03,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _removeImage,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.width * 0.015),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: SizeConfig.width * 0.045,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.027),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.kPrimaryColor.withOpacity(0.15)
              : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive
              ? AppColors.kPrimaryColor
              : Colors.grey.shade500,
          size: SizeConfig.width * 0.055,
        ),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(SizeConfig.width * 0.033),
        decoration: BoxDecoration(
          gradient: _isListening
              ? LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.kPrimaryColor,
                    AppColors.kPrimaryDark,
                  ],
                ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _isListening
                  ? Colors.red.withOpacity(0.4)
                  : AppColors.kPrimaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isListening ? Icons.stop_rounded : Icons.mic_rounded,
          color: Colors.white,
          size: SizeConfig.width * 0.055,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _handleSend,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.width * 0.033),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryDark,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: SizeConfig.width * 0.055,
        ),
      ),
    );
  }
}
