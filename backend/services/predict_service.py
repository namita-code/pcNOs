import joblib
import numpy as np

rf = joblib.load("model/pcos_severity_model.pkl")
scaler = joblib.load("model/scaler.pkl")

def to_binary(value: str) -> int:
    if not value:
        return 0
    return 1 if str(value).lower() in ['yes', 'y', 'true', '1'] else 0

def predict_pcos_severity(data: dict) -> str:
    """
    Takes patient data dictionary from Flutter and returns predicted severity label.
    """

    # Convert and compute derived feature LH_FSH_ratio safely
    lh = float(data.get("lh", 0))
    fsh = float(data.get("fsh", 1)) or 1  # avoid divide by zero
    lh_fsh_ratio = lh / fsh

    features = np.array([
        float(data.get("age", 0)),
        float(data.get("bmi", 0)),
        float(data.get("weight", 0)),
        to_binary(data.get("weight_gain")),
        to_binary(data.get("hair_growth")),
        to_binary(data.get("skin")),
        to_binary(data.get("hair_loss")),
        to_binary(data.get("acne")),
        to_binary(data.get("irregular_cycle")),
        float(data.get("cycle_length_days", 0)),
        float(data.get("fsh", 0)),
        float(data.get("lh", 0)),
        float(data.get("amh", 0)),
        float(data.get("tsh", 0)),
        float(data.get("prl", 0)),
        lh_fsh_ratio
    ]).reshape(1, -1)

    scaled = scaler.transform(features)
    severity = rf.predict(scaled)[0]
    return severity
