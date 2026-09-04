---
layout: post
title:  "A Doom Ride-Along: Understanding 2.5D Rendering"
date:   2026-09-03 16:44:40 +0000
categories: programming
slug: a-doom-ride-along-understanding-2-5d-rendering
featureImage: "/images/2026/father-ted-cows.jpg"
published: true
---

<% slot :aside, transform: false do %>
  <%= render Shared::DeskWindow.new(
    id: "father-ted",
    title: "This cow is small...",
    init: :inactive,
    activate_at: "#step-4---perspective-projection",
    activate_as: :expanded,
    collapse_before: "#step-4---perspective-projection",
    style: "max-width: 400px;",
    persist: true
  ) do %>
    <img src="<%= relative_url "/images/2026/father-ted-cows.jpg" %>" alt="Father Ted cows" />
    <p>... <a href="https://www.youtube.com/watch?v=MMiKyfd6hA0">those ones are far away</a>.</p>
  <% end %>
<% end %>

<a href="https://fabiensanglard.net/gebbdoom/" target="_blank">
  <img src="<%= relative_url "/images/2026/doombook.webp" %>" alt="Game Engine Black Book: DOOM" style="display:inline-block; min-width: 100px; max-width: 250px; width: 50%; float: right; margin-left: 0.5rem; margin-bottom: 0.5rem;" />
</a>

