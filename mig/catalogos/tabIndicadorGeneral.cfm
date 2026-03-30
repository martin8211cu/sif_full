<cfoutput>
<table border="0" cellpadding="0" cellspacing="0">
<tr valign="baseline"><td>
	<form method="post" name="form1" action="IndicadoresSQL.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="modo" id="modo" value="#modo#">
	<input type="hidden" name="pagenum1" id="pagenum1" value="#pagenum#">
	<input name="tab" value="#tabChoice#" id="tab"  type="hidden">
	<table align="center" border="0">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Indicador:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsIndicadores.MIGMcodigo)#
					<input type="hidden" name="MIGMid" id="MIGMid" value="#rsIndicadores.MIGMid#">
				<cfelse>
				<input type="text" name="MIGMcodigo" id='MIGMcodigo' maxlength="40" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td align="right">Responsable:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Responsables"
						tabla="MIGResponsables b"
						columnas="b.MIGReid as IDresp, b.MIGRenombre as NombreResp, b.MIGRcodigo as CodigoResp"
						campos = "IDresp, CodigoResp,NombreResp"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="CodigoResp, NombreResp"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGReid=#LvarIDR#"
						filtrar_por="MIGRcodigo,MIGRenombre"
						tabindex="1"
						size="0,20,60"
						fparams="IDresp"
						/>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Nombre Indicador:</td>
			<td align="left"><input type="text" name="MIGMnombre" id='MIGMnombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsIndicadores.MIGMnombre)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Reponsable Fija Meta:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Responsables"
						tabla="MIGResponsables c"
						columnas="c.MIGReid as IDFM,c.MIGRenombre as NombreFM,c.MIGRcodigo as CodigoFM"
						campos = "IDFM, CodigoFM,NombreFM"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="CodigoFM, NombreFM"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGReid=#LvarIDFijaMeta#"
						filtrar_por="MIGRcodigo,MIGRenombre"
						tabindex="1"
						size="0,20,60"
						fparams="IDFM"
						/>
			</td>
		</tr>
		<tr>
			<td align="right">Nombre Presentaci&oacute;n:</td>
			<td align="left" nowrap="nowrap" >
				<input name="MIGMnpresentacion" type="text" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsIndicadores.MIGMnpresentacion)#</cfif>" size="50" maxlength="250" />
			</td>
			<td align="right">Due&ntilde;o Indicador:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Responsables"
						tabla="MIGResponsables a"
						columnas="a.MIGReid as IDdue,a.MIGRenombre as Nombredue,a.MIGRcodigo as Codigodue"
						campos = "IDdue, Codigodue,Nombredue"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Codigodue, Nombredue"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						size="0,20,60"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGReid=#LvarID#"
						filtrar_por="MIGRcodigo,MIGRenombre"
						tabindex="1"
						fparams="IDdue"
						/>
			</td>

		</tr>
				<tr>
			<td align="right">Indicador Descripci&oacute;n:</td>
			<td align="left" nowrap="nowrap" >
				<input name="MIGMdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsIndicadores.MIGMdescripcion)#</cfif>" size="50" maxlength="250" />
			</td>
			<td align="right">Unidades:</td>
			<td align="left" nowrap="nowrap" >
				<cfif modo NEQ 'ALTA'>
				<cf_conlis title="Lista de Unidades"
						campos = "Ecodigo, Ucodigo, Udescripcion"
						desplegables = "N,S,S"
						modificables = "N,N,N"
						tabla="Unidades"
						columnas="Ecodigo, Ucodigo, Udescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Ucodigo, Udescripcion"
						etiquetas="Codigo,Descripci&oacute;n"
						formatos="S,S"
						size="0,20,60"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="Ucodigo='#LvarUnidades#' and Ecodigo=#session.Ecodigo#"
						filtrar_por="Ucodigo,Udescripcion"
						tabindex="1"
						fparams="Ucodigo,Ecodigo"
						readonly="true"
						/>
				<cfelse>
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
						size="0,20,60"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="Ucodigo='#LvarUnidades#' and Ecodigo=#session.Ecodigo#"
						filtrar_por="Ucodigo,Udescripcion"
						tabindex="1"
						fparams="Ucodigo,Ecodigo"
						/>
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap">Periodicidad:</td>
			<td align="left" nowrap="nowrap">
				<select name="MIGMperiodicidad" id="MIGMperiodicidad" <cfif modo NEQ 'ALTA'> disabled="disabled"</cfif>>
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="W"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMperiodicidad EQ 'W'>selected="selected"</cfif>>Semanal </option>
					<option value="M"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMperiodicidad EQ 'M'>selected="selected"</cfif>>Mensual</option>
					<option value="T"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMperiodicidad EQ 'T'>selected="selected"</cfif>>Trimestral </option>
					<option value="S"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMperiodicidad EQ 'S'>selected="selected"</cfif>>Semestral</option>
					<option value="A"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMperiodicidad EQ 'A'>selected="selected"</cfif>>Anual </option>
				</select>
			</td>
			<td align="right">Perspectiva:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Perspectivas"
						campos = "MIGPerid, MIGPercodigo, MIGPerdescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGPerspectiva"
						columnas="MIGPerid, MIGPercodigo, MIGPerdescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="MIGPercodigo, MIGPerdescripcion"
						etiquetas="Codigo,Perspectiva"
						formatos="S,S"
						align="left,left"
						size="0,20,60"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGPerid=#LvarIDP#"
						filtrar_por="MIGPercodigo, MIGPerdescripcion"
						tabindex="1"
						fparams="MIGPerid"
						/>
			</td>
		</tr>
		<tr>

			<td align="right">Tendencia:</td>
			<td align="left" nowrap="nowrap" >
				<select name="MIGMtendenciapositiva" id="MIGMtendenciapositiva">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="+"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMtendenciapositiva EQ '+'>selected="selected"</cfif>>Positiva </option>
					<option value="-"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMtendenciapositiva EQ '-'>selected="selected"</cfif>>Negativa</option>
					<option value="p"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMtendenciapositiva EQ 'p'>selected="selected"</cfif>>En el Punto</option>
				</select>
			</td>
			<td align="right" nowrap="nowrap">Tipo Tolerancia:</td>
			<td align="left" nowrap="nowrap">
				<select name="MIGMtipotolerancia" id="MIGMtipotolerancia">
						<option value="">-&nbsp;-&nbsp;-</option>
						<option value="A"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMtipotolerancia EQ 'A'>selected="selected"</cfif>>Absoluta </option>
						<option value="P"<cfif modo EQ 'CAMBIO'and rsIndicadores.MIGMtipotolerancia EQ 'P'>selected="selected"</cfif>>Porcentual</option>
				</select>
			</td>
		</tr>
		<tr>

			<td align="right" nowrap="nowrap">Estado:</td>
			<td align="left" nowrap="nowrap">
				<select name="Dactiva" id="Dactiva">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="0"<cfif modo EQ 'CAMBIO'and rsIndicadores.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
					<option value="1"<cfif modo EQ 'CAMBIO'and rsIndicadores.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
				</select>
			</td>
			<td align="right" nowrap="nowrap">Tolerancia Inferior:</td>
			<td align="left">
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
				<td>
					<cfif modo NEQ 'ALTA' and len(trim(rsIndicadores.MIGMtoleranciainferior))>
						<cf_inputNumber name="MIGMtoleranciainferior"  value="#rsIndicadores.MIGMtoleranciainferior#" enteros="18" decimales="4" negativos="false" comas="no">
					<cfelse>
						<cf_inputNumber name="MIGMtoleranciainferior"  value="" enteros="18" decimales="4" negativos="false" comas="no">
					</cfif>
				</td>


				<cfquery datasource="#session.DSN#" name="rsEsCoorporacion">	<!---agrega check si la empresa en coorporativa--->
					select case when Ecorporativa is null Then 'Empresa' else 'Corporación' end as CE,
							case when Ecorporativa is null Then 0 else 1 end as esCorporacion,
							   CuentaEmpresarial.CEcodigo,
							   CuentaEmpresarial.id_direccion,
							   CuentaEmpresarial.Mcodigo,
							   rtrim(LOCIdioma) as LOCIdioma,
							   CEnombre,
							   CEcuenta,
							   CEtelefono1,
							   CEtelefono2,
							   CEfax,
							   CEcontrato,
							   Ecorporativa
					  from CuentaEmpresarial
					  left join Empresa
							  on Empresa.Ecodigo = CuentaEmpresarial.Ecorporativa
					 where  CuentaEmpresarial.CEcodigo = #session.CEcodigo#
					 and Empresa.Ereferencia = #session.Ecodigo#
				</cfquery>
				<cfif modo NEQ 'ALTA'>
					<cfquery datasource="#session.DSN#" name="rsIndCorp">	<!---agrega check si la empresa en coorporativa--->
						select  MIGMescorporativo
						  from MIGMetricas
						 where MIGMid = #form.MIGMid#
					</cfquery>
				</cfif>

				<cfif isdefined('rsEsCoorporacion') and rsEsCoorporacion.esCorporacion EQ 1>
				<td>
						<input name="MIGMescorporativo" type="checkbox" value="1" id="MIGMescorporativo" <cfif isdefined('rsIndCorp.MIGMescorporativo') and rsIndCorp.MIGMescorporativo EQ 1>checked="checked"</cfif>/>Corporativo
				</td>
				<cfelse>
					<td>
						No Corporativa
					</td>
				</cfif>

				</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap">Secuencia:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA' and rsIndicadores.MIGMsequencia GT 0>
					<cf_inputNumber name="MIGMsequencia"  value="#rsIndicadores.MIGMsequencia#" enteros="15" decimales="0" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="MIGMsequencia"  value="" enteros="15" decimales="0" negativos="false" comas="no">
				</cfif>
			</td>
			<td align="right" nowrap="nowrap">Tolerancia Superior:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA' and len(trim(rsIndicadores.MIGMtoleranciasuperior))>
					<cf_inputNumber name="MIGMtoleranciasuperior"  value="#rsIndicadores.MIGMtoleranciasuperior#" enteros="18" decimales="4" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="MIGMtoleranciasuperior"  value="" enteros="18" decimales="4" negativos="false" comas="no">
				</cfif>
			</td>
		</tr>
	  <!---
	  <!---TRAMITES--->
	  <cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
			<cfinvokeargument name="PackageBaseName" value="DMIG" />
	  </cfinvoke>
	  
	  <cfif modo NEQ 'ALTA'>
			<cfquery name="rsTramite" datasource="#Session.DSN#">
				select idTramite
				from MIGMetricas
				where MIGMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsIndicadores.MIGMid#">
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
      <td align="right"><cf_translate XmlFile="/rh/generales.xml" key="LB_TRAMITE">Tr&aacute;mite</cf_translate>
:&nbsp;</td>
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
		</td>
    </tr>--->
	<!---FIN TRAMITES--->
	
		
		<!---<cfif isdefined("LvarInclude") and len(trim(LvarInclude))>--->
		<tr>
			<td height="23" colspan="6" align="center" nowrap>
			<cf_botones modo="#modo#" include="#LvarInclude#" tabindex="1"></td>
		</tr>
		<!---</cfif>--->

		</table>
		</form>
		</td></tr>
</table>
</cfoutput>