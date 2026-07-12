# Nodulo landing page: plain-language hero copy

## Goal

Make the first product explanation concrete and physical. Avoid suggesting that
Nodulo is an autonomous AI system while preserving the current hero layout,
video, waitlist form, and visual design.

## Approved copy

**Headline**

> Build your own control panel.

**Supporting copy**

> Snap encoders, buttons, sliders, and displays into any layout. The blocks
> recognize each other, then control your speakers, lamps, thermostat, home
> appliances, and gear.

## Scope

- Change only the hero headline and supporting paragraph in `index.html`.
- Remove the current voice-command / AI-wiring claim from that paragraph.
- Do not change the feature cards, waitlist behavior, API, styling, video, or
  Cloudflare configuration.

## Implementation and verification

The page remains a static HTML page with the same form and Pages Function data
flow; this copy-only change introduces no new error paths or runtime behavior.

Verify by checking the edited HTML, pushing `main` to trigger the existing
Cloudflare Pages GitHub Action, and fetching `https://nodulo.link` to confirm
the production page contains the approved headline and supporting copy.
