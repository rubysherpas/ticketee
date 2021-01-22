const Dropzone = require("dropzone");
import "dropzone/dist/dropzone.css";

Dropzone.autoDiscover = false;

document.addEventListener("turbolinks:load", () => {
  const uploader = document.querySelector(".uploader");
  if (uploader) {
    const appendAttachment = (signedId) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "attachments[]";
      input.value = signedId;
      uploader.parentElement.append(input);
    };

    const csrfTokenTag = document.querySelector('meta[name="csrf-token"]');
    const csrfToken = csrfTokenTag && csrfTokenTag["content"];

    let headers;
    if (csrfToken) {
      headers = {
        "X-CSRF-TOKEN": csrfToken,
      };
    } else {
      headers = {};
    }

    var myDropzone = new Dropzone(".uploader", {
      url: uploader.dataset.url,
      headers: headers,
    });

    myDropzone.on("success", (file, response) => {
      appendAttachment(response.signedId);
    });

     myDropzone.on("addedfile", function (file, xhr, formData) {
        var submit = document.querySelector("input[type=submit]");
        submit.disabled = true;
    });

    myDropzone.on("queuecomplete", function ( ) {
        var submit = document.querySelector("input[type=submit]");
        submit.disabled = false;
    });

  }
});
