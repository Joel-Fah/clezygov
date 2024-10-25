import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Category {
  String id;
  String name;
  DateTime createdAt;
  DateTime lastUpdatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': lastUpdatedAt,
    };
  }

  // fromJson
  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      id: data['id'],
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']),
      lastUpdatedAt: DateTime.parse(data['updated_at']),
    );
  }

  // toString
  @override
  String toString() {
    return 'Category{id: $id, name: $name, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt}';
  }
}


List<Category> categories = [
  Category(
    id: "1",
    name: "Justice",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "2",
    name: "Health",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "3",
    name: "Education",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "4",
    name: "Environment",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "5",
    name: "Economy",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "6",
    name: "International",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "7",
    name: "Sports",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "8",
    name: "Civil",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Category(
    id: "9",
    name: "Science",
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
];

List<Map<Category, IconData>> categoryIcons = [
  {categories[0]: HugeIcons.strokeRoundedJusticeScale01},
  {categories[1]: HugeIcons.strokeRoundedHealth},
  {categories[2]: HugeIcons.strokeRoundedGlobalEducation},
  {categories[3]: HugeIcons.strokeRoundedPlant03},
  {categories[4]: HugeIcons.strokeRoundedCashback},
  {categories[5]: HugeIcons.strokeRoundedGlobal},
  {categories[6]: HugeIcons.strokeRoundedDumbbell02},
  {categories[7]: HugeIcons.strokeRoundedLabor},
  {categories[8]: HugeIcons.strokeRoundedTestTube01},
];




Future<void> insertCategory(Category category, final supabase) async {
  try {
    final response = await supabase
        .from("Category")
        .insert(category.toJson());

    if(response.error != null){
      throw response.error!;
    }
  } catch(e) {
    print("Error inserting category: $e");
    rethrow;
  }
}