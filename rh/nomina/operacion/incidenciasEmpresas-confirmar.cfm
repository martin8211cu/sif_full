<cfquery name="rsTotal" datasource="#session.DSN#">
	select coalesce(count(1),0) as total

	<cfif isdefined("url.tipo") and url.tipo eq 'A'>
		from SalarioEmpleado se
	<cfelse>
		from HSalarioEmpleado se
	</cfif>	
	
	inner join DatosEmpleadoCorp dec
	on dec.DEid=se.DEid
	and dec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoOrigen#">
	
	where se.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and exists(  select 1 
				 from DatosEmpleadoCorp se2
				 where se2.DEidcorp=dec.DEidcorp
				   and se2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) 
</cfquery>
<cfset vCantidad = rsTotal.total >
<cfif rsTotal.recordcount eq 0 >
	<cfset vCantidad = 0 >
</cfif>

<cfquery name="rsMonto" datasource="#session.DSN#">
	select sum((((se.SEsalariobruto ))/<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#replace(url.tipo_cambio,',','','all')#">)) as monto

	<cfif isdefined("url.tipo") and url.tipo eq 'A'>
		from SalarioEmpleado se
	<cfelse>
		from HSalarioEmpleado se
	</cfif>	
	
	inner join DatosEmpleadoCorp dec
	on dec.DEid=se.DEid
	and dec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoOrigen#">
	
	where se.RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and exists(  select 1 
				 from DatosEmpleadoCorp se2
				 where se2.DEidcorp=dec.DEidcorp
				   and se2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> ) 
</cfquery>

<cfquery name="rsMoneda" datasource="#session.DSN#">
	select a.Mcodigo, m.Mnombre, m.Miso4217
	from Empresas a 
	
	inner join Monedas m
	on m.Mcodigo = a.Mcodigo
	and m.Ecodigo = a.Ecodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
</cfquery>

<cftransaction >

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_template>
	<cf_templatearea name="title"> <cfoutput>#nav__SPdescripcion#</cfoutput> </cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"><cfoutput>#pNavegacion#</cfoutput>

<cfoutput>
<table width="70%" cellpadding="3" cellspacing="0" align="center">

	<tr><td></td></tr>
	
	<cfif isdefined("url.error")>
		<tr><td align="center"><strong><cf_translate key="Nombre_Proceso" xmlfile="incidenciasEmpresas.xml">Proceso de Movimiento de Incidencias entre Empresas cancelado.</cf_translate></strong></td></tr>
		<tr><td align="center"><cf_translate key="Error_Registros_Existen" xmlfile="incidenciasEmpresas.xml">Ya existen registros para la relaci&oacute;n de n&oacute;mina y concepto incidente seleccionados.</cf_translate></td></tr>
	<cfelse>
		<tr><td align="center"><strong><cf_translate key="Proceso_Finalizado" xmlfile="incidenciasEmpresas.xml">Proceso de Movimiento de Incidencias entre Empresas finalizado.</cf_translate></strong></td></tr>
		<tr><td align="center"><cf_translate key="MSG_Cantidad_de_movimientos_realizados">Cantidad de movimientos realizados</cf_translate>: #LSNumberFormat(vCantidad, ',9.00')# </td></tr>
		<tr><td align="center"><cf_translate key="MSG_Monto_total">Monto total</cf_translate>: #rsMoneda.Miso4217# #LSNumberFormat(rsMonto.monto, ',9.00')# (Moneda: #rsMoneda.Mnombre#)</td></tr>
	</cfif>

	<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="Regresar"/>

	<tr><td align="center"><input type="button" name="Regresar" value="#Regresar#" class="btnAnterior" onClick="javascript:location.href='/cfmx/rh/nomina/operacion/incidenciasEmpresas.cfm'" tabindex="2"></td></tr>
	<tr><td>&nbsp;</td></tr>

</table>	

</cfoutput>			
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
