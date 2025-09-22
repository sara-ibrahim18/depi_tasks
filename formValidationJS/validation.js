const form = document.getElementById("register-form");

// Function to show message
function showMessage(eleId, msg, type){
  const element = document.getElementById(eleId);
  element.innerText = msg;
  element.className = type === "success" ? "msg-error success" : "msg-error error";
}

// Validate functions
function validateName(){
  const name = form["name"].value.trim();
  if(name === ""){
    showMessage("name-error", "Name is required", "error");
    return false;
  }else if(!/^[a-zA-Z ]{3,30}$/.test(name)){
    showMessage("name-error", "Name must be 3-30 letters only", "error");
    return false;
  }else{
    showMessage("name-error", "Valid name ✔", "success");
    return true;
  }
}

function validateEmail(){
  const email = form["email"].value.trim();
  if(email === ""){
    showMessage("email-error", "Email is required", "error");
    return false;
  }else if(!/^[a-zA-Z][a-zA-Z0-9._]*@[a-zA-Z]+\.[a-z]{2,}$/.test(email)){
    showMessage("email-error", "Invalid email format", "error");
    return false;
  }else{
    showMessage("email-error", "Valid email ✔", "success");
    return true;
  }
}

function validatePassword(){
  const password = form["password"].value;
  if(password === ""){
    showMessage("password-error", "Password is required", "error");
    return false;
  }else if(password.length < 6){
    showMessage("password-error", "Password must be at least 6 characters", "error");
    return false;
  }else{
    showMessage("password-error", "Strong password ✔", "success");
    return true;
  }
}

function validateConfirmPassword(){
  const password = form["password"].value;
  const confirmPassword = form["confirm-password"].value;
  if(confirmPassword === ""){
    showMessage("confirm-error", "Confirm password is required", "error");
    return false;
  }else if(confirmPassword !== password){
    showMessage("confirm-error", "Passwords do not match", "error");
    return false;
  }else{
    showMessage("confirm-error", "Passwords match ✔", "success");
    return true;
  }
}

function validatePhone(){
  const phone = form["phone"].value.trim();
  if(phone === ""){
    showMessage("phone-error", "Phone number is required", "error");
    return false;
  }else if(!/^[0-9]{10,11}$/.test(phone)){
    showMessage("phone-error", "Phone must be 10-11 digits", "error");
    return false;
  }else{
    showMessage("phone-error", "Valid phone ✔", "success");
    return true;
  }
}

// Attach live validation
form["name"].addEventListener("input", validateName);
form["email"].addEventListener("input", validateEmail);
form["password"].addEventListener("input", validatePassword);
form["confirm-password"].addEventListener("input", validateConfirmPassword);
form["phone"].addEventListener("input", validatePhone);

// Final check on submit
form.onsubmit = function(e){
  e.preventDefault();
  let valid = true;
  if(!validateName()) valid = false;
  if(!validateEmail()) valid = false;
  if(!validatePassword()) valid = false;
  if(!validateConfirmPassword()) valid = false;
  if(!validatePhone()) valid = false;

  if(valid){
    alert("Form submitted successfully!");
    form.submit();
  }
}
