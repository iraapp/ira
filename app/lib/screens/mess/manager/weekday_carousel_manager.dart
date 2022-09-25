// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:ira/screens/mess/student/mess_menu_model.dart';

// class WeekDayCarouselManager extends StatefulWidget {
//   WeekDayCarouselManager({required this.weekDay, Key? key}) : super(key: key);
//   final String weekDay;
//   final secureStorage = const FlutterSecureStorage();
//   final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

//   @override
//   State<WeekDayCarouselManager> createState() => _WeekDayCarouselManagerState();
// }

// class _WeekDayCarouselManagerState extends State<WeekDayCarouselManager> {
//   bool _isLoading = true;
//   bool _editingMode = false;
//   late String breakfastStartTime;
//   late String breakfastEndTime;
//   late String breakfastSlotId;
//   late String breakfastMenuId;
//   late String lunchStartTime;
//   late String lunchEndTime;
//   late String lunchSlotId;
//   late String lunchMenuId;
//   late String snacksStartTime;
//   late String snacksEndTime;
//   late String snacksSlotId;
//   late String snacksMenuId;
//   late String dinnerStartTime;
//   late String dinnerEndTime;
//   late String dinnerSlotId;
//   late String dinnerMenuId;

//   List<MealItems> breakfastItems = [];
//   final TextEditingController _breakfastItemController =
//       TextEditingController();
//   List<MealItems> lunchItems = [];
//   final TextEditingController _lunchItemController = TextEditingController();
//   List<MealItems> snacksItems = [];
//   final TextEditingController _snacksItemController = TextEditingController();
//   List<MealItems> dinnerItems = [];
//   final TextEditingController _dinnerItemController = TextEditingController();

//   final secureStorage = const FlutterSecureStorage();
//   final String baseUrl = FlavorConfig.instance.variables['baseUrl'];

//   Future<WeekDay> _getWeekDayData() async {
//     try {
//       final String? token = await secureStorage.read(key: 'staffToken');
//       final requestUrl = Uri.parse(baseUrl + '/mess/all_items');
//       final response = await http.get(
//         requestUrl,
//         headers: <String, String>{
//           "Content-Type": "application/x-www-form-urlencoded",
//           'Authorization': token != null ? 'Token ' + token : '',
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final weekData = data[widget.weekDay];
//         // final MealType breakfast = MealType.fromJson(weekData["Breakfast"]);
//         // final MealType lunch = MealType.fromJson(weekData["Lunch"]);
//         // final MealType snacks = MealType.fromJson(weekData["Snacks"]);
//         // final MealType dinner = MealType.fromJson(weekData["Dinner"]);

//         // List<MealType> _meals = [breakfast, lunch, snacks, dinner];

//     //     Map<String, dynamic> weekDataMap = {
//     //       "weekday": widget.weekDay,
//     //       "meals": _meals,
//     //     };
//     //     return WeekDay.fromJson(weekDataMap);
//     //   } else {
//     //     // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
//     //     throw Exception('API Call Failed');
//     //   }
//     // } catch (e) {
//     //   return WeekDay(meals: [], weekday: "");
//     // }
//   }

//   Future<void> _updateInitialData() async {
//     final WeekDay data = await _getWeekDayData();
//     if (data.meals.isEmpty) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//     breakfastItems = [];
//     lunchItems = [];
//     snacksItems = [];
//     dinnerItems = [];
//     setState(() {
//       breakfastStartTime = data.meals[0].slot.startTime;
//       breakfastEndTime = data.meals[0].slot.endTime;
//       breakfastSlotId = data.meals[0].slot.id;
//       breakfastMenuId = data.meals[0].id;
//       lunchStartTime = data.meals[1].slot.startTime;
//       lunchEndTime = data.meals[1].slot.endTime;
//       lunchSlotId = data.meals[1].slot.id;
//       lunchMenuId = data.meals[1].id;
//       snacksStartTime = data.meals[2].slot.startTime;
//       snacksEndTime = data.meals[2].slot.endTime;
//       snacksSlotId = data.meals[2].slot.id;
//       snacksMenuId = data.meals[2].id;
//       dinnerStartTime = data.meals[3].slot.startTime;
//       dinnerEndTime = data.meals[3].slot.endTime;
//       dinnerSlotId = data.meals[3].slot.id;
//       dinnerMenuId = data.meals[3].id;
//       // adding items to breakfast list
//       for (var item in data.meals[0].items) {
//         breakfastItems.add(item);
//       }
//       // adding items to lunch list
//       for (var item in data.meals[1].items) {
//         lunchItems.add(item);
//       }
//       // adding items to snacks list
//       for (var item in data.meals[2].items) {
//         snacksItems.add(item);
//       }
//       // adding items to dinner list
//       for (var item in data.meals[3].items) {
//         dinnerItems.add(item);
//       }
//       _isLoading = false;
//     });
//   }

