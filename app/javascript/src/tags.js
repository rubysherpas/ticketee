window.addEventListener("DOMContentLoaded", () => {
  const tags = document.getElementsByClassName("tags");
  const removeEls = tags[0].getElementsByClassName("remove");


  for (let removeEl of removeEls) {
    removeEl.addEventListener("ajax:success", () => {
      removeEl.parentElement.remove();
    });
  }
});
