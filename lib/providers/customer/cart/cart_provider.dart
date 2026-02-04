import 'package:carmarketapp/Cache/cart_storage.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/cart/cart_model.dart';
import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:carmarketapp/reprositories/customer/cart_repository/cart_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/excpations.dart';
import '../../../core/errors/failure.dart';

class CartProvider extends ChangeNotifier {
  // ================= Dependencies =================
  final CartRepository _cartRepository = CartRepository();
  final CartStorage cartStorage = CartStorage();
  final QuantityProvider _quantityProvider;

  CartProvider(this._quantityProvider);

  // ================= States =================
  ApiResponse<Cart> _addCartItem = ApiResponse.initial("initial");
  ApiResponse<void> _deleteCartItem = ApiResponse.initial("initial");
  ApiResponse<void> _toggleCart = ApiResponse.initial("initial");
  ApiResponse<List<Cart>?> _allCartItems = ApiResponse.initial("initial");

  final Map<String, bool> _loadingCart = {};
  Set<String> _carIdS = {};

  bool isCartsScreen = false;

  // ================= Getters =================
  ApiResponse<Cart> get addCartItem => _addCartItem;
  ApiResponse<void> get deleteCartItem => _deleteCartItem;
  ApiResponse<void> get toggleCartResponse => _toggleCart;
  ApiResponse<List<Cart>?> get allCartItems => _allCartItems;

  bool isLoadingCart(String id) => _loadingCart[id] ?? false;
  bool isCart(String id) => _carIdS.contains(id);
  bool get isOnCartScreen => isCartsScreen;

  // ================= Screen Flag =================
  void isCartScreen(bool value) {
    isCartsScreen = value;
    notifyListeners();
  }

  // ================= Fetch =================
  Future<void> fetchAllCart() async {
    _allCartItems = ApiResponse.loading("loading cart");
    notifyListeners();

    try {
      final carts = await _cartRepository.getCartItems();
      _allCartItems = ApiResponse.completed(carts);

      syncLocalWithServer();
      _syncQuantities(carts ?? []);

    } catch (e) {
      if (e is Failure) {
        _allCartItems = ApiResponse.error(mapFailureToMessage(e));
      }
    }

    notifyListeners();
  }

  // ================= Add =================
  Future<void> addToCart({
    required int carId,
    required int quantity,
  }) async {
    _addCartItem = ApiResponse.loading("add cart item");
    notifyListeners();

    try {
      final response = await _cartRepository.addCartItem(
        carId: carId,
        quantity: quantity,
      );

      _addCartItem = ApiResponse.completed(response);
      addToCartLocal(carId.toString());

      _quantityProvider.setQuantityWithCarId(
        carId: carId,
        value: quantity,
      );

    } catch (e) {
      if (e is Failure) {
        _addCartItem = ApiResponse.error(mapFailureToMessage(e));
      }
    }

    notifyListeners();
  }

  // ================= Toggle =================
  Future<bool> toggleCart({
    required int carId,
    int quantity = 1,
  }) async {
    final idStr = carId.toString();
    final wasInCart = isCart(idStr);

    // optimistic UI
    wasInCart ? removeFromCartLocal(idStr) : addToCartLocal(idStr);

    _loadingCart[idStr] = true;
    notifyListeners();

    try {
      if (wasInCart) {
        await deleteCartItemBasedId(idStr);
      } else {
        await _cartRepository.addCartItem(
          carId: carId,
          quantity: quantity,
        );
      }

      _toggleCart = ApiResponse.completed(null);
      return !wasInCart;

    } catch (e) {
      // rollback
      wasInCart ? addToCartLocal(idStr) : removeFromCartLocal(idStr);

      if (e is Failure) {
        _toggleCart = ApiResponse.error(mapFailureToMessage(e));
      }
      rethrow;

    } finally {
      _loadingCart[idStr] = false;
      notifyListeners();
    }
  }

  // ================= Delete by carId =================
  // ================= Delete (direct from UI) =================
  Future<void> deleteCart({required int carId}) async {
    _deleteCartItem = ApiResponse.loading("delete cart");
    notifyListeners();

    try {
      // نجيب cartId الحقيقي من allCartItems
      final carts = _allCartItems.data ?? [];

      final cart = carts.firstWhere(
            (e) => e.id == carId,
        orElse: () => throw ServerFailure("cart not found"),
      );

      await _cartRepository.deleteCart(
        carId: cart.id.toString(),
      );

      // تحديث local + state
      removeFromCartLocal(cart.carId.toString());

      // تحديث القائمة بدون refetch
      _allCartItems = ApiResponse.completed(
        carts.where((e) => e.id != cart.id).toList(),
      );

      _deleteCartItem = ApiResponse.completed(null);

    } catch (e) {
      if (e is Failure) {
        _deleteCartItem = ApiResponse.error(mapFailureToMessage(e));
      }
    }

    notifyListeners();
  }

  Future<void> deleteCartItemBasedId(String carId) async {
    final carts = _allCartItems.data ?? [];

    final cart = carts.firstWhere(
          (e) => e.carId.toString() == carId,
      orElse: () => throw ServerFailure("cart not found"),
    );

    await _cartRepository.deleteCart(carId: cart.id.toString());
    removeFromCartLocal(carId);
  }

  // ================= Update =================
  Future<void> updateCart({
    required int carId,
    required int quantity,
  }) async {
    _addCartItem = ApiResponse.loading("update cart");
    notifyListeners();

    try {
      final carts = _allCartItems.data ?? [];

      final cart = carts.firstWhere(
            (e) => e.carId == carId,
        orElse: () => throw ServerFailure("cart not found"),
      );

      final response = await _cartRepository.updateCart(
        quantity: quantity,
        carId: cart.id.toString(),
      );

      _addCartItem = ApiResponse.completed(response);

      _quantityProvider.setQuantityWithCarId(
        carId: carId,
        value: quantity,
      );

    } catch (e) {
      if (e is Failure) {
        _addCartItem = ApiResponse.error(mapFailureToMessage(e));
      }
    }

    notifyListeners();
  }

  // ================= Local =================
  void addToCartLocal(String id) {
    _carIdS.add(id);
    cartStorage.saveCarIdToStorage(_carIdS);
  }

  void removeFromCartLocal(String id) {
    _carIdS.remove(id);
    cartStorage.saveCarIdToStorage(_carIdS);
  }
// ================= Sync after login =================
  void syncLocalWithServer() {
    final carts = _allCartItems.data ?? [];

    _carIdS = carts.map((e) => e.carId.toString()).toSet();
    cartStorage.saveCarIdToStorage(_carIdS);

    notifyListeners();
  }


  void _syncQuantities(List<Cart> carts) {
    for (final item in carts) {
      _quantityProvider.setQuantityWithCarId(
        carId: item.carId,
        value: item.quantity,
      );
    }
  }

  // ================= Storage =================
  Future<void> loadCartsFromStorage() async {
    _carIdS = (await cartStorage.getAllCartCarIds() ?? []).toSet();
    notifyListeners();
  }

  // ================= Clear =================
  void clear() {
    _addCartItem = ApiResponse.initial("initial");
    _deleteCartItem = ApiResponse.initial("initial");
    _toggleCart = ApiResponse.initial("initial");
    _allCartItems = ApiResponse.initial("initial");

    _carIdS.clear();
    _loadingCart.clear();
    isCartsScreen = false;

    cartStorage.clear();
    notifyListeners();
  }
}
