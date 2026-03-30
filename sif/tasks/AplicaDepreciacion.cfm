<cfapplication 
sessionmanagement="Yes"
name="SIF_ASP">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Aplica Depreciación</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<cfset start = Now()>
Iniciando proceso <cfoutput> #TimeFormat(start,"HH:MM:SS")#</cfoutput><br>
<cfquery name="Caches" datasource="asp">
	select distinct c.Ccache, e.Ereferencia
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SIF'
		and m.SMcodigo = 'AF'
		and e.Ereferencia is not null
</cfquery>
<cfloop query="Caches">
	<cfset lecodigo = Caches.Ereferencia>
	<cfset lcache = Caches.Ccache>
	<cftry>
			<br>
			<cfoutput>
			<h1>#Caches.CurrentRow#</h1>
			Cache: #Caches.Ccache#<br>
			Ecodigo: #Caches.Ereferencia#<br>
			</cfoutput>
		<cfset Procesos = QueryNew("")>
		<cfquery name="Procesos" datasource="#Ccache#">
			select AGTPid, Usucodigo
			from AGTProceso
			where Ecodigo = #Caches.Ereferencia#
			and AGTPestadp = 2
			and IDtrans = 4
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> > AGTPfechaprog 
		</cfquery>
		<cfset lusuario = 0>
		<cfif len(trim(Procesos.Usucodigo))>
			<cfquery name="rsUsuario" datasource="asp">
				select Usulogin as usuario
				from Usuario 
				where Usucodigo = #Procesos.Usucodigo#
			</cfquery>
			<cfif rsUsuario.Recordcount>
				<cfset lusuario = rsUsuario.usuario>
			</cfif>
		</cfif>
		<cfset ArrResults = ArrayNew(1)>
		<cfloop query="Procesos">
			<cfset lagtpid = Procesos.AGTPid>
			<cfoutput>AGTPid: #Procesos.AGTPid#</cfoutput><br>
			<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacion" method="AF_ContabilizarDepreciacion" returnvariable="AGTPid">
				<cfinvokeargument name="AGTPid" value="#lagtpid#">
				<cfinvokeargument name="Ecodigo" value="#lecodigo#">
				<cfinvokeargument name="Conexion" value="#lcache#">
				<cfinvokeargument name="Usuario" value="#lusuario#">
				<cfinvokeargument name="debug" value="false">
			</cfinvoke>
			<cfset lostResult = ArrayAppend(ArrResults,AGTPid)>
		</cfloop>
		<!--- Generados: [<cfoutput>#ArrayToList(ArrResults)#</cfoutput>]<br>
		<cfif ArrayLen(ArrResults)>
			<cfquery datasource="#Ccache#" name="agtp">
				select *
				from AGTProceso
				where AGTPid in (#ArrayToList(ArrResults)#)
			</cfquery>
			<cfquery datasource="#Ccache#" name="adtp">
				select AGTPid,  count(1) as detalles
				from ADTProceso
				where AGTPid in (#ArrayToList(ArrResults)#)
				group by AGTPid
			</cfquery>
			<cfdump var="#agtp#" label="AGTProceso">
			<cfdump var="#adtp#" label="ADTProceso">
		</cfif>
		Total Generados: <cfoutput>#ArrayLen(ArrResults)#</cfoutput><br> --->
		<cfcatch>
			Ocurrió un Error en el Cache <cfoutput>#Caches.Ccache#.</cfoutput><br>
			Error: <cfoutput>#cfcatch.Message#</cfoutput>
		</cfcatch>
	</cftry>
</cfloop>
<cfset finish = Now()>
<br><br>Proceso Terminado<cfoutput> #TimeFormat(finish,"HH:MM:SS")#</cfoutput><br>

</body>
</html>