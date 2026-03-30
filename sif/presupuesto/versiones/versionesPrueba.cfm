<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfif isdefined("form.CtaMayor")>
		<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera "
		 method="fnGeneraCuentaFinanciera"
		 returnvariable="MSG">
			<cfinvokeargument name="Lprm_Cmayor" value="#form.CtaMayor#"/>
			<cfinvokeargument name="Lprm_Cdetalle" value="#form.Detalle#"/>
			<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
			<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
		
			<cfif isdefined("form.btnCPcuenta") OR isdefined("form.btnCVPcuenta")>
				<cfif form.Ejecucion NEQ 'V'>
					<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
				<cfelse>
					<cfinvokeargument name="Lprm_EsDePresupuesto" value="true"/>
				</cfif>
				<cfif isdefined("form.btnCVPcuenta")>
				<cfinvokeargument name="Lprm_CVid" value="#form.CVid#"/>
				</cfif>
			</cfif>
			<cfinvokeargument name="Lprm_debug" value="#form.Ejecucion EQ 'D'#"/>
		</cfinvoke>
		<cfoutput>
		**************#MSG#***************
		</cfoutput>
	</cfif>
	<cfoutput>
	<form action=""	 method="post" name="form1">
		<strong>GENERACION DE CUENTA FINANCIERA</strong>
		<table>
			<tr>
				<td>
					Cuenta Mayor
				</td>
				<td>
					<input type="text" name="CtaMayor" size="4" value="<cfif isdefined("form.btnCcuenta")>#form.CtaMayor#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Detalle
				</td>
				<td>
					<input type="text" name="Detalle" size="40" value="<cfif isdefined("form.btnCcuenta")>#form.Detalle#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Ejecucion
				</td>
				<td>
					<select name="Ejecucion">
						<option value="D">Debug</option>
						<option value="G">Generar</option>
					</select>
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
					Cuenta Mayor
				</td>
				<td>
					<input type="text" name="CtaMayor" size="4" value="<cfif isdefined("form.btnCPcuenta")>#form.CtaMayor#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Detalle
				</td>
				<td>
					<input type="text" name="Detalle" size="40" value="<cfif isdefined("form.btnCPcuenta")>#form.Detalle#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Ejecucion
				</td>
				<td>
					<select name="Ejecucion">
						<option value="D">Debug</option>
						<option value="G">Generar</option>
						<option value="V">Verificar Existencia</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" name="btnCPcuenta" value="Genera Cuenta Presupuestaria">
				</td>
			</tr>
		</table>
	</form>
	<form action=""	 method="post" name="form3">
		<strong>GENERACION DE CUENTA DE PRESUPUESTO EN CONTROL DE VERSIONES DE PRESUPUESTO</strong>
		<table>
			<tr>
				<td>
					Cuenta Mayor
				</td>
				<td>
					<input type="text" name="CtaMayor" size="4" value="<cfif isdefined("form.btnCVPcuenta")>#form.CtaMayor#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Detalle
				</td>
				<td>
					<input type="text" name="Detalle" size="40" value="<cfif isdefined("form.btnCVPcuenta")>#form.Detalle#</cfif>">
				</td>
			</tr>
			<tr>
				<td>
					Ejecucion
				</td>
				<td>
					<select name="Ejecucion">
						<option value="D">Debug</option>
						<option value="G">Generar</option>
						<option value="V">Verificar Existencia</option>
					</select>
					Control de Version: <input type="text" name="CVid" value="<cfif isdefined("form.btnCVPcuenta")>#form.CVid#</cfif>" size="6" maxlength="6">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" name="btnCVPcuenta" value="Genera Cuenta Version Presupuestaria">
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

		<cf_cuentas2 Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form3" Ccuenta="Ccuenta2" query="#rsPrueba#"> 
<input name="mascara">
	</form>
	</cfoutput>
</body>
<script language="javascript">
	var x=new Mask("##-####-####");
	x.attach(document.form3.mascara);
	x.mandatory = false;
</script>
</html>
