-- 1. Create multiply function which take two number and return the multiply of them\
CREATE OR REPLACE FUNCTION multiply(a NUMERIC, b NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN a * b;
END;
$$ LANGUAGE plpgsql;
SELECT multiply(6, 7);



--2  Create Hello world function which take username and return welcome message
-- to user using his name
CREATE OR REPLACE FUNCTION hello_world(username TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN 'Welcome, ' || username || '!';
END;
$$ LANGUAGE plpgsql;
SELECT hello_world('yehia');

-- 3. Create function which takes number and return if this number is odd or even.

CREATE OR REPLACE FUNCTION odd_or_even(number INT)
RETURNS TEXT AS $$
BEGIN
    IF number % 2 = 0 THEN
        RETURN 'Even';
    ELSE
        RETURN 'Odd';
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT odd_or_even(7);

--  4. Create AddNewStudent function which take Student firstName and lastname and
--birthdate and TrackName and add this new student info at database

CREATE OR REPLACE FUNCTION AddNewStudent(
    firstName TEXT,
    lastName TEXT,
    birthDate DATE,
    trackName TEXT
)
RETURNS VOID AS $$
DECLARE
    newStudentID INT;
    trackID INT;
BEGIN
    INSERT INTO Students (Name, DateOfBirth)
    VALUES (firstName || ' ' || lastName, birthDate)
    RETURNING StudentID INTO newStudentID;

    SELECT TrackID INTO trackID
    FROM Tracks
    WHERE TrackName = trackName;

    IF NOT FOUND THEN
        INSERT INTO Tracks (TrackName)
        VALUES (trackName)
        RETURNING TrackID INTO trackID;
    END IF;

    INSERT INTO StudentTracks (StudentID, TrackID)
    VALUES (newStudentID, trackID);

END;
$$ LANGUAGE plpgsql;


-- 5. Create function which takes StudentId and return the string/text that describe the
-- use info(firstname, last name, age, TrackName).


CREATE OR REPLACE FUNCTION GetStudentInfo(studentID INT)
RETURNS TEXT AS $$
DECLARE
    studentName TEXT;
    studentAge INT;
    trackName TEXT;
BEGIN
    SELECT (s.firstname || ' ' || s.LastName) AS studentName,
        DATE_PART('year', AGE(s.birthdate)) AS studentAge
    INTO  studentName, studentAge
    FROM  Students s
    WHERE  s.StudentID = studentID;
    
    -- Get the student's track name
    SELECT t.TrackName
    INTO trackName
    FROM  StudentTracks st
    JOIN Tracks t ON st.TrackID = t.TrackID
    WHERE  st.StudentID = studentID;

    -- Return the formatted string
    RETURN 'Name: ' || studentName || ', Age: ' || studentAge || ', Track: ' || trackName;
END;
$$ LANGUAGE plpgsql;


-- 6. Create function which takes TrackName and return the students names in this
 --track.
CREATE OR REPLACE FUNCTION GetStudentsByTrack(trackName TEXT)
RETURNS TEXT AS $$
DECLARE
    studentNames TEXT;
BEGIN
    SELECT STRING_AGG(s.firstname, ', ') AS studentNames
    INTO studentNames
    FROM Students s
    JOIN StudentTracks st ON s.StudentID = st.StudentID
    JOIN Tracks t ON st.TrackID = t.TrackID
    WHERE t.trackname = trackname;

    RETURN COALESCE(studentNames, 'No students found for this track');
END;
$$ LANGUAGE plpgsql;

SELECT GetStudentsByTrack('Java');

-- 7. Create function which takes student id and subject id and return score the
-- student in subject.

CREATE OR REPLACE FUNCTION GetStudentScore(studentID INT, subjectID INT)
RETURNS INT AS $$
DECLARE
    score INT;
BEGIN
    SELECT e.Score
    INTO score
    FROM Exams e
    WHERE e.StudentID = studentID AND e.SubjectID = subjectID;

    RETURN COALESCE(score, NULL);
END;
$$ LANGUAGE plpgsql;
SELECT GetStudentScore(1, 2);

--8. Create function which takes subject id and return the number of students who
-- failed in a subject (Score less than 50).

CREATE OR REPLACE FUNCTION CountFailedStudents(subjectID INT)
RETURNS INT AS $$
DECLARE
    failedCount INT;
BEGIN
    -- Count the number of students who failed in the given subject
    SELECT COUNT(*)
    INTO failedCount
    FROM Exams e
    WHERE e.SubjectID = subjectID AND e.Score < 50;

    -- Return the count of failed students
    RETURN failedCount;
END;
$$ LANGUAGE plpgsql;

SELECT CountFailedStudents(2);

-- 9. Create function which take subject name and return the average grades for
-- subject

CREATE OR REPLACE FUNCTION GetAverageGrade(subjectName TEXT)
RETURNS NUMERIC AS $$
DECLARE
    averageGrade NUMERIC;
BEGIN
    -- Calculate the average grade for the given subject
    SELECT AVG(e.Score)
    INTO averageGrade
    FROM Exams e
    JOIN Subjects s ON e.SubjectID = s.SubjectID
    WHERE s.Subjectname = subjectname;

    -- Return the average grade, or NULL if no grades are found
    RETURN COALESCE(averageGrade, NULL);
END;
$$ LANGUAGE plpgsql;

SELECT GetAverageGrade('Java');


-- 10. Import SQL file into your database.
-- psql -d iti-training -f yehia2.sql













