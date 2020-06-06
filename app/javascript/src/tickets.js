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

    const savedAttachments = document.querySelectorAll(".saved-attachment");
    for (const attachment of savedAttachments) {
      const details = JSON.parse(attachment.value);
      let mockFile = { name: details.name, size: details.size };
      myDropzone.displayExistingFile(mockFile, details.path);
      appendAttachment(details.signedId);
    }

    myDropzone.on("success", (file, response) => {
      appendAttachment(response.signedId);
    });
  }
});
