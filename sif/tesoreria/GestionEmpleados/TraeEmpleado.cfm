<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfif #url.CCHid# neq 'undefined'>

<cfquery name="rsnameE" datasource="#Session.DSN#">
	select CCHresponsable,
	(select DEnombre #LvarCNCT#' '#LvarCNCT#DEapellido1#LvarCNCT#' '#LvarCNCT#DEapellido2 from DatosEmpleado where DEid=a.CCHresponsable) as CCHresponsable1
	from CCHica a where CCHid= #url.CCHid#				
</cfquery>

<cfoutput>
<script language="javascript1.2" type="text/javascript">
<!---Caso 1 (Mlocal=MLiquidacion=Mdetalle)--->
	<cfif isdefined ('url.CCHid')>
		window.parent.document.form1.nameE.value = "#rsnameE.CCHresponsable1#";
		window.parent.document.form1.nameE.disabled = true;
	</cfif>			

</script>

</cfoutput>
</cfif>
