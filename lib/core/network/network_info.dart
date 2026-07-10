class NetworkInfo {
  const NetworkInfo();

  Future<bool> get isConnected async {
    return true;
  }

  Stream<bool> get onConnectivityChanged async* {
    yield true;
  }
}