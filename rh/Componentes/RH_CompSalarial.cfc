<cfcomponent>
	<cffunction name="pComponentes" access="public" returntype="numeric" output="true">
		<cfargument name="query" type="query" required="yes">
		<cfargument name="totalComponentes" type="numeric" required="yes">
		<cfargument name="MostrarSalarioNominal"  type="string"  required="no" default="0">
		<cfargument name="Tiponomina" 			  type="string"  required="no"  default="0">
		<cfargument name="id" type="string" required="no" default="0">
		<cfargument name="sql" type="numeric" required="no" default="0">
		<cfargument name="Ecodigo" type="numeric" default="#Session.Ecodigo#" required="no">
		<cfargument name="readonly" type="boolean" default="false" required="no">
		<cfargument name="permiteAgregar" type="boolean" default="true" required="no">
		<cfargument name="queryActual" type="query" required="no">
		<cfargument name="negociado" type="boolean" default="false" required="no">
		<cfargument name="linea" type="string" default="RHDAlinea" required="no">
		<cfargument name="unidades" type="string" default="RHDAunidad" required="no">
		<cfargument name="montobase" type="string" default="RHDAmontobase" required="no">
		<cfargument name="montores" type="string" default="RHDAmontores" required="no">
		<cfargument name="funcionEliminar" type="string" default="" required="no">
		<cfargument name="incluyeHiddens" type="boolean" default="true" required="no">
		<cfargument name="mostrarTotales" type="boolean" default="true" required="no">
		<cfargument name="formName" type="string" default="form1" required="no">

		<!-----================ TRADUCCION ===================---->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="MSG_El_argumento_id_o_argumento_sql_estan_indefinidos"
			default="El argumento id o argumento sql estan indefinidos"
			returnvariable="MSG_IdSqlIndefinido"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Agregar_Nuevo_Componente_Salarial"
			default="Agregar Nuevo Componente Salarial"
			returnvariable="LB_Agregar_Nuevo_Componente_Salarial"/>

		<cfif Arguments.permiteAgregar or not Arguments.readonly>
			<cfif Arguments.id EQ 0 or Arguments.sql EQ 0>
				<cfthrow message="#MSG_IdSqlIndefinido#">
			</cfif>
		</cfif>

		<!--- Averiguar el código de componente de salario base --->
		<cfif Arguments.MostrarSalarioNominal eq 1>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Semanal"
			default="Semanal"
			returnvariable="LB_Semanal"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Bisemanal"
			default="Bisemanal"
			returnvariable="LB_Bisemanal"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Quincenal"
			default="Quincenal"
			returnvariable="LB_Quincenal"/>

			<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
				select
					Ttipopago,
					case Ttipopago when 0 then '#LB_Semanal#'
					when 1 then '#LB_Bisemanal#'
					when 2 then '#LB_Quincenal#'
					end as   descripcion
				from TiposNomina
				where
				Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tiponomina#">
			</cfquery>


		</cfif>



		<cfquery name="rsSalarioBase" datasource="#Session.DSN#">
			select CSid as CampoSalarioBase, CSusatabla as usatabla
			from ComponentesSalariales
			where CSsalariobase = 1
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset usaEstructuraSalarial = rsSalarioBase.usatabla>

		<cfif Arguments.permiteAgregar and not Arguments.readonly>
		<script language="javascript" type="text/javascript">
			// Invoca ventana para agregar componentes salariales
			function doAgregarComponente(acc) {
				var width = 550;
				var height = 450;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				<cfoutput>
				var nuevo = window.open('/cfmx/rh/Utiles/ConlisCompSalarial.cfm?empresa=#Arguments.Ecodigo#&negociado=#Iif(Arguments.negociado, DE('1'), DE('0'))#&sql=#Arguments.sql#&id='+acc+'&formName=#Arguments.formName#','ComponentesSalariales','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
				</cfoutput>
				nuevo.focus();
			}
		</script>
		</cfif>

		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			 	<cfif arguments.mostrarTotales>
					<tr>
						<td class="tituloListas" colspan="3" nowrap><cf_translate key="LB_Salario_Total">Salario Total</cf_translate><cfif Arguments.negociado><cf_translate key="LB_Negociado"> (Negociado)</cf_translate></cfif>:</td>
						<td class="tituloListas" colspan="2" align="right" nowrap>#LSNumberFormat(Arguments.totalComponentes,',9.00')#</td>
					</tr>
					<cfif Len(Trim(Arguments.Tiponomina))>
					  <cfif Arguments.MostrarSalarioNominal eq 1>
							<cfif rsTiposNomina.Ttipopago neq 3>
							   <cfinvoke component="rh.Componentes.RH_Funciones"
								method="salarioTipoNomina"
								salario = "#Arguments.totalComponentes#"
								tcodigo = "#Arguments.Tiponomina#"
								ecodigo ="#Arguments.Ecodigo#"
								returnvariable="var_salarioTipoNomina">


							   <tr>
								<td class="tituloListas" colspan="3" nowrap><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
								<td class="tituloListas" colspan="2" align="right" nowrap>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
							  </tr>
							 <cfelse>
								<tr>
									<td colspan="5" nowrap>&nbsp;</td>
								</tr>
							 </cfif>
					  </cfif>
					</cfif>
			  	</cfif>

		  	<cfif Arguments.query.recordCount GT 0>
			  <tr>
				<td colspan="5" align="right" valign="middle" height="25">
					<cfif Arguments.incluyeHiddens>
						<input type="hidden" name="cantComp" value="#Arguments.query.recordCount#">
					</cfif>
					<cfif Arguments.permiteAgregar and not Arguments.readonly>
						<table border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="right"><img border="0" src="/cfmx/rh/imagenes/money.gif" alt="#LB_Agregar_Nuevo_Componente_Salarial#"></td>
							<td class="fileLabel">#LB_Agregar_Nuevo_Componente_Salarial#</td>
							<td><input name="btnAddCmp" type="button" id="btnAddCmp" value="+" onclick="javascript: doAgregarComponente('#Arguments.id#');" alt="#LB_Agregar_Nuevo_Componente_Salarial#"></td>
						  </tr>
						</table>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td class="tituloListas" nowrap><cf_translate key="LB_Componente">Componente</cf_translate></td>
				<td class="tituloListas" align="right" nowrap>
					<cf_translate key="LB_Unidades">Unidades</cf_translate>
				</td>
				<td class="tituloListas" align="right" nowrap>
					<cf_translate key="LB_Monto_Base">Monto Base</cf_translate>
				</td>
				<td <cfif Len(Trim(Arguments.funcionEliminar)) EQ 0 or Arguments.readonly>colspan="2"</cfif> class="tituloListas" align="right" nowrap>
					<cf_translate key="LB_Monto">Monto</cf_translate>
				</td>
				<cfif Len(Trim(Arguments.funcionEliminar)) and not Arguments.readonly>
				<td class="tituloListas" align="right" nowrap>&nbsp;</td>
				</cfif>
			  </tr>

			<cfloop query="Arguments.query">
				<cfif IsDefined('Arguments.query.CIid') And Arguments.query.CIid NEQ -1 and IsDefined('Arguments.query.CSexcluyeCB') and Arguments.query.CSexcluyeCB eq 0>
					  <cfset color = ' style="color: ##FF0000;"'>
				<cfelse>
					<cfset color = ''>
				</cfif>
				  <tr>
					<td class="fileLabel" height="25"#color# nowrap>
						#Arguments.query.CSdescripcion#
						<cfif Arguments.incluyeHiddens>
							<input type="hidden" name="#Arguments.linea#_#Arguments.query.currentRow#" value="#Evaluate('Arguments.query.#Arguments.linea#')#">
							<cfset ts = "">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#Arguments.query.ts_rversion#" returnvariable="ts">
							</cfinvoke>
							<input type="hidden" name="tsCmp_#Arguments.query.currentRow#" value="#ts#">
						</cfif>
					</td>
					<td height="25" align="right"#color# nowrap>
						<!--- (Usa Tabla y Multiplicador) --->
						<cfif usaEstructuraSalarial
							  and not Arguments.negociado and not Arguments.readonly
							  and (Arguments.query.CSusatabla EQ 1 or Arguments.query.CSusatabla EQ 2) and Arguments.query.RHMCcomportamiento EQ 3
							  >
							<input name="#Arguments.unidades#_#Arguments.query.currentRow#" type="text" size="12" maxlength="10" style="text-align: right;" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,6);"  onkeyup="if(snumber(this,event,6)){ if(Key(event)=='13') {this.blur();}}" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.unidades#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.unidades#'),',9.000000')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTunidades))>#LSNumberFormat(Arguments.queryActual.DLTunidades,',9.000000')#<cfelse>1.000000</cfif>">
						<!--- (Metodo de Calculo y Porcentaje) --->
						<cfelseif usaEstructuraSalarial
							  and not Arguments.negociado
							  and isdefined('Arguments.query.RHMCcomportamiento')
							  and Arguments.query.CSusatabla EQ 2 and Arguments.query.RHMCcomportamiento EQ 2
							  >
							<cfif Arguments.incluyeHiddens>
								<input name="#Arguments.unidades#_#Arguments.query.currentRow#" type="hidden" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.unidades#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.unidades#'),'9.000000')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTunidades))>#LSNumberFormat(Arguments.queryActual.DLTunidades,'9.000000')#<cfelse>100.000000</cfif>">
							</cfif>
							<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.unidades#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.unidades#'),'9.0000')#%<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTunidades))>#LSNumberFormat(Arguments.queryActual.DLTunidades,'9.000000')#%<cfelse>100.000000%</cfif>
						<!--- Monto Fijo o (Metodo de Calculo y Multiplicador) --->
						<cfelse>
							<cfif Arguments.incluyeHiddens>
								<input name="#Arguments.unidades#_#Arguments.query.currentRow#" type="hidden" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.unidades#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.unidades#'),'9.000000')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTunidades))>#LSNumberFormat(Arguments.queryActual.DLTunidades,'9.000000')#<cfelse>1.000000</cfif>">
							</cfif>
							<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.unidades#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.unidades#'),'9.0000')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTunidades))>#LSNumberFormat(Arguments.queryActual.DLTunidades,'9.000000')#<cfelse>1.000000</cfif>
						</cfif>
					</td>
					<td height="25" align="right"#color# nowrap>&nbsp;
						<cfif Arguments.incluyeHiddens>
							<input name="#Arguments.montobase#_#Arguments.query.currentRow#" type="hidden" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montobase#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montobase#'),'9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmontobase))>#LSNumberFormat(Arguments.queryActual.DLTmontobase,'9.00')#<cfelse>0.00</cfif>">
						</cfif>
						<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montobase#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montobase#'),',9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmontobase))>#LSNumberFormat(Arguments.queryActual.DLTmontobase,',9.00')#<cfelse>0.00</cfif>
					</td>
					<td <cfif Len(Trim(Arguments.funcionEliminar)) EQ 0 or Arguments.readonly>colspan="2"</cfif> height="25" align="right"#color# nowrap>
						<cfif (usaEstructuraSalarial and Arguments.query.CSusatabla EQ 1 and Arguments.negociado) or Arguments.query.CSusatabla EQ 0>
							<cfif not Arguments.readonly>
								<input name="#Arguments.montores#_#Arguments.query.currentRow#" type="text" size="18" maxlength="15"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montores#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montores#'),',9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmonto))>#LSNumberFormat(Arguments.queryActual.DLTmonto,',9.00')#<cfelse>0.00</cfif>">
							<cfelse>
								<cfif Arguments.incluyeHiddens>
									<input name="#Arguments.montores#_#Arguments.query.currentRow#" type="hidden" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montores#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montores#'),'9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmonto))>#LSNumberFormat(Arguments.queryActual.DLTmonto,'9.00')#<cfelse>0.00</cfif>">
								</cfif>
								<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montores#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montores#'),',9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmonto))>#LSNumberFormat(Arguments.queryActual.DLTmonto,',9.00')#<cfelse>0.00</cfif>
							</cfif>
						<cfelse>
							<cfif Arguments.incluyeHiddens>
								<input name="#Arguments.montores#_#Arguments.query.currentRow#" type="hidden" value="<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montores#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montores#'),'9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmonto))>#LSNumberFormat(Arguments.queryActual.DLTmonto,'9.00')#<cfelse>0.00</cfif>">
							</cfif>
							<cfif Len(Trim(Evaluate('Arguments.query.#Arguments.montores#')))>#LSNumberFormat(Evaluate('Arguments.query.#Arguments.montores#'),',9.00')#<cfelseif isdefined("Arguments.queryActual") and Len(Trim(Arguments.queryActual.DLTmonto))>#LSNumberFormat(Arguments.queryActual.DLTmonto,',9.00')#<cfelse>0.00</cfif>
						</cfif>
					</td>
					<cfif Len(Trim(Arguments.funcionEliminar)) and not Arguments.readonly>
					<td width="1%">
						<cfif rsSalarioBase.CampoSalarioBase NEQ Evaluate('Arguments.query.CSid')>
							<input name="btnEliminar" type="image" alt="Eliminar Componente Salarial" onclick="javascript: if (window.#Arguments.funcionEliminar#) return #Arguments.funcionEliminar#('#Evaluate('Arguments.query.#Arguments.linea#')#'); else return false;" src="/cfmx/rh/imagenes/Borrar01_S.gif" width="16" height="16" tabindex="-1">
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					</cfif>
				  </tr>
			  </cfloop>
		  	<cfelse>
			  <tr>
				<td colspan="5" align="right" valign="middle" height="25">
					<cfif Arguments.permiteAgregar and not Arguments.readonly>
						<table border="0" cellspacing="0" cellpadding="2">
						  <tr>
							<td align="right"><img border="0" src="/cfmx/rh/imagenes/money.gif" alt="#LB_Agregar_Nuevo_Componente_Salarial#"></td>
							<td class="fileLabel"><cf_translate key="LB_Componentes_Salariales">Componentes Salariales</cf_translate></td>
							<td><input name="btnAddCmp" type="button" id="btnAddCmp" value="+" onclick="javascript: doAgregarComponente('#Arguments.id#');" alt="#LB_Agregar_Nuevo_Componente_Salarial#"></td>
						  </tr>
						</table>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			  </tr>
		  	</cfif>

			</table>
		</cfoutput>

		<cfset error = 0>
		<cfreturn error>
	</cffunction>

</cfcomponent>
