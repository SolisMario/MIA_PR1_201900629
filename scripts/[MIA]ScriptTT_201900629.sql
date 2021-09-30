--carga de datos masiva
COPY temporal FROM '/home/mario/Repositorios/MIA_PR1_201900629/BlockbusterData.csv' (FORMAT 'csv', DELIMITER ';', NULL '-', HEADER 'true');
