<!---
	Se obtiene toda la información relacionada con las monedas en una sola consulta,
	que dependiendo del los parámetros que indique le devolverá.
	
	--------------------------------------	
	----------- FUNCIONALIDAD ------------
	--------------------------------------
	1.Si se envía el código de la moneda y la fecha en el encabezado
		de la respuesta se debe incluir el tipo de cambio vigente en esa fecha
	2.si no se incluye la fecha se debe devolver la vigente al día de la solicitud,
	3.si no se indica el código de la moneda, en el detalle de la respuesta se debe
		 incluir el listado de las diferentes monedas. 
		 
		 --------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
			<Codigo_Moneda></Codigo_Moneda> 
			<Fecha></Fecha>
		</row>
	</resultset>

	
	--------------------------------------
	---------- DATOS DE SALIDA: ----------	
	--------------------------------------
	
	(XML_OE):
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<EMPRESA></EMPRESA>
			<CODIGO MONEDA></CODIGO MONEDA>
			<FECHA></FECHA>
			<TIPO DE CAMBIO DE COMPRA></TIPO DE CAMBIO DE COMPRA>
			<TIPO DE CAMBIO DE VENTA></TIPO DE CAMBIO DE VENTA>
			<TIPO CAMBIO PROMEDIO></TIPO CAMBIO PROMEDIO>
		</row>
	</resultset>	
	
	(XML_OD):
	--------------------------------------	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<CODIGO MONEDA></CODIGO MONEDA>
			<NOMBRE></NOMBRE>
		</row>
	</resultset>
--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!---Actividad de la interfaz--->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura del Encabezado y Detalles--->
<cfset LvarXML = GvarXML_IE>
		
<!---Se realiza un parse de los datos--->
<cfset archivo_xml		= replace (#LvarXML#, chr(13), "", "All") >
<cfset datosXMLDOM 		= XMLParse(#archivo_xml#)>
<cfset datos 			= datosXMLDOM.XMLROOT>
<!---Cantidad de datos ingresados--->
<cfset numDATOS = Arraylen(datos.XMLChildren)>
	
<!---Recorrido para obtener los datos de la consulta--->
<cfloop FROM="1" to="#numDATOS#" index="i">
	<cfset DATOS = datos.XmlChildren[i]>
		<cfset myResult = ProcesaConsulta(DATOS)>
		<cfif #myResult# neq "OK">
        	<cfthrow message="#myResult#">
        </cfif>
</cfloop>

<!---Metodo que realiza la revisión de los datos y la posterior consulta--->
<cffunction name="ProcesaConsulta" access="public" hint="Devuelve los datos de la consulta sobre Cuentas Bancarias" returntype="string">
	<cfargument name="datos" type="string" required="yes" hint="Datos del XML recibidos">
	    
    <!---Variables--->
	<cfset LvarMonedaId = ""> 
    <cfset LvarFecha = "">
    <cfset LvarFechah = createdate(6100,1,1)>
    <cfset result = "">
	
	<!---En caso de haber recibido los datos de la empresa sino se toman del session--->
    <cfif #datos.Empresa.XmlText# neq "">
        <cfset LvarEmpresa= #datos.Empresa.XmlText#>
    <cfelse>
        <cfset LvarEmpresa= #session.Ecodigo#>
    </cfif>
    
       <!---FECHA: de no ser recibida se toma la fecha de las solicitud--->
    <cfif #datos.Fecha.XmlText# neq "">
		 <cfset LvarFecha = #datos.Fecha.XmlText#>
    <cfelse>
        <cfset LvarFecha = dateFormat(now(),"dd-mm-yyyy")>   
    </cfif>
    
	<!---MONEDA--->
    <cfif #datos.Codigo_Moneda.XmlText# neq "">
		<cfquery name="rsMonedaid" datasource="#session.dsn#">        
            SELECT DISTINCT m.Mcodigo, tc.Hfechah 
            FROM Monedas m
	            LEFT JOIN Htipocambio tc
					ON tc.Mcodigo 	= m.Mcodigo
					AND tc.Ecodigo 	= m.Ecodigo
            WHERE 	m.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#"> 
            	AND	m.Miso4217 	= <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Codigo_Moneda.XmlText#">
        </cfquery>
        <cfif rsMonedaid.recordcount eq 0>
			<cfthrow message="Error: El codigo de la moneda ingresado no esta en la BD">
    	<cfelse>
			<cfset LvarMonedaId = rsMonedaid.Mcodigo>
        </cfif>
    </cfif>
	<cfif #datos.Empresa.XmlText# eq "" AND #datos.Codigo_Moneda.XmlText# eq "" AND #datos.Fecha.XmlText# eq "">
		<cfthrow message="Interfaz 712: Error, todos los datos recibidos estan en blanco!">
	<cfelse>
		<!---Encabezado--->
        <cfquery name="rsConsultaMonedaE" datasource="#session.dsn#">
 			SELECT 
                     m.Ecodigo				 		as	'Empresa'
                    ,ltrim(rtrim(m.Miso4217))		as	'Codigo_Moneda'
                    ,ltrim(rtrim(tc.Hfecha))        as  'Fecha'
                    ,tc.TCcompra  				    as  'Tipo_Cambio_Compra'
                    ,tc.TCventa     				as  'Tipo_Cambio_Venta'
                    ,tc.TCpromedio  				as  'Tipo_Cambio_Promedio'
                    
            FROM Monedas m
                LEFT JOIN Htipocambio tc
                    ON tc.Mcodigo 	= m.Mcodigo
                    AND tc.Ecodigo 	= m.Ecodigo
                    AND tc.Hfechah BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> 
                                	 AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechah#">
            
            WHERE m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">  
				 <!---Caso Moneda recibida--->
                 <cfif #datos.Codigo_Moneda.XmlText# neq "">
					AND m.Mcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonedaId#">
                </cfif>               

        </cfquery>
        <!---Detalle--->
        <cfquery name="rsConsultaMonedaD" datasource="#session.dsn#">
            SELECT DISTINCT
                     ltrim(rtrim(m.Miso4217))			as		'Codigo_Moneda'
                    ,ltrim(rtrim(m.Mnombre))            as      'Descripcion'
            
            FROM Monedas m
                LEFT JOIN Htipocambio tc
                    ON tc.Mcodigo 	= m.Mcodigo
                    AND tc.Ecodigo 	= m.Ecodigo
                    AND tc.Hfechah BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> 
                                	 AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechah#">
            
            WHERE m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">  
				 <!---Caso Moneda recibida--->
                 <cfif #datos.Codigo_Moneda.XmlText# neq "">
					AND m.Mcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonedaId#">
                </cfif>               
                   
        </cfquery>
        <!---Encabezado--->
        <cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(rsConsultaMonedaE)>
        <!---Detalle--->
        <cfset GvarXML_OD = LobjInterfaz.fnGeneraQueryToXML(rsConsultaMonedaD)>
        <cfset result = "OK">
	</cfif>
	<cfreturn "#result#">
</cffunction>

