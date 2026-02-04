
import 'package:carmarketapp/models/db/brands_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/cars_brand_name.dart';

class BrandNamesProvider extends ChangeNotifier {
  late final  List<BrandModel> _brandsName =
      CarBrands.carBrands.toList(); //read brands of Car brands of Brand model
  List<BrandModel> get brands => _brandsName;
  String _selectedBrandName='';

  BrandModel? get selectedBrandName => _selectedBrand;
  String get brandName => _selectedBrandName;


  BrandModel? _selectedBrand; // البراند المحدد
  BrandModel? get selectedBrand => _selectedBrand;

  int get selectedCarType => _selectedType;
  int _selectedType = -1;
  void setSelectedIndex({required int index}) {
    _selectedType = index;
    print("se $_selectedType");
    notifyListeners();
  }


  void  setBrands(List<BrandModel>? list) async {
      if(list != null ){
      _brandsName.addAll( list );
      }
      notifyListeners();
  }
  void resetSelectedBrandManager(){
    _brandsName[_selectedType].isSelected=false;
    _selectedBrand=null;
    _selectedType=-1;
    _selectedBrandName='';
    notifyListeners();
  }

  void toggleSelectedBrandManager(int index,{ bool? isSelected=true}) {
    setSelectedIndex(index: index);
    for (var brand in _brandsName) {
      brand.isSelected = false; //كل البراندات فووولس
    }

    _brandsName[index].isSelected =isSelected?? true;
    _selectedBrand = _brandsName[index];
    print(_selectedBrand);
    _selectedType=index;
    print(_selectedType);

    _selectedBrandName=_selectedBrand!.brandName;
    print(_selectedBrandName);
    notifyListeners();
  }

  void addBrand(String brandName) {

    for (var brand in _brandsName) {
      brand.isSelected = false;
    }
    final newBrand = BrandModel(brandName: brandName, isSelected: true);
    _brandsName.add(newBrand);
    _selectedBrandName=newBrand.brandName;

    notifyListeners();
  }


}
