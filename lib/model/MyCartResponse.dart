class MyCartResponse {
  String? cartId;
  int? proId;
  String? name;
  String? sku;
  String? price;
  bool? onSale;
  String? regularPrice;
  String? salePrice;
  var stockQuantity;
  String? stockStatus;
  String? shippingClass;
  int? shippingClassId;
  String? thumbnail;
  String? full;
  List<String>? gallery;
  String? createdAt;
  String? quantity;

  MyCartResponse(
      {this.cartId,
        this.proId,
        this.name,
        this.sku,
        this.price,
        this.onSale,
        this.regularPrice,
        this.salePrice,
        this.stockQuantity,
        this.stockStatus,
        this.shippingClass,
        this.shippingClassId,
        this.thumbnail,
        this.full,
        this.gallery,
        this.createdAt,
        this.quantity});

  MyCartResponse.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    proId = json['pro_id'];
    name = json['name'];
    sku = json['sku'];
    price = json['price'];
    onSale = json['on_sale'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    thumbnail = json['thumbnail'];
    full = json['full'];
    gallery = json['gallery'].cast<String>();
    // if (json['gallery'] != null) {
    //   // gallery = json['gallery'] != null ? new List<String>.from(json['gallery']) : null;
    //   gallery = [];
    //   json['gallery'].forEach((v) {
    //     gallery!.add(v);
    //   });
    // }
    createdAt = json['created_at'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['pro_id'] = this.proId;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['on_sale'] = this.onSale;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['thumbnail'] = this.thumbnail;
    data['full'] = this.full;
    data['gallery'] = this.gallery;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    return data;
  }
}
