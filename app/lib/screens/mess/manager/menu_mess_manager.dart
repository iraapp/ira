import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MenuMessManager extends StatefulWidget {
  const MenuMessManager({Key? key}) : super(key: key);

  @override
  State<MenuMessManager> createState() => _MenuMessManagerState();
}

class _MenuMessManagerState extends State<MenuMessManager> {
  final List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  bool _editingMode = false;
  String breakfastStartTime = '9:00 AM';
  String breakfastEndTime = '10:00 AM';
  String lunchStartTime = '12:00 PM';
  String lunchEndTime = '13:00 PM';
  String snacksStartTime = '16:00 PM';
  String snacksEndTime = '17:00 PM';
  String dinnerStartTime = '9:00 PM';
  String dinnerEndTime = '10:30 PM';

  List<String> breakfastItems = [];
  final TextEditingController _breakfastItemController =
      TextEditingController();
  List<String> lunchItems = [];
  final TextEditingController _lunchItemController = TextEditingController();
  List<String> snacksItems = [];
  final TextEditingController _snacksItemController = TextEditingController();
  List<String> dinnerItems = [];
  final TextEditingController _dinnerItemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(0.0),
            ),
            color: Color(0xfff5f5f5),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.7),
                    items: _weekdays.map((day) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Opacity(
                                            opacity: 0.0,
                                            child: TextButton(
                                              onPressed: () {},
                                              // ignore: prefer_const_literals_to_create_immutables
                                              child: Row(children: [
                                                const Text('Edit'),
                                                const Icon(Icons.edit)
                                              ]),
                                            ),
                                          ),
                                          Text(
                                            day,
                                            style:
                                                const TextStyle(fontSize: 20.0),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _editingMode = !_editingMode;
                                              });
                                            },
                                            // ignore: prefer_const_literals_to_create_immutables
                                            child: _editingMode
                                                ? Row(children: const [
                                                    Text('Done'),
                                                    Icon(Icons.done)
                                                  ])
                                                : Row(children: const [
                                                    Text('Edit'),
                                                    Icon(Icons.edit)
                                                  ]),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Breakfast',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              _editingMode
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    breakfastStartTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                breakfastStartTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              ' - ',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    breakfastEndTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                breakfastEndTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : viewTimings(
                                                      breakfastStartTime,
                                                      breakfastEndTime),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          _editingMode
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      child: buildInputChips(
                                                          breakfastItems),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _breakfastItemController,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                breakfastItems.add(
                                                                    _breakfastItemController
                                                                        .text);
                                                                _breakfastItemController
                                                                    .clear();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                        hintText: 'Add Item',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child: buildChips(
                                                      breakfastItems),
                                                ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Lunch',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              _editingMode
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    lunchStartTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                lunchStartTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              ' - ',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    lunchEndTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                lunchEndTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : viewTimings(lunchStartTime,
                                                      lunchEndTime),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          _editingMode
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      child: buildInputChips(
                                                          lunchItems),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _lunchItemController,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                lunchItems.add(
                                                                    _lunchItemController
                                                                        .text);
                                                                _lunchItemController
                                                                    .clear();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                        hintText: 'Add Item',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child: buildChips(lunchItems),
                                                ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Snacks',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              _editingMode
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    snacksStartTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                snacksStartTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              ' - ',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    snacksEndTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                snacksEndTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : viewTimings(snacksStartTime,
                                                      snacksEndTime),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          _editingMode
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      child: buildInputChips(
                                                          snacksItems),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _snacksItemController,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                snacksItems.add(
                                                                    _snacksItemController
                                                                        .text);
                                                                _snacksItemController
                                                                    .clear();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                        hintText: 'Add Item',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child:
                                                      buildChips(snacksItems),
                                                ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Dinner',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              _editingMode
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4.0),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    dinnerStartTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                dinnerStartTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              ' - ',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                TimeOfDay
                                                                    initialTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                final selectedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      initialTime,
                                                                  initialEntryMode:
                                                                      TimePickerEntryMode
                                                                          .dial,
                                                                );
                                                                if (selectedTime !=
                                                                    null) {
                                                                  final localizations =
                                                                      MaterialLocalizations.of(
                                                                          context);
                                                                  final formattedTimeOfDay =
                                                                      localizations
                                                                          .formatTimeOfDay(
                                                                              selectedTime);
                                                                  setState(() {
                                                                    dinnerEndTime =
                                                                        formattedTimeOfDay;
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                dinnerEndTime,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : viewTimings(dinnerStartTime,
                                                      dinnerEndTime),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          _editingMode
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                      child: buildInputChips(
                                                          dinnerItems),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _dinnerItemController,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                dinnerItems.add(
                                                                    _dinnerItemController
                                                                        .text);
                                                                _dinnerItemController
                                                                    .clear();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.add)),
                                                        hintText: 'Add Item',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child:
                                                      buildChips(dinnerItems),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewTimings(String startTime, String endTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
      child: Row(
        children: [
          Text(
            startTime,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const Text(
            ' - ',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Text(
            endTime,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputChips(List<String> chipItems) {
    List<Widget> chips = [];
    for (int i = 0; i < chipItems.length; i++) {
      final inputChip = Chip(
          label: Text(chipItems[i]),
          onDeleted: () {
            setState(() {
              chipItems.removeAt(i);
            });
          });
      chips.add(inputChip);
    }
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  Widget buildChips(List<String> chipItems) {
    List<Widget> chips = [];
    for (int i = 0; i < chipItems.length; i++) {
      final inputChip = Chip(
        label: Text(chipItems[i]),
      );
      chips.add(inputChip);
    }
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }
}
