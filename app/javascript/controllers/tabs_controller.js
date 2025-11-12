import { Controller } from "@hotwired/stimulus"

// Controller para gerenciar o estado ativo das abas (tabs)
export default class extends Controller {
  static targets = ["tab"]

  connect() {
    // Define a aba ativa inicial (a primeira, se nenhuma estiver marcada)
    const activeTab = this.tabTargets.find(tab => tab.classList.contains("bg-white"))
    if (!activeTab && this.tabTargets.length > 0) {
      this.activate(this.tabTargets[0])
    }
  }

  activateTab(event) {
    event.preventDefault()

    const clickedTab = event.currentTarget

    // Remove o estado ativo de todas as abas
    this.tabTargets.forEach(tab => {
      tab.classList.remove("bg-white", "shadow", "text-purple-700", "font-semibold")
      tab.classList.add("hover:bg-white")
    })

    // Adiciona o estado ativo à aba clicada
    clickedTab.classList.add("bg-white", "shadow", "text-purple-700", "font-semibold")
    clickedTab.classList.remove("hover:bg-white")

    // Atualiza o conteúdo do turbo-frame
    const url = clickedTab.getAttribute("href")
    const frame = document.querySelector("turbo-frame#tab_content")
    if (frame) {
      frame.src = url
    }
  }

  activate(tab) {
    tab.classList.add("bg-white", "shadow", "text-purple-700", "font-semibold")
  }
}