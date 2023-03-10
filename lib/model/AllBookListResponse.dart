import 'DashboardResponse.dart';

class AllBookListResponse {
  int? numOfPages;
  List<DashboardBookInfo>? data;

  AllBookListResponse({this.numOfPages, this.data});

  AllBookListResponse.fromJson(Map<String, dynamic> json) {
    numOfPages = json['num_of_pages'];
    if (json['data'] != null) {
      data = <DashboardBookInfo>[];
      json['data'].forEach((v) {
        data!.add(new DashboardBookInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_of_pages'] = this.numOfPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
