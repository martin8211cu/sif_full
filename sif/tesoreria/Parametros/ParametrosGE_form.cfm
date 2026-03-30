<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CPcuentaAnticipo" default = "Cuenta Presupuestal para Anticipos" returnvariable="LB_CPcuentaAnticipo" xmlfile = "ParametrosGE_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaPorPagarEmpleados" default = "Cuenta Presupuestal para Anticipos" returnvariable="LB_CuentaPorPagarEmpleados" xmlfile = "ParametrosGE_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Retenciones" default = "Habilitar Retenciones" returnvariable="LB_Retenciones" xmlfile = "ParametrosGE_form.xml">
<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnLeeParametro" returntype="string">
	<cfargument name="Pcodigo"		type="numeric"	required="true">	
	<cfargument name="Pdescripcion"	type="string"	required="true">	
	<cfargument name="Pdefault"		type="string"	required="false">	
	<cfset var rsSQL = "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfreturn rsSQL.Pvalor>
	<cfelseif isdefined("Arguments.Pdefault")>
		<cfreturn Arguments.Pdefault>
	<cfelse>
		<cf_errorCode	code = "50436"
						msg  = "No se ha definido el Parámetro @errorDat_1@ - @errorDat_2@"
						errorDat_1="#Pcodigo#"
						errorDat_2="#Pdescripcion#"
		>
	</cfif>
</cffunction>

<!---PARAMETRO PARA ANTICIPOS DE EMPLEADO--->
<cfset LvarCxC_1		= fnLeeParametro(1200,"Cuenta por Cobrar para la gestión de Anticipos a Empleados","")>
<cfset LvarMontoMax		= fnLeeParametro(1201,"Monto máximo para viáticos al interior","")>
<cfset LvarCxC_2		= fnLeeParametro(1210,"Cuenta por Cobrar para Viáticos por Comision Nacionales","")>
<cfset LvarCxC_3		= fnLeeParametro(1211,"Cuenta por Cobrar para Viáticos por Comision al Exterior","")>
<cfset LvarCxP 			= fnLeeParametro(1212,"CxP a Empleados para Pago Adicional en Liquidación","")>
<cfset LvarAnt 			= fnLeeParametro(1213,"Solicitar Anticipos con Anticipos del mismo tipo sin Liquidar","")>
<cfset LvarLiq			= fnLeeParametro(1214,"Liquidar gastos con Anticipos del mismo tipo sin liquidar","")>
<cfset LvarLiqContra	= fnLeeParametro(1215,"Liquidar gastos con Anticipos con Saldo en contra","")>
<cfset LvarImpNCF		= fnLeeParametro(1216,"Digitar Impuesto No Crédito Fiscal en Linea de Gastos","")>
<cfset LvarchkCorreoAprobadores	= fnLeeParametro(1217,"Envia correos a los aprobadores de Anticipos y Liquidaciones","")>
<cfset LvarchkFechaDeposito	= fnLeeParametro(1220,"Permite digitar Fecha en Recepción de Efectivo","0")>
<cfset LvarchkRegMonTCE		= fnLeeParametro(1230,"Permite digitar el gasto en moneda de TCE","0")>
<cfset LvarcboCPcuentaAnticipo		= fnLeeParametro(1231,"Cuenta Presupuestal para Anticipo","1")>
<cfset LvarchkCuentaPagarEmpleados = fnLeeParametro(1232,"Utilizar cuenta por pagar a empleados","0")>
<cfset LvarCuentaPagarEmpleados	= fnLeeParametro(1233,"Cuenta por pagar a empleados","")>
<cfset LvarRetenciones	= fnLeeParametro(1234,"Registro de Retenciones","0")>
<!---BUSQUEDA DE LA CF PARA TIPO --->
<cfquery name="rsCxC_1" datasource="#Session.DSN#">
	select CFdescripcion, CFcuenta, CFformato, Ccuenta
	from CFinanciera
	where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCxC_1#" null="#Len(Trim(LvarCxC_1)) EQ 0#" >
</cfquery>

<cfquery name="rsCxC_2" datasource="#Session.DSN#"><!---Cambio para agregar Comodin en Viáticos por Comisión Nacionales RVD 16/01/2014--->
select Pvalor as Cformato,'' as Ccuenta, '' as Cdescripcion, '' as CFcuenta
	from Parametros
	where Pcodigo = 1210
</cfquery>

<cfquery name="rsCxC_3" datasource="#Session.DSN#"><!---Cambio para agregar Comodin en Viáticos por Comisión al Exterior RVD 16/01/2014---> 
select  Pvalor as Cformato,'' as Ccuenta, '' as Cdescripcion, '' as CFcuenta
	from Parametros
	where Pcodigo = 1211
</cfquery>

<cfquery name="rsCxP" datasource="#Session.DSN#">
	select CFdescripcion, CFcuenta, CFformato, Ccuenta
	from CFinanciera
	where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCxP#" null="#Len(Trim(LvarCxP)) EQ 0#" >
