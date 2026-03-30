<cfif isdefined("form.periodo") and isdefined("form.mes") and isdefined("form.periodoAux") and isdefined("form.mesAux") and isdefined("form.mesFiscal")
  and len(trim(form.periodo)) gt 0 and len(trim(form.mes)) gt 0 and len(trim(form.periodoAux)) gt 0 and len(trim(form.mesAux)) gt 0 and len(trim(form.mesFiscal)) gt 0>
  	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertDato" access="private" output="true">
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="mcodigo" type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">

		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 
			from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pcodigo#">
		</cfquery>
		
		<cfif rsExiste.recordCount gt 0>
			<cfquery name="update" datasource="#session.DSN#">
				update Parametros set Pvalor = '#Trim(Arguments.pvalor)#'
				where Ecodigo = #Session.Ecodigo#
				  and Pcodigo = #Arguments.pcodigo#

			</cfquery>
		<cfelse>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pcodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> )
			</cfquery>
		</cfif>
	</cffunction>

	<cftransaction>
		<!--- Borra datos que puede generar errores. Estos datos se insertan a partir de insert/select (masivos)
			  Por ser asi y para no cambiar la programacion (tendria darse cuenta que registros existen y cuales no),
			  se borran las tablas donde se hacen los inserts masivos. Este borrado solo funciona para empresas sin 
			  configurar.
		--->
		<cfquery name="delete1" datasource="#session.DSN#">
			delete from ConceptoContable where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="delete2" datasource="#session.DSN#">
			delete from Impuestos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="delete3" datasource="#session.DSN#">
			delete from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="delete4" datasource="#session.DSN#">
			delete from CtasMayor where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	
		<!--- Parámetros Capturados--->
		<cfset insertDato(30,'CG','Periodo Contable',Form.periodo) >
		<cfset insertDato(40,'CG','Mes Contable',Form.mes) >
		<cfset insertDato(50,'GN','Periodo Auxiliares',Form.periodoAux) >
		<cfset insertDato(60,'GN','Mes Auxiliares',Form.mesAux) >
		<cfset insertDato(45,'CG','Primer Mes Fiscal Contable',Form.mesFiscal)>
		
		<cfif form.WTCid neq 0 >
			<!--- X Generacion de Cuentas --->
			<cfinclude template="wizGeneral02-sql.cfm">
		
			<!--- X Asociacion de Cuentas de Operacion--->
			<cfinclude template="cuentasOperacion-sql.cfm">
		</cfif>
	
		<!--- Parámetros Generados--->
		<cfinclude template="configuracion-sql.cfm">
	
		<!--- marca la empresa como ya configurada --->
		<cfquery name="rsConfigurado" datasource="#session.DSN#">
			select 1
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 5
		</cfquery>
		<cfif rsConfigurado.RecordCount gt 0>
			<cfquery name="rsConfig" datasource="#session.DSN#">
				update Parametros
				set Pvalor = 'S'
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 5
			</cfquery>
		<cfelse>
			<cfquery  name="rsConfig" datasource="#session.DSN#">
				insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor )
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="5">,
						<cfqueryparam cfsqltype="cf_sql_char" value="GN">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Parametrización ya definida">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="S"> )
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>

<cflocation url="/cfmx/sif/indexSif.cfm">


