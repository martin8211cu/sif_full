<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="rsEOrdenCM" datasource="#session.DSN#">
		select  
			a.EOnumero,
			b.SNidentificacion,
			b.SNnombre,
			m.Miso4217,
			a.EOtc,
			a.fechamod,
			a.EOtotal
			
			from EOrdenCM a
			inner join SNegocios b
				on b.SNcodigo=a.SNcodigo
			inner join Monedas m
				on a.Mcodigo= m.Mcodigo 
		 where a.EOidorden =  #url.EOidorden# 
		 and b.Ecodigo=#session.Ecodigo# 
</cfquery>

<cfquery name="rsDOrdenCM" datasource="#session.DSN#">
		select  
		 distinct 
			s.OBPcodigo,
			a.EOnumero,
			a.DOconsecutivo,
			d.COItemClave,
			a.DOdescripcion,
			c.COItemCCantidad,
			c.COItemCPrecio,
			d.COItemUnidad,  
			(round(c.COItemCCantidad*c.COItemCPrecio,2)) as importe
			
			from DOrdenCM a
			inner join OBobra o
				on o.OBPid=a.OBOid
			inner join OBproyecto s
				on o.OBPid=s.OBPid
			inner join DCotizacionesCM b
				on b.DSlinea=a.DSlinea
			
			inner join COItemsCotizacion c
				on c.DClinea=b.DClinea
			inner join COItemsSigepro d
				on d.COItemId=c.COItemId
			where a.EOidorden =  #url.EOidorden#
			and a.Ecodigo=#session.Ecodigo# 
</cfquery>

<cfset LvarEOtotal=#NumberFormat(rsEOrdenCM.EOtotal,'9.99')#>
<cfset LvarImporteTotalLinea=0>

<cfloop query="rsDOrdenCM" >
	<cfset LvarImporteTotalLinea+=#rsDOrdenCM.importe#>
</cfloop>

<!---<cfthrow message="#LvarEOtotal# **  #LvarImporteTotalLinea#">--->

<!---Valida q los totales esten iguales sino no realiza ninguna acción--->
<cfif #LvarImporteTotalLinea# eq #LvarEOtotal#>

<cfquery datasource="sifinterfaces">
	insert into IE305
	(
	ID,
	CANTIDAD_DOCUMENTOS,
	IMPORTE_TOTAL
	)
	values(
	#GvarID#,
	1,
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEOrdenCM.EOtotal#"> 		
	)	
</cfquery>

<cftransaction>
		<cfquery datasource="sifinterfaces">
			insert into ID305
			(
			ID,
			CODIGO_PROYECTO,
			CODIGO_CONTRATO_OC,
			IDENTIFICADOR_PROVEEDOR,
			NOMBRE_PROVEEDOR,
			MONEDA,
			TIPO_DE_CAMBIO,
			FECHA_ADJUDICACION,
			IMPORTE_TOTAL
			)
			values(
			#GvarID#,
			'#rsDOrdenCM.OBPcodigo#',
			#rsEOrdenCM.EOnumero#,
			'#rsEOrdenCM.SNidentificacion#',
			'#rsEOrdenCM.SNnombre#',
			'#rsEOrdenCM.Miso4217#',
			#rsEOrdenCM.EOtc#,
			<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsEOrdenCM.fechamod#"> ,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEOrdenCM.EOtotal#">
			)	
		</cfquery>
</cftransaction>

<cftransaction>
	<cfloop query="rsDOrdenCM">
		<cfquery datasource="sifinterfaces">
			insert into IS305
			(
			ID,
			CODIGO_PROYECTO,
			CODIGO_CONTRATO_OC,
			LINEA_CONTRATO_OC, 
			CLAVE_ITEM,        
			DESCRIPCION,       
			CANTIDAD,          
			PRECIO_UNITARIO,   
			UNIDAD_MEDIDA,     
			IMPORTE_LINEA
			)
			values(
			#GvarID#,
			'#rsDOrdenCM.OBPcodigo#',
			#rsEOrdenCM.EOnumero#,
			#rsDOrdenCM.DOconsecutivo#,
			'#rsDOrdenCM.COItemClave#',
			'#rsDOrdenCM.DOdescripcion#',
			#rsDOrdenCM.COItemCCantidad#,
			#rsDOrdenCM.COItemCPrecio#,
			'#rsDOrdenCM.COItemUnidad#',
			#rsDOrdenCM.importe#
			)	
		</cfquery>
	</cfloop>
</cftransaction>
<cfelse>
	<cfthrow message="La Orden de Compra tiene un importe total de : #LvarEOtotal# el cual es diferente del total del importe por lineas : #LvarImporteTotalLinea#">
</cfif>