<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfquery name="empdata" datasource="CompanyInfo">
   SELECT * FROM Employee
</cfquery>

<cfform name="GridForm"
   action="handle_grid.cfm">

   <cfgrid name="employee_grid"
      height=425
      width=300
      vspace=10
      selectmode="edit"
      query="empdata"
      insert="Yes"
      delete="Yes">
      
      <cfgridcolumn name="Emp_ID"
         header="Emp ID"
         width=50
         headeralign="center"
         headerbold="Yes"
         select="No">

      <cfgridcolumn name="LastName"
         header="Last Name"
         width=100
         headeralign="center"
         headerbold="Yes">

      <cfgridcolumn name="Dept_ID"
         header="Dept"
         width=35
         headeralign="center"
         headerbold="Yes">

   </cfgrid>
   <br>
   <input type="Submit" value="Submit">
</cfform>
</body>
</html>
