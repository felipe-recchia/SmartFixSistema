document.addEventListener("DOMContentLoaded", function () {
    fetch("../../Components/sidebar.html")
        .then((response) => response.text())
        .then((data) => {
            document.getElementById("sidebar-container").innerHTML = data;
            document.getElementById("sidebar").addEventListener("click", function (event) {
                // Verifica se o clique foi em um item de menu diferente do Cadastro
                if (!event.target.closest("#cadastro-toggle")) {
                    this.classList.toggle("collapsed");
                    document.getElementById("mainContent").classList.toggle("expanded");
                }
            });

            document.getElementById("cadastro-toggle").addEventListener("click", function () {
                const submenu = document.getElementById("submenu");
                submenu.classList.toggle("show");
                const dropdownIcon = document.getElementById("dropdown-icon");
                dropdownIcon.classList.toggle("fa-chevron-up");
                dropdownIcon.classList.toggle("fa-chevron-down");
            });
        })
        .catch((error) => console.error("Erro ao carregar a sidebar:", error));
});
