// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./add_jquery"
import 'flowbite'
import "flowbite/dist/flowbite.turbo.js"
import "@fortawesome/fontawesome-free/js/all"

function hamburger() {
  const burger = document.querySelectorAll('.navbar-burger');
  const menu = document.querySelectorAll('.navbar-menu');

  if (burger.length && menu.length) {
    for (var i = 0; i < burger.length; i++) {
      burger[i].addEventListener('click', function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle('hidden');
        }
      });
    }
  }

  // close
  const close = document.querySelectorAll('.navbar-close');
  const backdrop = document.querySelectorAll('.navbar-backdrop');

  if (close.length) {
    for (var i = 0; i < close.length; i++) {
      close[i].addEventListener('click', function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle('hidden');
        }
      });
    }
  }

  if (backdrop.length) {
    for (var i = 0; i < backdrop.length; i++) {
      backdrop[i].addEventListener('click', function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle('hidden');
        }
      });
    }
  }
}

// When the user scrolls down 20px from the top of the document, show the button

const scrollFunction = () => {
  if (
    document.body.scrollTop > 20 ||
    document.documentElement.scrollTop > 20
  ) {
    mybutton.classList.remove("hidden");
  } else {
    mybutton.classList.add("hidden");
  }
};

const backToTop = () => {
  window.scrollTo({ top: 0, behavior: "smooth" });
};

$(document).on('turbo:load', function() {
  hamburger()
  scrollFunction()
  backToTop()
  todo_button()
})

// Get the button
const mybutton = document.getElementById("btn-back-to-top");

// When the user clicks on the button, scroll to the top of the document
mybutton.addEventListener("click", backToTop);

window.addEventListener("scroll", scrollFunction);

function todo_button() {
  const dropdownButton = document.querySelector("#dropdown");
  const dropdownButton2 = document.querySelector("#dropdown2");
  const dropdownList = document.querySelector("#dropdown + div.hidden");

  if (dropdownButton) {
    dropdownButton.addEventListener("click", () => {
      if (dropdownList.classList.toggle("hidden") === false) {
        dropdownButton.innerHTML = 'Hide'
      } else {
        dropdownButton.innerHTML = 'Show'
      }
    });
  }

  if (dropdownButton2) {
    dropdownButton2.addEventListener("click", () => {
      dropdownList.classList.toggle("hidden");
      if (dropdownButton.innerHTML === 'Show') {
        dropdownButton.innerHTML = 'Hide'
      } else {
        dropdownButton.innerHTML = 'Show'
      }
    });
  }
}
