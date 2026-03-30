<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfif isdefined("LvarConsulta")>
	<cfset LvarFiltro 	= "">
	<cfset LvarIra 		= "">
	<cfset LvarBotones 	= "">
	<cfset LvarShowLink	= "no">
<cfelse>
	<cfset LvarFiltro	= "and o.OBOestado <> '3'">
	<cfset LvarIra 		= "OBobra.cfm">
	<cfset LvarBotones	= "Nueva_Obra">
	<cfset LvarShowLink	= "yes">
</cfif>
<cf_cboOBPid>
<cfquery datasource="#session.dsn#" name="rsStatus">
	select '' as value, '(todas...) ' as description from dual
	UNION
	select '0' as value, 'Nuevas' as description  from dual
	UNION
	select '1' as value, 'Abiertas' as description  from dual
	UNION
	select '2' as value, 'Cerradas' as description  from dual
<cfif isdefined("LvarConsulta")>
	UNION
	select '3' as value, 'Liquidadas' as description  from dual
</cfif>
	order by value
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="
			OBobra o
			"
	columnas="o.OBOid,o.OBOcodigo,o.OBOdescripcion, 
				case o.OBOestado 
					when '0' then 'Nueva'
					when '1' then '<font color=''##00A000''><strong>Abierta</strong></font>'
					when '2' then '<font color=''##FF0000''><strong>Cerrada</strong></font>'
					when '3' then '<strong>Liquidada</strong>'
				end as Estado	
			"
	filtro="o.OBPid=#session.obras.OBPid# #LvarFiltro# order by o.OBOcodigo"
	desplegar="OBOcodigo,OBOdescripcion,Estado"
	etiquetas="Codigo,Descripcion de la Obra,Estado"
	formatos="S,S,S"
	align="left,left,left"
	ira="#LvarIrA#"
	form_method="post"
	keys="OBOid"
	showLink="#LvarShowLink#"

	mostrar_filtro="yes"
	filtrar_automatico="yes"
	filtrar_Por="OBOcodigo,OBOdescripcion,OBOestado"
	rsEstado="#rsStatus#"

	botones="#LvarBotones#"
	navegacion="_"
/>
