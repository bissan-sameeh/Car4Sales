import 'package:carmarketapp/core/utils/constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../core/utils/image_helper.dart';
import '../../core/utils/picker_helper.dart';

import 'my_text_field.dart';
class PhoneInputSeparated extends StatefulWidget {
  const PhoneInputSeparated({
    super.key,
    required this.phoneController,
    this.validator,
    this.showError = false,
    this.fillColor, required this.onChangedFullPhone,
  });

  final String? Function(String?)? validator;
  final bool showError;
  final Color? fillColor;
  final ValueChanged<String> onChangedFullPhone;

  final TextEditingController phoneController;

  @override
  State<PhoneInputSeparated> createState() => _PhoneInputSeparatedState();
}

class _PhoneInputSeparatedState extends State<PhoneInputSeparated> with ImageHelper ,PickerHelper{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Country selectedCountry = Country.parse('PS');
  bool? isValidNumber;
  @override
  void initState() {
    super.initState();
    _prefillFromFullNumber();
  }
  void _prefillFromFullNumber() {
    final full = widget.phoneController.text.trim();
    if (full.isEmpty) return;

    try {
      final parsed = PhoneNumber.parse(full);

      setState(() {
        selectedCountry = Country.parse(parsed.isoCode.name);
        widget.phoneController.text = parsed.nsn; // الرقم فقط
        isValidNumber = parsed.isValid();
      });

      _emitFullPhone(); // optional
    } catch (_) {
      setState(() => isValidNumber = false);
    }
  }


  void _emitFullPhone() {
    if (isValidNumber != true) return;

    final fullPhone =
        '+${selectedCountry.phoneCode}${widget.phoneController.text.trim()}';
    widget.onChangedFullPhone(fullPhone);
  }





  Widget _buildFlag() {
    final countryCode = selectedCountry.countryCode.toUpperCase();


      // Fallback في حالة عدم وجود العلم
      return Container(
        width: 30,
        height: 20,
        decoration: BoxDecoration(
          color: kBlackColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Center(
          child: Text(
            countryCode,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      );

  }


  void _onPhoneChanged(String number) {
    final trimmed = number.trim();
    if (trimmed.isEmpty) {
      setState(() => isValidNumber = null);
      return;
    }

    try {
      final isoCode = IsoCode.values.firstWhere(
            (code) => code.name == selectedCountry.countryCode,
        orElse: () => IsoCode.PS,
      );

      final phone = PhoneNumber.parse(trimmed, callerCountry: isoCode);
      setState(() => isValidNumber = phone.isValid());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    } catch (_) {
      setState(() => isValidNumber = false);
    }
  }

  bool validatePhoneInput() {
    final text = widget.phoneController.text.trim();
    if (text.isEmpty) {
      setState(() => isValidNumber = null);
      return false;
    }
    return isValidNumber == true;
  }



  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showAdaptiveCountryPicker(

                      context: context,
                      onSelect: (country) {
                        setState(() => selectedCountry = country);
                        _onPhoneChanged(widget.phoneController.text);
                        _emitFullPhone();
                      },
                    );
                  },
                  child: Container(

                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    margin: EdgeInsets.zero,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kLightBlackColor,
                      border: Border.all(color: Color(0xfff1f1f1).withOpacity(0.3),),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           _buildFlag(),
                            const SizedBox(width: 8),
                            Text(
                              '+${selectedCountry.phoneCode}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        appSvgImage(
                          path: 'arrowdown2',
                          height: 14,
                          width: 14,
                          color: kWhite,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: FormField<String>(
                    validator: widget.validator,
                    builder: (fieldState) {
                      return MyTextField(
                        controller: widget.phoneController,
                        hint: 'Mobile Number',

                        isOutlinedBorder: true,
                        onChanged: (value) {
                          _onPhoneChanged(value);
                          _emitFullPhone();
                          fieldState.didChange(value);
                        },
                        textInputType: TextInputType.phone,
                        startContentPadding: 4,
                        // isValid: isValidNumber == null ? null : isValidNumber ==
                        //     true,
                      );
                    },
                  ),
                ),
              ],
            ),

            // Validation message
            if (widget.showError && widget.phoneController.text
                .trim()
                .isEmpty)
              Text("Phone is Required!",
                style: TextStyle(fontSize: 12,color: Colors.red),

              )
            else
              if (isValidNumber == false)
                Text("Invalid Number According To Country",
                  style: TextStyle(fontSize: 12,color: Colors.red),
                    ),
          ],
        );
      },
    );
  }
}