import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// スマホ・タブレットサイズ時のみ表示されるメニューの開閉ボタンを変数に格納。
const spMenuBtn = document.getElementById("spMenuBtn");

// メニューや開閉ボタンをラップしている要素を変数に格納。
const headerInner = document.getElementById("headerInner");

// 開閉ボタンをクリックすると発火。
spMenuBtn.addEventListener("click", () => {
  // ラップ要素にactiveというクラスを付与する。
  headerInner.classList.toggle("active");
});


export { application }

