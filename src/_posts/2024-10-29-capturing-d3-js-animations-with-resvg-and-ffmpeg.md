---
title: Saving D3.js animations as video files with WebAssembly
slug: capturing-d3-js-animations-with-resvg-and-ffmpeg
createdAt: 2024-10-29 14:36:15.000000000 Z
updatedAt: 2024-10-29 18:04:33.000000000 Z
publishedAt: 2024-10-29 17:28:57.000000000 Z
FeatureImage: "/images/2024/10/Zeichenfla-che-1-1500x880-1.png"
date: 2024-10-29 17:28:57 UTC
layout: post
categories: creating-with-data
---

Browsers are more powerful than ever! Non-browser software can be compiled to WebAssembly and used client-side. WebAssembly or 'WASM' acts as a bridge, allowing code written in languages like Rust, C, and C++ to execute smoothly in the browser.

In my [SuperMap.world](https://supermap.world/) side-project I'm using D3 to generatively create lots of map designs in PNG and SVG formats. To up the challenge, I've been considering adding map animations using [d3-transition](https://d3js.org/d3-transition).

![](<%= relative_url "/images/2024/10/map.gif" %>)

The only problem is compiling video can be a pretty heavy operation (certainly for servers on a side-project budget). Thanks to WebAssembly, we can now get those lazy freeloading clients to do some of the work.

To tip my toe in the water, I've been experimenting with [Resvg](https://github.com/yisibl/resvg-js) and [FFmpeg](https://ffmpegwasm.netlify.app/) (compiled to WASM) to see if I can capture D3.js transitions and render them out to Gif, MP4, or whatever format – no servers req _uired!_

_Before you ask – yes, I know that rendering to Webcanvas in a raster format then capturing with FFmpeg makes more sense but I have my reasons which I cannot be bothered to explain right now._

### Capturing PNG with Resvg

Resvg is a powerful tool for rendering and working with SVGs. I've been using Resvg to convert SVG to PNG from the command line and it does a great job. The plan here is to use it to capture frames that will eventually be compiled into a video.

If you want to try it out on its own all you need to do is import and write a capture function e.g.

```HTML
<script src="https://unpkg.com/@resvg/resvg-wasm"></script>
```

```Javascript
async function captureSvg() {
    // Initialize Resvg WASM
    await resvg.initWasm(
        fetch('https://unpkg.com/@resvg/resvg-wasm/index_bg.wasm')
    );

    // Get the SVG element and convert to string
    const svgElement = document.getElementById('mySvg');
    const svgString = new XMLSerializer().serializeToString(svgElement);

    // Create Resvg instance
    const resvgJS = new resvg.Resvg(svgString);

    // Render to PNG
    const pngData = resvgJS.render();
    const pngBuffer = pngData.asPng();

    // Create blob and download link
    const blob = new Blob([pngBuffer], { type: 'image/png' });
    const url = URL.createObjectURL(blob);

    // Create download link
    const a = document.createElement('a');
    a.href = url;
    a.download = 'capture.png';
    a.textContent = 'Download PNG';
    document.body.appendChild(a);
}
```

As you'll see above it goes and fetches a .wasm file. Sometimes these files can be quite large – FFmpeg is about 30MB!

In the above example we get a PNG version of the SVG and a download link. We don't want to download a single PNG, but the above is a concise SVG to PNG convert function (NB if you want text rendered correctly you'll need to hand that to Resvg).

### Combining D3 + Resvg + FFmpeg

What we want to do is a little different: capture a PNG every time something changes, (e.g. inside a D3 tween function), hand that PNG over to FFmpeg to use as a frame in the video. Once we're done animating we compile and offer the MP4 up for download.

![](<%= relative_url "/images/2024/10/image.png" %>)

This example animates a simple SVG circle and captures each frame. Here's the code for [this example (available on Glitch)](https://creating-with-data.glitch.me/connecting-atlantic-ani/simple.html):

