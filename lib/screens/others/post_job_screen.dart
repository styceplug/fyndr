import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/data/services/employment_data.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/lga_multi-select.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/services/states_lga_local.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/dropdown_textfield.dart';
import '../../widgets/snackbars.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {

  String? selectedType;
  String? selectedVacancy;
  String? selectedLabel;
  DateTime? selectedDate;
  List<String> selectedBenefits = [];
  TextEditingController locationController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RequestController requestController = Get.find<RequestController>();


  bool acceptTerms = false;

  void policy(){
    setState(() {
      acceptTerms = !acceptTerms;
    });
  }

  bool get isFormValid {
    return
        selectedDate != null &&
        selectedLabel != null &&
        selectedType != null &&
        selectedVacancy != null &&
        selectedBenefits.isNotEmpty &&
        locationController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        acceptTerms;

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

          "Selected Type: $selectedType, "
          "Selected Vacancy: $selectedVacancy, "
          "Selected Label: $selectedLabel, "
          "Selected Date: $selectedDate, "
          "Selected Benefits: $selectedBenefits, "
          "Location: ${locationController.text}, "
          "Description: ${descriptionController.text}, "
          "Company: ${companyController.text}, "
          "First Name: ${firstNameController.text}, "
          "Last Name: ${lastNameController.text}, "
          "Phone: ${phoneController.text}, "
          "Email: ${mailController.text}, "
          "Reference: ${referenceController.text}, "
          "Job Title: ${jobTitleController.text}, "
          "Salary: ${salaryController.text}, "
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

              final apiBenefits = selectedBenefits
                  .map((label) => benefitMap[label] ?? label)
                  .toList();


              final body = {
                "company": companyController.text.trim(),
                "firstName": firstNameController.text.trim(),
                "lastName": lastNameController.text.trim(),
                "number": phoneController.text.trim(),
                "email": mailController.text.trim(),
                "howYouHeardAboutUs": referenceController.text.trim(),
                "jobTitle": jobTitleController.text.trim(),
                "jobLocation": locationController.text.trim(),
                "type": selectedType,
                "startDate": selectedDate != null
                    ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                    : null,
                "salary": int.tryParse(salaryController.text.trim()) ?? 0,
                "salaryCurrency": "NGN",
                "benefits": apiBenefits,
                "description": descriptionController.text.trim(),
                "availableVacancy": selectedVacancy?.toString(),
              };

              await requestController.postJobListing(body);
              setState(() {
                selectedDate = null;
                selectedLabel = null;
                selectedType = null;
                selectedVacancy = null;
                selectedBenefits = [];
                companyController.clear();
                firstNameController.clear();
                lastNameController.clear();
                phoneController.clear();
                mailController.clear();
                referenceController.clear();
                jobTitleController.clear();
                salaryController.clear();
                locationController.clear();
                descriptionController.clear();
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
        title: 'Create a Job Posting',
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
                
              //data
              CustomTextField(hintText: 'Company Name',controller: companyController),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'First Name',controller: firstNameController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Last Name',controller: lastNameController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Phone number',controller: phoneController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Email Address',controller: mailController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'How did you hear about us?',maxLines: 5,controller: referenceController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Job Title',controller: jobTitleController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Input Job Location',maxLines: 1,controller: locationController,),
              SizedBox(height: Dimensions.height20,),
              CustomTextField(hintText: 'Salary in naira',controller: salaryController,keyboardType: TextInputType.number,),
              SizedBox(height: Dimensions.height20,),
                
                
              DropdownTextField<String>(
                label: 'Job Type',
                items: jobTypes.keys.toList(),
                selectedItem: selectedLabel,
                onChanged: (value) {
                  setState(() {
                    selectedLabel = value;
                    selectedType = jobTypes[value];
                  });
                },
                itemToString: (val) => val,
              ),
              SizedBox(height: Dimensions.height20,),
                
              JobBenefitsMultiSelect(
                benefits: benefitMap.keys.toList(),
                selectedBenefits: selectedBenefits,
                onChanged: (updatedList) {
                  setState(() {
                    selectedBenefits = updatedList;
                  });
                },
              ),
                
              SizedBox(height: Dimensions.height20),
                
                
                
              //start date
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    hintText: '01/12/2020',
                    labelText: 'Date Needed',
                    maxLines: 1,
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : '',
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.height20),

                
              CustomTextField(hintText: 'Job Description?',maxLines: 5,controller: descriptionController,),
                
              SizedBox(height: Dimensions.height20),
                
              // Vacancy (1-10+)
              DropdownTextField<String>(
                label: 'Vacancy',
                items: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10+',
                ],
                selectedItem: selectedVacancy,
                onChanged: (value) {
                  setState(() {
                    selectedVacancy = value;
                  });
                },
                itemToString: (val) => val,
              ),
                
                

              SizedBox(height: Dimensions.height30),
                
                
              //accept policy
              InkWell(
                onTap: policy,
                child: Row(
                  children: [
                    Icon(acceptTerms? Icons.check_box_outlined : Icons.check_box_outline_blank ),
                    SizedBox(width: Dimensions.width5),
                    Expanded(
                      child: Text(
                        'As per our policy a payment of N250 is required to post a request on Fyndr, accept to proceed',
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
}
