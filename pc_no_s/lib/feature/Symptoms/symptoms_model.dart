class SymptomModel {
  int? age;
  double? bmi;
  double? weight;

  String weightGain = "None";
  String hairGrowth = "None";
  String hairLoss = "None";
  String irregularCycle = "None";
  String skin = "None";
  String acne = "None";

  int? cycleLengthDays;

  double? fsh;
  double? lh;
  double? amh;
  double? tsh;
  double? prl;

  Map<String, dynamic> toJson() => {
    "age": age,
    "bmi": bmi,
    "weight": weight,
    "weight_gain": weightGain,
    "hair_growth": hairGrowth,
    "hair_loss": hairLoss,
    "irregular_cycle": irregularCycle,
    "skin": skin,
    "acne": acne,
    "cycle_length_days": cycleLengthDays,
    "fsh": fsh,
    "lh": lh,
    "amh": amh,
    "tsh": tsh,
    "prl": prl,
  };
}