```HTML
<!DOCTYPE html>
<html>
<head>
  <script src="https://d3js.org/d3.v7.min.js"></script>
  <script src="https://unpkg.com/@resvg/resvg-wasm"></script>
  <script src="./assets/ffmpeg/package/dist/umd/ffmpeg.js"></script>
  <script src="./assets/util/package/dist/umd/index.js"></script>
</head>
<body>
  <svg id="animation" width="400" height="200"></svg>
<script>
const { FFmpeg } = FFmpegWASM;

// Setup constants and initialization
const FRAME_RATE = 12;
let ffmpeg = null;

// Initialize capture system
async function initCapture() {
  // Initialize Resvg
  await resvg.initWasm(fetch('https://unpkg.com/@resvg/resvg-wasm/index_bg.wasm'));

  // Initialize FFmpeg
  const ffmpeg = new FFmpeg();
  ffmpeg.on("log", ({ message }) => {
    console.log(message);
  })
  ffmpeg.on("progress", ({ progress }) => {
    console.log(`${progress * 100} %`);
  });

  console.log("Loading ffmpeg wasm")
  await ffmpeg.load({
    wasmURL: "https://cdn.glitch.me/4877c24f-4232-45d4-9767-d4c67608b8ed/ffmpeg-core.wasm?v=1730219929011",
    coreURL: "https://creating-with-data.glitch.me/connecting-atlantic-ani/assets/core/package/dist/umd/ffmpeg-core.js"
  });
  console.log("Done.")
  return ffmpeg;
}

// Frame capture function
let frameCount = 0;
let captureQueue = Promise.resolve();
async function captureFrame(svgString) {
  captureQueue = captureQueue.then(async () => {
    const resvgJS = new resvg.Resvg(svgString);
    const pngData = resvgJS.render();
    const pngBuffer = pngData.asPng();

    const filename = `frame_${frameCount.toString().padStart(5, '0')}.png`;
    console.log(`Capturing ${filename}`)
    await ffmpeg.writeFile(filename, pngBuffer);
    frameCount++;
  });
  return captureQueue;
}

// Animation with capture
async function animateAndCapture() {
  ffmpeg = await initCapture();

  // Setup SVG
  const svg = d3.select("#animation");
  const circle = svg.append("circle")
    .attr("cx", 50)
    .attr("cy", 100)
    .attr("r", 20)
    .style("fill", "blue");

  // Create transition
  const duration = 2000; // 2 seconds

  await circle.transition()
    .duration(duration)
    .attr("cx", 350)
    .style("fill", "red")
    .tween("capture", () => {
      return async (t) => {
        // Get current state of SVG
        const svgString = new XMLSerializer()
          .serializeToString(svg.node());
        await captureFrame(svgString);
      };
    })
    .end(); // Wait for transition to complete

  // Create video from frames
  await createVideo(ffmpeg);
}

// Create video from captured frames
async function createVideo(ffmpeg) {
  await ffmpeg.exec([
    '-framerate', FRAME_RATE.toString(),
    '-i', 'frame_%05d.png',
    '-c:v', 'libx264',
    '-pix_fmt', 'yuv420p',
    'output.mp4'
  ]);

  // Create download link
  const data = await ffmpeg.readFile('output.mp4');
  const videoBlob = new Blob([data.buffer], { type: 'video/mp4' });
  const videoUrl = URL.createObjectURL(videoBlob);

  const downloadLink = document.createElement('a');
  downloadLink.href = videoUrl;
  downloadLink.download = 'animation.mp4';
  downloadLink.textContent = 'Download Animation';
  document.body.appendChild(downloadLink);
}

// Start animation when page loads
document.addEventListener('DOMContentLoaded', animateAndCapture);
</script>
</body>
</html>
```

### Result

0:00

/

1×

### The capture queue

The real magic here happens in the `captureFrame` function. We want to write multiple frames to FFmpeg's internal file handler, as a sequentially numbered file (e.g., `frame_00000.png`, `frame_00001.png`).

We use `captureQueue` to manage asynchronous frame capturing. Chaining frames in a promise queue ensures each frame finishes processing before moving to the next.

This approach resolved an issue where D3’s tween function wasn’t running synchronously, leading to duplicated or misordered frames.

```Javascript
// Frame capture function
let frameCount = 0;
let captureQueue = Promise.resolve();
async function captureFrame(svgString) {
  captureQueue = captureQueue.then(async () => {
    const resvgJS = new resvg.Resvg(svgString);
    const pngData = resvgJS.render();
    const pngBuffer = pngData.asPng();

    const filename = `frame_${frameCount.toString().padStart(5, '0')}.png`;
    console.log(`Capturing ${filename}`)
    await ffmpeg.writeFile(filename, pngBuffer);
    frameCount++;
  });
  return captureQueue;
}

```

Using `captureFrame` is simple. We just call it whenever we want to add a frame, such as in a d3 tween function.

### Frame rates

When it comes to D3, it's not possible to dictate frame rate. From what I understand, D3 will aim to go as fast as supported by your browser. That's not always possible if you have complex transitions going on. As a result, the frame rate you tell FFmpeg to use may not match what's happening in the browser. I imagine you could track your animation's FPS yourself and pass that to over to FFmpeg at compile time.

The GIF I rendered of the transatlantic cable visualisation has a lot more going on than the circle animation. It came out at about 6 or 7 FPS. That's fine for a GIF but not what you'd want from a "real" video.

![](<%= relative_url "/images/2024/10/map.gif" %>)A Gif version of the [telegraph cable visualisation](<%= url_for("_posts/2023-07-12-dataviz-connecting-the-atlantic.md") %>)

Since these transitions use an interpolator I was able to render higher FPS videos by dropping D3 tweens in favour of just capturing renders inside a for loop –

```
// Use this  ...
const framesPerMillisecond = FRAME_RATE / 1000;
const frames = positionDuration * framesPerMillisecond;
for (let i = 0; i < frames; i++) {
  positionTween(i / frames, ip, sphere, land);
}

//Instead of ...
d3.transition().duration(positionDuration).tween("render", () => {
  return t => {
    positionTween(t, ip, sphere, land);
  }
}).end();
```

While my browser wasn't able to keep up (i.e. we can't watch the nice animation) it does succesfully produce a smoother video!

0:00

/

1×
