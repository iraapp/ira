import 'package:flutter/material.dart';
import 'package:ira/screens/mess/factories/slot.dart';

class MessSlot extends StatelessWidget {
  final Slot slot;
  const MessSlot({
    Key? key,
    required this.slot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          slot.name,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: Column(
            children: slot.items
                .map(
                  (e) => Column(
                    children: [
                      Text(e.name),
                      const SizedBox(
                        height: 5.0,
                      )
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
