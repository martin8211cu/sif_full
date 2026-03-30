<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.TDidlist") and len(trim(url.TDidlist))>
	<cfset form.TDidlist = url.TDidlist>
</cfif>
<cfif isdefined("url.CPid1") and len(trim(url.CPid1))>
	<cfset form.CPid1 = url.CPid1>
</cfif>
<cfif isdefined("url.CPid2") and len(trim(url.CPid2))>
	<cfset form.CPid2 = url.CPid2>
</cfif>
<cfif isdefined("url.TipoNomina") and len(trim(url.TipoNomina))>
	<cfset form.TipoNomina = url.TipoNomina>
</cfif>

<cfset vs_tablaCalculo = 'HRCalculoNomina'>
<cfset vs_tablaDeducciones = 'HDeduccionesCalculo'>
	
<cfif not isdefined("form.TipoNomina")>
	<cfset vs_tablaCalculo = 'RCalculoNomina'>
	<cfset vs_tablaDeducciones = 'DeduccionesCalculo'>	
</cfif>

<cfquery name="rsDeducciones" datasource="#session.DSN#">
	select 	<cf_dbfunction name="to_number" args="sum(floor(d.DCvalor*100)),0"> as Monto
			<!----convert(numeric,sum(floor(d.DCvalor*100)),0) as Monto---->
			,sum(d.DCvalor)  as MontoB	
			,d.DEid
			,f.DEidentificacion
			,<cf_dbfunction name="concat" args="f.DEapellido1,' ',f.DEapellido2,' ',f.DEnombre"> as Nombre
			,a.CPperiodo
			,a.CPmes
	from CalendarioPagos a
		inner join #vs_tablaCalculo# b
			on a.CPid = b.RCNid
		inner join HSalarioEmpleado c
			on b.RCNid = c.RCNid
		inner join #vs_tablaDeducciones# d
			on c.RCNid = d.RCNid
			and c.DEid = d.DEid
		inner join DeduccionesEmpleado e
			on d.Did = e.Did
			and d.DEid = e.DEid
			and TDid in (#form.TDidlist#)
		inner join DatosEmpleado f
			on d.DEid = f.DEid
	where 1 = 1
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
			and a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and a.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
		</cfif>	
		<cfif isdefined("form.CPid1") and len(trim(form.CPid1))>
			and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid1#">
		<cfelseif isdefined("form.CPid2") and len(trim(form.CPid2))>
			and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid2#">
		</cfif>
	group by d.DEid
			,f.DEidentificacion
			,<cf_dbfunction name="concat" args="f.DEapellido1,' ',f.DEapellido2,' ',f.DEnombre">
			,a.CPperiodo
			,a.CPmes
</cfquery>
<cfset hilera = ''>
<cfoutput query="rsDeducciones">
	<cfif len(trim(rsDeducciones.DEidentificacion)) LT 10>
		<cfset hilera = hilera & RepeatString('0', 10-(len(trim(rsDeducciones.DEidentificacion)))) & '#trim(rsDeducciones.DEidentificacion)#'>
	<cfelse>
		<cfset hilera = hilera & '#mid(trim(rsDeducciones.DEidentificacion),1,10)#'>
	</cfif>
	<cfif len(trim(rsDeducciones.Nombre)) LT 30>
		<cfset hilera = hilera & '#trim(rsDeducciones.Nombre)#' & RepeatString(' ', 30-(len(trim(rsDeducciones.Nombre))))>
	<cfelse>
		<cfset hilera = hilera & '#mid(trim(rsDeducciones.Nombre),1,30)#'>
	</cfif>
	
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<!----<cfset hilera = hilera & '#trim(form.Periodo)#'& IIf(len(trim(form.Mes)) LT 2,'0','') & '#trim(form.Mes)#'>---->
		<cfif len(trim(form.Mes)) LT 2>
			<cfset hilera = hilera & '#trim(form.Periodo)#0#trim(form.Mes)#'>
		<cfelse>
			<cfset hilera = hilera & '#trim(form.Periodo)##trim(form.Mes)#'>
		</cfif>		
	<cfelseif len(trim(rsDeducciones.CPperiodo)) and len(trim(rsDeducciones.CPmes))>
		<cfset hilera = hilera & '#trim(rsDeducciones.CPperiodo)#'& IIf(len(trim(rsDeducciones.CPmes)) LT 2,'0','""') & '#trim(rsDeducciones.CPmes)#'>
	<cfelse>
		<cfset hilera = hilera & RepeatString(' ',6)>
	</cfif>
	
	<cfif len(trim(rsDeducciones.Monto)) and rsDeducciones.Monto EQ 0>
		<cfset hilera = hilera & RepeatString('0',8)>
	<cfelseif len(trim(rsDeducciones.Monto)) LT 8>
		<cfset hilera = hilera & RepeatString('0', 8-(len(trim(rsDeducciones.Monto)))) & '#trim(rsDeducciones.Monto)#'>
	<cfelse>
		<cfset hilera = hilera & '#mid(trim(rsDeducciones.Monto),1,8)#'>
	</cfif>
	
	<cfset hilera = hilera & '#chr(13)##chr(10)#'>
</cfoutput>


<!----================ GENERA EL ARCHIVO TXT ================---->
<cfif isdefined("url.Generar")>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'DeducBPopular')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=DeduccionesBPopular.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
</cfif>
<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesDelBancoPopular" Default="Reporte de deducciones del Banco Popular" returnvariable="LB_ReporteDeDeduccionesDelBancoPopular"/>	
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeDeduccionesDelBancoPopular#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">				
			<cfinclude template="repDeduccionesBancoPopular-rep.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>