//   Future<void> _updateSlotTiming(
//       String startTime, String endTime, String slotId) async {
//     final String? token = await secureStorage.read(key: 'staffToken');
//     Map<String, dynamic> formMap = {
//       'start_time': startTime,
//       'end_time': endTime,
//       'slot_id': slotId,
//     };
//     final requestUrl = Uri.parse(baseUrl + '/mess/menu/timing');
//     final response = await http.post(
//       requestUrl,
//       headers: <String, String>{
//         "Content-Type": "application/x-www-form-urlencoded",
//         'Authorization': 'Token ' + token!
//       },
//       encoding: Encoding.getByName('utf-8'),
//       body: formMap,
//     );

//     if (response.statusCode == 200) {
//       return;
//     } else {
//       // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
//     }
//   }

//   Future<void> _removeMenuItem(
//       String menuId, String menuItemId, String action) async {
//     final String? token = await secureStorage.read(key: 'staffToken');
//     Map<String, dynamic> formMap = {
//       'menu_id': menuId,
//       'menu_item_id': menuItemId,
//       'action': action,
//     };
//     final requestUrl = Uri.parse(baseUrl + '/mess/menu/item_update');
//     final response = await http.post(
//       requestUrl,
//       headers: <String, String>{
//         "Content-Type": "application/x-www-form-urlencoded",
//         'Authorization': 'Token ' + token!
//       },
//       encoding: Encoding.getByName('utf-8'),
//       body: formMap,
//     );

//     if (response.statusCode == 200) {
//       return;
//     } else {
//       // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
//     }
//   }

//   Future<void> _addMenuItem(String menuItemName, String menuId) async {
//     final String? token = await secureStorage.read(key: 'staffToken');
//     Map<String, dynamic> formMap = {
//       'menu_id': menuId,
//       'menu_item_name': menuItemName,
//     };
//     final requestUrl = Uri.parse(baseUrl + '/mess/menu/item_add');
//     final response = await http.post(
//       requestUrl,
//       headers: <String, String>{
//         "Content-Type": "application/x-www-form-urlencoded",
//         'Authorization': 'Token ' + token!
//       },
//       encoding: Encoding.getByName('utf-8'),
//       body: formMap,
//     );

