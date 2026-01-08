abstract class AppGenericException implements Exception {
  final String message;
  final String technicalMessage;
  final String? code;

  AppGenericException({this.message = 'Generic Exception', required this.technicalMessage, this.code});
}

class LocalStorageException extends AppGenericException {
  LocalStorageException({super.message = 'Local Storage Exception', required super.technicalMessage, super.code});
}