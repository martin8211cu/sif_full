<!--- this example shows the use of cfinput within a cfform to ensure simplevalidation of text items --->
<cfform action = "aaa.cfm">
<!--- phone number validation --->
Phone Number Validation (enter a properly formatted phone number): <br>
<cfinput 
	type = "Text" name = "MyPhone" 
	message = "Enter telephone number,formatted xxx-xxx-xxxx (e.g. 617-761-2000)"
	validate = "telephone" required = "Yes">
	<font size = -1 color = red>Required</font>
<!--- zip code validation --->
<p>Zip Code Validation (enter a properly formatted zip code):<br>
<cfinput 
	type = "Text" name = "MyZip" 
	message = "Enter zip code, formatted xxxxx or xxxxx-xxxx" 
	validate = "zipcode" required = "Yes">
	<font size = -1 color = red>Required</font>
<!--- range validation --->
<p>Range Validation (enter an integer from 1 to 5): <br>
<cfinput 
	type = "Text" name = "MyRange" range = "1,5" 
	message = "You must enter an integer from 1 to 5" 
	validate = "integer" required = "No">
<!--- date validation --->
<p>Date Validation (enter a properly formatted date):<br>
<cfinput 
	type = "Text" name = "MyDate" 
	message = "Enter a correctly formatted date (dd/mm/yy)" 
	validate = "date" required = "No">
<input 
	type = "Submit" name = "" 
	value = "send my information">
</cfform>