</cfquery>
<cfquery name="rsCuentaPagarEmpleados" datasource="#Session.DSN#">
	select CFdescripcion, CFcuenta, CFformato, Ccuenta
	from CFinanciera
	where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaPagarEmpleados#" null="#Len(Trim(LvarCuentaPagarEmpleados)) EQ 0#" >
</cfquery>

<cfoutput>
<form action="ParametrosGE_sql.cfm" method="post" name="form1">
<p></p>
	<table width="85%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr>
			<td nowrap>
				CxC a Empleados para Anticipos de Gasto a Empleados:
			</td>
			<td nowrap>		
				<cfif rsCxC_1.CFcuenta NEQ ''>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CxC_1" query="#rsCxC_1#">
				<cfelse>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CxC_1">
				</cfif>
			</td>
		
			<td colspan="2" align="center">&nbsp;</td>
		</tr>

		<tr>
			<td nowrap>
				CxC a Empleados para Viáticos por Comisión Nacionales:
			</td>
			<td nowrap>		
				<cfif rsCxC_2.Cformato NEQ ''>                
					<cf_cuentasanexo <!---Cambio para agregar Comodin en Viáticos por Comisión Nacionales RVD 16/01/2014--->
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="ccuenta" 
							cdescripcion="CFdescripcion"
							cformato="CxC_2" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frame1"
							query="#rsCxC_2#"
							comodin="?" tabindex="1">  
      			<cfelse>
	                <cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="ccuenta" 
							descwidth="20"
							cdescripcion="Cdescripcion"
							cformato="CxC_2"
							conexion="#Session.DSN#"
							form="form1"
							frame="frame1"
							comodin="?" tabindex="1">
                          

				</cfif>
			</td>
		
			<td colspan="2" align="center">&nbsp;</td>
		</tr>
		<tr>
			<td nowrap>
				CxC a Empleados para Viáticos por Comisión al Exterior:&nbsp;
			</td>
			<td nowrap>		
				<cfif rsCxC_3.Cformato NEQ ''><!---Cambio para agregar Comodin en Viáticos por Comisión al Exterior RVD 16/01/2014--->
					<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="ccuenta_CxC_3" 
							cdescripcion="CFdescripcion"
							cformato="CxC_3" 
							conexion="#Session.DSN#"
							form="form1"
							frame="frame1"
							query="#rsCxC_3#"
							comodin="?" tabindex="2">      
				<cfelse>
                      <cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="ccuenta_CxC_3" 
							descwidth="20"
							cdescripcion="Cdescripcion"
							cformato="CxC_3"
							conexion="#Session.DSN#"
							form="form1"
							frame="frame1"
							comodin="?" tabindex="2">
				</cfif>
                
                
			</td>
		
			<td colspan="2" align="center">&nbsp;</td>
		</tr>
        
        <!---Liquidar gastos con anticipos con Saldo en contra--->
        <tr>
			<td nowrap>
				CxP a Empleados para Pago Adicional en Liquidación:&nbsp;
			</td>
			<td nowrap>		
				<cfif rsCxP.CFcuenta NEQ ''>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CxP" query="#rsCxP#">
				<cfelse>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CxP">
				</cfif>
			</td>
			<td colspan="2" align="center">&nbsp;</td>
		</tr>

		<tr>
			<td nowrap>
				Monto máximo para viáticos al interior:			
			</td>
			<td nowrap>		
				<!---<cf_monto name="MontoMax" id="MontoMax" tabindex="-1" value="#LvarMontoMax#" decimales="0" negativos="false">--->
                <cf_inputnumber name="MontoMax" id="MontoMax" value="#LvarMontoMax#"
         			 form="form1" enteros="15" decimales="2" tabindex="2"
          		>
			</td>
			<td colspan="2" align="center">&nbsp;</td>
		</tr>
		
		<!---Liquidar Gastos con anticipos--->
        <tr>
			<td nowrap>
				Solicitar Anticipos con Anticipos del mismo tipo sin Liquidar:&nbsp;		
			</td>
			<td nowrap>	
                <select name="cboAnt">
                    <option value=""  <cfif LvarAnt EQ "" >selected</cfif>>No Permitir</option>
                    <option value="1" <cfif LvarAnt EQ "1">selected</cfif>>Permitir</option>
				</select>
			</td>
		
			<td colspan="2" align="center">&nbsp;</td>
		</tr>
        
        <!---Liquidacion de gastos del mismo tipo--->
        <tr>
			<td nowrap>
				Liquidar gastos con Anticipos del mismo tipo sin liquidar:
			</td>
			<td nowrap>		
				<select name="cboLiq">
                    <option value=""  <cfif LvarLiq EQ "" >selected</cfif>>No Permitir</option>
                    <option value="1" <cfif LvarLiq EQ "1">selected</cfif>>Permitir</option>
				</select>
			</td>
		
			<td colspan="2" align="center">&nbsp;</td>
		</tr>
        
		<!---Liquidar gastos con anticipos con Saldo en contra--->
        <tr>
			<td nowrap>
				Liquidar gastos con Anticipos con Saldo en contra:
			</td>
			<td nowrap>		
				<select name="cboLiqContra">
                    <option value=""  <cfif LvarLiqContra EQ "" >selected</cfif>>No Permitir</option>
                    <option value="1" <cfif LvarLiqContra EQ "1">selected</cfif>>Permitir</option>
				</select>
			</td>
		</tr>

		<!---Digitar Impuesto No Crédito Fiscal en Linea de Gastos--->
        <tr>
			<td nowrap>
				Digitar Impuesto No Crédito Fiscal en Linea de Gastos:
			</td>
			<td nowrap>
				<input type="checkbox" name="chkImpNCF" value="1" <cfif LvarImpNCF EQ "1"> checked</cfif>>
			</td>
		</tr>
		
		<!---Envia correos a los aprobadores de Anticipos y Liquidaciones--->
        <tr>
			<td nowrap>
				Envia correos a los aprobadores de Anticipos y Liquidaciones:
			</td>
			<td nowrap>
				<input type="checkbox" name="chkCorreoAprobadores" value="1" <cfif LvarchkCorreoAprobadores EQ "1"> checked</cfif>>
			</td>
		</tr>
		
        <tr>
			<td nowrap>
				Permite digitar Fecha en Recepción de Efectivo:
			</td>
			<td nowrap>
				<input type="checkbox" name="chkFechaDeposito" value="1" <cfif LvarchkFechaDeposito EQ "1"> checked</cfif>>
			</td>
		</tr>
        <tr>
			<td nowrap>
				Permite digitar el gasto en moneda de TCE:
			</td>
			<td nowrap>
				<input type="checkbox" name="chkGstoMonTCE" value="1" <cfif LvarchkRegMonTCE EQ "1"> checked</cfif>>
			</td>
		</tr>
		 <tr>
			<td nowrap>
				Permite registrar Retenciones:
			</td>
			<td nowrap>
				<input type="checkbox" name="chkRetenciones" value="1" <cfif LvarRetenciones EQ "1"> checked</cfif>>
			</td>
		</tr>
        <!---SML. Inicio Modificacion para contemplar la Cuenta de  Presupuesto: Empleado, Gasto--->
        <tr>
			<td nowrap>
				#LB_CPcuentaAnticipo#
			</td>
			<td nowrap>
				<select name="cboCPcuentaAnticipo">
                    <option value="1" <cfif LvarcboCPcuentaAnticipo EQ "1" >selected</cfif>>Cuenta Empleado</option>
	                <option value="2" <cfif LvarcboCPcuentaAnticipo EQ "2" >selected</cfif>>Cuenta Gasto</option>
				</select>
			</td>
		</tr>
        <!---SML. Fin Modificacion para contemplar la Cuenta de  Presupuesto: Empleado, Gasto--->
        <!---SML. Inicio Creacion de parametro para utilizar cuenta por pagar a empleados--->
        <tr>
			<td nowrap>
				#LB_CuentaPorPagarEmpleados#
			</td>
			<td nowrap>
				<input type="checkbox" name="chkCuentaPagarEmpleados" value = "1" onchange="fnhabilitar(this.form,'trCuentasPagar');"<cfif LvarchkCuentaPagarEmpleados EQ "1">checked</cfif>>
			</td>
		</tr>
        <tr id="trCuentasPagar" <cfif LvarchkCuentaPagarEmpleados NEQ "1">style="display:none"</cfif>>
			<td nowrap>
				
			</td>
			<td nowrap>
				<cfif rsCuentaPagarEmpleados.CFcuenta NEQ ''>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CuentaPagarEmpleados" query="#rsCuentaPagarEmpleados#">
				<cfelse>
					<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CuentaPagarEmpleados">
				</cfif>
			</td>
		</tr>
        <!---SML. Fin Creacion de parametro para utilizar cuenta por pagar a empleados--->
		<tr>
			<td nowrap>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center" nowrap>
				<input type="submit" name="btnAceptar" value="Aceptar" onclick="Validar();" />
			</td>
		</tr>
	</table>

</form>
</cfoutput>

<script languaje="javascript">
function fnhabilitar(form,tr)
{
    if (form.chkCuentaPagarEmpleados.checked == true)
    {
	  if (!document.getElementById) return false;
  	  fila = document.getElementById(tr);
  		if (fila.style.display != "none") {
    	fila.style.display = "none"; //ocultar fila 
  		} else {
   		fila.style.display = ""; //mostrar fila 
  		}
    }
	else
	{
		fila = document.getElementById(tr);
		if (fila.style.display != "none") {
    	fila.style.display = "none"; //ocultar fila 
		form.CuentaPagarEmpleados.display = "none";
  		}	
	}
}

function Validar()
{	
	if(document.form1.chkCuentaPagarEmpleados.checked == true)
	{
		if(document.form1.CuentaPagarEmpleados.value == '')
		{
			alert('Registra una Cuenta por pagar a Empleados');
			return false;
		}
	}
}
</script>

