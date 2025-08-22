import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../data/services/profile_data.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/snackbars.dart';
import '../../../widgets/state_lga_dropdown.dart';

class MerchantCompleteAuth extends StatefulWidget {
  const MerchantCompleteAuth({super.key});

  @override
  State<MerchantCompleteAuth> createState() => _MerchantCompleteAuthState();
}



class _MerchantCompleteAuthState extends State<MerchantCompleteAuth> {
  final AuthController authController = Get.find<AuthController>();

  File? faceImage;
  List<String> selectedServices = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ninController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        businessNameController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        whatsappController.text.trim().isNotEmpty &&
        selectedServices.isNotEmpty &&
        authController.selectedState != null &&
        authController.selectedLga != null &&
        faceImage != null;
  }

  void register() {
    if (!isFormValid) return;

    print("Selected services before sending: $selectedServices");

    final validServices = selectedServices.where((service) =>
        ['car-hire', 'cleaning', 'real-estate', 'car-parts', 'automobile'].contains(service)
    ).toList();

    print("Valid services only: $validServices");


    authController.registerMerchant(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      businessName: businessNameController.text.trim(),
      businessAddress: addressController.text.trim(),
      nin: ninController.text.trim(),
      state: authController.selectedState!,
      lga: authController.selectedLga!,
      servicesOffered: validServices,
      whatsappNumber: whatsappController.text.trim(),
      avatar: faceImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'Register as a Merchant',
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: Dimensions.height30),
                Text(
                  'Fill Required Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: Dimensions.font17,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
        
                buildField("Full Name", nameController),
                buildField("Email Address", emailController),
                buildField("Business Name", businessNameController),
        
                SizedBox(height: Dimensions.height10),
                StateLgaDropdown(
                  selectedState: authController.selectedState,
                  selectedLga: authController.selectedLga,
                  onStateChanged: (val) => setState(() => authController.selectedState = val),
                  onLgaChanged: (val) => setState(() => authController.selectedLga = val),
                ),
        
                buildField("Business Address", addressController),
        
                SizedBox(height: Dimensions.height20),
                Text("Face Verification", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Dimensions.height10),
                buildImageUploadSection(context),
        
                buildField("WhatsApp Number", whatsappController),
        
                SizedBox(height: Dimensions.height20),
                Text("Select Services Offered", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Dimensions.height10),
        
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: merchantServicesMap.entries.map((entry) {
                    final label = entry.key;
                    final slug = entry.value;
                    final selected = selectedServices.contains(slug);
                    return FilterChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          value ? selectedServices.add(slug) : selectedServices.remove(slug);
                        });
                      },
                    );
                  }).toList(),
                ),
        
                SizedBox(height: Dimensions.height30),
                CustomButton(
                  text: 'Submit Details',
                  isDisabled: !isFormValid,
                  onPressed: register,
                ),
                SizedBox(height: Dimensions.height50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: Dimensions.height5),
        CustomTextField(controller: controller, hintText: label),
        SizedBox(height: Dimensions.height15),
      ],
    );
  }

  Widget buildImageUploadSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        color: Colors.grey.shade100.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Upload Face Verification Image',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.font16)),
          SizedBox(height: Dimensions.height10),
          Text('This helps us verify your identity.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.font14, color: Colors.grey[600])),
          SizedBox(height: Dimensions.height15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showImageSourceSheet(context),
                icon: Icon(Icons.camera_alt),
                label: Text("Upload Image"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (faceImage != null) ...[
                SizedBox(width: 16),
                CircleAvatar(radius: 30, backgroundImage: FileImage(faceImage!)),
              ]
            ],
          )
        ],
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndCompressImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Photo'),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndCompressImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndCompressImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100, // original quality for compression later
    );

    if (pickedFile == null) return;

    // ✅ Only accept png or jpg
    final extension = path.extension(pickedFile.path).toLowerCase();
    if (extension != '.png' && extension != '.jpg' && extension != '.jpeg') {
      MySnackBars.failure(title: "Invalid File", message: "Please select a PNG or JPG image.");
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(tempDir.path, 'compressed_${path.basename(pickedFile.path)}');

    final compressed = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 60,
      minWidth: 600,
      minHeight: 600,
      format: extension == '.png'
          ? CompressFormat.png
          : CompressFormat.jpeg,
    );

    if (compressed == null) {
      MySnackBars.failure(title: "Compression Failed", message: "Could not compress image.");
      return;
    }

    // ✅ Check size limit (2MB = 2097152 bytes)
    final imageSize = await compressed.length();
    if (imageSize > 2 * 1024 * 1024) {
      MySnackBars.failure(title: "Image Too Large", message: "Please upload an image under 2MB.");
      return;
    }

    setState(() {
      faceImage = File(compressed.path);
    });

    print("✅ Compressed Image Path: ${compressed.path}");
    print("📦 Image Size: ${imageSize / 1024} KB");
  }

}
