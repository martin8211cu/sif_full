<cfif isdefined("Form.EFEid") and Len(Trim(Form.EFEid)) NEQ 0 and isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfif isdefined("Form.IEid") and Len(Trim(Form.IEid)) NEQ 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>
	
	<!--- Encabezado del Formato --->
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select a.EFEcodigo, a.EFEdescripcion, a.TEid
		from EFormatosExpediente a
		where a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">
	</cfquery>
	
	<!--- Tipos de Acciones que puede generar el Formato de Expediente --->
	<cfquery name="rsTipoAcciones" datasource="#Session.DSN#">
		select b.RHTid, 
			   {fn concat(<cf_dbfunction name="to_char" args="b.RHTid" >,{fn concat('|',<cf_dbfunction name="to_char" args="b.RHTpfijo" >)})} as Codigo,
			   {fn concat(rtrim(b.RHTcodigo),{fn concat(' - ',b.RHTdesc)})} as Descripcion
		from AccionesTipoExpediente a
		
		inner join RHTipoAccion b
		  on a.RHTid = b.RHTid
		  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

		where a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">
		and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
	</cfquery>

	<!--- Detalle del Formato --->
	<cfquery name="rsLineas" datasource="#Session.DSN#">
		select a.DFElinea, a.DFEetiqueta, a.DFEorden, a.DFEcaptura, a.ECEid
		from DFormatosExpediente a
		where a.EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">
		order by DFEorden
	</cfquery>

	<!--- Datos del Empleado ocupados por el empleado --->
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, 
			   a.NTIcodigo, 
			   a.DEidentificacion, 
			   a.DEnombre, 
			   a.DEapellido1, 
			   a.DEapellido2, 
			   a.DEfechanac as FechaNacimiento,
			   b.NTIdescripcion
		from DatosEmpleado a
		
		inner join NTipoIdentificacion b
		  on a.NTIcodigo = b.NTIcodigo

		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		<cfif Session.cache_empresarial EQ 1>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfif>
	</cfquery>
	
	<!--- Conceptos --->
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select a.ECEid, a.ECEcodigo, a.ECEdescripcion, a.ECEmultiple
		from ConceptosTipoE d
		inner join EConceptosExpediente a
		  on a.ECEid = d.ECEid
		where d.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
	</cfquery>

	<!--- Detalle de los Conceptos --->
	<cfquery name="rsDetConceptos" datasource="#Session.DSN#">
		select a.ECEid, a.ECEcodigo, a.ECEdescripcion, a.ECEmultiple,
			   b.DCEid, b.DCEcodigo, b.DCEvalor, b.DCEcuantifica, b.DCEanotacion
		from ConceptosTipoE d
		
		inner join EConceptosExpediente a
		  on a.ECEid = d.ECEid
		
		inner join DConceptosExpediente b
		  on a.ECEid = b.ECEid

		where d.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
	</cfquery>

	<!--- Valores por defecto obtenidos de la linea de tiempo del empleado --->
	<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
		select ECEid,
			   DCEid,
			   coalesce(DEEVcant, 0.00) as DEEVcant,
			   coalesce(DEEVanotacion, '*') as DEEVanotacion
		from DExpedienteEmpleadoV
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
	</cfquery>
	<cfif rsLineaTiempo.recordCount GT 0>
		<cfset List_ECEid = Replace(ValueList(rsLineaTiempo.ECEid, ','), ' ', '', 'all')>
		<cfset List_DCEid = Replace(ValueList(rsLineaTiempo.DCEid, ','), ' ', '', 'all')>
		<cfset List_DEEVcant = Replace(ValueList(rsLineaTiempo.DEEVcant, ','), ' ', '', 'all')>
		<cfset List_DEEVanotacion = Replace(ValueList(rsLineaTiempo.DEEVanotacion, ','), ' ', '', 'all')>
	</cfif>
	
	<!--- Valores de un empleado --->
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsLineasExpediente" datasource="#Session.DSN#">
			select b.DFElinea, b.IVvalor, b.DCEid
			from IncidenciasExpediente a
			
			inner join IncidenciasValores b
			  on a.IEid = b.IEid			

			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
			and a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
		</cfquery>
		
		<cfif rsTipoAcciones.recordCount GT 0>
			<cfquery name="rsDatosAccion" datasource="#Session.DSN#">
				select a.RHTid,
					   a.IEdesde,
					   a.IEhasta,
					   a.IEobservaciones,
					   b.RHTpfijo
				from IncidenciasExpediente a
				
				left outer join RHTipoAccion b
				  on a.RHTid = b.RHTid				

				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				  and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
				  and a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
			</cfquery>
		</cfif>
	</cfif>

	<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//Utiles Monto</script>
	<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	</script>
	<cfoutput>
	<script language="javascript" type="text/javascript">
		<cfif rsDetConceptos.recordCount GT 0>
			var conceptos = new Object();
			var anota = new Object();			
			<cfloop query="rsDetConceptos">
				conceptos["#DCEid#"] = #DCEcuantifica#;
				anota["#DCEid#"] = #DCEanotacion#;
			</cfloop>
		</cfif>
		
		function changeConcepto(ctl) {
			var id = ctl.id.substring(ctl.id.indexOf("_")+1, ctl.id.length);
			var a = document.getElementById("cantidad_"+id);
			var b = document.getElementById("cuantifica_"+id);
			var c = document.getElementById("DEEanotacion_"+id);
			var d = document.getElementById("anotacion_"+id);


			if (a != null && b != null) {
				if (conceptos != null && conceptos[ctl.value] != null) {
					if (conceptos[ctl.value] == 1) {
						a.style.display = '';
						b.value = conceptos[ctl.value];
					} else {
						a.style.display = 'none';
						b.value = conceptos[ctl.value];
					}
				}

				if (anota != null && anota[ctl.value] != null) {
					if (anota[ctl.value] == 1) {
						c.style.display = '';
						d.value = anota[ctl.value];
					} else {
						c.style.display = 'none';
						d.value = anota[ctl.value];
					}
				}
			}
		}
	
		function showGen(t) {
			var a = document.getElementById("trGeneraAccion");
			if (t && a) {
				a.style.display = '';
				objForm.RHTid.required = true;
				objForm.IEdesde.required = true;
			} else if (a) {
				a.style.display = 'none';
				objForm.RHTid.required = false;
				objForm.IEdesde.required = false;
			}
		}
		
		function showFhasta(c) {
			var a = c.value.split('|');
			var b = document.getElementById("trFhasta");
			if (a.length > 1 && a[1] == '1') {
				if (b) { 
					b.style.display = '';
					objForm.IEhasta.required = true;
				}
			} else {
				if (b) {
					b.style.display = 'none';
					objForm.IEhasta.required = false;
				}
			}
		}
	</script>
	
	<!---==================== TRADUCCION ======================---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Guardar"
		Default="Guardar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Guardar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Eliminar"
		Default="Eliminar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Eliminar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Aplicar"
		Default="Aplicar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Aplicar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Esta_seguro_de_que_desea_aplicar_este_formulario"
		Default="¿Está seguro de que desea aplicar este formulario?"	
		returnvariable="MSG_Esta_seguro_de_que_desea_aplicar_este_formulario"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Esta_seguro_de_que_desea_eliminar_este_formulario"
		Default="¿Está seguro de que desea eliminar este formulario?"	
		returnvariable="MSG_Esta_seguro_de_que_desea_eliminar_este_formulario"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Tipo_de_Accion"
		Default="Tipo de Acción"	
		returnvariable="MSG_Tipo_de_Accion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Fecha_Inicio"
		Default="Fecha Inicio"	
		returnvariable="MSG_Fecha_Inicio"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Fecha_Fin"
		Default="Fecha Fin"	
		returnvariable="MSG_Fecha_Fin"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	xmlfile='/rh/generales.xml'
	returnvariable="BTN_Regresar"/>
		
	
	<form name="form1" action="save.cfm" method="post" style="margin: 0">
		<input type="hidden" name="TEid" value="#rsEncabezado.TEid#">
		<input type="hidden" name="DEid" value="#Form.DEid#">
		<input type="hidden" name="EFEid" value="#Form.EFEid#">
		<input type="hidden" name="IEfecha" value="#Form.IEfecha#">
		
		<cfif isdefined("Form.IEid") and Len(Trim(Form.IEid)) NEQ 0>
			<input type="hidden" name="IEid" value="#Form.IEid#">
		</cfif>
		<cfset Lvar_IncluyeFechaNac = true>		
		<cfif rsLineas.recordCount GT 0>
			<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2">
					<cfinclude template="/rh/expediente/consultas/frame-infoEmpleado.cfm">
				</td>
			  </tr>
			  <tr>
				<td colspan="2" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
						<cfif modo EQ "CAMBIO">
							<cf_botones values="Guardar,Aplicar,Eliminar,Regresar" names="Guardar,AplicarInside,Eliminar,Regresar" modo="#modo#" align="right">
						<cfelse>
							<cf_botones values="Guardar,Aplicar,Regresar" names="Guardar,AplicarInside,Regresar" modo="#modo#" align="right">
						</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" class="#Session.preferences.Skin#_thcenter">
					<cf_translate key="LB_Conceptos">Conceptos</cf_translate>
				</td>
			  </tr>
			  
				<cfloop query="rsConceptos"> <!--- loop conceptos --->
					<cfquery name="rsDetalleConceptos" dbtype="query">
						select ECEid, DCEid, DCEcodigo, DCEvalor, DCEcuantifica, DCEanotacion
						from rsDetConceptos
						where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.ECEid#">
				  	</cfquery>
			  
					<cfif rsDetalleConceptos.recordCount GT 0> <!--- if tiene detalles --->
						<tr>
							<!--- nombre del concepto (negrita en pantalla) --->
							<td class="fileLabel" width="20%" valign="top" align="right" style="padding-right: 10px; " nowrap>#ECEdescripcion#</td>

							<td>
								<input type="hidden" name="ECEid" id="ECEid" value="#ECEid#">
								<input type="hidden" name="ECEmultiple_#ECEid#" id="ECEmultiple_#ECEid#" value="#ECEmultiple#">
								
								<cfif rsConceptos.ECEmultiple EQ 1>
									<table cellpadding="2" cellspacing="0">
										<cfloop query="rsDetalleConceptos">
											<cfset c = "">
											<cfset cant_valor = "0.00">
											<cfset anot_valor = "">
											<!--- Cargar Datos en Modo Cambio --->
											<cfif modo EQ "CAMBIO">
												<cfquery name="valorConcepto" datasource="#Session.DSN#">
													select coalesce(DEEcant, 0.00) as DEEcant,
															DEEanotacion
													from DExpedienteEmpleado
													where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
													  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
													  and DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleConceptos.DCEid#">
													  and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleConceptos.ECEid#">
													  and IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
												</cfquery>
												<cfif valorConcepto.recordCount GT 0>
													<cfset c = "checked">
													<cfset cant_valor = valorConcepto.DEEcant >
													<cfset anot_valor = valorConcepto.DEEanotacion >
												</cfif>
											<!--- Obtener conceptos de la linea del tiempo --->
											<cfelse>
												<cfif isdefined("List_DCEid") and ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') NEQ 0>
													<cfset c = "checked">
													<cfset cant_valor = ListGetAt(List_DEEVcant, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',')>
													<cfif listlen(List_DEEVanotacion) gte ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') and ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',') neq '*'>
														<cfset anot_valor = ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',')>
													</cfif>
												</cfif>
											</cfif>
											
											
											<tr>
												<td><input type="checkbox" name="DCEid_#ECEid#" id="DCEid_#ECEid#" value="#DCEid#" #c#  onclick="javascript:habilitarImput(this,'#DCEid#');"></td>
												<td>#DCEvalor#
													<input type="hidden" name="DCEcuantifica_#DCEid#" id="DCEcuantifica_#DCEid#" value="#DCEcuantifica#">
													<input type="hidden" name="DCEanotacion_#DCEid#" id="DCEanotacion_#DCEid#" value="#DCEanotacion#">
												</td>
												<cfif rsDetalleConceptos.DCEcuantifica EQ 1>
													<td><input  <cfif c neq 'checked'>disabled</cfif>  type="text" name="DEEcant_#DCEid#" id="DEEcant_#DCEid#" value="#cant_valor#" size="18" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"></td>
												</cfif>
												<cfif rsDetalleConceptos.DCEanotacion EQ 1>
													<td><input  <cfif c neq 'checked'>disabled</cfif>  type="text" name="DEEanotacion_#DCEid#" id="DEEanotacion_#ECEid#" value="#anot_valor#" size="45" maxlength="255" ></td>
												</cfif>
											</tr>
										</cfloop>
									</table>
								<cfelse> <!--- if de ECEmultiple = 1 --->
									<cfset valor = "">
									<cfset cant_valor = "">
									<cfset anot_valor = "">
									<cfif modo EQ "CAMBIO">
										<cfquery name="valorConcepto" datasource="#Session.DSN#">
											select DCEid, coalesce(DEEcant, 0.00) as DEEcant, DEEanotacion
											from DExpedienteEmpleado
											where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.TEid#">
											  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
											  and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalleConceptos.ECEid#">
											  and IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
										</cfquery>
										<cfif valorConcepto.recordCount GT 0>
											<cfset valor = valorConcepto.DCEid>
											<cfset cant_valor = valorConcepto.DEEcant>
											<cfset anot_valor = valorConcepto.DEEanotacion>
										</cfif>
									<cfelse>
										<!--- Obtener conceptos de la linea del tiempo --->
										<cfif isdefined("List_ECEid") and ListFind(List_ECEid, rsDetalleConceptos.ECEid, ',') NEQ 0>
											<cfset valor = ListGetAt(List_DCEid, ListFind(List_ECEid, rsDetalleConceptos.ECEid, ','),',')>
											<cfset cant_valor = ListGetAt(List_DEEVcant, ListFind(List_DCEid, valor, ','),',')>
											<cfif listlen(List_DEEVanotacion) gte ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') and ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, valor, ','),',') neq '*'>
												<cfset anot_valor = ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, valor, ','),',')>

											</cfif>
										</cfif>
									</cfif>
									
									<table cellpadding="2" cellspacing="0">
										<tr>
											<td>
												<select name="DCEid_#ECEid#" id="DCEid_#ECEid#" onChange="javascript: changeConcepto(this);">
												<cfloop query="rsDetalleConceptos">
													<option value="#DCEid#" <cfif valor EQ rsDetalleConceptos.DCEid>selected</cfif>>#DCEvalor#<br>
												</cfloop>
												</select>
												<input type="hidden" name="cuantifica_#ECEid#" id="cuantifica_#ECEid#" value="#rsDetalleConceptos.DCEcuantifica#">
												<input type="hidden" name="anotacion_#ECEid#" id="anotacion_#ECEid#" value="#rsDetalleConceptos.DCEanotacion#">
											</td>
											<td><input type="text" name="cantidad_#ECEid#" id="cantidad_#ECEid#" value="#cant_valor#"  size="18" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="display: none; text-align: right;"></td>
											<td><input type="text" name="DEEanotacion_#ECEid#" id="DEEanotacion_#ECEid#" value="#anot_valor#" size="45" maxlength="255" style="display: none; "></td>
										</tr>
									</table>
									<script language="javascript" type="text/javascript">
										changeConcepto(document.form1.DCEid_#ECEid#);
									</script>
								</cfif><!--- if de ECEmultiple = 1 --->
							</td>
					  	</tr>
					</cfif> <!--- if tiene detalles --->
				</cfloop> <!--- loop conceptos --->

<!--- A PARTIR DE AQUI EMPIEZA A PINTAR LOS DETALLES DEL FORMATO (DIAGNOSTICO,SINTOMAS ETC....)--->
				<tr><td colspan="2" class="#Session.preferences.Skin#_thcenter">#rsEncabezado.EFEdescripcion#</td></tr>
			  	
				<!--- seccion de diagnostico, sintomas, tratamiento --->
				<cfloop query="rsLineas">
					<cfset v_DCEid = 0 >
					<cfif modo EQ "CAMBIO">
						<cfquery name="valorLinea" dbtype="query">
							select *
							from rsLineasExpediente
							where DFElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.DFElinea#">
						</cfquery>
						<cfif len(trim(valorLinea.DCEid))>
							<cfset v_DCEid = valorLinea.DCEid >
						</cfif>
					</cfif>
					<tr><td colspan="2" class="fileLabel">#DFEetiqueta#</td></tr>

					<cfif ListFind('1,2', rsLineas.DFEcaptura)>
						<cfquery name="rs_detallesconcepto" datasource="#session.DSN#">
							select DCEid, DCEcodigo, DCEvalor
							from DConceptosExpediente
							where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.ECEid#">
							order by DCEcodigo
						</cfquery>

						<tr>
							<td colspan="2">
								<select name="Concepto_#DFElinea#">
									<option value="">-<cf_translate xmlfile="/rh/generales.xml" key="LB_Ninguno" >Ninguno</cf_translate>-</option>
									<cfloop query="rs_detallesconcepto">
										<option value="#rs_detallesconcepto.DCEid#" <cfif isdefined('v_DCEid') and v_DCEid eq rs_detallesconcepto.DCEid>selected</cfif> >#trim(rs_detallesconcepto.DCEcodigo)# - #rs_detallesconcepto.DCEvalor#</option>
									</cfloop>
								</select>
							</td>
						</tr>
					<cfelse>
						<input type="hidden" name="Concepto_#DFElinea#" id="DECid__#DFElinea#" value="" />
					</cfif>

					<cfif ListFind('0,2', rsLineas.DFEcaptura)>
						<tr>
							<td colspan="2">
								<textarea name="DFElinea_#DFElinea#" id="DFElinea_#DFElinea#" rows="4" style="width: 100%"><cfif modo EQ "CAMBIO">#trim(valorLinea.IVvalor)#</cfif></textarea>
							</td>
						</tr>
					<cfelse>
						<input type="hidden" name="DFElinea_#DFElinea#" id="DFElinea_#DFElinea#" value="" />
					</cfif>
			  	</cfloop>
			  
			  	<tr><td colspan="2">&nbsp;</td></tr>

			  	<!--- acciones --->
				<cfif rsTipoAcciones.recordCount GT 0>
					<tr>
				  		<td colspan="2">
					  		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          		<tr><td class="fileLabel"><cf_translate key="LB_Generara_Accion">Generar Acci&oacute;n</cf_translate>: <input type="checkbox" name="chkGenAccion" value="1" onClick="javascript: showGen(this.checked);" <cfif modo EQ 'CAMBIO' and Len(Trim(rsDatosAccion.RHTid))> checked</cfif>></td></tr>
						  		
								<tr id="trGeneraAccion" style="display:<cfif (modo EQ 'CAMBIO' and Len(Trim(rsDatosAccion.RHTid)) EQ 0) or modo EQ 'ALTA'> none;</cfif>">
									<td>
										<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								  			<tr><td colspan="2">&nbsp;</td></tr>
                                  			<tr><td colspan="2" class="#Session.preferences.Skin#_thcenter"><cf_translate key="LB_Seleccione_la_accion_a_generar">Seleccione la acci&oacute;n a generar</cf_translate></td></tr>
								  			<tr><td colspan="2">&nbsp;</td></tr>
								  			<tr>
												<td class="fileLabel" width="15%" align="right" style="padding-right: 10px; " nowrap><cf_translate key="LB_Tipo_de_accion">Tipo de Acci&oacute;n</cf_translate>: </td>
												<td><select name="RHTid" onChange="javascript: showFhasta(this);">
														<option value="">-- <cf_translate key="LB_Seleccione_un_tipo_de_accion">Seleccione un tipo de acci&oacute;n</cf_translate> --</option>
														<cfloop query="rsTipoAcciones">
															<option value="#rsTipoAcciones.Codigo#" <cfif modo EQ 'CAMBIO' and rsTipoAcciones.RHTid EQ rsDatosAccion.RHTid> selected</cfif>>#rsTipoAcciones.Descripcion#</option>
														</cfloop>
													</select>
												</td>
								  			</tr>
								  
								  			<tr>
												<td class="fileLabel" align="right" style="padding-right: 10px; " nowrap><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate>: </td>
												<td>
													<cfif modo EQ "CAMBIO">
														<cfset fecha1 = LSDateFormat(rsDatosAccion.IEdesde,'dd/mm/yyyy')>
													<cfelse>
														<cfset fecha1 = LSDateFormat(Now(), 'dd/mm/yyyy')>
													</cfif>
													<cf_sifcalendario form="form1" name="IEdesde" value="#fecha1#">
												</td>
								  			</tr>
								  
								  			<tr id="trFhasta" style="display: <cfif (modo EQ 'CAMBIO' and rsDatosAccion.RHTpfijo EQ 0) or modo EQ 'ALTA'> none;</cfif>">
												<td class="fileLabel" align="right" style="padding-right: 10px;" nowrap><cf_translate key="LB_Fecha_Fin">Fecha Fin</cf_translate>: </td>
												<td>
													<cfif modo EQ "CAMBIO">
														<cfset fecha2 = LSDateFormat(rsDatosAccion.IEhasta,'dd/mm/yyyy')>
													<cfelse>
														<cfset fecha2 = "">
													</cfif>
													<cf_sifcalendario form="form1" name="IEhasta" value="#fecha2#">
												</td>
								  			</tr>

											<tr>
												<td class="fileLabel" align="right" style="padding-right: 10px; " nowrap><cf_translate key="LB_Observaciones">Observaciones</cf_translate>: </td>
												<td><input type="text" name="IEobservaciones" maxlength="255" style="width: 100%;" value="<cfif modo EQ 'CAMBIO'>#rsDatosAccion.IEobservaciones#</cfif>"></td>
											</tr>
								  
								  			<tr><td colspan="2">&nbsp;</td></tr>
										</table>
									</td>
						  		</tr>
                        	</table>
						</td>
				  	</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</cfif>
			  	<tr>
					<td colspan="2" bgcolor="##EEEEEE" align="right" style="border-top: 1px solid darkgray; border-bottom: 1px solid darkgray ">
						<cfif modo EQ "CAMBIO">
							<cf_botones values="Guardar,Aplicar,Eliminar,Regresar" names="Guardar,AplicarInside,Eliminar,Regresar" modo="#modo#" align="right">
						<cfelse>
							<cf_botones values="Guardar,Aplicar,Regresar" names="Guardar,AplicarInside,Regresar" modo="#modo#" align="right">
						</cfif>
					</td>
			  	</tr>
			  	<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</cfif>
	</form>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		<cfoutput>
			<cfif rsTipoAcciones.recordCount GT 0>
				<cfif modo EQ 'CAMBIO' and Len(Trim(rsDatosAccion.RHTid)) NEQ 0>
					objForm.RHTid.required = true;
					objForm.IEdesde.required = true;
				<cfelse>
					objForm.RHTid.required = false;
					objForm.IEdesde.required = false;
				</cfif>
				
				objForm.RHTid.description = "#MSG_Tipo_de_Accion#";
				objForm.IEdesde.description = "#MSG_Fecha_Inicio#";
				
				<cfif modo EQ 'CAMBIO' and rsDatosAccion.RHTpfijo EQ 1>
					objForm.IEhasta.required = true;
				<cfelse>
					objForm.IEhasta.required = false;
				</cfif>
				objForm.IEhasta.description = "#MSG_Fecha_Fin#";
			</cfif>
		</cfoutput>
		function  habilitarImput(obj,imput) {
			var campo_DEEcant      = eval("document.form1.DEEcant_" + imput);
			var campo_DEEanotacion = eval("document.form1.DEEanotacion_" + imput)	;
			
			if (obj.checked==true){
				if(campo_DEEcant){
					campo_DEEcant.disabled=false;
					campo_DEEcant.focus();
				}
				if(campo_DEEanotacion){
					campo_DEEanotacion.disabled=false;
					campo_DEEanotacion.focus();
				}

				
			}else{
				if(campo_DEEcant){
					campo_DEEcant.disabled=true;
				}
				if(campo_DEEanotacion){
					campo_DEEanotacion.disabled=true;
				}
			}  <!------>
		}
		
		<!--- FUNCIONES DE BOTONES --->
		<cfoutput>
		function funcAplicar(){
			return (confirm('#MSG_Esta_seguro_de_que_desea_aplicar_este_formulario#'));
		}
		function funcEliminar(){
			return (confirm('#MSG_Esta_seguro_de_que_desea_eliminar_este_formulario#'));
		}
		function  funcRegresar(){
			location.href = "/cfmx/rh/expedientemng/Expediente.cfm?<cfif isdefined('form.IEid')>DEid=<cfoutput>#form.DEid#</cfoutput>&IEid=<cfoutput>#form.IEid#</cfoutput>&TEid=<cfoutput>#form.TEid#</cfoutput>&EFEid=<cfoutput>#form.EFEid#</cfoutput></cfif>";
			return false;
		}
		</cfoutput>
	</script>


<cfelse>
	<cf_translate key="LB_El_formato_escogido_es_invalido">El formato escogido es inv&aacute;lido</cf_translate>
</cfif>
