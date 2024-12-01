int calculateWaterIntake(int weight) {
  return (weight * 0.033).toInt();  // A simple formula: Weight in kg * 0.033
}

String formatTime(DateTime time) {
  return "${time.hour}:${time.minute}";
}

bool isValidWeight(int weight) {
  return weight >= 30 && weight <= 150;
}

bool isValidAge(int age) {
  return age >= 10 && age <= 100;
}
