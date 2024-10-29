<?php
// Arquivo: index.php

// Simulação de dados para o dashboard
class DashboardData {
    public static function getStatusCounts() {
        return [
            'total' => 480,
            'abertos' => 45,
            'resolvidos' => 425,
            'tempo_medio' => '3.5h'
        ];
    }

    public static function getChartData() {
        return [
            ['mes' => 'Jan', 'total' => 65],
            ['mes' => 'Fev', 'total' => 75],
            ['mes' => 'Mar', 'total' => 85],
            ['mes' => 'Abr', 'total' => 70],
            ['mes' => 'Mai', 'total' => 90],
            ['mes' => 'Jun', 'total' => 95]
        ];
    }

    public static function getLatestTickets() {
        return [
            [
                'id' => '#1234',
                'cliente' => 'João Silva',
                'titulo' => 'Falha no Sistema',
                'status' => 'Resolvido',
                'prioridade' => 'Alta',
                'data' => '2024-10-28'
            ],
            [
                'id' => '#1235',
                'cliente' => 'Maria Santos',
                'titulo' => 'Erro de Login',
                'status' => 'Em Progresso',
                'prioridade' => 'Média',
                'data' => '2024-10-28'
            ],
            [
                'id' => '#1236',
                'cliente' => 'Pedro Costa',
                'titulo' => 'Atualização',
                'status' => 'Aberto',
                'prioridade' => 'Baixa',
                'data' => '2024-10-27'
            ],
            [
                'id' => '#1237',
                'cliente' => 'Ana Oliveira',
                'titulo' => 'Problema de Rede',
                'status' => 'Em Progresso',
                'prioridade' => 'Alta',
                'data' => '2024-10-27'
            ],
            [
                'id' => '#1238',
                'cliente' => 'Carlos Mendes',
                'titulo' => 'Bug no Relatório',
                'status' => 'Aberto',
                'prioridade' => 'Média',
                'data' => '2024-10-26'
            ]
        ];
    }
}

// Obtendo dados para o dashboard
$statusCounts = DashboardData::getStatusCounts();
$chartData = DashboardData::getChartData();
$latestTickets = DashboardData::getLatestTickets();

// Função auxiliar para gerar classes de status
function getStatusClass($status) {
    switch ($status) {
        case 'Resolvido':
            return 'success';
        case 'Em Progresso':
            return 'warning';
        case 'Aberto':
            return 'danger';
        default:
            return 'default';
    }
}

// Função auxiliar para gerar classes de prioridade
function getPriorityClass($priority) {
    switch ($priority) {
        case 'Alta':
            return 'danger';
        case 'Média':
            return 'warning';
        case 'Baixa':
            return 'success';
        default:
            return 'default';
    }
}

