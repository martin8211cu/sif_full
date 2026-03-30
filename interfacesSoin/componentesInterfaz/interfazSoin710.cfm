<!---
	Obtener información variada, relacionada con los artículos y 
	dependiendo de los parámetros que sean proveídos por el solicitante
	
	--------------------------------------	
	----------- FUNCIONALIDAD ------------
	--------------------------------------
	Al menos se debe enviar el artículo ó el almacén, 
	1.si se envía el artículo, la consulta devolverá todos los almacenes donde existe el artículo
	2.si solo se envía el código de un almacén, en el detalle de la respuesta se desplegaran todos los artículos existentes en el almacén, 
	3.si se envían el articulo y el almacén se debe desplegar el dato individual del artículo en ese almacén.
	
	--------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Empresa></Empresa>
			<Articulo></Articulo> 
			<Almacen></Almacen>
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
		  <ARTICULO></ARTICULO>
		  <ALMACEN></ALMACEN>
		</row>
	<resultset>
	
	(XML_OD):
	--------------------------------------	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<CODIGO DEL ALMACEN></CODIGO DEL ALMACEN>
			<DESCRIPCION DEL ALMACEN></DESCRIPCION DEL ALMACEN>
			<CODIGO DE ARTICULO></CODIGO DE ARTICULO>
			<DESCRIPCION DEL ARTICULO></DESCRIPCION DEL ARTICULO>
			<EXISTENCIA></EXISTENCIA>
			<COSTO UNITARIO></COSTO UNITARIO>
			<CODIGO DE UNIDAD DE MEDIDA></CODIGO DE UNIDAD DE MEDIDA>
			<DESCRIPCION></DESCRIPCION>
			<CODIGO CLASIFICACION></CODIGO CLASIFICACION>
			<ESTANTE></ESTANTE>
			<CASILLA></CASILLA>
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
	<cfset LvarAlmId = ""> 
    <cfset LvarArtId = "">
    <cfset result = "">
	
	<!---En caso de haber recbido los datos de la empresa sino se toman del session--->
    <cfif #datos.Empresa.XmlText# neq "">
        <cfset LvarEmpresa= #datos.Empresa.XmlText#>
    <cfelse>
        <cfset LvarEmpresa= #session.Ecodigo#>
    </cfif>
    
	<!---Articulo--->
    <cfif #datos.Articulo.XmlText# neq "">
		<cfquery name="rsArticulo" datasource="#session.dsn#">        
            SELECT Aid FROM Articulos
            WHERE Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Articulo.XmlText#">
            	AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
        </cfquery>
        <cfif rsArticulo.recordcount eq 0>
        	<cfthrow message="Error, el codigo del articulo suministrado no esta registrado en la BD.">
        <cfelse>
        	<cfset LvarArtId = rsArticulo.Aid>    	
        </cfif>
    </cfif>
    
    <!---Almacen--->
    <cfif #datos.Almacen.XmlText# neq "">
		<cfquery name="rsAlmacen" datasource="#session.dsn#">        
            SELECT Aid FROM Almacen 
            WHERE Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Almacen.XmlText#">
            	AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
        </cfquery>
        <cfif rsAlmacen.recordcount eq 0>
        	<cfthrow message="Error, el codigo del almacen suministrado no esta en la BD">
        <cfelse>
        	<cfset LvarAlmId = rsAlmacen.Aid>
        </cfif>
    </cfif>

    <!---Verificacion de que el XML no este en Blanco--->
	<cfif #datos.Articulo.XmlText# eq "" AND #datos.Almacen.XmlText# 	eq "">
		<cfthrow message="Interfaz 710: Error, los datos esenciales para la consulta no se recibieron.!">
	<cfelse>
		<!---Encabezado--->
        <cfquery name="rsConsultaDescArtiE" datasource="#session.dsn#">
            SELECT 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#"> as Empresa
                <cfif #datos.Articulo.XmlText# neq "">
                    ,<cfqueryparam cfsqltype="cf_sql_char" value="#datos.Articulo.XmlText#"> as Articulo
               	<cfelse>
                	, '' as Articulo
                </cfif>
                
                <cfif #datos.Almacen.XmlText# neq "">
                    ,<cfqueryparam cfsqltype="cf_sql_char" value="#datos.Almacen.XmlText#"> as Almacen
                <cfelse>
                	,'' as Almacen
                </cfif> 
            FROM dual 
        </cfquery>
       
        <!---Detalle--->
        <cfquery name="rsConsultaDescArtiD" datasource="#session.dsn#">
            SELECT
                      ltrim(rtrim(a.Acodigo))            as  	'Articulo'
                    , ltrim(rtrim(al.Almcodigo)) 		 as 	'Almacen'		
                    , ltrim(rtrim(al.Bdescripcion)) 	 as		'Descr_Almacen'
                    , ltrim(rtrim(a.Adescripcion))    	 as 	'Descr_Articulo'
                    , Eexistencia				     	 as  	'Existencia'
                    , e.Ecostou							 as  	'Costo_Unitario'
                    , u.Ucodigo							 as  	'Unidad_medida'
                    , ltrim(rtrim(u.Udescripcion))       as  	'Desc_Unidad_Med'
                    , c.Ccodigo							 as		'Clasificacion'                    
                    , e.Eestante						 as 	'Estante'
                    , e.Ecasilla						 as 	'Casilla'
            
            FROM Articulos a
            
                INNER JOIN  Existencias e 	
                    ON 	e.Aid 		= a.Aid
                    AND e.Ecodigo 	= a.Ecodigo
            
                INNER JOIN Almacen al
                    ON al.Aid 		= e.Alm_Aid
                    AND al.Ecodigo 	= e.Ecodigo
            
                INNER JOIN Unidades u
                    ON u.Ucodigo 	= a.Ucodigo
                    AND u.Ecodigo 	= a.Ecodigo
            
                INNER JOIN Clasificaciones c
                    ON c.Ccodigo = a.Ccodigo
                    AND c.Ecodigo 	= a.Ecodigo	
            
             WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#"> 
                 
                <cfif len(trim(datos.Articulo.XmlText)) GT 0>
                    AND a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarArtId#"> <!----1.Nivel TODOS LOS ALMACENES DONDE EXISTE ESE ARTICULO--->
                </cfif>
                
                <cfif len(trim(datos.Almacen.XmlText)) GT 0>
                    AND al.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmId#"><!---2.Nivel DESCRIPCIÓN DEL ARTICULO INDIVIDUAL o TODOS los articulos de ese ALMACEN--->
                </cfif> 
        </cfquery>
         
        <!---Encabezado--->
        <cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(rsConsultaDescArtiE)>
        <!---Detalle--->
        <cfset GvarXML_OD = LobjInterfaz.fnGeneraQueryToXML(rsConsultaDescArtiD)>
        <cfset result = "OK">
	</cfif>
	<cfreturn "#result#">
</cffunction>

