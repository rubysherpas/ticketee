window.addEventListener("DOMContentLoaded", () => {
  const removeEls = document.getElementsByClassName("remove");

  for (let removeEl of removeEls) {
    removeEl.addEventListener("ajax:success", (test) => {
      removeEl.parentElement.remove();
    });
  }
});
