import 'package:flutter/material.dart';
import 'package:fyndr/data/services/beauty_data.dart';
import 'package:fyndr/data/services/car_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/request_controller.dart';
import '../../data/services/employment_data.dart';
import '../../data/services/states_lga_local.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/dropdown_textfield.dart';

class EmploymentForm extends StatefulWidget {
  const EmploymentForm({super.key});

  @override
  State<EmploymentForm> createState() => _EmploymentFormState();
}

class _EmploymentFormState extends State<EmploymentForm> {
  // Role toggle
  bool? isEmployer; // null until user picks a role

  // Common Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedState;
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool acceptTerms = false;

  // Employer Controllers
  final companyNameController = TextEditingController();
  final hearAboutUsController = TextEditingController();
  final jobTitleController = TextEditingController();
  final jobLocationController = TextEditingController();
  final minSalaryController = TextEditingController();
  final vacancyController = TextEditingController();

  String? selectedJobType;

  // Job Seeker Controllers
  String? selectedLga;
  String? isGraduate;
  String? selectedEducationLevel;
  final fieldOfStudyController = TextEditingController();
  final schoolNameController = TextEditingController();
  String? startYear;
  String? endYear;
  final workExperienceYears = TextEditingController();
  final workCompany = TextEditingController();
  final workJobTitle = TextEditingController();
  final workDuration = TextEditingController();
  final skillsController = TextEditingController();
  final licenseController = TextEditingController();
  final languageController = TextEditingController();

  bool get isFormValid =>
      firstNameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          selectedState != null &&
          selectedService != null &&
          selectedDate != null &&
          selectedTime != null &&
          locationController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          isEmployer != null &&
          acceptTerms;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: CustomAppbar(
        customTitle: Text('Post an Employment Request'),
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Job Seeking and Employee Hunting',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            // ✅ COMMON FIELDS FIRST
            buildField('First Name', firstNameController),
            buildField('Last Name', lastNameController),
            buildField('Email', emailController),
            buildField('Phone Number', phoneController),
            buildDropdown('Your State', stateLgaMap.keys.toList(), selectedState,
                    (val) => setState(() => selectedState = val)),
            buildField('Location', locationController),
            buildDropdown('Service Required', beautyServices, selectedService,
                    (val) => setState(() => selectedService = val)),
            buildDateTimePicker(),
            SizedBox(height: Dimensions.height20),
            buildField('Additional Details', descriptionController, maxLines: 5),

            // 🔘 Role Switcher After Common Fields
            SizedBox(height: Dimensions.height20),
            Text("Are you posting as:", style: Theme.of(context).textTheme.titleMedium),
            Row(
              
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Employer'),
                    selected: isEmployer == true,
                    onSelected: (_) => setState(() => isEmployer = true),
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Job Seeker'),
                    selected: isEmployer == false,
                    onSelected: (_) => setState(() => isEmployer = false),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // Show form fields based on role
            if (isEmployer == true) ...buildEmployerFields(),
            if (isEmployer == false) ...buildJobSeekerFields(),

            // ✅ Terms Checkbox
            SizedBox(height: Dimensions.height20),
            InkWell(
              onTap: () => setState(() => acceptTerms = !acceptTerms),
              child: Row(
                children: [
                  Icon(acceptTerms ? Icons.check_box : Icons.check_box_outline_blank),
                  SizedBox(width: Dimensions.width5),
                  Expanded(
                    child: Text(
                      'Accept N499 fee policy to proceed with request.',
                      style: TextStyle(fontSize: 12, color: textColor?.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30),

            // 🔘 Submit
            CustomButton(
              isDisabled: !isFormValid,
              text: 'Submit Request',
              onPressed: () {
                // handle submission here
              },
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }

  // Reusable Widget Builders
  Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(controller: controller, hintText: label, maxLines: maxLines,labelText: label,),
        SizedBox(height: Dimensions.height15),
      ],
    );
  }

  Widget buildDropdown(String label, List<String> items, String? selected, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownTextField<String>(
          label: label,
          items: items,
          selectedItem: selected,
          onChanged: onChanged,
          itemToString: (item) => item,
        ),
        SizedBox(height: Dimensions.height15),
      ],
    );
  }

  Widget buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
            child: AbsorbPointer(
              child: CustomTextField(
                hintText: 'DD/MM/YYYY',
                labelText: 'Date Needed',
                controller: TextEditingController(
                  text: selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : '',
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) setState(() => selectedTime = picked);
            },
            child: AbsorbPointer(
              child: CustomTextField(
                hintText: 'HH:MM',
                labelText: 'Time Needed',
                controller: TextEditingController(
                  text: selectedTime != null ? selectedTime!.format(context) : '',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Employer Fields
  List<Widget> buildEmployerFields() => [
    buildField('Company Name', companyNameController),
    buildField('How did you hear about us?', hearAboutUsController),
    buildField('Job Title', jobTitleController),
    buildField('Job Location', jobLocationController),
    buildDropdown('Job Type', jobTypes, selectedJobType,
            (val) => setState(() => selectedJobType = val)),
    buildField('Min. Salary', minSalaryController),
    buildField('Job Description', descriptionController, maxLines: 4),
    buildField('Vacancies (1–10+)', vacancyController),
  ];

  // Job Seeker Fields
  List<Widget> buildJobSeekerFields() => [
    buildDropdown('LGA', stateLgaMap[selectedState] ?? [], selectedLga,
            (val) => setState(() => selectedLga = val)),
    buildDropdown('Graduate?', ['Yes', 'No'], isGraduate,
            (val) => setState(() => isGraduate = val)),
    buildDropdown('Education Level',
        ['None', 'Primary', 'Secondary', 'University'],
        selectedEducationLevel,
            (val) => setState(() => selectedEducationLevel = val)),
    buildField('Field of Study', fieldOfStudyController),
    buildField('School Name', schoolNameController),
    buildDropdown('Start Year', carYears, startYear,
            (val) => setState(() => startYear = val)),
    buildDropdown('End Year', carYears, endYear,
            (val) => setState(() => endYear = val)),
    buildField('Work Experience (Years)', workExperienceYears),
    buildField('Company', workCompany),
    buildField('Job Title', workJobTitle),
    buildField('Duration', workDuration),
    buildField('Additional Skills', skillsController),
    buildField('Licenses/Certifications', licenseController),
    buildField('Languages', languageController),
  ];
}