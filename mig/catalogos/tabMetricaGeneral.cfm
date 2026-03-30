<cfoutput>
<table border="0" cellpadding="0" cellspacing="0">
<tr valign="baseline"><td>
	<form method="post" name="form1" action="MetricasSQL.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="pagenum" id="pagenum" value="<cfoutput>#pagenum#</cfoutput>">
	<table border="0">
		<tr valign="baseline">
			<td nowrap align="right">Codigo M&eacute;trica:</td>
			<td align="left">
			<input type="hidden" name="modo" id="modo" value="<cfoutput>#modo#</cfoutput>">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMcodigo)#
					<input type="hidden" name="MIGMid" id="MIGMid" value="#rsMetricas.MIGMid#">
				<cfelse>
					<input type="text" name="MIGMcodigo" id='MIGMcodigo' maxlength="40" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td nowrap align="right">Secuencia M&eacute;trica:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA' and rsMetricas.MIGMsequencia GT 0>
					<cf_inputNumber name="MIGMsequencia"  value="#rsMetricas.MIGMsequencia#" enteros="15" decimales="0" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="MIGMsequencia"  value="" enteros="15" decimales="0" negativos="false" comas="no">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Nombre M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMnombre" id='MIGMnombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMnombre)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Responsable:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Responsables"
						campos = "MIGReid, MIGRcodigo,MIGRenombre"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGResponsables"
						columnas="MIGReid, MIGRcodigo,MIGRenombre"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="MIGRcodigo, MIGRenombre"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGReid=#LvarIDR#"
						filtrar_por="MIGRcodigo,MIGRenombre"
						tabindex="1"
						Size="0,20,60"
						fparams="MIGReid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Presentaci&oacute;n M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMnpresentacion" id='MIGMnpresentacion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMnpresentacion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Unidades:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Unidades"
						campos = "Ecodigo, Ucodigo, Udescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="Unidades"
						columnas="Ecodigo, Ucodigo, Udescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Ucodigo, Udescripcion"
						etiquetas="Codigo,Descripci&oacute;n"
						formatos="S,S"
						Size="0,20,60"
						align="left,left"
						readonly="#LvarReadOnly#"
						traerInicial="#LvarIniciales#"
						traerFiltro="Ucodigo='#LvarID#' and Ecodigo=#session.Ecodigo#"
						filtrar_por="Ucodigo,Udescripcion"
						tabindex="1"
						fparams="Ucodigo,Ecodigo"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMdescripcion" id='MIGMdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMdescripcion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Periocidad:</td>
			 <td width="17%">
				 <select name="periocidad" id="periocidad" <cfif modo NEQ 'ALTA'> disabled="disabled"</cfif> >
				 	<option value="D" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "D">selected</cfif> ><cf_translate  key="perio0">Diario</cf_translate></option>
					<option value="W" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "W">selected</cfif> ><cf_translate  key="perio0">Semanal</cf_translate></option>
					<option value="M" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "M">selected</cfif>><cf_translate  key="perio1">Mensual</cf_translate></option>
					<option value="T" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "T">selected</cfif>><cf_translate  key="perio2">Trimestral</cf_translate></option>
					<option value="S" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "S">selected</cfif>><cf_translate  key="perio3">Semestral</cf_translate></option>
					<option value="A" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "A">selected</cfif>><cf_translate  key="perio4">Anual</cf_translate></option>
				  </select>
			  </td>
		</tr>
		
		<!---TRAMITES--->
	  <!---<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
			<cfinvokeargument name="PackageBaseName" value="DMIG" />
	  </cfinvoke>
	  
	  <cfif modo NEQ 'ALTA'>
			<cfquery name="rsTramite" datasource="#Session.DSN#">
				select idTramite
				from MIGMetricas
				where MIGMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMetricas.MIGMid#">
			</cfquery>
	 </cfif>
	 <cfquery name="rsProcesos" datasource="#Session.DSN#">
			select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
			from WfProcess
			where WfProcess.Ecodigo = #session.Ecodigo#
			  and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
				   and PublicationStatus = 'RELEASED'
			<cfif IsDefined('rsTramite.idtramite') and Len(rsTramite.idtramite)>
			or ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTramite.idtramite#">
			</cfif>)
			order by upper_name
		</cfquery>
	  <tr>
      <td align="right"><cf_translate XmlFile="/rh/generales.xml" key="LB_TRAMITE">Tr&aacute;mite</cf_translate>:&nbsp;</td>
      	<td>   	   
			<select name="idtramite">
			  <option value="N"> --
			  <cf_translate key="LB_Ninguno">Ninguno</cf_translate>
				-- </option>
			  <cfloop query="rsProcesos">
				<option value="#rsProcesos.ProcessId#" <cfif modo NEQ 'ALTA' and isdefined('rsTramite.idtramite') and rsTramite.idtramite EQ rsProcesos.ProcessId> selected</cfif>>#rsProcesos.Name#
				  <cfif rsProcesos.PublicationStatus neq 'RELEASED'>
					(#rsProcesos.PublicationStatus#)
				  </cfif>
				  </option>
			  </cfloop>
			</select>
		</td><!---FIN TRAMITES--->
   	 --->
		<td align="right" nowrap="nowrap">Estado:</td>
		<td align="left" nowrap="nowrap" colspan="2">
			<select name="Dactiva" id="Dactiva">
				<option value="">-&nbsp;-&nbsp;-</option>
				<option value="0"<cfif modo EQ 'CAMBIO'and rsMetricas.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
				<option value="1"<cfif modo EQ 'CAMBIO'and rsMetricas.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
			</select>
		</td></tr>
		
		<tr>
			<td colspan="4" align="center" nowrap><cf_botones modo="#modo#" include="#LvarInclude#"></td>
		</tr>

		</table>
	</form>
	</td></tr>
</table>
</cfoutput>