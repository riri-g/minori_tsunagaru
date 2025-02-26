import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// DOMの読み込み完了後に実行
document.addEventListener('DOMContentLoaded', () => {
  // スマホ・タブレットサイズ時のみ表示されるメニューの開閉ボタンを変数に格納。
  const spMenuBtn = document.getElementById("spMenuBtn");
  
  // メニューや開閉ボタンをラップしている要素を変数に格納。
  const headerInner = document.getElementById("headerInner");

  // 要素が取得できているか確認
  console.log(spMenuBtn, headerInner);

  // spMenuBtnが存在する場合のみイベントを設定
  if (spMenuBtn && headerInner) {
    spMenuBtn.addEventListener("click", () => {
      // ラップ要素にactiveというクラスを付与する。
      headerInner.classList.toggle("active");
    });
  }
});

export { application }