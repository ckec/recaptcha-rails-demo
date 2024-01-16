import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { siteKey: String }

  initialize() {
    // Google reCAPTCHA rendering code
    window.onloadCallback = () => {
      grecaptcha.render("recaptchaV2", { sitekey: this.siteKeyValue });
    };

    // Load reCAPTCHA API script with onloadCallback
    const script = document.createElement('script');
    script.src = 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit';
    script.async = true;
    document.head.appendChild(script);
  }
}