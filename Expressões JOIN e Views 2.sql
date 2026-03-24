-- Aula 04.B.ac Expressões JOIN e Views


/* Questão 1. Gere uma lista de todos os instrutores, mostrando sua ID, nome e número de seções que eles ministraram. 
 Não se esqueça de mostrar o número de seções como 0 para os instrutores que não ministraram qualquer seção. 
 Sua consulta deverá utilizar outer join e não deverá utilizar subconsultas escalares. */

SELECT i.ID, i.name, COUNT(t.sec_id) AS "Number of Sections"
FROM instructor i LEFT OUTER JOIN teaches t
ON i.ID = t.ID
GROUP BY i.ID, i.name;

/* Questão 2. Escreva a mesma consulta do item anterior, mas usando uma subconsulta escalar, sem outer join. */

SELECT i.ID, i.name, (SELECT COUNT(t.sec_id) FROM teaches t WHERE i.ID = t.ID) AS "Number of Sections"
FROM instructor i
GROUP BY i.ID, i.name;

/* Questão 3. Gere a lista de todas as seções de curso oferecidas na primavera de 2010, junto com o nome dos instrutores ministrando a seção. 
 Se uma seção tiver mais de 1 instrutor, ela deverá aparecer uma vez no resultado para cada instrutor. Se não tiver instrutor algum, ela ainda deverá aparecer no resultado,
 com o nome do instrutor definido como “-”. */

SELECT t.course_id, t.sec_id, i.ID, t.semester, t.year, i.name
FROM teaches t LEFT OUTER JOIN instructor i 
ON t.ID = i.ID
WHERE t.semester = 'Spring' AND t.year = 2010
ORDER BY t.course_id;

/* Questão 4. Suponha que você tenha recebido uma relação grade_points (grade, points), que oferece uma conversão de conceitos (letras) na relação takes para notas numéricas; 
por exemplo, uma nota “A+” poderia ser especificada para corresponder a 4 pontos, um “A” para 3,7 pontos, e “A-” para 3,4, e “B+” para 3,1 pontos, e assim por diante. 
Os Pontos totais obtidos por um aluno para uma oferta de curso (section) são definidos como o número de créditos para o curso multiplicado pelos pontos numéricos para a nota que o aluno recebeu.
Dada essa relação e o nosso esquema university, escreva:
Ache os pontos totais recebidos por aluno, para todos os cursos realizados por ele. */

CREATE VIEW grade_points AS SELECT t.grade,
	CASE 
        WHEN t.grade = 'A+' THEN 4
		WHEN t.grade = 'A' THEN 3.7
		WHEN t.grade = 'A-' THEN 3.3
		WHEN t.grade = 'B+' THEN 3
		WHEN t.grade = 'B' THEN 2.7
		WHEN t.grade = 'B-' THEN 2.3
		WHEN t.grade = 'C+' THEN 2
		WHEN t.grade = 'C' THEN 1.7
        ELSE 1.3
     END AS points
FROM takes t;


SELECT s.ID,s.name, c.title,s.dept_name,t.grade, gp.points, c.credits, 
(c.credits * gp.points) AS "Pontos totais"
FROM student s JOIN takes t
ON s.ID = t.ID
JOIN section se
ON t.course_id = se.course_id
JOIN course c
ON se.course_id = c.course_id
JOIN grade_points gp
ON t.grade = gp.grade;

/* Questão 5. Crie uma view a partir do resultado da Questão 4 com o nome “coeficiente_rendimento”. */

CREATE VIEW coeficiente_rendimento AS 
SELECT s.ID,s.name, c.title,s.dept_name,t.grade, gp.points, c.credits, 
(c.credits * gp.points) AS "Pontos totais"
FROM student s JOIN takes t
ON s.ID = t.ID
JOIN section se
ON t.course_id = se.course_id
JOIN course c
ON se.course_id = c.course_id
JOIN grade_points gp
ON t.grade = gp.grade;
