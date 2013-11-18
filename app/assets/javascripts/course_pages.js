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
}

$(document).ready(function()
{
  updateDepartments();
});