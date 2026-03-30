
<cfoutput>
<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#\">
</cfif>


<cffunction name="obtenerEdosCuenta" hint="Ejecuta el proceso de generacion de estados de cuenta por codigo de corte.">

	<cfargument  name="codCorte"        	type="string"   required="yes">
    <cfargument  name="dsn"                 type="string"   required="no"   default="#session.dsn#">
    <cfargument  name="ecodigo"             type="string"   required="no"   default="#session.ecodigo#">

	<!---Query para iterar la cuentas de las cuales se obtendran los estados de cuenta --->
	<cfquery name="qCuentasCorte" datasource="#arguments.dsn#">
	 	select 
			co.Codigo Corte, 
			ct.Numero Cuenta, 
			co.Tipo tipoCorte, 
			ct.Tipo tipoCuenta,
			ct.id idCuenta 
		from CRCCuentas ct
			inner join CRCCortes co
				on ct.Tipo = co.Tipo
		where co.Codigo = '#arguments.codCorte#'
		order by Cuenta

	</cfquery>


	<cfif qCuentasCorte.recordCount neq 0>
		<cftry>
			<cfset codCorte = #arguments.codCorte#>
			<!--- instancia del objeto a utilizar para invocar al garbage collector.--->
			<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime() />
			
			<!---Ruta de guardado si el tipo de corte es TM o si no lo es. EN REVISION YA QUE SOLO SE RECIBIRA EL CODIGO DEL CORTE YA NO SE NOMBRARIA EL DIRECTORIO CON EL ANIO O EL MES--->
			<cfif #Trim(qCuentasCorte.tipoCorte)# eq 'TM'>
				<cfset dir = CheckDir("#vsPath_R#DocCortes\#codCorte#")>
				<cfset dirPath="#vsPath_R#DocCortes\#codCorte#\">
			<cfelse>
				<cfset dir = CheckDir("#vsPath_R#DocCortes\#codCorte#")>
				<cfset dirPath="#vsPath_R#DocCortes\#codCorte#\">
			</cfif>


			<!---Si el tipo de corte es TM se formara el codigo con el anio seleccionado y el numero del mes --->
			<cfif #Trim(qCuentasCorte.tipoCorte)# eq 'TM'>

				<!--- Query para obtener las cuentas afectadas por el corte de tipo TM y que tienen transacciones realizadas.--->
				<cfquery name="qCuentasCorteM" datasource="#arguments.dsn#" >
				 	select distinct
						co.Codigo Corte, 
						ct.Numero Cuenta, 
						co.Tipo tipoCorte, 
						ct.Tipo tipoCuenta,
						ct.id idCuenta 
					from CRCCuentas ct
						inner join CRCCortes co
							on ct.Tipo = co.Tipo
						inner join CRCTransaccion t
							on ct.id = t.CRCCuentasid
					where co.Codigo = '#arguments.codCorte#'
					order by Cuenta
				</cfquery>

				<!---Por cada cuenta que se vea efectada por el corte mayorista se obtendra el año y los meses de las transacciones. --->
				<cfset anioMes = []>
				<cfset contador = 1>
				<cfloop query="qCuentasCorteM">

					<cfquery name="rsAnioMeses" datasource="#arguments.dsn#">
						select distinct year(Fecha) Anio,
										month(Fecha) Mes
						from CRCTransaccion
							where CRCCuentasid = #qCuentasCorteM.idCuenta#
						order by year(Fecha) desc
					</cfquery>
					<!--- Se iteran los resultados de año y mes para gusradarlos en un arreglo --->
					<cfloop query="rsAnioMeses">

						<cfset anioMes[#contador#] = [#rsAnioMeses.Anio#, #rsAnioMeses.Mes#]>
						<cfset codCorte = "#rsAnioMeses.Anio#,#rsAnioMeses.Mes#">

				 		<cfset fileName="#rsAnioMeses.Mes#_#qCuentasCorteM.idCuenta#">
				 		
				 		<cfset filePath="#dirPath##fileName#.pdf">

							<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
							<cfset pdf = objEstadoCuenta.createEstadoCuenta(
									CodigoSelect	= "#codCorte#"
								,	Tipo			= "#qCuentasCorteM.tipoCuenta#"
								,	CuentaId		= "#qCuentasCorteM.idCuenta#"
								,	dsn				= "minisif"
								,	ecodigo			= 2
								,	saveAs			= "#fileName#"
								
								)>
							

						<cfset contador ++>
					</cfloop>
				</cfloop>
				<cfset result ="Operacion exitosa">
				<!---Limpieza de memoria --->
				<cfset javaRT.gc() />
			<cfelse>
				
				<!---Se iteran las cuentas obtenidas en el query --->
			 	<cfloop query="qCuentasCorte">

			 		<cfset fileName="#codCorte#_#qCuentasCorte.idCuenta#">
			 		<cfset filePath="#dirPath##fileName#.pdf">
						<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
						<cfset pdf = objEstadoCuenta.createEstadoCuenta(
								CodigoSelect	= "#codCorte#"
							,	Tipo			= "#qCuentasCorte.tipoCuenta#"
							,	CuentaId		= "#qCuentasCorte.idCuenta#"
							,	dsn				= "minisif"
							,	ecodigo			= 2
							,	saveAs			= "#fileName#"
							
							)>
					
				</cfloop>
				<cfset result ="Operacion exitosa">
				<!---Limpieza de memoria --->	
				<cfset javaRT.gc() />

			</cfif>
			<cfcatch>
                <cfthrow Message="#cfcatch.Message#">
            </cfcatch>
            </cftry>	
	<cfelse>
		<cfset result = "No se encontraron cuentas asociadas">
	</cfif>
	<cfreturn result>
</cffunction>

<cffunction  name="checkDir">
	<cfargument  name="path" required="true">
	<cfif !DirectoryExists("#arguments.path#") >
		<cfset DirectoryCreate("#arguments.path#")>
	</cfif>
</cffunction>
</cfoutput>


 
