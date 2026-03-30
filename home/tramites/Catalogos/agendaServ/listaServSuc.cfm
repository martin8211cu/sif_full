<cfif isdefined('url.id_inst') and not isdefined('form.id_inst')>
	<cfset form.id_inst = url.id_inst>
</cfif>	
<cfif isdefined('url.id_sucursal') and not isdefined('form.id_sucursal')>
	<cfset form.id_sucursal = url.id_sucursal>
</cfif>	
<cfif isdefined('url.id_tiposerv') and not isdefined('form.id_tiposerv')>
	<cfset form.id_tiposerv = url.id_tiposerv>
</cfif>	
<cfif isdefined('url.id_agendaserv') and not isdefined('form.id_agendaserv')>
	<cfset form.id_agendaserv = url.id_agendaserv>
</cfif>		

<!--- <cfdump var="#form#"> --->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<cfif not isdefined('form.id_agendaserv') and not isdefined('form.btnNueva')>
		<cfquery name="rsLista" datasource="#session.tramites.dsn#">
			Select 
				s.id_inst
				, tas.id_sucursal
				, tas.id_tiposerv
				, id_agendaserv
				, nombre_sucursal
				, codigo_sucursal
				, codigo_tiposerv
				, nombre_tiposerv	
				<cfif isdefined('form.id_sucursal')>
					, 2 as tab
					, 'suc3' as tabsuc	
				<cfelseif isdefined('form.id_tiposerv')>
					, 5 as tab
					, 'serv2' as tabserv	
				</cfif>
			from TPAgendaServicio tas
				inner join TPSucursal s
					on s.id_sucursal=tas.id_sucursal
						and s.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
			
				inner join TPTipoServicio ts
					on ts.id_tiposerv=tas.id_tiposerv
						and ts.id_inst = s.id_inst
			<cfif isdefined('form.id_sucursal')>
				where tas.id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
				order by nombre_tiposerv
			<cfelseif isdefined('form.id_tiposerv')>
				where tas.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiposerv#">
				order by nombre_sucursal
			</cfif>
		</cfquery>											
	  <tr>
		<td class="tituloMantenimiento">
			<font size="1">
				<strong>
					Tipos de Servicio con Agenda
				</strong>
			</font>
		</td>
	  </tr>
	  <tr>
		<td>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfif isdefined('form.id_tiposerv')>
					<cfinvokeargument name="desplegar" value="codigo_sucursal,nombre_sucursal"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Sucursal"/>
				<cfelseif isdefined('form.id_sucursal')>
					<cfinvokeargument name="desplegar" value="codigo_tiposerv,nombre_tiposerv"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Servicio"/>
				</cfif>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="botones" value="Nueva"/>
				<cfinvokeargument name="formName" value="listaServSuc"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_agendaserv"/>
			</cfinvoke>
		</td>
	  </tr>
	<cfelse>
	  <tr>
		<td>
			<cfif isdefined('form.btnNueva')>
				<cfinclude template="listaServSuc_sinAgenda.cfm">				
			<cfelse>
				<cfinclude template="editCupos.cfm">
			</cfif>
		</td>
	  </tr>							
	</cfif>					  
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	function funcNueva(){
		<cfif isdefined('form.id_sucursal')>
			document.listaServSuc.ID_SUCURSAL.value = '<cfoutput>#form.id_sucursal#</cfoutput>';
			document.listaServSuc.TAB.value = 2;
			document.listaServSuc.TABSUC.value = 'suc3';						
		<cfelseif isdefined('form.id_tiposerv')>
			document.listaServSuc.ID_TIPOSERV.value = '<cfoutput>#form.id_tiposerv#</cfoutput>';
			document.listaServSuc.TAB.value = 5;			
			document.listaServSuc.TABSERV.value = 'serv2';	
		</cfif>			
		document.listaServSuc.ID_INST.value = '<cfoutput>#form.id_inst#</cfoutput>';
		document.listaServSuc.submit();
	}
</script>