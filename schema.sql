-- This table storages crucial students' info: user credentials, contact info, enrolled department
CREATE TABLE "students" (
    "id" VARCHAR(16)
    "names" VARCHAR(32) NOT NULL
    "last_names" VARCHAR(32) NOT NULL
    "pw" VARCHAR(255) NOT NULL
    "department_id" VARCHAR(16) NOT NULL
    "email" VARCHAR(64)
    "phone" VARCHAR(32)
    PRIMARY KEY("id")
    FOREIGN KEY("department_id") REFERENCES "departments"("id")
);

-- This table storages crucial subjects' info like its unique code and the department where it is taught
CREATE TABLE "subjects" (
    "id" VARCHAR(16)
    "name" TEXT NOT NULL
    "department_id" VARCHAR(16) NOT NULL
    "semester" INTEGER NOT NULL
    "credits" INTEGER NOT NULL
    PRIMARY KEY("id")
    FOREIGN KEY("department_id") REFERENCES "departments"("id")
);

-- This table storages crucial teachers' info: user credentials and contact info
CREATE TABLE "teachers" (
    "id" VARCHAR(16)
    "names" VARCHAR(32) NOT NULL
    "last_names" VARCHAR(32) NOT NULL
    "pw" VARCHAR(255) NOT NULL
    "email" VARCHAR(64)
    "phone" VARCHAR(32)
    PRIMARY KEY("id")
);

-- This table storages departments' info: its unique code and name
CREATE TABLE "departments" (
    "id" VARCHAR(16)
    "field" TEXT NOT NULL
    PRIMARY KEY("id")
);

-- This is a join table which storages the relationship between a teacher and a subject
CREATE TABLE "teaching" (
    "teacher_id" VARCHAR(16) NOT NULL
    "subject_id" VARCHAR(16) NOT NULL
    "section" VARCHAR(2)
    PRIMARY KEY("teacher_id", "subject_id")
    FOREIGN KEY("teacher_id") REFERENCES "teachers"("id")
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- This is a join table which storages the relationship between a student and a subject
CREATE TABLE "studying" (
    "student_id" VARCHAR(16) NOT NULL
    "subject_id" VARCHAR(16) NOT NULL
    "section" VARCHAR(2)
    PRIMARY KEY("student_id", "subject_id")
    FOREIGN KEY("student_id") REFERENCES "students"("id")
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- This is a join table which storages the relationship between a strategy and a student's grade
CREATE TABLE "evaluated" (
    "strategy_id" INTEGER NOT NULL
    "student_id" VARCHAR(16) NOT NULL
    "grade" INTEGER
    PRIMARY KEY("strategy_id", "student_id")
    FOREIGN KEY("strategy_id") REFERENCES "strategies"("id")
    FOREIGN KEY("student_id") REFERENCES "students"("id")
);

-- This table storages all the info about final grades like its range and date
CREATE TABLE "grades" (
    "id" INTEGER
    "student_id" INTEGER NOT NULL
    "subject_id" VARCHAR(16) NOT NULL
    "teacher_id" INTEGER NOT NULL
    "grade" INTEGER NOT NULL
    "date" DATE DEFAULT CURRENT_DATE
    PRIMARY KEY("id")
    FOREIGN KEY("student_id") REFERENCES "students"("id")
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- This table storages all the info about strategies which teachers use to evaluate their students
CREATE TABLE "strategies" (
    "id" INTEGER
    "type" TEXT NOT NULL
    "topic" TEXT
    "percentage" INTEGER NOT NULL
    "subject_id" VARCHAR(16) NOT NULL
    "teacher_id" INTEGER NOT NULL
    "date" DATE DEFAULT CURRENT_DATE
    PRIMARY KEY("id")
    FOREIGN KEY("teacher_id") REFERENCES "teachers"("id")
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- Index created to make faster querying a table which won't be modified after a semester starts
CREATE INDEX "subjects_index" ON "subjects"("name", "department_id", "semester", "credits");

-- View created to keep safe a list of students who are enrolled in "Logic & Math" subject
CREATE VIEW "logic_math" AS
SELECT students.id, students.names, students.last_names, grades.grade
FROM studying
JOIN grades ON studying.student_id = grades.student_id AND studying.subject_id = grades.subject_id
JOIN students ON studying.student_id = students.id
WHERE studying.subject_id = 'LM002';