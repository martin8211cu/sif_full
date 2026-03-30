<cfapplication name="SIF_ASP" sessionmanagement="true">
<cfsetting requesttimeout="18000">
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
	<cftry>
		<hr>
		<cfoutput>
			<h1>#Caches.CurrentRow#</h1>
			Cache: #Caches.Ccache#<br>
			Ecodigo: #Caches.Ereferencia#<br>
		</cfoutput>
		<cfset lecodigo = Caches.Ereferencia>
		<cfset lcache = Caches.Ccache>
		<!--- El siguiente código no debería estar pero habría que cavar profundo en toda la 
		cadena de invocaciones de los componentes a ver cual utiliza un link directo. (mft)  --->
		<cfset Session.Ecodigo = Caches.Ereferencia>
		<cfset Session.Dsn = Caches.Ccache>
		<cfset Session.Usucodigo = 0>
		<cfset Session.Usulogin = ''>
		<cfquery name="Feriados" datasource="#lcache#">
			select a.RHFid, a.RHFdescripcion, a.RHFfecha
				from RHFeriados a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lecodigo#">
					and a.RHFpagooblig = 1
					and <cf_dbfunction name="to_datechar" args="a.RHFfecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		</cfquery>
		<cfloop query="Feriados">
			<cfoutput>Generando Feriado #RHFdescripcion#(#RHFfecha#)...<br></cfoutput>
			<cfset lRHFid = Feriados.RHFid>
				<cfset Procesos = QueryNew("")>
					<cfinvoke component="sif.rh.Componentes.RH_ProcesoGeneraMarcas" method="RH_ProcesoGeneraFeriados">
						<cfinvokeargument name="RHFid" value="#lRHFid#">
						<cfinvokeargument name="Ecodigo" value="#lecodigo#">
						<cfinvokeargument name="Conexion" value="#lcache#">
						<cfinvokeargument name="Usucodigo" value="0">
					</cfinvoke>
		</cfloop>
	<cfcatch>
		Ocurrió un Error en el Cache <cfoutput>#Caches.Ccache#. Error: </cfoutput>{<cfoutput>#cfcatch.Message#.</cfoutput>}<br>
	</cfcatch>
	</cftry>
</cfloop>
<cfset finish = Now()>
<br><br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>

</body>
</html>