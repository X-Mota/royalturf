
-- =====================================================
-- ROYAL TURF — Script de Banco de Dados
-- MySQL 5.7+ / MariaDB 10.3+
-- =====================================================

CREATE DATABASE IF NOT EXISTS royalturf CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE royalturf;

-- ─── USUÁRIOS ─────────────────────────────────────────────────────────────────
CREATE TABLE usuarios (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(100) NOT NULL,
  email     VARCHAR(150) NOT NULL UNIQUE,
  senha     VARCHAR(255) NOT NULL,   -- guardar hash em PHP (password_hash)
  saldo     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  role      ENUM('admin','apostador') NOT NULL DEFAULT 'apostador',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email, senha, saldo, role) VALUES
('João Silva',  'apostador@royal.com', '123456', 1250.00, 'apostador'),
('Admin Turf',  'admin@royal.com',     'admin123', 0.00,  'admin');

-- ─── CAVALOS ──────────────────────────────────────────────────────────────────
CREATE TABLE cavalos (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(100) NOT NULL,
  idade     TINYINT UNSIGNED NOT NULL,
  peso_kg   SMALLINT UNSIGNED,
  pelagem   VARCHAR(60),
  raca      VARCHAR(80),
  origem    VARCHAR(60),
  sexo      VARCHAR(30),
  altura    SMALLINT UNSIGNED,       -- cm
  treinador VARCHAR(100),
  joquei    VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cavalos (nome, idade, peso_kg, pelagem, raca, origem, sexo, altura, treinador, joquei) VALUES
('Bala de Prata',  4, 495, 'Castanho Escuro', 'Puro Sangue Inglês', 'Brasil',    'Macho (Inteiro)', 158, 'M. Aurélio',  'J. Moreira'),
('Vento Leste',    5, 478, 'Tordilho',        'Puro Sangue Inglês', 'Argentina', 'Macho (Inteiro)', 162, 'A. Silva',    'L. Henrique'),
('Trovão Real',    6, 502, 'Alazão',          'Quarto de Milha',    'Brasil',    'Macho (Inteiro)', 160, 'C. Santos',   'H. Fernandes'),
('Estrela d''Alva',3, 460, 'Baio',            'Puro Sangue Inglês', 'Brasil',    'Fêmea',           155, 'R. Lima',     'F. Costa'),
('Fogo da Serra',  7, 510, 'Ruão',            'Árabe',              'EUA',       'Macho (Capado)',   164, 'P. Dias',     'G. Neto');

-- ─── CORRIDAS (pareos) ────────────────────────────────────────────────────────
CREATE TABLE pareos (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  local      VARCHAR(150) NOT NULL,
  distancia  SMALLINT UNSIGNED NOT NULL,   -- metros
  data       DATETIME NOT NULL,
  status     ENUM('aberta','em_andamento','encerrada') NOT NULL DEFAULT 'aberta',
  premio     DECIMAL(10,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO pareos (local, distancia, data, status, premio) VALUES
('Hipódromo da Gávea (RJ)',  1200, '2026-06-10 14:00:00', 'aberta',    50000.00),
('Cidade Jardim (SP)',        1400, '2026-06-10 15:30:00', 'aberta',    75000.00),
('Hipódromo da Gávea (RJ)',  1000, '2026-06-08 16:30:00', 'encerrada', 40000.00),
('Cristal (RS)',              1600, '2026-06-07 15:45:00', 'encerrada', 60000.00);

-- ─── INSCRIÇÕES (cavalo × corrida) ────────────────────────────────────────────
CREATE TABLE inscricoes (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  pareo_id   INT NOT NULL,
  cavalo_id  INT NOT NULL,
  odd        DECIMAL(5,2) NOT NULL DEFAULT 1.00,
  posicao    TINYINT UNSIGNED DEFAULT NULL,   -- NULL = não finalizado
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pareo_id)  REFERENCES pareos(id)  ON DELETE CASCADE,
  FOREIGN KEY (cavalo_id) REFERENCES cavalos(id) ON DELETE CASCADE
);

INSERT INTO inscricoes (pareo_id, cavalo_id, odd, posicao) VALUES
(1, 1, 2.50, NULL),
(1, 2, 4.00, NULL),
(1, 3, 1.85, NULL),
(2, 4, 3.20, NULL),
(2, 5, 2.10, NULL),
(3, 2, 3.50, 2),
(3, 3, 2.20, 1),
(4, 1, 1.90, 3),
(4, 4, 4.50, 1);

-- ─── APOSTAS ──────────────────────────────────────────────────────────────────
CREATE TABLE apostas (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id   INT NOT NULL,
  inscricao_id INT NOT NULL,
  valor        DECIMAL(10,2) NOT NULL,
  status       ENUM('PENDENTE','GANHA','PERDIDA') NOT NULL DEFAULT 'PENDENTE',
  data         DATE NOT NULL,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id)   REFERENCES usuarios(id)   ON DELETE CASCADE,
  FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id) ON DELETE CASCADE
);

INSERT INTO apostas (usuario_id, inscricao_id, valor, status, data) VALUES
(1, 1, 100.00, 'PENDENTE', '2026-06-10'),
(1, 6,  50.00, 'PERDIDA',  '2026-06-08'),
(1, 8, 200.00, 'GANHA',    '2026-06-07');

-- ─── VIEW ÚTIL: apostas com detalhes ──────────────────────────────────────────
CREATE VIEW vw_apostas_detalhes AS
SELECT
  a.id           AS aposta_id,
  u.nome         AS apostador,
  c.nome         AS cavalo,
  p.local        AS hipodromo,
  p.data         AS data_corrida,
  i.odd,
  a.valor,
  a.status,
  (a.valor * i.odd) AS retorno_potencial
FROM apostas a
JOIN usuarios  u ON u.id = a.usuario_id
JOIN inscricoes i ON i.id = a.inscricao_id
JOIN cavalos   c ON c.id = i.cavalo_id
JOIN pareos    p ON p.id = i.pareo_id;
