<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>


			<cfinvoke 
<!---			webservice="http://127.0.0.1:8500/cfmx/rh/admin/catalogos/book.cfc?wsdl" --->
			
            webservice="http://127.0.0.1:8500/cfmx/ws1/book.cfc?wsdl" 
			method="listBooks"
			returnvariable="rawXMLBookList">
			<cfinvokeargument name="category" value="infantil"/>
			</cfinvoke>>
			<cfoutput>#rawXMLBookList#</cfoutput> --->


</body>
</html>