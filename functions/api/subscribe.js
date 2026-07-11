// Cloudflare Pages Function — stores preorder emails in D1 (binding: DB)
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export async function onRequestPost(context) {
  const { request, env } = context;

  let email;
  try {
    const body = await request.json();
    email = (body.email || "").trim().toLowerCase();
  } catch {
    return json({ error: "Invalid request." }, 400);
  }

  if (!EMAIL_RE.test(email) || email.length > 254) {
    return json({ error: "Please enter a valid email address." }, 400);
  }

  if (!env.DB) {
    return json({ error: "Storage not configured." }, 500);
  }

  const ip = request.headers.get("cf-connecting-ip") || "";
  const ua = request.headers.get("user-agent") || "";
  const ts = new Date().toISOString();

  try {
    await env.DB.prepare(
      "INSERT INTO subscribers (email, created_at, ip, user_agent) VALUES (?, ?, ?, ?) " +
      "ON CONFLICT(email) DO NOTHING"
    ).bind(email, ts, ip, ua).run();
  } catch (e) {
    return json({ error: "Could not save. Please try again." }, 500);
  }

  return json({ ok: true });
}

// Reject non-POST
export async function onRequest(context) {
  if (context.request.method !== "POST") {
    return json({ error: "Method not allowed." }, 405);
  }
  return onRequestPost(context);
}

function json(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
