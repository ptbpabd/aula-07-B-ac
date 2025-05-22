/*
Questão 01. Crie um procedimento denominado salaryHistogram, que distribua as frequências dos salários dos Professores em intervalos (Histograma).
O número de intervalos será calculado de acordo com o parâmetro de entrada do procedimento. Exemplo: EXEC dbo.salaryHistogram 4;
*/
-- Criação do procedimento
CREATE PROCEDURE dbo.salaryHistogram @number_interval INT
AS
DECLARE @tamanhoIntervalo NUMERIC(8,2); 
DECLARE @LocationTVP AS TABLE (valorMinimo INT, valorMaximo INT);
DECLARE @intervaloMinimo INT;
DECLARE @intervaloMaximo INT;
DECLARE @limiteAtual INT;

SET @intervaloMinimo = (SELECT FLOOR(MIN(instructor.salary)) FROM instructor);
SET @intervaloMaximo = (SELECT CEILING(MAX(instructor.salary)) FROM instructor);

SET @tamanhoIntervalo = CEILING((@intervaloMaximo-@intervaloMinimo)/@number_interval); 

PRINT 'Intervalo mínimo: ' + CAST(@intervaloMinimo as nvarchar(20));
PRINT 'Intervalo máximo: ' + CAST(@intervaloMaximo as nvarchar(20));
PRINT 'Tamanho do intervalo: ' + CAST(@tamanhoIntervalo as nvarchar(20));

SET @limiteAtual = @intervaloMinimo;

WHILE (@limiteAtual + @tamanhoIntervalo + 1 < @intervaloMaximo)
  BEGIN
  INSERT INTO @LocationTVP VALUES (@limiteAtual, @limiteAtual + @tamanhoIntervalo);
  SET @limiteAtual = @limiteAtual + @tamanhoIntervalo;
END;

INSERT INTO @LocationTVP VALUES (@limiteAtual, @intervaloMaximo);

SELECT l.valorMinimo, l.valorMaximo, count(*) AS total FROM @LocationTVP l
LEFT JOIN dbo.instructor ON instructor.salary BETWEEN l.valorMinimo AND l.valorMaximo
GROUP BY l.valorMinimo, l.valorMaximo;

-- Execução do procedimento
EXEC dbo.salaryHistogram 5;


