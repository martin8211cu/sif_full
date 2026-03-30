<cfsetting requesttimeout="3600">
<!--- maximo una hora por script --->
<cfparam name="form.num_tarea" type="numeric">
<cfif Not IsDefined('form.force')>
	<cfquery datasource="asp" name="siguiente" maxrows="1">
		select num_tarea
		from APTareas
		where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		  and (inicio is null or fin is null)
		order by num_tarea asc
	</cfquery>
	
	<cfif form.num_tarea NEQ siguiente.num_tarea>
		<cfthrow message="La tarea #form.num_tarea# no es la siguiente.  La siguiente es #siguiente.num_tarea#">
	</cfif>
</cfif>
<cfquery datasource="asp" name="last_msg">
	select coalesce (max (num_msg), 0) as last_msg
	from APMensajes
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
</cfquery>


<cfquery datasource="asp" name="seleccionada">
	select num_tarea,tipo,ruta,datasource,inicio,fin
	from APTareas
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	  and num_tarea = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.num_tarea#">
	order by num_tarea asc
</cfquery>
<cfif IsDefined('form.omitir')>
	<cfset QuerySetCell(seleccionada,'tipo', 'omite')>
</cfif>
<cfinvoke component="asp.parches.comp.ejecutor_#seleccionada.tipo#"
	method="ejecuta"
	num_tarea="#seleccionada.num_tarea#"
	ruta="#seleccionada.ruta#"
	datasource="#seleccionada.datasource#" />
	
<cfquery datasource="asp" name="hay_errores">
	select count(1) as cuantos
	from APMensajes
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	  and num_msg > <cfqueryparam cfsqltype="cf_sql_integer" value="#last_msg.last_msg#">
	  and severidad > 0 <!--- -1=DEBUG, 0=INFO, 1=WARN, 2=ERROR --->
</cfquery>


<cfquery datasource="asp" name="siguiente" maxrows="1">
	select num_tarea
	from APTareas
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	  and (inicio is null or fin is null)
	order by num_tarea asc
</cfquery>

<cfset session.instala.ejecutado = Len(siguiente.num_tarea) NEQ 0>

<cfparam name="form.verlog" default="S">
<cfset session.instala.verlog = form.verlog>
<cfif form.verlog EQ 'S' or hay_errores.cuantos>
	<cflocation url="ejecuta-resultado.cfm?num_tarea=#form.num_tarea#&from=#last_msg.last_msg+1#">
<cfelse>
	<cflocation url="ejecuta.cfm">
</cfif>
