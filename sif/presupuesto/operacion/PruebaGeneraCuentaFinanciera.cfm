<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfif isdefined("form.Cformato")>
	<cfif isdefined("form.btnVerifica")>
		<cfinvoke 	component		= "sif.Componentes.PC_VerificaCuentasFinancieras"
					method			= "VerificacionCFformato"
					returnvariable	= "MSG"
					
					Ecodigo			= "#session.Ecodigo#"
					CFformato		= "#form.Cformato#"
					Ocodigo			= "#form.Ocodigo#"
					Efecha			= "#now()#"
					datasource		= "#session.dsn#"
		>
		<cfoutput>
		**************<BR>
		<font color="##CC3300">
		#MSG#
		</font>
		***************<BR>
		</cfoutput>
		<cfinvoke 	component		= "sif.Componentes.PC_VerificaCuentasFinancieras"
					method			= "VerificacionCFcuenta"
					returnvariable	= "MSG"
					
					Ecodigo			= "#session.Ecodigo#"
					CFcuenta		= "500000000018670"
					Ocodigo			= "#form.Ocodigo#"
					Efecha			= "#now()#"
					datasource		= "#session.dsn#"
		>

		<cfoutput>
		**************<BR>
		<font color="##CC3300">
		#MSG#
		</font>
		***************<BR>
		</cfoutput>
	<cfelse>	
		<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnGeneraCuentaFinanciera"
		 returnvariable="MSG">
			<cfinvokeargument name="Lprm_CFformato" value="#form.Cformato#"/>
			<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
			<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
		
			<cfif isdefined("form.btnCcuenta")>
				<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
				<cfif form.Ejecucion EQ 'V'>
					<cfinvokeargument name="Lprm_SoloVerificar" value="true"/>
				<cfelseif form.Ejecucion EQ 'G'>
					<cfinvokeargument name="Lprm_CrearConPlan" 	value="true"/>
					<cfinvokeargument name="Lprm_CrearSinPlan" 	value="false"/>
				<cfelse>
					<cfinvokeargument name="Lprm_CrearConPlan" 	value="false"/>
					<cfinvokeargument name="Lprm_CrearSinPlan" 	value="true"/>
				</cfif>
			</cfif>
			<cfinvokeargument name="Lprm_Cdescripcion" value="#form.Cdescripcion#"/>

			<cfif isdefined("form.btnCPcuenta")>
			<cfinvokeargument name="Lprm_CPformato" value="#form.Cformato#"/>
				<cfinvokeargument name="Lprm_EsDePresupuesto" value="true"/>
				<cfif form.Ejecucion EQ 'V'>
					<cfinvokeargument name="Lprm_CrearPresupuesto" value="false"/>
				<cfelse>
					<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
				</cfif>
				<cfif form.CVid EQ "">
					<cfinvokeargument name="Lprm_CPPid" value="#form.CPPid#"/>
					<cfinvokeargument name="Lprm_CVPtipoControl" value="#form.CVPtipoControl#"/>
					<cfinvokeargument name="Lprm_CVPcalculoControl" value="#form.CVPcalculoControl#"/>
				<cfelse>
					<cfinvokeargument name="Lprm_CVid" value="#form.CVid#"/>
				</cfif>
			</cfif>
			<cfinvokeargument name="Lprm_debug" value="#isdefined('form.chkDebug')#"/>
		</cfinvoke>
		<cfoutput>
		**************
		<font color="##CC3300">
		#MSG#
		</font>
		***************
		</cfoutput>
	</cfif>
</cfif>
	<form action=""	 method="post" name="form1">
		<strong>GENERACION DE CUENTA FINANCIERA</strong>
		<table>
			<tr>
				<td>
					Cuenta Financiera
				</td>
				<td>
					<input type="text" name="Cformato" size="40" value="<cfif isdefined("form.Cformato")><cfoutput>#form.Cformato#</cfoutput></cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Descripcion
				</td>
				<td colspan="2">
					<input type="text" name="Cdescripcion" size="80" value="<cfif isdefined("form.Cformato")><cfoutput>#form.Cdescripcion#</cfoutput></cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Ejecucion
				</td>
				<td>
					<select name="Ejecucion">
						<option value="V">Verificar</option>
						<option value="G">Generar Solo Con Plan</option>
						<option value="C">Generar Con o Sin Plan</option>
					</select>
					&nbsp;<input type="checkbox" name="chkDebug" value="1" checked> Debug
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" name="btnCcuenta" value="Genera Cuenta Financiera">
				</td>
			</tr>
		</table>
