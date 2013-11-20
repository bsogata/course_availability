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
 * Loads in data for the course tracking functionality.
 *
 * Parameters:
 *   departments         The array containing department names.
 *   department_pages    The array containing the pages for the above departments.
 *
 */

function setDepartmentData(departments, department_pages)
{
  this.departments = departments;
  this.pages = department_pages;
//  updateDepartments();
}

/*
 * Appends course data to the Course List.
 * 
 */

function showCourses()
{
  var selected = this.departments.indexOf($("#department").val());
  
  if ((0 <= selected) && (selected < this.pages.length))
  {
    // Creates a div containing the department page;
    // this makes it easier for jQuery to look through the page
    var page = this.pages[selected];
    var wrapper = document.createElement("div");
    $(wrapper).html(page);
    
    // Clear the table body
    var tableBody = $("#course-list-table > tbody");
    tableBody.html("");
    
    $("tr", wrapper).each(function()
    {
      columnIndex = 0;
			name = "";
			crn = 0;
			section = 0;
      title = "";
      credits = 0;
      instructor = "";
      seats = "";
      days = "";
      time = "";
      room = "";
      dates = "";
      columnCount = $("td", $(this)).length;
      
      $("td", $(this)).each(function()
      {
//        alert($(this).text());
        // Lectures
        if (columnCount == 12)
        {
          switch (columnIndex)
          {
            case 1:
              crn = $(this).text();
              break;
            case 2:
              name = $(this).text();
              break;
            case 3:
              section = $(this).text();
              break;
            case 4:
              title = $(this).text();
              break;
            case 5:
              credits = $(this).text();
              break;
            case 6:
              instructor = $(this).text();
              break;
            case 7:
              seats = $(this).text();
              break;
            case 8:
              days = $(this).text();
              break;
            case 9:
              time = $(this).text();
              break;
            case 10:
              room = $(this).text();
              break;
            case 11:
              dates = $(this).text();
              break;
          }
        }
        else if (columnCount == 11)
        {
          switch (columnIndex)
          {
            case 7:
              days = $(this).text();
              break;
            case 8:
              time = $(this).text();
              break;
            case 9:
              room = $(this).text();
              break;
            case 10:
              dates = $(this).text();
              break;
          }
        }
        columnIndex++;
      });
      
      // Create a row in the table for this course
      var row = document.createElement("tr");
      
      // Lectures
      if (crn != 0)
      {
        $(row).append("<td>" + name + "</td>");
        $(row).append("<td>" + crn + "</td>");
        $(row).append("<td>" + section + "</td>");
        $(row).append("<td>" + ((title.indexOf("Restriction:") == -1) ?
                                (title) :
                                (title.substring(0, title.indexOf("Restriction")) +
                                 "<br />" + title.substring(title.indexOf("Restriction"))))+ "</td>");
        $(row).append("<td>" + credits + "</td>");
        $(row).append("<td>" + instructor + "</td>");
        $(row).append("<td>" + seats + "</td>");
        $(row).append("<td>" + days + "</td>");
        $(row).append("<td>" + time + "</td>");
        $(row).append("<td>" + room + "</td>");
        $(row).append("<td>" + dates + "</td>");
        $(tableBody).append(row);
      }
      // Labs
      else if ((crn == 0) && (days.length > 0))
      {
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td></td>");
        $(row).append("<td>" + days + "</td>");
        $(row).append("<td>" + time + "</td>");
        $(row).append("<td>" + room + "</td>");
        $(row).append("<td>" + dates + "</td>");        
        $(tableBody).append(row);
      }
      
      first = false;
    });
  }
}