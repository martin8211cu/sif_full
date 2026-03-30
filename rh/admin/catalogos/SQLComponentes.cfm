<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MG_El_codigo_de_componente_salarial_ya_existe" default="El c&oacute;digo de Componente Salarial ya existe." returnvariable="MG_El_codigo_de_componente_salarial_ya_existe" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIALBES DE TRADUCCION --->
<!--- Parámetros Requeridos --->
<cfparam name="Form.RHCAid" type="numeric">
<cfparam name="Form.PAGENUMPADRE" type="numeric" default="1">
<cfif isdefined("Form.Alta")>
	<cfparam name="Form.CScodigo" type="string">
	<cfparam name="Form.CSdescripcion" type="string" default="">
<cfelseif isdefined("Form.Cambio")>
	<cfparam name="Form.CScodigo" type="string">
	<cfparam name="Form.CSdescripcion" type="string" default="">
	<cfparam name="Form.CSid" type="numeric">
	<cfparam name="Form.PAGENUM" type="numeric" default="1">
	<cfparam name="Form.ts_rversion" type="string">
<cfelseif isdefined("Form.Baja")>
	<cfparam name="Form.CSid" type="numeric">
</cfif>

<!---
	*****  Reglas para CSsalariobase  *****
	1. Debe existir SIEMPRE 1 registro con este campo marcado.
	2. No se puede borrar el registro que tenga este campo marcado.
--->