<!--- 		<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1"> 
 --->
 	</form>
	<form action=""	 method="post" name="form2">
		<strong>GENERACION DE CUENTA DE PRESUPUESTO</strong>
		<table>
			<tr>
				<td>
					Cuenta Presupuesto
				</td>
				<td colspan="2">
					<input type="text" name="Cformato" size="40" value="<cfif isdefined("form.Cformato")><cfoutput>#form.Cformato#</cfoutput></cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Descripcion
				</td>
				<td colspan="2">
					<input type="text" name="Cdescripcion" size="80" value="<cfif isdefined("form.Cformato")><cfoutput>#form.Cdescripcion#</cfoutput></cfif>">
				</td>
			</tr>
			<tr>
				<td valign="top">
					Ejecucion
				</td>
				<td>
					<select name="Ejecucion">
						<option value="G">Generar</option>
						<option value="V">Verificar Existencia</option>
					</select>
					&nbsp;<input type="checkbox" name="chkDebug" value="1" checked> Debug
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsVersion" datasource="#session.dsn#">
		select CVid,
			   	case a.CVtipo when '1' then 'Formulación Ordinaria ' when '2' then 'Modificación Extraordinaria ' else '' end
				#_Cat# 'Periodo ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				#_Cat# ' - ' #_Cat# CVdescripcion
			as Vdescripcion
		from CVersion a 
			inner join CPresupuestoPeriodo b 
				on a.CPPid = b.CPPid 
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = #session.ecodigo#
			and a.CVaprobada = 0
		order by a.CVtipo, b.CPPfechaDesde, a.CVid
	</cfquery>
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select CPPid,
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
				#_Cat# case CPPestado when 0 then ' (Inactivo)' when 1 then ' (Abierto)' when 2 then ' (Cerrado)' when 5 then ' (Sin Presup)' else '????' end
			as Pdescripcion
		from CPresupuestoPeriodo b 
		where b.Ecodigo = #session.ecodigo#
		order by b.CPPfechaDesde
	</cfquery>
					
					<BR>Periodo de Presupuesto:<BR>
					<select name="CPPid">
					<cfoutput query="rsPeriodo">
						<option value="#CPPid#" <cfif isdefined("form.CPPid") AND CPPid EQ form.CPPid>selected</cfif>>#Pdescripcion#</option>
					</cfoutput>
					</select>
					<BR>Control de Version:<BR>
					<select name="CVid">
						<option value="">(Periodo de Presupuesto)</option>
					<cfoutput query="rsVersion">
						<option value="#CVid#"<cfif isdefined("form.CPPid") AND CPPid EQ form.CVid>selected</cfif>>#Vdescripcion#</option>
					</cfoutput>
					</select>
				</td>
			    <td>
					Tipo Control: 
						<select name="CVPtipoControl">
							<option value="0">Abierto</option>
							<option value="1">Restringido</option>
							<option value="2">Restrictivo</option>
						</select><br>
					Tipo Cálculo:
						<select name="CVPcalculoControl">
							<option value="1">Mensual</option>
							<option value="2">Acumulado</option>
							<option value="3">Total</option>
						</select>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="btnCPcuenta" value="Genera Cuenta Presupuestaria" onClick="if (form2.CPPid.value == '' && form2.CVid.value == '') {alert ('Digite el Período o la Version'); return false;}">
				</td>
			</tr>
		</table>


		<cfquery name="rsPrueba" datasource="#session.dsn#">
			select * from CFinanciera
			where Ecodigo = #session.Ecodigo# and Cmayor='0018' and CFmovimiento='S'
		</cfquery>
		<cfquery name="rsPrueba" datasource="#session.dsn#">
			select * from CContables
			where Ecodigo = #session.Ecodigo# and Cmayor='0018' and Cmovimiento='S'
		</cfquery>
		
		<cf_cuentas Conexion="#Session.DSN#" Ocodigo="Ocodigo" Conlis="S" auxiliares="N" movimiento="S" form="form2" Ccuenta="Ccuenta2" query="#rsPrueba#"> 
		<input name="Ocodigo" id="Ocodigo" value="0">
		<input type="submit" name="btnVerifica" value="Verifica Cuenta"">
	</form>
</body>
</html>
