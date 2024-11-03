<?php
include_once '../../ConectionString/conectionString.php'; //import da conectionString

$conexao = new Conexao(); //busca a classe de conexao
$conn = $conexao->conectar(); //conecta

if ($conn) {
    $Y = $_POST[''] ?? null;
    $X = $_POST[''] ?? null;

    // echo '<br/>' .$bl_nome;
    // echo '<br/>' .$cla_nome;

        // Prepara a consulta SQL para inserir os dados
        $sql = "CALL PROCEDURE(?, ?)";

        // Prepara a execução do SQL
        $stmt = $conn->prepare($sql);

        // Executa a consulta com os parâmetros
        $executado = $stmt->execute([
            $Y,
            $X,
        ]);

}else{
    echo "Falha ao conectar com o banco de dados.";
}
?>
