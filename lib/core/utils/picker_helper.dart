import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'constants.dart';

mixin PickerHelper {
  void showAdaptiveCountryPicker({
    required BuildContext context,
    required Function(Country) onSelect,
  }) {
    showCountryPicker(
      context: context,
      useSafeArea: true,
      showPhoneCode: true,
      favorite: const ['PS', 'SA', 'EG', 'JO'],
      onSelect: onSelect,

      /// 🎨 Theme
      countryListTheme: CountryListThemeData(
        backgroundColor: kBlackColor,

        textStyle: const TextStyle(
          color: Colors.white,
        ),

        searchTextStyle: const TextStyle(
          color: Colors.white,
        ),

        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white24,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
        ),

        /// 👇 لو بدك شكل أنعم
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }
}

// final ImagePicker _picker = ImagePicker();
  //
  // Future<File?> pickImage({ImageSource image = ImageSource.gallery}) async {
  //   XFile? file = await _picker.pickImage(source: image);
  //   return file == null ? null : File(file.path);
  // }
  //
  // Future<List<File>> pickImages() async {
  //   List<XFile>? files = await _picker.pickMultiImage();
  //   return files.map((xFile) => File(xFile.path)).toList();
  // }

  // countryPicker(BuildContext context){
  //   return      showCountryPicker(
  //       context: context,
  //       countryListTheme: CountryListThemeData(
  //         flagSize: 25,
  //         backgroundColor: Theme.of(context).hintColor,
  //         textStyle: const TextStyle(fontSize: 16, color: kWhite),
  //
  //         bottomSheetHeight: MediaQuery.of(context).size.height / 2,
  //         // Optional. Country list modal height
  //         //Optional. Sets the border radius for the bottomsheet.
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(20.0),
  //           topRight: Radius.circular(20.0),
  //         ),
  //
  //         //Optional. Styles the search field.
  //         inputDecoration: InputDecoration(
  //             labelText: 'Search',
  //             hintText: 'Start typing to search',
  //             prefixIcon: Icon(
  //               Icons.search,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             focusColor: Theme.of(context).primaryColor,
  //             labelStyle:
  //             TextStyle(color: Theme.of(context).primaryColor),
  //             focusedBorder: buildOutLinedInputBorder(
  //                 color: Theme.of(context).primaryColor),
  //             border: buildOutLinedInputBorder(
  //                 color: kGrayColor.withOpacity(0.2))),
  //       ),
  //       onSelect: (Country country) => setState(() {
  //         selectedCountry = country.name;
  //         // print('Select country: ${country.displayName}');
  //       }));
  // }



  // Future<List<Uint8List>> pickImagesBytes() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: true,
  //   );
  //     print("result ${result?.files.map((file) => file.bytes).whereType<Uint8List>().toList()}");
  //   if(result !=null ){
  //        return result.files .map((file) => file.bytes)
  //            .whereType<Uint8List>()
  //            .toList();
  //
  //   }
  //   return [];
  // }
  Future<Uint8List?> pickImageBytes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, // السماح بصورة واحدة فقط
      withData: true, // تحميل البيانات مباشرة
    );

    if (result != null && result.files.isNotEmpty) {
      Uint8List? bytes = result.files.first.bytes; // قراءة مباشرة من `bytes`

      if (bytes == null && result.files.first.path != null) {
        bytes = await File(result.files.first.path!).readAsBytes(); // قراءة من `path`
      }

      print("Picked image size: ${bytes?.lengthInBytes} bytes");
      return bytes;
    }

    return null; // في حالة عدم اختيار صورة
  }

  Future<List<Uint8List>> pickImagesBytes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true, // تأكد من تحميل البيانات
    );

    if (result != null) {
      List<Uint8List> imageBytesList = [];

      for (var file in result.files) {
        Uint8List? bytes = file.bytes; // قراءة مباشرة من `bytes`
        if (bytes == null && file.path != null) {
          bytes = await File(file.path!).readAsBytes(); // قراءة من `path`
        }
        if (bytes != null) {
          imageBytesList.add(bytes);
        }
      }

      print("Picked images count: ${imageBytesList.length}");
      return imageBytesList;
    }

    return [];
  }
  // Future<Uint8List?> pickImageBytes({bool isMultiple=false}) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //   List<Uint8List?> imagesBytes;
  //   if(result !=null ){
  //        imagesBytes = result.files.map((file) => file.bytes).toList();
  //        return result.files.first.bytes;
  //
  //   }
  //   return null;
  // }

  Future<DateTime?> pickDate(BuildContext context,
      {DateTime? initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) {
    var date = showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);
    return date;
  }

