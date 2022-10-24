import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String diagnosis;
  final String treatment;
  final String details;
  final String doctor;
  final bool inhouse;

  const HistoryCard({
    Key? key,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.details,
    required this.doctor,
    required this.inhouse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(81, 158, 158, 158),
                offset: Offset(0, 3),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.00, 5.00, 30.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Diagnosis: " + diagnosis,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            "Treatment: " + treatment,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        details,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 12.5, 10.0, 12.5),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          doctor,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 12.5, 10.0, 12.5),
                      decoration: BoxDecoration(
                        color: inhouse ? Colors.blue : Colors.red,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          inhouse ? "Inhouse" : "Outhouse",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
