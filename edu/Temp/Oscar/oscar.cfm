<cfquery datasource="SDC" name="Miquery">
	select name, id, type from sysobjects
</cfquery>
<cfquery dbtype="query" name="MiSubQuery">
	select name, id, type from Miquery where type='U'
</cfquery>

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<table>
		<tr>
			<td>
				<table>
					<cfoutput query="Miquery">
						<tr>
							<td>
								#name#
							</td>
						</tr>
					</cfoutput>
				</table>
			</td>
			<td>
				<table>
					<cfoutput query="Miquery">
						<tr>
							<td>
								#id#
							</td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>
	</table>
	<cfif isdefined("form.btnAgregar")>
  	  <cfset LvarModo = "Agregar">
	<cfelseif isdefined("form.btnModificar")>
  	  <cfset LvarModo = "Modificar">
	</cfif>
</body>
</html>

