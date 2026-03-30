<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 10-8-2005.
		Motivo: Nuevo porlet de Cierre de trámites.
 --->

<cftransaction>
  <cfquery datasource="#session.tramites.dsn#" name="data">
	select it.id_persona, dg.id_tipo, tpi.id_tipoident
	from TPInstanciaTramite it
		left join TPTramite tr
			on tr.id_tramite = it.id_tramite
		left join TPDocumento dg
			on dg.id_documento = tr.id_documento_generado
		left join TPTipoIdent tpi
			on tpi.id_documento = tr.id_documento_generado
	where it.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
  </cfquery>
  <cfset bGenerarPersona = Len(data.id_tipoident)>
  
  <cfif bGenerarPersona>
	<cfparam name="form.P_NOM" default="#form.P_IDN#">
	<cfparam name="form.P_AP1" default="">
	<cfparam name="form.P_AP2" default="">
	<cfparam name="form.P_TEL" default="">
	<cfparam name="form.P_CEL" default="">
	<cfparam name="form.P_FAX" default="">
	<cfparam name="form.P_EML" default="">
	<cfparam name="form.P_NAC" default="">
	<cfparam name="form.P_SEX" default="">
	<cfquery name="inserta_persona" datasource="#session.tramites.dsn#">
		insert into TPPersona( id_tipoident, identificacion_persona, nombre,
			apellido1, apellido2, 
			casa, celular, fax, email1, nacimiento, sexo,
			extranjero, BMUsucodigo, BMfechamod )
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tipoident#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_IDN#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_NOM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_AP1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_AP2#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_TEL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_CEL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_FAX#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_EML#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_NAC#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.P_SEX#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	    <cf_dbidentity1 name="inserta_persona" datasource="#session.tramites.dsn#">
	</cfquery>
	<cf_dbidentity2 name="inserta_persona" datasource="#session.tramites.dsn#">
	<cfset QuerySetCell(data, 'id_persona', inserta_persona.identity)>
  </cfif>
  
  <cfset nuevo_registro = "">
  <cfif Len(data.id_tipo) AND ((form.genera EQ 1) or (form.genera EQ 2))>
    <cfquery name="datos_variables" datasource="#session.tramites.dsn#" >
		select tc.id_campo
		from DDTipoCampo tc
		where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_tipo#">
	</cfquery>
    <cfinvoke component="home.tramites.componentes.vistas"
			method="insRegistro"
			id_tipo="#data.id_tipo#"
			id_persona="#data.id_persona#"
			returnvariable="nuevo_registro">
    <cfloop query="datos_variables">
      <cfif StructKeyExists(form, 'dato_' & datos_variables.id_campo)>
        <cfinvokeargument name="C_#id_campo#" 
		  	value="#form['dato_' & datos_variables.id_campo]#">
      </cfif>
    </cfloop>
    </cfinvoke>
    <cfif (form.genera EQ 1)>
      <!---
		  <cfthrow message="No estoy preparado para llamar al web service.">
		  
				<cfinvoke component="home.tramites.componentes.WS"
					method="WS->
      guardar" id_registro="#nuevo_registro#" >
      </cfinvoke>
      --->
    </cfif>
  </cfif>
  <cfquery datasource="#session.tramites.dsn#">
	update TPInstanciaTramite
	set completo = 1,
		id_registro_generado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_registro#" null="#Len(nuevo_registro) EQ 0#">,
		id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#" null="#Len(session.tramites.id_funcionario) EQ 0#">,
		BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
  </cfquery>
</cftransaction>
<cflocation url="/cfmx/home/tramites/Operacion/cierre/listado_form.cfm">
