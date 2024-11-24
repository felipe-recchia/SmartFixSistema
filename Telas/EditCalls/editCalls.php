<?php
$dsn = 'mysql:host=localhost;dbname=smart_fix';
$usuario = 'root';
$senha = '';

try {
    $conexao = new PDO($dsn, $usuario, $senha);


    // Corrigindo a query SQL com concatenação adequada e espaços apropriados
    $query = "SELECT " 
        . "chamado.cha_id, "
        . "chamado.cha_dt_inicio, "
        . "classificacao.cla_nome AS classificacao, "
        . "itens.itm_nome AS item, "
        . "chamado.cha_assunto, "
        . "maquina.maq_num AS maquina, "
        . "sala.sl_num AS sala, "
        . "bloco.bl_nome AS bloco, "
        . "chamado.cha_desc, "
        . "chamado.cha_sit, "
        . "chamado.cha_dt_fim, "
        . "chamado.cha_notes "
        . "FROM tb_chamado chamado "
        . "JOIN tb_classificacao classificacao ON chamado.cla_id = classificacao.cla_id "
        . "JOIN tb_itens itens ON chamado.itm_id = itens.itm_id "
        . "JOIN tb_maquina maquina ON chamado.maq_id = maquina.maq_id "
        . "JOIN tb_sala sala ON chamado.sl_id = sala.sl_id "
        . "JOIN tb_bloco bloco ON chamado.bl_id = bloco.bl_id "
        . "WHERE chamado.cha_id = 1";

    $retorno = $conexao->query($query);
    
    $resultados = $retorno->fetchAll(PDO::FETCH_OBJ);
    
    // Exibe os resultados como JSON
    echo json_encode($resultados);    

} catch (PDOException $erro) {
    echo 'Erro DE CONEXÃO: ' . $erro->getMessage();
}
?>
