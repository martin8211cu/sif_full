<cfif isdefined("Form.Nuevo") or (isdefined("Form.IEid") and Len(Trim(Form.IEid)))>
	<cfset action = "Expediente.cfm">
<cfelse>
	<cfset action = "Expediente-lista.cfm">
</cfif>

<cfif isdefined("Form.chkGenAccion")>
	<cfset tipoaccion = ListGetAt(Form.RHTid, 1, '|')>
	<cfset fijo = ListGetAt(Form.RHTid, 2, '|')>
</cfif>
<cftransaction>
	<cfif isdefined("Form.Guardar") or isdefined("Form.AplicarInside")>
		<cftry>
			<cfif isdefined("Form.IEid")>	
				<!--- En modo CAMBIO se elimina el detalle del expediente para volverlos a crear --->
				<cfquery datasource="#Session.DSN#">
					delete DExpedienteEmpleado
					where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
				</cfquery>
					
				<cfquery datasource="#Session.DSN#">
					delete IncidenciasValores
					where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
				</cfquery>	
					
				<cfset vIdentity = Form.IEid >
			<cfelse>
				<!--- En modo ALTA se inserta el expediente --->
				<cfquery name="rsEncabezado" datasource="#Session.DSN#">
					insert into IncidenciasExpediente(TEid, DEid, Ecodigo, EFEid, CEcodigo, IEfecha, Usucodigo, Ulocalizacion, IEfcaptura, IEestado, RHTid, IEdesde, IEhasta, IEobservaciones)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.IEfecha)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						0,
					<cfif isdefined("Form.chkGenAccion")>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#tipoaccion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.IEdesde)#">,
						<cfif fijo and len(trim(Form.IEhasta)) >
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.IEhasta)#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IEobservaciones#">
					<cfelse>
						null, null, null, null
					</cfif>
					)
					
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="rsEncabezado">
				<cfset vIdentity = rsEncabezado.identity >
			</cfif>

			<!--- Actualiza el id del expediente en el Form --->
			<cfset Form.IEid = vIdentity >
		
			<!--- Agregar los campos detalle del expediente --->
			<cfloop collection="#Form#" item="i">
				<cfif FindNoCase("DFElinea_", i) NEQ 0>
					<cfset linea = Mid(i, Len("DFElinea_")+1, Len(i)-Len("DFElinea_"))>  <!--- id de la linea --->
					<cfset concepto = 'Concepto_#linea#' >
					<!---<cfif isdefined("form.#i#") and len(trim(form[i])) >--->
					<cfif isdefined("form.#i#") >					
						<cfquery name="rsLinea" datasource="#Session.DSN#">
							insert into IncidenciasValores(IEid, DFElinea, IVvalor, Usucodigo, Ulocalizacion, DCEid)
							values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#linea#">,
									<cfif len(trim(form[i])) >
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.'&i)#">,
									<cfelse>
										' ',	<!--- campo no permite nulos --->
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
									<cfif isdefined("form.#concepto#") and len(trim(form[concepto])) >
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form[concepto]#">
									<cfelse>
										null
									</cfif>	
								)	
						</cfquery>
					</cfif>	
				</cfif>
			</cfloop>

			<!--- Agregar los conceptos del expediente --->
			<cfif isdefined("Form.ECEid")>
				<!--- Buscar todos los conceptos --->
				<cfloop index="i" list="#Form.ECEid#" delimiters=",">
					<cfset valor_ECEid = Trim(i)>
		
					<!--- En caso de que se permita incluir multiples valores para el concepto --->
					<cfif Evaluate("Form.ECEmultiple_"&i) EQ 1>
						<!--- Si al menos hay algun valor seleccionado --->
						<cfif isdefined("Form.DCEid_"&i)>
							<!--- Recorro todos los valores seleccionados --->
							<cfloop index="j" list="#Evaluate('Form.DCEid_'&i)#" delimiters=",">
								<cfset valor_DCEid = Trim(j)>
								
								<cfquery name="rsInsertConcepto" datasource="#Session.DSN#">
									insert into DExpedienteEmpleado (TEid, DEid, DCEid, ECEid, IEid, DEEcant, DEEanotacion, DCEidant, ECEidant, DEEcantant)
									values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_DCEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">,
									<!--- Si tiene una cuantificacion asociada --->
									<cfif Evaluate("Form.DCEcuantifica_"&j) EQ 1 and Len(Trim(Evaluate('Form.DEEcant_'&j))) NEQ 0>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.DEEcant_'&j)#" scale="2">,
									<cfelse>
										null,
									</cfif>
									<!--- Si tiene una cuantificacion asociada --->
									<cfif Evaluate("Form.DCEanotacion_"&j) EQ 1 and Len(Trim(Evaluate('Form.DEEanotacion_'&j))) NEQ 0>
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DEEanotacion_'&j)#" scale="2">,
									<cfelse>
										null,
									</cfif>
										null,
										null,
										null
									)
								</cfquery>
									
								<cfquery name="rsUpdateConcepto" datasource="#Session.DSN#">
									select b.DEEVcant, a.ECEid, a.DCEid, b.DEEVanotacion
									from DExpedienteEmpleado a, DExpedienteEmpleadoV b
									where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
									  and a.ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">
									  and a.DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_DCEid#">
									  and a.DEid = b.DEid
									  and a.TEid = b.TEid
									  and a.ECEid = b.ECEid
									  and a.DCEid = b.DCEid
								</cfquery>
								<cfloop query="rsUpdateConcepto">
									<cfquery datasource="#session.DSN#">
										update DExpedienteEmpleado
										set ECEidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">,
											DCEidant = <cfif len(trim(valor_DCEid)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_DCEid#"><cfelse>null</cfif>,
											DEEcantant = <cfif len(trim(rsUpdateConcepto.DEEVcant)) ><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateConcepto.DEEVcant#"><cfelse>null</cfif>,
											DEEanotacionant = <cfif len(trim(rsUpdateConcepto.DEEVanotacion)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateConcepto.DEEVanotacion#"><cfelse>null</cfif>
										where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
										and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">
										and DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_DCEid#">
									</cfquery>
								</cfloop>
							</cfloop>
						</cfif>
		
					<!--- En caso de que solo se permita un valor por concepto --->
					<cfelseif Evaluate("Form.ECEmultiple_"&i) EQ 0>
						<cfquery name="rsInsertConcepto" datasource="#Session.DSN#">
							insert into DExpedienteEmpleado (TEid, DEid, DCEid, ECEid, IEid, DEEcant, DEEanotacion, DCEidant, ECEidant, DEEcantant)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.DCEid_'&i)#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">,
							<!--- Si tiene una cuantificacion asociada --->
							<cfif Evaluate("Form.cuantifica_"&i) EQ 1 and Len(Trim(Evaluate('Form.cantidad_'&i))) NEQ 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.cantidad_'&i)#" scale="2">,
							<cfelse>
								null,
							</cfif>
							<!--- Si tiene una anotacion asociada --->
							<cfif Evaluate("Form.anotacion_"&i) EQ 1 and Len(Trim(Evaluate('Form.DEEanotacion_'&i))) NEQ 0>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.DEEanotacion_'&i)#" scale="2">,
							<cfelse>
								null,
							</cfif>
								null,
								null,
								null
							)
						</cfquery>
							
						<cfquery name="rsUpdateConcepto" datasource="#Session.DSN#">
							select b.DCEid, b.DEEVcant, a.TEid, b.DEEVanotacion
							from DExpedienteEmpleado a, DExpedienteEmpleadoV b
							where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
							  and a.ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							  and a.DEid = b.DEid
							  and a.TEid = b.TEid
							  and a.ECEid = b.ECEid
						</cfquery>
						<cfloop query="rsUpdateConcepto">
							<cfquery datasource="#session.DSN#">
								update DExpedienteEmpleado
								set ECEidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">,
									DCEidant = <cfif len(trim(rsUpdateConcepto.DCEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateConcepto.DCEid#"><cfelse>null</cfif>,
									DEEcantant = <cfif len(trim(rsUpdateConcepto.DEEVcant))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateConcepto.DEEVcant#"><cfelse>null</cfif>,
									DEEanotacionant = <cfif len(trim(rsUpdateConcepto.DEEVanotacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateConcepto.DEEVanotacion#"><cfelse>null</cfif>
								where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
							  	  and ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor_ECEid#">
								  and DEid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
								  and DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateConcepto.DCEid#">
								  and TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateConcepto.TEid#">
							</cfquery>
						</cfloop>

					</cfif>
				</cfloop>
			</cfif>
			
			<!--- Construir el contenido html y actualizarlo --->
			<cfquery name="rsLineasExpediente" datasource="#Session.DSN#">
				select c.DFEetiqueta, b.IVvalor, b.DCEid
				from IncidenciasExpediente a

				inner join IncidenciasValores b
				  on a.IEid = b.IEid
				
				inner join DFormatosExpediente c
				  on b.DFElinea = c.DFElinea
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				and a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
			</cfquery>
	
			<cfquery name="rsLineasConceptos" datasource="#Session.DSN#">
				select c.ECEid, c.ECEdescripcion, c.ECEmultiple, b.DCEcuantifica, b.DCEvalor, a.DEEcant, b.DCEanotacion, a.DEEanotacion

				from DExpedienteEmpleado a
				
				inner join DConceptosExpediente b
				  on a.ECEid = b.ECEid
				  and a.DCEid = b.DCEid
				
				inner join EConceptosExpediente c
				  on a.ECEid = c.ECEid
				  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">

				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
				and a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
				order by a.ECEid, a.DCEid
			</cfquery>
	
			<cfsavecontent variable="contenidoHTML">
				<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="3">&nbsp;</td></tr>
					<cfoutput>
						<cfif rsLineasConceptos.recordCount GT 0>
							<tr><td colspan="3" class="etiquetaCampo" style="padding-left: 5px; "><cf_translate key="LB_Conceptos">Conceptos</cf_translate></td></tr>
							<cfset concepto = "">
							<cfset conceptoEtiqueta = "">
							<cfloop query="rsLineasConceptos">
								<cfif concepto NEQ rsLineasConceptos.ECEid>
									<cfset concepto = rsLineasConceptos.ECEid>
									<cfset conceptoEtiqueta = rsLineasConceptos.ECEdescripcion>
								<cfelse>
									<cfset conceptoEtiqueta = "&nbsp;">
								</cfif>
								<tr>
									<td class="fileLabel">#conceptoEtiqueta#</td>
									<td >#DCEvalor#</td>
									<cfif rsLineasConceptos.DCEcuantifica EQ 1>
										<td><input type="text" size="20" value="<cfif Len(Trim(rsLineasConceptos.DEEcant)) NEQ 0>#LSCurrencyFormat(rsLineasConceptos.DEEcant, 'none')#</cfif>" style="border: none; text-align: left; " readonly></td>
									<cfelse>
										<td><input type="text" size="20" value="<cfif Len(Trim(rsLineasConceptos.DEEanotacion)) NEQ 0>#rsLineasConceptos.DEEanotacion#</cfif>" style="border: none; text-align: left; " readonly></td>
									</cfif>
								</tr>
							</cfloop>
						</cfif>
						<cfloop query="rsLineasExpediente">
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3" class="etiquetaCampo" style="padding-left: 5px;">#DFEetiqueta#</td>
							</tr>

							<cfif isdefined("rsLineasExpediente.DCEid") and len(trim(rsLineasExpediente.DCEid))>
								<cfquery name="rs_detallesconcepto" datasource="#session.DSN#">
									select DCEcodigo, DCEvalor
									from DConceptosExpediente
									where DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasExpediente.DCEid#">
								</cfquery>
								<tr>
									<td colspan="3">#trim(rs_detallesconcepto.DCEcodigo)# - #rs_detallesconcepto.DCEvalor#</td>
								</tr>
							</cfif>

							<tr>
								<td colspan="3">#IVvalor#</td>
							</tr>
						</cfloop>
					</cfoutput>
				</table>
			</cfsavecontent>
			
			<!--- Acutalizar datos del expediente --->
			<cfquery name="rsUpdateContenido" datasource="#Session.DSN#">
				update IncidenciasExpediente
				set IEcontenido = <cfqueryparam cfsqltype="cf_sql_varchar" value="#contenidoHTML#">,
				<cfif isdefined("Form.chkGenAccion")>
					RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tipoaccion#">,
					IEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.IEdesde)#">, 
					<cfif fijo and len(trim(Form.IEhasta)) >
						IEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.IEhasta)#">, 
					<cfelse>
						IEhasta = null,
					</cfif>
					IEobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IEobservaciones#">
				<cfelse>
					RHTid = null, 
					IEdesde = null, 
					IEhasta = null, 
					IEobservaciones = null
				</cfif>
				where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
			</cfquery>
		
		<cfcatch type="any">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>

	</cfif>
</cftransaction>

<cfif isdefined("Form.btnAplicar") or isdefined("Form.AplicarInside")>
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
	<!--- Preparar codigos de expedientes a procesar para la aplicacion --->
	<cfif isdefined("Form.btnAplicar")>
		<cfset expedientes = ListToArray(Replace(Form.chk, ' ', '', 'all'),',')>
	<cfelseif isdefined("Form.AplicarInside")>
		<cfset expedientes = ArrayNew(1)>
		<cfset expedientes[1] = Trim(Form.IEid)>
	</cfif>

	<cftransaction>
		<cfloop index="expId" from="1" to="#ArrayLen(expedientes)#">
			<!--- Actualizar los conceptos que siguen vigentes y posiblemente con otros valores --->

			<!--- Actualizar los conceptos de escogencia unica --->
			<cfquery name="rsUpdateVigente" datasource="#Session.DSN#">
				select a.DEEVid, a.DCEid, b.DCEid as bDCEid, a.DEEVcant,b.DEEcant, a.DEEVanotacion, b.DEEanotacion
				from DExpedienteEmpleadoV a, DExpedienteEmpleado b, EConceptosExpediente c
				where b.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
				and a.DEid = b.DEid
				and a.TEid = b.TEid
				and a.ECEid = b.ECEid
				and b.ECEid = c.ECEid
				and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and c.ECEmultiple = 0
			</cfquery>
			<cfloop query="rsUpdateVigente">
				<cfquery datasource="#session.DSN#">
					update DExpedienteEmpleadoV
					set DCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateVigente.bDCEid#">,
						DEEVcant = <cfif len(trim(rsUpdateVigente.DEEcant))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateVigente.DEEcant#"><cfelse>null</cfif>,
						DEEVanotacion = <cfif len(trim(rsUpdateVigente.DEEanotacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUpdateVigente.DEEanotacion#"><cfelse>null</cfif>
					where DEEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUpdateVigente.DEEVid#">
				</cfquery>
			</cfloop>

			<!--- Insertar los conceptos de escogencia unica que no estan en la tabla de vigencia --->
			<cfquery name="rsInsertVigente" datasource="#Session.DSN#">
				insert into DExpedienteEmpleadoV(DEid, TEid, ECEid, DCEid, DEEVcant, DEEVanotacion)
				select a.DEid, a.TEid, a.ECEid, a.DCEid, a.DEEcant, a.DEEanotacion
				from DExpedienteEmpleado a
				
				inner join EConceptosExpediente b
				  on a.ECEid = b.ECEid
				  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				  and b.ECEmultiple = 0
				
				where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
				and not exists (
					select 1
					from DExpedienteEmpleadoV c
					where a.DEid = c.DEid
					and a.TEid = c.TEid
					and a.ECEid = c.ECEid
				)
			</cfquery>
			
			<!--- Borrar todos los conceptos de escogencia multiple según el tipo de expediente del empleado en la tabla de vigencia --->
			<cfquery name="rsDelVigente" datasource="#Session.DSN#">
				delete DExpedienteEmpleadoV
				where exists (
					select 1
					from IncidenciasExpediente a, ConceptosTipoE b, EConceptosExpediente c
					where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
					and a.TEid = b.TEid
					and b.ECEid = c.ECEid
					and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and c.ECEmultiple = 1
					and DExpedienteEmpleadoV.DEid = a.DEid
					and DExpedienteEmpleadoV.TEid = a.TEid
					and DExpedienteEmpleadoV.ECEid = c.ECEid
				)
			</cfquery>
			
			<!--- Insertar los conceptos de escogencia multiple que no estan en la tabla de vigencia --->
			<cfquery name="rsInsertVigente" datasource="#Session.DSN#">
				insert into DExpedienteEmpleadoV(DEid, TEid, ECEid, DCEid, DEEVcant, DEEVanotacion )
				select a.DEid, a.TEid, a.ECEid, a.DCEid, a.DEEcant, a.DEEanotacion
				from DExpedienteEmpleado a
				
				inner join EConceptosExpediente b
				  on a.ECEid = b.ECEid
				  and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				  and b.ECEmultiple = 1
				
				where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
				and not exists (
					select 1
					from DExpedienteEmpleadoV c
					where a.DEid = c.DEid
					and a.TEid = c.TEid
					and a.ECEid = c.ECEid
					and a.DCEid = c.DCEid
				)
			</cfquery>
	
			<cfquery name="rsGeneraAccion" datasource="#session.dsn#">
				select IEdesde 
				from IncidenciasExpediente
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
			</cfquery>

			<cfif len(trim(rsGeneraAccion.IEdesde))> <!--- ACCIONES --->
				<!--- Insertar la Accion --->
				<cfset vRHAlinea = '' >
				<cfquery name="updAcciones" datasource="#Session.DSN#">
					insert into RHAcciones (DEid, RHTid, Ecodigo, Tcodigo, RVid, RHJid, Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion, RHAporc, RHAporcsal, IEid, TEid)
					select b.DEid, a.RHTid, b.Ecodigo, b.Tcodigo, b.RVid, b.RHJid, b.Dcodigo, b.Ocodigo, b.RHPid, b.RHPcodigo, a.IEdesde, a.IEhasta, b.LTsalario, a.IEobservaciones, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, '00', b.LTporcplaza, b.LTporcsal, a.IEid, a.TEid
					from IncidenciasExpediente a
					
					inner join LineaTiempo b
					  on a.DEid = b.DEid
					  and a.Ecodigo = b.Ecodigo
					  and a.IEdesde between b.LTdesde and b.LThasta
					
					where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="updAcciones">
				<cfset vRHAlinea = updAcciones.identity >
				
				<cfquery datasource="#Session.DSN#">
					insert into RHDAcciones (RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion, DRCid)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHAlinea#">, c.CSid, c.DLTtabla, c.DLTunidades, c.DLTmonto
                    , c.DLTmonto, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, '00', c.DRCid
					from IncidenciasExpediente a
					
					inner join LineaTiempo b
					  on a.DEid = b.DEid
					  and a.Ecodigo = b.Ecodigo
					  and a.IEdesde between b.LTdesde and b.LThasta
	
					inner join DLineaTiempo c
					  on b.LTid = c.LTid				
	
					where a.IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
				</cfquery>	
				
				<cfquery name="rsConceptos" datasource="#Session.DSN#">
					select a.DLfvigencia, 
						   a.DLffin, 
						   <cf_dbfunction name="to_char" args="a.DEid" > as DEid,
						   <cf_dbfunction name="to_char" args="a.Ecodigo" > as Ecodigo, 
						   <cf_dbfunction name="to_char" args="a.RHTid" > as RHTid, 
						   <cf_dbfunction name="to_char" args="a.RHAlinea" > as RHAlinea, 
						   <cf_dbfunction name="to_char" args="coalesce(a.RHJid, 0)" > as RHJid, 
						   <cf_dbfunction name="to_char" args="c.CIid" > as CIid, 
						   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo 
					from RHAcciones a
					
					inner join ConceptosTipoAccion b
					on a.RHTid = b.RHTid
	
					inner join CIncidentesD c
					on b.CIid = c.CIid
					
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHAlinea#">
				</cfquery>
		
				<cfloop query="rsConceptos">
	
					<cfset vFVigencia = LSDateFormat(rsConceptos.DLfvigencia,'dd/mm/yyyy')>
					<cfset vFechaFin  = LSDateFormat(rsConceptos.DLffin,'dd/mm/yyyy')>
						
					<cfset current_formulas = rsConceptos.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(vFVigencia,3,'/'), ListGetAt(vFVigencia,2,'/'), ListGetAt(vFVigencia,1,'/')),
												   CreateDate(ListGetAt(vFechaFin,3,'/'), ListGetAt(vFechaFin,2,'/'), ListGetAt(vFechaFin,1,'/')),
												   rsConceptos.CIcantidad,
												   rsConceptos.CIrango,
												   rsConceptos.CItipo,
												   rsConceptos.DEid,
												   rsConceptos.RHJid,
												   rsConceptos.Ecodigo,
												   rsConceptos.RHTid,
												   rsConceptos.RHAlinea
												   )>
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
					<cfset calc_error = RH_Calculadora.getCalc_error()>
					<cfif Not IsDefined("values")>
						<cfif isdefined("presets_text")>
							<cf_errorCode	code="51852" msg="@errorDat_1@"
											errorDat_1="#calc_error & '----' & current_formulas & '-----' & presets_text#"
							>
						<cfelse>
							<cfthrow detail="#calc_error#" >
						</cfif>
					</cfif>
					
					<cfquery name="updConceptos" datasource="#Session.DSN#">
						insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHAlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
						)
					</cfquery> 
					<cfinvoke component="rh.Componentes.RHFormulacionAccion" method="SetData">
						<cfinvokeargument name="RHAlinea" value="#vRHAlinea#">
						<cfinvokeargument name="CIid" 	  value="#rsConceptos.CIid#">
					</cfinvoke>
				</cfloop>

			</cfif>	 <!--- ACCIONES --->
			
			<!--- Actualizar el estado del expediente a aplicado --->
			<cfquery datasource="#Session.DSN#">
				update IncidenciasExpediente
				set IEestado = 1
				where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#expedientes[expId]#">
			</cfquery>
			
		</cfloop>
	</cftransaction>

</cfif>

<cfif isdefined("Form.Eliminar")>
	<cfquery datasource="#Session.DSN#">
		delete DExpedienteEmpleado
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
	</cfquery>
		
	<cfquery datasource="#Session.DSN#">
		delete IncidenciasValores
		where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		delete IncidenciasExpArchivos
		where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
	</cfquery>
			
	<cfquery datasource="#Session.DSN#">
		delete IncidenciasExpediente
		where IEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IEid#">
	</cfquery>

</cfif>

<cfoutput>

<cfif isdefined("Form.Guardar")>
	<cfset action = "Expediente.cfm" >
</cfif>

<form action="#action#" method="post" name="sql">
	<cfif not isdefined("Form.Eliminar") and not isdefined("Form.btnAplicar") and not isdefined("Form.AplicarInside")>
		<cfif isdefined("Form.o")>
		<input name="o" type="hidden" value="#Form.o#">
		</cfif>
		<cfif isdefined("Form.TEid")>
		<input name="TEid" type="hidden" value="#Form.TEid#">
		</cfif>
		<cfif isdefined("Form.EFEid")>
		<input name="EFEid" type="hidden" value="#Form.EFEid#">
		</cfif>
		<cfif isdefined("Form.DEid")>
		<input name="DEid" type="hidden" value="#Form.DEid#">
		</cfif>
		<cfif isdefined("Form.IEid")>
		<input name="IEid" type="hidden" value="#Form.IEid#">
		</cfif>
		<cfif isdefined("Form.Fecha")>
		<input name="IEfecha" type="hidden" value="#Form.Fecha#">
		<cfelseif isdefined("form.IEFecha")>
		<input name="IEfecha" type="hidden" value="#Form.IEFecha#">
		</cfif>
	</cfif>
	
<!----
	<cfif isdefined("Form.Guardar")>
		<cfif isdefined("Form.DEid")>
		<input name="DEid" type="hidden" value="#Form.DEid#">
		</cfif>
		<cfif isdefined("Form.IEid")>
		<input name="IEid" type="hidden" value="#Form.IEid#">
		</cfif>
		<cfif isdefined("Form.EFEid")>
		<input name="EFEid" type="hidden" value="#Form.EFEid#">
		</cfif>
		<cfif isdefined("Form.Fecha")>
		<input name="IEfecha" type="hidden" value="#Form.Fecha#">
		</cfif>
	</cfif>
	--->
	
	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript" type="text/javascript">document.forms[0].submit();</script></body>
</HTML>


