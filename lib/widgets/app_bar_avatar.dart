import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/app_controller.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/screens/auth/merchant/merchant_complete_auth.dart';
import 'package:fyndr/widgets/avatar_upload_widget.dart';
import 'package:get/get.dart';

import '../helpers/global_loader_controller.dart';
import '../helpers/image_cache.dart';
import '../screens/main_menu/user/navigation.dart';
import '../utils/app_constants.dart';
import '../utils/dimensions.dart';
import 'attach_media_btn.dart';

class AppBarAvatar extends StatefulWidget {
  final String? avatarUrl;

  const AppBarAvatar({super.key, this.avatarUrl});

  @override
  State<AppBarAvatar> createState() => _AppBarAvatarState();
}

class _AppBarAvatarState extends State<AppBarAvatar> {
  AppController appController = Get.find<AppController>();
  bool showAttachmentOverlay = false;
  String? avatarUrl;
  File? selectedImageFile;
  File? cachedImageFile;
  bool isDownloading = false;
  String? lastDownloadedUrl;
  final ImageCacheService _cacheService = ImageCacheService();
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    avatarUrl = widget.avatarUrl;
    _loadCachedImage();
  }

  @override
  void didUpdateWidget(AppBarAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👉 only react when the URL changes
    if (oldWidget.avatarUrl != widget.avatarUrl) {
      setState(() {
        avatarUrl = widget.avatarUrl;
        selectedImageFile = null;
        cachedImageFile = null;
        lastDownloadedUrl = null;
      });
      _loadCachedImage();
    }
  }

  Future<void> _loadCachedImage() async {
    if (avatarUrl == null ||
        avatarUrl!.isEmpty ||
        !avatarUrl!.startsWith('http'))
      return;

    final cachedFile = await _cacheService.getCachedImage(avatarUrl!);
    if (cachedFile != null && cachedFile.existsSync()) {
      setState(() {
        cachedImageFile = cachedFile;
        lastDownloadedUrl = avatarUrl;
      });
    } else {
      _downloadAndCacheImage();
    }
  }

  Future<void> _downloadAndCacheImage() async {
    if (isDownloading || avatarUrl == null || !avatarUrl!.startsWith('http'))
      return;

    setState(() => isDownloading = true);
    Get.find<GlobalLoaderController>().showLoader();

    try {
      final cachedFile = await _cacheService.cacheImageFromUrl(avatarUrl!);
      if (cachedFile != null) {
        setState(() {
          cachedImageFile = cachedFile;
          lastDownloadedUrl = avatarUrl;
        });
      }
    } catch (e) {
      debugPrint('🛑 Failed to download: $e');
    } finally {
      isDownloading = false;
      Get.find<GlobalLoaderController>().hideLoader();
    }
  }

  ImageProvider _getImageProvider() {
    if (selectedImageFile != null) {
      return FileImage(selectedImageFile!);
    } else if (cachedImageFile != null && cachedImageFile!.existsSync()) {
      return FileImage(cachedImageFile!);
    } else if (avatarUrl != null && avatarUrl!.startsWith('http')) {
      return NetworkImage(avatarUrl!);
    } else {
      return AssetImage(AppConstants.getPngAsset('user'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Get.to(() => const Navigation(), arguments: 1)
            appController.changeCurrentAppPage(3);
            print('tapped');
          },
          child: Container(
            height: Dimensions.height100 * 1.5,
            width: Dimensions.width100 * 1.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _getImageProvider(),
                onError: (_, __) => debugPrint('🛑 Failed to load image'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
