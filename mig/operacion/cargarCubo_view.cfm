<cfset LvarOP = "">
<cfset LvarErrD = expandPath("/mig/operacion/Dimensiones_err.txt")>
<cfset LvarErrM = expandPath("/mig/operacion/Metricas_err.txt")>
<cfset LvarErrI = expandPath("/mig/operacion/Indicadores_err.txt")>

<cflock name="mig_prcs" throwontimeout="yes" timeout="5">
	<cfif isdefined("application.mig_prcs") AND NOT isdefined("application.mig_prcs.Tipo")>
		<cfset Application.mig_prcs = structNew()>
		<cfset structDelete(Application,"mig_prcs")>
	</cfif>
	<cfif isdefined("application.mig_prcs")>
		<cfset LvarOP = "PROGRESO">
	<cfelseif fileExists(LvarErrD)>
		<cfset LvarOP = "ERR_D">
	<cfelseif fileExists(LvarErrM)>
		<cfset LvarOP = "ERR_M">
	<cfelseif fileExists(LvarErrI)>
		<cfset LvarOP = "ERR_I">
	</cfif>
</cflock>

<cfif LvarOP EQ "PROGRESO">
	<cfoutput>
	<cfset LvarOBJ=createObject("component", "mig.Componentes.utils")>
	#LvarOBJ.sbPintarResultado()#
	</cfoutput>
	<script language="javascript">
	<cfif application.mig_prcs.stN EQ 0>
		setTimeout("location.href = 'cargarCubo.cfm';",1000);
	<cfelse>
		setTimeout("location.href = 'cargarCubo.cfm';",5000);
	</cfif>
	</script>
	<cfabort>
<cfelse>
	<cfif LvarOP EQ "ERR_D">
		<img src="/cfmx/sif/imagenes/Cferror.gif" style="cursor:pointer" alt="Ver Errores" onclick="location.href='cargarCubo_sql.cfm?ERR_D';">
		Errores al cargar las Dimensiones<BR>
	<cfelseif LvarOP EQ "ERR_M">
		<cfset LvarHtml = "Dimensiones.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Dimensiones</strong><BR>
		</cfif>

		<img src="/cfmx/sif/imagenes/Cferror.gif" style="cursor:pointer" alt="Ver Errores" onclick="location.href='cargarCubo_sql.cfm?ERR_M';">
		Errores al cargar las Métricas<BR>
	<cfelseif LvarOP EQ "ERR_I">
		<cfset LvarHtml = "Dimensiones.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Dimensiones</strong><BR>
		</cfif>
	
		<cfset LvarHtml = "Metricas.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Metricas</strong><BR>
		</cfif>
	
		<img src="/cfmx/sif/imagenes/Cferror.gif" style="cursor:pointer" alt="Ver Errores" onclick="location.href='cargarCubo_sql.cfm?ERR_I';">
		Errores al cargar los Indicadores<BR>
	<cfelse>
		<cfset LvarHtml = "Dimensiones.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Dimensiones</strong><BR>
		</cfif>
	
		<cfset LvarHtml = "Metricas.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Metricas</strong><BR>
		</cfif>
	
		<cfset LvarHtml = "Indicadores.html">
		<cfif FileExists(expandPath("/mig/operacion/#LvarHtml#"))>
			<img src="/cfmx/sif/imagenes/findsmall.gif" style="cursor:pointer" alt="Ver Resumen" onclick="location.href='/cfmx/mig/operacion/<cfoutput>#LvarHtml#</cfoutput>';">
			Resumen de ultima carga de <strong>Indicadores</strong><BR>
		</cfif>
	</cfif>
</cfif>
