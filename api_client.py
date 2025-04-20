import time
import cv2
import requests

# API endpoint
API_URL = "http://localhost:8000/predict"

# Parameters to send to server
PROMPT = "ball"
BOX_THRESHOLD = 0.3
TEXT_THRESHOLD = 0.25

# Read from a video file
cap = cv2.VideoCapture("example_video.mp4")

# Font for drawing labels
font = cv2.FONT_HERSHEY_SIMPLEX

while True:
    ret, frame = cap.read()
    if not ret:
        print("Failed to grab frame")
        break

    # Encode frame as JPEG
    _, img_encoded = cv2.imencode('.jpg', frame)
    files = {
        'file': ('frame.jpg', img_encoded.tobytes(), 'image/jpeg')
    }

    data = {
        'prompt': PROMPT,
        'box_threshold': str(BOX_THRESHOLD),
        'text_threshold': str(TEXT_THRESHOLD)
    }

    try:
        # Send to server
        start_time = time.time()
        response = requests.post(API_URL, files=files, data=data)
        response.raise_for_status()
        detections = response.json()["detections"]
        elapsed_time = time.time() - start_time
        print(f"Elapsed time: {elapsed_time:.2f} seconds")

        if response.ok:
            print("Detections:", detections)
        else:
            print("Error:", response.status_code, response.text)

        # Draw the bounding boxes
        for det in detections:
            cx, cy, w, h = det["box"]
            score = det["score"]
            label = det["label"]

            # Convert to xyxy
            x1 = int((cx - w / 2) * frame.shape[1])
            y1 = int((cy - h / 2) * frame.shape[0])
            x2 = int((cx + w / 2) * frame.shape[1])
            y2 = int((cy + h / 2) * frame.shape[0])
            print(f"Box: {x1}, {y1}, {x2}, {y2}")

            # Draw box
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

            # Draw label with score
            text = f"{label} ({score:.2f})"
            cv2.putText(frame, text, (x1, y1 - 8), font, 0.5, (0, 255, 0), 1)

    except Exception as e:
        print("Request failed:", e)

    # Show the frame
    cv2.imshow("DINO Detection", frame)

    # Press 'q' to quit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
