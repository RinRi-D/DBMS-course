Select title from course where dept_name='Comp. Sci.' and credits=3;

Select course.course_id, course.title from course Inner Join takes On course.course_id=takes.course_id And takes.id='12345';

Select Sum(course.credits) from course Inner Join takes On course.course_id=takes.course_id And takes.id='12345';

Select student.id, Sum(course.credits) from course Inner Join takes On course.course_id=takes.course_id Inner Join student On takes.id=student.id group by student.id;

Select student.name from student Inner Join takes On student.id=takes.id Inner Join course On course.course_id=takes.course_id and course.dept_name='Comp. Sci.' group by student.id;

Select instructor.id from instructor Left Join teaches On instructor.id=teaches.id Where teaches.id IS null;

Select instructor.id, instructor.name from instructor Left Join teaches On instructor.id=teaches.id Where teaches.id IS null;

-- Optional
Select * from takes where grade like 'F%' and (id, course_id) not in (
    Select id, course_id from takes where grade not like 'F%'
);
