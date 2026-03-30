<cfparam name="rsDVD.RHDVDconstante" default="0">

<cfif modo EQ 'cambio'>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetEVariablesDinamicas" returnvariable="rsEVD">
		<cfinvokeargument name="RHEVDid" value="#form.RHEVDid#">
	</cfinvoke>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsEVD.ts_rversion#" returnvariable="tsE"></cfinvoke>
	
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetSiguienteNivel" returnvariable="rsSNivel">
		<cfinvokeargument name="RHEVDid" value="#rsEVD.RHEVDid#">
	</cfinvoke>
</cfif>
<cfif modoD EQ 'cambio'>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetDVariablesDinamicas" returnvariable="rsDVD">
		<cfinvokeargument name="RHDVDid" value="#form.RHDVDid#">
	</cfinvoke>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsEVD.ts_rversion#" returnvariable="tsD"></cfinvoke>
</cfif>

<cfoutput>
<table width="100%" border="0" align="center" cellspacing="1" cellpadding="1">
	<tr><td><fieldset><legend>Encabezado</legend>
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
			<form action="VariablesDinamicas-sql.cfm" method="post" name="EForm">
				<tr><td width="50%" align="right">Código:</td>
					<td><input type="text" maxlength="10" id="RHEVDcodigo" name="RHEVDcodigo" value="<cfif modo EQ 'cambio'>#rsEVD.RHEVDcodigo#</cfif>"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td align="right">Descripción:</td>
					<td><input type="text" maxlength="60" id="RHEVDdescripcion" name="RHEVDdescripcion" value="<cfif modo EQ 'cambio'>#rsEVD.RHEVDdescripcion#</cfif>"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td align="right">Tipo:</td>
					<td>
						<select name="RHEVDtipo">
						  <option value="1" <cfif modo EQ 'cambio' and rsEVD.RHEVDtipo eq '1'>selected</cfif>>Finiquito</option>
						  <option value="2" <cfif modo EQ 'cambio' and rsEVD.RHEVDtipo eq '2'>selected</cfif>>Liquidación</option>
						  <option value="3" <cfif modo EQ 'cambio' and rsEVD.RHEVDtipo eq '3'>selected</cfif>>PTU</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">
						<cf_botones modo='#modo#' sufijo="_E">
						<cfif modo EQ 'cambio'>
							<input type="hidden" name="RHEVDid" 	value="#rsEVD.RHEVDid#" />
							<input type="hidden" name="ts_rversion" value="#tsE#">
						</cfif>
					</td>
				</tr>
			</form>
		</table>
	</fieldset></td></tr>
	<cfif modo EQ 'cambio'>
		<tr><td><fieldset><legend>Detalles</legend>
			<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="50%"><table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
						<tr><td colspan="2">
							<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetDVariablesDinamicas" returnvariable="rsListadoDVD">
								<cfinvokeargument name="Ecodigo" value="#session.ecodigo#">
								<cfinvokeargument name="RHEVDid" value="#rsEVD.RHEVDid#">
								<cfinvokeargument name="OrderBy" value="RHDVDnivel">
								<cfif isdefined('form.RHEVDcodigo') and len(trim(form.RHEVDcodigo))>
									<cfinvokeargument name="RHEVDcodigo" 	  value="#form.RHEVDcodigo#">
								</cfif>
								<cfif isdefined('form.RHEVDdescripcion') and len(trim(form.RHEVDdescripcion))>
									<cfinvokeargument name="RHEVDdescripcion"  value="#form.RHEVDdescripcion#">
								</cfif>
							</cfinvoke>
							<cfquery name="rsRHDVDtipo" datasource="#session.dsn#">
									select -1 as value, '-Todos-' DESCRIPTION	from dual
										union all
									select 1 as value , 'Variable' DESCRIPTION 	from dual
										union all
									select 2 as value, 'Fórmula' DESCRIPTION 	from dual
										union all
									select 3 as value, 'Constante' DESCRIPTION 	from dual
							</cfquery>
							<cfinvoke 
								component		= "sif.Componentes.pListas" 
								method			= "pListaQuery" 
								query			= "#rsListadoDVD#" 
								conexion		= "#session.dsn#"
								desplegar		= "RHDVDcodigo,RHDVDdescripcion,RHDVDtipoDescripcion,RHDVDnivel"
								etiquetas		= "Código,Descripción,Tipo,Nivel"
								formatos		= "S,S,S,U"
								mostrar_filtro	= "true"
								align			= "left,left,left,center"
								checkboxes		= "N"
								irA				= "VariablesDinamicas.cfm"
								rsRHDVDtipoDescripcion		= "#rsRHDVDtipo#"
								keys			= "RHDVDid"
							>
						</td></tr>
					</table></td>
					<td><table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
						<form action="VariablesDinamicas-sql.cfm" method="post" name="DForm">
						<tr><td width="18%">Código:</td>
							<td><input type="text" maxlength="10" id="RHDVDcodigo" name="RHDVDcodigo" value="<cfif modoD EQ 'cambio'>#rsDVD.RHDVDcodigo#</cfif>"></td>
						</tr>
						<tr><td>Descripción:</td>
							<td><input type="text" maxlength="60" id="RHDVDdescripcion" name="RHDVDdescripcion" value="<cfif modoD EQ 'cambio'>#rsDVD.RHDVDdescripcion#</cfif>"></td>
						</tr>
						<tr><td>Nivel:</td>
							<td><input type="text" id="RHDVDnivel" name="RHDVDnivel" readonly="yes" style="background-color:##CCCCCC" value="<cfif modoD EQ 'cambio'>#rsDVD.RHDVDnivel#<cfelse>#rsSNivel#</cfif>"></td>
						</tr>
						<tr><td>Tipo:</td>
							<td>
								<select name="RHDVDtipo" onchange="fnCambiarTipo(this.value);fnSetCamposRequeridos(this.value);">
									<option value="1" <cfif modoD EQ 'cambio' and rsDVD.RHDVDtipo eq '1'>selected</cfif>>Variable</option>
									<option value="2" <cfif modoD EQ 'cambio' and rsDVD.RHDVDtipo eq '2'>selected</cfif>>Formula</option>
									<option value="3" <cfif modoD EQ 'cambio' and rsDVD.RHDVDtipo eq '3'>selected</cfif>>Constante</option>
								</select>
							</td>
						</tr>
						<tr id="Tipo1" align="center">
							<td colspan="2">
								<cfif modoD EQ 'cambio'>
									<cfif rsDVD.RHDVDtipo neq '1'>
										<input type="submit" name="Cambio_D" id="Cambio_D" value="Formular" class="btnNormal" onclick="fnFormular()"/>
									<cfelse>
										<input type="submit" name="variable" id="variable" value="Formular" class="btnNormal" onclick="fnFormular()"/>
									</cfif>
								<cfelse>
									<input type="submit" name="Alta_D" id="Alta_D" value="Formular" class="btnNormal" onclick="fnFormular()"/>
								</cfif>
							</td>
						</tr>
						<tr id="Tipo2A">
							<td width="20%">Valor 1:</td>
							<td>
								<cfset valuesList ="">
								<cfif modoD EQ 'cambio' and len(trim(rsDVD.RHDVDconceptoA))>
									<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetDVariablesDinamicas" returnvariable="rsRHDVDid">
										<cfinvokeargument name="RHDVDid" value="#rsDVD.RHDVDconceptoA#">
									</cfinvoke>
									<cfset valuesList ="#rsRHDVDid.RHDVDid#|#rsRHDVDid.RHDVDcodigo#|#rsRHDVDid.RHDVDdescripcion#">
								</cfif>
								<cf_conlis
								Campos="RHDVDidV1,RHDVDcodigoV1,RHDVDdescripcionV1"
								valuesArray = "#ListToArray(valuesList,'|')#"
								tabindex="1"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								form="DForm"
								Size="0,10,45"
								Title="Lista de Niveles"
								Tabla="RHDVariablesDinamicas"
								Columnas="RHDVDid as RHDVDidV1,RHDVDcodigo as RHDVDcodigoV1,RHDVDdescripcion as RHDVDdescripcionV1"
								Filtro="Ecodigo = #Session.Ecodigo# and RHEVDid = #rsEVD.RHEVDid# and RHDVDnivel < $RHDVDnivel,numeric$ order by RHDVDcodigo,RHDVDdescripcion"
								Desplegar="RHDVDcodigoV1,RHDVDdescripcionV1"
								Etiquetas="C&oacute;digo,Descripci&oacute;n"
								filtrar_por="RHDVDcodigo,RHDVDdescripcion"
								Formatos="S,S"
								Align="left,left"
								Asignar="RHDVDidV1,RHDVDcodigoV1,RHDVDdescripcionV1"
								Asignarformatos="I,S,S"/>
							</td>
						</tr>
						<tr id="Tipo2B">
							<td>Operación:</td>
							<td>
								<select name="RHDVDoperacion">
									<option value="-" <cfif modoD EQ 'cambio' and rsDVD.RHDVDoperacion eq '-'>selected</cfif>>- Resta</option>
									<option value="+" <cfif modoD EQ 'cambio' and rsDVD.RHDVDoperacion eq '+'>selected</cfif>>+ Suma</option>
									<option value="*" <cfif modoD EQ 'cambio' and rsDVD.RHDVDoperacion eq '*'>selected</cfif>>* Multiplicación</option>
									<option value="/" <cfif modoD EQ 'cambio' and rsDVD.RHDVDoperacion eq '/'>selected</cfif>>/ División</option>
								</select>
							</td>
						</tr>
						<tr id="Tipo2C">
							<td>Valor 2:</td>
							<td>
								<cfset valuesList ="">
								<cfif modoD EQ 'cambio' and len(trim(rsDVD.RHDVDconceptoB))>
									<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetDVariablesDinamicas" returnvariable="rsRHDVDid">
										<cfinvokeargument name="RHDVDid" value="#rsDVD.RHDVDconceptoB#">
									</cfinvoke>
									<cfset valuesList ="#rsRHDVDid.RHDVDid#|#rsRHDVDid.RHDVDcodigo#|#rsRHDVDid.RHDVDdescripcion#">
								</cfif>
								<cf_conlis
								Campos="RHDVDidV2,RHDVDcodigoV2,RHDVDdescripcionV2"
								valuesArray = "#ListToArray(valuesList,'|')#"
								tabindex="1"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								form="DForm"
								Size="0,10,45"
								Title="Lista de Niveles"
								Tabla="RHDVariablesDinamicas"
								Columnas="RHDVDid as RHDVDidV2,RHDVDcodigo as RHDVDcodigoV2,RHDVDdescripcion as RHDVDdescripcionV2"
								Filtro="Ecodigo = #Session.Ecodigo# and RHEVDid = #rsEVD.RHEVDid# and RHDVDnivel < $RHDVDnivel,numeric$ order by RHDVDcodigo,RHDVDdescripcion"
								Desplegar="RHDVDcodigoV2,RHDVDdescripcionV2"
								Etiquetas="C&oacute;digo,Descripci&oacute;n"
								filtrar_por="RHDVDcodigo,RHDVDdescripcion"
								Formatos="S,S"
								Align="left,left"
								Asignar="RHDVDidV2,RHDVDcodigoV2,RHDVDdescripcionV2"
								Asignarformatos="I,S,S"/>
							</td>
						</tr>
						<tr id="Tipo3">
							<td>Valor:</td>
							<td><cf_monto name="RHDVDconstante" value="#rsDVD.RHDVDconstante#" decimales="2" negativos="false">
						</tr>
						<tr><td colspan="2">
							<cf_botones modo='#modoD#' sufijo="_D">
							<input type="hidden" name="RHEVDid" 	value="#rsEVD.RHEVDid#" />
							<input type="hidden" name="formular" 	value="0" />
							
							<cfif modoD EQ 'cambio'>
								<input type="hidden" name="RHDVDid" 	value="#rsDVD.RHDVDid#" />
								<input type="hidden" name="ts_rversion" value="#tsD#">
							</cfif>
						</td></tr>
						</form>
					</table></td>
				</tr>
			</table>
		</fieldset></td></tr>		
		<cf_qforms form="DForm" objForm="objDForm">
			<cf_qformsRequiredField name="RHDVDcodigo" 	 	description="Código">
			<cf_qformsRequiredField name="RHDVDdescripcion" description="Descripción">
			<cf_qformsRequiredField name="RHDVDnivel"       description="Nivel">
			<cf_qformsRequiredField name="RHDVDtipo"        description="Tipo">
		</cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objDForm.RHDVDconstante.description = "Valor";
			objDForm.RHDVDidV1.description = "Valor 1";
			objDForm.RHDVDidV2.description = "Valor 2";
			objDForm.RHDVDoperacion.description = "Operación";
			
			function fnCambiarTipo(valor){
				document.getElementById('Tipo1').style.display = (valor == 1 ? "" : "none");
				document.getElementById('Tipo2A').style.display = (valor == 2 ? "" : "none");
				document.getElementById('Tipo2B').style.display = (valor == 2 ? "" : "none");
				document.getElementById('Tipo2C').style.display = (valor == 2 ? "" : "none");
				document.getElementById('Tipo3').style.display = (valor == 3 ? "" : "none");
			}
			
			function fnSetCamposRequeridos(valor){
				
				objDForm.RHDVDconstante.required = (valor == 1 ? true : false);
				objDForm.RHDVDidV1.required = (valor == 2 ? true : false);
				objDForm.RHDVDidV2.required = (valor == 2 ? true : false);
				objDForm.RHDVDoperacion.required = (valor == 2 ? true : false);
			}
			
			function fnFormular(){
				if(!document.DForm.RHDVDid <cfif modoD EQ 'cambio' and rsDVD.RHDVDtipo neq '1'>|| true</cfif>){
					if(confirm("Es necesario guadar los datos para poder formular, Desea guardar los datos y formular?")){
						document.DForm.formular.value = 1;
						return true;
					}
					return false;
				}else{
					document.DForm.action = "VariablesDinamicas-formular.cfm?EsVarDin=true";
				}
				return true;
			}
			fnCambiarTipo(document.DForm.RHDVDtipo.value);
			fnSetCamposRequeridos(document.DForm.RHDVDtipo.value);
			<cfif isdefined('form.formular') and form.formular eq '1'>
				document.DForm.action = "VariablesDinamicas-formular.cfm?EsVarDin=true";
				document.DForm.submit();
			</cfif>
		</script>
	</cfif>
</table>
<cf_qforms form="EForm" objForm="objEForm">
	<cf_qformsRequiredField name="RHEVDcodigo" 	 	description="Código">
	<cf_qformsRequiredField name="RHEVDdescripcion" description="Descripción">
	<cf_qformsRequiredField name="RHEVDtipo"         description="Tipo">
</cf_qforms>
</cfoutput>
