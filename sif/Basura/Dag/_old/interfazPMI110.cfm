<!--- INICIO Encabezado de Pruebas --->
<cfinclude template="../../Application.cfm">
<title>insert into OD110</title>
<!--- FINAL Encabezado de Pruebas --->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(110, url.ID)>
<!--- Parámetros Requeridos --->
<cfparam name="url.ID" type="numeric">
<cfparam name="url.CXTcodigo" type="string">
<cfparam name="url.Ddocumento" type="string">
<cfparam name="url.SNcodigo" type="numeric">
<cfparam name="url.MODULO" type="string">
<cfparam name="url.MODO" type="string">
<cfset session.debug = false>
<cfif isdefined("url.debug") and (url.debug eq 1 or url.debug eq true or url.debug)>
	<cfset session.debug = true>
</cfif>
<!--- Valida Parámetros de entrada --->
<cfquery name="rsid_vexists" datasource="sifinterfaces">
	select 1 from OE110 where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">
</cfquery>
<cfif rsid_vexists.Recordcount GT 0>
	<!--- (Intento de Reprocesar) --->
	<cfthrow message="Error en interfaz PMI 110, Intercambio de Información de Documentos de CXC y CXP, EL proceso ya fué ejecutado anteriormente, Proceso Cancelado!">
</cfif>
<cfif not url.MODO EQ 'R'>
	<cfthrow message="Error en interfaz PMI 110, Intercambio de Información de Documentos de CXC y CXP, Modo inválido, Proceso Cancelado!">
</cfif>
<cfif not (url.MODULO EQ 'CC' or url.MODULO EQ 'CP')>
	<cfthrow message="Error en interfaz PMI 110, Intercambio de Información de Documentos de CXC y CXP, Modulo inválido, Proceso Cancelado!">
</cfif>
<cfif url.MODULO EQ 'CC'>
	<cfquery name="rsedr_vexists" datasource="#Session.Dsn#">
		select *
		from Documentos d
		where d.Ecodigo      	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and d.CCTcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CXTcodigo#">
			  and d.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ddocumento#">
	</cfquery>
<cfelse>
	<cfquery name="rsedr_vexists" datasource="#Session.Dsn#">
		select *
		from EDocumentosCP d
		where d.SNcodigo 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			  and d.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ddocumento#">
			  and d.CPTcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CXTcodigo#">
			  and d.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
<cfif rsedr_vexists.Recordcount EQ 0>
	<!--- (Error de datos en la Cola) --->
	<cfthrow message="Error en interfaz PMI 110, Intercambio de Información de Documentos de CXC y CXP, Documento no está definido en Módulo, Proceso Cancelado!">
</cfif>
<!--- Consulta Principal: De esta consulta se obtienen los datos para las operaciones. --->
<cfset Lvar_ECodigoExterno = "">
<cfquery name="rsEcodigoExterno" datasource="sifinterfaces"> 
	select ECodigoExterno
	from InterfazEmpresa
	where Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset Lvar_ECodigoExterno = rsEcodigoExterno.ECodigoExterno>
<cfif not IsNumeric(Lvar_ECodigoExterno)>
	<cfthrow message="Error en interfaz PMI 110, Intercambio de Información de Documentos de CXC y CXP, El numero de Empresa Externo en la tabla Interfaz Empresa es Inválido, Proceso Cancelado!">
