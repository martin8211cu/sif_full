<!--- Archivo    :  SQLAplicaSeguros.cfm --->
<cfquery name="rsProductoP" datasource="sifinterfaces">
	select distinct Almacen,Alm_Aid,title_tran_date,sessionid
	from #session.Dsource#RecProdTranPMI
	where mensajeerror is null 
	and sessionid = #session.monitoreo.sessionid#
	group by Almacen,title_tran_date
	order by Almacen,title_tran_date
</cfquery>
<cfif rsProductoP.recordcount GT 0>
	<cfloop query="rsProductoP"> 
		<cfset ws_GeneraEnc = true>
		<cfset rp_Almacen = rsProductoP.Alm_Aid>
		<cfset rp_FechaCambio = rsProductoP.title_tran_date>
		<cfquery name="rsProducto" datasource="sifinterfaces">
			select distinct fecharegistro,sessionid,Ecodigo,OCItipoOD,OCIfecha,Alm_Aid,
			OCIobservaciones,OCid,OCTid,Aid,BMUsucodigo,sum(Volumen) as Volumen
			from RecProdTranPMI
			where mensajeerror is null 
				and sessionid = #session.monitoreo.sessionid#
				and Alm_Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProductoP.Alm_Aid#">
				and title_tran_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsProductoP.title_tran_date#">
			group by Almacen,title_tran_date,Compra,Producto
			order by Almacen,title_tran_date
		</cfquery>
		<cfif rsProducto.recordcount GT 0>	
			<cfloop query="rsProducto">
				<cftransaction>
					<cfif ws_GeneraEnc>
						<!--- Graba en tabla OCinventario el Encabezado del Documento  --->
						<cfquery name="rsNumero"datasource="#session.dsn#">
							select coalesce(max(OCInumero),0) +1 as OCInumero
							 					from OCinventario
												where Ecodigo = #rsProducto.Ecodigo#
												and OCItipoOD = 'D'
						</cfquery>
						<cfset rp_OCInumero = rsNumero.OCInumero>
						<cfquery datasource="#session.dsn#">
							insert into OCinventario (Ecodigo,OCItipoOD,OCIfecha,
														Alm_Aid,OCIobservaciones,BMUsucodigo,OCid, OCInumero)
							values(#rsProducto.Ecodigo#,'#rsProducto.OCItipoOD#',
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsProducto.OCIfecha#">,
							 #rsProducto.Alm_Aid#,'#rsProducto.OCIobservaciones#',#rsProducto.BMUsucodigo#,
							 #rsProducto.OCid#, #rp_OCInumero#)
						</cfquery>
						<cfquery name="rsVerifica" datasource="#session.dsn#">
							select MAX(OCIid) as valorID
							from OCinventario
						</cfquery>
						<cfset vOCIid = rsVerifica.valorID>
					</cfif>
					<cfset ws_GeneraEnc = false>
					<cfquery datasource="#session.dsn#">
						insert into OCinventarioProducto (OCIid,OCTid,Aid,OCIcantidad,OCIcostoValuacion,BMUsucodigo)
						values(#vOCIid#,#rsProducto.OCTid#,#rsProducto.Aid#,#rsProducto.Volumen#,0,#rsProducto.BMUsucodigo#)
					</cfquery>
				</cftransaction>
			</cfloop> <!--- Cierra lopp rsProducto --->
<!---<cfabort showerror="Debio Agregar 1"> --->
  		</cfif>
	</cfloop> <!--- Cierra lopp rsProductoP --->
</cfif>

<!---
<cfquery name="DebugE" datasource="#session.dsn#">
	select * from EContablesImportacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery name="DebugD" datasource="#session.dsn#">
	select * from DContablesImportacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery name="Debug" datasource="sifinterfaces">
	select * from #session.Dsource#segurosPMI a where ExisteOrden is null and sessionid = #session.monitoreo.sessionid# 
</cfquery>
<cfquery name="Debug2" datasource="sifinterfaces">
	select count(distinct OCidCompra) as cuenta,* from #session.Dsource#segurosVentasPMI where sessionid = #session.monitoreo.sessionid# group by sessionid
</cfquery>
<cfquery name="Debug3" datasource="sifinterfaces">
	select * from #session.Dsource#segurosArticulosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfdump var="#session.FechaFolio#" label = "Salida">
<cfdump var="#DebugE#" label = "Salida">
<cfdump var="#DebugD#" label = "Salida">
<cfdump var="#Debug#" label = "Salida">
<cfdump var="#Debug2#" label = "Salida">
<cf_dump var="#Debug3#" label = "Salida2">
--->