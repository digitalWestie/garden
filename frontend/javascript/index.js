import "$styles/index.css"
import "$styles/syntax-highlighting.css"

// Import all JavaScript & CSS files from src/_components
import components from "$components/**/*.{js,jsx,js.rb,css}"

// Keep component modules (and their side effects) in the bundle.
void components

console.info("Bridgetown is loaded!")
