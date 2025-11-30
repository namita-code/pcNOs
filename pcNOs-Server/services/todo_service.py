import requests
import os

# Load Perplexity API Key
PPLX_API_KEY = os.environ.get("PPLX_API_KEY")

def generate_prompt(user_data: dict) -> str:
    return f"""
You are a warm, friendly PCOS wellness coach.

Below is the patient's information:
{user_data}

Your task is to generate a **beautiful, emoji-rich, supportive PCOS improvement plan**.

IMPORTANT RULES:
- DO NOT include citations, references, bracketed numbers like [1], [2], [3], or URLs.
- Keep all content supportive, uplifting, and non-clinical.
- DO NOT diagnose or prescribe medication.
- Use emojis to make content friendly and encouraging.
- Keep sections neat, visually separated, and easy to understand.
- Use bullet points when needed—NOT long paragraphs.

Please provide ALL the following sections in order, each with relevant emojis:

---

### 🌅 Daily Routine
Give morning, afternoon, evening recommendations using simple bullet points.

### 📅 Weekly Routine
Provide weekly habits like exercise frequency, meal prep suggestions, or self-care practices.

### 🍽️ Diet Plan
Include:
- meals
- snack ideas
- foods to include 🍓
- foods to avoid 🚫
Use emojis in each bullet point.

### 🏃‍♀️ Exercise Plan
Beginner-friendly:
- steps count 👣
- workout types 🧘‍♀️
- time duration ⏱

### 💊 Supplements (General Only)
Provide simple, evidence-based general supplements.
Example: Vitamin D, Omega-3 (if needed).
No dosage. No prescriptions.

### 🌿 Lifestyle Changes
Stress management, sleep habits 😴, hydration 💧, self-care.

### 🚫 What to Avoid
Foods, habits, patterns that may worsen PCOS symptoms.

### 🔍 Tracking Progress
Explain what improvements to notice:
- energy levels ⚡
- mood 🙂
- cycles
- appetite

### 💖 Motivational Note
End with a positive, reassuring paragraph.

---

Tone: kind, supportive, feminine, and empowering. 
Output should feel like a personal coach helping the user on a healing journey.
"""


def generate_todo_plan(user_data: dict) -> str:
    if not PPLX_API_KEY:
        raise Exception("Perplexity API key missing. Set PPLX_API_KEY environment variable.")

    prompt = generate_prompt(user_data)

    url = "https://api.perplexity.ai/chat/completions"

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {PPLX_API_KEY}",
    }

    payload = {
        "model": "sonar-pro",
        "messages": [
            {"role": "system", "content": "You are a medical assistant specialized in PCOS management and safe lifestyle recommendations."},
            {"role": "user", "content": prompt}
        ],
        "max_tokens": 3000,
        "temperature": 0.7,
        "top_p": 0.9
    }

    response = requests.post(url, json=payload, headers=headers)

    if response.status_code != 200:
        raise Exception(f"Perplexity API Error: {response.text}")

    result = response.json()
    return result["choices"][0]["message"]["content"]
