<cfif IsDefined('form.Cargar')>
		<!---
			10 horas debe ser suficiente para aprox 9 millones de registros
			si el procesamiento se mantiene en ~4 milisegundos por registros
		--->
		<cfsetting requesttimeout="36000" enablecfoutputonly="yes">
		<cffile action="upload" destination="#GetTempDirectory()#" filefield="archivo"  nameconflict="makeunique">
		<cfset tempfile = cffile.ServerDirectory & '/' & cffile.ServerFile>
		<cfinvoke component="saci.comp.facturaMedios" method="recibirLiquidaciones"
				dsn="#session.dsn#" rutaArchivo="#tempfile#" nombreOriginal="#cffile.ClientFile#" />
		<cffile action="delete" file="#tempfile#">
</cfif>
<cflocation url="index.cfm?tab=#form.tab#">