</cfif>
<cftransaction>
	<cfif url.MODULO EQ 'CC'>
		<cfquery datasource="#Session.dsn#">
			insert sif_interfaces..OE110 (	ID, contraparte_id, compania_prop_id, concepto_id, llave_soin_tbs, fecha_vencimiento, monto, iva, 
							retencion, pago_cobro, aux_origen, tipo_documento, usuario_creacion, moneda, documento, nombre_largo, 
							comentarios, BMUsucodigo)
			select #url.ID#, 					<!---  Numero de la Interfaz --->
				convert(int, sn.SNcodigoext),     													<!---  Codigo externo de socio de negocios --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ECodigoExterno#">, <!---  Codigo de la empresa en los parámetros del motor de interfaz --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ECodigoExterno#">, <!---  Codigo de concepto (revisar la definicion) --->
				d.Dreferencia,                           											<!---  Numero interno del documento --->
				coalesce(d.Dvencimiento, d.Dfecha),                  								<!---  Fecha de Vencimiento --->
				d.Dtotal,                       <!---  Monto total del documento --->
				round(d.Dtotal*coalesce(i.Iporcentaje,0),2),	<!---  Monto del impuesto de la factura --->
				0.00,                           <!---  Monto de la retención (revisar como se obtendría) --->
				'R',                            <!---  Indica que es un cobro en el sistema TBS --->
				'CC',                           <!---  Codigo del sistema origen para TBS --->
				d.CCTcodigo,                    <!---  Tipo de documento de la factura --->
				d.Dusuario,                     <!---  Usuario de creación del documento --->
				m.Miso4217,                     <!---  Codigo ISO de la moneda del documento --->
				d.Ddocumento,                   <!---  Numero del Documento --->
				sn.SNnombre,                    <!---  Nombre del Socio de Negocios --->
				convert(varchar, d.Dreferencia),<!---  Referencia en el documento --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from Documentos d
				inner join SNegocios sn
					on sn.Ecodigo  = d.Ecodigo
			  		and sn.SNcodigo = d.SNcodigo
				inner join Monedas m
					on m.Ecodigo   = d.Ecodigo
					and m.Mcodigo  = d.Mcodigo
				left outer join Impuestos i
					on i.Ecodigo   = d.Ecodigo
					and i.Icodigo  = d.Icodigo
			where d.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and d.CCTcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CXTcodigo#">
			  and d.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ddocumento#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.dsn#">
			insert sif_interfaces..OE110 (	ID, contraparte_id, compania_prop_id, concepto_id, llave_soin_tbs, fecha_vencimiento, monto, iva, 
							retencion, pago_cobro, aux_origen, tipo_documento, usuario_creacion, moneda, documento, nombre_largo, 
							comentarios, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ID#">, 					<!---  Numero de la Interfaz --->
				convert(int, sn.SNcodigoext),     													<!---  Codigo externo de socio de negocios --->
				convert(int, <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_ECodigoExterno#">), <!---  Codigo de la empresa en los parámetros del motor de interfaz --->
				convert(int, <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_ECodigoExterno#">), <!---  Codigo de concepto (revisar la definicion) --->
				d.IDdocumento,                           											<!---  Numero interno del documento --->
				coalesce(d.Dfechavenc, d.Dfecha),                  								<!---  Fecha de Vencimiento --->
				d.Dtotal,                       <!---  Monto total del documento --->
				round(d.Dtotal*coalesce(i.Iporcentaje,0),2),	<!---  Monto del impuesto de la factura --->
				0.00,                           <!---  Monto de la retención (revisar como se obtendría) --->
				'P',                            <!---  Indica que es un cobro en el sistema TBS --->
				'CP',                           <!---  Codigo del sistema origen para TBS --->
				d.CPTcodigo,                    <!---  Tipo de documento de la factura --->
				d.EDusuario,                    <!---  Usuario de creación del documento --->
				m.Miso4217,                     <!---  Codigo ISO de la moneda del documento --->
				d.Ddocumento,                   <!---  Numero del Documento --->
				sn.SNnombre,                    <!---  Nombre del Socio de Negocios --->
				d.EDdocref,                  	<!---  Referencia en el documento --->
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from EDocumentosCP d
				inner join SNegocios sn
					on sn.Ecodigo  = d.Ecodigo
			  		and sn.SNcodigo = d.SNcodigo
				inner join Monedas m
					on m.Ecodigo   = d.Ecodigo
					and m.Mcodigo  = d.Mcodigo
				left outer join Impuestos i
					on i.Ecodigo   = d.Ecodigo
					and i.Icodigo  = d.Icodigo
			where d.SNcodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			  and d.Ddocumento   = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ddocumento#">
			  and d.CPTcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#url.CXTcodigo#">
			  and d.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
	<cfif session.debug>
		<cfquery name="rsdebug" datasource="#session.dsn#">
			select * from sif_interfaces..OE110
		</cfquery>
		<cfdump var="#rsdebug#">
		<cftransaction action="rollback"/>
		<cfabort>
	</cfif>
</cftransaction>
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(110, url.ID)>