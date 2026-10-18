import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/storage/shared_prefs.dart';
import 'symptoms_model.dart';
import 'symptoms_repository.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  final SymptomModel model = SymptomModel();
  final _formKey = GlobalKey<FormState>();
  final SymptomsRepository repo = SymptomsRepository();

  final PageController _pageController = PageController();

  int _step = 0; // 0 = Intro, 1–4 = form steps

  static const Color accent = Colors.pinkAccent;
  static const double radius = 20;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // UI Helpers
  // -------------------------------------------------------

  InputDecoration _decor(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: accent, fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: accent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey),
    ),
  );

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white.withOpacity(.95),
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.15),
        blurRadius: 25,
        offset: const Offset(0, 10),
      ),
    ],
  );

  Widget _cardShell({required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 620),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          padding: const EdgeInsets.all(22),
          decoration: _cardDecoration,
          child: child,
        ),
      ),
    );
  }

  Text _title(String t) => Text(
    t,
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: accent,
    ),
  );

  // -------------------------------------------------------
  // MAIN BUILD
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    const totalSteps = 5; // 0 = intro, 1-4 actual

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.pink[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // DOT STEPPER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalSteps,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: _step == i ? 14 : 10,
                    height: _step == i ? 14 : 10,
                    decoration: BoxDecoration(
                      color:
                      _step == i ? accent : Colors.white.withOpacity(.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PAGE CONTENT
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _cardShell(child: _stepIntro()),
                      _cardShell(child: _stepAboutYou()),
                      _cardShell(child: _stepSymptoms()),
                      _cardShell(child: _stepClinical()),
                      _cardShell(child: _stepReview()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _buildButtons(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // STEP 0 — INTRO
  // -------------------------------------------------------

  Widget _stepIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("PCOS Severity Tracker"),
        const SizedBox(height: 16),

        Text(
          "Hi, let’s understand your lifestyle better to personalize PCOS recommendations.",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey[800],
            height: 1.35,
          ),
        ),

        const Spacer(),

        // Start Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 8,
              shadowColor: accent.withOpacity(0.5),
            ),
            onPressed: () {
              setState(() => _step = 1);
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            },
            child: Text(
              "Start Assessment",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // STEP 1 — ABOUT YOU
  // -------------------------------------------------------

  Widget _stepAboutYou() {
    return ListView(
      children: [
        _title("About You"),
        const SizedBox(height: 16),

        _fieldNumber("Age (years)", (v) => model.age = int.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("BMI", (v) => model.bmi = double.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("Weight (kg)", (v) => model.weight = double.tryParse(v!)),
      ],
    );
  }

  // -------------------------------------------------------
  // STEP 2 — SYMPTOMS
  // -------------------------------------------------------

  Widget _stepSymptoms() {
    return ListView(
      children: [
        _title("Your Symptoms"),
        const SizedBox(height: 16),

        _dropdown("Recent Weight Gain?", model.weightGain,
                (v) => model.weightGain = v!),
        const SizedBox(height: 20),

        _dropdown("Hair Growth?", model.hairGrowth,
                (v) => model.hairGrowth = v!),
        const SizedBox(height: 20),

        _dropdown("Hair Loss?", model.hairLoss, (v) => model.hairLoss = v!),
        const SizedBox(height: 20),

        _dropdown("Skin Darkening?", model.skin, (v) => model.skin = v!),
        const SizedBox(height: 20),

        _dropdown("Acne?", model.acne, (v) => model.acne = v!),
        const SizedBox(height: 20),

        _dropdown("Irregular Cycle?", model.irregularCycle,
                (v) => model.irregularCycle = v!),
        const SizedBox(height: 20),

        _fieldNumber("Cycle Length (Days)",
                (v) => model.cycleLengthDays = int.tryParse(v!)),
      ],
    );
  }

  // -------------------------------------------------------
  // STEP 3 — CLINICAL VALUES
  // -------------------------------------------------------

  Widget _stepClinical() {
    return ListView(
      children: [
        _title("Clinical Values"),
        const SizedBox(height: 10),

        Text(
          "If you don’t know your hormone levels, you can skip this step. The prediction may be less precise without this information.",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[800],
            height: 1.35,
          ),
        ),

        const SizedBox(height: 16),

        _fieldNumber("FSH (mIU/mL)", (v) => model.fsh = double.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("LH (mIU/mL)", (v) => model.lh = double.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("AMH (mIU/mL)", (v) => model.amh = double.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("TSH (mIU/mL)", (v) => model.tsh = double.tryParse(v!)),
        const SizedBox(height: 20),

        _fieldNumber("PRL (mIU/mL)", (v) => model.prl = double.tryParse(v!)),
      ],
    );
  }


  // -------------------------------------------------------
  // STEP 4 — REVIEW
  // -------------------------------------------------------

  Widget _stepReview() {
    final data = model.toJson();

    return ListView(
      children: [
        _title("Review Details"),
        const SizedBox(height: 16),

        ...data.entries.map(
              (e) => ListTile(
            title: Text(
              e.key.replaceAll("_", " "),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${e.value}",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // BUTTONS (Hidden on Intro screen)
  // -------------------------------------------------------

  Widget _buildButtons() {
    if (_step == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (_step > 1)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: accent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  setState(() => _step--);
                  _pageController.animateToPage(
                    _step,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                  );
                },
                child: Text(
                  "Back",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_step > 1) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _onNextPressed,
              child: Text(
                _step == 4 ? "Submit" : "Next",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // NEXT / SUBMIT
  // -------------------------------------------------------

  Future<void> _onNextPressed() async {
    // Steps 1–3 → validate & move
    if (_step < 4) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() => _step++);
        _pageController.animateToPage(
          _step,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
      return;
    }

    // Step 4 → SUBMIT
    _formKey.currentState!.save();

    final data = model.toJson();
    await SharedPrefs.saveSymptomsData(data);

    try {
      final severity = await repo.getPcosProbability(data);
      await showPcosResultDialog(severity);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to predict: $e")),
      );
    }
  }

  // -------------------------------------------------------
  // FIELD HELPERS
  // -------------------------------------------------------

  Widget _fieldNumber(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: _decor(label),
      keyboardType:
      const TextInputType.numberWithOptions(decimal: true),
      validator: (v) => v!.isEmpty ? "Required" : null,
      onSaved: onSaved,
      style: GoogleFonts.poppins(),
    );
  }

  Widget _dropdown(
      String label, String current, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: _decor(label),
      value: current,
      items: const [
        DropdownMenuItem(value: "None", child: Text("None")),
        DropdownMenuItem(value: "Yes", child: Text("Yes")),
        DropdownMenuItem(value: "No", child: Text("No")),
      ],
      onChanged: onChanged,
      style: GoogleFonts.poppins(),
      dropdownColor: Colors.white,
    );
  }

  // -------------------------------------------------------
  // PCOS RESULT DIALOG
  // -------------------------------------------------------

  Future<void> showPcosResultDialog(String severity) async {
    // Your original mapping exactly preserved
    final Map<String, dynamic> info = {
      "Mild": {
        "color": Colors.greenAccent.shade700,
        "message":
        "Your PCOS risk is low. Keep maintaining a healthy and active lifestyle!",
        "emoji": "🌿",
      },
      "Moderate": {
        "color": Colors.orangeAccent.shade700,
        "message":
        "You have a moderate risk of PCOS. Consider lifestyle adjustments and medical guidance if needed.",
        "emoji": "🌸",
      },
      "Severe": {
        "color": Colors.redAccent.shade700,
        "message":
        "Your PCOS probability is high. Please consult a gynecologist for further evaluation and care.",
        "emoji": "❤️",
      }
    };

    final color = info[severity]?['color'] ?? Colors.grey;
    final message = info[severity]?['message'] ?? '';
    final emoji = info[severity]?['emoji'] ?? '💡';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),

              Text(
                "PCOS Severity",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                severity,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
