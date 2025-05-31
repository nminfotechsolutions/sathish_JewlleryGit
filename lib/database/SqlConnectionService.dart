import 'package:agni_chit_saving/routes/app_export.dart';

class SqlConnectionService {
  final MssqlConnection _sqlConnection = MssqlConnection.getInstance();
  bool _isConnected = false;

  Future<bool> connect({
    String ip = '97.74.93.130',
    String port = '1433',
    String databaseName = 'AgniSoft',
    String username = 'sa',
    String password = 'Agniapp@916',
  }) async {
    try {
      // Check if already connected
      if (_isConnected) {
        Fluttertoast.showToast(
          msg: "Already connected to database",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
        return true;
      }

      // Attempt connection
      _isConnected = await _sqlConnection.connect(
        ip: ip,
        port: port,
        databaseName: databaseName,
        username: username,
        password: password,
      );

      // Show a toast indicating connection status
/*      Fluttertoast.showToast(
        msg: _isConnected ? "Connected to database successfully" : "Failed to connect to database",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: _isConnected ? Colors.green : Colors.red,
        textColor: Colors.white,
      );*/

      return _isConnected;
    } catch (e) {
      // Handle connection error
      commonUtils.log.i('Error connecting to SQL: $e');
      return false;
    }
  }

  // Future<List<dynamic>?> fetchData(String query) async {
  //   try {
  //     if (!_isConnected) {
  //       bool connected = await connect();
  //       if (!connected) {
  //         throw Exception('Failed to connect to the database');
  //       }
  //     }
  //
  //     commonUtils.log.i('Executing query: $query');
  //     final result = await _sqlConnection.getData(query);
  //     commonUtils.log.i('Raw result: $result');
  //     return jsonDecode(result);
  //   } catch (e) {
  //     // Handle fetch data error
  //     commonUtils.log.i('Error fetching data from SQL: $e');
  //     return null;
  //   } finally {
  //     closeConnection();
  //   }
  // }

  Future<List<dynamic>?> fetchData(String query) async {
    try {
      if (!_isConnected) {
        commonUtils.log.i('Attempting to connect...');
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to connect to the database');
        }
      }

      commonUtils.log.i('Executing query: $query');
      final result = await _sqlConnection.getData(query);
      commonUtils.log.i('Raw result: $result');

      return jsonDecode(result);
    } catch (e, stacktrace) {
      commonUtils.log.e('Error fetching data from SQL: $e\n$stacktrace');
      return null;
    } finally {
      try {
        commonUtils.log.i('Closing connection...');
        closeConnection();
      } catch (e) {
        commonUtils.log.e('Error closing connection: $e');
      }
    }
  }

  Future<String?> writeData(String query) async {
    try {
      if (!_isConnected) {
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to connect to the database');
        }
      }

      final result = await _sqlConnection.writeData(query);
      return result.toString();
    } catch (e) {
      // Handle write data error
      commonUtils.log.i('Error writing data to SQL: $e');
      return null;
    } finally {
      closeConnection();
    }
  }

  Future<void> closeConnection() async {
    try {
      await _sqlConnection.disconnect();
      _isConnected = false;
    } catch (e) {
      // Handle error while closing connection
      commonUtils.log.i('Error closing connection: $e');
    }
  }
}
