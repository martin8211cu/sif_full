<cf_htmlReportsHeaders 
	irA="diagnosticoDepartamento-filtro.cfm"
	FileName="diagnosticoDepartamento_#session.Usucodigo#.xls"
	method="url"
	title="#LB_Titulo#">

<cf_dbtemp name="tbl_trabajo1" returnvariable="tbl_trabajo" >
	<cf_dbtempcol name="DEid" 		type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="DCEid" 		type="numeric" 		mandatory="yes">
	<cf_dbtempcol name="DCEcodigo"	type="varchar(255)" mandatory="yes">		
	<cf_dbtempcol name="DCEvalor" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="IEfecha" 	type="date" 		mandatory="yes">
	<cf_dbtempcol name="Dcodigo" 	type="int"			mandatory="no">
</cf_dbtemp>

<!--- filtrar por ecodigo este y los demas reportes, pues si no sale lo de otras empresas aqui --->
<cfquery datasource="#session.DSN#" name="x">
	insert into #tbl_trabajo#(DEid,DCEid,DCEcodigo,DCEvalor,IEfecha) 

	select b.DEid, a.DCEid, c.DCEcodigo, c.DCEvalor, b.IEfecha
	from IncidenciasValores a, IncidenciasExpediente b, DConceptosExpediente c
	where a.IEid=b.IEid
	  and c.DCEid=a.DCEid
	  and a.DCEid is not null

	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and IEfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	<cfelseif isdefined("url.desde") and len(trim(url.desde))>
		and IEfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
		and IEfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	</cfif>
</cfquery>

 


<cfquery datasource="#session.DSN#">
	update #tbl_trabajo#
	set Dcodigo = 	(	select min(cf.Dcodigo)
						from LineaTiempo lt, RHPlazas p, CFuncional cf
						where lt.DEid=#tbl_trabajo#.DEid
						  and lt.LThasta = (  	select max(lt2.LThasta) 
						  						from LineaTiempo lt2 
												where lt2.DEid=lt.DEid )
						   and p.RHPid=lt.RHPid
						   and p.CFid=cf.CFid )
</cfquery>

<cfquery datasource="#session.DSN#" name="data">
	select Deptocodigo, Ddescripcion, DCEcodigo, DCEvalor, count(1) as cantidad
	from #tbl_trabajo# a, Departamentos d 
	where d.Dcodigo=a.Dcodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by Deptocodigo, Ddescripcion, DCEcodigo, DCEvalor
	order by Deptocodigo, Ddescripcion, DCEcodigo, DCEvalor
</cfquery>

<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<cfoutput>
	<tr>
		<td colspan="2" align="center"><strong style="font-size:16px;">#session.Enombre#</strong></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><strong style="font-size:14px;">#LB_Titulo#</strong></td>
	</tr>
	
	<tr>
		<td colspan="2" align="center">
			<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
				<strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Desde">Desde</cf_translate>:</strong> #LSDateFormat(url.Desde, 'dd/mm/yyyy')# <strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Hasta">Hasta</cf_translate>:</strong> #LSDateFormat(url.Hasta, 'dd/mm/yyyy')#
			<cfelseif isdefined("url.desde") and len(trim(url.desde))>
				<strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Desde">Desde</cf_translate>:</strong> #LSDateFormat(url.Desde, 'dd/mm/yyyy')#
			<cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
				<strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Hasta">Hasta</cf_translate>:</strong> #LSDateFormat(url.Hasta, 'dd/mm/yyyy')#
			</cfif>
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	</cfoutput>


	<cfif data.recordcount gt 0>
		<cfoutput query="data" group="Deptocodigo"  >
			<tr bgcolor="##CCCCCC">
				<td colspan="5"><strong>Departamento:</strong>&nbsp;#data.Deptocodigo# - #data.Ddescripcion#</td>
			</tr>
			<tr bgcolor="##EAEAEA">
				<td style="padding-left:10px;"><strong><cf_translate key="LB_Diagnostico">Diagn&oacute;stico</cf_translate></strong></td>
				<td align="center"><strong><cf_translate key="LB_Numero_de_casos">N&uacute;mero de casos</cf_translate></strong></td>
			</tr>
			
			<cfoutput>
			<tr>
				<td valign="top" style="padding-left:10px;">#data.DCEvalor#</td>
				<td valign="top"  align="center">#data.cantidad#</td>
			</tr>
			</cfoutput>
		<tr><td>&nbsp;</td></tr>
		</cfoutput>	
		<tr><td colspan="5" align="center">-<cf_translate xmlfile="/rh/generales.xml" key="MGS_FinDelReporte">Fin del reporte</cf_translate> -</td></tr>
	<cfelse>
		<tr><td colspan="5" align="center">---<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ---</td></tr>		
	</cfif>
</table>