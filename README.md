# PredictSkin

An educational prototype that compares an uploaded skin photo with seven reference images and reports which one it most resembles. It does not diagnose anything.

> PredictSkin is an educational prototype and should not be used as a substitute for professional medical diagnosis or treatment.

## How it works
A pretrained MobileNetV2 (or ResNet50) with its last layer removed turns each image into an embedding. Cosine similarity between the upload and each reference ranks the 7 classes. Percentages are a softmax of the cosine values (temperature 0.05), so they add up to 100%. Weak or close results are shown as "Uncertain Result". Nothing is random or hard-coded.

## 1. Install the tools (once)
1. **Python 3.10 to 3.12** from https://www.python.org/downloads/ . On Windows tick **Add python.exe to PATH**.
2. **Node.js LTS** from https://nodejs.org/ .
3. Open this folder in VS Code (File > Open Folder > `predictskin`).

## 2. Add the 7 reference images
Put one image in each folder. File names do not matter. JPG, JPEG, PNG and WEBP are all supported.

| Your file | Folder |
|---|---|
| normal skin.jpg | backend/dataset/normal_skin/ |
| eczema.webp | backend/dataset/eczema/ |
| Psoriasis.webp | backend/dataset/psoriasis/ |
| ringworm.jpg | backend/dataset/ringworm/ |
| chickenpox.webp | backend/dataset/chickenpox/ |
| Rosacea.webp | backend/dataset/rosacea/ |
| Cellulitis.jpg | backend/dataset/cellulitis/ |

If you keep more than one image in a folder, only the first valid one (alphabetical) is used. To replace an image, delete the old one, add the new one, and restart the backend.

## 3. Start the app

**Windows (easiest):** double-click `START-WINDOWS.cmd`. Two windows open (backend and frontend) and the browser opens http://localhost:5173 . The first run installs packages and downloads the model, so it takes a few minutes.

**Mac/Linux:** run `./start.sh` in a terminal.

**Manually (two terminals):**
- Backend: `python -m venv .venv`, activate it, `pip install -r requirements.txt`, then `cd backend` and `uvicorn main:app --port 8000`
- Frontend: `cd frontend`, `npm install`, `npm run dev`

## 4. Test it
- Open http://localhost:5173 and go to **Reference Dataset**. All 7 images should show.
- Upload each reference image on **Skin Analysis**. Its own class should rank first.
- Same check without the browser: `cd backend` then `python verify_dataset.py`
- Missing image: remove one reference, restart the backend, and the analysis shows a "Reference dataset incomplete" error.

## 5. Test the API
Open http://localhost:8000/docs for an interactive page. Endpoints: `GET /health`, `GET /dataset-status`, `POST /predict-skin` (form field `image`), `POST /health-profile`, `POST /nutrition-plan`.

## 6. Settings
The defaults work as they are. To change the model or the uncertainty thresholds (`MIN_COSINE`, `MIN_MARGIN`), set the variables listed in `.env.example` in the terminal before starting the backend. If real photos always come out "Uncertain", lower `MIN_COSINE`.

## 7. Deploy
- **Frontend (Vercel, Netlify):** root `frontend`, build `npm run build`, output `dist`, and set `VITE_API_URL` to your backend URL.
- **Backend (Render, Railway):** root `backend`, install `pip install -r ../requirements.txt`, start `uvicorn main:app --host 0.0.0.0 --port $PORT`. Include `backend/dataset` with the images, and set `ALLOWED_ORIGINS` to your frontend URL. PyTorch needs about 1 GB of memory, so choose a plan that allows it.

## Privacy
Uploaded images are processed in memory and never saved. The health profile stays in your browser (only if you tick "Remember profile"). Recent analyses keep only the prediction, scores and time, for the current browser tab.
