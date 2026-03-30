<html>
<head>
	<title>Simple Data Form</title>
</head>
<body>
<h2>Simple Data Form</h2>

<!--- Form part --->
<form action="datatest.cfm" method="Post">
	<input type="hidden" 
		name="StartDate_required" 
		value="You must enter a start date.">
	<input type="hidden" 
		name="StartDate_date" 
		value="Enter a valid date as the start date.">
	<input type="hidden" 
		name="Salary_required" 
		value="You must enter a salary.">
	<input type="hidden" 
		name="Salary_float" 
		value="The salary must be a number.">
	Start Date: 
	<input type="text" 
		name="StartDate" size="16" 
		maxlength="16"><br>
	Salary: 
	<input type="text" 
		name="Salary" 
		size="10" 
		maxlength="10"><br>
	<input type="reset" 
		name="ResetForm" 
		value="Clear Form">
	<input type="submit" 
		name="SubmitForm" 
		value="Insert Data">
</form>
<br>

<!--- Action part --->
<cfif isdefined("Form.StartDate")>
	<cfoutput>
		Start Date is: #DateFormat(Form.StartDate)#<br>
		Salary is: #DollarFormat(Form.Salary)#
	</cfoutput>
</cfif>
</html>