?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Chamados</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Reset e Variáveis */
        :root {
            --primary-color: #4F46E5;
            --secondary-color: #6B7280;
            --success-color: #10B981;
            --warning-color: #F59E0B;
            --danger-color: #EF4444;
            --light-bg: #F3F4F6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: var(--light-bg);
        }

        /* Container Principal */
        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 200px;
            background-color: #1F2937;
            color: white;
            position: fixed;
            height: 100vh;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .sidebar.collapsed {
            width: 50px;
        }

        .sidebar-header {
            padding: 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .menu-item {
            padding: 1rem;
            display: flex;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .menu-item:hover {
            background-color: rgba(255,255,255,0.1);
        }

        .menu-item i {
            width: 20px;
            margin-right: 1rem;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        .main-content.expanded {
            margin-left: 60px;
        }

        /* Header */
        .header {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
        }

        /* Tabela */
        .table-container {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #E5E7EB;
        }

        .table th {
            background-color: #F9FAFB;
            font-weight: 600;
            color: var(--secondary-color);
        }

        /* Status e Prioridade Badges */
        .badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge.success {
            background-color: #ECFDF5;
            color: var(--success-color);
        }

        .badge.warning {
            background-color: #FEF3C7;
            color: var(--warning-color);
        }

        .badge.danger {
            background-color: #FEE2E2;
            color: var(--danger-color);
        }

        /* Responsividade */
        @media (max-width: 768px) {
            .sidebar {
                width: 50px;
            }

            .sidebar:hover {
                width: 200px;
            }

            .main-content {
                margin-left: 50px;
                padding: 1rem;
            }

            .cards-grid {
                grid-template-columns: 1fr;
            }

            .table-container {
                overflow-x: auto;
            }
        }

        @media (max-width: 480px) {
            .header {
                flex-direction: column;
                align-items: stretch;
            }

            .search-bar input {
                width: 100%;
            }
        }

        img{
            width: 66%;
            height: auto;
            background-color: white;
            border-radius: 20px;
            margin-left: 20px;            
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <img src="Logo.png" alt="Logo">
            </div>
            <div class="menu-item">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-ticket-alt"></i>
                <span>Chamados</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-users"></i>
                <span>Usuários</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-chart-bar"></i>
                <span>Relatórios</span>
            </div>
            <div class="menu-item">
                <i class="fas fa-cog"></i>
                <span>Configurações</span>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Header -->
            <div class="header">
                <h1>Dashboard</h1>
                <div class="search-bar">
                    <input type="text" placeholder="Buscar chamados...">
                </div>
            </div>

            <!-- Cards -->
            <div class="cards-grid">
                <div class="card">
                    <div class="card-header">
                        <div class="card-icon" style="background-color: #EEF2FF;">
                            <i class="fas fa-ticket-alt" style="color: var(--primary-color);"></i>
                        </div>
                        <div>
                            <h3>Total de Chamados</h3>
                            <p class="text-3xl font-bold"><?php echo $statusCounts['total']; ?></p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <div class="card-icon" style="background-color: #FEF3C7;">
                            <i class="fas fa-clock" style="color: var(--warning-color);"></i>
                        </div>
                        <div>
                            <h3>Em Aberto</h3>
                            <p class="text-3xl font-bold"><?php echo $statusCounts['abertos']; ?></p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <div class="card-icon" style="background-color: #ECFDF5;">
                            <i class="fas fa-check-circle" style="color: var(--success-color);"></i>
                        </div>
                        <div>
                            <h3>Resolvidos</h3>
                            <p class="text-3xl font-bold"><?php echo $statusCounts['resolvidos']; ?></p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <div class="card-icon" style="background-color: #FEE2E2;">
                            <i class="fas fa-stopwatch" style="color: var(--danger-color);"></i>
                        </div>
                        <div>
                            <h3>Tempo Médio</h3>
                            <p class="text-3xl font-bold"><?php echo $statusCounts['tempo_medio']; ?></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabela de Chamados -->
            <div class="table-container">
                <h2 style="margin-bottom: 1rem;">Últimos Chamados</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Cliente</th>
                            <th>Título</th>
                            <th>Status</th>
                            <th>Prioridade</th>
                            <th>Data</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($latestTickets as $ticket): ?>
                        <tr>
                            <td><?php echo $ticket['id']; ?></td>
                            <td><?php echo $ticket['cliente']; ?></td>
                            <td><?php echo $ticket['titulo']; ?></td>
                            <td>
                                <span class="badge <?php echo getStatusClass($ticket['status']); ?>">
                                    <?php echo $ticket['status']; ?>
                                </span>
                            </td>
                            <td>
                                <span class="badge <?php echo getPriorityClass($ticket['prioridade']); ?>">
                                    <?php echo $ticket['prioridade']; ?>
                                </span>
                            </td>
                            <td><?php echo date('d/m/Y', strtotime($ticket['data'])); ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Toggle Sidebar
        document.getElementById('sidebar').addEventListener('click', function() {
            this.classList.toggle('collapsed');
            document.getElementById('mainContent').classList.toggle('expanded');
        });
    </script>
</body>
</html>