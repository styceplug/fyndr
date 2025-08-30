import 'dart:ffi';
import 'dart:io';
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

import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/data/services/employment_data.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/lga_multi-select.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../data/services/states_lga_local.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/attach_media_btn.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/dropdown_textfield.dart';
import '../../widgets/snackbars.dart';

class PostCvScreen extends StatefulWidget {
  const PostCvScreen({super.key});

  @override
  State<PostCvScreen> createState() => _PostCvScreenState();
}

class _PostCvScreenState extends State<PostCvScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  String? selectedState;
  String? selectedLga;
  TextEditingController locationController = TextEditingController();
  bool? graduate;
  String? education;
  TextEditingController studyController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool? experience;
  TextEditingController yearsExperience = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  List<String> selectedSkills = [];
  List<String> language = [];
  TextEditingController certificateController = TextEditingController();
  RequestController requestController = Get.find<RequestController>();
  File? cvImageFile;

  bool acceptTerms = false;

  void policy() {
    setState(() {
      acceptTerms = !acceptTerms;
    });
  }

  bool get isFormValid {
    return locationController.text.trim().isNotEmpty && acceptTerms;
  }


  void submitRequest() async {
    if (!isFormValid) {
      MySnackBars.failure(
        title: "Incomplete",
        message: "Please complete all fields and accept the policy.",
      );
      return;
    }

    print(
      "State: $selectedState, "
          "LGA: $selectedLga, "
          "Graduate: $graduate, "
          "Education: $education, "
          "Study: ${studyController.text}, "
          "School: ${schoolController.text}, "
          "Start Date: ${startDate?.toString()}, "
          "End Date: ${endDate?.toString()}, "
          "Experience: $experience, "
          "Years of Experience: ${yearsExperience.text}, "
          "Company Name: ${companyName.text}, "
          "Job Title: ${jobTitle.text}, "
          "Skills: $selectedSkills "
          "Certificate: ${certificateController.text}, "
          "Language: $language, "
          "Location: ${locationController.text}, "
          "First Name: ${firstNameController.text}, "
          "Last Name: ${lastNameController.text}, "
          "Phone: ${phoneController.text}, "
          "Email: ${mailController.text}, "
          "Accept Terms: $acceptTerms",
    );

    Get.dialog(
      AlertDialog(
        title: Text("Disclaimer"),
        content: SingleChildScrollView(
          child: Text(
            "Fyndr acts solely as a platform to ensure your request is delivered to your selected service providers. "
                "We are not affiliated with, nor do we endorse or partner with, any of the service providers listed on the platform. "
                "Our involvement ends once communication begins between you and the service provider. "
                "The fee paid is strictly for facilitating the delivery of your request and does not guarantee the outcome or success of any transaction.",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // dismiss
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              final apiSkills = selectedSkills
                  .map((label) => skillsMap[label] ?? label)
                  .toList();

              List<Map<String, String>>? workExperienceDetails;
              if (experience == true &&
                  companyName.text.isNotEmpty &&
                  jobTitle.text.isNotEmpty) {
                workExperienceDetails = [
                  {
                    "jobTitle": jobTitle.text,
                    "companyName": companyName.text,
                    "startYear": startDate?.year.toString() ?? "",
                    "endYear": endDate?.year.toString() ?? "",
                  }
                ];
              }

              final body = {
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                "number": phoneController.text,
                "email": mailController.text,
                "state": selectedState ?? "",
                "lga": selectedLga ?? "",
                "area": locationController.text,
                "isGraduate": graduate ?? false,
                "educationLevel": education ?? "",
                "educationMajor": studyController.text,
                "schoolName": schoolController.text,
                "startYear": startDate?.year.toString() ?? "",
                "endYear": endDate?.year.toString() ?? "",
                "hasWorkExperience": experience ?? false,
                if (workExperienceDetails != null)
                  "workExperienceDetails": workExperienceDetails,
                "skills": apiSkills,
                "additionalCertificate": certificateController.text,
                "languages": language ?? [],
              };

              await requestController.postCv(body, image: cvImageFile);

              setState(() {
                selectedState = null;
                selectedLga = null;
                graduate = null;
                education = null;
                studyController.clear();
                schoolController.clear();
                startDate = null;
                endDate = null;
                experience = null;
                yearsExperience.clear();
                companyName.clear();
                jobTitle.clear();
                selectedSkills = [];
                certificateController.clear();
                language = [];
                firstNameController.clear();
                lastNameController.clear();
                phoneController.clear();
                mailController.clear();
                locationController.clear();
                cvImageFile = null;
                acceptTerms = false;
              });
            },
            child: Text("I Understand"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Create a CV Posting',
        leadingIcon: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Dimensions.width20,
            Dimensions.width20,
            Dimensions.width20,
            Dimensions.height50,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdsCarousel(),
              SizedBox(height: Dimensions.height20),

              //cv image
              buildImageUploadSection(context),
              SizedBox(height: Dimensions.height10),

              //data
              CustomTextField(
                hintText: 'First Name',
                controller: firstNameController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Last Name',
                controller: lastNameController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Phone number',
                controller: phoneController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Email Address',
                controller: mailController,
              ),
              SizedBox(height: Dimensions.height20),

              /// State & LGA
              Column(
                children: [
                  DropdownTextField<String>(
                    label: 'Select State',
                    items: stateLgaMap.keys.toList(),
                    selectedItem: selectedState,
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                        selectedLga = null;
                      });
                    },
                    itemToString: (val) => val,
                  ),
                  SizedBox(height: Dimensions.height20),
                  DropdownTextField<String>(
                    label: 'Select LGA',
                    items:
                        selectedState != null
                            ? stateLgaMap[selectedState!] ?? []
                            : [],
                    selectedItem: selectedLga,
                    onChanged: (value) => setState(() => selectedLga = value),
                    itemToString: (val) => val,
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Home Address',
                maxLines: 1,
                controller: locationController,
              ),
              SizedBox(height: Dimensions.height20),

              DropdownTextField<bool>(
                label: 'Graduate',
                items: [true, false],
                selectedItem: graduate,
                onChanged: (value) {
                  setState(() {
                    graduate = value;
                  });
                },
                itemToString: (val) => val ? 'Yes' : 'No',
              ),

              SizedBox(height: Dimensions.height20),

              DropdownTextField<String>(
                label: 'Level of Education',
                items: const [
                  "none",
                  "primary",
                  "secondary",
                  "university",
                ],
                selectedItem: education,
                onChanged: (value) {
                  setState(() {
                    education = value;
                  });
                },
                itemToString: (val) => val ?? '',
              ),
              SizedBox(height: Dimensions.height20),

              CustomTextField(
                hintText: 'Field of Study',
                controller: studyController,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'School Name',
                maxLines: 1,
                controller: schoolController,
              ),
              SizedBox(height: Dimensions.height20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Select Start Year"),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: YearPicker(
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  selectedDate: startDate ?? DateTime.now(),
                                  onChanged: (DateTime date) {
                                    Navigator.pop(context, date.year);
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            startDate = DateTime(picked);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: '2020',
                          labelText: 'Start Year',
                          maxLines: 1,
                          controller: TextEditingController(
                            text:
                                startDate != null
                                    ? DateFormat('yyyy').format(startDate!)
                                    : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Select End Year"),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: YearPicker(
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  selectedDate: endDate ?? DateTime.now(),
                                  onChanged: (DateTime date) {
                                    Navigator.pop(context, date.year);
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            endDate = DateTime(picked);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: '2024',
                          labelText: 'End Year',
                          maxLines: 1,
                          controller: TextEditingController(
                            text:
                                endDate != null
                                    ? DateFormat('yyyy').format(endDate!)
                                    : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              DropdownTextField<bool>(
                label: 'Work Experience',
                items: [true, false],
                selectedItem: experience,
                onChanged: (value) {
                  setState(() {
                    experience = value;
                  });
                },
                itemToString: (val) => val ? 'Yes' : 'No',
              ),
              SizedBox(height: Dimensions.height20),

              if (experience == true)
                Column(
                  children: [
                    CustomTextField(
                      hintText: 'How many years',
                      keyboardType: TextInputType.number,
                      controller: yearsExperience,
                    ),
                    SizedBox(height: Dimensions.height20),

                    CustomTextField(
                      hintText: 'Company Name',
                      keyboardType: TextInputType.text,
                      controller: companyName,
                    ),
                    SizedBox(height: Dimensions.height20),

                    CustomTextField(
                      hintText: 'Job Title',
                      keyboardType: TextInputType.text,
                      controller: jobTitle,
                    ),
                  ],
                ),
              SizedBox(height: Dimensions.height20),

              SkillsMultiSelect(
                selectedSkills: selectedSkills,
                onChanged: (updatedList) {
                  setState(() {
                    selectedSkills = updatedList;
                  });
                },
              ),

              SizedBox(height: Dimensions.height20),

              CustomTextField(
                hintText: 'Additional Certificate',
                controller: certificateController,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: Dimensions.height20),

              LanguageMultiSelect(
                onChanged: (updatedList) {
                  setState(() {
                    language = updatedList;
                  });
                },
                selectedLanguage: language,
              ),

              SizedBox(height: Dimensions.height30),

              //accept policy
              InkWell(
                onTap: policy,
                child: Row(
                  children: [
                    Icon(
                      acceptTerms
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Expanded(
                      child: Text(
                        'As per our policy a payment of N0 is required to post a request on Fyndr, accept to proceed',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor?.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height30),

              // Submit
              CustomButton(
                isDisabled: !isFormValid,
                text: 'Submit Request',
                onPressed: () {
                  submitRequest();
                },
              ),
              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
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
              if (cvImageFile != null) ...[
                SizedBox(width: 16),
                CircleAvatar(radius: 30, backgroundImage: FileImage(cvImageFile!)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.height20,),
          Row(
            children: [
              SizedBox(width: Dimensions.width20),
              Text('Upload from Gallery or Camera',textAlign: TextAlign.start,style: Theme.of(context).textTheme.titleMedium,),
            ],
          ),
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
          SizedBox(height: Dimensions.height50*3,),

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
      cvImageFile = File(compressed.path);
    });

    print("✅ Compressed Image Path: ${compressed.path}");
    print("📦 Image Size: ${imageSize / 1024} KB");
  }
}
