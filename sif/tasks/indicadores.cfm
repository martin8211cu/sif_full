<cfsetting enablecfoutputonly="no">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
	
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" ></cfinvoke>
	
<cfparam name="url.emp"  default="">
<cfparam name="url.ind"  default="">
<cfparam name="url.desde"  default="">
<cfparam name="url.hasta"  default="">

<cfif isdefined('url.indicador') and len(url.ind) is 0>
	<cfset url.ind = url.indicador>
</cfif>

<cfif Len(url.desde) And len(url.hasta)>
<cfset task_Indicadores_hasta = LSParseDateTime(url.hasta)>
<cfset task_Indicadores_desde = LSParseDateTime(url.desde)>
<cfelse>
<cfset task_Indicadores_hoy = Now()>
<cfset task_Indicadores_desde = CreateDate(Year(task_Indicadores_hoy),Month(task_Indicadores_hoy),1)>
<cfset task_Indicadores_hasta = CreateDate(Year(task_Indicadores_hoy),Month(task_Indicadores_hoy),Day(task_Indicadores_hoy))>
</cfif>


<html><head><title>Calculo diario de indicadores</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfoutput>
url.emp=#HTMLEditFormat(url.emp)# (EcodigoSDC)<br>
url.ind=#HTMLEditFormat(url.ind)#<hr>
Desde #LSDateFormat(task_Indicadores_desde)# 
hasta #LSDateFormat(task_Indicadores_hasta)# (#DateDiff('d', task_Indicadores_desde, task_Indicadores_hasta)+1# d&iacute;as)<br>

<a href="?emp=#URLEncodedFormat(url.emp)#&amp;ind=#URLEncodedFormat(url.ind)#&amp;desde=#LSDateFormat(DateAdd('m',-1,task_Indicadores_desde))#&amp;hasta=#LSDateFormat(DateAdd('d',-1,task_Indicadores_desde))#">Mes anterior</a>
|
<a href="?emp=#URLEncodedFormat(url.emp)#&amp;ind=#URLEncodedFormat(url.ind)#&amp;desde=#LSDateFormat(DateAdd('d',1,task_Indicadores_hasta))#&amp;hasta=#LSDateFormat(DateAdd('m',1,task_Indicadores_hasta))#">Mes siguiente</a>

</cfoutput>

<cfquery datasource="asp" name="indicadores">
	select i.indicador, i.calculo,
		e.CEcodigo, e.Ecodigo as EcodigoSDC, e.Ereferencia, e.Enombre, c.Ccache,
		' ' as inicio, ' ' as final, -1 as millis
	from Indicador i,
		Empresa e
		join Caches c on e.Cid = c.Cid
	where Ereferencia is not null
	<cfif len(url.emp)>
	  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
	</cfif>
	<cfif len(url.ind)>
	  and i.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.ind#">
	</cfif>
	  and Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by indicador, Enombre, Ereferencia
</cfquery>

<!--- <cfdump var="#indicadores#"> --->

<cfloop query="indicadores">
	<cfset inicio_indicador = Now()>
	<cfset indicadores.inicio = inicio_indicador>
	<cfoutput>Calculando indicador [#indicadores.CurrentRow#/#indicadores.RecordCount#] #indicadores.indicador# #indicadores.Ereferencia#-#indicadores.Enombre# ... </cfoutput>
	
	<cfflush>
	
	<cftry>
		<cfif len(trim(indicadores.calculo))>
			<cfinvoke component="#Replace(indicadores.calculo,'.cfc','')#"
				method="calcular"
				datasource="#indicadores.Ccache#"
				Ecodigo="#indicadores.Ereferencia#"
				EcodigoSDC="#indicadores.EcodigoSDC#"
				CEcodigo="#indicadores.CEcodigo#"
				fecha_desde="#task_Indicadores_desde#"
				fecha_hasta="#task_Indicadores_hasta#"
				indicador="#indicadores.indicador#">
			</cfinvoke>
			<cfinvoke component="home.Componentes.IndicadorBase"
				method="consolidar"
				datasource="#indicadores.Ccache#"
				indicador="#indicadores.indicador#"
				Ecodigo="#indicadores.Ereferencia#"
				CEcodigo="#indicadores.CEcodigo#"
				fecha_desde="#task_Indicadores_desde#"
				fecha_hasta="#task_Indicadores_hasta#">
			</cfinvoke>
		</cfif>
		
		<cfcatch type="any">
			<cfoutput><div style="color:red">Error en calculo: #cfcatch.Message# #cfcatch.Detail#</div></cfoutput>
			<!---
			<cfinclude template="/home/public/error/log_cfcatch.cfm">
			--->
		</cfcatch>
		
	</cftry>
	
	<cfset final_indicador = Now()>
	<cfset indicadores.final = final_indicador>
	<cfset indicadores.millis = final_indicador.getTime() - inicio_indicador.getTime()>
	
	<cfoutput>listo <br></cfoutput>
	
	<cfflush>

</cfloop>


<!--- <cfdump var="#indicadores#"> --->

</body></html>