<!--- Consulta ---->
<cfif not isdefined("form.btnNuevo")>
	<cftransaction>
			<cfif isdefined("form.Alta")>
				<cfquery name="pre_Alta_Plazas" datasource="#session.DSN#">
					select 1
					from ComponentesSalariales
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="Alta_Plazas" datasource="#session.DSN#">
					insert into ComponentesSalariales(Ecodigo, CScodigo, CSdescripcion, CSusatabla,BMUsucodigo,
													  CSsalariobase, CIid, CAid, CScomplemento, CSorden,
													  CSpagohora, CSpagodia, CSclave, CScodigoext,CSreplica,CSsalarioEspecie,
													  CSsalarioEspecieQuin,RHCSATid,CSexcluyeCB)
					values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Trim(ucase(form.CScodigo))#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#form.CSdescripcion#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSusatabla#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif pre_Alta_Plazas.RecordCount eq 0 or isdefined("form.CSsalariobase")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.CIid") and Len(Trim(Form.CIid)) and not isdefined("form.CSsalariobase")>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam value="#Form.RHCAid#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#">,
						<cfif isdefined("Form.CSorden") and Len(Trim(Form.CSorden))>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CSorden#">
						<cfelse>
							10
						</cfif>,
						<cfif isdefined("Form.CSpagohora")>1<cfelse>0</cfif>,
						<cfif isdefined("Form.CSpagodia") >1<cfelse>0</cfif>,
						<cfif isdefined('form.CSclave') and LEN(TRIM(form.CSclave))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.CSclave#">,
						<cfelse>
						  null,
						</cfif>
						<cfif isdefined('form.CScodigoext') and LEN(TRIM(form.CScodigoext))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.CScodigoext#">
						<cfelse>
						  null
						</cfif>,
                        <cfif isdefined('form.CSreplica')>1<cfelse>0</cfif>
						,<cfif isdefined('form.CSsalarioEspecie')>1<cfelse>0</cfif>,
						<cfif isdefined('form.salarioEspeciePrimera')>1<cfelseif isdefined('form.salarioEspecieSegunda')>2<cfelse>null</cfif>
						,<cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>
						,(#IsDefined('form.CSexcluyeCB') ? 1 : 0#)
						)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="Alta_Plazas">
				<!--- danim, 28/12/2004 --->
				<cfset form.CSid = Alta_Plazas.identity>

				<!--- Genera Concepto Incidente, y lo asocia al componente  --->
				<cfif isdefined("form.CSdesglosar")>
					<cfquery name="valida" datasource="#session.DSN#">
						select 1
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and upper(CIcodigo) = <cfqueryparam cfsqltype="cf_sql_char"  value="#Trim(ucase(form.CScodigo))#">
					</cfquery>
					<cfif valida.recordcount gt 0 >
						<cf_throw message="#MG_El_codigo_de_componente_salarial_ya_existe#" errorcode="2085">
					</cfif>

					<cfquery name="altaConcepto" datasource="#session.DSN#">
						insert into CIncidentes( Ecodigo, CIcodigo, CIdescripcion, CIfactor, CItipo, CIcantmin, CIcantmax, Usucodigo, CIcuentac, CSid, BMUsucodigo,RHCSATid )
						values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(ucase(form.CScodigo))#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CSdescripcion)#">,
								 1,
								 <cfif form.CSusatabla EQ 2 or form.CSusatabla EQ 4>3<cfelse>2</cfif>,
								 1,
								 1,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                                ,<cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="altaConcepto">

					<cfquery datasource="#session.DSN#">
						update ComponentesSalariales
						set CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#altaConcepto.identity#">
						where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
					</cfquery>
				</cfif>

			<cfelseif isdefined("form.Cambio")>
				<cf_dbtimestamp
 					 datasource="#session.dsn#"
					 table="ComponentesSalariales"
					 redirect="formComponentes.cfm"
					 timestamp="#form.ts_rversion#"
					 field1= "CSid" type1="numeric" value1="#form.CSid#"
					 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#"
					 field3="CAid" type3="numeric" value3="#Form.RHCAid#">

				<cfquery datasource="#session.DSN#">
					update ComponentesSalariales
					set CScodigo = <cfqueryparam value="#Trim(form.CScodigo)#" cfsqltype="cf_sql_char">,
						CSdescripcion = <cfqueryparam value="#form.CSdescripcion#"    cfsqltype="cf_sql_varchar">,
						CScomplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#">,
						CSusatabla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSusatabla#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						<cfif isdefined("form.CSsalariobase")>, CSsalariobase = 1 </cfif>
						<cfif isdefined("Form.CSorden") and Len(Trim(Form.CSorden))>
							,CSorden=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CSorden#">
						<cfelse>
							,CSorden=10
						</cfif>
						, CSpagohora = <cfif isdefined("Form.CSpagohora")>1<cfelse>0</cfif>
						, CSpagodia = <cfif isdefined("Form.CSpagodia")>1<cfelse>0</cfif>
						, CSclave =
						<cfif isdefined('form.CSclave') and LEN(TRIM(form.CSclave))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.CSclave#">
						<cfelse>
						  null
						</cfif>
						, CScodigoext =
						<cfif isdefined('form.CScodigoext') and LEN(TRIM(form.CScodigoext))>
						  <cfqueryparam cfsqltype="cf_sql_char" value="#form.CScodigoext#">
						<cfelse>
						  null
						</cfif>
						,CSreplica= <cfif isdefined('form.CSreplica')>1<cfelse>0</cfif>
						,CSsalarioEspecie= <cfif isdefined('form.CSsalarioEspecie')>1<cfelse>0</cfif>,
						CSsalarioEspecieQuin=<cfif isdefined('form.salarioEspeciePrimera')>1<cfelseif isdefined('form.salarioEspecieSegunda')>2<cfelse>null</cfif>
						,RHCSATid  = <cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>
						,CSexcluyeCB = (#IsDefined('form.CSexcluyeCB') ? 1 : 0#)
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
						and CAid = <cfqueryparam value="#Form.RHCAid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="ligados" datasource="#session.DSN#">
					select CSid
					from CIncidentes
					where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
					and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
				</cfquery>

				<!--- Actualiza el complemento del Concepto asociado al Componente (o los conceptos, se supone qu ees 1:1) --->
				<cfif ligados.recordcount gt 0>
					<cfquery datasource="#session.DSN#">
						update CIncidentes
						set CIcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CScomplemento#">,
							CIcodigo=<cfqueryparam value="#Trim(form.CScodigo)#" cfsqltype="cf_sql_varchar">,
							CIdescripcion= <cfqueryparam value="#form.CSdescripcion#"    cfsqltype="cf_sql_varchar">,
							<cfif form.CSusatabla EQ 2>CItipo = 3,</cfif>
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                           ,RHCSATid  = <cfif isdefined("form.ConceptoSAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#"><cfelse>0</cfif>
						where CSid = <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
						and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

			<cfelseif isdefined("form.Baja")>

				<!--- borra Reglas que tenga asociadas --->
				<cfquery name="rsDetalleR" datasource="#session.DSN#">
					select ERCid
					from EReglaComponente
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset Lvar_Reglas = ValueList(rsDetalleR.ERCid)>
				<cfif LEN(TRIM(Lvar_Reglas)) GT 0>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"> actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="DReglaComponente">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="ERCid in(#Lvar_Reglas#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
					<cfquery datasource="#session.DSN#">
						delete from DReglaComponente
						where ERCid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#Lvar_Reglas#">)
					</cfquery>
				</cfif>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="EReglaComponente">
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="Ecodigo= #session.Ecodigo# and CSid = #form.CSid#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>
				<cfquery datasource="#session.DSN#">
					delete from EReglaComponente
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="CIncidentes">
					<cfinvokeargument name="condicion" value="Ecodigo= #session.Ecodigo# and CSid = #form.CSid# and upper(CIcodigo) =#Trim(ucase(form.CScodigo))#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>
				<!--- Borra Conceptos Incidentes asociados--->
				<cfquery datasource="#session.DSN#">
					delete from CIncidentes
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
					  and upper(CIcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(ucase(form.CScodigo))#">
				</cfquery>--->

				<cfquery name="pre_Baja_Plazas" datasource="#session.DSN#">
					select 1
					from ComponentesSalariales
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
					  and CSsalariobase = 1
				</cfquery>

				<cfif pre_Baja_Plazas.RecordCount eq 0>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
					<cfinvokeargument  name="nombreTabla" value="RHMetodosCalculo">
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="CSid = #form.CSid#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>
					<cfquery name="Baja_PlazasDelete1" datasource="#session.DSN#">
						delete from RHMetodosCalculo
						where CSid = <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="ComponentesSalariales">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo= #session.Ecodigo# and CSid =  #form.CSid# and CAid = #Form.RHCAid#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
					</cfinvoke>
					<cfquery name="Baja_PlazasDelete2" datasource="#session.DSN#">
						delete from ComponentesSalariales
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CSid =  <cfqueryparam value="#form.CSid#" cfsqltype="cf_sql_numeric">
							and CAid = <cfqueryparam value="#Form.RHCAid#" cfsqltype="cf_sql_numeric">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("form.CSsalariobase") and (isdefined("form.Alta") or isdefined("form.Cambio"))>
				<cfquery name="Update_Plazas" datasource="#session.DSN#">
					update ComponentesSalariales
					set CSsalariobase = 0,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					<!--- danim, 28/12/2004: cambio Alta_Plazas.CSid por form.CSid --->
					and CSid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
				</cfquery>
			</cfif>
	</cftransaction>
</cfif>

<!--- Parámetros para volver a la pantalla principal --->
<cfif isdefined("Form.Cambio")>
	<cflocation url="Componentes.cfm?RHCAid=#Form.RHCAid#&PAGENUMPADRE=#Form.PAGENUMPADRE#&CSid=#Form.CSid#&PAGENUM=#Form.PAGENUM#">
<cfelse>
	<cflocation url="Componentes.cfm?RHCAid=#Form.RHCAid#&PAGENUMPADRE=#Form.PAGENUMPADRE#&PAGENUM=#Form.PAGENUM#">
</cfif>