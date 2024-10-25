import 'package:clezigov/models/procedures/availability.dart';
import 'package:clezigov/models/procedures/category.dart';
import 'package:clezigov/models/procedures/contact.dart';
import 'package:clezigov/models/procedures/document.dart';
import 'package:clezigov/models/procedures/image.dart';
import 'package:clezigov/models/procedures/tag.dart';

enum ProcedureStatus { active, deprecated }

class Procedure {
  String id;
  String title;
  String description;
  List<ProcedureImage> images;
  List<Tag> tags;
  Category category;
  String estimatedTimeToComplete;
  double price;
  List<Availability> availability;
  List<Document> documents;
  List<Contact> contacts;
  ProcedureStatus status;
  DateTime createdAt;
  DateTime lastUpdatedAt;

  Procedure({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.tags,
    required this.category,
    required this.estimatedTimeToComplete,
    required this.price,
    required this.availability,
    required this.documents,
    required this.contacts,
    required this.status,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images.map((image) => image.toJson()).toList(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'category': category.toJson(),
      'estimatedTimeToComplete': estimatedTimeToComplete,
      'price': price,
      'availability':
          availability.map((available) => available.toJson()).toList(),
      'documents': documents.map((document) => document.toJson()).toList(),
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  // fromJson
  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: (json['images'] as List)
          .map((image) => ProcedureImage.fromJson(image))
          .toList(),
      tags: (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList(),
      category: Category.fromJson(json['category']),
      estimatedTimeToComplete: json['estimatedTimeToComplete'],
      price: json['price'],
      availability: (json['availability'] as List)
          .map((available) => Availability.fromJson(available))
          .toList(),
      documents: (json['documents'] as List)
          .map((document) => Document.fromJson(document))
          .toList(),
      contacts: (json['contacts'] as List)
                .map((contact) => Contact.fromJson(contact)).toList(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
    );
  }

  // toString
  @override
  String toString() {
    return 'Procedure{id: $id, title: $title, description: $description, images: $images, tags: $tags, category: $category, estimatedTimeToComplete: $estimatedTimeToComplete, price: $price, availability: $availability, documents: $documents, status: $status, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt}';
  }
}

// generate one procedure from existing data
final List<Procedure> procedures = [
  Procedure(
    id: "1",
    title: "How to legalize the GCE Advanced Level Certificate",
    description:
        "This is a procedure about nothing that says abything if you read it careful enough. But I know you won't mind.",
    images: procedureImages,
    tags: tags,
    category: categories[0],
    estimatedTimeToComplete: "200",
    price: 100.0,
    availability: availabilities,
    documents: documents,
    contacts: contacts.sublist(0, 2),
    status: ProcedureStatus.active,
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Procedure(
    id: "2",
    title: "Procedure 2",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec purus nec nunc tincidunt tincidunt. Nullam nec purus nec nunc tincidunt tincidunt.",
    images: procedureImages,
    tags: tags,
    category: categories[1],
    estimatedTimeToComplete: "5",
    price: 3500.0,
    availability: availabilities,
    documents: documents,
    contacts: contacts.sublist(1, 2),
    status: ProcedureStatus.active,
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Procedure(
    id: "3",
    title: "Procedure 3",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec purus nec nunc tincidunt tincidunt. Nullam nec purus nec nunc tincidunt tincidunt.",
    images: procedureImages,
    tags: tags,
    category: categories[2],
    estimatedTimeToComplete: "3",
    price: 2000.0,
    availability: availabilities,
    documents: documents,
    contacts: contacts.sublist(0, 1),
    status: ProcedureStatus.deprecated,
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Procedure(
    id: "4",
    title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec purus nec nunc tincidunt tincidunt. Nullam nec purus nec nunc tincidunt tincidunt.",
    images: procedureImages,
    tags: tags,
    category: categories[3],
    estimatedTimeToComplete: "1",
    price: 500.0,
    availability: availabilities,
    documents: documents,
    contacts: contacts,
    status: ProcedureStatus.active,
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
  Procedure(
    id: "5",
    title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec purus nec nunc tincidunt tincidunt. Nullam nec purus nec nunc tincidunt tincidunt.",
    images: procedureImages,
    tags: tags,
    category: categories[4],
    estimatedTimeToComplete: "2",
    price: 1000.0,
    availability: availabilities,
    documents: documents,
    contacts: contacts,
    status: ProcedureStatus.active,
    createdAt: DateTime.now(),
    lastUpdatedAt: DateTime.now(),
  ),
];
