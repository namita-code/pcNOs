from flask import Flask, request, jsonify
from services.predict_service import predict_pcos_severity
from services.todo_service import generate_todo_plan
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No input provided"}), 400

        result = predict_pcos_severity(data)
        return jsonify({"pcos_severity": result})

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/todo", methods=["POST"])
def todo():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No input provided"}), 400

        result = generate_todo_plan(data)
        return jsonify({"todo": result})

    except Exception as e:
        print("Error:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
