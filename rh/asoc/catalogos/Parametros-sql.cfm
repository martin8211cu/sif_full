<!--- Proceso de Actualización de la tabla de Parémtros de la Asociación --->
<cfif isDefined("Form.btnAceptar")>
	
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="datos" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">
		<cfargument name="empresa" type="string" required="false" default="#session.Ecodigo#">
		
		<cfset cpdescripcion = mid(#pdescripcion#,1,80)>
		
		<cfquery name="checkExists" datasource="#Session.DSN#">
			select 1
			from ACParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
		</cfquery>
		
		<cfif checkExists.recordCount GT 0>
			<!--- Update los parámetros --->
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				update ACParametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pvalor)#" null="#len(trim(pvalor)) EQ 0#">,
					Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cpdescripcion)#">
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			</cfquery>
		
		<cfelse>
			<!--- Insert los parámetros --->
			<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into ACParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor, BMUsucodigo, BMfecha )
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">, 
				    <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(cpdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(pvalor)#" null="#len(trim(pvalor)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<!--- Ahorro y Crédito: Inserta los valores de los parametros. --->
	<cftransaction>
		<!--- 10. Periodo Contable --->
		<cfif isdefined("form.Periodo") >	
			<cfset datos(10, 'Periodo Contable', #form.Periodo# )>
		</cfif>
		
		<!--- 20. Mes Contable --->
		<cfif isdefined("form.Mes") >
			<cfset datos(20, 'Mes Contable', #form.Mes#)>
		</cfif>
		
		<!--- 30. Factor de días del año --->
		<cfif isdefined("form.FactorDiasAnio") ><cfset vDiasAnio = #form.FactorDiasAnio# ><cfelse><cfset vDiasAnio = 365 ></cfif>	
		<cfset datos(30, 'Factor de días del año', #vDiasAnio#)>	
		
		<!--- 40. Orden Aplicación de Adelanto de Pago --->
		<cfset datos(40, 'Orden Aplicación de Adelanto de Pago', #form.AdelantoPago#)>
		
		<!--- 50. Metodo de Cálculo de Dividendos --->
		<cfset datos(50, 'Metodo de Cálculo de Dividendos', #form.CalculoDividendos#)>
		
		<!--- 60. Factor de Días de Nómina Mensual --->
		<cfif isdefined("form.NominaMensual") ><cfset vMensual = #form.NominaMensual# ><cfelse><cfset vMensual = 365 ></cfif>	
		<cfset datos(60, 'Factor de Días de Nómina Mensual', #vMensual#)>
		
		<!--- 70. Factor de Días de Nómina Quincenal --->
		<cfif isdefined("form.NominaQuincenal") ><cfset vQuincenal = #form.NominaQuincenal# ><cfelse><cfset vQuincenal = 15 ></cfif>	
		<cfset datos(70, 'Factor de Días de Nómina Quincenal', #vQuincenal#)>
		
		<!--- 80. Factor de Días de Nómina Bisemanal --->
		<cfif isdefined("form.NominaBisemanal") ><cfset vBisemanal = #form.NominaBisemanal# ><cfelse><cfset vBisemanal = 14 ></cfif>	
		<cfset datos(80, 'Factor de Días de Nómina Bisemanal', #vBisemanal#)>
		
		<!--- 90. Factor de Días de Nómina Semanal --->
		<cfif isdefined("form.NominaSemanal") ><cfset vSemanal = #form.NominaSemanal# ><cfelse><cfset vSemanal = 7 ></cfif>	
		<cfset datos(90, 'Factor de Días de Nómina Semanal', #vSemanal#)>
		
		<!--- 100. Socio de Negocio --->
		<cfset datos(100, 'Socio de Negocio', #form.SNcodigo#)>

		<!--- 110. Periodo Contable --->
		<cfif isdefined("form.PeriodoAsociado") >	
			<cfset datos(110, 'Periodo Cierre Contable Asociado', #form.PeriodoAsociado# )>
		</cfif>
		
		<!--- 120. Mes Contable --->
		<cfif isdefined("form.MesAsociado") >
			<cfset datos(120, 'Mes Cierre Contable Asociado', #form.MesAsociado#)>
		</cfif>
		
		<!--- 130. Crédito Silvacano--->
		<cfif isdefined("form.ACCTid") >
			<cfset datos(130, 'Crédito Silvacano', #form.ACCTid#)>
		</cfif>
			
		<!--- 140. Crédito Electrodomesticos--->
		<cfif isdefined("form.ACCTidE") >
			<cfset datos(140, 'Crédito Electrodoméstico', #form.ACCTidE#)>
		</cfif>
		<!--- 150. Período Intereses Liquidados --->
		<cfif isdefined('form.PeriodoInt')>
		<cfset datos(150, 'Per&iacute;odo Intereses Liquidados', #form.PeriodoInt#)>
		</cfif>
		<!--- 160. Mes Intereses Liquidados --->
		<cfif isdefined('form.MesInt')>
			<cfset datos(160, 'Mes Intereses Liquidados', #form.MesInt#)>
		</cfif>
	</cftransaction>		
</cfif>

<cflocation url="Parametros.cfm">
