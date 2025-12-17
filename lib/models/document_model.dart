class DocumentModel {
  String id;
  String title;
  String author;
  String category;
  int year;
  bool available;

  DocumentModel({
    this.id = "",
    required this.title,
    required this.author,
    required this.category,
    required this.year,
    required this.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,      
      'author': author,
      'category': category,
      'year': year,
      'available': available,
    };
  }

  factory DocumentModel.fromMap(String id, Map<String, dynamic> map) {
    return DocumentModel(
      id: id,
      title: map['title'] ?? '',   
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      year: map['year'] ?? 0,
      available: map['available'] ?? false,
    );
  }
}
