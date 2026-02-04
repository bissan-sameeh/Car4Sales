import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _quantity = 0;

  int get quantity => _quantity;
  final Map<int, int> _quantities = {};
  final Map<int, int> _originalQuantities = {}; // الكمية الأصلية


  int getQuantity(int carId) => _quantities[carId] ?? 0;


  void increase(int maxStock) {
    if (_quantity < maxStock) {
      _quantity++;
      notifyListeners();
    }
  }
  void resetAll() {
    for (var key in _originalQuantities.keys) {
      _quantities[key] = _originalQuantities[key]!;
    }
    notifyListeners();
  }
  bool increaseQuantity(int carId,int maxStock){
    if((_quantities[carId] ?? 0) < maxStock ){
      _quantities[carId] = (_quantities[carId] ?? 0) + 1;
      print( _quantities[carId]);

      notifyListeners();
      return true;
    }
    return false;
  }
  bool decreaseQuantity({required int carId}){
    if( (_quantities[carId] ??0 ) > 1){
      print("looooooooo");
      _quantities[carId] = (_quantities[carId] ??0 ) -1;
      print(_quantities[carId]);

      notifyListeners();
      return true;
    }
    return false;
  }
  setQuantityWithCarId({required int carId, required int value,bool updateOriginal = false}){
    print("update now setttttttttttttt" );
    _quantities[carId]= value;
    if (updateOriginal) {
      _originalQuantities[carId] = value;
    }
    print( _originalQuantities[carId] );
    notifyListeners();
  }

  void decrease() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }
  void resetQuantity(int carId) {
    _quantities.remove(carId);
    _originalQuantities.remove(carId);
    notifyListeners();
  }


  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }
}
