-- Royal Turf — schema MySQL
CREATE DATABASE IF NOT EXISTS royalturf CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE royalturf;

CREATE TABLE IF NOT EXISTS cavalos (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(120) NOT NULL,
  raca        VARCHAR(100),
  idade       TINYINT UNSIGNED NOT NULL,
  pelagem     VARCHAR(60),
  sexo        VARCHAR(40),
  peso_kg     DECIMAL(5,1) NOT NULL,
  altura      SMALLINT,
  treinador   VARCHAR(100),
  joquei      VARCHAR(100),
  criado_em   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dados padrão
INSERT INTO cavalos (nome, raca, idade, pelagem, sexo, peso_kg, altura, treinador, joquei) VALUES
  ('Bala de Prata',  'Puro Sangue Inglês', 4, 'Castanho Escuro', 'Macho (Inteiro)', 495, 158, 'M. Aurélio',  'J. Moreira'),
  ('Vento Leste',    'Puro Sangue Inglês', 5, 'Tordilho',        'Macho (Inteiro)', 478, 162, 'A. Silva',     'L. Henrique'),
  ('Trovão Real',    'Quarto de Milha',    6, 'Alazão',          'Macho (Inteiro)', 502, 160, 'C. Santos',    'H. Fernandes'),
  ('Estrela d\'Alva','Puro Sangue Inglês', 3, 'Baio',            'Fêmea',           460, 155, 'R. Lima',      'F. Costa'),
  ('Fogo da Serra',  'Árabe',              7, 'Ruão',            'Macho (Capado)',   510, 164, 'P. Dias',      'G. Neto');
