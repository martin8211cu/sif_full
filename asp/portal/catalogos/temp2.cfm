<cfinclude template="imagen.cfm">

<cfdump var="#ts#">

<cfquery name="rs" datasource="asp">
	update CuentaEmpresarial
	set CElogo = #ts#
	where CEcodigo = 15
</cfquery>


<cflocation url="temp.cfm">