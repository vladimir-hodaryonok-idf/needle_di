class NeedleException implements Exception {
  final String message;

  const NeedleException({required this.message});

  @override
  String toString() {
    return message;
  }
}

class ItemNotFoundException extends NeedleException {
   ItemNotFoundException(String key)
      : super(message: "Not found $key. Did u forget to register it?");
}
