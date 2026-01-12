abstract class AppGenericException implements Exception {
  final String message;
  final String technicalMessage;
  final String? code;

  AppGenericException({this.message = 'Generic Exception', required this.technicalMessage, this.code});
}

class DataBaseLocalException extends AppGenericException {
  DataBaseLocalException({super.message = 'Local Storage Exception', required super.technicalMessage, super.code});
}