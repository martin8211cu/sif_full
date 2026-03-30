<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and len(url.CodICTS) and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset ETQCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset ETQCodICTS = form.CodICTS>
<cfelse>
	<cfset ETQCodICTS = "">
</cfif>	

<cfif isdefined("ETQCodICTS") and len(ETQCodICTS)>
	<cfquery name="rsNombre" datasource="preicts">
		select min(acct_full_name) as acct_full_name
		from account
		where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#">
	</cfquery>
</cfif>

<cfif isdefined("rsNombre") AND rsNombre.recordcount GT 0>
	<cfset etiquetaT = " #rsNombre.acct_full_name#">
<cfelse>
	<cfset etiquetaT = "">
</cfif>

<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from futurosCerradosPMI a
	where a.sessionid = #session.monitoreo.sessionid#
    and a.mensajeerror is not null  
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cf_templateheader title="Procesa Futuros Cerrados">
	  <cf_web_portlet_start titulo="Procesa Futuros Cerrados #etiquetaT#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cfinclude template="query-lista.cfm">
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsFuturos#"/>
	<cfinvokeargument name="cortes" value="market_day_and_broker_name"/>
	<cfinvokeargument name="desplegar" value="port_num, port_short_name, cobertura_VR_FE, mtm_pl, currency_code, pasa_o_no_pasa"/>
	<cfinvokeargument name="etiquetas" value="Portafolio, Estrategia, Tipo Cobertura,Mark To Market PL,Moneda,Genera póliza"/>
	<cfinvokeargument name="formatos" value="S,S,S,M,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,right,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#?CodICTS=#ETQCodICTS#"/>
	<cfinvokeargument name="MaxRows" value="50"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,#BErrores#,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
	<cfinvokeargument name="Navegacion" value="CodICTS=#ETQCodICTS#"/>
</cfinvoke>

	  <cf_web_portlet_end>
<cf_templatefooter>
