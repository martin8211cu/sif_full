<!---
	Recibe datos relacionados con el tipo de cambio y lo actualiza en la base de datos:
	Verifica la existencia del tipo de cambio enviado, si no existe lo crea, de existir lo actualiza, 
	debe tomar en cuenta que la fecha que se pasa es de inicio de vigencia del tipo de cambio y realizar
	las actualizaciones necesarias segn la lgica del programa que da mantenimiento al tipo de cambio.
--->

<cfcomponent>
	<cffunction name="ActualizaTiposCambio" access="public" returntype="string" displayname="TipoCambio" hint="Funcion para incluir una Factura Directa">
		<!---Se recibe el XML que ser evaluado--->
		<cfargument name="xmlString" type="string" required="yes" hint="XML con todos los datos">	
		
		<!---Se realiza un parse de los datos--->
		<cfset archivo_xml		= replace (#Arguments.xmlString#, chr(13), "", "All") >
		<cfset datosXMLDOM 		= XMLParse(#archivo_xml#)>
		<cfset datos 			= datosXMLDOM.XMLROOT>
		<!---Cantidad de datos ingresados--->
		<cfset numDATOS = Arraylen(datos.XMLChildren)>
		
		<!---Evaluador de que ningun dato este en blanco--->
		<cfloop from="1" to="#numDATOS#" index="i">
			<cfset DATOS = datos.XmlChildren[i]>
			<cfset datosEnBlanco = existeDatosVacios(	"#DATOS.Empresa.XmlText#", 
														"#DATOS.Moneda.XmlText#", 
														"#DATOS.Fecha.XmlText#", 
														"#DATOS.Compra.XmlText#", 
														"#DATOS.Venta.XmlText#", 
														"#DATOS.Promedio.XmlText#")>
			
			<!---En caso de tener datos en blanco--->
			<cfif datosEnBlanco EQ "SI">
				<cfthrow message="SE ENVIARON CAMPOS EN BLANCO">
			 <cfelse>
			<!---Si todos los datos tienen valores se procesa la actualizacin o insercin--->
				<cfset myResult = procesarActualizacion(DATOS)>
				<cfthrow message="#myResult#">
			</cfif>
		</cfloop>
		<cfreturn "#myResult#">
	</cffunction>
	
	<!----Funcin que realiza la verificacin de que todos los datos que se recibieron tengan valores--->
	<cffunction name="existeDatosVacios" access="public" returntype="string" hint="Verifica que los datos ingresados no esten en Blanco">
		
		<!---Campos requeridos para la actualizacin del Tipo de Cambio--->
		<cfargument name="Empresa"	 type="string" required="Yes" hint="Campo Empresa Requerido">
        <cfargument name="Moneda"    type="string" required="Yes" hint="Campo Moneda Requerido">
		<cfargument name="Fecha" 	 type="string" required="Yes" hint="Campo Fecha Requerido">
		<cfargument name="Compra" 	 type="string" required="Yes" hint="Campo Compra Requerido">
        <cfargument name="Venta"     type="string" required="Yes" hint="Campo Venta Requerido">
		<cfargument name="Promedio"  type="string" required="Yes" hint="Campo Promedio Requerido">
		
		<!---Validacin de campos en Blanco--->
		<cfif #Arguments.Empresa# 	neq "" and 
			  #Arguments.Moneda# 	neq "" and 
			  #Arguments.Fecha# 	neq "" and 
			  #Arguments.Compra# 	neq "" and
			  #Arguments.Venta# 	neq "" and
			  #Arguments.Promedio# 	neq "">
			
			<!---Funcion que verifica que la moneda exista--->				
			<cfquery name="rsMoneda" datasource="#session.dsn#">
				SELECT count(1) as Total
				FROM Monedas 
				WHERE Ecodigo = #Arguments.Empresa# 
					AND Miso4217 = '#Arguments.Moneda#'
			</cfquery>	
				<!---Si no existe en la BD mensaje--->
				<cfif rsMoneda.Total eq 0>
					<cfthrow message="El tipo de moneda ingresada no se esta en la base de datos.">
					<cfset result = "SI">
				<cfelse>
					<cfif #Arguments.Compra# eq 0>  
						<cfthrow message="ERROR: EL tipo de Cambio para Compra es 0">
						<cfset result = "SI">
					<cfelse>
						<cfif #Arguments.Venta# eq 0>
							<cfthrow message="ERROR: EL tipo de Cambio para Venta es 0">
							<cfset result = "SI">
						<cfelse>
							<cfset result = "NO">
						</cfif>
					</cfif>
				</cfif>
		<cfelse>
			<cfset result = "SI">
		</cfif>
		<cfreturn "#result#"/>
	</cffunction>
	
	<!---Funcion para Actualizar o insertar el Tipo de Cambio recibido--->	
	<cffunction name="procesarActualizacion" access="public" returnType="string" hint="Funcin que se encarga de realizar la insercin o actualizacin del TC">
		<cfargument name="datos" type="xml" required="Yes" hint="Datos de Tipo de Cambio">
		<cfset result = "">
		<cftransaction>
		
			<!---Verficador de la fecha para realizar la actualizacin o isercin del nuevo valor--->
			<cfquery name="rsMoneda" datasource="#Session.dsn#">
				SELECT Mcodigo 
				FROM Monedas
				WHERE Miso4217 = <cfqueryparam value="#datos.Moneda.XmlText#" cfsqltype="cf_sql_char">
				AND Ecodigo = <cfqueryparam value="#datos.Empresa.XmlText#" cfsqltype="cf_sql_numeric">		
			</cfquery>
			
			<cfif rsMoneda.recordcount eq 0>
				<cfthrow message="El tipo de moneda ingresada no se esta en la base de datos.">
			</cfif>
			
			<cfset LvarMcodigo = rsMoneda.Mcodigo>
			<cfset LvarInserta = 0>
            
            <cfset LvarFecha = #datos.fecha.XmlText#>
            <!---Validador de la fecha--->
            <cftry>
            	<!--- 1234-67-90 --->
            	<cfset DtCorrecta = CreateDate( mid(LvarFecha,1,4), mid(LvarFecha,6,2), mid(LvarFecha,9,2) )>
                <cfif mid(LvarFecha,5,1) NEQ "-" OR mid(LvarFecha,8,1) NEQ "-">
                	<cfthrow>
                </cfif>
            <cfcatch type="any">
            	<cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
            </cfcatch>
            </cftry>
					
            <cfquery name="rsRegistroFecha" datasource="#Session.dsn#">
				SELECT 1
				FROM Htipocambio
				WHERE Ecodigo = <cfqueryparam value="#datos.Empresa.XmlText# " cfsqltype="cf_sql_numeric"> 
					AND Mcodigo = <cfqueryparam value="#LvarMcodigo# " cfsqltype="cf_sql_numeric"> 
					AND Hfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DtCorrecta#">
			</cfquery>
		
			<!---Si se encuentra una fecha que coincida no se puede tramitar la transaccion--->	
				<cfif rsRegistroFecha.RecordCount GT 0>
					<cfset result = "ERROR: La fecha de tipo de cambio ya existe!">
				<cfelse>
					<cfset LvarFechaEncontrada = createdate(6100,1,1)>
						<cfquery name="rsRegistroActual" datasource="#Session.dsn#">
							SELECT 	Ecodigo,
									Mcodigo,
									Hfecha,
									Hfechah
							FROM Htipocambio
							WHERE Ecodigo = <cfqueryparam value="#datos.Empresa.XmlText# " cfsqltype="cf_sql_numeric"> 
							  AND Mcodigo = <cfqueryparam value="#LvarMcodigo# " cfsqltype="cf_sql_numeric">
							  AND Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(datos.fecha.XmlText)#">
							  AND Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(datos.fecha.XmlText)#">
						</cfquery>

						<cfif rsRegistroActual.recordcount GT 0>
							<cfset LvarInserta = 1>
							<cfset LvarFecha  = CreateODBCDateTime(rsRegistroActual.Hfecha)>
							<cfset LvarFechah = CreateODBCDateTime(rsRegistroActual.Hfechah)>
	
							<cfquery datasource="#Session.dsn#">
								UPDATE Htipocambio
								SET Hfechah = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(datos.fecha.XmlText)#">
								WHERE Ecodigo = <cfqueryparam value="#datos.Empresa.XmlText# " cfsqltype="cf_sql_numeric"> 
								  AND Mcodigo = <cfqueryparam value="#LvarMcodigo# " cfsqltype="cf_sql_numeric">
								  AND Hfecha  = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> 
								  AND Hfechah = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechah#"> 
							</cfquery>
							<cfset LvarFechaEncontrada = LvarFechah>
						</cfif>
						
						<cfif LvarInserta eq 1>
							<cfset LvarMcodigo = rsRegistroActual.Mcodigo>
						</cfif>
		
						<cfquery datasource="#Session.DSN#">
						
							INSERT INTO Htipocambio (	Ecodigo,
														Mcodigo,
														Hfecha,
														TCcompra,
														TCventa,
														TCpromedio,
														Hfechah)
							VALUES(
									<cfqueryparam value="#datos.Empresa.XmlText#" cfsqltype="cf_sql_numeric">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(datos.Fecha.XmlText)#">,
									<cfqueryparam value="#Replace(datos.Compra.XmlText,',','','all')#" cfsqltype="cf_sql_float">,
									<cfqueryparam value="#Replace(datos.Venta.XmlText,',','','all')#" cfsqltype="cf_sql_float">,
									<cfqueryparam value="#Replace(datos.Promedio.XmlText,',','','all')#" cfsqltype="cf_sql_float">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaEncontrada#">)
						</cfquery>
						<cfset result = "OK">
				</cfif>
			<cfreturn "#result#"/>
		</cftransaction>
	</cffunction>
</cfcomponent>