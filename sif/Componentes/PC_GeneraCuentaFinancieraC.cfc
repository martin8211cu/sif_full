<!---
NOTA IMPORTANTE:  OJO:
	Este componente debe invocarse dentro de un <cftransaction>
--->

<cfcomponent>
	<cffunction name='GeneraCuentaFinanciera' access='public' output='false'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='Cmayor' type="string" required='true'>		
		<cfargument name='Cformato' type='string' required='true'>
		<cfargument name='debug' type='string' required='false' default='N'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='usarTransaccion' type="boolean" required="no" default="true">

		<cfquery name="rs_Cuenta" datasource="#arguments.conexion#">
			select Ccuenta, Cpadre, Cmayor
			  from CContables
			 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
			   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Cmayor#">
			   and Cformato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Cformato#">
		</cfquery>

		<cfif rs_Cuenta.recordCount EQ 0>
			<cfreturn>
		</cfif>
		
		<cfset nivel = -1>
		<cfset LvarCtasNiveles = rs_Cuenta.Ccuenta>
		<cfset Cpadre = rs_Cuenta.Ccuenta>			 
				
		 <!--- Buscar la cantidad de niveles que tiene la cuenta  --->
		<cfloop condition = "Cpadre NEQ ''">
			<cfquery name="rs_cantNiveles" datasource="#arguments.conexion#">
				select Cpadre
				  from CContables
				 where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Cpadre#">
			</cfquery>
			
			<cfif rs_cantNiveles.recordCount GT 0>
				<cfset nivel = nivel + 1>
				<cfset Cpadre = rs_cantNiveles.Cpadre>
				<cfset LvarCtasNiveles = LvarCtasNiveles & "," & Cpadre>
			<cfelse>
				<cfset Cpadre = "">
			</cfif>
		</cfloop>

		<cfset LvarGuiones = len(Cformato)-len(replace(Cformato,"-","","ALL"))>
		<cfif Nivel LT LvarGuiones>
			<cf_errorCode	code = "51249"
							msg  = "ERROR DE FORMATO: se enviaron @errorDat_1@ niveles a generar pero sólo fueron registrados @errorDat_2@ padres de la cuenta Contable"
							errorDat_1="#LvarGuiones#"
							errorDat_2="#Nivel#"
			>
		</cfif>

		<!--- Borra el Cubo Contable solo si no acepta movimientos --->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select Cmovimiento
			  from CContables 
			 where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_Cuenta.Ccuenta#">
		</cfquery>
		<cfif rsSQL.Cmovimiento EQ "N">
			<cfquery datasource="#arguments.conexion#">
				delete from PCDCatalogoCuenta
				 where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_Cuenta.Ccuenta#">
			</cfquery>
		</cfif>
				
		<!--- Genera el cubo por niveles --->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from PCDCatalogoCuenta
			where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_Cuenta.Ccuenta#">
		</cfquery>
		<cfif rsSQL.Cantidad EQ 0>
			<cfset LvarCtasNiv = LvarCtasNiveles>
			<cfloop list="#LvarCtasNiv#" index="LvarCtaNiv">
				<cfif LvarCtaNiv NEQ rs_Cuenta.Ccuenta>
					<cfquery datasource="#arguments.conexion#">
						update CContables
						   set Cmovimiento = 'N'
						 where Ccuenta = #LvarCtaNiv#
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.conexion#">
					insert INTO PCDCatalogoCuenta (Ccuenta, Ccuentaniv, PCDCniv)
					values(
						  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_Cuenta.Ccuenta#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCtaNiv#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">						
					)
				</cfquery>
				<cfset nivel = nivel - 1>				
			</cfloop>
		</cfif>




		<!--- CUBO FINANCIERO --->
		<cfquery name="A_CPVigencia" datasource="#Session.DSN#">
			Select CPVid, PCEMid
			from CPVigencia
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#rs_Cuenta.Cmayor#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between 
			  		CPVdesde and coalesce(CPVhasta,<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100,1,1)#">)
		</cfquery>
		<cfif A_CPVigencia.CPVid EQ "">
			<cf_errorCode	code = "51250" msg = "No se encontró Vigencia para generar la Cubo Financiero">
		<cfelseif A_CPVigencia.PCEMid NEQ "">
			<cf_errorCode	code = "51251" msg = "La Cuenta Contable debe generarse a través de GeneraCuentaFinanciera">
		</cfif>

		<!--- DETERMINA SI HAY QUE GENERAR TODO EL CUBO PARA LA CUENTA MAYOR --->
		<cfset LvarReconstruir = false>
		<cfset LvarCtasNiv = LvarCtasNiveles>
		<cfloop list="#LvarCtasNiv#" index="LvarCtaNiv">
			<cfquery name="rs_CuentaF" datasource="#arguments.conexion#">
				select CFcuenta, CFformato, CFpadre, Ccuenta, CFmovimiento
				  from CFinanciera
				 where Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCtaNiv#">
				   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
			</cfquery>
			<cfquery name="rs_CuentaC" datasource="#arguments.conexion#">
				select Ccuenta, Cformato, (select CFcuenta from CFinanciera where Ccuenta = CContables.Cpadre) as CFpadre, Cmovimiento
				  from CContables
				 where Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCtaNiv#">
			</cfquery>
			<cfif rs_CuentaF.Ccuenta EQ "" or rs_CuentaF.CFformato NEQ rs_CuentaC.Cformato 
					OR rs_CuentaF.CFpadre NEQ rs_CuentaC.CFpadre OR rs_CuentaF.CFmovimiento NEQ rs_CuentaC.Cmovimiento>
				<cfset LvarReconstruir = true>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif LvarReconstruir>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select Cformato, count(1) as cantidad
				  from CContables
				 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and Cmayor =<cfqueryparam cfsqltype="cf_sql_char" 	value="#rs_Cuenta.Cmayor#">
				 group by Cformato
				having count(1) > 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cf_errorCode	code = "51252"
								msg  = "Las siguientes Cuentas Contables estan repetidas: @errorDat_1@"
								errorDat_1="#ValueList(rsSQL.Cformato)#"
				>
			</cfif>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select CFformato, count(1) as cantidad
				  from CFinanciera 
				 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and Cmayor =<cfqueryparam cfsqltype="cf_sql_char" 	value="#rs_Cuenta.Cmayor#">
				 group by CFformato
				having count(1) > 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cf_errorCode	code = "51253"
								msg  = "Las siguientes Cuentas Financieras estan repetidas: @errorDat_1@"
								errorDat_1="#ValueList(rsSQL.CFformato)#"
				>
			</cfif>

			<!--- Incluye todas las Cuentas Financieras de la Cuenta de Mayor si no existen --->
			<cfquery datasource="#Session.DSN#">
				insert INTO CFinanciera(CPVid,Ccuenta,Ecodigo,Cmayor,CFformato,CFdescripcion,CFmovimiento,CFpadre)
				select #A_CPVigencia.CPVid#, Ccuenta, Ecodigo, Cmayor, Cformato, Cdescripcion, Cmovimiento, NULL
				  from CContables c
				 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and Cmayor =<cfqueryparam cfsqltype="cf_sql_char" 	value="#rs_Cuenta.Cmayor#">
				   and 
				   	(
						select count(1)
						  from CFinanciera f
						where f.Ecodigo		= c.Ecodigo
						  and f.CFformato	= c.Cformato
						  and f.CPVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
						  and f.Cmayor		= c.Cmayor
					) = 0
			</cfquery>					
			<cfquery datasource="#Session.DSN#">
				update CFinanciera
				   set Ccuenta =
					(
						select c.Ccuenta
						  from CContables c
						 where c.Ecodigo	= CFinanciera.Ecodigo
						   and c.Cmayor		= CFinanciera.Cmayor
						   and c.Cformato	= CFinanciera.CFformato
					)
				 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
				   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#rs_Cuenta.Cmayor#">
				   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#A_CPVigencia.CPVid#">
			</cfquery>					
			<cfquery datasource="#Session.DSN#">
				update CFinanciera
				   set CFpadre =
				   	case
						when Cmayor = CFformato then NULL
						else
							(
								select f.CFcuenta
								  from CContables c
									inner join CFinanciera f
										on f.Ccuenta = c.Cpadre
								where c.Ccuenta = CFinanciera.Ccuenta
							)
					end
					, CFmovimiento = (select c.Cmovimiento from CContables c where c.Ccuenta = CFinanciera.Ccuenta)
				 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
				   and Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#rs_Cuenta.Cmayor#">
				   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#A_CPVigencia.CPVid#">
			</cfquery>					
		<cfelse>
			<cfquery name="rs_CFcuenta" datasource="#arguments.conexion#">
				select Ecodigo, CFcuenta, Cmayor
				  from CFinanciera
				 where Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_Cuenta.Ccuenta#">
				   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
			</cfquery>
		</cfif>

		<!--- Borra el Cubo Financiero --->
		<cfquery datasource="#arguments.conexion#">
			delete from PCDCatalogoCuentaF
			<cfif LvarReconstruir>
			 where (select count(1)
			          from CFinanciera c
					 where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
			   		   and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" 		value="#rs_Cuenta.Cmayor#">
			   		   and c.CFcuenta = PCDCatalogoCuentaF.CFcuenta) > 0
			<cfelse>
			 where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_CFcuenta.CFcuenta#">
			</cfif>
		</cfquery>
				
		<!--- Genera el cubo financiero con base en el cubo contable --->
		<cfquery datasource="#arguments.conexion#">
			insert INTO PCDCatalogoCuentaF (CFcuenta, CFcuentaniv, PCDCniv)
			select 
				(
					select CFcuenta
					  from CFinanciera
					 where Ccuenta	= cb.Ccuenta
					   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
				),
				(
					select CFcuenta
					  from CFinanciera
					 where Ccuenta	= cb.Ccuentaniv
					   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
				),
				PCDCniv
			  from PCDCatalogoCuenta cb
			<cfif LvarReconstruir>
			 where (select count(1)
			 		from CContables c
					where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
			   		and c.Cmayor  = <cfqueryparam cfsqltype="cf_sql_char" 		value="#rs_Cuenta.Cmayor#">
					and c.Ccuenta = cb.Ccuenta) > 0
			<cfelse>
			 where cb.Ccuenta = #rs_Cuenta.Ccuenta#
			</cfif>
		</cfquery>
	</cffunction>
</cfcomponent>

