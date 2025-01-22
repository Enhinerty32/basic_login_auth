

// Define una interfaz que todos los modelos deben implementar
abstract class BaseModel {
  Map<String, dynamic> toMap();
  BaseModel fromMap(Map<String, dynamic> data, String documentId);
}
