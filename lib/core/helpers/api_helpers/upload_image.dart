
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../models/api/cars/car_api_model.dart';
import '../../utils/constants.dart';

class UploadImages{
  Future<CarApiModel> uploadImages({required Map<String, dynamic> carData,List<Uint8List?>? images}) async {
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaXNTZWxsZXIiOnRydWUsImlhdCI6MTczNzg4NzEyM30.5uWo0kl5YpYiLKnrRym7w6cF5jgD_PDChLHQ1hJgsEg';

    var url = Uri.parse(addNewCarUrl);

    var request = http.MultipartRequest('POST', url)
      ..fields
          .addAll(carData.map((key, value) => MapEntry(key, value.toString())))
      ..headers['Authorization'] = 'Bearer $token';

    for (int i = 0; i < images!.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        'images', // Field name in API
        images[i]!,
        filename: 'image_$i.jpg',
      ));
    }

    var response = await request.send();
    String responseBody = await response.stream.bytesToString();
    return CarApiModel.fromJson(jsonDecode(responseBody));
  }

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['images'] = 'YOUR_UPLOAD_PRESET'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'upload.jpg',
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);
      return data['secure_url'];
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  Future<List<String>> uploadAllImages(List<Uint8List> imageList) async {
    List<String> urls = [];

    for (Uint8List image in imageList) {
      final url = await uploadImage(image);
      if (url != null) {
        urls.add(url);
      } else {
        print("فشل رفع صورة");
      }
    }

    return urls;
  }




}
// class UploadImage {
//   Future<int> uploadImage(File file, mailId) async {
//     var request =
//         http.MultipartRequest("POST", Uri.parse('$baseUrl/attachments'));
// //create multipart using filepath, string or bytes .
//     var pic = await http.MultipartFile.fromPath('image', file.path);
//     request.fields['mail_id'] = mailId.toString();
//     request.fields['title'] = 'image_${DateTime.now()}';
// //add multipart to request
//     request.files.add(pic);
//     request.headers.addAll({
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${SharedPrefrencesController().token}'
//     });
//     var response = await request.send();
//
// //Get the response from the server
//     var responseData = await response.stream.toBytes();
//     var responseString = String.fromCharCodes(responseData);
//     print(responseString);
//     return response.statusCode;
//   }
// }
