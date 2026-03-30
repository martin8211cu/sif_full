<!---ljimenez llamado a cada uno de los archivos Reportes de SUA--->
<cfswitch expression="#form.ArchivoSUA#">
	<cfcase value="1">
		<cfinclude template="ImpDatosAfiliatorios_form.cfm">
	</cfcase>
	<cfcase value="2">
		<cfinclude template="ImpTrabajadores_form.cfm">
	</cfcase>
	<cfcase value="3">
		<cfinclude template="ImportacionMovimientos_form.cfm">
	</cfcase>
	<cfcase value="4">
		<cfinclude template="ImpDatosIncapacidades_form.cfm">
	</cfcase>
	<cfcase value="5">
		<cfinclude template="ImpMovCreditos_form.cfm">
	</cfcase>
    <cfcase value="6">
		<cfinclude template="ImpMovBimestrales_form.cfm">
	</cfcase>
</cfswitch>