<cfsetting enablecfoutputonly="no" showdebugoutput="no">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">

<cffunction name="show_date">
	<cfoutput>@ #Now()# #RepeatString(' ', 2000)#<br></cfoutput>
	<cfflush>
</cffunction>
<html><head><title>Tareas de tasación</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfoutput>
Comienza tarea... #show_date()#
<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
dsinfo ok ... #show_date()#
<cfquery datasource="asp" name="empresas">
	select distinct c.Ccache
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SACI'
	and Ereferencia is not null
</cfquery>
Caches leídos ... #show_date()#
<cfdump var="#empresas#">
<cfloop query="empresas">
	<cftry>
		Datasource: #empresas.Ccache# @ #show_date()#
		<cfif Not StructKeyExists(Application.dsinfo, empresas.Ccache)>
			Datasource #empresas.Ccache# no existe.
		<cfelse>
			<cfinvoke component="saci.comp.tasacion" method="getConfig"
				datasource="#empresas.Ccache#"
				hostname="#hostname#"
				returnvariable="config"/>
			<cfdump var="#config#" label="configuracion getConfig(#empresas.Ccache#,#hostname#)" >
			
			<!---
				Ver si hay un proceso disponible e iniciarlo
				Si no lo hay, y faltan trabajadores, agregarlo.
			--->
			<cfset el_servicio = ''>
			<cfset cant_trabajadores = 0>
			<cfquery datasource="#empresas.Ccache#" name="trabajadores_activos">
				select count(1) as cant
				from ISBtasarStatus
				where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">
				  and (estado not in ('stopped', 'runnable')
				  and horaReporte > dateadd(mi, -5, getdate()) )
			</cfquery>
			Trabajadores activos en #empresas.Ccache#: #trabajadores_activos.cant#, configurados: #config.procesos# #show_date()#
			<cfif (trabajadores_activos.cant LT config.procesos) OR IsDefined('url.force')>
				Iniciando trabajador... #show_date()#
				<cfquery datasource="#empresas.Ccache#" name="descansando" maxrows="1">
					select servicio
					from ISBtasarStatus
					where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">
					  and (estado in ('stopped', 'runnable')
					  or horaReporte <= dateadd(mi, -5, getdate()) )
				</cfquery>
				<cfif descansando.RecordCount>
					<cfdump var="#descansando#" label="descanso">
					<cfset el_servicio = descansando.servicio>
					Trabajador descansando ... usar #el_servicio# #show_date()#
				<cfelse>
					<cfquery datasource="#empresas.Ccache#" name="duplicados">
						select servicio
						from ISBtasarStatus
						where hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hostname#">
					</cfquery>
					<cfset duplicados = ValueList(duplicados.servicio)>
					<cfloop from="1" to="999" index="i">
						<cfset el_servicio = LCase(hostname) & '-' & empresas.Ccache & '-' & NumberFormat( i, '000')>
						<cfif Not ListFindNoCase(duplicados, el_servicio)>
							<cfbreak>
						</cfif>
					</cfloop>
					Nuevo trabajador...start #el_servicio# (activos=#duplicados#) #show_date()#
					<cfinvoke component="saci.comp.tasacion"
						method="start"
						datasource="#empresas.Ccache#"
						servicio="#el_servicio#">
				</cfif>
			
				Ejecutando trabajador...run #el_servicio# @ #show_date()#
	
				<cfinvoke component="saci.comp.tasacion"
					method="run"
					datasource="#empresas.Ccache#"
					servicio="#el_servicio#">
				</cfinvoke>
	
				Trabajo completado #el_servicio# @ #show_date()#
				<cfbreak>
			<cfelse>
				No se requieren más trabajadores @ #show_date()#
			</cfif>
		</cfif>
		
		<cfcatch type="any">
			<cflog file="isb_tasacion" text="tasacion::task #cfcatch.Message# #cfcatch.Detail#">
			<!---<div style="color:red">Error en tasacion: #cfcatch.Message# #cfcatch.Detail#</div>--->
			<cfrethrow>
		</cfcatch>
		
	</cftry>

</cfloop>
Tarea terminada #show_date()#
</cfoutput>
</body></html>