//     if (response.statusCode == 200) {
//       return;
//     } else {
//       // ScaffoldMessenger.of(context).showSnackBar(alertSnackbar);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _updateInitialData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : breakfastItems.isEmpty
//             ? const Center(
//                 child: Text("No data available"),
//               )
//             : Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10.0, vertical: 20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Opacity(
//                               opacity: 0.0,
//                               child: TextButton(
//                                 onPressed: () {},
//                                 // ignore: prefer_const_literals_to_create_immutables
//                                 child: Row(children: [
//                                   const Text('Edit'),
//                                   const Icon(Icons.edit)
//                                 ]),
//                               ),
//                             ),
//                             Text(
//                               widget.weekDay,
//                               style: const TextStyle(fontSize: 20.0),
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 setState(() {
//                                   _editingMode = !_editingMode;
//                                   _isLoading = true;
//                                 });
//                                 // update data
//                                 await _updateInitialData();
//                               },
//                               // ignore: prefer_const_literals_to_create_immutables
//                               child: _editingMode
//                                   ? Row(children: const [
//                                       Text('Done'),
//                                       Icon(Icons.done)
//                                     ])
//                                   : Row(children: const [
//                                       Text('Edit'),
//                                       Icon(Icons.edit)
//                                     ]),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Breakfast',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 _editingMode
//                                     ? Container(
//                                         decoration: BoxDecoration(
//                                           border:
//                                               Border.all(color: Colors.black12),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4.0),
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';

//                                                     setState(() {
//                                                       breakfastStartTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         breakfastStartTime,
//                                                         breakfastEndTime,
//                                                         breakfastSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   breakfastStartTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 ' - ',
//                                                 style: TextStyle(
//                                                   fontSize: 18.0,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       breakfastEndTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         breakfastStartTime,
//                                                         breakfastEndTime,
//                                                         breakfastSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   breakfastEndTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     : viewTimings(
//                                         breakfastStartTime, breakfastEndTime),
//                               ],
//                             ),
//                             const SizedBox(height: 10.0),
//                             _editingMode
//                                 ? Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       SizedBox(
//                                         height: 30,
//                                         child: buildInputChips(
//                                             breakfastItems, breakfastMenuId),
//                                       ),
//                                       TextField(
//                                         controller: _breakfastItemController,
//                                         decoration: InputDecoration(
//                                           suffixIcon: IconButton(
//                                               onPressed: () async {
//                                                 final MealItems _mealItem =
//                                                     MealItems(
//                                                   name: _breakfastItemController
//                                                       .text,
//                                                   id: "-1",
//                                                 );
//                                                 await _addMenuItem(
//                                                     _mealItem.name,
//                                                     breakfastMenuId);
//                                                 setState(() {
//                                                   breakfastItems.add(_mealItem);
//                                                   _breakfastItemController
//                                                       .clear();
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.add)),
//                                           hintText: 'Add Item',
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : SizedBox(
//                                     height: 30,
//                                     child: buildChips(breakfastItems),
//                                   ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Lunch',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 _editingMode
//                                     ? Container(
//                                         decoration: BoxDecoration(
//                                           border:
//                                               Border.all(color: Colors.black12),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4.0),
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       lunchStartTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         lunchStartTime,
//                                                         lunchEndTime,
//                                                         lunchSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   lunchStartTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 ' - ',
//                                                 style: TextStyle(
//                                                   fontSize: 18.0,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       lunchEndTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         lunchStartTime,
//                                                         lunchEndTime,
//                                                         lunchSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   lunchEndTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     : viewTimings(lunchStartTime, lunchEndTime),
//                               ],
//                             ),
//                             const SizedBox(height: 10.0),
//                             _editingMode
//                                 ? Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       SizedBox(
//                                         height: 30,
//                                         child: buildInputChips(
//                                             lunchItems, lunchMenuId),
//                                       ),
//                                       TextField(
//                                         controller: _lunchItemController,
//                                         decoration: InputDecoration(
//                                           suffixIcon: IconButton(
//                                               onPressed: () async {
//                                                 final MealItems _mealItem =
//                                                     MealItems(
//                                                         name:
//                                                             _lunchItemController
//                                                                 .text,
//                                                         id: "-1");
//                                                 await _addMenuItem(
//                                                     _mealItem.name,
//                                                     lunchMenuId);
//                                                 setState(() {
//                                                   lunchItems.add(_mealItem);
//                                                   _lunchItemController.clear();
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.add)),
//                                           hintText: 'Add Item',
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : SizedBox(
//                                     height: 30,
//                                     child: buildChips(lunchItems),
//                                   ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Snacks',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 _editingMode
//                                     ? Container(
//                                         decoration: BoxDecoration(
//                                           border:
//                                               Border.all(color: Colors.black12),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4.0),
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       snacksStartTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         snacksStartTime,
//                                                         snacksEndTime,
//                                                         snacksSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   snacksStartTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 ' - ',
//                                                 style: TextStyle(
//                                                   fontSize: 18.0,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       snacksEndTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         snacksStartTime,
//                                                         snacksEndTime,
//                                                         snacksSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   snacksEndTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     : viewTimings(
//                                         snacksStartTime, snacksEndTime),
//                               ],
//                             ),
//                             const SizedBox(height: 10.0),
//                             _editingMode
//                                 ? Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       SizedBox(
//                                         height: 30,
//                                         child: buildInputChips(
//                                             snacksItems, snacksMenuId),
//                                       ),
//                                       TextField(
//                                         controller: _snacksItemController,
//                                         decoration: InputDecoration(
//                                           suffixIcon: IconButton(
//                                               onPressed: () async {
//                                                 final MealItems _mealItem =
//                                                     MealItems(
//                                                   name: _snacksItemController
//                                                       .text,
//                                                   id: "-1",
//                                                 );
//                                                 await _addMenuItem(
//                                                     _mealItem.name,
//                                                     snacksMenuId);
//                                                 setState(() {
//                                                   snacksItems.add(_mealItem);
//                                                   _snacksItemController.clear();
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.add)),
//                                           hintText: 'Add Item',
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : SizedBox(
//                                     height: 30,
//                                     child: buildChips(snacksItems),
//                                   ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Dinner',
//                                   style: TextStyle(
//                                     fontSize: 18.0,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 _editingMode
//                                     ? Container(
//                                         decoration: BoxDecoration(
//                                           border:
//                                               Border.all(color: Colors.black12),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4.0),
//                                           child: Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       dinnerStartTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         dinnerStartTime,
//                                                         dinnerEndTime,
//                                                         dinnerSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   dinnerStartTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 ' - ',
//                                                 style: TextStyle(
//                                                   fontSize: 18.0,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   TimeOfDay initialTime =
//                                                       TimeOfDay.now();
//                                                   final selectedTime =
//                                                       await showTimePicker(
//                                                     context: context,
//                                                     initialTime: initialTime,
//                                                     initialEntryMode:
//                                                         TimePickerEntryMode
//                                                             .dial,
//                                                   );
//                                                   if (selectedTime != null) {
//                                                     final hour = selectedTime
//                                                                 .hour <
//                                                             10
//                                                         ? '0${selectedTime.hour}'
//                                                         : '${selectedTime.hour}';
//                                                     final minute = selectedTime
//                                                                 .minute <
//                                                             10
//                                                         ? '0${selectedTime.minute}'
//                                                         : '${selectedTime.minute}';
//                                                     final String
//                                                         formattedTimeOfDay =
//                                                         hour.toString() +
//                                                             ':' +
//                                                             minute.toString() +
//                                                             ':00';
//                                                     setState(() {
//                                                       dinnerEndTime =
//                                                           formattedTimeOfDay;
//                                                     });
//                                                     await _updateSlotTiming(
//                                                         dinnerStartTime,
//                                                         dinnerEndTime,
//                                                         dinnerSlotId);
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   dinnerEndTime,
//                                                   style: const TextStyle(
//                                                     fontSize: 18.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     : viewTimings(
//                                         dinnerStartTime, dinnerEndTime),
//                               ],
//                             ),
//                             const SizedBox(height: 10.0),
//                             _editingMode
//                                 ? Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       SizedBox(
//                                         height: 30,
//                                         child: buildInputChips(
//                                             dinnerItems, dinnerMenuId),
//                                       ),
//                                       TextField(
//                                         controller: _dinnerItemController,
//                                         decoration: InputDecoration(
//                                           suffixIcon: IconButton(
//                                               onPressed: () async {
//                                                 final MealItems _mealItem =
//                                                     MealItems(
//                                                         name:
//                                                             _dinnerItemController
//                                                                 .text,
//                                                         id: "-1");
//                                                 await _addMenuItem(
//                                                     _mealItem.name,
//                                                     dinnerMenuId);
//                                                 setState(() {
//                                                   dinnerItems.add(_mealItem);
//                                                   _dinnerItemController.clear();
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.add)),
//                                           hintText: 'Add Item',
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : SizedBox(
//                                     height: 30,
//                                     child: buildChips(dinnerItems),
//                                   ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//   }

//   Widget viewTimings(String startTime, String endTime) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             startTime,
//             style: const TextStyle(
//               fontSize: 18.0,
//             ),
//           ),
//           const Text(
//             ' - ',
//             style: TextStyle(
//               fontSize: 18.0,
//             ),
//           ),
//           Text(
//             endTime,
//             style: const TextStyle(
//               fontSize: 18.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildInputChips(List<MealItems> chipItems, String menuId) {
//     List<Widget> chips = [];
//     for (int i = 0; i < chipItems.length; i++) {
//       final inputChip = Chip(
//           label: Text(chipItems.elementAt(i).name),
//           onDeleted: () async {
//             await _removeMenuItem(menuId, chipItems.elementAt(i).id, "remove");
//             setState(() {
//               chipItems.remove(chipItems.elementAt(i));
//             });
//           });
//       chips.add(inputChip);
//     }
//     return ListView(
//       // This next line does the trick.
//       scrollDirection: Axis.horizontal,
//       children: chips,
//     );
//   }

//   Widget buildChips(List<MealItems> chipItems) {
//     List<Widget> chips = [];
//     for (int i = 0; i < chipItems.length; i++) {
//       final inputChip = Chip(
//         label: Text(chipItems.elementAt(i).name),
//       );
//       chips.add(inputChip);
//     }
//     return ListView(
//       // This next line does the trick.
//       scrollDirection: Axis.horizontal,
//       children: chips,
//     );
//   }
// }
