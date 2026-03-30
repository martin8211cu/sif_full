
<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" >
	<tr>
		<td>&nbsp;</td>
		<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
			<font size="2" color="#000000"><strong><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></strong></font>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>

		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><cf_translate key="LB_DiasAntesParaAsignarVacaciones">D&iacute;as antes para asignar Vacaciones</cf_translate>:&nbsp;</td>
		<td>
			<input name="RHDiasAntesVac" type="text" style="text-align: right;" tabindex="1"
				   onfocus="javascript:this.value=qf(this); this.select();"
				   onBlur="javascript:fm(this,-1); asignar(this, 'M');"
				   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
				   value="<cfif PvalorDiasAntesVac.RecordCount GT 0 ><cfoutput>#PvalorDiasAntesVac.Pvalor#</cfoutput><cfelse>0</cfif>"
				   size="8" maxlength="3" >
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><cf_translate key="LB_FechaDeUltimaAsignacionDeVacaciones">Fecha &uacute;ltima de asignaci&oacute;n de vacaciones</cf_translate>:&nbsp;</td>
		<td>
			<cfif PvalorUltimaCorridaVac.RecordCount GT 0 and len(trim(PvalorUltimaCorridaVac.Pvalor)) >
				<cf_sifcalendario form="form1" name="RHFechaUltimaCorridaVac" value="#PvalorUltimaCorridaVac.Pvalor#" tabindex="1">
			<cfelse>
				<cf_sifcalendario form="form1" name="RHFechaUltimaCorridaVac" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
			</cfif>

		</td>
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td><cf_translate key="LB_ContralaVacacionesPorPeriodo">Controla vacaciones por periodo</cf_translate>:&nbsp;</td>
		<td><input name="ContralaVacacionesPorPeriodo" type="checkbox" <cfif PvalorControlaVacacionesPorPeriodo.RecordCount gt 0 and PvalorControlaVacacionesPorPeriodo.Pvalor>checked="checked"</cfif>/></td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_Incapacidades">Incapacidades</cf_translate></strong></font>
			</td>
		</tr>
	<tr>
			<td>&nbsp;</td>
			<td bgcolor="#FAFAFA">
				<cf_translate key="LB_ConceptoSubcidioIncapacidad">Concepto de Pago para Subcidio de Incapacidades</cf_translate>
			</td>
			<td>
				<cfset valuesArray = ArrayNew(1)>
				<cfif PvalorConceptoSubsidioIncapacidad.RecordCount GT 0 and trim(PvalorConceptoSubsidioIncapacidad.Pvalor) neq '' >
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and CIid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorConceptoSubsidioIncapacidad.Pvalor#">
					</cfquery>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIid)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIcodigo)>
					<cfset ArrayAppend(valuesArray, rsConcepto.CIdescripcion)>
				</cfif>
				<cf_conlis
					campos="CIidPSI,CIcodigoPSI,CIdescripcionPSI"
					asignar="CIidPSI, CIcodigoPSI, CIdescripcionPSI"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"
					title="#LB_TITULOCONLISCONCEPTOSPAGO#"
					tabla="CIncidentes a"
					columnas="CIid as CIidPSI, CIcodigo as CIcodigoPSI, CIdescripcion as CIdescripcionPSI"
					filtro="Ecodigo = #Session.Ecodigo# and CItipo = 3 and CIcarreracp = 0"
					filtrar_por="CIcodigo,CIdescripcion"
					desplegar="CIcodigoPSI,CIdescripcionPSI"
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


	<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_ReclutamientoYSeleccion">Reclutamiento y Selecci&oacute;n</cf_translate></strong></font>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_AccionDeNombramiento">Acci&oacute;n de Nombramiento</cf_translate>:</td>
		  	<td>

				<cfquery name="accionNomb" datasource="#session.DSN#">
					select RHTcodigo,RHTdesc,RHTid
					 from RHTipoAccion
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHTcomportam = 1
					 order by RHTcodigo,RHTdesc
				</cfquery>
				<cfoutput>
					<select name="accionNomb" tabindex="1">
						<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
						<cfloop query="accionNomb">
							<option value="#accionNomb.RHTid#" <cfif trim(PvalorAccionNombramiento.Pvalor) eq trim(accionNomb.RHTid) >selected</cfif> >#accionNomb.RHTcodigo# - #accionNomb.RHTdesc#</option>
						</cfloop>
					</select>
				</cfoutput>
		  	</td>
	    </tr>

		<tr>
			<td>&nbsp;</td>
		  	<td><cf_translate key="LB_AcciondeCambio">Acci&oacute;n de Cambio</cf_translate>:</td>
		  	<td>

				<cfquery name="accionCambio" datasource="#session.DSN#">
					select RHTcodigo,RHTdesc,RHTid
					 from RHTipoAccion
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHTcomportam = 6
					 order by RHTcodigo,RHTdesc
				</cfquery>
				<cfoutput>
					<select name="accionCambio" tabindex="1">
						<option value="">- <cf_translate key="CBM_Ninguno" XmlFile="/rh/generales.xml">Ninguno</cf_translate> -</option>
						<cfloop query="accionCambio">
							<option value="#accionCambio.RHTid#" <cfif trim(PvalorAccionCambio.Pvalor) eq trim(accionCambio.RHTid) >selected</cfif> >#accionCambio.RHTcodigo# - #accionCambio.RHTdesc#</option>
						</cfloop>
					</select>
				</cfoutput>
		  	</td>
	    </tr>

	    <!--- OPARRALES 2018-08-17
			- Check para decidir si se aplican las acciones o solo se agregan cuando se hacen desde la interfa del reloj checador
		 --->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0">
				<font size="2" color="#000000"><strong><cf_translate key="LB_AccionesPersonal">ACCIONES DE PERSONAL</cf_translate></strong></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>

			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><cf_translate key="LB_AplicarAccionesIRC">Aplicar acciones desde Intefaz de Reloj Checador</cf_translate>:&nbsp;</td>
			<td><input name="PvalorAplicarAccionesIRC" type="checkbox" <cfif PvalorAplicarAccionesIRC.RecordCount gt 0 and PvalorAplicarAccionesIRC.Pvalor>checked="checked"</cfif>/></td>
		</tr>

		<tr><td>&nbsp;</td></tr>

		<tr>
			<td colspan="4" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Agregar"
					Default="Agregar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Agregar"/>

				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="1">
			</td>
		</tr>

</table>