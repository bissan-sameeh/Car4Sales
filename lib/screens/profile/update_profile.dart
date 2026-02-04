import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/auth/auth_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Cache/auth_storage.dart';
import '../../core/helpers/api_helpers/api_response.dart';
import '../../providers/profile/profile_provider.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_phone_widget.dart';
import '../Widgets/my_text_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> with ShowSnackBar {
  late TextEditingController nameController;
  late TextEditingController whatsappController;
  String fullWhatsapp = '';


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    whatsappController = TextEditingController();

    /// Prefill user data

    final auth = AuthStorage();

    final userName = auth.getName;
    final whatsapp = auth.getWhatsAppNumber;
    if (userName != null && whatsapp !=null) {
      nameController.text = userName ?? '';
      whatsappController.text = whatsapp ?? '';
    }
  }


  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(text: 'Update Profile'),

                SizedBox(height: 24.h),

                Image.asset(
                  'assets/images/edit.png',
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 32.h),

                /// Name
                _label('Name'),
                MyTextField(
                  hint: 'Enter your name',
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  isOutlinedBorder: true,
                ),

                SizedBox(height: 18.h),

                /// WhatsApp
                _label('WhatsApp Number'),

                PhoneInputSeparated(
                  phoneController: whatsappController,
                  // initialCountryCode: 'PS', // أو من AuthStorage
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "WhatsApp number is required";
                    }
                    return null;
                  }, onChangedFullPhone: (value) {
                  fullWhatsapp = value;
                },

                ),

                SizedBox(height: 32.h),

                /// Update button
                CustomButton(
                  title: "Update",
                  loading: provider.isLoading,
                  onTap: () async {

                    await provider.updateUserProfile(
                      name: nameController.text.trim(),
                      whatsapp: fullWhatsapp.trim(),
                    );
                    final response = provider.updateProfile;

                    if (!context.mounted) return;

                    if (response.status == ApiStatus.ERROR) {
                      showSnackBar(
                        context,
                        message: response.message.toString(),
                        error: true,
                      );
                    } else if (response.status == ApiStatus.COMPLETED) {
                   Provider.of<AuthProvider>(context,listen: false).updateUsername(nameController.text);
                      showSnackBar(
                        context,
                        message: "Profile updated successfully",
                      );
                      NavigationRoutes()
                          .jump(context, Routes.customerMainScreen);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Label widget
  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}
