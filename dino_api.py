from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
from groundingdino.util.inference import load_model, load_image, predict
from PIL import Image
import uvicorn
import numpy as np
import io

model = load_model(
    "groundingdino/config/GroundingDINO_SwinT_OGC.py",
    "weights/groundingdino_swint_ogc.pth"
)

app = FastAPI(title="DINO Object Detection API")

@app.post("/predict")
async def detect_objects(
    file: UploadFile = File(...),
    prompt: str = Form(...),
    box_threshold: float = Form(0.3),
    text_threshold: float = Form(0.25)
):
    try:
        # Read file contents
        contents = await file.read()

        # Save to temporary buffer and reload via load_image
        image_bytes = io.BytesIO(contents)
        image_source, image = load_image(image_bytes)

        # Run prediction with client-sent parameters
        boxes, logits, phrases = predict(
            model=model,
            image=image,
            caption=prompt,
            box_threshold=box_threshold,
            text_threshold=text_threshold
        )

        results = []
        for box, score, phrase in zip(boxes, logits, phrases):
            cx, cy, w, h = map(float, box.tolist())  # keep it in cxcywh
            results.append({
                "box": [cx, cy, w, h],
                "score": float(score),
                "label": phrase
            })

        return JSONResponse(content={"detections": results})

    except Exception as e:
        print(f"Error processing file: {e}")
        return JSONResponse(status_code=500, content={"error": str(e)})

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
