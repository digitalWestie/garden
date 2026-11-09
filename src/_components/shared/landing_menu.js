function initLandingMenu() {
  const menu = document.querySelector("details.landing-menu")
  if (!(menu instanceof HTMLDetailsElement)) return

  const summary = menu.querySelector("summary")

  document.addEventListener("click", (event) => {
    if (!menu.open) return
    if (menu.contains(event.target)) return
    menu.open = false
  })

  document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape" || !menu.open) return
    menu.open = false
    summary?.focus()
  })
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initLandingMenu, { once: true })
} else {
  initLandingMenu()
}
