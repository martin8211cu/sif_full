<cfparam name="form.McodigoValuacion"	default="">
<cfparam name="form.CVPendiente"		default="">
<cfparam name="form.cfcuenta_ccuentaestimacion"	default="">
<cfparam name="form.PrcOCnegativos"		default="">
<cfparam name="form.PrcOCcierre" 		default="">


<cfif isDefined("Form.btnAceptar")>
	<cfset fnGrabaParametro(490,"IV", "Mantener Costo de Ventas Pendiente",
							form.CVPendiente, "0"
							)>
	<cfset fnGrabaParametro(441,"IV", "Moneda Valuación de Inventarios",				
							form.McodigoValuacion
							)>
	<cfset fnGrabaParametro(442,"OC", "Porcentaje permitido para Existencias Negativas de Tránsito (0-9%)",
							form.PrcOCnegativos
							)>
	<cfset fnGrabaParametro(443,"OC", "Porcentaje permitido de sobrantes para Cierre de Transportes (0-99%)",
							form.PrcOCcierre
							)>
	<cfset fnGrabaParametro(444,"OC", "Socio de Negocios default (propia Empresa) para Movs Origenes diferentes a CxP",
							form.SNid
							)>
	<cfset fnGrabaParametro(980,"CG", "Cuenta Financiera de balance para reversión de estimación",
							form.cfcuenta_ccuentaestimacion
							)>
</cfif>
<cflocation url="ParametrosOC.cfm">

<!--- Graba los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnGrabaParametro" returntype="void">
	<cfargument name="Pcodigo"		type="numeric" required="true">	
	<cfargument name="Mcodigo"		type="string" required="true">	
	<cfargument name="Pdescripcion"	type="string" required="true">	
	<cfargument name="Pvalor"		type="string" required="true">	
	<cfargument name="Pdefault"		type="string" required="no">
	<cfif Arguments.Pvalor NEQ "" OR isdefined("Arguments.Pdefault")>
		<cfif Arguments.Pvalor EQ "" AND isdefined("Arguments.Pdefault")>
			<cfset Arguments.Pvalor = Arguments.Pdefault>
		</cfif>
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
</cffunction>
