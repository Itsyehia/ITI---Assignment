----------- LAB 2 ------------------------
-- 1 add gender column for the students 
CREATE TYPE gender_enum AS ENUM ('male', 'female');

ALTER TABLE students
ADD COLUMN gender gender_enum;

-- 2 add birth date column 
ALTER TABLE students
ADD COLUMN birthDate DATE;


-- 3 delete name column 
ALTER TABLE students
DROP COLUMN name;

-- replace it with first and last name column
ALTER TABLE students
ADD COLUMN firstName VARCHAR(255),
ADD COLUMN lastName VARCHAR(255);

-- 4 
-- Create the composite columns
CREATE TYPE contactInfo AS (
    address VARCHAR(255),
    email VARCHAR(255)
);

-- Drop columns
ALTER TABLE students
DROP COLUMN email,
DROP COLUMN address;

-- Add the `contactInfo` column
ALTER TABLE students
ADD COLUMN contactInfo contactInfo;

-- 5 
-- Add column serial  type
ALTER TABLE students
ADD COLUMN serialCol SERIAL;

-- Alter to smallint
ALTER TABLE students
ALTER COLUMN serialCol TYPE SMALLINT;

-- 6 add new constrain 
ALTER TABLE PhoneNumbers
ADD CONSTRAINT fkStudent
FOREIGN KEY (StudentID) REFERENCES Students(StudentID);

-- 7 insert new data 
INSERT INTO public.students (
    studentid, gender, birthdate, firstname, lastname, contactinfo, serialcol
) VALUES (
    8, 'female', '2000-01-01', 'Johnita 2 ', 'Doe 2', ROW('123 Main St', 'johnita.doe@example.com')::contactinfo, DEFAULT
);



-- 8 display all students info 
select * from students 

-- 9 display male students 
select * from students 
where gender = 'male';  

-- 10 display number of female students 
SELECT count(*) AS num
FROM public.students
WHERE gender = 'female';

-- 11 display   students born before 1992-10-01
select * from students 
where  birthdate < '1992-10-01';

-- 12 display male students borm before 
select * from students 
where  birthdate < '1991-10-01' and gender = 'male';



-- 13 dispaly subject and their max score sorted by max score 
select subjectname, maxscore from subjects
order by maxscore;

-- 14 select subject with highest score 

SELECT s.SubjectName, e.Score
FROM Subjects s
JOIN Exams e ON s.SubjectID = e.SubjectID
ORDER BY e.Score DESC
LIMIT 1;

-- 15 select student with name 'a'
select * from students 
where  firstname like 'A%';

-- 16 select count of mohammed's 
SELECT count(*) AS num
FROM public.students
WHERE firstname = 'Mohammed';


-- 17 display number of male and femal 
SELECT gender, COUNT(*) AS num
FROM students
GROUP BY gender;

-- 18 select repeated first name and 
-- their count if they are higher than 2 
SELECT firstname, COUNT(*) AS counter
FROM students
GROUP BY firstname
HAVING COUNT(*) > 2;

-- 19 display all students and the track they belong to 
select s.StudentID, s.firstname, s.lastname, t.TrackName
from students s
join StudentTracks st on s.StudentID = st.StudentID
join Tracks t on st.TrackID = t.TrackID;

-- 20 bonus 
-- display students name and their score and subject name 

select s.firstname, s.lastname, e.Score, sub.SubjectName
from students s
join Exams e on s.StudentID = e.StudentID
join Subjects sub on e.SubjectID = sub.SubjectID;

----------- END ------------------------


----------- LAB 3 ------------------------




-- 1. Insert new student and his score in exam in different subjects as transaction and save it.
    BEGIN TRANSACTION;
    
    INSERT INTO public.students (
    studentid, gender, birthdate, firstname, lastname, contactinfo, serialcol
) VALUES (
    9, 'female', '2000-01-01', 'Johnita 3 ', 'Doe 3', ROW('123 Main St', 'johnita.doe@example.com')::contactinfo, DEFAULT
);
     COMMIT;

    BEGIN TRANSACTION;

    -- Insert exam scores for the new student
    INSERT INTO public.exams (
        studentid, subjectid, examdate, score
    ) VALUES
        (9, 1, '2024-08-01', 90),
        (9, 2, '2024-08-01', 85),
        (9, 3, '2024-08-01', 92);

     COMMIT;

 
-- 2. Insert new student and his score in exam in different subjects as transaction and abort.

    BEGIN TRANSACTION;
    
    INSERT INTO public.students (
    studentid, gender, birthdate, firstname, lastname, contactinfo, serialcol
) VALUES (
    9, 'female', '2000-01-01', 'Johnita 3 ', 'Doe 3', ROW('123 Main St', 'johnita.doe@example.com')::contactinfo, DEFAULT
);
    
    -- Insert exam scores for the new student
    INSERT INTO public.exams (
        studentid, subjectid, examdate, score
    ) VALUES
        (9, 1, '2024-08-01', 90),
        (9, 2, '2024-08-01', 85),
        (9, 3, '2024-08-01', 92);

     abort;

-- 8. Create user and give him all privileges.

CREATE USER itiUser WITH PASSWORD 'root';

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO itiUser;


-- 9. Create another new user and make the authentication method is “trust” 
-- and give him all privileges if he login from his “local” server.
CREATE USER newUser WITH PASSWORD 'root';

-- adjust the config file with adding the trust method 
-- then give access 
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO itiUser;


----------- END ------------------------




