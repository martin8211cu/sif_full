<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2723" default="0" returnvariable="LvarAprobarExperiencia"/>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_NombreDeLaEmpresa" Default="Nombre de la empresa" returnvariable="LB_NombreDeLaEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TelefonoDeLaEmpresa" Default="Tel&eacute;fono de la empresa" returnvariable="LB_TelefonoDeLaEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Profesion_u_oficio" Default="Profesi&oacute;n u oficio" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeIngreso" Default="Fecha de ingreso" returnvariable="LB_FechaDeIngreso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDeRetiro" Default="Fecha de retiro" returnvariable="LB_FechaDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MotivoDelRetiro" Default="Motivo del retiro" returnvariable="LB_MotivoDelRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FuncionesYLogrosObtenidos" Default="Funciones y logros obtenidos" returnvariable="LB_FuncionesYLogrosObtenidos"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="CHK_Actualmente" Default="Actualmente" returnvariable="CHK_Actualmente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnnosLaborados" Default="A&ntilde;os Laborados" returnvariable="LB_AnnosLaborados" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml" />
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Eliminar" Default="Eliminar" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Nuevo" Default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DeseaEliminarElRegistro" Default="Desea eliminar el registro" returnvariable="MSG_DeseaEliminarElRegistro" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="LB_MesDeInicio" Default="Mes de inicio" returnvariable="LB_MesDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnoDeInicio" Default="Año de Inicio" returnvariable="LB_AnoDeInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_MesDeRetiro" Default="Mes de retiro" returnvariable="LB_MesDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnoDeRetiro" Default="Año de retiro" returnvariable="LB_AnoDeRetiro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuestoDesempenado" Default="Puesto desempeñado" returnvariable="LB_PuestoDesempenado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" Default="Debe seleccionar el año y mes de finalización" returnvariable="MSG_DebeSeleccionarElAnoYMesDeFinalizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PendienteDeAprobar" default="Pendiente de Aprobar" returnvariable="LB_PendienteDeAprobar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Rechazada" default="Rechazada" returnvariable="LB_Rechazada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Observacion" default="Observación" returnvariable="LB_Observacion" component="sif.Componentes.Translate" method="Translate"/>	
		
<cfset modoExperiencia = "ALTA">
<cfif isdefined("form.RHEEid") and len(trim(form.RHEEid))>
	<cfset modoExperiencia = "CAMBIO">
</cfif>

<cfif modoExperiencia neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select 	RHEEid, RHEEnombreemp, RHEEtelemp, RHOPid, RHEEfechaini, RHEEfecharetiro,
				Actualmente, RHEEfunclogros, ts_rversion, RHEEmotivo,RHEEpuestodes,RHEEAnnosLab,RHEEestado,RHEEObserv,
				RHEEDV1,RHEEDV2,RHEEDV3,RHEEDV4,RHEEDV5,RHEEDV6,RHEEDV7,RHEEDV8,RHEEDV9,RHEEDV10, RHEEobservacion,RHEEestado
		from RHExperienciaEmpleado
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
				and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			</cfif> 
			and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>


</cfif>

<cfquery name="rsDatosVarAll" datasource="#Session.DSN#">
	select RHDVEcol,
		   RHDVEDatoV,
		   RHDVErequerido
	from RHDVExperiencia
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHDVEdisplay = 1
</cfquery>
<cfif isdefined('LvarAuto')>
	<cfset Lvar_Accion = 'experiencia-sql.cfm'>
<cfelseif isdefined('Lvar_EducAuto')>
	<cfset Lvar_Accion = '../capacitacion/expediente/experiencia-sql.cfm'>
<cfelse>
	<cfset Lvar_Accion = '../../capacitacion/expediente/experiencia-sql.cfm'>
