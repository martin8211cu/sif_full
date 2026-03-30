<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
	<br>
	<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		function validar(f) {
			f.obj.HOdia.disabled = false;
			f.obj.HOinicio1.disabled = false;
			f.obj.HOinicio2.disabled = false;		
		}
	</script>
	<cf_web_portlet border="true" titulo="Horario del Curso" skin="#Session.Preferences.Skin#">
	<cfoutput>
	
		<cfquery name="rsAulas" datasource="#Session.DSN#">
			select convert(varchar, b.AUcodigo) as AUcodigo,
				   b.AUcodificacion || ': ' || b.AUnombre as Descripcion
			from Edificio a, Aula b
			where a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCurso.Scodigo#">
			and a.EDcodigo = b.EDcodigo
			order by b.AUcodificacion
		</cfquery>
		<cfset modoHorario = "ALTA">
		<cfif isdefined("Form.HOinicio") and Len(Trim(Form.HOinicio)) and isdefined("Form.HOdia") and Len(Trim(Form.HOdia)) NEQ 0>
			<cfset modoHorario = "CAMBIO">
		</cfif>
		
		<cfif modoHorario EQ "CAMBIO">
			<cfquery name="rsHorarioSel" datasource="#Session.DSN#">
				select a.HOdia,
					   substring(convert(varchar, a.HOinicio), 1, charindex('.', convert(varchar, a.HOinicio))-1) as HOinicio1,
					   substring(convert(varchar, a.HOinicio), charindex('.', convert(varchar, a.HOinicio))+1, char_length(convert(varchar, a.HOinicio))) as HOinicio2,
					   substring(convert(varchar, a.HOfinal), 1, charindex('.', convert(varchar, a.HOfinal))-1) as HOfinal1,
					   substring(convert(varchar, a.HOfinal), charindex('.', convert(varchar, a.HOfinal))+1, char_length(convert(varchar, a.HOfinal))) as HOfinal2,
					   convert(varchar, a.AUcodigo) as AUcodigo
				from Horario a
				where a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccodigo#">
				and a.HOdia = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.HOdia#">
				and a.HOinicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HOinicio#" scale="2">
			</cfquery>
		</cfif>
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="50%" valign="top">
				<cfif session.MoG EQ "G">
					<cfset LvarIrA = "CursoGeneracion.cfm">
				<cfelse>
					<cfset LvarIrA = "CursoMantenimiento.cfm">
				</cfif>
				<cfset LvarColumnas =
					"convert(varchar, a.Ccodigo) as Ccodigo, 
					a.HOdia, 
					case HOdia when 1 then 'Domingo' when 2 then 'Lunes' when 3 then 'Martes' when 4 then 'Miércoles' when 5 then 'Jueves' when 6 then 'Viernes' when 7 then 'Sábado' else '' end as Dia,
					a.HOinicio,
					a.HOfinal,
					case when a.AUcodigo is null then '(No asignado)' else
					b.AUcodificacion || ': ' || b.AUnombre end as AulaH">
					<cfif isdefined("form.CILtipoCicloDuracion")>
						<cfset LvarColumnas = LvarColumnas & 
										",'#form.CILcodigo#' as CILcodigo
										,'#form.CILtipoCicloDuracion#' as CILtipoCicloDuracion
										,'#Form.PLcodigo#' as PLcodigo
										,'#Form.EScodigo#' as EScodigo
										,'#Form.CARcodigo#' as CARcodigo
										,'#Form.GAcodigo#' as GAcodigo
										,'#Form.PEScodigo#' as PEScodigo
										,'#Form.txtMnombreFiltro#' as txtMnombreFiltro
										,'#Form.Scodigo#' as Scodigo
										,'#form.Mcodigo#' as Mcodigo">
						<cfif form.CILtipoCicloDuracion EQ "E">
							<cfset LvarColumnas = LvarColumnas & ",'#Form.PEcodigo#' as PEcodigo">
						</cfif>
					</cfif>
				<cfinvoke 
				 component="educ.componentes.pListas"
				 method="pListaEdu"
				 returnvariable="pListaEduRet">
					<cfinvokeargument name="tabla" value="Horario a, Aula b"/>
					<cfinvokeargument name="columnas" value="#LvarColumnas#"/>
					<cfinvokeargument name="desplegar" value="Dia, HOinicio, HOfinal, AulaH"/>
					<cfinvokeargument name="etiquetas" value="D&iacute;a, Hora Inicio, Hora Fin, Aula"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value=" a.Ccodigo = #Form.Ccodigo#
															and b.Ecodigo = #Session.Ecodigo# 
															and b.AUcodigo =* a.AUcodigo
															order by a.HOdia, a.HOinicio, a.HOfinal"/>
					<cfinvokeargument name="align" value="left, center, center, left"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="keys" value="Ccodigo, HOdia, HOinicio"/>
					<cfinvokeargument name="irA" value="#LvarIrA#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</td>
			<td valign="top">
				<form name="frmHorario" id="frmHorario" method="post" action="CursoHorario_SQL.cfm" style="margin: 0;" onSubmit="javascript: return validar(this);">
					<cfif isdefined("form.CILtipoCicloDuracion")>
						<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
						<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
						<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
						<cfif form.CILtipoCicloDuracion EQ "E">
						<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
						</cfif>
						<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
						<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
						<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
						<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
						<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
						<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
						<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
					</cfif>
					<input type="hidden" name="Ccodigo" id="Ccodigo" value="#form.Ccodigo#">
					<cfif modoHorario EQ "CAMBIO">
						<input type="hidden" name="HOinicio" value="#Form.HOinicio#">
					</cfif>
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td colspan="2" align="right" class="fileLabel">&nbsp;</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right" width="50%">D&iacute;a: </td>
						<td><select name="HOdia" id="HOdia" <cfif modoHorario EQ 'CAMBIO'>disabled</cfif>>
						  <option value="2" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 2>selected</cfif>>Lunes</option>
						  <option value="3" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 3>selected</cfif>>Martes</option>
						  <option value="4" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 4>selected</cfif>>Mi&eacute;rcoles</option>
						  <option value="5" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 5>selected</cfif>>Jueves</option>
						  <option value="6" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 6>selected</cfif>>Viernes</option>
						  <option value="7" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 7>selected</cfif>>S&aacute;bado</option>
						  <option value="1" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.HOdia EQ 1>selected</cfif>>Domingo</option>
						</select></td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right">Hora Inicio: </td>
						<td>
							 <input name="HOinicio1" type="text" id="HOinicio1" <cfif modoHorario EQ 'CAMBIO'>disabled</cfif> style="text-align:right;" size="3" maxlength="2" <cfif modoHorario EQ 'CAMBIO'>value="#rsHorarioSel.HOinicio1#"</cfif> onKeyUp="javascript:snumber(this,event,0);" onblur="javascript:if (parseInt(this.value) > 23) this.value=23;">
							:<input name="HOinicio2" type="text" id="HOinicio2" <cfif modoHorario EQ 'CAMBIO'>disabled</cfif> size="3" maxlength="2" <cfif modoHorario EQ 'CAMBIO'>value="#rsHorarioSel.HOinicio2#"</cfif> onKeyUp="javascript:snumber(this,event,0);" onblur="javascript:if (parseInt(this.value) > 59) this.value=59; else if (this.value=='') this.value=0;if (this.value.length == 1) this.value='0' + this.value;">
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right">Hora Fin: </td>
						<td>
							 <input name="HOfinal1" type="text" id="HOfinal1" style="text-align:right;" size="3" maxlength="2" <cfif modoHorario EQ 'CAMBIO'>value="#rsHorarioSel.HOfinal1#"</cfif> onKeyUp="javascript:snumber(this,event,0);" onblur="javascript:if (parseInt(this.value) > 23) this.value=23;">
							:<input name="HOfinal2" type="text" id="HOfinal2" size="3" maxlength="2" <cfif modoHorario EQ 'CAMBIO'>value="#rsHorarioSel.HOfinal2#"</cfif> onKeyUp="javascript:snumber(this,event,0);" onblur="javascript:if (parseInt(this.value) > 59) this.value=59; else if (this.value=='') this.value=0;if (this.value.length == 1) this.value='0' + this.value;">
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right">Aula: </td>
						<td>
							<select name="AUcodigo">
								<option value="0">(No asignado)</option>
							<cfloop query="rsAulas">
								<option value="#rsAulas.AUcodigo#" <cfif modoHorario EQ 'CAMBIO' and rsHorarioSel.AUcodigo EQ rsAulas.AUcodigo>selected</cfif>>#rsAulas.Descripcion#</option>
							</cfloop>
							</select>
						</td>
					  </tr>
					  <tr>
						<td colspan="2" align="right" class="fileLabel">&nbsp;</td>
					  </tr>
					  <tr>
						<td colspan="2" align="center" class="fileLabel">
							<cfif modoHorario EQ "ALTA">
								<input type="submit" name="Alta" value="Agregar">
							<cfelse>	
								<input type="submit" name="Cambio" value="Cambiar">
								<input type="submit" name="Baja" value="Eliminar">
								<input type="submit" name="Nuevo" value="Nuevo">
							</cfif>
						</td>
					  </tr>
					  <tr>
						<td colspan="2" align="right" class="fileLabel">&nbsp;</td>
					  </tr>
					</table>
				</form>
			</td>
		  </tr>
		</table>
	
	</cfoutput>
	<script language="javascript" type="text/javascript">
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("frmHorario");

		objForm.HOinicio1.required = true;
		objForm.HOinicio1.description = "Hora Inicio";
		objForm.HOfinal1.required = true;
		objForm.HOfinal1.description = "Hora Fin";
	</script>
	</cf_web_portlet>
	
</cfif>
