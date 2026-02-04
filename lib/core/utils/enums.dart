enum CacheKeys {
  loggedIn,
  name,
  email,
  id,
  mobile,
  theme,
  lang,
  fcm,
  lat, //خط الطول
  long, //خط العرض
}

enum AppLanguage { ar, en }

enum AppPermission { admin, user }

enum DbTable { brand }

enum AppGender { male, female }
enum FbCollection{
  users,
  categories,
  products,
  rates,
  carts,
  sliders,
  notifications
}
enum User {id,username,token,email,isSeller,loggedIn,whatsApp}
enum Favorite {favoriteId}
enum CartId {cartId}

enum ToggleCartResult {
  added,
  removed,
  alreadyExists,
  error,
}


