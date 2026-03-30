<!---
	Componente de Contabilidad General.
	Contiene las siguientes funciones:
		1. Nuevo_Asiento
		3. Cierre_Mes
--->
<cfcomponent displayname="Contabilidad" hint="Funciones Módulo de Contabilidad General">
	<!---
		1. Función Nuevo Asiento
	--->
	<cffunction output="false" name="Nuevo_Asiento" access="public" returntype="numeric" hint="Retorna Edocumento">
		<cfargument name="Ecodigo" type="numeric" required="no">
		<cfargument name="Conexion" type="string" required="no">
		
		<cfargument name="Cconcepto" type="string" required="no" default="-1">
		<cfargument name="Oorigen" type="string" required="yes">
		<cfargument name="Eperiodo" type="numeric" required="yes">
		<cfargument name="Emes" type="numeric" required="yes">
		
		<cfargument name="Ocodigo" type="string" required="no" default="">	<!--- Mandar un -1 para que no sea tomado en cuenta --->
		<cfargument name="Usucodigo" type="string" required="no" default="">	<!--- Mandar un -1 para que no sea tomado en cuenta --->
		<cfargument name="Efecha" type="date" required="no">
	
		<cfif len(trim(Arguments.Cconcepto)) eq 0 >
			<cfset Arguments.Cconcepto = -1 >		
		</cfif>
		
		<cfif not isdefined("arguments.ecodigo")>
		 	<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>

		<cfif not isdefined("arguments.conexion")>
		 	<cfset arguments.conexion = session.dsn>
		</cfif>

		<!---1--->
		<cfif Arguments.Cconcepto EQ -1 >
			<cfquery name="rsNA1" datasource="#Arguments.Conexion#">
				select Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
			</cfquery>
			<cfif rsNA1.RecordCount>
				<cfset Arguments.Cconcepto = rsNA1.Cconcepto>
			</cfif>
		</cfif>

		<!--- Obtención del agrupamiento según el Concepto Contable por Auxiliar --->
		<cfset Agrupamiento = 0>
		<cfquery name="rsAgrupamiento" datasource="#Arguments.Conexion#">
			select Resumir
			from ConceptoContable
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
			and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
		</cfquery>
		<cfif rsAgrupamiento.recordCount>
			<cfset Agrupamiento = rsAgrupamiento.Resumir>
		</cfif>

		<!--- Filtros para la obtención del tipo de numeración para el Concepto Contable --->
		<cfset NumeracionConcepto = 0>
		<cfquery name="rsNumeracion" datasource="#Arguments.Conexion#">
			select Ctiponumeracion as NumeracionConcepto
			from ConceptoContableE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
		</cfquery>
		<cfif rsNumeracion.recordCount>
			<cfset NumeracionConcepto = rsNumeracion.NumeracionConcepto>
		</cfif>

		<cfset LvEcodigo = Arguments.Ecodigo>
		<cfset LvCconcepto = Arguments.Cconcepto>
		<cfset LvEperiodo = Arguments.Eperiodo>
		<cfset LvEmes = Arguments.Emes>		

		<cfset ExisteEnEcontables = -1>
		<cfif Agrupamiento gt 0>
			<cfquery name="rsEContables" datasource="#Arguments.Conexion#">
				select min(IDcontable) as IDcontable 
				from EContables ed
				where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				  and ed.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				  and ed.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				  and ed.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				  and ed.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
				  and ed.ECestado = 0 
				<cfif (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
					<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and Arguments.Ocodigo GE 0>
						and ed.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
					<cfelse>
						and ed.Ocodigo = -1
					</cfif>
				</cfif>
				<cfif (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
					<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha)>
						and <cf_dbfunction name="to_datechar" args="ed.Efecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Efecha#">
					<cfelse>
						and <cf_dbfunction name="to_datechar" args="ed.Efecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(1900,1,1)#">
					</cfif>
				</cfif>
				<cfif (Agrupamiento EQ 3 OR Agrupamiento EQ 6)>
					<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo)>
						and ed.ECusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					<cfelse>
						and ed.ECusucodigo = -1
					</cfif>
				</cfif>
			</cfquery>
			
			<cfif rsEContables.recordCount GT 0>
				<cfif rsEContables.IDcontable GT 0>
					<cfset ExisteEnEcontables = rsEContables.IDcontable>
				</cfif>
			</cfif>
		</cfif>

		<!--- Si es necesario generar un nuevo documento, No se puede resumir si no viene alguno de los campos --->
		<cfif Agrupamiento EQ 0 OR ExisteEnEcontables LT 1>
		
			<cfif NumeracionConcepto EQ 3>
				<!--- Por Empresa --->
				<cfset LvCconcepto = 0>
				<cfset LvEperiodo = 0>
				<cfset LvEmes = 0>
			</cfif> 
			<cfif NumeracionConcepto EQ 2>
				<!--- Por Empresa / Concepto --->
				<cfset LvEperiodo = 0>
				<cfset LvEmes = 0>
			</cfif> 
			<cfif NumeracionConcepto EQ 1>
				<!--- Por Empresa / Concepto / Periodo --->
				<cfset LvEmes = 0>
			</cfif> 
	
			<!---2--->
			<cfif LvCconcepto EQ -1 >
				<cfthrow message="No se ha definido el Concepto Contable para el Origen #Arguments.Oorigen#">
			</cfif>		
		
			<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
				select count(1) as cuenta
				from ConceptoContableN
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
			</cfquery>
			<cfif rsNA2.cuenta gt 0>
				<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
					update ConceptoContableN
					set Edocumento = Edocumento + 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
					and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
					and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
					and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				</cfquery>
			<cfelse>
				  <cftry>
						<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
							insert into ConceptoContableN (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento)
							values(<cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
							, 1)
						</cfquery>
					<cfcatch>
						<cf_errorCode	code = "51119" msg = "No se pudo insertar el Concepto Contable! (Tabla: ConceptoContableN) Proceso Cancelado!">
					</cfcatch>
				</cftry>
			</cfif>

			<cfquery name="rsNA3" datasource="#Arguments.Conexion#">
				select Edocumento
				from ConceptoContableN
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
			</cfquery>
			
		<!--- Si NO es necesario generar un nuevo documento, se busca el que ya existe y se devuelve ese --->
		<cfelse>
			<cfquery name="rsNA3" datasource="#Arguments.Conexion#">
				select min(ed.Edocumento) as Edocumento
				from EContables ed
				where ed.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ExisteEnEcontables#">
				  and ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				  and ed.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				  and ed.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				  and ed.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				  and ed.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
				  and ed.ECestado = 0 
			</cfquery>
			
			<cfquery name="rsNA4" datasource="#Arguments.Conexion#">
					<!--- Cambio para modificar la descripcion del asiento contable que se va a agrupar --->
					update EContables
					set Edescripcion = 
							<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							{fn concat(
							</cfif>
							<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							{fn concat(
							{fn concat(
							</cfif>
							<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
								{fn concat(
							</cfif>

							{fn concat(coalesce(( select Odescripcion from Origenes where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#"> ) , ' ') ,':')}
																	
							<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
								, rtrim(
									coalesce(( select Usulogin from Usuario where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#"> ) , ' ')
									) )}  
							</cfif>
							<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							, ' Oficina: ' )}
							, rtrim(
								coalesce(( select Oficodigo from Oficinas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#"> and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#"> ) , ' ')
								))}
							</cfif>
							<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
								, ' Fecha: #LSDateFormat(Arguments.Efecha, "DD/MM/YYYY")#')}
							</cfif>
						where EContables.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ExisteEnEcontables#">
						  and EContables.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
						  and EContables.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
						  and EContables.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
						  and EContables.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
						  and EContables.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
						  and EContables.ECestado = 0 
					  	  and EContables.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNA3.Edocumento#">
			</cfquery>
		</cfif>
		<cfreturn rsNA3.Edocumento>
	</cffunction>

	<cffunction output="true" name="Cierre_Mes" access="public" hint="Retorna Nulo">
		<cfargument name="Ecodigo" type="numeric" required="no">
		<cfargument name="Conexion" type="string" required="no">
	
		<cfif isdefined("session.Ecodigo") and not isdefined("arguments.ecodigo")>
		 	<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined("session.dsn") and not isdefined("arguments.conexion")>
		 	<cfset arguments.conexion = session.dsn>
		</cfif>

		<cfinvoke component = "CG_CierreMes"
				  method    = "Cierre_Mes"
				  Ecodigo	= "#Arguments.Ecodigo#"
				  Conexion 	= "#Arguments.Conexion#"
		/>
	</cffunction>
</cfcomponent>



