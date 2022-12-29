class DefaultSettingModel {
  String? name;
  String? image;

  DefaultSettingModel({this.name, this.image});

  static List<DefaultSettingModel> get getDefaultAnimation {
    List<DefaultSettingModel> list = [];

    list.add(DefaultSettingModel(name: "Slide Animation"));

    list.add(DefaultSettingModel(name: "Scale Animation"));

    list.add(DefaultSettingModel(name: "Flip Animation"));

    return list;
  }
}
