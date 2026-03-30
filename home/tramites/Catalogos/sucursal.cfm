<cfif not isdefined("form.fid_inst") and not isdefined("form.id_inst") and isdefined("url.id_inst") and len(trim(url.id_inst))>
	<cfset form.id_inst = url.id_inst>
	<cfset form.fid_inst = url.id_inst>
</cfif>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td valign="top" width="40%">
			<form style="margin: 0%" name="filtros" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>C&oacute;digo:</td>
						<td>Descripci&oacute;n:</td>
					</tr>
					<tr> 
						<td><input type="text" name="fcodigo_sucursal"  maxlength="10" size="10" value="<cfif isdefined("form.fcodigo_sucursal")>#form.fcodigo_sucursal#</cfif>"></td>
						<td><input type="text" name="fnombre_sucursal"  maxlength="30" size="30" value="<cfif isdefined("form.fnombre_sucursal")>#form.fnombre_sucursal#</cfif>"></td>
						<td align="right"><input type="submit" name="btnFiltrar" value="Filtrar"></td>
						<td align="left"><input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiarsuc();"> </td>
					</tr>
				</table>
				<input type="hidden" name="id_inst" value="#form.id_inst#">
				<input type="hidden" name="tab" value="2">
				</cfoutput>

			</form>
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select TPSucursal.id_inst,
					   id_sucursal,
					   codigo_sucursal,
					   nombre_sucursal,
					   nombre_inst,
					   2 as tab
					   
				from TPSucursal,TPInstitucion 

				where TPSucursal.id_inst = TPInstitucion.id_inst
				 and  TPSucursal.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
					<cfif isdefined("form.fcodigo_sucursal") and len(trim(form.fcodigo_sucursal))>
						and upper(codigo_sucursal) like upper('%#trim(form.fcodigo_sucursal)#%')
					</cfif>
					<cfif isdefined("form.fnombre_sucursal") and len(trim(form.fnombre_sucursal))>
						and upper(nombre_sucursal) like upper('%#trim(form.fnombre_sucursal)#%')
					</cfif>
				
				order by codigo_sucursal
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_sucursal,nombre_sucursal"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Sucursal"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_inst,id_sucursal"/>
			</cfinvoke>
		</td>
		<td valign="top">
		
			<cfif IsDefined('url.tabsuc')>
				<cfset form.tabsuc = url.tabsuc>
			<cfelse>
				<cfparam name="form.tabsuc" default="suc1">
			</cfif>
			<cf_tabs>
				<cf_tab text="Sucursal" id="suc1" selected="#form.tabsuc is 'suc1'#">
					<cfinclude template="sucursal-form.cfm">
				</cf_tab>
				
				<cfif modo NEQ "ALTA">
					<cf_tab text="Ventanillas" id="suc2" selected="#form.tabsuc is 'suc2'#">
						<cfinclude template="sucursal-ventanilla.cfm">
					</cf_tab>
<!--- 					<cf_tab text="Recursos" id="suc3" selected="#form.tabsuc is 'suc3'#">
						<cfinclude template="recursos/recursosIn.cfm">
					</cf_tab>					 --->
					<cf_tab text="Agendas x Servicios" id="suc3" selected="#form.tabsuc is 'suc3'#">
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
<!--
	function limpiarsuc(){
		document.filtros.fcodigo_sucursal.value = ' ';
		document.filtros.fnombre_sucursal.value = ' ';
	}

	function tab_set_current_suc (n){
	<cfoutput>
		<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
			location.href='instituciones.cfm?id_inst=#JSStringFormat(form.id_inst)#&tab=#JSStringFormat(form.tab)#&tabsuc='+escape(n);
		<cfelse>
			alert('Debe agregar o seleccionar una institución.');
		</cfif>
	</cfoutput>
	}
	//-->
</script>
