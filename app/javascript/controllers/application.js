import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// DOMの読み込み完了後に実行
document.addEventListener('DOMContentLoaded', () => {
 
  const spMenuBtn = document.getElementById("spMenuBtn");
  
  
  const headerInner = document.getElementById("headerInner");

 
  console.log(spMenuBtn, headerInner);

  
  if (spMenuBtn && headerInner) {
    spMenuBtn.addEventListener("click", () => {
     
      headerInner.classList.toggle("active");
    });
  }
});

export { application }