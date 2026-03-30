<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDelEstadoDelEmpleado" Default="Reporte del Estado del Empleado" returnvariable="LB_ReporteDelEstadoDelEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!---
<cfoutput>
	select 	a.DEid,a.DEidentificacion, <br />
		   	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre,<br />
			(select EVfantig from EVacacionesEmpleado where DEid=b.DEid) as EVfantig,<br />
			b.ACAfechaIngreso,<br />
			(case when <cf_dbfunction name="to_char" args="b.ACAfechaEgreso"> = '61000101' then null else b.ACAfechaEgreso end) as ACAfechaEgreso,<br />
			(case when (  select 1<br />
					  	  from ACLineaTiempoAsociado<br />
					  	  where ACAid = b.ACAid<br />
					  	    and #LSDateFormat(now(), 'yyyymmdd')# between ACLTAfdesde and ACLTAfhasta ) is not null then 'Si' else 'No' end) as asociado<br />
	from DatosEmpleado a<br /><br />

	left join ACAsociados b<br />
		on b.DEid = a.DEid<br /><br />

	<!--- valida que el empleado este activo en la empresa --->
	<!---
	inner join LineaTiempo c
		on a.DEid = c.DEid
		and a.Ecodigo = c.Ecodigo
		and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
	--->		

	where a.Ecodigo = #session.Ecodigo#<br />
	<cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
		and a.DEid = #url.DEid#<br />
	</cfif>
	
	<!--- valida que el empleado sea un asociado activo --->
	<cfif isdefined("url.tipo") and url.tipo eq 2>
		and exists (  select 1<br />
					  from ACLineaTiempoAsociado<br />
					  where ACAid = b.ACAid<br />
					  and #LSDateFormat(now(), 'yyyymmdd')# between ACLTAfdesde and ACLTAfhasta )<br />
	</cfif>

	<!--- valida que la persona sea un empleado pero no un asociado --->
	<cfif isdefined("url.tipo") and url.tipo eq 3>
		and not exists (  select 1<br />
					  	  from ACLineaTiempoAsociado<br />
					  	  where ACAid = b.ACAid<br />
					  	    and #LSDateFormat(now(), 'yyyymmdd')# between ACLTAfdesde and ACLTAfhasta )<br />
	</cfif>
</cfoutput>	
<cfabort>
--->

<cfset formato = '112'>
<cfif Application.dsinfo[session.DSN].type is 'oracle'>
	<cfset formato = "'yyyymmdd'">
</cfif>
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 	a.DEid,a.DEidentificacion, 
		   	{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as nombre,
			(select EVfantig from EVacacionesEmpleado where DEid=b.DEid) as EVfantig,
			b.ACAfechaIngreso,
			(case when <cf_dbfunction name="to_char" args="b.ACAfechaEgreso,#PreserveSingleQuotes(formato)#"> = '61000101' then null else b.ACAfechaEgreso end) as ACAfechaEgreso,
			(case when (  select 1
					  	  from ACLineaTiempoAsociado
					  	  where ACAid = b.ACAid
					  	    and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between ACLTAfdesde and ACLTAfhasta ) is not null then 'Si' else 'No' end) as asociado
	from DatosEmpleado a

	left join ACAsociados b
		on b.DEid = a.DEid

	<!--- valida que el empleado este activo en la empresa --->
	<!---
	inner join LineaTiempo c
		on a.DEid = c.DEid
		and a.Ecodigo = c.Ecodigo
		and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
	--->		

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	
	<!--- valida que el empleado sea un asociado activo --->
	<cfif isdefined("url.tipo") and url.tipo eq 2>
		and exists (  select 1
					  from ACLineaTiempoAsociado
					  where ACAid = b.ACAid
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between ACLTAfdesde and ACLTAfhasta )
	</cfif>

	<!--- valida que la persona sea un empleado pero no un asociado --->
	<cfif isdefined("url.tipo") and url.tipo eq 3>
		and not exists (  select 1
					  	  from ACLineaTiempoAsociado
					  	  where ACAid = b.ACAid
					  	    and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between ACLTAfdesde and ACLTAfhasta )
	</cfif>
</cfquery>

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;
		height:20px}
	.detalle {
		font-size:14px;
		text-align:left;}
	.detaller {
		font-size:14px;
		text-align:right;}
	.detallec {
		font-size:14px;
		text-align:center;}	
</style>

<table width="800" align="center" border="0" cellspacing="2" cellpadding="0">
    <cfoutput>
    <tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
    <tr><td align="center" colspan="5" class="titulo_empresa2"><strong>#LB_ReporteDelEstadoDelEmpleado#</strong></td></tr>
    <tr><td colspan="5">&nbsp;</td></tr>
    <tr><td align="right" colspan="5" class="detaller"><strong>#LB_Fecha#:#LSDateFormat(now(),'dd/mm/yyyy')#</strong></td></tr>
	<tr><td colspan="5">&nbsp;</td></tr>
	<tr class="titulo_columnar">
		<td align="center" width="150"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
		<td align="center" width="250"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
		<td align="center" width="100"><cf_translate key="LB_Contratado">Contratado</cf_translate></td>
		<td align="center" width="100"><cf_translate key="LB_Asociado">Asociado</cf_translate></td>
		<td align="center" width="100"><cf_translate key="LB_IngresoSoli">Ingreso Soli</cf_translate></td>
		<td align="center" width="100"><cf_translate key="LB_SalidaSoli">Salida Soli</cf_translate></td>
	</tr>
	<cfloop query="rsReporte">
		<tr>
			<td align="center" class="detalle">#DEidentificacion#</td>
			<td align="center" class="detalle">#Nombre#</td>
			<td align="center" class="detallec"><cfif len(trim(EVfantig))>#LSDateFormat(EVfantig,'dd/mm/yyyy')#</cfif></td>
			<td align="center" class="detallec">#asociado#</td>
			<td align="center" class="detallec"><cfif len(trim(ACAfechaIngreso))>#LSDateFormat(ACAfechaIngreso,'dd/mm/yyyy')#</cfif></td>
			<td align="center" class="detallec"><cfif len(trim(ACAfechaEgreso))>#LSDateFormat(ACAfechaEgreso,'dd/mm/yyyy')#</cfif></td>
		</tr>
	</cfloop>
	</cfoutput>
</table>