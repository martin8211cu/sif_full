<cfapplication name="SIF_ASP" sessionmanagement="true">
<cfsetting requesttimeout="3600">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Agrupa y Procesa Marcas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
<cfquery name="Caches" datasource="asp">
	select distinct c.Ccache, e.Ereferencia
	from Empresa e, ModulosCuentaE m, Caches c
	where c.Cid = e.Cid
	  and m.CEcodigo = e.CEcodigo
	  and m.SScodigo = 'RH'
	  and m.SMcodigo = 'MARCAS'
	  and e.Ereferencia is not null
</cfquery>
<cfloop query="Caches">
	<cfset lecodigo = Caches.Ereferencia>
	<cfset lcache = Caches.Ccache>
	<cfset lusucodigo = 0>
	<cftry>
		<br>
		<cfoutput>
		<h1>#Caches.CurrentRow#</h1>
		Cache: #Caches.Ccache#<br>
		Ecodigo: #Caches.Ereferencia#<br>
		</cfoutput>
		<cfset Procesos = QueryNew("")>
			<cfset Session.Ecodigo = Caches.Ereferencia>
			<cfset Session.dsn = Caches.Ccache>
			<cfset Session.Usulogin = ''>
			<cfinvoke component="sif.rh.Componentes.RH_ProcesoAgrupaMarcas" method="RH_ProcesoAgrupaMarcas">
				<cfinvokeargument name="Ecodigo" value="#lecodigo#">
				<cfinvokeargument name="Conexion" value="#lcache#">
				<cfinvokeargument name="Usucodigo" value="#lusucodigo#">
			</cfinvoke>
		<cfcatch>
			Ocurrió un Error en el Cache <cfoutput>#Caches.Ccache#.</cfoutput><br>
			Error: <cfoutput>#cfcatch.Message#.</cfoutput>
		</cfcatch>
	</cftry>
</cfloop>
<cfset finish = Now()>
<br><br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>

</body>
</html>