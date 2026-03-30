<cfsetting enablecfoutputonly="no">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">
<cferror type="validation" template="/home/public/error/handler.cfm">
<cferror type="request" template="/home/public/error/handler.cfm">

<cfset ini = Now()>

<cfset session.ecodigo=1>
<cfset session.usucodigo=27>
<cfset session.usuario='marcel'>
<cfset session.CEcodigo=15>

<!---
<cfinvoke component="sif.rh.indicadores.vacaciones"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2004,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="vacaciones"
></cfinvoke>

<cfinvoke component="sif.rh.indicadores.incapacidad"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2004,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="incapacidades"
></cfinvoke>
--->

<cfinvoke component="sif.rh.indicadores.salarios-p25"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2005,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="salarios025" >
</cfinvoke>

<cfinvoke component="sif.rh.indicadores.salarios-p2550"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2005,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="salarios2550" >
</cfinvoke>

<cfinvoke component="sif.rh.indicadores.salarios-p5075"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2005,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="salarios5075" >
</cfinvoke>

<cfinvoke component="sif.rh.indicadores.salarios-p75"
	method="calcular"
	datasource="minisif"
	Ecodigo="1"
	CEcodigo="15"
	fecha_desde="#CreateDate(2005,1,1)#"
	fecha_hasta="#CreateDate(2005,1,1)#"
	indicador="salarios75" >
</cfinvoke>

<cfset now2 = Now()>

<hr><cfoutput>Duracion: <strong>#now2.getTime() - ini.getTime()#</strong> ms</cfoutput><hr>

<!---
<cfquery datasource="minisif" name="data">
	select
		distinct Ecodigo,fecha, sum(valor) as a_sum_valor, sum(total) as b_sum_total
	from IndicadorValor
	where fecha between '20040101' and '20050101'
	group by Ecodigo,fecha
</cfquery>
<cfdump var="#data#">
--->
