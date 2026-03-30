<!---
	Retornar los datos relacionados con los socios de negocios,
	relacionados con los parámetros indicados.
	
		--------------------------------------	
	----------- FUNCIONALIDAD ------------
	--------------------------------------
	1.caso de que se envíe el identificador del socio de negocios
		se devuelven los valores relacionados con ese código
	2.de lo contrario se debe devolver una lista de los socios de negocios 
		para que seleccionen el que desean asignar.
	--------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
			<ProvClienteAmbos></ProvClienteAmbos> 
			<CodigoSocio></CodigoSocio>
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
		<CODIGOSOCIO></CODIGOSOCIO>
		<NOMBRE></NOMBRE>
		<TIPOSOCIO></TIPOSOCIO>
		<TIPOIDENTIFICACION></TIPOIDENTIFICACION>
		<IDENTIFICACIONCEDULA></IDENTIFICACIONCEDULA>
		<EMPLEADOCOBRADOR></EMPLEADOCOBRADOR>
	</row>
	</resultset>	
	
	(XML_OD):
	--------------------------------------	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<CODIGOSOCIO></CODIGOSOCIO>
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
	<cfset LvarEmpresa = ""> 
    <cfset LvarSNcodigo = "">
    <cfset LvarTipoSN = "">
    <cfset result = "">
	
	<!---En caso de haber recibido los datos de la empresa sino se toman del session--->
    <cfif #datos.Empresa.XmlText# neq "">
        <cfset LvarEmpresa= #datos.Empresa.XmlText#>
    <cfelse>
        <cfset LvarEmpresa= #session.Ecodigo#>
    </cfif>

	<!---Valida el tipo de socio ingresado SNcodigo--->
    <cfif #datos.ProvClienteAmbos.XmlText# neq "">
		<cfquery name="rsTipoSocio" datasource="#session.dsn#">        
            SELECT SNtiposocio FROM SNegocios
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
	            AND SNtiposocio = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.ProvClienteAmbos.XmlText#">
        </cfquery>
		<cfif rsTipoSocio.recordcount eq 0>
			<cfthrow message="Error: El Tipo de Socio suministrado es invalido.!">
		</cfif> 
    </cfif>
    
    <!---Valida SNnumero y Obtiene el SNcodigo--->
    <cfif #datos.CodigoSocio.XmlText# neq "">
		<cfquery name="rsSNcodigo" datasource="#session.dsn#">        
            SELECT SNcodigo FROM SNegocios
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#"> 
        	    AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.CodigoSocio.XmlText#">
        </cfquery>
		<cfif rsSNcodigo.recordcount eq 0>
			<cfthrow message="Error: El codigo de socio suministrado no esta en la BD.!">
		<cfelse>
        	 <cfset LvarSNcodigo = rsSNcodigo.SNcodigo>
        </cfif> 
    </cfif>
    
	<cfif #datos.Empresa.XmlText# eq "" AND #datos.ProvClienteAmbos.XmlText# eq "" AND #datos.CodigoSocio.XmlText# eq "">
		<cfthrow message="Interfaz 713: Error, todos los datos recibidos estan en blanco!">
	<cfelse>
			<!---Encabezado--->
            <cfquery name="rsSNegociosE" datasource="#session.dsn#">
                SELECT
                     ltrim(rtrim(SNnumero))      		as	 	'CodigoSocio'
                    ,ltrim(rtrim(SNnombre))         	as      'NombreSocio'
                    ,ltrim(rtrim(SNtiposocio))    	    as      'Tipo'
                    ,ltrim(rtrim(SNtipo))           	as     	'TipoCedula'
                    ,ltrim(rtrim(SNidentificacion))     as    	'Identificacion'
                    ,DEidCobrador						as      'Cobrador'
                
                FROM SNegocios
                WHERE Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">  
                    
                    <cfif #datos.CodigoSocio.XmlText# neq "">
                        AND SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigo#">
                    </cfif>
                    <cfif #datos.ProvClienteAmbos.XmlText# neq "">
                        AND SNtiposocio = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.ProvClienteAmbos.XmlText#">
                    </cfif>
            </cfquery>
            <!---Detalle--->
            <cfquery name="rsSNegociosD" datasource="#session.dsn#">
                 SELECT 
                     ltrim(rtrim(SNnumero))      		as	 'CodigoSocio'
                    ,ltrim(rtrim(SNnombre))             as    'NombreSocio'
                FROM SNegocios
                WHERE Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">  
                    <cfif #datos.CodigoSocio.XmlText# neq "">
                        AND SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigo#">
                    </cfif>
                    <cfif #datos.ProvClienteAmbos.XmlText# neq "">
                        AND SNtiposocio = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.ProvClienteAmbos.XmlText#">
                    </cfif>
            </cfquery>
            <!---Encabezado--->
            <cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(rsSNegociosE)>
            <!---Detalle--->
            <cfset GvarXML_OD = LobjInterfaz.fnGeneraQueryToXML(rsSNegociosD)>
            <cfset result = "OK">
	</cfif>
	<cfreturn "#result#">
</cffunction>

