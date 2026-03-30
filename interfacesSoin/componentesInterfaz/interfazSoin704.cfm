<!---
	Al utilizar esta interfaz se unificara el origen de los datos relacionados con los bancos y sus
	cuentas, al ser utilizados por sistemas externos

	--------------------------------------	
	----------- FUNCIONALIDAD ------------
	--------------------------------------
	La Empresa siempre es requerida.
	
	1- Si solo se envia la empresa, se retornan tadas las Cuentas Bancarias existentes para todos los Bancos
	2- Si se envia empresa y banco, se retornan solo las Cuentas Bancarias de ese Banco específico
	3- Si se envia empresa, banco y cuenta, se retorna especificamente los datos de esa cuenta bancaria
	
	--------------------------------------
	---- DATOS DE ENTRADA (GvarXML_IE): --
	--------------------------------------
	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<Empresa></Empresa>
			<Banco></Banco>
			<Cuenta></Cuenta>
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
			<ID></ID>
			<Empresa></Empresa>
			<Banco></Banco>
			<Cuenta></Cuenta>
		</row>
	</resultset>	
	
	(XML_OD):
	--------------------------------------	
	<?xml version="1.0" encoding="utf-8"?>
	<resultset>
		<row>
			<ID></ID>
			<Banco></Banco>
			<Descripcion></Descripcion>			
			<Cuenta></Cuenta>
			<DescripcionCuenta></DescripcionCuenta>
			<Moneda></Moneda>
			<MISO4217></MISO4217>
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
	<cfset LvarResult = ProcesaConsulta(DATOS)>
	<cfif LvarResult neq "OK">
		<cfthrow message="#LvarResult#">
	</cfif>	
</cfloop>

<!---Metodo que realiza la revisión de los datos y la posterior consulta--->
<cffunction name="ProcesaConsulta" access="public" hint="Devuelve los datos de la consulta sobre Cuentas Bancarias" returntype="string">
	<cfargument name="datos" type="string" required="yes" hint="Datos del XML recibidos">
	<!---variables--->
	<cfset LvarEmpresa ="">
    <cfset LvarBancosId ="">
    <cfset LvarCuentasBancos = "">
    
	<cfif #datos.Empresa.XmlText# eq "" AND #datos.Banco.XmlText# eq "" AND #datos.Cuenta.XmlText# 	eq "">
		<cfthrow message="Interfaz 704: Error, se enviaron todos los datos en blanco.">
	<cfelse>
		
		<!---Empresa--->
		<cfif #datos.Empresa.XmlText# neq "">
			<cfset LvarEmpresa= #datos.Empresa.XmlText#>
		<cfelse>
			<cfset LvarEmpresa= #session.Ecodigo#>
		</cfif>
        <!---Bancos--->
        <cfif #datos.Banco.XmlText# neq "">
        	<cfquery name="rsBancosId" datasource="#session.dsn#">
            	SELECT Bid 
				FROM Bancos 
	            WHERE Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
		            AND Bcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.Banco.XmlText#">											
            </cfquery>
        	<cfif rsBancosId.recordcount eq 0>
            	<cfthrow message="Error: El codigo del Banco suministrado no esta en la BD">
            <cfelse>
            	 <cfset LvarBancosId =  rsBancosId.Bid>
            </cfif>    
        </cfif>
        
        <!----Cuentas Bancos--->
        <cfif #datos.Cuenta.XmlText# neq "">
	        <cfquery name="rsCBid" datasource="#session.dsn#">
                SELECT CBid 
				FROM CuentasBancos 
                WHERE Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
                  AND CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.Cuenta.XmlText#">											
            </cfquery>
        	<cfif rsCBid.recordcount eq 0>
            	<cfthrow message="Error: La cuenta del Banco suministrado no esta en la BD">
            <cfelse>
            	 <cfset LvarCuentasBancos =  rsCBid.CBid>
            </cfif>
        </cfif>
		
		<cfquery name="rsConsultaEnc" datasource="#session.dsn#">
			Select #LvarEmpresa# as Empresa, 
					<cfif #datos.Banco.XmlText# neq "">
						'#datos.Banco.XmlText#'
					<cfelse>
						''
					</cfif> as Banco, 
					<cfif #datos.Cuenta.XmlText# neq "">
						'#datos.Cuenta.XmlText#'
					<cfelse>
						''
					</cfif> as Cuenta
			from dual
		</cfquery>
	
		<!---Consulta de las Cuentas Bancarias --->
		<cfquery name="rsConsultaCB" datasource="#session.dsn#">
			SELECT 
					 b.Bcodigo as Banco
					,b.Bdescripcion	as Descripcion
                    ,cb.CBcodigo as Cuenta
				 	,cb.CBdescripcion as DescripcionCuenta
                    ,m.Mnombre as Moneda
					,m.Miso4217 as MISO4217
							
			FROM  CuentasBancos cb
				INNER JOIN Bancos b
					ON b.Bid 		= cb.Bid
					AND b.Ecodigo 	= cb.Ecodigo
				INNER JOIN Monedas m
					ON m.Mcodigo	= cb.Mcodigo
						
			WHERE  cb.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">				
			
				<cfif #datos.Banco.XmlText# neq "">
					AND b.Bid 		= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarBancosId#">
				</cfif>
				
				<cfif #datos.Cuenta.XmlText# neq "">
					AND cb.CBid 	=  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentasBancos#">
				</cfif>
				AND cb.CBesTCE 		<> <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>
		
		<cfset GvarXML_OE = LobjInterfaz.fnGeneraQueryToXML(rsConsultaEnc)>
		<cfset GvarXML_OD = LobjInterfaz.fnGeneraQueryToXML(rsConsultaCB)>
		<cfset result = "OK">

	</cfif>
	<cfreturn "#result#">
</cffunction>