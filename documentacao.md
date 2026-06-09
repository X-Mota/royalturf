```mermaid
flowchart TD
    A["INTERNET"]

    B["NGINX / APACHE<br/>Reverse Proxy / SSL / Servidor Web"]

    C["CLIENTE / BROWSER<br/>Interface do Usuário"]
    C1["• Páginas Dinâmicas Renderizadas"]
    C2["• Boletim de Apostas Lateral Bet Slip"]
    C3["• Envio de Formulários HTTP POST/GET"]

    D["SERVIDOR BACK END<br/>PHP 8.x Engine"]
    D1["• Validação de Sessões session_start"]
    D2["• Filtros e Buscas Dinâmicas LIKE"]
    D3["• Sistema de Autenticação e Perfis"]
    D4["• Geração de Relatórios PDF FPDF/DomPDF"]

    E["SERVIDOR DE BANCO DE DADOS<br/>MySQL"]
    E1["• Tabelas: usuarios, cavalos, joqueis"]
    E2["• Tabelas: corridas, inscricoes, apostas, resultados"]
    E3["• Chaves Estrangeiras e Integridade Referencial"]

    A --> B

    B -->|"HTTPS / Requisições"| C
    C -->|"Requisições de Páginas"| B
    
    B -->|"Módulo PHP / FastCGI"| D
    
    D -->|"PDO / MySQLi - Porta 3306"| E

    C --> C1
    C --> C2
    C --> C3

    D --> D1
    D --> D2
    D --> D3
    D --> D4

    E --> E1
    E --> E2
    E --> E3
```
