<cfif isdefined("url.id_inst") and not isdefined("form.id_inst")>
	<cfset form.id_inst = url.id_inst >
</cfif>
<cfif isdefined("url.id_tiposerv") and not isdefined("form.id_tiposerv")>
	<cfset form.id_tiposerv = url.id_tiposerv >
</cfif>

<cfset form.id_inst = 3 >
<cfset form.id_tiposerv = 2 >

<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales - Agenda
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Agenda'>
	<table width="100%" border="0" cellspacing="3" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="40%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select id_inst, id_tiposerv, id_agenda, codigo_agenda, nombre_agenda
				from TPAgenda
				where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				  and id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
				order by codigo_agenda
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_agenda, nombre_agenda"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Nombre"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="agenda.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_agenda"/>
			</cfinvoke>
		</td>
		<td valign="top"><cfinclude template="agenda-form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr> 
	</table>
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>