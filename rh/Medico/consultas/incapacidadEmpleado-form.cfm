<cf_htmlReportsHeaders 
	irA="incapacidadEmpleado-filtro.cfm"
	FileName="incapacidadEmpleado_#session.Usucodigo#.xls"
	method="url"
	title="#LB_Titulo#">

<cf_dbtemp name="tbl_trabajo_2" returnvariable="tbl_trabajo">
	<cf_dbtempcol name="DEid" 				type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="DEidentificacion" 	type="varchar(60)" 	mandatory="yes">
	<cf_dbtempcol name="DEnombre"			type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="fecha_desde"		type="datetime"		mandatory="no">
	<cf_dbtempcol name="fecha_hasta"		type="datetime"		mandatory="no">
	<cf_dbtempcol name="etiqueta"			type="varchar(255)"	mandatory="no">	
	<cf_dbtempcol name="valor"				type="text"			mandatory="no">
	<cf_dbtempcol name="Dcodigo"			type="int"			mandatory="no">
</cf_dbtemp>

<!--- Tipo de Formato por Expediente --->
<cfset v_EFEid = 0 >
<cfquery name="rs_parametro_930" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 930
</cfquery>
<cfif len(trim(rs_parametro_930.Pvalor))>
	<cfset v_EFEid = rs_parametro_930.Pvalor >
</cfif>

<cfquery datasource="#session.DSN#">
	insert into #tbl_trabajo#(DEid, DEidentificacion, DEnombre, fecha_desde, fecha_hasta, etiqueta, valor)
	select 	c.DEid, 
			de.DEidentificacion, 
			<cf_dbfunction name="concat" args="de.DEapellido1|' '|de.DEapellido2|', '|de.DEnombre" delimiters="|">,
			c.IEdesde, 
			c.IEhasta, 
			b.DFEetiqueta, 
			a.IVvalor

	from IncidenciasValores a, DFormatosExpediente b, IncidenciasExpediente c, DatosEmpleado de

	where b.DFElinea = a.DFElinea
	  and c.IEid = a.IEid
	  and c.RHTid is not null
	  and b.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_EFEid#">
	  and a.DFElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DFElinea#">	<!--- combo para seleccionar esto desde filtros --->
	  and de.DEid=c.DEid
	  
	  <cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and c.IEhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
		and c.IEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	  <cfelseif isdefined("url.desde") and len(trim(url.desde))>
	  	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> between c.IEdesde and c.IEhasta
	  <cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
	  	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#"> between c.IEdesde and c.IEhasta
	  </cfif>
	 
	 <cfif isdefined("url.DEid") and len(trim(url.DEid)) >
	 	and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	 </cfif>
	 
	order by de.DEidentificacion
</cfquery>

<cfif isdefined("url.depto")>
	<cfquery datasource="#session.DSN#">
		update #tbl_trabajo#
		set Dcodigo = ( select cf.Dcodigo 
						from LineaTiempo lt, RHPlazas p, CFuncional cf
						where lt.DEid=#tbl_trabajo#.DEid
						   and p.RHPid=lt.RHPid
						  and cf.CFid=p.CFid
						  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta )
	</cfquery>

	<cfquery name="data" datasource="#session.DSN#">
		select Deptocodigo, d.Ddescripcion, a.DEid, a.DEidentificacion, a.DEnombre, a.fecha_desde, a.fecha_hasta, a.etiqueta, a.valor
		from #tbl_trabajo# a, Departamentos d
		where d.Dcodigo = a.Dcodigo
		  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by d.Deptocodigo, d.Ddescripcion, a.DEidentificacion
	</cfquery>
<cfelse>
	<cfquery name="data" datasource="#session.DSN#">
		select Dcodigo as Deptocodigo, DEid, DEidentificacion, DEnombre, fecha_desde, fecha_hasta, etiqueta, valor
		from #tbl_trabajo#
		order by DEidentificacion
	</cfquery>
</cfif>

<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<cfoutput>
	<tr>
		<td colspan="5" align="center"><strong style="font-size:16px;">#session.Enombre#</strong></td>
	</tr>
	<tr>
		<td colspan="5" align="center"><strong style="font-size:14px;">#LB_Titulo#</strong></td>
	</tr>
	
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<tr><td colspan="5" align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Empleado">Empleado</cf_translate>:</strong> #data.DEidentificacion# - #data.DEnombre#</td></tr>	
	</cfif>

	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		<tr><td colspan="5" align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Desde">Desde</cf_translate>:</strong> #LSDateFormat(url.Desde, 'dd/mm/yyyy')# <strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Hasta">Hasta</cf_translate>:</strong> #LSDateFormat(url.Hasta, 'dd/mm/yyyy')#</td></tr>
	<cfelseif isdefined("url.desde") and len(trim(url.desde))>
		<tr><td colspan="5" align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Desde">Desde</cf_translate>:</strong> #LSDateFormat(url.Desde, 'dd/mm/yyyy')#</td></tr>
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
		<tr><td colspan="5" align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Hasta">Hasta</cf_translate>:</strong> #LSDateFormat(url.Hasta, 'dd/mm/yyyy')#</td></tr>
	</cfif>
	
	<tr><td>&nbsp;</td></tr>
	</cfoutput>

	<cfif data.recordcount gt 0>
		<cfoutput query="data" group="Deptocodigo">
			<cfif isdefined("url.depto")>
				<tr><td>&nbsp;</td></tr>
				<tr bgcolor="##CCCCCC">
					<td colspan="5"><strong>Departamento:</strong>&nbsp;#data.Deptocodigo# - #data.Ddescripcion#</td>
				</tr>
			</cfif>

			<tr bgcolor="##EAEAEA">
				<td style="padding-left:10px;"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
				<td nowrap="nowrap"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Nombre">Nombre</cf_translate></strong></td>
				<td><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Desde">Desde</cf_translate></strong></td>
				<td><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Hasta">Hasta</cf_translate></strong></td>
				<td><strong>#data.etiqueta#</strong></td>
			</tr>
			
			<cfoutput>
			<tr>
				<td valign="top" style="padding-left:10px;">#data.DEidentificacion#</td>
				<td valign="top" nowrap="nowrap">#data.DEnombre#</td>
				<td valign="top">#LSDateFormat(data.fecha_desde, 'dd/mm/yyyy')#</td>
				<td valign="top">#LSDateFormat(data.fecha_hasta, 'dd/mm/yyyy')#</td>
				<td valign="top">#data.valor#</td>
			</tr>
			</cfoutput>
		</cfoutput>	
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="5" align="center">-<cf_translate xmlfile="/rh/generales.xml" key="MGS_FinDelReporte">Fin del reporte</cf_translate> -</td></tr>
	<cfelse>
		<tr><td colspan="5" align="center">---<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ---</td></tr>		
	</cfif>
</table>