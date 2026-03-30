<cfif IsDefined('form.Revisar_Correo')>
		<!---
			10 horas debe ser suficiente para aprox 4.5 millones de registros
			si el procesamiento se mantiene en ~8 milisegundos por registros
		--->
		<cfsetting requesttimeout="36000" enablecfoutputonly="yes">
		<cfinvoke component="saci.comp.facturaMedios" method="revisarCorreo" dsn="#session.dsn#" />
</cfif>
<cflocation url="index.cfm?tab=inbox">