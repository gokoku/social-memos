document.addEventListener('turbo:load', () => {
  const flashMessage = document.querySelector('.alert')
  if(flashMessage !== null) {
    flashMessage.classList.add('fadeOut')
    setTimeout(() => {
      flashMessage.computedStyleMap.display = "none"
    }, 5000)
  }
})

