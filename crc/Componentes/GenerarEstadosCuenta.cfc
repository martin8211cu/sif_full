
<cfoutput>
<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
	<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
<cfelse> 
	<cfset vsPath_R = "#vsPath_R#\">
</cfif>

<cfsetting requesttimeout="8000" showdebugoutput="true" enablecfoutputonly="false"/>
<cfset countEstadosCuenta = 0>
<cffunction name="obtenerEdosCuenta" hint="Ejecuta el proceso de generacion de estados de cuenta por codigo de corte.">


	<cfargument  name="codCorte"        	type="string"   required="yes">
    <cfargument  name="dsn"                 type="string"   required="yes" >
	<cfargument  name="ecodigo"             type="string"   required="yes" >
	<cfargument  name="acumulado"           type="boolean"  required="false" default="true">
	
	<cfquery name="parametroAcumulado" datasource="#arguments.dsn#">
			SELECT coalesce(Pvalor,'') Pvalor
			FROM CRCParametros
			WHERE Ecodigo = #arguments.Ecodigo#
			and Pcodigo = '30300112'
	</cfquery>
	<cfset pAcum = parametroAcumulado.Pvalor>

	<!---Query para iterar la cuentas de las cuales se obtendran los estados de cuenta --->
	<cfquery name="qCuentasCorte" datasource="#arguments.dsn#">
	 	select 
			co.Codigo Corte, 
			ct.Numero Cuenta, 
			co.Tipo tipoCorte, 
			ct.Tipo tipoCuenta,
			ct.id idCuenta,
			ct.Numero,
			ec.Descripcion, 
			ec.orden 
		from CRCCuentas ct
		inner join CRCCortes co
			on ct.Tipo = co.Tipo
		inner join CRCMovimientoCuentaCorte mcc
			on ct.id = mcc.CRCCuentasId
			and co.Codigo = mcc.Corte
		inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
		where co.Codigo = '#arguments.codCorte#'
			and mcc.MontoAPagar > 0
			and  ec.Orden < ( select id 
							from CRCEstatusCuentas
							where Orden = (select Pvalor 
											from CRCParametros 
											where Pcodigo = '30300110' and Ecodigo = #arguments.Ecodigo#)
					)
		order by Cuenta

	</cfquery>

	<cfif qCuentasCorte.recordCount neq 0>
		
			<cfset codCorte = #arguments.codCorte#>
			<!--- instancia del objeto a utilizar para invocar al garbage collector.--->
			<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime() />
			
			<!---Ruta de guardado si el tipo de corte es TM o si no lo es. EN REVISION YA QUE SOLO SE RECIBIRA EL CODIGO DEL CORTE YA NO SE NOMBRARIA EL DIRECTORIO CON EL ANIO O EL MES--->
			<cfif #Trim(qCuentasCorte.tipoCorte)# eq 'TM'>
				<cfset dir = CheckDir("#vsPath_R#DocCortes\#codCorte#")>
				<cfset dirPath="#vsPath_R#DocCortes\#codCorte#\">
				
				<cfset dirAcum = CheckDir("#vsPath_R#DocCortes\#codCorte#\Acumulados\tmp")>
				<cfset dirPathAcum="#vsPath_R#DocCortes\#codCorte#\Acumulados\tmp\">
				<cfset dirPathFin="#vsPath_R#DocCortes\#codCorte#\Acumulados">
			<cfelse>
				<cfset dir = CheckDir("#vsPath_R#DocCortes\#codCorte#")>
				<cfset dirPath="#vsPath_R#DocCortes\#codCorte#\">

				<cfset dirAcum = CheckDir("#vsPath_R#DocCortes\#codCorte#\Acumulados\tmp")>
				<cfset dirPathAcum="#vsPath_R#DocCortes\#codCorte#\Acumulados\tmp\">
				<cfset dirPathFin="#vsPath_R#DocCortes\#codCorte#\Acumulados\">
			</cfif>

			<cfset fileNameTotal="#arguments.codCorte#_E.pdf">
			<cfif FileExists("#dirPath##fileNameTotal#")> 
				<cffile action = "delete" file = "#dirPath##fileNameTotal#">
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
						ct.id idCuenta,
						ct.Numero,
						ec.Descripcion, 
						ec.orden  
					from CRCCuentas ct
					inner join CRCCortes co
						on ct.Tipo = co.Tipo
					inner join CRCTransaccion t
						on ct.id = t.CRCCuentasid
					inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
					where ec.Orden < ( select id 
							from CRCEstatusCuentas
							where Orden = (select Pvalor 
											from CRCParametros 
											where Pcodigo = '30300110' and Ecodigo = #arguments.Ecodigo#)
					)
					and co.Codigo = '#arguments.codCorte#'
					order by Cuenta
				</cfquery>

				<!---Por cada cuenta que se vea efectada por el corte mayorista se obtendra el año y los meses de las transacciones. --->
				<cfset anioMes = []>
				<cfset contador = 1>

				<cfloop query="qCuentasCorteM">
					<cfset acum = 0>
					<cfif qCuentasCorteM.orden lte pAcum>
						<cfset acum = 1>
					</cfif>
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

				 		<cfset fileName="#rsAnioMeses.Mes#_#qCuentasCorteM.Numero#">
				 		
				 		<cfset filePath="#dirPath##fileName#.pdf">

							<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
							<cfset pdf = objEstadoCuenta.createEstadoCuenta(
									CodigoSelect	= "#codCorte#"
								,	Tipo			= "#qCuentasCorteM.tipoCuenta#"
								,	CuentaId		= "#qCuentasCorteM.idCuenta#"
								,	dsn				= "#arguments.dsn#"
								,	ecodigo			= arguments.Ecodigo
								,	saveAs			= "#fileName#"
								,   acumulado       = "#acum#"
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

					<cftry>
						<cfset acum = 0>
						<cfif qCuentasCorte.orden lte pAcum>
							<cfset acum = 1>
						</cfif>
						<cfset fileName="#codCorte#_#qCuentasCorte.Numero#_E">
						<cfset fileNameTotal="#codCorte#_E.pdf">
						<cfset filePath="#dirPath##fileName#_E.pdf">
						<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
						<cfset pdf = objEstadoCuenta.createEstadoCuenta(
								CodigoSelect	= "#codCorte#"
							,	Tipo			= "#qCuentasCorte.tipoCuenta#"
							,	CuentaId		= "#qCuentasCorte.idCuenta#"
							,	dsn				= "#arguments.dsn#"
							,	ecodigo			= arguments.Ecodigo
							,	saveAs			= "#fileName#"
							,   acumulado       = "#acum#"
							
							)>
							
						<cfset countEstadosCuenta ++>
					<cfcatch type="any">
						<cflog file="GeneraRecibosPagos" application="no"
							text="Error: #cfcatch.stacktrace#">
					</cfcatch>
					</cftry>   
				</cfloop>

				<cfif arguments.acumulado>
					<cfdirectory 
						action="list" 
						directory="#dirPath#" 
						recurse="false" 
						name="_documents"
						filter="*_E.pdf"
						sort="Name"
					>
					
					

					<cfpdf action="merge" destination="#dirPath##fileNameTotal#" overwrite="yes"> 
						<cfloop query="_documents">
							<cfpdfparam source="#dirPath##_documents.Name#"> 
						</cfloop>
					</cfpdf>
					<cfset javaRT.gc() />
				</cfif>
				<cfdirectory action="list" directory="#dirPathAcum#" name="myList" />
				<cfif myList.Directory neq "">
					<cfdirectory 
						action="list" 
						directory="#dirPathAcum#" 
						recurse="false" 
						name="_documents"
						filter="*_E.pdf"
						sort="Name"
					>
					
					

					<cfpdf action="merge" destination="#dirPathFin#Acumulados_#fileNameTotal#" overwrite="yes"> 
						<cfloop query="_documents">
							<cfpdfparam source="#dirPathAcum##_documents.Name#"> 
						</cfloop>
					</cfpdf>	
				</cfif>
				<cfdirectory action="delete" recurse= "yes" directory="#dirPathAcum#" />

				<cfset result =countEstadosCuenta>
				<!---Limpieza de memoria --->	
				<cfset javaRT.gc() />

			</cfif>
			
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


 
