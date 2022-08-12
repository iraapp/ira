import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ira/screens/gate_pass/update_gate_pass.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';

class ScanGatePass extends StatelessWidget {
  const ScanGatePass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Gate Pass'),
      ),
      body: const Center(
        child: Text('Scan Gate Pass'),
      ),
    );
  }
}

// class ScanGatePass extends StatefulWidget {
//   const ScanGatePass({Key? key}) : super(key: key);

//   @override
//   State<ScanGatePass> createState() => _ScanGatePassState();
// }

// class _ScanGatePassState extends State<ScanGatePass> {
//   String baseUrl = FlavorConfig.instance.variables['baseUrl'];
//   final secureStorage = const FlutterSecureStorage();

//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       this.controller?.pauseCamera();
//       setState(() async {
//         result = scanData;
//         final String? hash = result?.code;
//         if (hash != null) {
//           HapticFeedback.vibrate();
//           Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => UpdateGatePass(hash: hash)))
//               .then((value) => this.controller?.resumeCamera());
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scanArea = MediaQuery.of(context).size.width * 0.9;

//     return Scaffold(
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//             borderColor: Colors.red,
//             borderRadius: 10,
//             borderLength: 30,
//             borderWidth: 10,
//             cutOutSize: scanArea),
//         onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//       ),
//     );
//   }
// }
