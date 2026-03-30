<cfif isdefined("form.id_inst") and len(trim(form.id_inst)) >
	<cfset url.id_inst = form.id_inst>
</cfif>
<cfif isdefined("form.id_tiposerv") and len(trim(form.id_tiposerv)) >
	<cfset url.id_tiposerv = form.id_tiposerv>
</cfif>

<cf_templatecss>

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	select id_inst, codigo_inst, nombre_inst   
	from TPInstitucion
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_inst#">
</cfquery>

<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="40%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select id_inst, id_tiposerv, codigo_tiposerv, nombre_tiposerv, descripcion_tiposerv, 5 as tab
				from TPTipoServicio
				where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_inst#">
				order by codigo_tiposerv
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_tiposerv, nombre_tiposerv"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_tiposerv"/>
				<cfinvokeargument name="formname" value="listats"/>
			</cfinvoke>
		</td>
		<td valign="top">
			<cfif IsDefined('url.tabserv')>
				<cfset form.tabserv = url.tabserv>
			<cfelse>
				<cfparam name="form.tabserv" default="serv1">
			</cfif>		
			<cf_tabs>
				<cf_tab text="Servicio" id="serv1" selected="#form.tabserv is 'serv1'#">
					<cfinclude template="tipo_servicio-form.cfm">
				</cf_tab>
				
				<cfif modo NEQ "ALTA">
					<cf_tab text="Agendas x Sucursal" id="serv2" selected="#form.tabserv is 'serv2'#">
						<cfinclude template="agendaServ/listaServSuc.cfm">
					</cf_tab>
				</cfif>
			</cf_tabs>		
			
		</td>
	</tr>
	<tr> 
		<td colspan="2">&nbsp;</td>
	</tr> 
</table>

<script language="javascript" type="text/javascript">
	function tab_set_current_suc (n){
	<cfoutput>
		<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
			location.href='instituciones.cfm?id_inst=#JSStringFormat(form.id_inst)#&tab=#JSStringFormat(form.tab)#&tabserv='+escape(n);
		<cfelse>
			alert('Debe agregar o seleccionar una institucin.');
		</cfif>
	</cfoutput>
	}
</script>

