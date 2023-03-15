import 'package:flutter/material.dart';

class CarInfoRow extends StatelessWidget {
  final String carModel;
  final String carNumber;
  final int seats;

  const CarInfoRow({
    required this.carModel,
    required this.carNumber,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            carModel,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Text(
          carNumber,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 8),
        Text(
          'Seats: $seats',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
