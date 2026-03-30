<cffunction name="p" returntype="boolean" access="public">
	<cftry>
		<cfquery name="p2" datasource="educativo">
			insert Nivel(CEcodigo, Ndescripcion, Norden)
			values(12, 'Prueba1', 1000)
	
			insert Nivel(CEcodigo, Ndescripcion, Norden)
			values(66, 'Prueba2', 1)
		</cfquery>

		<cfcatch type="any">
			Error Dentro: 
			<cftransaction action="rollback"/>
		</cfcatch>				
	</cftry>
</cffunction>

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<cftransaction action="begin">
		<cftry>
			<cfquery name="p4" datasource="educativo">
				insert Nivel(CEcodigo, Ndescripcion, Norden)
				values(12, 'Prueba0', 1000)
			</cfquery>
			<cftransaction action="commit" />
			
			<cfscript>
				p();
			</cfscript>

		<cfcatch type="any">
			Error Fuera: 
			<cftransaction action="rollback"/>
		</cfcatch>				
		</cftry>
	</cftransaction>

</body>
</html>
