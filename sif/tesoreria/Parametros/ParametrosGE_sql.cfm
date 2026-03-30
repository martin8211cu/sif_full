<cfset form.MontoMax = replace(form.MontoMax,",","","ALL")>
<cfparam name="form.chkImpNCF" default="">
<cfparam name="form.chkCorreoAprobadores" default="">
<cfparam name="form.chkFechaDeposito" default="0">
<cfparam name="form.chkGstoMonTCE" default="0">
<cfparam name="form.chkCuentaPagarEmpleados" default="0"> <!---SML. Creacion de parametro para utilizar cuenta por pagar a empleados--->

<cfif isDefined("Form.btnAceptar")>
	<cfset fnGrabaParametro(1200,"GE", "Cuenta por Cobrar para la gestión de Anticipos a Empleados",
							form.cfcuenta_CxC_1, 
							true
							)>
	<cfset fnGrabaParametro(1201,"GE", "Monto máximo para viáticos al interior",
							form.MontoMax, 
							true
							)>						
	<cfset fnGrabaParametro(1210,"GE", "Cuenta por Cobrar para Viáticos por Comisión Nacionales",
							"#Cmayor_CxC_2#-#form.CxC_2#",<!---Cambio para agregar Comodin en Viáticos por Comisión Nacionales RVD 16/01/2014--->
							false, ""
							)>
	<cfset fnGrabaParametro(1211,"GE", "Cuenta por Cobrar para Viáticos por Comision al Exterior",
							"#Cmayor_CxC_3#-#form.CxC_3#",<!---Cambio para agregar Comodin en Viáticos por Comisión al Exterior RVD 16/01/2014--->
							false, ""
							)>
	<cfset fnGrabaParametro(1212,"GE", "CxP a Empleados para Pago Adicional en Liquidación",
							form.cfcuenta_CxP, 
							true
							)>
	<cfset fnGrabaParametro(1213,"GE", "Solicitar Anticipos con Anticipos del mismo tipo sin Liquidar",
							form.cboAnt, 
							false, ""
							)>
	<cfset fnGrabaParametro(1214,"GE", "Liquidar gastos con Anticipos del mismo tipo sin liquidar",
							form.cboLiq, 
							false, ""
							)>
	<cfset fnGrabaParametro(1215,"GE", "Liquidar gastos con Anticipos con Saldo en contra",
							form.cboLiqContra, 
							false, ""
							)>
	<cfset fnGrabaParametro(1216,"GE", "Digitar Impuesto No Crédito Fiscal en Linea de Gastos",
							form.chkImpNCF, 
							false, ""
							)>
	<cfset fnGrabaParametro(1217,"GE", "Envia correos a los aprobadores de Anticipos y Liquidaciones",
							form.chkCorreoAprobadores, 
							false, ""
							)>
	<cfset fnGrabaParametro(1220,"GE", "Permite digitar Fecha en Recepcion de Efectivo",
                        form.chkFechaDeposito, 
                        false, ""
                        )>
	<cfset fnGrabaParametro(1230,"GE", "Permite digitar el gasto en moneda de TCE",
                        form.chkGstoMonTCE, 
                        false, ""
                        )>
    <cfset fnGrabaParametro(1234,"GE", "PPermite registrar Retenciones",
                        form.chkRetenciones, 
                        false, ""
                        )>
    <!---SML. Inicio Modificacion para contemplar la Cuenta de  Presupuesto: Empleado, Gasto--->
    <cfset fnGrabaParametro(1231,"GE", "Cuenta Presupuestal para Anticipo",
                        form.cboCPcuentaAnticipo, 
                        false, ""
                        )>  
    <!---SML. Final Modificacion para contemplar la Cuenta de  Presupuesto: Empleado, Gasto--->  
    <!---SML. Inicio Creacion de parametro para utilizar cuenta por pagar a empleados--->
    <cfset fnGrabaParametro(1232,"GE", "Utilizar cuenta por pagar a empleados",
                        form.chkCuentaPagarEmpleados, 
                        false, ""
                        )>  
    <cfif form.chkCuentaPagarEmpleados EQ 0>
    	<cfquery  datasource="#Session.DSN#">
			delete from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="1233">
		</cfquery>
    </cfif>
    <cfif form.chkCuentaPagarEmpleados EQ 1>
    <cfset fnGrabaParametro(1233,"GE", "Cuenta por pagar a empleados",
                        form.cfcuenta_CuentaPagarEmpleados, 
                        false, ""
                        )> 
     </cfif>                   
    <!---SML. Final Creacion de parametro para utilizar cuenta por pagar a empleados--->                  
</cfif>

<cflocation url="ParametrosGE.cfm">

<!--- Graba los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnGrabaParametro" returntype="void">
	<cfargument name="Pcodigo"		type="numeric" required="true">	
	<cfargument name="Mcodigo"		type="string" required="true">	
	<cfargument name="Pdescripcion"	type="string" required="true">	
	<cfargument name="Pvalor"		type="string" required="true">	
	<cfargument name="obligatorio"	type="boolean" required="true">
	<cfargument name="Pdefault"		type="string" required="no">
	
	<cfif Arguments.Pvalor EQ "" and Arguments.obligatorio>
		<cf_errorCode	code = "50781"
						msg  = "Debe digitar un valor para el parámetro @errorDat_1@"
						errorDat_1="#Arguments.Pdescripcion#"
		>
	</cfif>
	<cfif Arguments.Pvalor NEQ "" OR isdefined("Arguments.Pdefault")>
		<cfif Arguments.Pvalor EQ "" AND isdefined("Arguments.Pdefault")>
			<cfset Arguments.Pvalor = Arguments.Pdefault>
		</cfif>
		<cfif Arguments.Pvalor EQ "">
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				delete from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select count(1) as cantidad
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfquery datasource="#Session.DSN#">
					insert INTO Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Mcodigo)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pdescripcion)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pvalor)#"> 
                        
						)
				</cfquery>
			<cfelse>
				<cfquery datasource="#Session.DSN#">
					update Parametros 
						set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pvalor)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">			
				</cfquery>				
			</cfif>
		</cfif>
	</cfif>
</cffunction>


