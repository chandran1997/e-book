class LineItemModel{
  String? productId;
  String? quantity;

  LineItemModel({this.productId, this.quantity});
}
class LineItemsRequest {
  int? product_id;
  String? quantity;

  LineItemsRequest({this.product_id, this.quantity});

  factory LineItemsRequest.fromJson(Map<String, dynamic> json) {
    return LineItemsRequest(product_id: json['product_id'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['quantity'] = this.quantity;
    return data;
  }
}