</cfif>
<cfoutput>
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formExperiencia" action="#Lvar_Accion#" method="post" onSubmit="javascript: return funcValida();">
	<table width="100%" cellpadding="2" cellspacing="0">
		<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
		<input type="hidden" name="tab" value="3">
		<input type="hidden" name="RHOid" value="<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>#form.RHOid#</cfif>">
		<input name="sel" type="hidden" value="1">
		<input type="hidden" name="o" value="2">	
        <cfif isdefined('Lvar_EducAuto')><input name="Lvar_EducAuto" type="hidden" value="#Lvar_EducAuto#"></cfif>	
		<tr>
			<td align="right" nowrap><strong>#LB_NombreDeLaEmpresa#:&nbsp;</strong></td>
			<td><input type="text" name="RHEEnombreemp" size="60" maxlength="80" value="<cfif modoExperiencia neq 'ALTA'>#trim(data.RHEEnombreemp)#</cfif>" onFocus="this.select();" ></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_TelefonoDeLaEmpresa#:&nbsp;</strong></td>
			<td><input type="text" name="RHEEtelemp" size="20" maxlength="35" value="<cfif modoExperiencia neq 'ALTA'>#trim(data.RHEEtelemp)#</cfif>" onFocus="this.select();"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Puesto#:&nbsp;</strong></td>
			<td>
			
				<cfset ArrayOFIC=ArrayNew(1)>
				<cfif  modoExperiencia neq 'ALTA' and isdefined("data.RHOPid") and len(trim(data.RHOPid))>
					<cfset ArrayAppend(ArrayOFIC,data.RHOPid)>
					<cfset ArrayAppend(ArrayOFIC,data.RHEEpuestodes)>
				</cfif>
                <cfinvoke component="sif.Componentes.Translate"	method="Translate"
				Key="LB_ListaDePuestos" Default="Lista de Puestos" returnvariable="LB_ListaDePuestos"/>
				<cf_conlis
				Campos="RHOPid,RHOPDescripcion"
				Desplegables="N,S"
				Modificables="N,N"
				Size="0,50"
				tabindex="1"
				form="formExperiencia"
				ValuesArray="#ArrayOFIC#" 
				Title="#LB_ListaDePuestos#"
				Tabla="RHOPuesto"
				Columnas="RHOPid,RHOPDescripcion"
				Filtro=" CEcodigo = #Session.CEcodigo# order by RHOPDescripcion"
				Desplegar="RHOPDescripcion"
				Etiquetas="#LB_Puesto#"
				filtrar_por="RHOPDescripcion"
				Formatos="S"
				Align="left"
				Asignar="RHOPid,RHOPDescripcion"
				Asignarformatos="S,S"/>
			</td>
		</tr>		
		<tr>
			<td align="right"><strong>#LB_FechaDeIngreso#:&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
		
						  <select name="mesIni" id="mesIni">
							<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
							<option value="1" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini)) and month(data.RHEEfechaini) EQ 1>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
							<option value="2" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
							<option value="3" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
							<option value="4" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
							<option value="5" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
							<option value="6" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
							<option value="7" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
							<option value="8" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
							<option value="9" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
							<option value="10" <cfif modoExperiencia NEQ 'ALTA'and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini)) and month(data.RHEEfechaini) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
							<option value="11" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
							<option value="12" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and month(data.RHEEfechaini) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
						  </select>
						</td>
						<td>&nbsp;</td>
						<td>
							<select name="anoIni" id="anoIni">
								<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
								<cfloop from="#year(now())#" to="#year(now())-50#" index="i" step="-1">
									<option value="#i#" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfechaini") and len(trim(data.RHEEfechaini))and year(data.RHEEfechaini) EQ i>selected</cfif>>#i#</option>
								</cfloop>
							  </select>
						</td>
					</tr>					
				</table>
			</td>
		</tr>		
		<tr>
			<td align="right"><strong>#LB_FechaDeRetiro#:&nbsp;</strong></td>
			<td>
				<table>
					<tr>
					  <td>
						  <select name="mesFin" id="mesFin">
							<option value="">(<cf_translate key="CMB_Mes" XmlFile="/rh/generales.xml">Mes</cf_translate>)</option>
							<option value="1" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 1 and (createdate(6100,1,1) neq data.RHEEfecharetiro)>selected</cfif>><cf_translate key="CMB_Enero" XmlFile="/rh/generales.xml">Enero</cf_translate></option>
							<option value="2" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 2>selected</cfif>><cf_translate key="CMB_Febrero" XmlFile="/rh/generales.xml">Febrero</cf_translate></option>
							<option value="3" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 3>selected</cfif>><cf_translate key="CMB_Marzo" XmlFile="/rh/generales.xml">Marzo</cf_translate></option>
							<option value="4" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 4>selected</cfif>><cf_translate key="CMB_Abril" XmlFile="/rh/generales.xml">Abril</cf_translate></option>
							<option value="5" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 5>selected</cfif>><cf_translate key="CMB_Mayo" XmlFile="/rh/generales.xml">Mayo</cf_translate></option>
							<option value="6" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 6>selected</cfif>><cf_translate key="CMB_Junio" XmlFile="/rh/generales.xml">Junio</cf_translate></option>
							<option value="7" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 7>selected</cfif>><cf_translate key="CMB_Julio" XmlFile="/rh/generales.xml">Julio</cf_translate></option>
							<option value="8" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 8>selected</cfif>><cf_translate key="CMB_Agosto" XmlFile="/rh/generales.xml">Agosto</cf_translate></option>
							<option value="9" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 9>selected</cfif>><cf_translate key="CMB_Septiembre" XmlFile="/rh/generales.xml">Septiembre</cf_translate></option>
							<option value="10" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 10>selected</cfif>><cf_translate key="CMB_Octubre" XmlFile="/rh/generales.xml">Octubre</cf_translate></option>
							<option value="11" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 11>selected</cfif>><cf_translate key="CMB_Noviembre" XmlFile="/rh/generales.xml">Noviembre</cf_translate></option>
							<option value="12" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and month(data.RHEEfecharetiro) EQ 12>selected</cfif>><cf_translate key="CMB_Diciembre" XmlFile="/rh/generales.xml">Diciembre</cf_translate></option>
						  </select>
					  </td>
					  <td>&nbsp;</td>
					  <td>
						  <select name="anoFin" id="anoFin">
							<option value="">(<cf_translate key="LB_Anno">a&ntilde;o</cf_translate>)</option>
							<cfloop from="#year(now())#" to="#year(now())-50#" index="i" step="-1">
								<option value="#i#" <cfif modoExperiencia NEQ 'ALTA' and isdefined("data.RHEEfecharetiro") and len(trim(data.RHEEfecharetiro)) and year(data.RHEEfecharetiro) EQ i>selected</cfif>>#i#</option>
							</cfloop>
						  </select>						  
					  </td>
					  <td>&nbsp;<input type="checkbox" name="Actualmente" value="" <cfif modoExperiencia neq 'ALTA' and data.Actualmente EQ 1>checked=""</cfif>><label><strong>#CHK_Actualmente#</strong></label></td>
					</tr>
				</table>
			</td>
		</tr>		
		<tr>
				<td align="right"><strong>#LB_AnnosLaborados#:&nbsp;</strong></td>
				<td>
					<input 
						name="RHEEAnnosLab" 
						type="text" 
						id="RHEEAnnosLab"  
						style="text-align: right;" 
						onBlur="javascript: fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						value="<cfif modoExperiencia NEQ 'ALTA'><cfoutput>#data.RHEEAnnosLab#</cfoutput><cfelse>0.00</cfif>">
				</td>
			</tr>

				
		<tr>
			<td align="right"><strong>#LB_MotivoDelRetiro#:&nbsp;</strong></td>
			<td>
				<select name="RHEEmotivo" id="RHEEmotivo">
					<option value=""><cf_translate key="CMB_Ninguno" XmlFile="/rh/generales.xml">Ninguno</cf_translate></option>
					<option value="0" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 0>selected</cfif>><cf_translate key="CMB_Renuncia">Renuncia</cf_translate></option>
					<option value="10" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 10>selected</cfif>><cf_translate key="CMB_Despido">Despido</cf_translate></option>
					<option value="20" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 20>selected</cfif>><cf_translate key="CMB_FinDeContrato">Fin de Contrato</cf_translate></option>
					<option value="30" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 30>selected</cfif>><cf_translate key="CMB_FinDeProyecto">Fin de proyecto</cf_translate></option>
					<option value="40" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 40>selected</cfif>><cf_translate key="CMB_CierreOperaciones">Cierre operaciones</cf_translate></option>
					<option value="50" <cfif modoExperiencia NEQ 'ALTA' and data.RHEEmotivo EQ 50>selected</cfif>><cf_translate key="CMB_Otros">Otros</cf_translate></option>
				</select>
			</td>
		</tr>	
        <!---20140718 - ljimenez  se crea campo para observacion 255 caracteres (IICA)--->
        <tr>
        	<td align="right"><strong>#LB_Observacion#:</strong></td>
        	<td><textarea tabindex="1" name="RHEEobservacion" cols="80" rows="4"><cfif modoExperiencia NEQ 'ALTA'> #data.RHEEobservacion #</cfif></textarea></td>
        </tr>	
		<cfif isdefined('rsDatosVarAll') and rsDatosVarAll.recordCount GT 0>
			<tr><td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="DatosVariables">Datos Variables</cf_translate></td></tr>
			<tr><td colspan="2" align="center">&nbsp;</td></tr>
			<tr> 
				<td colspan="2" align="center">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<cfloop query="rsDatosVarAll">
						  <!--- Campos Variables de Datos del empleado --->
						  <tr> 
							<td width="21%" nowrap class="fileLabel"><cfoutput>#rsDatosVarAll.RHDVEDatoV#</cfoutput>:</td>
							<td width="79%"> 
							  <cfoutput> 
								<input name="#rsDatosVarAll.RHDVEcol#" onFocus="this.select()" type="text" id="#rsDatosVarAll.RHDVEcol#" value="<cfif modoExperiencia NEQ 'ALTA'><cfoutput>#Evaluate("data.#rsDatosVarAll.RHDVEcol#")#</cfoutput></cfif>" size="30" maxlength="30">
							  </cfoutput> 
							</td>
						  </tr>
						</cfloop>
					</table>
				</td>			
			</tr>
		</cfif>
		<tr><td>&nbsp;</td><td align="left"><strong>#LB_FuncionesYLogrosObtenidos#&nbsp;</strong></td></tr>
		<tr>			
			<td colspan="2">
				<cfif modoExperiencia neq 'ALTA'>
					<cf_rheditorhtml name="RHEEfunclogros" width="99%" height="200" value="#trim(data.RHEEfunclogros)#">
			   	<cfelse>
					<cf_rheditorhtml name="RHEEfunclogros" width="99%" height="200">
			   	</cfif>
			</td>
		</tr>
		<cfif modoExperiencia NEQ 'ALTA' and  isdefined('Lvar_EducAuto')>
		<tr>
        	<td align="right"><strong><cf_translate key="LB_Estado">Estado</cf_translate>:</strong></td>
        	<td><strong><cfif data.RHEEestado EQ 0>#LB_PendienteDeAprobar#<cfelseif data.RHEEestado EQ 2>#LB_Rechazada#</cfif></strong></td>
        </tr>
        <tr>
        	<td align="right" valign="top"><strong><cf_translate key="LB_Observ">Observaciones</cf_translate>:</strong></td>
            <td><textarea name="RHEEObserv" cols="70" rows="7"><cfif modoExperiencia NEQ 'ALTA'>#data.RHEEObserv#</cfif></textarea></td>
        </tr>
		</cfif>	  
        
		<!--- Botones --->
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center">

		<cfif modoExperiencia eq 'ALTA'>
			<input type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion();">
			<input type="reset" name="Limpiar" value="#BTN_Limpiar#">
		<cfelse>
			<cfif isdefined('Lvar_EducAuto') and data.RHEEestado eq 1 and LvarAprobarExperiencia>
                <div class="alert alert-dismissable alert-info text-center">
				 <cf_Translate key="MSG_NoPuedeEditarEstarInformacionAprobacionPrevia" xmlFile="/rh/generales.xml">No puede editar esta información debido a una aprobación previa</cf_Translate>
				</div>
            <cfelse>
				<input type="submit" name="Cambio" value="#BTN_Modificar#" onClick="habilitarValidacion();">
				<input type="submit" name="Baja" value="#BTN_Eliminar#" onClick="if ( confirm('#MSG_DeseaEliminarElRegistro#?') ){deshabilitarValidacion(); return true;} return false;">
			</cfif>		
			<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="deshabilitarValidacion();">
		</cfif>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modoExperiencia neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHEEid" value="#data.RHEEid#">
	</cfif>
