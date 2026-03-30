<cfinvoke Key="LB_Parte" Default="Parte" returnvariable="LB_Parte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Numero" Default="N&uacute;mero" returnvariable="LB_Numero" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Pregunta" Default="Pregunta" returnvariable="LB_Pregunta" component="sif.Componentes.Translate" method="Translate"/>

<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.PPparte') and #url.PPparte# GT 0>
	<cfquery name="rsListaPreguntas" datasource="sifcontrol">
		select 	PPid as pPPid,
				PPnumero as pPPnumero, 
				{fn concat(	'#LB_Parte#', 
							 <cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol"> 
						   )
				} as pPPpartedesc, 
				PPpregunta as pPPpregunta, 
				PPtipo as pPPtipo, 
				PPvalor as pPPvalor,
				PPparte as pPPparte

		from PortalPregunta
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PCid#">
		  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PPparte#"> 
		order by PPparte, PPnumero, PPorden
	</cfquery>

<cfoutput>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
		<cfinvokeargument name="desplegar" 		value="pPPnumero,pPPpregunta">
		<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
		<cfinvokeargument name="formatos" 		value="S,S">
		<cfinvokeargument name="align" 			value="left,left">
		<cfinvokeargument name="ira" 			value="cuestionario.cfm?tab=3">
		<cfinvokeargument name="keys" 			value="pPPid">
		<cfinvokeargument name="showEmptyListMsg" value="true">
		<cfinvokeargument name="incluyeform" 	value="false">
		<cfinvokeargument name="formname"		value="form3">
		<cfinvokeargument name="ajustar"		value="S">
		<cfinvokeargument name="cortes"			value="pPPpartedesc">
		<cfinvokeargument name="PageIndex"		value="30">
	</cfinvoke>	
</cfoutput>
</cfif>