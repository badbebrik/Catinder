import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityCubit({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityStatus.offline) {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChange);
  }

  void _onChange(List<ConnectivityResult> results) async {
    final hasInterface = results.any(
      (r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile,
    );

    if (!hasInterface) {
      if (state != ConnectivityStatus.offline) {
        log('[ConnectivityCubit] onChange: $results → offline');
        emit(ConnectivityStatus.offline);
      }
      return;
    }

    final hasInet = await _checkTcpInternet();
    final newStatus =
        hasInet ? ConnectivityStatus.online : ConnectivityStatus.offline;

    if (state != newStatus) {
      log('[ConnectivityCubit] onChange: $results + TCP → $newStatus');
      emit(newStatus);
    }
  }

  Future<bool> _checkTcpInternet() async {
    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 2),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
