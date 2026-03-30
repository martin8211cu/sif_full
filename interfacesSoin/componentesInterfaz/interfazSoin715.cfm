<!---
	Consulta de Requisiciones
		
	--------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<Empresa>1</Empresa>
			<EstadoVale></EstadoVale>
			<Clasificacion></Clasificacion> 
			<Almacen></Almacen>
			<fechaIni></fechaIni>
			<fechaFin></fechaFin>
			<Numero_Requisicion></Numero_Requisicion>
			<Centro_Costo></Centro_Costo>
		</row>
	</resultset>
	
	--------------------------------------
	---- DATOS DE SALIDA (GvarXML_OE): --
	--------------------------------------
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			  <CODIGO_ARTICULO></CODIGO_ARTICULO>
			  <DESC_ARTICULO></DESC_ARTICULO>
			  <CANTIDAD></CANTIDAD>
			  <COSTO></COSTO>
			  <CODIGO_UNIDAD></CODIGO_UNIDAD>
			  <DESCRIPCION_UNIDAD></DESCRIPCION_UNIDAD>
			  <NUMERO_REQUISICION></NUMERO_REQUISICION>
			  <OBSERVACIONES></OBSERVACIONES>
			  <CENTRO_COSTO></CENTRO_COSTO>
			  <FECHA_REQUISICION></FECHA_REQUISICION>
   		 </row>
	</resultset>
--->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cfset LvarXML = GvarXML_IE>

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
		<cfset myResult = fn_Consulta(DATOS)>
		<cfif #myResult# neq "OK">
        	<cfthrow message="#myResult#">
        </cfif>
</cfloop>

<cffunction name="fn_Consulta" hint="Realiza la consulta" returntype="string">
	<cfargument name="datos" type="string" required="yes" hint="Datos del XML recibidos">
<cfset resultado = "">
<cfif #datos.Empresa.XmlText# eq "">
	<cfthrow message="Error en Interfaz 715. No se el campo requerido empresa. Proceso Cancelado!.">
