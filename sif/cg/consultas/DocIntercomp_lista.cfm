<cfset navegacion = "">
<cf_navegacion name="EcodigoOri" 	navegacion="">
<cf_navegacion name="Periodo" 		navegacion="">
<cf_navegacion name="Mes" 			navegacion="">
<cf_navegacion name="EcodigoDest" 	navegacion="">

<cfset navegacion = '&EcodigoOri=#form.EcodigoOri#&Periodo=#form.Periodo#&Mes=#form.Mes#&EcodigoDest=#form.EcodigoDest#'>

<cfquery name="rsEmpresaOrigen" datasource="#session.DSN#">
	select Edescripcion
	  from Empresas
	where Ecodigo = #form.EcodigoOri#
</cfquery>
<cfset LvarEmpresa = ''>
<cfif isdefined("rsEmpresaOrigen") and rsEmpresaOrigen.recordcount gt 0>
	<cfset LvarEmpresa = rsEmpresaOrigen.Edescripcion>
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">
	select 
		ic.ECid,
		ed.Edescripcion as EmpresaDestino,
		a.Cconcepto, 
		a.Edocumento,
		a.Edescripcion as DescripAsiento, 
		ic.fechaasiento as fechaasiento
	from EControlDocInt ic
		inner join HEContables a
			on a.IDcontable = ic.idcontableori
		inner join Empresas ed
			on ed.Ecodigo = ic.Ecodigodest
	where ic.Ecodigo     = #form.EcodigoOri#
	  and a.Eperiodo     = #form.Periodo#
	  and a.Emes         = #form.Mes#
	 <cfif isdefined("form.EcodigoDest") and form.EcodigoDest NEQ -1>
	  and ic.Ecodigodest = #form.EcodigoDest#
	 </cfif>
	order by ed.Edescripcion, a.Cconcepto, a.Edocumento
</cfquery>
<cfif rsLista.recordcount EQ 0>
	<cf_errorCode code = "50349" msg = "No se han generado registros para este reporte.">
</cfif>
<cf_templateheader title="Documentos Intercompañ&iacute;a">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Lista Documentos Intercompañ&iacute;a">
		<cfoutput>
			<strong>Empresa Origen: #LvarEmpresa#</strong><br />
			<br />
		</cfoutput>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
			<cfinvokeargument name="query" 				value="#rsLista#"/>
			<cfinvokeargument name="desplegar" 			value="EmpresaDestino, Cconcepto, Edocumento, DescripAsiento, fechaasiento"/>
			<cfinvokeargument name="etiquetas" 			value="Empresa Destino, Concepto, Documento, Descripción Asiento, Fecha Asiento"/>
			<cfinvokeargument name="formatos" 			value="S, S, S, S, D"/>
			<cfinvokeargument name="align" 				value="left, left, left, left, left,"/>
			<cfinvokeargument name="keys" 				value="ECid"/>
			<cfinvokeargument name="ajustar" 			value="s"/>
			<cfinvokeargument name="irA" 				value="DocIntercomp_Rep.cfm"/>
			<cfinvokeargument name="showLink" 			value="false"/>
			<cfinvokeargument name="formName" 			value="form1"/>
			<cfinvokeargument name="MaxRows" 			value="100"/>
			<cfinvokeargument name="Botones" 			value="Generar, Regresar"/>
			<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
			<cfinvokeargument name="debug" 				value="N"/>
			<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
			<cfinvokeargument name="checkboxes" 		value="S"/>
		</cfinvoke>
	<cf_web_portlet_end>
<cf_templatefooter>