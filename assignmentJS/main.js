// Elements
const username = document.getElementById("username");
const imageName = document.getElementById("imageName");
const fontSize = document.getElementById("fontSize");
const increaseFont = document.getElementById("increaseFont");
const decreaseFont = document.getElementById("decreaseFont");
const enlargeImage = document.getElementById("enlargeImage");
const clickBtn = document.getElementById("clickBtn");
const errorBox = document.getElementById("errorBox");
const output = document.getElementById("output");
const imageText = document.getElementById("imageText");
const displayImg = document.getElementById("displayImg");

// Constants
let currentFontSize = parseInt(fontSize.value);
const minFont = 10;
const maxFont = 40;

// Helper validation function
function validateInputs() {
  errorBox.innerText = "";

  // Validate username
  if (username.value.trim() === "") {
    errorBox.innerText = "Please enter your name.";
    return false;
  }

  // Validate image name
  const imgValue = imageName.value.trim();
  if (imgValue === "") {
    errorBox.innerText = "Please enter an image name.";
    return false;
  }

  const validExtensions = [".jpg", ".jpeg", ".png", ".gif"];
  if (!validExtensions.some(ext => imgValue.toLowerCase().endsWith(ext))) {
    errorBox.innerText = " Invalid image format. Allowed: jpg, jpeg, png, gif.";
    return false;
  }

  return true;
}

// Show welcome and image
function showContent() {
  if (validateInputs()) {
    output.innerText = `Welcome ${username.value}`;
    output.style.fontSize = currentFontSize + "px";

    imageText.innerText = `Image: ${imageName.value}`;
    imageText.style.fontSize = currentFontSize + "px";

   
    displayImg.src = imageName.value;
    displayImg.hidden = false;

   
    displayImg.onerror = () => {
      errorBox.innerText = " Image file not found in project folder.";
      displayImg.hidden = true;
    };
  }
}


clickBtn.addEventListener("click", showContent);

// Change font size select
fontSize.addEventListener("change", () => {
  currentFontSize = parseInt(fontSize.value);
  output.style.fontSize = currentFontSize + "px";
  imageText.style.fontSize = currentFontSize + "px";
});

// Increase font
increaseFont.addEventListener("click", () => {
  if (currentFontSize < maxFont) {
    currentFontSize += 2;
    output.style.fontSize = currentFontSize + "px";
    imageText.style.fontSize = currentFontSize + "px";
  } else {
    errorBox.innerText = "⚠️ Max font size reached (40px).";
  }
});

// Decrease font
decreaseFont.addEventListener("click", () => {
  if (currentFontSize > minFont) {
    currentFontSize -= 2;
    output.style.fontSize = currentFontSize + "px";
    imageText.style.fontSize = currentFontSize + "px";
  } else {
    errorBox.innerText = "⚠️ Min font size reached (10px).";
  }
});

// Enlarge image
enlargeImage.addEventListener("click", () => {
  if (validateInputs()) {
    let imgWidth = displayImg.width;
    if (imgWidth + 50 < window.innerWidth) {
      displayImg.width = imgWidth + 50;
    } else {
      errorBox.innerText = "⚠️ Cannot enlarge beyond window width.";
    }
  }
});
