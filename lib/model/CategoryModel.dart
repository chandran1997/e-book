class CategoryModel {
  int? id;
  String? name;
  String? slug;
  int? parent;
  String? description;
  String? display;
  String? image;
  int? menuOrder;
  int? count;

  CategoryModel(
      {this.id,
        this.name,
        this.slug,
        this.parent,
        this.description,
        this.display,
        this.image,
        this.menuOrder,
        this.count});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    parent = json['parent'];
    description = json['description'];
    display = json['display'];
    image = json['image'];
    menuOrder = json['menu_order'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['parent'] = this.parent;
    data['description'] = this.description;
    data['display'] = this.display;
    data['image'] = this.image;
    data['menu_order'] = this.menuOrder;
    data['count'] = this.count;
    return data;
  }
}

