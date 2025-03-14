-- Querying subjects that the teacher are teaching
SELECT s.id, s.name, d.field, s.semester, COUNT(studying.student_id) AS 'enrolled'
FROM subjects s
JOIN departments d ON s.department_id = d.id
JOIN teaching t ON s.id = t.subject_id
JOIN teachers ts ON t.teacher_id = ts.id
JOIN studying ON s.id = studying.subject_id
WHERE t.teacher_id = 23500120
GROUP BY s.id;
-- QUERY PLAN
-- |--SEARCH ts USING COVERING INDEX sqlite_autoindex_teachers_1 (id=?)
-- |--SEARCH t USING COVERING INDEX sqlite_autoindex_teaching_1 (teacher_id=?)
-- |--SEARCH s USING INDEX sqlite_autoindex_subjects_1 (id=?)
-- |--SEARCH d USING INDEX sqlite_autoindex_departments_1 (id=?)
-- |--SCAN studying USING COVERING INDEX sqlite_autoindex_studying_1
-- `--USE TEMP B-TREE FOR GROUP BY


-- Querying teacher's name
SELECT names, last_names
FROM teachers
WHERE id = 23500120;
-- QUERY PLAN
-- `--SEARCH teachers USING INDEX sqlite_autoindex_teachers_1 (id=?)


-- Updating grade's info
UPDATE "grades" SET "grade" = 7, "teacher_id" = 23500120, "date" = '2025-03-06'
WHERE "student_id" = 30500100
AND "subject_id" = 'LM002';
-- QUERY PLAN
-- `--SCAN grades


-- List of students from a specific subject
SELECT students.id, students.names, students.last_names, grades.grade
FROM studying
JOIN grades ON studying.student_id = grades.student_id AND studying.subject_id = grades.subject_id
JOIN students ON studying.student_id = students.id
WHERE studying.subject_id = 'LM002';
-- QUERY PLAN
-- |--SCAN studying USING COVERING INDEX sqlite_autoindex_studying_1
-- |--SEARCH students USING INDEX sqlite_autoindex_students_1 (id=?)
-- |--BLOOM FILTER ON grades (subject_id=? AND student_id=?)
-- `--SEARCH grades USING AUTOMATIC PARTIAL COVERING INDEX (subject_id=? AND student_id=?)


-- Inserting a strategy by a professor
INSERT INTO "strategies" ("type", "topic", "percentage", "subject_id", "teacher_id", "date")
VALUES ('exam', 'Bool Logic', 25, 'LM002', 23500120, '2025-03-31');


-- Inserting a students-strategy relationship
INSERT INTO evaluated (strategy_id, student_id)
SELECT 6, students.id
FROM studying
JOIN grades ON studying.student_id = grades.student_id AND studying.subject_id = grades.subject_id
JOIN students ON studying.student_id = students.id
WHERE studying.subject_id = 'LM002';


-- List of students who must take a strategy
SELECT evaluated.strategy_id, evaluated.student_id, students.names, students.last_names, evaluated.grade
FROM evaluated
JOIN students ON evaluated.student_id = students.id
WHERE evaluated.strategy_id = 6;
-- QUERY PLAN
-- |--SEARCH evaluated USING INDEX sqlite_autoindex_evaluated_1 (strategy_id=?)
-- `--SEARCH students USING INDEX sqlite_autoindex_students_1 (id=?)


-- Querying important info from a student: subjects, semesters, grades, teachers...
SELECT subjects.name, subjects.semester, subjects.credits, grades.grade, teachers.names, teachers.last_names
FROM studying
JOIN subjects ON studying.subject_id = subjects.id
JOIN grades ON studying.student_id = grades.student_id AND studying.subject_id = grades.subject_id
JOIN teaching ON studying.subject_id = teaching.subject_id
JOIN teachers ON teaching.teacher_id = teachers.id
WHERE studying.student_id = 30500100;
-- QUERY PLAN
-- |--SCAN teaching USING COVERING INDEX sqlite_autoindex_teaching_1
-- |--SEARCH studying USING COVERING INDEX sqlite_autoindex_studying_1 (student_id=? AND subject_id=?)
-- |--SEARCH teachers USING INDEX sqlite_autoindex_teachers_1 (id=?)
-- |--SEARCH subjects USING INDEX sqlite_autoindex_subjects_1 (id=?)
-- |--BLOOM FILTER ON grades (subject_id=? AND student_id=?)
-- `--SEARCH grades USING AUTOMATIC PARTIAL COVERING INDEX (subject_id=? AND student_id=?)


-- Deleting a specific subject from pensum
DELETE FROM subjects
WHERE id = 'LM002';


-- List of subjects provided by enrolled department for a student
SELECT subjects.id, subjects.name, subjects.semester, subjects.credits
FROM subjects
JOIN students ON subjects.department_id = students.department_id
WHERE students.id = 30500100;
-- QUERY PLAN
-- |--SEARCH students USING INDEX sqlite_autoindex_students_1 (id=?)
-- `--SCAN subjects