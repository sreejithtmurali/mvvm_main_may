
import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    await checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (ConnectivityResult result) {
        _updateConnectionStatus(result);
      },
    );
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected;
    } catch (e) {
      log('Error checking connectivity: $e');
      return false;
    }
  }

  /// Update connection status and notify listeners
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;

    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        _isConnected = true;
        break;
      case ConnectivityResult.none:
        _isConnected = false;
        break;
      default:
        _isConnected = false;
        break;
    }

    log('Connectivity changed: $result - Connected: $_isConnected');

    // Notify only if status changed
    if (wasConnected != _isConnected) {
      _connectionController.add(_isConnected);
    }
  }

  /// Get connectivity type as string
  Future<String> getConnectivityType() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }
}