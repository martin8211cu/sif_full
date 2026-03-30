<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from futurosabiertosPMI a
	where a.sessionid = #session.monitoreo.sessionid#
    and a.mensajeerror is not null  
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cf_templateheader title="Procesa Futuros Abiertos">
	  <cf_web_portlet_start titulo="Procesa Futuros Abiertos">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

<cfinclude template="query-lista.cfm">

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsFuturos#"/>
	<cfinvokeargument name="cortes" value="broker_name"/>
	<cfinvokeargument name="desplegar" value="port_num, port_short_name, cobertura_VR_FE,mtm_pl, currency_code, pasa_o_no_pasa"/>
	<cfinvokeargument name="etiquetas" value="Portafolio, Estrategia, Tipo Cobertura, Mark To Market PL,Moneda,Genera póliza"/>
	<cfinvokeargument name="formatos" value="S,S,S,M,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,right,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="50"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,#BErrores#,Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>

	  <cf_web_portlet_end>
<cf_templatefooter>
