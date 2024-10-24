<?php
// Configurações de conexão com o banco de dados
class Conexao 
{       
    private $host = '127.0.0.1';  
    private $dbname = 'smart_fix';
    private $usuario = 'root';  // Use o nome de usuário do MySQL, o padrão no XAMPP é 'root'
    private $senha = '';  // Deixe em branco se não houver senha no MySQL

    public function conectar()
    {
        try 
        {
            $conexao = new PDO(
                "mysql:host=$this->host;dbname=$this->dbname;charset=utf8",
                $this->usuario,
                $this->senha
            );
            // Definindo o modo de erro do PDO para exceções
            $conexao->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $conexao;
            
        } 
        catch (PDOException $erro) 
        {
            echo '<p>Erro de conexão: '.$erro->getMessage().'</p>';
        }
    }
}

// Obtém os dados do formulário e verifica se estão presentes

$Senha = $_POST['password'] ?? null;
$Nome = $_POST['username'] ?? null;


// echo '<br/>' .$bl_nome;
// echo '<br/>' .$cla_nome;

if ($usuario && $senha) {
// Instancia a conexão
$conexao = (new Conexao())->conectar();

// Prepara a consulta SQL para inserir os dados
$sql = "CALL LOGIN(?, ?)";

// Prepara a execução do SQL
$stmt = $conexao->prepare($sql);

// Executa a consulta com os parâmetros
$executado = $stmt->execute([
    $Senha,
    $Nome,
]);

// Verifica se foi executado com sucesso
if ($stmt->rowCount() > 0) {
    echo json_encode(['sucesso' => true]);
} else {
    echo json_encode(['erro' => 'Usuário ou senha incorretos.']);
}
}else{
    echo json_encode(['erro' => 'Preencha todos os campos.']);
}


// Fecha a conexão (opcional, pois o PHP fecha automaticamente ao final do script)
$conexao = null;
?>
