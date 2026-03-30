<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   TimbresFiscales.cfc
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:
--->

<cfcomponent output="true" extends="Interfaz_Base">
	<cffunction name="init" description="constructor">
		<cfreturn this >
	</cffunction>

	<cffunction name="setTimbres" access="public" returntype="void" output="true">
		<!--- Proceso --->

		<!---<cfquery name="rsDatosCred" datasource="ldcom">
			<!----- Crédito--->
			SELECT	'V-'+Right('00' + CONVERT(NVARCHAR, s.Cadena_Id), 2)+Right('0000' + CONVERT(NVARCHAR, e.Suc_id), 4)+Right('00' + CONVERT(NVARCHAR, fe.Caja_id), 2)+'-'+Right('00000000' + CONVERT(NVARCHAR, fe.Factura_Id), 9) as Numero_Documento,
					Upper(e.ClienteFiscal_Id)RFC, s.Cadena_Id, fe.TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, 0 as Actualizar, XML_Archivo,
					e.Fiscal_NumeroFactura, e.Fiscal_Serie, e.Fiscal_Total, e.Fiscal_Tipo, e.Fiscal_Tipo_Factura, e.Fiscal_Estado
			FROM	Factura_Fiscal_Encabezado e
				INNER JOIN	Factura_Encabezado fe ON e.Emp_Id = fe.Emp_Id AND e.Suc_Id = fe.Suc_Id 
				AND e.Fiscal_NumeroFactura = fe.Fiscal_NumeroFactura
				INNER JOIN	Sucursal s ON e.Emp_Id = s.Emp_Id AND e.Suc_Id = s.Suc_Id
				INNER JOIN 	Factura_Fiscal_XML x ON e.Emp_Id = x.Emp_Id and e.Suc_Id = x.Suc_Id and e.Fiscal_NumeroFactura = x.Fiscal_NumeroFactura
			WHERE	fe.TipoDoc_id = 4
			union
			SELECT	'V-'+Right('00' + CONVERT(NVARCHAR, s.Cadena_Id), 2)+Right('0000' + CONVERT(NVARCHAR, e.Suc_id), 4)+Right('00' + CONVERT(NVARCHAR, fe.Caja_id), 2)+'-'+Right('00000000' + CONVERT(NVARCHAR, fe.Factura_Id), 9) as Numero_Documento,
					Upper(e.ClienteFiscal_Id)RFC, s.Cadena_Id, fe.TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, 0 as Actualizar, XML_Archivo,
					e.Fiscal_NumeroFactura, e.Fiscal_Serie, e.Fiscal_Total, e.Fiscal_Tipo, e.Fiscal_Tipo_Factura, e.Fiscal_Estado 
			FROM	Factura_Fiscal_Encabezado e
				INNER JOIN	Factura_Encabezado fe ON e.Emp_Id = fe.Emp_Id AND e.Suc_Id = fe.Suc_Id 
				AND fe.Fiscal_NumeroFacturaGlobal = e.Fiscal_NumeroFactura
				INNER JOIN	Sucursal s ON e.Emp_Id = s.Emp_Id AND e.Suc_Id = s.Suc_Id
				INNER JOIN 	Factura_Fiscal_XML x ON e.Emp_Id = x.Emp_Id and e.Suc_Id = x.Suc_Id and e.Fiscal_NumeroFactura = x.Fiscal_NumeroFactura
			WHERE	fe.TipoDoc_id = 4									
		</cfquery>--->
		<cfquery name="rsDatosCont" datasource="ldcom">
			<!----- Contado--->
			SELECT	'V-'+Right('00' + CONVERT(NVARCHAR, s.Cadena_Id), 2)+Right('0000' + CONVERT(NVARCHAR, e.Suc_id), 4)+'-'+Right('000000000' + CONVERT(NVARCHAR, fe.Operacion_Id), 9) as Numero_Documento,
					Upper(e.ClienteFiscal_Id)RFC, s.Cadena_Id, fe.TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, 0 as Actualizar, XML_Archivo,
					e.Fiscal_NumeroFactura, e.Fiscal_Serie, e.Fiscal_Total, e.Fiscal_Tipo, e.Fiscal_Tipo_Factura, e.Fiscal_Estado
			FROM	Factura_Fiscal_Encabezado e
				INNER JOIN	Factura_Encabezado fe ON e.Emp_Id = fe.Emp_Id AND e.Suc_Id = fe.Suc_Id 
				AND e.Fiscal_NumeroFactura = fe.Fiscal_NumeroFactura
				INNER JOIN	Sucursal s ON e.Emp_Id = s.Emp_Id AND e.Suc_Id = s.Suc_Id
				INNER JOIN 	Factura_Fiscal_XML x ON e.Emp_Id = x.Emp_Id and e.Suc_Id = x.Suc_Id and e.Fiscal_NumeroFactura = x.Fiscal_NumeroFactura
			WHERE	fe.TipoDoc_id != 4
				AND cast(e.Fiscal_FechaTimbrado as date) between getdate()-60 and getdate()
			UNION
			SELECT	'V-'+Right('00' + CONVERT(NVARCHAR, s.Cadena_Id), 2)+Right('0000' + CONVERT(NVARCHAR, e.Suc_id), 4)+'-'+Right('000000000' + CONVERT(NVARCHAR, fe.Operacion_Id), 9) as Numero_Documento,
					Upper(e.ClienteFiscal_Id)RFC, s.Cadena_Id, fe.TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, 0 as Actualizar, XML_Archivo,
					e.Fiscal_NumeroFactura, e.Fiscal_Serie, e.Fiscal_Total, e.Fiscal_Tipo, e.Fiscal_Tipo_Factura, e.Fiscal_Estado
			FROM	Factura_Fiscal_Encabezado e
			INNER JOIN	Factura_Encabezado fe ON e.Emp_Id = fe.Emp_Id AND e.Suc_Id = fe.Suc_Id 
			AND e.Fiscal_NumeroFactura = fe.Fiscal_NumeroFacturaGlobal
			INNER JOIN	Sucursal s ON e.Emp_Id = s.Emp_Id AND e.Suc_Id = s.Suc_Id
			INNER JOIN 	Factura_Fiscal_XML x ON e.Emp_Id = x.Emp_Id and e.Suc_Id = x.Suc_Id and e.Fiscal_NumeroFactura = x.Fiscal_NumeroFactura
			WHERE	fe.TipoDoc_id != 4
		</cfquery>
		<!--- Crea tabla temporal para comparación --->
		<!---<cf_dbtemp name="LocalTempFiscal" returnvariable="varLocalTempFiscal" datasource="sifinterfaces">
			<cf_dbtempcol name="Numero_Documento"		 type="Varchar(40)">
			<cf_dbtempcol name="RFC" 					 type="Varchar(13)">
			<cf_dbtempcol name="Cadena_Id"				 type="integer">
			<cf_dbtempcol name="TipoDoc_Id" 			 type="Varchar(1)">
			<cf_dbtempcol name="Fiscal_FechaTimbrado" 	 type="DateTime">
			<cf_dbtempcol name="Fiscal_UUID" 			 type="Varchar(100)">
			<cf_dbtempcol name="Fiscal_UUID_Anulado" 	 type="Varchar(100)">
			<cf_dbtempcol name="xml" 					 type="Varchar(8000)">
			
			<!--- <cf_dbtempcol name="Actualizar" 			type="integer"> --->
		</cf_dbtemp>--->
		<!--- Para ventas a crédito --->
		<!---<cfif rsDatosCred.recordcount GT 0>
			<!--- Inserta en tabla temporal para comparación --->
			<cfquery datasource="sifinterfaces">
				<cfloop query="rsDatosCred">
					INSERT INTO varLocalTempFiscal (Numero_Documento, RFC, Cadena_Id, TipoDoc_Id, Fiscal_FechaTimbrado, Fiscal_UUID, xml,
					Fiscal_NumeroFactura,Fiscal_Serie, Fiscal_Total, Fiscal_Tipo, Fiscal_Tipo_Factura, Fiscal_Estado) 					
					VALUES('#rsDatosCred.Numero_Documento#','#rsDatosCred.RFC#', #rsDatosCred.Cadena_Id#,#rsDatosCred.TipoDoc_id#, 
					'#rsDatosCred.Fiscal_FechaTimbrado#','#rsDatosCred.Fiscal_UUID#', '#REReplace(rsDatosCred.XML_Archivo,'ñ|Ñ','n','all')#',
					'#rsDatosCred.Fiscal_NumeroFactura#', '#rsDatosCred.Fiscal_Serie#',#rsDatosCred.Fiscal_Total#, #rsDatosCred.Fiscal_Tipo#,
					#rsDatosCred.Fiscal_Tipo_Factura#, '#rsDatosCred.Fiscal_Estado#')
				</cfloop>
			</cfquery>
			<!--- Selecciona los Registros nuevos a insertar --->
			<cfquery name="rsTimbresNuevos" datasource="sifinterfaces">
				SELECT	Numero_Documento, RFC, Cadena_Id, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, xml, 
				Fiscal_Serie+Fiscal_NumeroFactura as Factura, Fiscal_Total, Fiscal_Tipo, Fiscal_Tipo_Factura, Fiscal_Estado
				FROM	varLocalTempFiscal t
				WHERE	TipoDoc_id = 4
				AND 	NOT EXISTS (
								SELECT	1
								FROM	SIFLD_Timbres_Fiscales tf
								WHERE	t.Numero_Documento = tf.Numero_Documento
								AND 	t.Cadena_Id = tf.Cadena_Id);
			</cfquery>
			<!--- Selecciona los Registros a Actualizar --->
			<cfquery name="rsTimbresActualizar" datasource="sifinterfaces">
				SELECT	Numero_Documento, RFC, Cadena_Id, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, xml,
				Fiscal_Serie+Fiscal_NumeroFactura as Factura, Fiscal_Total, Fiscal_Tipo, Fiscal_Tipo_Factura, Fiscal_Estado
				FROM	varLocalTempFiscal t
				WHERE	TipoDoc_id = 4
				AND  	EXISTS (
								SELECT	1
								FROM	SIFLD_Timbres_Fiscales tf
								WHERE	t.Numero_Documento = tf.Numero_Documento
								AND 	t.Cadena_Id = tf.Cadena_Id
								AND 	t.Fiscal_UUID != tf.Fiscal_UUID);
			</cfquery>
			<cftry>
				<!--- Inserta los registros nuevos --->
				<cfif rsTimbresNuevos.recordcount GT 0>
					<cfloop query="rsTimbresNuevos">
						<cfquery  datasource="sifinterfaces">
							INSERT INTO SIFLD_Timbres_Fiscales(Numero_Documento, RFC, Cadena_Id, TipoDoc_id, Fiscal_FechaTimbrado, 
							Fiscal_UUID, Actualizar, xml,Factura, Fiscal_Total,Fiscal_Tipo,Fiscal_Tipo_Factura,Fiscal_Estado)
							VALUES 	('#rsTimbresNuevos.Numero_Documento#', '#rsTimbresNuevos.RFC#', #rsTimbresNuevos.Cadena_Id#, 
							#rsTimbresNuevos.TipoDoc_id#,'#rsTimbresNuevos.Fiscal_FechaTimbrado#', '#rsTimbresNuevos.Fiscal_UUID#', 0, 
							'#rsTimbresNuevos.xml#','#rsTimbresNuevos.Factura#', #rsTimbresNuevos.Fiscal_Total#, #rsTimbresNuevos.Fiscal_Tipo#, 
							#rsTimbresNuevos.Fiscal_Tipo_Factura#, '#rsTimbresNuevos.Fiscal_Estado#')
						</cfquery>
					</cfloop>
				</cfif>
				<!--- Inserta los registros a actualizar --->
				<cfif rsTimbresActualizar.recordcount GT 0>
					<cfloop query="rsTimbresActualizar">
						<cfquery datasource="sifinterfaces">
							UPDATE 	SIFLD_Timbres_Fiscales
							SET 	Fiscal_UUID = '#rsTimbresActualizar.Fiscal_UUID#', Actualizar = 1, xml = '#rsTimbresActualizar.xml#'
							WHERE 	Numero_Documento = '#rsTimbresActualizar.Numero_Documento#'
							AND 	Cadena_Id = #rsTimbresActualizar.Cadena_Id#
						</cfquery>
					</cfloop>
				</cfif>
			<cfcatch>
				<cfquery datasource="sifinterfaces">
					delete varLocalTempFiscal
				</cfquery>
			</cfcatch>
			</cftry>
			<cfquery datasource="sifinterfaces">
				delete varLocalTempFiscal
			</cfquery>
		</cfif>--->
<!--- <cfset startTime = getTickCount()> --->
		<!--- Para Ventas de Contado --->
		<cfif rsDatosCont.recordcount GT 0>
			<!--- inserta datos en tabla temporal para comparación --->
			<cfquery datasource="sifinterfaces">
				<cfloop query="rsDatosCont">
					INSERT INTO varLocalTempFiscal (Numero_Documento, RFC, Cadena_Id, TipoDoc_Id, Fiscal_FechaTimbrado, Fiscal_UUID, xml,
					Fiscal_NumeroFactura,Fiscal_Serie, Fiscal_Total,Fiscal_Tipo,Fiscal_Tipo_Factura,Fiscal_Estado)
					VALUES('#rsDatosCont.Numero_Documento#','#rsDatosCont.RFC#',#rsDatosCont.Cadena_Id#, #rsDatosCont.TipoDoc_id#,
							'#rsDatosCont.Fiscal_FechaTimbrado#','#rsDatosCont.Fiscal_UUID#', 
							'#REReplace(rsDatosCont.XML_Archivo,'ñ|Ñ','n','all')#','#rsDatosCont.Fiscal_NumeroFactura#',
							'#rsDatosCont.Fiscal_Serie#', #rsDatosCont.Fiscal_Total#, #rsDatosCont.Fiscal_Tipo#, #rsDatosCont.Fiscal_Tipo_Factura#,
							'#Fiscal_Estado#')
				</cfloop>
			</cfquery>
			<cfquery datasource="sifinterfaces">
				UPDATE 	t
				SET 	t.Fiscal_UUID_Anulado = t.Fiscal_UUID, t.Fiscal_UUID = temp.Fiscal_UUID, t.xml = temp.xml, t.Actualizar = 1
				FROM 	SIFLD_Timbres_Fiscales t
				INNER JOIN 	varLocalTempFiscal temp
					ON (t.Numero_Documento = temp.Numero_Documento AND t.TipoDoc_id = temp.TipoDoc_id AND cast(t.Fiscal_FechaTimbrado as date) = cast(temp.Fiscal_FechaTimbrado as date))
				WHERE 	temp.TipoDoc_id != 4
			</cfquery>


			<!--- Facturas individuales de dias anteriores --->
	<!---	<cfquery name="rsFactInd" datasource="sifinterfaces">
				SELECT 	temp.Numero_Documento, temp.RFC, temp.Cadena_Id, temp.TipoDoc_id, temp.Fiscal_FechaTimbrado, temp.Fiscal_UUID, temp.xml, CAST(SUBSTRING(temp.Numero_Documento,3,2) as numeric) Emp_Id,
						CAST(SUBSTRING(temp.Numero_Documento,5,4) as numeric) Suc_Id, CAST(SUBSTRING(temp.Numero_Documento,10,9) as numeric) Operacion_Id
				FROM	varLocalTempFiscal temp
				INNER JOIN 	SIFLD_Timbres_Fiscales t
				ON	(temp.Numero_Documento = t.Numero_Documento AND temp.TipoDoc_id = t.TipoDoc_id AND cast(temp.Fiscal_FechaTimbrado as date) != cast(t.Fiscal_FechaTimbrado as date))
				WHERE 	temp.TipoDoc_id != 4
			</cfquery>
				<cfif rsFactInd.recordcount GT 0>
				<cfloop query="rsFactInd">
					<!--- genera numero de documento de factura global del día de facturación --->
					<cfquery name="rsNumeroDoc" datasource="ldcom">
						SELECT 	top (1) Operacion_id
						FROM 	Factura_Encabezado e
						WHERE 	Emp_Id = #rsFactInd.Emp_Id# AND Suc_Id = #rsFactInd.Suc_Id#
						AND 	Factura_Fecha = '#rsFactInd.Fiscal_FechaTimbrado#'
						AND 	TipoDoc_id != 4
					</cfquery>
					<!--- Numero de documento --->
					<cfquery name="rsNumeroDoc" datasource="sifinterfaces">
						SELECT 'V-' + Right('00' + CONVERT(NVARCHAR, #rsFactInd.Cadena_Id#),2) + Right('0000' + CONVERT(NVARCHAR, #rsFactInd.Suc_id#),4) + '-' + Right('000000000' + CONVERT(NVARCHAR, #rsFactInd.Operacion_Id#),9) as Numero_Documento
					</cfquery>
					<!--- Inserta las facturas individuales de dias anteriores --->
					<cfquery datasource="sifinterfaces">
						INSERT; INTO SIFLD_Timbres_Fiscales(Numero_Documento,RFC,Cadena_Id,TipoDoc_id,Fiscal_FechaTimbrado,Fiscal_UUID, xml, 
						Factura)
						VALUES('#rsNumeroDoc.Numero_Documento#', '#rsFactInd.RFC#', #rsFactInd.Cadena_Id#, #rsFactInd.TipoDoc_id#, '#rsFactInd.Fiscal_FechaTimbrado#', '#rsFactInd.Fiscal_UUID#', 'rsFactInd.xml','#Fiscal_Serie#'&'#rsFactInd.Fiscal_NumeroFactura#')
					</cfquery>
				</cfloop>
				
			</cfif>--->
			<!--- Inserta timbres nuevos --->
			<cfquery datasource="sifinterfaces">
				INSERT INTO SIFLD_Timbres_Fiscales (Numero_Documento,RFC,Cadena_Id,TipoDoc_id,Fiscal_FechaTimbrado,Fiscal_UUID, xml, Factura,
				Fiscal_Total, Fiscal_Tipo, Fiscal_Tipo_Factura, Fiscal_Estado)
				SELECT	Numero_Documento, RFC, Cadena_Id, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, xml, 
				Fiscal_Serie+Fiscal_NumeroFactura as Factura, Fiscal_Total, Fiscal_Tipo, Fiscal_Tipo_Factura, Fiscal_Estado
				FROM	varLocalTempFiscal t
				WHERE	TipoDoc_id != 4
				AND 	NOT EXISTS (SELECT	1
								FROM	SIFLD_Timbres_Fiscales tf
								WHERE	t.Numero_Documento = tf.Numero_Documento
								AND 	t.Cadena_Id = tf.Cadena_Id);
			</cfquery>

			<!--- Valida Los Documentos --->

<!--- <cfset executionTime = getTickCount() - startTime>
<cfoutput>Execution time CFDIs: #executionTime# ms</cfoutput> --->
		<cfquery datasource="sifinterfaces">
			delete varLocalTempFiscal
		</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="setEcodigo" access="public" returntype="void" output="false">
		<cfargument name="Sistema" type="string" default="LD">
		<!--- Proceso --->
		<cfquery name="getRegistrosCadena" datasource="sifinterfaces">
			SELECT 	DISTINCT Cadena_Id
			FROM 	SIFLD_Timbres_Fiscales
			WHERE	(Ecodigo IS NULL OR Ecodigo = '')
			AND 	TipoDoc_id = 4
		</cfquery>
		<!--- Barrido de Cadenas --->
		<cfloop query="getRegistrosCadena">
			<!--- Busca equivalencia de Empresa --->
			<cfquery name="rsEmpresa" datasource="sifinterfaces">
				SELECT 	EQUidSIF, EQUcodigoOrigen
				FROM 	SIFLD_Equivalencia WHERE  SIScodigo = '#Arguments.Sistema#'
			</cfquery>
			<!--- Inserta el Ecodigo --->
			<cfquery name="rsUpdate" datasource="sifinterfaces">
				UPDATE 	SIFLD_Timbres_Fiscales
				SET 	Ecodigo   = #rsEmpresa.EQUidSIF#
				WHERE 	Cadena_Id = #rsEmpresa.EQUcodigoOrigen#
				AND 	Ecodigo   IS NULL OR Ecodigo = ''
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="setIDcontable" access="public" returntype="void" output="false">
		<!--- Proceso --->
		<cfquery name="rsTimbresSinID" datasource="sifinterfaces">
			SELECT 	Numero_Documento, RFC, Ecodigo, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, TipoDoc_id,Factura
			FROM 	SIFLD_Timbres_Fiscales
			WHERE	IDContable is null
		</cfquery>
		<cfloop query="rsTimbresSinID">
			<!--- Trae cache de empresa --->
			<cftry>
				<cfquery name="rsCache" datasource="asp">
					SELECT	c.Ccache, e.Ereferencia
					FROM	Caches c
						INNER JOIN Empresa e
						ON	c.Cid = e.Cid
						WHERE Ereferencia = #rsTimbresSinID.Ecodigo#
				</cfquery>
				<cfset varCache = rsCache.Ccache>
			<cfcatch>
				<cfset varCache = "minisif">
			</cfcatch>
			</cftry>
			<cfif rsTimbresSinID.TipoDoc_id EQ 4>
				<cfset Documento = rsTimbresSinID.Factura>
			<cfelse>
				<cfset 	Documento = rsTimbresSinID.Numero_Documento>
			</cfif>
			<!--- trae el IDContable --->
			<cfquery name="rsIDcontable" datasource="#varCache#">
				SELECT 	IDContable
				FROM 	EContables
				WHERE 	Edocbase = '#Documento#'
				UNION
				SELECT 	IDContable
				FROM 	HEContables
				WHERE 	Edocbase = '#Documento#'
			</cfquery>
			<!--- Inserta el IDContable --->
			<cfquery datasource="sifinterfaces">
				UPDATE SIFLD_Timbres_Fiscales SET IDContable = #rsIDcontable.IDContable#
				WHERE 	Numero_Documento = '#rsTimbresSinID.Numero_Documento#' AND Ecodigo = #rsTimbresSinID.Ecodigo#
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="setRepoCFDI" access="public" returntype="void" output="false">
		<!--- Proceso --->
		<cfquery name="rsTimbresCFDI" datasource="sifinterfaces">
			select Factura as Numero_Documento, Ecodigo, IDContable, Fiscal_UUID from sifinterfaces..SIFLD_Timbres_Fiscales t
			where t.Actualizar = 1 and TipoDoc_id = 4
		</cfquery>
		<cfloop query="rsTimbresCFDI">
			<!--- Trae cache de empresa --->
			<cftry>
				<cfquery name="rsCache" datasource="asp">
					SELECT	c.Ccache, e.Ereferencia
					FROM	Caches c
						INNER JOIN Empresa e
						ON	c.Cid = e.Cid
						WHERE Ereferencia = #rsTimbresSinID.Ecodigo#
				</cfquery>
				<cfset varCache = rsCache.Ccache>
			<cfcatch>
				<cfset varCache = "minisif">
			</cfcatch>
			</cftry>
			<!--- trae el IDContable --->
			<cfquery name="rsIDcontable" datasource="#varCache#">
				UPDATE 	CERepositorio
				SET 	Timbre = '#rsTimbresCFDI.Fiscal_UUID#'
				WHERE 	Ecodigo = #rsTimbresCFDI.Ecodigo#
				AND 	IdContable = #rsTimbresCFDI.IDContable#
				AND 	numDocumento = '#rsTimbresCFDI.Numero_Documento#'
			</cfquery>
			<!--- Inserta el IDContable --->
			<cfquery datasource="sifinterfaces">
				UPDATE SIFLD_Timbres_Fiscales SET IDContable = #rsIDcontable.IDContable#
				WHERE 	Numero_Documento = '#rsTimbresSinID.Numero_Documento#' AND Ecodigo = #rsTimbresSinID.Ecodigo#
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="getTimbres" access="public" returntype="query" output="false">
		<cfargument name="Documento"  type="string"  required="false"  />
		<cfargument name="Ecodigo"    type="numeric" required="false"  />
		<cfargument name="Cadena_Id"  type="numeric" required="false"  />
		<cfargument name="Fecha"  	  type="Date" 	 required="false" />
		<cfargument name="Insertado"  type="numeric" required="false" default="1,0" />

		<!--- Proceso --->
		<cfquery name="getTF" datasource="sifinterfaces">
			SELECT 	Numero_Documento, RFC, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, Factura
			FROM 	SIFLD_Timbres_Fiscales
			WHERE	1=1
			<cfif isdefined('Arguments.Documento')>
			AND 	Numero_Documento = '#Arguments.Documento#'
			<cfelseif isdefined('Arguments.Ecodigo')>
				AND 	Ecodigo = #Arguments.Ecodigo#
			<cfelseif isdefined('#Arguments.Cadena_Id#')>
				AND 	Cadena_Id = #Arguments.Cadena_Id#
			<cfelseif isdefined('#Arguments.Fecha#')>
				AND 	cast(Fiscal_FechaTimbrado as date) = cast(#Arguments.Fecha# as date)
			</cfif>
			AND Insertado IN (#Arguments.Insertado#)
		</cfquery>
		<cfreturn getTF>
	</cffunction>

	<cffunction name="updTimbreFiscal" access="public" returntype="void" output="false">
		<cfargument name="Tipo" type="string" default="C">
		<!--- Para las ventas de tipo Crédito --->
		<cfif Arguments.Tipo EQ 'C'>
			<!--- Verifica si hay timbres a actualizar --->
			<cfquery name="rsActualizar" datasource="sifinterfaces">
				SELECT 	ID_TimbresFiscales, IDContable, Numero_Documento, RFC, Cadena_Id, Ecodigo, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, Actualizar
				FROM 	SIFLD_Timbres_Fiscales
				WHERE 	Actualizar = 1
				AND 	TipoDoc_id = 4
			</cfquery>
			<!--- Trae cache de empresa --->
			<cftry>
				<cfquery name="rsCache" datasource="asp">
					SELECT	c.Ccache, e.Ereferencia
					FROM	Caches c
						INNER JOIN Empresa e
						ON	c.Cid = e.Cid
						WHERE Ereferencia = #rsActualizar.Ecodigo#
				</cfquery>
				<cfset varCache = rsCache.Ccache>
			<cfcatch>
				<cfset varCache = "minisif">
			</cfcatch>
			</cftry>
			<cfif rsActualizar.recordcount GT 0>
				<cfloop query="rsActualizar">
					<!--- Actualiza el timbre --->
					<cftry>
						<cfquery name="rsUpdRepo" datasource="#varCache#">
							UPDATE 	CERepositorio
							SET 	timbre = '#rsActualizar.Fiscal_UUID#'
							WHERE 	Ecodigo = #rsActualizar.Ecodigo#
							AND 	numDocumento = '#rsActualizar.Numero_Documento#'
						</cfquery>
					<cfcatch>
						<cf_dump var=#cfcatch.detail#>
					</cfcatch>
					</cftry>
					<cfquery name="rsMarca" datasource="sifinterfaces">
						UPDATE 	SIFLD_Timbres_Fiscales
						SET 	Actualizar = 0
						WHERE 	Ecodigo = #rsActualizar.Ecodigo#
						AND 	Numero_Documento = '#rsActualizar.Numero_Documento#'
						AND 	Actualizar = 1
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
		<cfif Arguments.Tipo NEQ 'C'>
			<!--- Verifica si hay timbres a actualizar --->
			<cfquery name="rsActualizar" datasource="sifinterfaces">
				SELECT 	ID_TimbresFiscales, IDContable, Numero_Documento, RFC, Cadena_Id, Ecodigo, TipoDoc_id, Fiscal_FechaTimbrado, Fiscal_UUID, Actualizar
				FROM 	SIFLD_Timbres_Fiscales
				WHERE 	Actualizar = 1
				AND 	TipoDoc_id != 4
			</cfquery>
			<!--- Trae cache de empresa --->
			<cftry>
				<cfquery name="rsCache" datasource="asp">
					SELECT	c.Ccache, e.Ereferencia
					FROM	Caches c
						INNER JOIN Empresa e
						ON	c.Cid = e.Cid
						WHERE Ereferencia = #rsActualizar.Ecodigo#
				</cfquery>
				<cfset varCache = rsCache.Ccache>
			<cfcatch>
				<cfset varCache = "minisif">
			</cfcatch>
			</cftry>
			<!---	<cfif rsActualizar.recordcount GT 0>
				<cfloop query="rsActualizar">
					<!--- Actualiza el timbre --->
					<cftry>
						<cfquery name="rsUpdRepo" datasource="#varCache#">
							UPDATE 	CERepositorio
							SET 	timbre = '#rsActualizar.Fiscal_UUID#'
							WHERE 	Ecodigo = #rsActualizar.Ecodigo#
							AND 	numDocumento = '#rsActualizar.Numero_Documento#'
						</cfquery>
					<cfcatch>
						<cf_dump var=#cfcatch.detail#>
					</cfcatch>
					</cftry>
					<cfquery name="rsMarca" datasource="sifinterfaces">
						UPDATE 	SIFLD_Timbres_Fiscales
						SET 	Actualizar = 0
						WHERE 	Ecodigo = #rsActualizar.Ecodigo#
						AND 	Numero_Documento = '#rsActualizar.Numero_Documento#'
						AND 	Actualizar = 1
					</cfquery>
				</cfloop>
			</cfif> --->
		</cfif>
	</cffunction>
</cfcomponent>