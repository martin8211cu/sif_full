<!---<cf_dump var="#form#">--->


<cfoutput>
	<table cellpadding="0" cellspacing="0" border="0" >
			<tr><td  colspan="3" align="left"><strong>Cat&aacute;logos</strong></td></tr>
			<tr><td class="label"><input name="Marcartodos" type="checkbox" onClick="javascript:Marcar(this);"><strong>Marcar Todos</strong></td></tr>
			
			<tr><td>&nbsp;</td><td style="font:Arial, Helvetica, sans-serif; font-size:9px">Origen</td><td style="font:Arial, Helvetica, sans-serif; font-size:9px">Destino</td></tr>

				<tr><td class="label"><input name="Clonar" type="checkbox" value="Oficinas"/>Oficinas</td>
				<cfset Org = reg('Oficinas',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('Oficinas',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>


				<tr><td class="label"><input name="Clonar" type="checkbox" value="Departamentos"/>Departamentos</td>
				<cfset Org = reg('Departamentos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('Departamentos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CtasMayor"/>SIF - Catalogo de Cuentas de Mayor</td>
				<cfset Org = reg('CtasMayor',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CtasMayor',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CPVigencia"/>SIF - Catalogo de Cuentas Vigencia</td>
				<cfset Org = reg('CPVigencia',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CPVigencia',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				<tr><tr><td class="label"><input name="Clonar" type="checkbox" value="CContables"/>SIF - Catalogo Contable</td>
				<cfset Org = reg('CContables',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CContables',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CFinanciera"/>SIF - Catalogo CFinanciera</td>
				<cfset Org = reg('CFinanciera',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CFinanciera',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="ConceptoContableE"/>SIF - Conceptos Contables Encabezado</td>
				<cfset Org = reg('ConceptoContableE',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('ConceptoContableE',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="ConceptoContable"/>SIF - Conceptos Contables Detalles</td>
				<cfset Org = reg('ConceptoContable',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('ConceptoContable',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="EstadoSNegocios"/>SIF - Estado Socio de Negocios</td>
				<cfset Org = reg('EstadoSNegocios',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('EstadoSNegocios',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="SNegocios"/>SIF - Socio de Negocios</td>
				<cfset Org = reg('SNegocios',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('SNegocios',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RegimenVacaciones,DRegimenVacaciones"/>Regimen Vacaciones (Encabezado)</td>
				<cfset Org = reg('RegimenVacaciones',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RegimenVacaciones',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHComponentesAgrupados,ComponentesSalariales"/>Componentes Salariales</td>
				<cfset Org = reg('ComponentesSalariales',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('ComponentesSalariales',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
						
				<tr><td class="label"><input name="Clonar" type="checkbox" value="TDeduccion,FDeduccion"/>Tipos de Deduccion</td>
				<cfset Org = reg('TDeduccion',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('TDeduccion',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHEtiquetasEmpresa"/>Etiquetas por Empresa</td>
				<cfset Org = reg('RHEtiquetasEmpresa',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>	
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHEtiquetasEmpresa',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CIncidentes,CIncidentesD"/>Conceptos de pago ó Incidencias</td>
				<cfset Org = reg('CIncidentes',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>			
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CIncidentes',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHFeriados"/>Dias Feriados</td>
				<cfset Org = reg('RHFeriados',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHFeriados',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHTipoAccion,ConceptosTipoAccion"/>Tipos de Acciones de Personal</td>
				<cfset Org = reg('RHTipoAccion',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHTipoAccion',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="ECargas,DCargas"/>Cargas Patronales</td>
				<cfset Org = reg('ECargas',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('ECargas',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<!--- DETALLE DE LAS CARGAS PATRONALES
				<tr><td class="label"><input name="Clonar" type="checkbox" value="DCargas"/>Detalle Cargas Patronales</td>
				<cfset Org = reg('DCargas',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('DCargas',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				--->		
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="TiposNomina"/>Tipos de Nomina</td>
				<cfset Org = reg('TiposNomina',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('TiposNomina',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CalendarioPagos,TDCalendario,CCalendario,RHExcluirDeduccion"/>Calendario Pagos</td>
				<cfset Org = reg('CalendarioPagos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CalendarioPagos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="DiasTiposNomina"/>Dias de No Pago</td>
				<cfset Org = reg('DiasTiposNomina',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('DiasTiposNomina',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHJornadas,RHDJornadas,RHComportamientoJornada"/>Jornadas</td>
				<cfset Org = reg('RHJornadas',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHJornadas',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<!--- DETALLE DE JORNADAS
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHDJornadas,RHComportamientoJornada"/>Detalle de Jornadas</td>
				<cfset Org = reg('RHDJornadas',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHDJornadas',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				--->
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHPuestosExternos"/>Puestos Externos</td>
				<cfset Org = reg('RHPuestosExternos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHPuestosExternos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHTPuestos"/>Tipos de Puesto</td>
				<cfset Org = reg('RHTPuestos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHTPuestos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHMaestroPuestoP"/>Puestos Presupuestarios</td>
				<cfset Org = reg('RHMaestroPuestoP',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHMaestroPuestoP',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CFuncional"/>Centros Funcionales</td>
				<cfset Org = reg('CFuncional',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CFuncional',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="RHPuestos"/>Puestos</td>
				<cfset Org = reg('RHPuestos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('RHPuestos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				<tr><td class="label"><input name="Clonar" type="checkbox" value="Bancos"/>Bancos</td>
				<cfset Org = reg('Bancos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('Bancos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>
				</cfif>
				
				<tr><td class="label"><input name="Clonar" type="checkbox" value="CuentasBancos"/>Cuentas Bancarias</td>
				<cfset Org = reg('CuentasBancos',#form.DSNO#,#form.EcodigoO#)>
				<td>&nbsp;<label style="cursor:pointer">(#Org.total#)</label></td>
				<cfif isdefined("form.EcodigoD") and form.EcodigoD GT 0>
					<cfset Des = reg('CuentasBancos',#form.DSND#,#form.EcodigoD#)>
					<td>&nbsp;<label style="cursor:pointer">(#Des.total#)</label> </tr>				
				</cfif>
		</table>
		</td>
		<td valign="top">
			<!---Historial--->
			<table cellpadding="0" cellspacing="0" border="0" width="500">
			<tr><td><strong>Hist&oacute;ricos (Seleccione)</strong></td></tr>
			<tr>
			<td width="90%"><input name="Clonar" value="DatosEmpleado,RHImagenEmpleado,RHAnotaciones,FEmpleado,EVacacionesEmpleado,DVacacionesEmpleado"
				type="checkbox"  onclick="javascript: showConlis(document.getElementById('tr_Emp'),this.checked)" />Empleados e Historia Laboral</td></tr>	
			<tr id="tr_Emp" style="display:none">
			<td>
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<tr><td>
						<table cellpadding="0" cellspacing="0" border="0">
							<tr><td>&nbsp;&nbsp;&nbsp;</td>
							<td>
								<input name="rTodos" <cfif not isdefined("form.rTodos") or form.rTodos EQ 1> checked="checked" </cfif>  type="radio" value="1" onclick="javascript: showConlis(document.getElementById('TRListEmp'),false)" />Todos &nbsp;&nbsp;&nbsp;
							</td></tr><tr><td>&nbsp;</td>
							<td>
								<input name="rTodos" type="radio" value="0" <cfif isdefined("form.rTodos") and form.rTodos EQ 0>checked="checked" </cfif> onclick="javascript: showConlis(document.getElementById('TRListEmp'),true)"/>Seleccionar
							</td></tr>
						</table>
					</td></tr>
					<tr id="TRListEmp" <cfif not isdefined("form.rTodos") or form.rTodos EQ 1>style="display:none" </cfif>><td>
						<!---<cfinclude template="clonacion-empleados.cfm">--->
					
					<table id="tblempleado" width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
					<tr>
						<td></td>
						<td><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:</strong>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<cf_rhempleado size="30" Ecodigo ="#form.EcodigoO#" DSN ="#form.DSNO#">				
						</td>
						<td align="right"><!----align="right"---->
							<input type="hidden" name="LastOneEmpleado" id="LastOneEmpleado" value="ListaNon" >
							&nbsp;<input type="button" name="agregarEmpleado" onClick="javascript:if (window.fnNuevoEmpleado) fnNuevoEmpleado();" value="+" >
						</td>
					</tr>
					<tbody>
					</tbody>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
					</td></tr>
				</table>
				
				</td>
			</tr>
			
			<td><input name="Clonar" value="CargasEmpleado" <cfif isdefined("form.Cargos")>checked="checked"</cfif> type="checkbox"  onclick="javascript: showConlis(document.getElementById('tr_Carg'),this.checked)"/>Cargas de los Empleado</td></tr>
			<tr id="tr_Carg" style="display:none">
			<td>
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<tr id="TRListCar" <!---<cfif not isdefined("form.rTodos") or form.rTodos EQ 1>style="display:none" </cfif>--->><td>
						<table id="tblCargas" width="100%"  border="0" cellspacing="0" cellpadding="2" style="border:1px solid gray;">
						<tr>
							<td></td>
							<td><strong><cf_translate key="LB_Cargas" XmlFile="/rh/generales.xml">Cargas</cf_translate>:</strong>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<cfinclude template="clonacion-cargas.cfm">			
							</td>
							<td align="right"><!----align="right"---->
								<input type="hidden" name="LastOneCarga" id="LastOneCarga" value="ListaCarg" >
								&nbsp;<input type="button" name="agregarCargas" onClick="javascript:if (window.fnNuevoCarga) fnNuevoCarga();" value="+" >
							</td>
						</tr>
						<tbody>
						</tbody>
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</td></tr>
				</table>
			</td>
			</tr>
			<!---<tr>
				<td><input name="Clonar" value="DeduccionesEmpleado" <cfif isdefined("form.histDeduc")>checked="checked"</cfif> type="checkbox"  <!---onclick="javascript: showConlis(document.getElementById('tr_Hdeducciones'),this.checked)"--->/>Deducciones de los Empleados</td>
			<!---</tr>	--->
			<tr id="tr_Hdeducciones" <cfif not isdefined("form.histDeduc")>style="display:none"</cfif>><td>&nbsp;</td>
				<td>
				<cfinclude template="clonacion-deducciones.cfm">
				</td>--->
			</tr>
			
			<!---<tr><td>&nbsp;&nbsp;</td><td><input name="histNomina" <cfif isdefined("form.histNomina")>checked="checked"</cfif> type="checkbox" <!--- onclick="javascript: showConlis(document.getElementById('tr_Hnomina'),this.checked)"--->/>Tipos de Nomina </td>
			</tr>	
			<tr id="tr_Hnomina" <cfif not isdefined("form.histNomina")>style="display:none"</cfif>><td>&nbsp;</td>
				<td>
				<cfinclude template="clonacion-tiposnomina.cfm">
				</td>
			</tr>--->
			<tr>
				<td><input name="Clonar" value="RHPlazas,RHTipoMovimiento,RHPlazaPresupuestaria,RHMovPlaza" type="checkbox" />Plaza de Empleados</td>
			</tr>	
			</table>
		</td>
	</tr>
</cfoutput>