<cfelse>
	<!---Variables--->
	<cfset LvarAlmId = "">
    <cfset LvarCcodigo = "">
    <cfset LvarNumReq = "">
    <cfset LvarCFuncional = "">
    
	<!---Validar la empresa--->
    <cfquery name="rsEmpresa" datasource="#session.dsn#">
    	SELECT count(1)
        FROM Empresas
        WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
    </cfquery>
    
    <!---Validar Almacen--->
    <cfif #datos.Almacen.XmlText# neq "">
        <cfquery name="rsAlmacen" datasource="#session.dsn#">
            SELECT Aid
            FROM Almacen
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
	            AND Almcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Almacen.XmlText#">
        </cfquery>
        <cfif #rsAlmacen.recordcount# eq 0>
    	    <cfthrow message="Error en Interfaz 715. El almacen no se encuentra en la base de datos. Proceso Cancelado!.">
        <cfelse>
        	<cfset LvarAlmId = #rsAlmacen.Aid#>
        </cfif>
   </cfif>
   
   <!---Validar Número requisición --->
    <cfif #datos.Numero_Requisicion.XmlText# neq "">
        <cfquery name="rsNumReq" datasource="#session.dsn#">
            SELECT ERdocumento
            FROM ERequisicion
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
	            AND  ERdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Numero_Requisicion.XmlText#">
        </cfquery>
        <cfif #rsNumReq.recordcount# eq 0>
    	    <cfthrow message="Error en Interfaz 715. El número de requisición no se encuentra en la base de datos. Proceso Cancelado!.">
        <cfelse>
        	<cfset LvarNumReq = #datos.Numero_Requisicion.XmlText#>
        </cfif>
   </cfif>
   
   <!---Validar Centro Costo --->
    <cfif #datos.Centro_Costo.XmlText# neq "">
        <cfquery name="rsCentroCosto" datasource="#session.dsn#">
            SELECT CFcodigo 
            FROM CFuncional 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
	            AND  CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Centro_Costo.XmlText#">
        </cfquery>
        <cfif #rsCentroCosto.recordcount# eq 0>
    	    <cfthrow message="Error en Interfaz 715. El Centro Funcional no se encuentra en la base de datos. Proceso Cancelado!.">
        <cfelse>
        	<cfset LvarCFuncional = #datos.Centro_Costo.XmlText#>
        </cfif>
   </cfif>
   
   <!---Clasificacion del articulo--->
    <cfif #datos.Clasificacion.XmlText# neq "">
		<cfquery name="rsClasificacion" datasource="#session.dsn#">        
            SELECT Ccodigo FROM Articulos
            WHERE Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Clasificacion.XmlText#">
            	AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
        </cfquery>
        <cfif #rsClasificacion.recordcount# eq 0>
        	<cfthrow message="Error, El codigo de clasificacion del articulo no esta registrado en la BD.">
        <cfelse>
        	<cfset LvarCcodigo = #datos.Clasificacion.XmlText#>   	
        </cfif>
    </cfif>  
    
    <!---Validación Estado--->
    <cfif #datos.EstadoVale.XmlText# neq "">
               <cfif 	#datos.EstadoVale.XmlText# eq 0 or
			   			#datos.EstadoVale.XmlText# eq 1 or
						#datos.EstadoVale.XmlText# eq 2 or
						#datos.EstadoVale.XmlText# eq 4>
                <cfelse>
               		<cfthrow message="Error, Los tipos de estados validos son 0,1,2 y 4 no '#datos.EstadoVale.XmlText#'. Proceso Cancelado.!">
               </cfif>         
    </cfif>
    

    <!---VALIDACION FECHA--->
    <cfset LvarFechaIni = validacionFecha(#datos.fechaIni.XmlText#, "Inicio")>
    <cfset LvarFechaFin = validacionFecha(#datos.fechaFin.XmlText#, "Fin")>
     
    <cfif #rsEmpresa.recordcount# gt 0>
        <cfquery name="consulta" datasource="#session.DSN#">
            SELECT      
                     ltrim(rtrim(art.Acodigo)) 					AS Codigo_Articulo
                    ,art.Adescripcion 							AS Desc_Articulo
                    ,round(coalesce(det.DRcantidad,0.0000),4) 	AS Cantidad
                    ,round(( coalesce(det.DRcantidad,0) * coalesce(ext.Ecostou,0) ) ,2) AS Costo
                    ,ltrim(rtrim(uni.Ucodigo)) 					AS Codigo_Unidad
                    ,ltrim(rtrim(uni.Udescripcion)) 			AS Descripcion_Unidad
                    ,enc.ERdocumento as Numero_Requisicion
                    ,ltrim(rtrim(enc.ERdescripcion)) 			AS Observaciones
                    ,cfu.CFcodigo as Centro_Costo
                    ,enc.ERFecha as Fecha_Requisicion
            FROM ERequisicion enc
                INNER JOIN DRequisicion det
                        INNER JOIN CFuncional cfu
                            ON cfu.CFid = det.CFid
                        INNER JOIN Articulos art
                            ON art.Aid = det.Aid
                        INNER JOIN Unidades uni
                            ON uni.Ucodigo = art.Ucodigo
                            AND uni.Ecodigo = art.Ecodigo
                    ON det.ERid = enc.ERid               
                INNER JOIN Existencias ext
                    ON ext.Aid = det.Aid
                    AND ext.Alm_Aid = enc.Aid
            WHERE enc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
					<cfif #datos.Almacen.XmlText# neq "">
                    	AND  enc.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmId#">
                    </cfif>
                  
                    <cfif #datos.EstadoVale.XmlText# neq "">
                    	AND  enc.Estado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.EstadoVale.XmlText#">
                    </cfif>
                    
                    <cfif #datos.Clasificacion.XmlText# neq "">
                    	AND  art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Clasificacion.XmlText#">
                    </cfif>

                    <cfif LvarFechaIni neq "" and LvarFechaFin neq "">
                        AND enc.ERFecha BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
                    </cfif>

                    <cfif #datos.Numero_Requisicion.XmlText# neq "">
                    	AND  enc.ERdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarNumReq#">
                    </cfif>

                    <cfif #datos.Centro_Costo.XmlText# neq "">
                    	AND  cfu.CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCFuncional#">
                    </cfif>
            <cfif datos.EstadoVale.XmlText gt 0>
            UNION
            SELECT      
                     ltrim(rtrim(art.Acodigo)) 					AS Codigo_Articulo
                    ,art.Adescripcion 							AS Desc_Articulo
                    ,round(coalesce(kx.Kunidades,0.0000),4) 	AS Cantidad
                    ,round(( coalesce(kx.Kunidades,0) * coalesce(ext.Ecostou,0) ) ,2) AS Costo
                    ,ltrim(rtrim(uni.Ucodigo)) 					AS Codigo_Unidad
                    ,ltrim(rtrim(uni.Udescripcion)) 			AS Descripcion_Unidad
                    ,her.ERdocumento as Numero_Requisicion
                    ,ltrim(rtrim(her.ERdescripcion)) 			AS Observaciones
                    ,cfu.CFcodigo as Centro_Costo
                    ,her.ERFecha as Fecha_Requisicion
            FROM HERequisicion her
                INNER JOIN Kardex kx
                        INNER JOIN CFuncional cfu
                            ON cfu.CFid = kx.CFid
                        INNER JOIN Articulos art
                            ON art.Aid = kx.Aid
                        INNER JOIN Unidades uni
                            ON uni.Ucodigo = art.Ucodigo
                            AND uni.Ecodigo = art.Ecodigo
                    ON kx.ERid = her.ERid               
                INNER JOIN Existencias ext
                    ON ext.Aid = kx.Aid
                    AND ext.Alm_Aid = her.Aid
            WHERE her.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Empresa.XmlText#">
					<cfif #datos.Almacen.XmlText# neq "">
                    	AND  her.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmId#">
                    </cfif>
                                    
                    <cfif #datos.Clasificacion.XmlText# neq "">
                    	AND  art.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos.Clasificacion.XmlText#">
                    </cfif>

                    <cfif LvarFechaIni neq "" and LvarFechaFin neq "">
                        AND her.ERFecha BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaIni#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaFin#">
                    </cfif>

                    <cfif #datos.Numero_Requisicion.XmlText# neq "">
                    	AND  her.ERdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarNumReq#">
                    </cfif>

                    <cfif #datos.Centro_Costo.XmlText# neq "">
                    	AND  cfu.CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCFuncional#">
                    </cfif>        
            </cfif>
            
        </cfquery>
    <cfelse> 
    	<cfthrow message="Error en Interfaz 715. La empresa no se encuentra en la BD. Proceso Cancelado!.">
    </cfif>
</cfif>
<cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(consulta)>
<cfset resultado = "OK">
<cfreturn "#resultado#">
</cffunction>
<cffunction 	access="private" 
				name="validacionFecha" 
                description="Validacion de las fechas q sean en formato esperado YYYY-MM-DD" 
                returntype="string">
	<cfargument name="fecha" type="string" hint="Fecha recibida">
    <cfargument name="lapso" type="string" hint="fecha Inicio o fecha fin">
    
    <cfset LvarFecha = "">
    <cfset DtCorrecta = "">
    
	<!---Validacion Fecha--->
	<cfif Arguments.fecha neq "">
    <cfset LvarFecha = Arguments.fecha>
        <cftry>
            <!--- 2011-09-13--->
            <cfset DtCorrecta = CreateDate( mid(LvarFecha,1,4), mid(LvarFecha,6,2), mid(LvarFecha,9,2) )>
            <cfif mid(LvarFecha,5,1) NEQ "-" OR mid(LvarFecha,8,1) NEQ "-">
                <cfthrow>
            </cfif>
        <cfcatch type="any">
            <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD. Proceso Cancelado!.">
        </cfcatch>
        </cftry> 
	</cfif>
    <cfreturn "#DtCorrecta#">
</cffunction>
