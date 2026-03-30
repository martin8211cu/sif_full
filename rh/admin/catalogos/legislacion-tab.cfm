	<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" >
	<tr>
		<td>&nbsp;</td>
		<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
		<font size="2" color="#000000"><strong><cf_translate key="LB_PuertoRico">Puerto Rico</cf_translate></strong></font>			</td>
	</tr>


	<tr>
		<td colspan="2">
			<input name="VerDatos" tabindex="3"  onclick="javascript : muestracampos()"
			   type="checkbox"
					<cfif PvalorCantidadDiasEnfermedad.Pvalor neq 0 or PvalorAplicaDiasEnfermedad.Pvalor neq 0 or PvalorTopeDiasEnfermedad.Pvalor neq 0
						or PvalorDiasEnfermedadAsignar.Pvalor neq 0 or PvalorProcesaEnf.Pvalor eq 's'>
						checked disabled="disabled"
					</cfif>>
				<cf_translate key="CHK_VerDatos"><strong>VerDatos</strong></cf_translate>
		</td>
	</tr>

	<tr id="Incap" style="display:none">
		<td>&nbsp;</td>
		<td colspan="2" align="left">
		<font size="2" color="#000000"><strong><cf_translate key="LB_Incapacidad">Incapacidad</cf_translate></strong></font>			</td>
	</tr>
	<tr id="PDiaEnf" style="display:none">
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap>
						<input type="checkbox" tabindex="1" name="RHAplicaDiasEnf"
						<cfif PvalorAplicaDiasEnfermedad.RecordCount GT 0 and PvalorAplicaDiasEnfermedad.Pvalor eq '1' >checked</cfif> >
						<cf_translate key="CHK_ProcesaDiasDeEnfermedad">Procesa D&iacute;as de Enfermedad</cf_translate>
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr id="TDiaEnf" style="display:none">
		<td>&nbsp;</td>
		<td><cf_translate key="LB_Tope_Dias_Enfermedad">Tope de d&iacute;as de enfermedad</cf_translate>:&nbsp;</td>
		<td>
			<input name="RHTopesDiasEnf" type="text" style="text-align: right;" tabindex="1"
			   onfocus="javascript:this.value=qf(this); this.select();"
			   onBlur="javascript:fm(this,-1); asignar(this, 'M');"
			   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
			   value="<cfif PvalorTopeDiasEnfermedad.RecordCount GT 0 ><cfoutput>#LSNumberFormat(trim(PvalorTopeDiasEnfermedad.Pvalor))#</cfoutput><cfelse>0</cfif>"
			   size="8" maxlength="3" >
		</td>
	</tr>

	<tr id="CDiaEnfA" style="display:none">
		<td>&nbsp;</td>
		<td><cf_translate key="LB_Tope_Dias_Enfermedad">Cantidad de d&iacute;as para activar proceso de d&iacute;as de enfermedad</cf_translate>:&nbsp;</td>
		<td>
			<input name="RHCantidadDiasEnfermedad" type="text" style="text-align: right;" tabindex="1"
			   onfocus="javascript:this.value=qf(this); this.select();"
			   onBlur="javascript:fm(this,-1); asignar(this, 'M');"
			   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
			   value="<cfif PvalorCantidadDiasEnfermedad.RecordCount GT 0 ><cfoutput>#LSNumberFormat(trim(PvalorCantidadDiasEnfermedad.Pvalor))#</cfoutput><cfelse>0</cfif>"
			   size="8" maxlength="3" >
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr id="CDiaEnfAs" style="display:none">
		<td>&nbsp;</td>
		<td width="1%" nowrap="nowrap"><cf_translate key="LB_Tope_Dias_Enfermedad">Cantidad de d&iacute;as por asignar si cumple requisitos de d&iacute;as de enfermedad</cf_translate>:&nbsp;</td>
		<td>
			<input name="RHDiasEnfermedadAsignar" type="text" style="text-align: right;" tabindex="1"
			   onfocus="javascript:this.value=qf(this); this.select();"
			   onBlur="javascript:fm(this,1); asignar(this, 'M');"
			   onkeyup="javascript:if(snumber(this,event,1)){ if(Key(event)=='13') {this.blur();}}"
			   value="<cfif PvalorDiasEnfermedadAsignar.RecordCount GT 0 ><cfoutput>#LSNumberFormat(trim(PvalorDiasEnfermedadAsignar.Pvalor))#</cfoutput><cfelse>0</cfif>"
			   size="8" maxlength="6" >
		</td>
	</tr>
	<tr id="Vaca" style="display:none">
		<td>&nbsp;</td>
		<td colspan="2" align="left">
			<font size="2" color="#000000"><strong><cf_translate key="LB_Incapacidad">Vacaciones</cf_translate></strong></font>				</td>
	</tr>
	<tr id="VacaPDE" style="display:none">
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td nowrap align="left" colspan="1">
		 <input type="checkbox" tabindex="1"
			name="RHProcesaEnf"
			<cfif PvalorProcesaEnf.RecordCount GT 0 and PvalorProcesaEnf.Pvalor eq 'S' >
			checked
			</cfif> >
				<cf_translate key="CHK_ProcesaDiasDeEnfermedad">Procesa D&iacute;as de Enfermedad</cf_translate>
		</td>
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
			<font size="2" color="#000000"><strong><cf_translate key="LB_Costa_Rica">Costa Rica</cf_translate></strong></font>			</td>
	</tr>

	<tr>
		<td colspan="2">
			<input name="VerDatosCR" tabindex="5"  onclick="javascript : muestracamposCR()"
			   type="checkbox"
					<cfif PvalorRequiereSucAds.Pvalor neq 0 or PvalorRequierePolIns.Pvalor neq 0 or PvalorImpINS.Pvalor neq 0
						or rsImpINS.EIcodigo neq 0 or vn_PvalorSalMinimoINS.Pvalor eq 0 or PvalorPolizaDE.Pvalor eq 0>
						checked disabled="disabled"
					</cfif>>
				<cf_translate key="CHK_VerDatos2"><strong>VerDatos</strong></cf_translate>
		</td>
	</tr>
	<tr id="ReporteCons" style="display:none">
		<td>&nbsp;</td>
		<td colspan="2" align="left">
		<font size="2" color="#000000"><strong><cf_translate key="LB_ReportesyConsultas">Reportes y consultas</cf_translate></strong></font>			</td>
	</tr>
	<tr id="SucAds" style="display:none">
		<td>&nbsp;</td>
		<td width="40%" nowrap><cf_translate key="LB_SucursalAdscritaCCSS">Sucursal Adscrita CCSS</cf_translate>:</td>
		<td>
			<input name="RHSucursalAdscrita" type="text" size="30" maxlength="30" tabindex="1"
			   value="<cfoutput><cfif PvalorRequiereSucAds.RecordCount GT 0 and len(trim(PvalorRequiereSucAds.Pvalor))>#Trim(PvalorRequiereSucAds.Pvalor)#</cfif></cfoutput>"
			   onfocus="javascript:this.select();">
		</td>
	 </tr>

	<tr id="PolINS" style="display:none">
		<td>&nbsp;</td>
	  	<td nowrap><cf_translate key="LB_NumeroDePolizaINS">N&uacute;mero De P&oacute;liza del INS</cf_translate>:</td>
	  	<td>
			<input name="RHPolizaINS" type="text" size="30" maxlength="30" tabindex="1"
			   value="<cfoutput><cfif PvalorRequierePolIns.RecordCount GT 0 and len(trim(PvalorRequierePolIns.Pvalor))>#Trim(PvalorRequierePolIns.Pvalor)#</cfif></cfoutput>"
			   onfocus="javascript:this.select();">
	  	</td>
	</tr>
	<tr id="ExpINS" style="display:none">
	  <td>&nbsp;</td>
	  <td><cf_translate key="LB_ScriptDeExportacionDelInstitutoNacionalDeSeguros">Script de exportaci&oacute;n del Instituto Nacional de Seguros</cf_translate>:</td>
	  <td>
	  	<cfquery name="rsImpINS" datasource="sifcontrol">
			select EIid, EIcodigo, EIdescripcion
			from EImportador
			where EImodulo = 'rh.nomina'
		</cfquery>
		<cfoutput>
			<select name="impINS" tabindex="1">
				<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
					<cfloop query="rsImpINS">
						<option value="#rsImpINS.EIcodigo#"
								<cfif trim(PvalorImpINS.Pvalor) eq trim(rsImpINS.EIcodigo) >
									selected
									</cfif> >
								#rsImpINS.EIcodigo# - #rsImpINS.EIdescripcion#							</option>
						</cfloop>
				</select>
			</cfoutput>
		</td>
	  </tr>
	  <!---======================= Parametro 1110 (Salario minimo aceptado por el INS para exportador de riesgos del trabajo) =============================---->
	  <tr id="SalMINS" style="display:none">
	  	  	<td nowrap>&nbsp;</td>
			<td><cf_translate key="LB_SalarioMinimoDiarioINS">Salario m&iacute;nimo del INS</cf_translate></td>
			<td>
				<input name="salminimoins" type="text" style="text-align: right;" tabindex="1"
			   	onfocus="javascript:this.value=qf(this); this.select();"
			   	onblur="javascript:fm(this,2); asignar(this, 'S');"
			   	onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
			   	value="<cfif vn_PvalorSalMinimoINS GT 0 ><cfoutput>#vn_PvalorSalMinimoINS#</cfoutput><cfelse>0.00</cfif>"
			   	size="10" maxlength="10" >
			</td>
	  </tr>
	  <tr id="PolDE" style="display:none">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td nowrap align="left" colspan="1">
				 <input type="checkbox" tabindex="1"
					name="PolizaDE"
						<cfif PvalorPolizaDE.RecordCount GT 0 and PvalorPolizaDE.Pvalor eq 'S' >
							checked
						</cfif> >
				<cf_translate key="CHK_PolizaDatosEmpleado">Tomar n&uacute;mero de p&oacute;liza de datos empleado</cf_translate>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
			<font size="2" color="#000000"><strong><cf_translate key="LB_Mexico">M&eacute;xico</cf_translate></strong></font>			</td>
		</tr>

		<tr>
			<td colspan="2">
				<input name="VerDatosMX" tabindex="6"  onclick="javascript : muestracamposMX()"
					type="checkbox"
						<cfif PvalorEsmexico.Pvalor neq 0 or PvalorSalarioMinimoZona.Pvalor neq 0 or PvalorModificaSDI.Pvalor neq 0
							or PvalorSMGA.Pvalor neq 0>
							checked disabled="disabled"
						</cfif>>
					<cf_translate key="CHK_VerDatos3"><strong>VerDatos</strong></cf_translate>
			</td>
		</tr>

	   <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0">
				<tr id="SalBMX" style="display:none">
						<td nowrap>
							<input type="checkbox" tabindex="1" name="RHEsmexico"
								<cfif PvalorEsmexico.RecordCount GT 0 and PvalorEsmexico.Pvalor eq '1' >checked</cfif> >
							<cf_translate key="CHK_UtilizaSBC">Utiliza salario base de cotizaci&oacute;n (SBC)</cf_translate>
						</td>
					</tr>
				<tr id="SalBMinZ" style="display:none">
						<td nowrap>
							<input type="checkbox" tabindex="1" name="RHSalarioMinimoZona"
							<cfif PvalorSalarioMinimoZona.RecordCount GT 0 and PvalorSalarioMinimoZona.Pvalor eq '1' >checked</cfif> >
							<cf_translate key="CHK_HabilitarSalarioMinimoporZona">Habilitar Salario M&iacute;nimo por Zona</cf_translate>
						</td>
					</tr>
				<tr id="AMSDI" style="display:none">
						<td nowrap>
							<input type="checkbox" tabindex="1" name="RHModificarSDI"
									<cfif PvalorModificaSDI.RecordCount GT 0 and PvalorModificaSDI.Pvalor eq '1' >checked</cfif> >
							<cf_translate key="CHK_modificarSDI">Activar la modificaci&oacute;n del SDI en Expediente Empleado</cf_translate>
						</td>
					</tr>
				</table>
				</td>
				<tr id="SalMGZ" style="display:none">
				<td>&nbsp;</td>
					<td width="1%" nowrap="nowrap"><cf_translate key="LB_SalarioMinimoGeneralA">Salario M&iacute;nimo General Zona A (SMGA)</cf_translate>:&nbsp;</td>
					<td>
					  <input name="RHSMGA" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,2); asignar(this, 'M');"
					   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorSMGA.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(PvalorSMGA.Pvalor,'none')#</cfoutput><cfelse>0.00</cfif>"
						size="16" maxlength="16" />
					</td>
 		 </tr>
		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap="nowrap"><cf_translate key="LB_UMA">Valor de la Unidad de Medida y Actualizaci&oacute;n (UMA)</cf_translate>:&nbsp;</td>
			<td><input size="16" maxlength="16" name="UMA" style="text-align: right;" id="UMA" type="text" value="<cfif PvalorUMA.RecordCount GT 0><cfoutput>#LSCurrencyFormat(PvalorUMA.Pvalor,'none')#</cfoutput><cfelse>0.00</cfif>"/></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap="nowrap"><cf_translate key="LB_DAguinaldo">Dias de Aguinaldo</cf_translate>:&nbsp;</td>
			<td><input size="16" maxlength="2" name="DAguinaldo" style="text-align: right;" id="DAguinaldo" type="text" value="<cfif PvalorDAguinaldo.RecordCount GT 0><cfoutput>#LSNumberFormat(PvalorDAguinaldo.Pvalor,'__')#</cfoutput><cfelse>0</cfif>"/></td>
		</tr>
		 </tr>
  			<td></td>


		 <tr id="ConPVac" style="display:none">
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ConceptoDePagoVacaciones">Concepto Pago Vacaciones</cf_translate>:&nbsp;</td>
			<td>
				<!---<cfset valuesArray = ArrayNew(1)>
				<cfif PvalorCPagoVacaciones.RecordCount GT 0 and trim(PvalorCPagoVacaciones.Pvalor) neq '' >
					<cfquery name="rsConceptoVac" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPagoVacaciones.Pvalor#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsConceptoVac.CIid)>
					<cfset ArrayAppend(valuesArray, rsConceptoVac.CIcodigo)>
					<cfset ArrayAppend(valuesArray, rsConceptoVac.CIdescripcion)>
				</cfif>--->
				<cf_conlis
					campos="CIidVac,CIcodigoVac,CIdescripcionVac"
					asignar="CIidVac, CIcodigoVac, CIdescripcionVac"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidVac, CIcodigo as CIcodigoVac, CIdescripcion as CIdescripcionVac"
					filtro="Ecodigo = #Session.Ecodigo# and CIcarreracp = 0 and CItipo = 3"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoVac,CIdescripcionVac"
					etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#"
					alt="ID,#LB_CODIGO#,#LB_DESCRIPCION#"
				/>
			</td>
		</tr>
        <!---SML--->
        <tr>
		<td colspan="2">&nbsp;</td>
		<td>
			<cfquery name="rsPrimasVacacional" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 2031
			</cfquery>
			<cfif isdefined('rsPrimasVacacional') and rsPrimasVacacional.RecordCount  and LEN(TRIM(rsPrimasVacacional.Pvalor)) and rsPrimasVacacional.Pvalor NEQ 0>
				<cfquery name="rsCIid" datasource="#session.dsn#">
					select CIid, CIcodigo, CIdescripcion
                    from CIncidentes
					where Ecodigo = #session.Ecodigo#
					and CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPrimasVacacional.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsCIid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsCIid.CIcodigo#</td>
							<td nowrap width="60%">#rsCIid.CIdescripcion#</td>
							<td width="10%"><input name="chkLCIncidentes" type="checkbox" value="#rsCIid.CIid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
		</td>
	</tr>
	<cfset va_arrayIncidencia = ArrayNew(1)>
    <!---SML--->
		<tr id="DedSSal" style="display:none">
			<td>&nbsp;</td>
			<td><cf_translate key="LB_ConceptoDePagoSubsidio">Deducción Subsidio Salario</cf_translate>:&nbsp;</td>
			<td>
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_ListaDeIncidencias"
						default="Lista de Incidencias"
						returnvariable="LB_ListaDeIncidencias"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="Concepto_Incidente"
						default="Concepto Incidente"
						xmlfile="/rh/generales.xml"
						returnvariable="vConcepto"/>
				<cfif PvalorCPagoSubsidio.RecordCount GT 0 and trim(PvalorCPagoSubsidio.Pvalor) neq '' >
					<!---
					<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
						select TDid, TDcodigo, TDdescripcion, TDfinanciada
						from TDeduccion
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPagoSubsidio.Pvalor#">
					</cfquery>

					<cf_rhtipodeduccion tabindex = "1" name = "TDcodigo" desc = "TDdescripcion" id = "TDid" query="#rsTipoDeduccion#" size="60" readOnly="false">
					--->

					<cfset navegacion = "">
					<cfset filtro = "">
					<cfif isdefined("PvalorCPagoSubsidio") and len(trim(PvalorCPagoSubsidio.Pvalor)) gt 0>
						<cfset navegacion = trim(navegacion) & "&CIid_f=#PvalorCPagoSubsidio.Pvalor#">
						<cfset filtro = filtro & " and a.CIid=" & PvalorCPagoSubsidio.Pvalor>
						<cfquery name="rsCIid" datasource="#session.DSN#">
							select CIid, CIcodigo, CIdescripcion
							from CIncidentes
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCPagoSubsidio.Pvalor#">
						</cfquery>
						<cfif isdefined("rsCIid.CIid")>
							<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIid)>
						</cfif>
						<cfif isdefined("rsCIid.CIcodigo")>
							<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIcodigo)>
						</cfif>
						<cfif isdefined("rsCIid.CIdescripcion")>
							<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIdescripcion)>
						</cfif>
					</cfif>

					<cf_conlis title="#LB_ListaDeIncidencias#"
							campos = "CIid_f,CIcodigo_f,CIdescripcion_f"
							desplegables = "N,S,S"
							modificables = "N,S,N"
							size = "0,10,20"
							asignar="CIid_f,CIcodigo_f,CIdescripcion_f"
							asignarformatos="I,S,S"
							tabla="	CIncidentes a"
							columnas="CIid as CIid_f,CIcodigo as CIcodigo_f, CIdescripcion as CIdescripcion_f, CInegativo as CInegativo_f"
							filtro="a.Ecodigo =#session.Ecodigo#
									and CIcarreracp = 0
									and coalesce(a.CInomostrar,0) = 0
									and CItipo <= 3"
							desplegar="CIcodigo_f,CIdescripcion_f"
							etiquetas="	#vConcepto#,
										#LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="CIcodigo,CIdescripcion"
							valuesarray="#va_arrayIncidencia#">
				<cfelse>
					<cf_conlis title="#LB_ListaDeIncidencias#"
							campos = "CIid_f,CIcodigo_f,CIdescripcion_f"
							desplegables = "N,S,S"
							modificables = "N,S,N"
							size = "0,10,20"
							asignar="CIid_f,CIcodigo_f,CIdescripcion_f"
							asignarformatos="I,S,S"
							tabla="	CIncidentes a"
							columnas="CIid as CIid_f,CIcodigo as CIcodigo_f, CIdescripcion as CIdescripcion_f, CInegativo as CInegativo_f"
							filtro="a.Ecodigo =#session.Ecodigo#
									and CIcarreracp = 0
									and coalesce(a.CInomostrar,0) = 0
									and CItipo <= 3"
							desplegar="CIcodigo_f,CIdescripcion_f"
							etiquetas="	#vConcepto#,
										#LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="CIcodigo,CIdescripcion"
							valuesarray="#va_arrayIncidencia#">
					<!--- <cf_rhtipodeduccion tabindex = "1" name = "TDcodigo" desc = "TDdescripcion" id = "TDid" size="60"> --->
				</cfif>
			</td>
		</tr>
		<tr id="CaEmp" style="display:none">
			<td>&nbsp;</td>
			<td><cf_translate key="LB_CargasMostrar">Cargas Empleado</cf_translate>:&nbsp;</td>
			<td>
			<!--- trae las lista de Cargas --->
			<cfset values = ''>
			<cfset valuesArray = ArrayNew(1)>
			<cfif PcargasMostrar.RecordCount GT 0 >
				<cfif len(trim(PcargasMostrar.Pvalor)) GT 0 >
					<cfquery name="rsListaCargas" datasource="#session.DSN#">
						select ECid,ECcodigo,ECdescripcion
						from ECargas
						where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(PcargasMostrar.Pvalor)#">
					</cfquery>
					<cfset values = '#rsListaCargas.ECcodigo#,#rsListaCargas.ECdescripcion#'>
					<cfset ArrayAppend(valuesArray, rsListaCargas.ECid)>
					<cfset ArrayAppend(valuesArray, rsListaCargas.ECcodigo)>
					<cfset ArrayAppend(valuesArray, rsListaCargas.ECdescripcion)>
				</cfif>
			</cfif>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_ListadeCargasEmpleado"
				default="Lista de Cargas Empleado"
				returnvariable="LB_ListadeCargasEmpleado"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_Codigo"
				default="C&oacute;digo"
				returnvariable="LB_Codigo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_Descripcion"
				default="Descripci&oacute;n"
				returnvariable="LB_Descripcion"/>

			<cf_conlis
					campos="ECid,ECcodigo,ECdescripcion "
					asignar="ECid,ECcodigo,ECdescripcion"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_ListadeCargasEmpleado#"
					tabla="ECargas c"
					columnas="ECid,ECcodigo,ECdescripcion"
					filtro="Ecodigo = #Session.Ecodigo# "
					filtrar_por="ECcodigo,ECdescripcion"
					desplegar="ECcodigo,ECdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#"
					alt=""
				/>
    	</td>
    </tr>

	<tr>
		 <td>&nbsp;</td>
		 <td><cf_translate key="LB_Montoporsegurodevivienda">Monto por seguro de vivienda para Infonavit</cf_translate>:</td>
        <td>
            <input name="MtoSeguro" type="text" style="text-align: right;" tabindex="1"
            onfocus="javascript:this.value=qf(this); this.select();"
            onblur="javascript:fm(this,2); asignar(this, 'M');"
            onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
            value="<cfif PvalorMtoSeguro.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(PvalorMtoSeguro.Pvalor,'none')#</cfoutput><cfelse>0.00</cfif>"
            size="16" maxlength="16" />
        </td>


        <!--- <td colspan="2"><input type="text" name="MtoSeguro" value="" />---></td>
	</tr>


    <tr id="LCAINF" style="display:none">
		 <td>&nbsp;</td>
		 <td><cf_translate key="LB_ListadeconceptosaplicadosaInfonavit">Lista de conceptos aplicados a Infonavít</cf_translate>:</td>
		 <td colspan="2"><cf_rhtipodeduccion tabindex = "2"  name = "TDcodigo1" desc = "TDdescripcion1" id = "TDid1"  size="60"></td>
	</tr>
	<tr id="INFO2" style="display:none">
		<td colspan="2">&nbsp;</td>
		<td>
			<cfquery name="rsInfonavit" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo =  2110
			</cfquery>
			<cfif isdefined('rsInfonavit') and rsInfonavit.RecordCount  and LEN(TRIM(rsInfonavit.Pvalor)) and rsInfonavit.Pvalor NEQ 0>
				<cfquery name="rsTDid" datasource="#session.dsn#">
					select TDid, TDcodigo, TDdescripcion
					from TDeduccion
					where Ecodigo = #session.Ecodigo#
					and TDid in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInfonavit.Pvalor#" list="yes">)
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid black;">
					<tr id="INFO" style="display:none">
						<td class="tituloListas" width="10%" nowrap>C&oacute;digo</td>
						<td class="tituloListas" width="60%" nowrap>Descripci&oacute;n</td>
						<td class="tituloListas" width="10%" nowrap>&nbsp;</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<cfoutput query="rsTDid">
						<tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onmouseover="javascript: this.className='listaParSel';" onmouseout="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';">
							<td nowrap width="10%" align="center">#rsTDid.TDcodigo#</td>
							<td nowrap width="60%">#rsTDid.TDdescripcion#</td>
							<td width="10%"><input name="chkLDeduciones" type="checkbox" value="#rsTDid.TDid#" checked="checked"/></td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Agregar"
				Default="Agregar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Agregar"/>
				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="6">
		</td>
	</tr>
	</table>
	<script type="text/javascript" language="javascript1.2">
		function muestracampos(){
			var Incap  		= document.getElementById("Incap");
			var PDiaEnf  	= document.getElementById("PDiaEnf");
			var TDiaEnf		= document.getElementById("TDiaEnf");
			var CDiaEnfA   = document.getElementById("CDiaEnfA");
			var CDiaEnfAs	= document.getElementById("CDiaEnfAs");
			var Vaca		   = document.getElementById("Vaca");
			var VacaPDE		= document.getElementById("VacaPDE");

			if (document.form1.VerDatos.checked ==  true) {
				Incap.style.display		 = '';
				PDiaEnf.style.display 	 = '';
				TDiaEnf.style.display 	 = '';
				CDiaEnfA.style.display 	 = '';
				CDiaEnfAs.style.display  = '';
				Vaca.style.display 		 = '';
				VacaPDE.style.display 	 = '';

			} else {
				Incap.style.display     = 'none';
				PDiaEnf.style.display   = 'none';
				TDiaEnf.style.display 	= 'none';
				CDiaEnfA.style.display  = 'none';
				CDiaEnfAs.style.display = 'none';
				Vaca.style.display 		= 'none';
				VacaPDE.style.display 	= 'none';

				document.form1.RHAplicaDiasEnf.value 	     	= "";
				document.form1.RHTopesDiasEnf.value 		  	= "";
				document.form1.MCuentaPasivo.value 		     	= "";
				document.form1.RHCantidadDiasEnfermedad.value= "";
				document.form1.RHDiasEnfermedadAsignar.value	= "";
				document.form1.RHProcesaEnf.value	 			= "";
				document.form1.DistCargasPat.checked 			= false;
				document.form1.DistCargasEmp.checked 			= false;
			}
		}
		muestracampos();

		function muestracamposCR(){

			var ReporteCons  = document.getElementById("ReporteCons");
			var SucAds  = document.getElementById("SucAds");
			var PolINS	 = document.getElementById("PolINS");
			var ExpINS  = document.getElementById("ExpINS");
			var SalMINS		 = document.getElementById("SalMINS");
			var PolDE		 = document.getElementById("PolDE");

			if (document.form1.VerDatosCR.checked ==  true) {
				ReporteCons.style.display	 	 = '';
				SucAds.style.display 		 = '';
				PolINS.style.display 	 	 = '';
				ExpINS.style.display  		 	 = '';
				SalMINS.style.display   = '';
				PolDE.style.display   = '';

			} else {
				ReporteCons.style.display     = 'none';
				SucAds.style.display     	= 'none';
				PolINS.style.display 		= 'none';
				ExpINS.style.display    		= 'none';
				SalMINS.style.display  = 'none';
				PolDE.style.display  = 'none';

				document.form1.PvalorRequiereSucAds.value 	= "";
				document.form1.PvalorRequierePolIns.value 	= "";
				document.form1.PvalorImpINS.Pvalor.value 		= "";
				document.form1.rsImpINS.EIcodigo.value 		= "";
				document.form1.PvalorPolizaDE.value	 			= "";
				document.form1.DistCargasPat.checked 			= false;
				document.form1.DistCargasEmp.checked 			= false;
			}
		}
		muestracamposCR();

		function muestracamposMX(){

			var SalBMX  	 = document.getElementById("SalBMX");
			var SalBMinZ 	 = document.getElementById("SalBMinZ");
			var AMSDI		 = document.getElementById("AMSDI");
			var SalMGZ		 = document.getElementById("SalMGZ");
			var ConPVac		 = document.getElementById("ConPVac");
			var DedSSal		 = document.getElementById("DedSSal");
			var CaEmp		 = document.getElementById("CaEmp");
			var LCAINF		 = document.getElementById("LCAINF");
			var INFO		 	 = document.getElementById("INFO");
			var INFO2		 = document.getElementById("INFO2");

			if (document.form1.VerDatosMX.checked ==  true) {
				SalBMX.style.display	 	 = '';
				SalBMinZ.style.display 	 = '';
				AMSDI.style.display 	 	 = '';
				SalMGZ.style.display  	 = '';
				ConPVac.style.display    = '';
				DedSSal.style.display    = '';
				CaEmp.style.display      = '';
				LCAINF.style.display     = '';
				INFO.style.display       = '';
				INFO2.style.display      = '';

			} else {
				SalBMX.style.display     = 'none';
				SalBMinZ.style.display   = 'none';
				AMSDI.style.display 		 = 'none';
				SalMGZ.style.display     = 'none';
				ConPVac.style.display    = 'none';
				DedSSal.style.display    = 'none';
				CaEmp.style.display      = 'none';
				LCAINF.style.display     = 'none';
				INFO.style.display       = 'none';
				INFO2.style.display      = 'none';

				document.form1.RHEsmexico.value  = "";
				document.form1.VerDatosMX.value  = "";
				document.form1.RHModificarSDI.value = "";
				document.form1.RHSMGA.value = "";
				document.form1.DistCargasPat.checked 			 = false;
				document.form1.DistCargasEmp.checked 			 = false;
			}
		}
	muestracamposMX();
</script>
