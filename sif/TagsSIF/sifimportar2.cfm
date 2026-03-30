<cfsetting enablecfoutputonly="yes" requesttimeout="3600">


<cfif ThisTag.ExecutionMode IS 'Start' AND ThisTag.HasEndTag IS 'YES'>

<cfelseif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'NO' >
	
	<cfparam name="Attributes.EIid"     type="numeric" default="0">
	<cfparam name="Attributes.EIcodigo" type="string"  default="">
	<cfparam name="Attributes.mode"     type="string">
	<cfparam name="Attributes.width"    type="string" default="300">
	<cfparam name="Attributes.height"   type="string" default="300">
	<cfparam name="Attributes.form"     type="string"  default="formexport">
	<cfparam name="Attributes.exec"     type="boolean" default="no">
	
	
	<!--- solo para exportación --->
	<cfparam name="Attributes.html"     type="boolean" default="no">
	<cfparam name="Attributes.header"   type="boolean" default="#Attributes.html#">
	<cfparam name="Attributes.name"     type="string"  default="">
	<cfparam Name="ThisTag.parameters"  default="#arrayNew(1)#">
	<!--- solo para exportación (nuevos)--->
	<cfparam name="Attributes.Modulo" 		  		type="string"  default="TODOS">
	<cfparam name="Attributes.ListaDeExportacion" 	type="boolean" default="false">
	<cfparam name="Attributes.Nuevo" 				type="boolean" default="false">
	
	<cfif Attributes.Nuevo>
		<!---  	En esta opcion lo que hace es pintar el combo de exportadores a los que el usuario tiene acceso 	--->
		<cfif Attributes.ListaDeExportacion eq "true" and Attributes.mode eq "out">
			<cfset ListParams = "">
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
				<cfset ListParams = ListAppend(ListParams,"#ThisTag.parameters[i].name#=#ThisTag.parameters[i].value#","|")>
			</cfloop>
			<cflocation url="/cfmx/hosting/tratado/importar/IMP_SeleccionExportadores.cfm?Modulo=#Attributes.Modulo#&PARAMETROS=#ListParams#">
		<!---  pinta el exportador que esta ejecutando si este tiene un cfm para los parametros los pinta.	--->
		<cfelseif Attributes.mode eq "out" and isdefined("Attributes.EIid") and len(trim(Attributes.EIid)) gt 0 and isdefined("Attributes.EIcodigo") and len(trim(Attributes.EIcodigo)) gt 0 >
			<cfset ListParams = "">
			<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
				<cfset ListParams = ListAppend(ListParams,"#ThisTag.parameters[i].name#=#ThisTag.parameters[i].value#","|")>
			</cfloop>		
			<cflocation url="/cfmx/hosting/tratado/importar/IMP_SolicitarParametros.cfm?Directo=S&Modulo=#Attributes.Modulo#&PARAMETROS=#ListParams#&EIcodigo=#Attributes.EIcodigo#&EIid=#Attributes.EIid#">
		</cfif>
	<cfelse>
		<!---  Invocacion normal del exportador . (version anterior)	--->
		
		<!----=============== TRADUCCION ==================--->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Debe_especificarse_al_menos_uno_de_los_siguientes_atributos_EIid_EIcodigo"
			Default="Debe especificarse al menos uno de los siguientes atributos:  EIid, EIcodigo"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_Atributos"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_cfsifimportar_No_se_debe_especificar_mode_in_y_exec_yes"
			Default="cfsifimportar No se debe especificar mode=in y exec=yes"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_cfsifimportar_No_se_debe_especificar_mode"/>
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_atributo_mode_debe_ser_in_o_out"
			Default="El atributo mode debe ser in o out	"	
			XmlFile="/sif/generales.xml"
			returnvariable="MSG_El_atributo_mode_debe_ser_in_o_out"/>		
		
			
		<cfif Attributes.EIid EQ 0 AND Len(Attributes.EIcodigo) EQ 0>
			<cfoutput><cfthrow message="#MSG_Atributos#"></cfoutput>
		</cfif>
		
		<cfquery datasource="sifcontrol" name="formatos">
			select * from EImportador
			where (Ecodigo is null
			   or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" null="#Len(session.Ecodigo) is 0#">)
			<cfif Attributes.EIid NEQ 0>
			  and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.EIid#">
			</cfif>
			<cfif Len(Attributes.EIcodigo) NEQ 0>
			  and EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.EIcodigo#">
			</cfif>
		</cfquery>
		<cfif formatos.RecordCount EQ 1>
			<cfif Attributes.mode EQ "out" and formatos.EIexporta EQ 0>
				<cfoutput><cf_translate key="LB_Este_format_no_esta_habilitado_para_exportacion" XmlFile="/sif/generales.xml">Este formato no est&aacute; habilitado para exportaci&oacute;n.</cf_translate></cfoutput>
			<cfelseif Attributes.mode EQ "out" and Attributes.exec EQ "yes">
				<cfinclude template="/sif/importar/export-function.cfm">
				<cfset parms = StructNew()>
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
					<cfset parms[ThisTag.parameters[i].name] = ThisTag.parameters[i].value>
				</cfloop>
				<cfif Len(Attributes.name) EQ 0>
					<cfset LvarArchivo=exportar(formatos.EIid,Attributes.html,Attributes.header,parms)>
					<cfif not Attributes.html>
						<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
						<cfheader  name="Content-Disposition"	value="attachment;filename=#Attributes.EIcodigo#.txt">
						<cfcontent type="text/plain" reset="yes" file="#LvarArchivo#" deletefile="yes">
					</cfif>
					<cfabort>
				<cfelse>
					<!---
						exec=yes  se hace obsoleto para modificar la funcion exportar()
								  para que no use una variable temporal.
								  danim, 03-ene-2005
					--->
					<cf_errorCode	code = "50702" msg = "exec=yes,name=var está obsoleto.">
					<cfset "Caller.#Attributes.name#" = ret_value>
				</cfif>
			<cfelseif Attributes.mode EQ "out">
				<cfinclude template="/sif/importar/export-form.cfm">
			<cfelseif Attributes.mode EQ "in" and formatos.EIimporta EQ 0>
				<cfoutput><cf_translate key="LB_Este_formato_no_esta_habilitado_para_importacion" XmlFile="/sif/generales.xml">Este formato no est&aacute; habilitado para importaci&oacute;n.</cf_translate></cfoutput>
			<cfelseif Attributes.mode EQ "in" AND Attributes.exec EQ "yes">			
				<cfthrow message="#MSG_cfsifimportar_No_se_debe_especificar_mode#">
			<cfelseif Attributes.mode EQ "in">
				<cfset ListParams = "">
				<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
					<cfset ListParams = ListAppend(ListParams,"&parameters=#ThisTag.parameters[i].name#,#ThisTag.parameters[i].value#","|")>
				</cfloop>
				<cfoutput>
					<iframe name="ifrImportar" id="ifrImportar"
						width ="#Attributes.width#"
						height="#Attributes.height#"
						frameborder="0"
						src="/cfmx/hosting/tratado/importar/importar-form.cfm?fmt=#formatos.EIid##ListParams#">
					</iframe>
				</cfoutput>
			<cfelse>
				<cfthrow message="#MSG_El_atributo_mode_debe_ser_in_o_out#">
			</cfif>
		</cfif>
	</cfif>
</cfif> 
<!--- ThisTag.ExecutionMode IS 'End' --->
<cfsetting enablecfoutputonly="no">

