import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(e) {
    e.preventDefault()
    const time = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, time)
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(e) {
    e.preventDefault()
    const wrapper = e.target.closest('.gas-station-product-fields')
    if (this.containerTarget.querySelectorAll('.gas-station-product-fields').length > 1) {
      wrapper.remove()
    }
  }
}
