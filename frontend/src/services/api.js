const BASE = import.meta.env.VITE_API_URL || "/api";
const DOWN = "Analysis service is currently unavailable.";

async function request(path, options) {
  let res;
  try {
    res = await fetch(BASE + path, options);
  } catch {
    throw new Error(DOWN);
  }
  if (!res.ok) {
    let detail = res.status >= 500 ? DOWN : "Request failed.";
    try {
      const body = await res.json();
      if (typeof body.detail === "string") detail = body.detail;
      else if (Array.isArray(body.detail)) detail = "Please check the values you entered.";
    } catch { /* keep default message */ }
    throw new Error(detail);
  }
  return res.json();
}

const json = (body) => ({ method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });

export const predictSkin = (file) => {
  const form = new FormData();
  form.append("image", file);
  return request("/predict-skin", { method: "POST", body: form });
};
export const getDatasetStatus = () => request("/dataset-status");
export const getNutritionPlan = (profile) => request("/nutrition-plan", json(profile));
export const referenceImageUrl = (key) => `${BASE}/reference-image/${key}`;
