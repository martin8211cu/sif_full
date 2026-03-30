<cfparam name="width" default="400">
<cfparam name="height" default="225">

<!---
<cfquery name="LineaTiempo" datasource="#Session.DSN#">
	select DEid, 
		   convert(varchar,LTdesde,103) as desde, 
		   (case LThasta when '61000101' then 'Indefinido' else convert(varchar,LThasta,103) end) as hasta
	from LineaTiempo
	where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.LTid#">
</cfquery>

<cfquery name="ComponentesSalariales" datasource="#Session.DSN#">
	select a.LTid, 
		   a.CSid, 
		   a.DLTmonto, 
		   b.CSdescripcion
	from DLineaTiempo a
	
	inner join ComponentesSalariales b
	on a.CSid = b.CSid
	
	where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.LTid#">
	order by DLTmonto desc
</cfquery>
--->

<cfquery name="LineaTiempo" datasource="#Session.DSN#">
	select DEid, 
		   LTdesde as desde, 
		   LThasta as hasta
	from LineaTiempo
	where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.LTid#">
</cfquery>

<cfquery name="ComponentesSalariales" datasource="#Session.DSN#">
	select a.LTid, 
		   a.CSid, 
		   a.DLTmonto, 
		   b.CSdescripcion
	from DLineaTiempo a
	
	inner join ComponentesSalariales b
	on a.CSid = b.CSid
	
	where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.LTid#">
	order by DLTmonto desc
</cfquery>

<cfquery name="rsMoneda" datasource="#session.DSN#">
	select a.Mcodigo, a.Mnombre, a.Miso4217
	from Monedas a
	 inner join Empresas e
	 on e.Mcodigo=a.Mcodigo
	 and e.Ecodigo= #session.Ecodigo#
</cfquery>

<html>
<head>
<title><cf_translate key="ComponentesSalariales">Componentes Salariales</cf_translate></title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
</head>
<body>
<!--- Bar chart, from DeptSalaries Query of Queries --->
<table width="90%" border="0" align="center">
  <tr>
    <td align="center">
		<cfset vFechaHasta = CreateDate('6100','01','01') >
		<div align="center"><strong><font size="4"><cf_translate key="GraficoDeComponentesSalariales">Gr&aacute;fico de Componentes Salariales</cf_translate><br> 
        <font size="3"><cf_translate key="Desde">Desde</cf_translate>:</font> <cfoutput><font size="3">#LSDateFormat(LineaTiempo.desde,'dd/mm/yyyy')#</font> &nbsp;&nbsp;&nbsp;<font size="3"><cf_translate key="Hasta">Hasta</cf_translate>:</font> <font size="3"><cfif LSDateFormat(LineaTiempo.hasta,'yyyymmdd') eq '61000101'>Indefinido<cfelse>#LSDateFormat(LineaTiempo.hasta,'dd/mm/yyyy')#</cfif></font></cfoutput></font></strong></div></td>
  </tr>
  <tr>
    <td nowrap align="center">
	<cfparam name="Form.DEid" default="#LineaTiempo.DEid#">
	<cfinclude template="/rh/portlets/pEmpleado.cfm">
		
	</td>
  </tr>

	<tr>
		<cfset salario = 0 >
		<cfoutput query="ComponentesSalariales">
			<cfset salario = salario + #ComponentesSalariales.DLTmonto#>
		</cfoutput>

		<td align="center"><font size="2"><b><cf_translate key="Salario">Salario</cf_translate>:&nbsp;<cfoutput>#LSNumberFormat(salario,'9,.00')#</cfoutput></b></font></td>
	</tr>

  <tr>
    <td nowrap align="center">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ComponenteSalarial"
			Default="Componente Salarial"
			returnvariable="LB_ComponenteSalarial"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Monto"
			Default="Monto"
			returnvariable="LB_Monto"/>			
			
			
		<cfchart 
			format="flash" 
			chartWidth="#width#" 
			chartHeight="#height#"
			scaleFrom=0 
			scaleTo=10 
			gridLines=3 
			labelFormat ="number"
			xAxisTitle="#LB_ComponenteSalarial#"
			yAxisTitle="#LB_Monto#"
			show3D="yes"
		>
			<cfchartseries 
				type="pie" 
				query="ComponentesSalariales" 
				valueColumn="DLTmonto" 
				itemColumn="CSdescripcion"
			/>
		</cfchart>

	</td>
  </tr>
  <tr>
    <td nowrap align="center"><em><b><cf_translate key="GraficoDeComponentesSalariales">Gr&aacute;fico de componentes salariales</cf_translate></b> <cfif rsMoneda.recordcount gt 0><br>Moneda de pago:<cfoutput>#rsMoneda.Miso4217# - #rsMoneda.Mnombre#</cfoutput></cfif>  </em></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
  <td align="center">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Imprimir"
	Default="Imprimir"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Imprimir"/>    
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Cerrar"/>    


	<cfoutput>
	<input type="button" value="#BTN_Imprimir#" name="Imprimir" onClick="javascript:window.print();">
    <input type="button" value="#BTN_Cerrar#" name="Cerrar" onClick="javascript:window.close();">
	</cfoutput>
    </td>
  </tr>
</table>

</body>
</html>
