<cfparam name="width" default="400">
<cfparam name="height" default="225">

<cfif isdefined("url.RHLTPfdesde") and len(trim(url.RHLTPfdesde)) neq 0 and isdefined("url.RHPPid") and len(trim(url.RHPPid)) neq 0>
	
	<cfquery name="idLineaTiempo" datasource="#Session.DSN#">
		select RHLTPid, RHLTPfdesde
		from RHLineaTiempoPlaza
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and RHPPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPPid#">
			and RHLTPfhasta = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSDateFormat(url.RHLTPfdesde,'mm,dd,yyyy')#">
	</cfquery>
	
	<cfif isdefined("idLineaTiempo.RHLTPid") and len(trim(idLineaTiempo.RHLTPid))neq 0>
		<cfset Url.RHLTPid=idLineaTiempo.RHLTPid>
	</cfif>
	
</cfif>

<cfquery name="LineaTiempo" datasource="#Session.DSN#">
	select 
			a.RHLTPfdesde as desde, 
		   	a.RHLTPfhasta as hasta,
		   	a.RHPPid, 
		   	b.RHPPcodigo, 
		   	b.RHPPdescripcion
	from 
		RHLineaTiempoPlaza a
		
		inner join RHPlazaPresupuestaria b
			on b.Ecodigo=a.Ecodigo
			and b.RHPPid=a.RHPPid
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and a.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.RHLTPid#">
</cfquery>

<cfquery name="ComponentesSalariales" datasource="#Session.DSN#">
	
	select 
		a.RHLTPid , 
		a.RHLTPmonto,
		b.Monto,
		c.CSid,  
		c.CSdescripcion 
			
	from RHLineaTiempoPlaza a
	
		inner join RHCLTPlaza b
		on  b.Ecodigo = a.Ecodigo
		and b.RHLTPid = a.RHLTPid
		
		inner join ComponentesSalariales c
		on  c.Ecodigo = a.Ecodigo
		and c.CSid = b.CSid
		
	where  a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.RHLTPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.RHLTPid#">
		
</cfquery>

<html>
<head>
<title>Componentes Salariales</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
</head>
<body>
<!--- Bar chart, from DeptSalaries Query of Queries --->
<table width="90%" border="0" align="center">
  <tr>
    <td align="center">
		<br>
		<cfset vFechaHasta = CreateDate('6100','01','01') >
		<div align="center"><strong><font size="4">Gr&aacute;fico de Componentes Salariales<br> 
        <font size="3">Desde:</font> <cfoutput><font size="3">#LSDateFormat(LineaTiempo.desde,'dd/mm/yyyy')#</font> &nbsp;&nbsp;&nbsp;<font size="3">Hasta:</font> <font size="3"><cfif LSDateFormat(LineaTiempo.hasta,'yyyymmdd') eq '61000101'>Indefinido<cfelse>#LSDateFormat(LineaTiempo.hasta,'dd/mm/yyyy')#</cfif></font></cfoutput></font></strong></div></td>
  </tr>
  <tr>
    <td nowrap align="center">
		<br>
		<cf_web_portlet_start titulo="Plaza Presupuestaria" border="true" skin="#Session.Preferences.Skin#">
			<table cellpadding="3" cellspacing="3">
				<tr>
					<td><strong>Código:</strong></td>
					<td>&nbsp;&nbsp;<cfoutput>#LineaTiempo.RHPPcodigo#</cfoutput></td>
				</tr>
				<tr>
					<td><strong>Descripción:</strong></td>
					<td>&nbsp;&nbsp;<cfoutput>#LineaTiempo.RHPPdescripcion#</cfoutput></td>
				</tr>
			</table>
		<cf_web_portlet_end> 	
	</td>
  </tr>

	<tr>
		<cfset salario = 0 >
		<cfoutput query="ComponentesSalariales">
			<cfset salario = salario + #ComponentesSalariales.Monto#>
		</cfoutput>

		<td align="center"><font size="2"><b>Salario:&nbsp;<cfoutput>#LSNumberFormat(salario,'9,.00')#</cfoutput></b></font></td>
	</tr>

  <tr>
    <td nowrap align="center">

		<cfchart 
			format="flash" 
			chartWidth="#width#" 
			chartHeight="#height#"
			scaleFrom=0 
			scaleTo=10 
			gridLines=3 
			labelFormat ="currency"
			xAxisTitle="Componente Salarial"
			yAxisTitle="Monto"
			show3D="yes"
		>
			<cfchartseries 
				type="pie" 
				query="ComponentesSalariales" 
				valueColumn="Monto" 
				itemColumn="CSdescripcion"
			/>
		</cfchart>

	</td>
  </tr>
  <tr>
    <td nowrap align="center"><em>Gr&aacute;fico de componentes salariales</em></td>
  </tr>
  <tr>
  <td align="center"><input type="button" value="Imprimir" name="Imprimir" onClick="javascript:window.print();">
    <input type="button" value="Cerrar" name="Cerrar" onClick="javascript:window.close();">
    </td>
  </tr>
</table>

</body>
</html>