</form>

<cf_qforms objForm="objForm3" form='formExperiencia'>
	<cf_qformsrequiredfield args="mesIni, #LB_MesDeInicio#">
	<cf_qformsrequiredfield args="anoIni, #LB_AnoDeInicio#">
<!---	<cf_qformsrequiredfield args="mesFin, #LB_MesDeRetiro#">    
	<cf_qformsrequiredfield args="anoFin, #LB_AnoDeRetiro#">--->
    <cf_qformsrequiredfield args="RHEEnombreemp, #LB_NombreDeLaEmpresa#">
    <!----<cf_qformsrequiredfield args="RHEEtelemp, #LB_TelefonoDeLaEmpresa#">---->
    <cf_qformsrequiredfield args="RHOPid, #LB_PuestoDesempenado#">
</cf_qforms>

</cfoutput>
<script language="JavaScript" type="text/javascript">	
	
	arrNombreObjs = new Array();
	arrNombreEtiquetas = new Array();
	//Objetos de los datos variables del empleado
	<cfloop query="rsDatosVarAll">	
		<cfif rsDatosVarAll.RHDVErequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = '<cfoutput>#rsDatosVarAll.RHDVEcol#</cfoutput>';
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsDatosVarAll.RHDVEDatoV#</cfoutput>';
		</cfif>
	</cfloop>
	//Validacion de los datos variables de expriencia
		for(var i=0;i<arrNombreObjs.length;i++){
			eval("objForm3." + arrNombreObjs[i] + ".required = true;");
			eval("objForm3." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");		
		}		
	function habilitarValidacion(){
		objForm3.mesIni.required = true;
		objForm3.anoIni.required = true;
		objForm3.RHEEnombreemp.required= true;
		objForm3.RHOPid.required= true;
		for(var i=0;i<arrNombreObjs.length;i++){
			eval("objForm3." + arrNombreObjs[i] + ".required = true;");
		}	
		if (document.formExperiencia.Actualmente.checked){
			objForm3.mesFin.required= false;
			objForm3.anoFin.required= false;
		}
		else{
			objForm3.mesFin.required= true;
			objForm3.anoFin.required= true;
		}
	}

	function deshabilitarValidacion(){
		objForm3.mesIni.required = false;
		objForm3.anoIni.required = false;
		objForm3.RHEEnombreemp.required= false;
		objForm3.RHOPid.required= false;
		//Validacion de los datos variables de experiencia
		for(var i=0;i<arrNombreObjs.length;i++){
			eval("objForm3." + arrNombreObjs[i] + ".required = false;");
		}
		if (!document.formExperiencia.Actualmente.checked){
			objForm3.mesFin.required= true;
			objForm3.anoFin.required= true;
		}
		else{	
			objForm3.mesFin.required= false;
			objForm3.anoFin.required= false;
		}
	}	


	function funcValida(){
		if (!document.formExperiencia.Actualmente.checked){
			if (document.formExperiencia.anoFin.value == ''){
				alert('<cfoutput>#MSG_DebeSeleccionarElAnoYMesDeFinalizacion#</cfoutput>');
				return false;
			}
			if(document.formExperiencia.mesFin.value == ''){
				alert('<cfoutput>#MSG_DebeSeleccionarElAnoYMesDeFinalizacion#</cfoutput>');
				return false;
			}
		}
		return true;
	}
</script>
