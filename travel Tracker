import React, { useState, useEffect } from "react";

// Simple Travel Order Tracker
// Usage: Save this file as TravelTracker.jsx and render it in your React app (e.g. App.jsx -> <TravelTracker />).
// Styling uses Tailwind classes (assumes Tailwind is available). If not using Tailwind, replace classNames.

export default function TravelTracker() {
  const [orders, setOrders] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem("travel_orders") || "[]");
    } catch (e) {
      return [];
    }
  });

  const [form, setForm] = useState({
    title: "",
    destination: "",
    startDate: "",
    endDate: "",
    purpose: "",
    mode: "",
    estimatedCost: "",
    status: "Planned",
    notes: "",
  });

  useEffect(() => {
    localStorage.setItem("travel_orders", JSON.stringify(orders));
  }, [orders]);

  function handleChange(e) {
    const { name, value } = e.target;
    setForm((s) => ({ ...s, [name]: value }));
  }

  function addOrder(e) {
    e.preventDefault();
    const id = Date.now().toString();
    setOrders((prev) => [
      ...prev,
      { id, ...form, createdAt: new Date().toISOString() },
    ]);
    setForm({
      title: "",
      destination: "",
      startDate: "",
      endDate: "",
      purpose: "",
      mode: "",
      estimatedCost: "",
      status: "Planned",
      notes: "",
    });
  }

  function removeOrder(id) {
    if (!confirm("Delete this travel order?")) return;
    setOrders((prev) => prev.filter((o) => o.id !== id));
  }

  function toggleStatus(id) {
    setOrders((prev) =>
      prev.map((o) =>
        o.id === id ? { ...o, status: o.status === "Completed" ? "Planned" : "Completed" } : o
      )
    );
  }

  function exportCSV() {
    const headers = [
      "id",
      "title",
      "destination",
      "startDate",
      "endDate",
      "purpose",
      "mode",
      "estimatedCost",
      "status",
      "notes",
      "createdAt",
    ];
    const rows = orders.map((o) => headers.map((h) => (o[h] || "").toString()));
    const csv = [headers.join(","), ...rows.map((r) => r.map((c) => `"${c.replace(/"/g, '""')}"`).join(","))].join("\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `travel_orders_${new Date().toISOString()}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

  function importJSON(e) {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      try {
        const data = JSON.parse(reader.result);
        if (!Array.isArray(data)) throw new Error("JSON must be an array of travel orders");
        // Simple merge: append imported orders with new IDs if missing
        const normalized = data.map((d) => ({ id: d.id || Date.now().toString() + Math.random(), ...d }));
        setOrders((prev) => [...prev, ...normalized]);
      } catch (err) {
        alert("Invalid JSON file: " + err.message);
      }
    };
    reader.readAsText(file);
  }

  function clearAll() {
    if (!confirm("Clear all travel orders? This cannot be undone.")) return;
    setOrders([]);
  }

  // Simple filters
  const [filter, setFilter] = useState({ q: "", status: "Any" });
  const filtered = orders.filter((o) => {
    if (filter.status !== "Any" && o.status !== filter.status) return false;
    if (filter.q) {
      const q = filter.q.toLowerCase();
      return (
        (o.title || "").toLowerCase().includes(q) ||
        (o.destination || "").toLowerCase().includes(q) ||
        (o.purpose || "").toLowerCase().includes(q)
      );
    }
    return true;
  });

  return (
    <div className="p-4 max-w-4xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Travel Order Tracker</h1>

      <form onSubmit={addOrder} className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-4">
        <input name="title" value={form.title} onChange={handleChange} placeholder="Trip title (e.g. " + "Conference Manila") className="p-2 border rounded" />
        <input name="destination" value={form.destination} onChange={handleChange} placeholder="Destination" className="p-2 border rounded" />
        <input name="startDate" value={form.startDate} onChange={handleChange} type="date" className="p-2 border rounded" />
        <input name="endDate" value={form.endDate} onChange={handleChange} type="date" className="p-2 border rounded" />
        <input name="purpose" value={form.purpose} onChange={handleChange} placeholder="Purpose (e.g. Training)" className="p-2 border rounded" />
        <input name="mode" value={form.mode} onChange={handleChange} placeholder="Mode (Air/Sea/Land)" className="p-2 border rounded" />
        <input name="estimatedCost" value={form.estimatedCost} onChange={handleChange} placeholder="Estimated cost" className="p-2 border rounded" />
        <select name="status" value={form.status} onChange={handleChange} className="p-2 border rounded">
          <option>Planned</option>
          <option>Ongoing</option>
          <option>Completed</option>
          <option>Cancelled</option>
        </select>
        <textarea name="notes" value={form.notes} onChange={handleChange} placeholder="Notes" className="p-2 border rounded md:col-span-2" />

        <div className="md:col-span-2 flex gap-2">
          <button className="px-4 py-2 rounded bg-blue-600 text-white" type="submit">Add travel order</button>
          <button type="button" onClick={exportCSV} className="px-4 py-2 rounded bg-green-600 text-white">Export CSV</button>
          <label className="px-4 py-2 rounded bg-gray-200 cursor-pointer">
            Import JSON
            <input type="file" accept="application/json" onChange={importJSON} className="hidden" />
          </label>
          <button type="button" onClick={clearAll} className="px-4 py-2 rounded bg-red-600 text-white">Clear all</button>
        </div>
      </form>

      <div className="mb-4 flex gap-2 items-center">
        <input placeholder="Search title/destination/purpose" value={filter.q} onChange={(e) => setFilter((s) => ({ ...s, q: e.target.value }))} className="p-2 border rounded flex-1" />
        <select value={filter.status} onChange={(e) => setFilter((s) => ({ ...s, status: e.target.value }))} className="p-2 border rounded">
          <option>Any</option>
          <option>Planned</option>
          <option>Ongoing</option>
          <option>Completed</option>
          <option>Cancelled</option>
        </select>
      </div>

      <div className="space-y-3">
        {filtered.length === 0 && <div className="text-gray-500">No travel orders yet.</div>}
        {filtered.map((o) => (
          <div key={o.id} className="p-3 border rounded flex justify-between items-start">
            <div>
              <div className="font-semibold">{o.title} <span className="text-sm text-gray-500">({o.destination})</span></div>
              <div className="text-sm text-gray-600">{o.startDate} → {o.endDate} · {o.purpose}</div>
              <div className="text-sm">Mode: {o.mode} · Cost: {o.estimatedCost}</div>
              {o.notes && <div className="text-sm mt-1">Notes: {o.notes}</div>}
              <div className="text-xs text-gray-400">Created: {new Date(o.createdAt).toLocaleString()}</div>
            </div>
            <div className="flex flex-col gap-2 items-end">
              <div className={`px-2 py-1 rounded text-sm ${o.status === 'Completed' ? 'bg-green-100' : 'bg-yellow-100'}`}>{o.status}</div>
              <button onClick={() => toggleStatus(o.id)} className="px-3 py-1 border rounded">Toggle status</button>
              <button onClick={() => removeOrder(o.id)} className="px-3 py-1 border rounded text-red-600">Delete</button>
            </div>
          </div>
        ))}
      </div>

      <footer className="mt-6 text-sm text-gray-600">
        Tip: This app stores data locally in your browser (localStorage). To make it accessible across devices you'll need a backend or a cloud-sync solution (Firebase, Supabase, or a simple API).
      </footer>
    </div>
  );
}

/*
Quick deployment notes (short):
- This is a single React component. To publish quickly:
  1) Create a new React app (e.g. using Vite or Create React App).
  2) Add this file and import it into App.jsx.
  3) Build the app (npm run build) and deploy the build folder to any static hosting (GitHub Pages, Vercel, Netlify, Firebase Hosting, Render).

If you want a backend (sync across devices):
- Use Firebase (Firestore) or Supabase for user-auth + cloud storage.
- Or deploy a small Node/Express or serverless function that stores travel orders in a database.
*/