I've been reading [Fabien Sanglard's fabulous Game Engine Black Book: DOOM](https://fabiensanglard.net/gebbdoom/). What makes it such a joy is that it isn't only engine internals — mixed in is computer history, hardware, and the odd wacky anecdote.

To really follow it, I felt like I needed to write some code to grasp some of the concepts. Chief among them is rendering, which isn't real 3D. The geometry doesn't come from free-form meshes but rather a 2D map that's projected onto a 3D space.

If you've glanced through this post already, you'll have noticed the snippets are written in Ruby. Yes, that looks an unnatural choice for someone writing anything graphics related, and I can explain!

It's Ruby that compiles to native executables. Thanks to [Spinel](https://github.com/matz/spinel), the latest project from Ruby creator, Matz. Spinel parses Ruby, emits C, and then compiles the C to a native executable. The neat thing about Spinel is that you can use native libraries like SDL for graphics. I've been wanting to try Spinel for a while now, and it's been delightful. There are a few quirks and features of Ruby that are not available, but overall I'm surprised how well it just works.

### 2D to 2.5D

To make things easy, we think in 2D first. We define the world as a top-down map. For the purpose of this example we're just going to work with the player and a single wall. The player is situated using x, y coordinates, and there's an 'a' value which represents which way the player is facing.

```ruby
player = { x: 70, y: -110, z: 20, a: 0, l: 0 }

WALL_X  = 40
WALL_Y1 = 10
WALL_Y2 = 290

COS_TABLE = []
SIN_TABLE = []
for i in 0..360
  COS_TABLE[i] = Math.cos(i * Math::PI / 180)
  SIN_TABLE[i] = Math.sin(i * Math::PI / 180)
end
```

At start, the player is facing 0 degrees (north). We also have 'z' and 'l'; these you can think of as eye height and pitch, but that's 3D stuff that we get into later. In the code above you can see tables for cos and sin. These are precalculated so we can work in degrees e.g. we store player rotation in 0..360.


<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 440" style="margin: 0 auto; width: 400px;height: 400px; background: navy; display:block;">
  <line x1="10" y1="290" x2="10" y2="10" stroke="#ff0" stroke-width="2"></line>
  <circle cx="40" cy="410" r="4" fill="#0ff"></circle>
  <line x1="40" y1="410" x2="40" y2="395" stroke="#0ff" stroke-width="1.5" marker-end="url(#arrow)"></line>

  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="4" markerHeight="4" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#0ff"></path>
    </marker>
  </defs>
</svg>


This is the map with the player and the wall. The player is facing north (a=0). The wall is at (40,10) to (40,290).


### Step 1 - Player relative map space

In game, it feels like the player is moving around the world, but from a rendering perspective we're moving the world around the player.

One of the first things to do is figure out where the wall corners are relative to the player on the map.

```ruby
x1 = WALL_X - player[:x]
y1 = WALL_Y1 - player[:y]
x2 = WALL_X - player[:x]
y2 = WALL_Y2 - player[:y]
```

We're still in 2d space so you'll notice the x1 and x2 are the same value. The initial coordinates are set to `x1= 40-70 =-30` and `x2= 40-70 = -30`. As the player moves in the game, we'll update these values.

### Step 2 - Rotate the world around the player

_The mountain goes to Mohammed._

The player's angle also has a bearing on the wall's coordinates. As the player turns we rotate the world around the player. Multiplying by the cosine and sine of the player's angle gives us view specific coordinates. We store these in working arrays, wx and wy .

```ruby
# wx[0], wy[0]: first corner in view space (wx = side, wy = forward)
wx[0] = x1 * COS_TABLE[player[:a]] - y1 * SIN_TABLE[player[:a]]
wy[0] = y1 * COS_TABLE[player[:a]] + x1 * SIN_TABLE[player[:a]]

wx[1] = x2 * COS_TABLE[player[:a]] - y2 * SIN_TABLE[player[:a]]
wy[1] = y2 * COS_TABLE[player[:a]] + x2 * SIN_TABLE[player[:a]]
```

At the initial position, `y1 = 10 - (-110) = 120` and `y2 = 400`. With `a = 0` (cos is 1, sin is 0), `wx[0] = -30`, `wy[0] = 120`, `wx[1] = -30`, and `wy[1] = 400`. The rotation leaves these unchanged at 0 degrees.


<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 440" style="margin: 0 auto; width: 400px;height: 400px; background: navy; display:block;">
  <!-- wall: (-50, 112) to (-99, 388) -->
  <line x1="-50" y1="112" x2="-99" y2="388" stroke="#ff0" stroke-width="2"></line>

  <!-- player: (70,-110) -->
  <circle cx="40" cy="410" r="4" fill="#0ff"></circle>

  <!-- facing +Y (a=10) -->
  <line x1="40" y1="410" x2="40" y2="395" stroke="#0ff" stroke-width="1.5" marker-end="url(#arrow)"></line>

  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="4" markerHeight="4" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#0ff"></path>
    </marker>
  </defs>
</svg>


If the player was to rotate to 10 degrees, the coordinates would be transformed to approximately `wx[0], wy[0] = (-50, 112)` and `wx[1], wy[1] = (-99, 388)`.

So far so good, we have player relative map space, but we're still in 2d land.


### Step 3 - Calculate vertical position

In order to move into 3D land and project to the screen, we need some Z values. Rather like we did with the wall's X and Y coordinates, we start by calculating values that are based on the player's view.

```ruby
wz[0] = WALL_Z1 - player[:z] + ((player[:l] * wy[0]) / 32.0)
wz[1] = WALL_Z1 - player[:z] + ((player[:l] * wy[1]) / 32.0)
```

The first part of the calculation is determining the wall's Z value relative to the player's eye level. `WALL_Z1` is the bottom of the wall. Subtracting from the player's eye level `player[:z]` gives you the edge relative to the player's eye level.

The `wy` is used to represent depth. This value is multiplied by the player's pitch `player[:l]`. If we're looking straight ahead, `l` is 0 and there is no pitch correction. If we're looking up or down, the `wz` value is adjusted by `l`.

Further points (ie larger wy values) are affected more by pitch than closer points. The division by 32 is just a number to help control sensitivity of the pitch.


<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 440" style="margin: 0 auto; width: 400px;height: 400px; background: navy; display:block;">
  <line x1="-50" y1="112" x2="-99" y2="388" stroke="#ff0" stroke-width="2"></line>

  <line x1="40" y1="410" x2="40" y2="112" stroke="#0f0" stroke-width="1.5" stroke-dasharray="6,4"/>
  <text x="45" y="270" fill="#0f0" font-size="13" font-family="monospace">wy (depth)</text>

  <line x1="40" y1="410" x2="-50" y2="112" stroke="#f55" stroke-width="1.5" stroke-dasharray="6,4"/>

  <line x1="40" y1="112" x2="-50" y2="112" stroke="#ff0" stroke-width="1" stroke-dasharray="4,3"/>
  <text x="-15" y="105" fill="#ff0" font-size="13" font-family="monospace">wx</text>

  <circle cx="-50" cy="112" r="3" fill="#ff0"/>
  <circle cx="40" cy="410" r="4" fill="#0ff"></circle>
  <line x1="40" y1="410" x2="40" y2="395" stroke="#0ff" stroke-width="1.5" marker-end="url(#arrow)"></line>

  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="4" markerHeight="4" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#0ff"></path>
    </marker>
  </defs>
</svg>


One thing that sunk my understanding of this at first was thinking of depth as distance! Try to read it as how forward the point is along the player's view. In the diagram above this is the vertical line from the player.

### Step 4 - Perspective projection

<button type="button" class="italic link" data-desk-open="father-ted">This cow is small, those ones are far away.</button>

We now have the following values:

- wx tells us how far left or right of centre
- wy tells us how far in front (depth)
- wz tells us how far above or below the player's eye level

We now use all these values to calculate screen space coordinates.

```ruby
PROJECTION_SCALE = 200
sx0 = wx[0] * PROJECTION_SCALE / wy[0] + HALF_SW
sy0 = -wz[0] * PROJECTION_SCALE / wy[0] + HALF_SH

sx1 = wx[1] * PROJECTION_SCALE / wy[1] + HALF_SW
sy1 = -wz[1] * PROJECTION_SCALE / wy[1] + HALF_SH
```

You'll notice here we use a few other values, `PROJECTION_SCALE`, `HALF_SW` and `HALF_SH`. The `PROJECTION_SCALE` is a number that helps us control the perspective. `PROJECTION_SCALE` acts like focal length: larger values zoom in the view, whereas smaller values show more of the scene.

We negate `wz` when writing screen Y because the camera has Y-up (floor below the eye is negative) while the screen has Y-down (zero is the top of the window). Without that minus, the floor line would appear in the top half of the view.

The `HALF_SW` and `HALF_SH` values are half width and half height of the screen. This is used to shift the origin to the centre of the screen (rather than the top left corner).

The main thing that we are doing here is dividing X and Z values by depth. Points farther away are scaled down relative to depth, so they appear smaller and converge on the centre of the screen. This provides the perspective effect of far things looking smaller than close things.

We have now successfully moved from 2D map space to 3D view space! Here's how it looks:

![](<%= relative_url "/images/2026/one-line.png" %>)

So far it's just a single line, but if you can draw a single line, you can draw two. The only thing that's really different is the `wz` values. Put together it looks like this:

```ruby
wz0 = WALL_Z1 - player[:z] + ((player[:l] * wy0) / 32.0)
wz1 = WALL_Z1 - player[:z] + ((player[:l] * wy1) / 32.0)
wz2 = wz0 + (WALL_Z2 - WALL_Z1)
wz3 = wz1 + (WALL_Z2 - WALL_Z1)

sx0 = wx0 * PROJECTION_SCALE / wy0 + HALF_SW
sy0 = -wz0 * PROJECTION_SCALE / wy0 + HALF_SH
sx1 = wx1 * PROJECTION_SCALE / wy1 + HALF_SW
sy1 = -wz1 * PROJECTION_SCALE / wy1 + HALF_SH

sx2 = wx0 * PROJECTION_SCALE / wy0 + HALF_SW
sy2 = -wz2 * PROJECTION_SCALE / wy0 + HALF_SH
sx3 = wx1 * PROJECTION_SCALE / wy1 + HALF_SW
sy3 = -wz3 * PROJECTION_SCALE / wy1 + HALF_SH

draw_line(r, sx0, sx1, sy0, sy1)
draw_line(r, sx2, sx3, sy2, sy3)
```

And displays like this:

<video src="<%= relative_url "/images/2026/two-lines.webm" %>" style="width: 100%; height: auto;" preload="metadata" playsinline controls></video>

POST TODO:

- link to example.rb and mention that it has some issues e.g. divide by zero, no clipping
- cite / reference https://www.youtube.com/watch?v=huMO4VQEwPc&t=973s
-