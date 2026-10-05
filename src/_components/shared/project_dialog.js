function openProjectDialog(id) {
  const dialog = document.getElementById(id)
  if (!(dialog instanceof HTMLDialogElement)) return
  if (typeof dialog.showModal === "function") {
    dialog.showModal()
  } else {
    dialog.setAttribute("open", "")
  }
}

function closeOnBackdropClick(event) {
  const dialog = event.currentTarget
  if (!(dialog instanceof HTMLDialogElement)) return
  if (event.target === dialog) {
    dialog.close()
  }
}

function initProjectDialogs() {
  document.querySelectorAll("[data-project-dialog-open]").forEach((trigger) => {
    trigger.addEventListener("click", (event) => {
      event.preventDefault()
      const id = trigger.getAttribute("data-project-dialog-open")
      if (id) openProjectDialog(id)
    })
  })

  document.querySelectorAll("dialog.project-dialog").forEach((dialog) => {
    dialog.addEventListener("click", closeOnBackdropClick)
  })
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initProjectDialogs)
} else {
  initProjectDialogs()
}
