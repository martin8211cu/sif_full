<cfcomponent hint="Componente donde se colocan las invocaciones a web services">

	<cffunction name="Get_DepositoGarantia" access="public" returntype="struct">
		<cfargument name="PQcodigo" type="string" required="yes">
		<cfargument name="Contratoid" type="numeric" required="no" hint="Contrato cuya garantía calcularemos">
		<cfargument name="Pquien" type="numeric" required="no">
		<cfargument name="Pid" type="string" required="no">
		<cfargument name="LGlogin" type="string" required="no">
		<!--- obtiene de H029 y regresa un struct con (monto,moneda,tipoCambio) --->
		<cfset var LvarResult = StructNew()>
		<cfset LvarResult.monto = -1>
		<cfset LvarResult.moneda = ''>
		<cfset LvarResult.tipoCambio = 1>
		<cfset LvarResult.permitecargofijo = 'N'>
		<cftry>
			<cfquery datasource="#session.dsn#" name="deposito_paquete_Q">
				select CINCAT
				from ISBpaquete
				where PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PQcodigo#">
			</cfquery>
			<cfif IsDefined('Arguments.Pid') And IsDefined('Arguments.LGlogin')>
				<!--- ok, siga --->
			<cfelseif IsDefined('Arguments.Pquien') And IsDefined('Arguments.LGlogin')>
				<!--- busque la cédula --->
				<cfquery datasource="#session.dsn#" name="deposito_ced_Q">
					select Pid
					from ISBpersona
					where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
				</cfquery>
				<cfset Arguments.Pid = deposito_ced_Q.Pid>
			<cfelseif IsDefined('Arguments.Contratoid')>
				<cfquery datasource="#session.dsn#" name="deposito_login_Q">
					select b.LGlogin, p.Pid, b.LGprincipal
					from ISBproducto a
						join ISBlogin b
							on b.Contratoid = a.Contratoid
						join ISBcuenta c
							on c.CTid = a.CTid
						join ISBpersona p
							on p.Pquien = c.Pquien
					where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
					order by b.LGnumero<!--- Obtener primero el primer login --->
				</cfquery>

				<cfif isdefined('deposito_login_Q')>
					<cfquery name="deposito_login_Princ" dbtype="query">
						Select  LGlogin, Pid
						from deposito_login_Q
						where LGprincipal = 1
					</cfquery>
					
					<cfif isdefined('deposito_login_Princ') and deposito_login_Princ.recordCount GT 0>
						<cfset Arguments.LGlogin = deposito_login_Princ.LGlogin>
						<cfset Arguments.Pid = deposito_login_Princ.Pid>					
					<cfelse>
						<cfthrow message="No existe el login principal para el contrato seleccionado.">
					</cfif>				
				</cfif>	
			<cfelse>
				<cfthrow message="Debe invocarse  con PQcodigo,Contratoid o PQcodigo,Pquien,LGlogin">
			</cfif>

			<cfinvoke component="saci.ws.intf.H029_garantia" method="buscaDeposito" 
				returnvariable="LvarResult"
				SERCLA="#Arguments.LGlogin#"
				CLTCED="#Arguments.Pid#"
				CINCAT="#deposito_paquete_Q.CINCAT#" />
		<cfcatch type="any">
			<cfset LvarResult.monto = -2>
		</cfcatch>
		
		</cftry>
		<cfreturn LvarResult>
	</cffunction>
	
	
	<cffunction name="Get_Sobres" access="public" returntype="boolean">
		<cfargument name="param" type="string" required="No">
	</cffunction>

</cfcomponent>
