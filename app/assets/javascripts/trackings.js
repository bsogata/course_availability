$(document).ready(function()
{
  updateDepartments();
});

/*
 * Populates the Department select tag.
 * 
 */
 
function updateDepartments()
{
  var departments = $("#department");
  departments.html("");
  departments.append($("<option></option>").text("Select a department"));
  for (var i = 0; i < this.departments.length; i++)
  {
    departments.append($("<option></option>").text(this.departments[i]));
  }
}

/*
 * Populates the Course select tag.
 * 
 */
 
function updateCourses()
{
  var courses = $("#course");
  courses.html("");
  courses.append($("<option></option>").text("Select a course"));
  
  var departmentIndex = this.departments.indexOf($("#department").val());
  
  if (departmentIndex != -1)
  {
    for (var i = 0; i < this.courses[departmentIndex].length; i++)
    {
      courses.append($("<option></option>").text(this.courses[departmentIndex][i]))
    }
  }
}

/*
 * Loads in data for the course tracking functionality.
 *
 * Parameters:
 *   departments    The array containing department names.
 *   courses        The array containing the courses for the above departments.
 *
 */

function setCourseData(departments, courses)
{
  this.departments = departments;
  this.courses = courses;
//  updateDepartments();
}