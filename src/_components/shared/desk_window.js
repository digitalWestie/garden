const shells = () => document.querySelectorAll("[data-desk-window]")

function getParts(shell) {
  return {
    details: shell.querySelector(".desk-window"),
  }
}

function setActive(shell, { open = null, animate = true } = {}) {
  const { details } = getParts(shell)
  if (!details) return

  shell.dataset.userDismissed = "false"
  details.hidden = false

  if (open === true || open === false) {
    details.open = open
  }

  shell.classList.remove("is-inactive")

  if (animate) {
    shell.classList.remove("is-visible")
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        shell.classList.add("is-visible")
      })
    })
  } else {
    shell.classList.add("is-visible")
  }
}

function setInactive(shell) {
  const { details } = getParts(shell)
  if (!details) return

  shell.classList.remove("is-visible")
  shell.classList.add("is-inactive")
  details.open = false
  details.hidden = true
}

function dismissForGood(shell) {
  const { details } = getParts(shell)
  if (!details) return

  shell.dataset.userDismissed = "true"
  setInactive(shell)
}

function isPast(el, threshold) {
  if (!el) return false
  return el.getBoundingClientRect().top < window.innerHeight * threshold
}

function desiredScrollState(shell) {
  const threshold = Number(shell.dataset.threshold || 0.35)
  const persist = shell.hasAttribute("data-persist")
  const activateSelector = shell.dataset.activateAt
  const deactivateSelector = shell.dataset.deactivateAt
  const collapseBeforeSelector = shell.dataset.collapseBefore
  const collapseAfterSelector = shell.dataset.collapseAfter
  const activateEl = activateSelector ? document.querySelector(activateSelector) : null
  const deactivateEl = deactivateSelector ? document.querySelector(deactivateSelector) : null
  const collapseBeforeEl = collapseBeforeSelector
    ? document.querySelector(collapseBeforeSelector)
    : null
  const collapseAfterEl = collapseAfterSelector
    ? document.querySelector(collapseAfterSelector)
    : null

  let pastActivate = !activateSelector || isPast(activateEl, threshold)

  // persist: once past activate_at, stay active even if you scroll back up
  if (persist && (pastActivate || shell.dataset.latched === "true")) {
    shell.dataset.latched = "true"
    pastActivate = true
  }

  const pastDeactivate =
    persist || !deactivateSelector ? false : isPast(deactivateEl, threshold)

  let open = (shell.dataset.activateAs || "expanded") === "expanded"

  // Collapsed while still above collapse_before
  if (collapseBeforeSelector && !isPast(collapseBeforeEl, threshold)) {
    open = false
  }

  // Collapsed once past collapse_after
  if (collapseAfterSelector && isPast(collapseAfterEl, threshold)) {
    open = false
  }

  return {
    active: pastActivate && !pastDeactivate,
    open,
  }
}

function isVisiblyActive(shell) {
  const { details } = getParts(shell)
  if (!details) return false
  return !shell.classList.contains("is-inactive") && !details.hidden
}

function applyScrollState(shell) {
  if (!shell.hasAttribute("data-scroll-controlled")) return

  const next = desiredScrollState(shell)

  if (!next.active) {
    if (isVisiblyActive(shell) || !shell.classList.contains("is-inactive")) {
      // Don't revive a permanently closed window when leaving the range
      if (shell.dataset.userDismissed !== "true") {
        setInactive(shell)
      }
    }
    return
  }

  // Closed for good — ignore further scroll activation
  if (shell.dataset.userDismissed === "true") return

  if (!isVisiblyActive(shell)) {
    setActive(shell, { open: next.open, animate: true })
    return
  }

  const { details } = getParts(shell)
  if (details && details.open !== next.open) {
    details.open = next.open
  }
}

function syncAllScrollWindows() {
  shells().forEach(applyScrollState)
}

function openById(id, { animate = true } = {}) {
  if (!id) return
  const shell = document.querySelector(`[data-desk-window][data-desk-id="${CSS.escape(id)}"]`)
  if (!shell) return

  shell.dataset.userDismissed = "false"
  if (shell.hasAttribute("data-persist")) {
    shell.dataset.latched = "true"
  }

  const open = (shell.dataset.activateAs || "expanded") === "expanded"
  setActive(shell, { open, animate })
}

document.addEventListener("click", (event) => {
  const closeBtn = event.target.closest(".desk-window-close")
  if (closeBtn) {
    event.preventDefault()
    event.stopPropagation()
    const shell = closeBtn.closest("[data-desk-window]")
    if (shell) dismissForGood(shell)
    return
  }

  const trigger = event.target.closest("[data-desk-open]")
  if (trigger) {
    event.preventDefault()
    openById(trigger.getAttribute("data-desk-open"))
  }
})

document.addEventListener(
  "mousedown",
  (event) => {
    if (event.target.closest(".desk-window-close")) {
      event.preventDefault()
      event.stopPropagation()
    }
  },
  true
)

let ticking = false
function onScrollOrResize() {
  if (ticking) return
  ticking = true
  requestAnimationFrame(() => {
    syncAllScrollWindows()
    ticking = false
  })
}

window.addEventListener("scroll", onScrollOrResize, { passive: true })
window.addEventListener("resize", onScrollOrResize)

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", syncAllScrollWindows)
} else {
  syncAllScrollWindows()
}
