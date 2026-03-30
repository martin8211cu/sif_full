<!--- Procesar los datos válidos (CDPcontrolv=1) sin generar (CDPcontrolvg=0) --->
<cftransaction>
	<cfinclude template = "#Gvar.rutaProcesa#">
	<cfquery datasource="#Gvar.Conexion#">
		update #Gvar.table_name#
		set CDPcontrolg = 1
		,CDPcontrolgt = 1	<!---Control de Generado temporal para saber que registros son nuevos y cuales no lo son, para controlar en la lista el proceso desde que se importan los datos, se validan y se generan encaso de que suceda en varias ocaiones para una misma tabla temporal. CarolRS.--->
		where coalesce(CDPcontrolv,1) = 1
		and coalesce(CDPcontrolg,0) = 0
		and Ecodigo=#Gvar.Ecodigo#
	</cfquery>
</cftransaction>

<!--- vuelve a la lista inicial --->
<cfoutput>
<form name="generar" action="index.cfm" method="post">
	<input type="hidden" name="CEcodigo" value="#form.CEcodigo#">
	<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">
	<input type="hidden" name="SScodigo" value="#form.SScodigo#">
</form>
<script language="javascript">
	document.generar.submit();
</script>
</cfoutput>