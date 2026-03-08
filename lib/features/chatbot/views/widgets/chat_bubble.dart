import 'dart:io';

import 'package:care_link/core/locale/app_localizations_ext.dart';
import 'package:care_link/core/utilies/colors/app_colors.dart';
import 'package:care_link/core/utilies/sizes/sized_config.dart';
import 'package:care_link/features/chatbot/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTail;

  const ChatBubble({
    super.key,
    required this.message,
    this.showTail = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final timeStr = DateFormat('hh:mm a').format(message.timestamp);

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            showTail ? SizeConfig.height * 0.012 : SizeConfig.height * 0.004,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            if (showTail)
              _buildAiAvatar()
            else
              SizedBox(width: SizeConfig.width * 0.08),
            SizedBox(width: SizeConfig.width * 0.02),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.width * 0.04,
                vertical: SizeConfig.height * 0.012,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser || !showTail ? 20 : 4),
                  bottomRight: Radius.circular(!isUser || !showTail ? 20 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? AppColors.kPrimaryColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Show image if present
                  if (message.imagePath != null) ...[
                    GestureDetector(
                      onTap: () => _showFullImage(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(message.imagePath!),
                          width: SizeConfig.width * 0.5,
                          height: SizeConfig.width * 0.5,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: SizeConfig.width * 0.5,
                              height: SizeConfig.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey.shade400,
                                    size: SizeConfig.width * 0.08,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    context.tr.imageUnavailable,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: SizeConfig.width * 0.03,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.height * 0.008),
                  ],
                  // Text content
                  if (message.text.isNotEmpty)
                    Text(
                      isUser ? message.text : message.text.replaceAll('*', ''),
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: SizeConfig.width * 0.037,
                        height: 1.45,
                      ),
                    )
                  else if (message.imagePath != null && isUser)
                    Text(
                      context.tr.analyzeThisImage,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: SizeConfig.width * 0.032,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  SizedBox(height: SizeConfig.height * 0.004),
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey.shade400,
                      fontSize: SizeConfig.width * 0.026,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: SizeConfig.width * 0.02),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    if (message.imagePath == null) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(SizeConfig.width * 0.05),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                child: Image.file(
                  File(message.imagePath!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: SizeConfig.width * 0.08,
      height: SizeConfig.width * 0.08,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kPrimaryColor.withOpacity(0.7),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: SizeConfig.width * 0.04,
      ),
    );
  }
}
