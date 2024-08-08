-- 1. Create trigger to prevent insert new Course with name length greater
-- than 20 chars;
CREATE OR REPLACE FUNCTION check_course_name_length()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.subjectsname) > 20 THEN
        RAISE EXCEPTION 'Course name must be 20 characters or less.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_course_name
BEFORE INSERT ON subjects
FOR EACH ROW
EXECUTE FUNCTION check_course_name_length();

--2. Create trigger to prevent user to insert or update Exam with Score
-- greater than 100 or less than zero
CREATE OR REPLACE FUNCTION validate_exam_score()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Score < 0 OR NEW.Score > 100 THEN
        RAISE EXCEPTION 'Score must be between 0 and 100.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_exam_score
BEFORE INSERT OR UPDATE ON exams
FOR EACH ROW
EXECUTE FUNCTION validate_exam_score();




-- 3. (bonus) Create trigger to prevent any user to update/insert/delete to all
-- tables (Students, Exams, Tracks,..) after 7:00 PM


CREATE OR REPLACE FUNCTION prevent_late_modifications()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(HOUR FROM CURRENT_TIME) >= 19 THEN
        RAISE EXCEPTION 'Modifications are not allowed after 7:00 PM.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- Trigger for Students 
CREATE TRIGGER trg_prevent_late_modifications_students
BEFORE INSERT OR UPDATE OR DELETE ON Students
FOR EACH ROW
EXECUTE FUNCTION prevent_late_modifications();

-- Trigger for Exams 
CREATE TRIGGER trg_prevent_late_modifications_exams
BEFORE INSERT OR UPDATE OR DELETE ON Exams
FOR EACH ROW
EXECUTE FUNCTION prevent_late_modifications();

-- Trigger for Tracks 
CREATE TRIGGER trg_prevent_late_modifications_tracks
BEFORE INSERT OR UPDATE OR DELETE ON Tracks
FOR EACH ROW
EXECUTE FUNCTION prevent_late_modifications();


-- 4. backup my database using commands 
-- pg_dump -U yehia -F c -b -v -f iti-training.dump iti-training

-- 5. Backup your Student table to external file
-- pg_dump -U yehia -d iti-training -t Students -F c -b -v -f students_backup.dump


-- end 







