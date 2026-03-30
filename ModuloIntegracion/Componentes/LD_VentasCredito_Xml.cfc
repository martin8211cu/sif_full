<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--- Asigna variables de Fechas --->
		<cfif isdefined("form.fechaini") && isdefined("form.fechafin")>
			<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
			<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
		<cfelse>
			<!--- EN CASO DE NO EXISTIR FECHA, SE TOMAN 7 DIAS DE LA FECHA ACTUAL HACIA ATRAS. --->
			<cfset fechaini = createdate(YEAR(NOW() -7), MONTH(NOW() -7), DAY(NOW() -7))>
			<cfset fechafin = createdatetime(YEAR(NOW()), MONTH(NOW()), DAY(NOW()),23,59,59)>
		</cfif>

		<cfquery name="rsGetVtasCredito" datasource="ldcom">
			SELECT CONCAT(e.Fiscal_Serie, e.Fiscal_NumeroFactura) AS Factura,
			       e.Fiscal_Serie,
			       e.Fiscal_NumeroFactura,
			       CASE
			           WHEN Fiscal_Tipo_Factura = 3 THEN 'CteVale'
			           WHEN Fiscal_Tipo_Factura = 4 THEN 'CteTarjeta'
			           ELSE CONVERT(varchar(30), COALESCE(c.Cliente_CodigoExterno, e.Cliente_Id))
			       END AS Cliente_CodigoExterno,
			       CASE
			           WHEN LEN(COALESCE(x.XML_Archivo, '')) > 0 THEN x.XML_Archivo
			           ELSE
			                  (SELECT TOP 1 a.XML_Archivo
			                   FROM Factura_Fiscal_XML a
			                   INNER JOIN Factura_Fiscal_Encabezado b ON b.Fiscal_NumeroFactura = a.Fiscal_NumeroFactura
			                   AND b.Emp_Id = a.Emp_Id
			                   AND b.Suc_Id = a.Suc_Id
			                   WHERE b.Fiscal_NumeroFactura_Anula = e.Fiscal_NumeroFactura
			                     AND b.Suc_Id = e.Suc_Id
			                     AND b.Emp_Id = e.Emp_Id)
			       END AS XML_Archivo,
			       CASE
			           WHEN LEN(COALESCE(x.XML_Archivo, '')) > 0 THEN 'No'
			           ELSE 'Si'
			       END AS Anulacion,
			       CASE
			           WHEN LEN(COALESCE(x.XML_Archivo, '')) > 0 THEN e.Fiscal_FechaTimbrado
			           ELSE e.Fiscal_Fecha
			       END AS Fiscal_FechaTimbrado,
			       e.Emp_Id,
			       e.Suc_Id,
			       e.Fiscal_NumeroFactura AS ticket,
			       e.Fiscal_Total,
			       e.Fiscal_NumeroFactura_Anula
			FROM Factura_Fiscal_Encabezado e
			LEFT JOIN Factura_Fiscal_XML x ON e.Fiscal_NumeroFactura = x.Fiscal_NumeroFactura
			AND e.Emp_Id = x.Emp_Id
			AND e.Suc_Id = x.Suc_Id
			LEFT JOIN Cliente c ON c.Emp_Id = e.Emp_Id
			AND c.Cliente_Id = e.Cliente_Id
			WHERE e.Fiscal_Estado = 'NO'
			  AND e.Fiscal_Tipo IN (1, 2)
			  AND e.Fiscal_Tipo_Factura IN (1, 3, 4)
			  AND ((LEN(COALESCE(x.XML_Archivo, '')) = 0
			        AND e.Fiscal_Fecha BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value='#fechaini#'> AND <cfqueryparam cfsqltype="cf_sql_date" value='#fechafin#'>)
			       OR (LEN(COALESCE(x.XML_Archivo, '')) > 0
			           AND e.Fiscal_FechaTimbrado BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value='#fechaini#'> AND <cfqueryparam cfsqltype="cf_sql_date" value='#fechafin#'>))
			ORDER BY e.Fiscal_NumeroFactura ASC
		</cfquery>

		<cfset CompVentaCred = createObject('component', '/WS/IntegracionVentas/WsGetVentaCredito')>

		<!--- DISTINCT POR EMPRESA --->
		<cfquery name="rsGetEmpresaId" dbtype="query">
			SELECT DISTINCT Emp_Id
			FROM rsGetVtasCredito
		</cfquery>

		<!--- ITERACION POR EMPRESA --->
		<cfloop query="rsGetEmpresaId">
			<cfset Equiv = ConversionEquivalencia ("LD", 'CADENA', rsGetEmpresaId.Emp_Id, rsGetEmpresaId.Emp_Id, 'Cadena')>
			<cfset varEcodigo 	 = Equiv.EQUidSIF>

			<!--- DOCUMENTOS EXISTENTES --->
			<cfquery name="rsEncVtasExist" datasource="sifinterfaces">
				SELECT DISTINCT TOP 8000
				 		RTRIM(LTRIM(Numero_Documento)) AS Numero_Documento,
                       	Fecha_Inclusion
				FROM ESIFLD_Facturas_Venta
				WHERE Tipo_Venta = 'C'
				  AND Numero_Documento NOT LIKE 'V-%'
				GROUP BY Numero_Documento,
				         Fecha_Inclusion
				ORDER BY Fecha_Inclusion DESC
			</cfquery>

			<!--- SOLO SE QUEDAN LOS DOCUMENTO QUE NO ESTÁN EN ESIFLD_Facturas_Venta --->
			<cfquery name="rsGetFacCredEmp" dbtype="query">
				SELECT DISTINCT * FROM
				rsGetVtasCredito
				<cfif rsEncVtasExist.RecordCount GT 0>
				WHERE Factura NOT IN (
					<cfloop query="rsEncVtasExist">
						<cfif rsEncVtasExist.CurrentRow NEQ rsEncVtasExist.RecordCount>
							'#TRIM(rsEncVtasExist.Numero_Documento)#',
						<cfelse>
							'#TRIM(rsEncVtasExist.Numero_Documento)#'
						</cfif>
					</cfloop>
				)
				</cfif>
			</cfquery>

			<!--- EXTRACCION Y PROCESAMIENTO DE VENTAS UNA POR UNA --->
			<cfloop query="rsGetFacCredEmp">
				<!--- Parseado de XML --->
				<cfset xmltimbrado = XmlParse(XML_Archivo)>
				<cfset headAtt = xmltimbrado["cfdi:Comprobante"].XmlAttributes>
				<cfset lvarTotal = headAtt.Total>
				<cfset lVarContinue = true>

				<!--- PREVENTA --->
				<!--- <cfinvoke component="WS.IntegracionVentas.WsGetVentaCredito" method="PreVenta" returnvariable="objResultP">
					<cfinvokeargument name="Emp_id" value="#Emp_Id#"/>
					<cfinvokeargument name="Suc_id" value="#Suc_id#"/>
					<cfinvokeargument name="Cliente_CodigoExterno" value="#Cliente_CodigoExterno#"/>
					<cfinvokeargument name="Ticket" value="#ticket#"/>
		            <cfinvokeargument name="Monto" value="#lvarTotal#"/>
		            <cfinvokeargument name="token" value="NA"/>
				</cfinvoke>
				<cfif isDefined("objResultP") AND isdefined("objResultP.Resultado") AND #objResultP.Resultado# EQ false>
					<cflog file="Log_VtasCxC_Por_Xml" application="no" text="ERROR: #objResultP.mensaje# [Factura #ticket#]">
					<cfset lVarContinue = false>
				</cfif> --->

				<!--- RECIBE VENTA --->
				<cfinvoke component="WS.IntegracionVentas.WsGetVentaCredito" method="RecibeVenta" returnvariable="objResult">
					<cfinvokeargument name="Emp_id" value="#Emp_Id#"/>
					<cfinvokeargument name="Suc_id" value="#Suc_id#"/>
					<cfinvokeargument name="Cliente_CodigoExterno" value="#Cliente_CodigoExterno#"/>
					<cfinvokeargument name="Ticket" value="interface"/>
		            <cfinvokeargument name="Xml" value="#XML_Archivo#"/>
		            <cfinvokeargument name="token" value="NA"/>
		            <cfif isdefined("Anulacion") AND #Anulacion# EQ "Si">
			            <cfinvokeargument name="Anulacion" value="true"/>
			            <cfinvokeargument name="Fiscal_Serie" value="#Fiscal_Serie#"/>
			            <cfinvokeargument name="Fiscal_NumeroFactura" value="#Fiscal_NumeroFactura#"/>
					</cfif>
				</cfinvoke>
				<cfif isDefined("objResult") AND isdefined("objResult.Resultado") AND #objResult.Resultado# EQ false>
					<cflog file="Log_VtasCxC_Por_Xml" application="no" text="ERROR: #objResult.mensaje# [Factura #ticket#]">
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
</cfcomponent>