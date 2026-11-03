# 3D Asset Production Brief

The SVG assets in this repository are original lightweight 2D vector illustrations and are not 3D models. Production 3D assets should be authored in Blender and delivered with editable `.blend` sources plus optimized `.glb` exports.

## Initial asset inventory

- Royal room stage / background set.
- Voice-seat avatar frame and active-speaker ring.
- Gift collection (common, rare, VIP, seasonal) with event variants.
- Profile frames, VIP/SVIP badges, level medals, family and agency emblems.
- Room entry and PK win effects.
- UI icon family, currency tokens, task and event markers.

## Runtime guidance

- Keep static scene geometry in optimized GLB; use Draco only when the target renderer supports it reliably.
- Prefer baked textures and compact materials for broad mobile compatibility.
- Provide Lottie/Rive or sprite-based fallbacks for large effects and low-end devices.
- Define texture limits and device tiers before production. Do not bundle third-party branded assets without a license.
