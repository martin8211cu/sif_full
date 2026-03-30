<!---
	Devuelve la lista de los diferentes "Almacenes" definidos en el sistema
	
	--------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
		</row>
	</resultset>
	
	--------------------------------------
	---------- DATOS DE SALIDA: ----------	
	--------------------------------------
	
	(XML_OE):
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset rows="27">
		<row>
		<CODIGO ALMACEN></CODIGO ALMACEN>
		<DESCRIPCION ALMACEN></DESCRIPCION ALMACEN>
		</row>
	</resultset>	
	
	(XML_OD):
	--------------------------------------	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
		<EMPRESA></EMPRESA>
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

<cffunction name="ProcesaConsulta" access="public" hint="Devuelve los datos de la consulta sobre Cuentas Bancarias">
	<cfargument name="datos" type="string" required="yes" hint="Datos del XML recibidos">
		        
		<!---En caso de haber recbido los datos de la empresa sino se toman del session--->
		<cfif #datos.Empresa.XmlText# neq "">
			<cfset LvarEmpresa= #datos.Empresa.XmlText#>
		<cfelse>
			<cfset LvarEmpresa= #session.Ecodigo#>
		</cfif>
			
		<!---Se inicia la transacción para la consulta--->
                <cfquery name="rsAlmacenesE" datasource="#session.dsn#">
                	SELECT #LvarEmpresa# as Empresa from dual
                </cfquery>
                
                <cfquery name="rsAlmacenesD" datasource="#session.dsn#">
                    SELECT
        		            ltrim(rtrim(Almcodigo)) as 'Almacen'
                    	   ,ltrim(rtrim(Bdescripcion)) as 'Descripcion'
                    FROM Almacen 
                    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
				</cfquery>
			<cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(rsAlmacenesE)>
			<cfset GvarXML_OD = LobjInterfaz.fnGeneraQueryToXML(rsAlmacenesD)>
			<cfset result = "OK">
	<cfreturn "#result#">
</cffunction>