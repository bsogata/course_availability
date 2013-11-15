/*
 * Populates the Department select tag.
 * 
 */
 
function updateDepartments()
{
  semester = $('#semester').val();
  departments = $('#department');
  url = 'https://www.sis.hawaii.edu/uhdad/' + semester;
  alert(url);
  
  $.get(url, function(data)
        {
          alert(data);
          var retrieved = $("a", data);
          
          departments.html('');
          
          for (var i = 0; i < retrieved.length; i++)
          {
            alert(retrieved[i]);
            newOption = $('<option></option');
            newOption.attr('value', retrieved[i].attr('href'));
            newOption.text(retrieved[i].val());
            departments.append(newOption);
          }
        });
}