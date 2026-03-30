<cfparam name="url.desde" default="">
<cfparam name="url.hasta" default="">
<cfparam name="url.indicador" default="">

<cfif Len(url.desde) Is 0 Or Len(url.hasta) Is 0 or Len(Trim(url.indicador)) Is 0>
	Invocacion incorrecta:<ul>
	<cfif Len(Trim(url.desde)) Is 0>
		<li>Especifique fecha desde</li>
	</cfif>
	<cfif Len(Trim(url.hasta)) Is 0>
		<li>Especifique fecha hasta</li>
	</cfif>
	<cfif Len(Trim(url.indicador)) Is 0>
		<li>Especifique indicador</li>
	</cfif>
	</ul>
	<cfabort>
</cfif>

<html><head><title>Rec&aacute;lculo de indicadores</title></head><body>
<style type="text/css">
*,td {
	font-size:10px;
	font-family:Arial, Helvetica, sans-serif;
} 
</style>
<cfoutput>
</cfoutput>
<cfquery datasource="asp" name="indicadores">
	select i.indicador, i.calculo,
		e.CEcodigo, e.Ecodigo as EcodigoSDC, e.Ereferencia, e.Enombre, c.Ccache,
		' ' as inicio, ' ' as final, -1 as millis
	from Indicador i,
		Empresa e
		join Caches c on e.Cid = c.Cid
	where Ereferencia is not null
	  and i.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.indicador#">
	  and Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by indicador, Enombre, Ereferencia
</cfquery>

<cfset task_Indicadores_hasta = LSParseDateTime(url.hasta)>
<cfset task_Indicadores_desde = LSParseDateTime(url.desde)>

<cfoutput>
<table width="100%"  border="0">
  <tr>
    <td>Indicador:</td>
    <td>#HTMLEditFormat(url.indicador)#</td>
  </tr>
  <tr>
    <td>Desde:</td>
    <td>#LSDateFormat(task_Indicadores_desde)#</td>
  </tr>
  <tr>
    <td>Hasta:</td>
    <td>#LSDateFormat(task_Indicadores_hasta)#</td>
  </tr>
</table>
<hr>
</cfoutput>
<table cellpadding="0" cellspacing="2"  cellpadding="0" border="0" bgcolor="#CCCCCC">

<cfloop query="indicadores">
	<cfset inicio_indicador = Now()>
	<cfset indicadores.inicio = inicio_indicador>
	
	<cfflush>
	<cfset mensaje_error = "">
	<cfset texto_capturado = "">
	<cftry>
		<cfif len(trim(indicadores.calculo))>
			<cfsavecontent variable="texto_capturado">
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
			</cfsavecontent>
		</cfif>
		
		<cfcatch type="any">
			<cfset mensaje_error = "Error en calculo: #cfcatch.Message# #cfcatch.Detail#">
			<cfinclude template="/home/public/error/log_cfcatch.cfm">
		</cfcatch>
		
	</cftry>
	
	<cfset final_indicador = Now()>
	<cfset indicadores.final = final_indicador>
	<cfset indicadores.millis = final_indicador.getTime() - inicio_indicador.getTime()>
	<cfoutput>
	<tr><td bgcolor="white" align="right">#indicadores.CurrentRow#/#indicadores.RecordCount#</td>
		<td bgcolor="white" align="center">#HTMLEditFormat(indicadores.Ereferencia)#</td>
		<td bgcolor="white">#HTMLEditFormat(indicadores.Enombre)#</td>
		<td bgcolor="white" align="right">#HTMLEditFormat(indicadores.millis)#&nbsp;ms</td>
		</tr>
		<tr><td bgcolor="white"></td bgcolor="white"><td colspan="3" bgcolor="white">
			#texto_capturado#
		</td></tr>
	<cfif Len(mensaje_error)>
		<tr><td bgcolor="white">&nbsp;</td bgcolor="white"><td colspan="3" bgcolor="white">
			<div style="color:red;">#mensaje_error#</div>
		</td></tr>
	</cfif>
	</cfoutput>
	<cfflush>
	
</cfloop>
</table>

</body></html>
