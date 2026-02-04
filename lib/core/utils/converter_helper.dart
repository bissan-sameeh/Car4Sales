
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
mixin ConverterHelper {
  // Future<String?> convertFileToString(File? file) async {
  //   if (file == null) return null;
  //   Uint8List uint8list = await file.readAsBytes(); // نظام تشفير بيز 64
  //   return base64Encode(uint8list);
  // }

  // List<Uint8List> convertBase64ListToUint8List({required List<String> base64String}){
  //
  //  return base64String.map((e) {
  //     return base64Decode(e);
  //   },).toList();
  //
  // }

  int getMonthIndex(String monthName) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    print(months.indexOf(monthName) + 1);
    return months.indexOf(monthName) + 1;
  }


  int convertStringToColorIndex(String? colorString){
    final regex = RegExp(r'Color\(0x([0-9a-fA-F]+)\)');
    final match = regex.firstMatch(colorString!);

    String? hex = match?.group(1)!;
    int colorValueFromApi = int.parse("0x$hex");
    return colorValueFromApi; //convert string to int
  }

  Future<Uint8List?>? downloadImageAsBytesConverter(String url, {bool isCoverImage = false}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
      // setState(() {
      //   if (isCoverImage) {
      //     pickCoverImage = response.bodyBytes;
      //   } else {
      //     pickedImages.add(response.bodyBytes);
      //   }
      // });
    }
    return null;
  }


  Future<void> openWhatsApp({
    required String phone,
    String message = "مرحبًا، مهتم بهذه السيارة",
  }) async {
    final url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch WhatsApp';
    }
  }


  // Future<File> convertLinkToFile(String link) async {
  //   print("zzzzzzzzzzzz");
  //
  //   ///1
  //   var url = Uri.parse(link);
  //
  //   ///String => Uri
  //   var response = await http.get(url);
  //
  //   ///2 create new path ..
  //   var directory = await getApplicationDocumentsDirectory();
  //   File file = File(join(directory.path, '${DateTime.now()}.png'));
  //
  //   ///3 write the response as byte on file
  //   await file.writeAsBytes(response.bodyBytes);
  //   print("zzzzzzzzzzzz");
  //
  //   ///4
  //   return file;
  // }
  //
  // String? convertDateTimeToString(DateTime date,
  //     {String format = 'yyyy/MM//dd',bool showMonth=false }) {
  //   if (date == null) return null;
  //   if(!showMonth){
  //   DateFormat dateFormat = DateFormat(format);
  //
  //   return dateFormat.format(date);
  // }else{
  //     String month=Jiffy.parseFromDateTime(date).format(pattern: 'MMMM');
  //   return '$month ${date.day}, ${date.year}';
  //   }
  //
  // }

  DateTime? convertStringToDateTime(String? time,
      {String format = 'yyyy/MM//dd'}) {
    if (time == null) return null;
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(time);
  }

  String formatMonth(String dateString) {
    DateTime date = DateFormat("yyyy-MM")
        .parse(dateString); //convert string date to dateTime(year,month)
    return DateFormat("MMM")
        .format(date); // "Jan", "Feb"... => format the dateTime to shorten
  }
}
