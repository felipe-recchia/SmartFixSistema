//LeonardoSarruf - 02/11/2024 - script.js externo//
document.addEventListener("DOMContentLoaded", function () {
    //Aciona ao carregar a pagina
    fetch("../../Components/sidebar.html") //busca o arquivo sidebar.html
        .then((response) => response.text()) //resposta do fetch armazena em texto (nao usado)
        .then((data) => {
            document.getElementById("sidebar-container").innerHTML = data; //busca o container e coloca a data da resposta nele (sidebar)
            document
                .getElementById("sidebar") //evento de animação da sidebar
                .addEventListener("click", function () {
                    this.classList.toggle("collapsed");
                    document
                        .getElementById("mainContent")
                        .classList.toggle("expanded");
                })
                .catch((error) =>
                    console.error("Erro ao carregar a sidebar:", error)
                );
        });
});
