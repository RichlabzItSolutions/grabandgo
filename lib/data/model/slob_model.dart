import 'dart:convert';

class Slob {
  final int? id;
  final String? fromTotal;
  final String? toTotal;
  final String? deliveryCharges;

  Slob({
    this.id,
    this.fromTotal,
    this.toTotal,
    this.deliveryCharges,
  });

  // Factory constructor to create a Slob instance from a JSON object
  factory Slob.fromJson(Map<String, dynamic> json) {
    return Slob(
      id: json['id'] as int?,
      fromTotal: json['fromTotal'] as String?,
      toTotal: json['toTotal'] as String?,
      deliveryCharges: json['deliveryCharges'] as String?,
    );
  }

  // Convert Slob object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromTotal': fromTotal,
      'toTotal': toTotal,
      'deliveryCharges': deliveryCharges,
    };
  }
}

// To handle a list of "slobs"
class SlobList {
  final List<Slob>? slobs;

  SlobList({this.slobs});

  factory SlobList.fromJson(Map<String, dynamic> json) {
    var list = json['slobs'] as List?;
    List<Slob>? slobList = list?.map((i) => Slob.fromJson(i)).toList();

    return SlobList(slobs: slobList);
  }

  Map<String, dynamic> toJson() {
    return {
      'slobs': slobs?.map((slob) => slob.toJson()).toList(),
    };
  }
}
