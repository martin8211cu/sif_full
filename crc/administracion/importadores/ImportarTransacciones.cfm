<cfinclude template="FnScripts.cfm">

<cftransaction>
	<cftry>
		<!---  se busca la fecha minima y maxima de todas las transacciones de tipo compra
			   con estas dos fechas se mandan a generar los cortes en esos periodos y parcialidades de la transaccion ---->
		<cfif isdefined('ProcesarGUI')> <cfset progress = 0><cfset progressB(progress,'Starting')> </cfif>
		<cfif isdefined('ProcesarGUI')> <cfset progress += 1><cfset progressB(progress,'Retriving rows')> </cfif>
		
		<cfquery  name="rsImportador" datasource="#session.dsn#">
			update #table_name# 
			set NumerodeTarjeta = replace(NumerodeTarjeta,' ','')
		</cfquery>

		<cfquery name="qTransaccionDuplicada" datasource="#session.dsn#">
			select i.IdentificadorTransaccion , count(i.IdentificadorTransaccion) cantidad
			from #table_name#  i
			group by i.IdentificadorTransaccion  
			having count(i.IdentificadorTransaccion) > 1
		</cfquery> 
  
		<cfif qTransaccionDuplicada.recordCount gt 0>
			<cfset loc.transacciones = ''>
			<cfloop query="qTransaccionDuplicada">
				<cfset loc.transacciones =  listAppend(loc.transacciones, "#qTransaccionDuplicada.IdentificadorTransaccion#:#qTransaccionDuplicada.cantidad#")>
			</cfloop>

			<cfthrow message="Existen Transacciones duplicadas #loc.transacciones#">
		</cfif>

		<cfquery name="qTransCompra" datasource="#session.dsn#">
			select i.IdentificadorTransaccion, i.FechadeTransaccion, i.FechaInicioPago, i.Parcialidades, i.CodigoTipoTransaccion, sn.SNid,
			       c.Tipo
			from #table_name# i
			inner join CRCCuentas c
			on c.Numero  = i.NumerodeCuenta 
			inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid  
			where CodigoTipoTransaccion  = 'VC' 
			or    CodigoTipoTransaccion  = 'TC' 
			or    CodigoTipoTransaccion  = 'TM' 
			or    CodigoTipoTransaccion  = 'PG' 
			or    CodigoTipoTransaccion  = 'GC' 
			or    CodigoTipoTransaccion  = 'IN' 
		</cfquery>

		<cfif isdefined('ProcesarGUI')> <cfset progress += 1><cfset progressB(progress,'Retriving codigo cortes')> </cfif>
		

		<cfif qTransCompra.recordCount gt 0>

			<cfif isdefined('ProcesarGUI')> 
				<cfset countR = progress>
				<cfset total = qTransCompra.recordCount + 5>
				<cfset progressB(progress,'Set tipo transaccion')>
			</cfif>
		
			<cfset CRCCortesImportacion = createObject("component","crc.administracion.importadores.componentes.CRCCortesImportacion")> 
			<cfset CRCCortesImportacion.init(DSN=#session.DSN#, Ecodigo=#SESSION.ECodigo#)>		
			
			<cfloop query="qTransCompra">
				
				<cftry>
					<cfset CRCCortesImportacion.process(fecha='#qTransCompra.FechadeTransaccion#',
														tipoTransaccion=#qTransCompra.CodigoTipoTransaccion#,
														parcialidades=#qTransCompra.Parcialidades#, 
														SNid=#qTransCompra.SNid#,
														tipoProducto=#qTransCompra.Tipo#)>
				<cfcatch type="any">
					<cfthrow message="IdentificadorTransaccion: #qTransCompra.IdentificadorTransaccion# Error: #cfcatch.message#">
				</cfcatch>
				</cftry>

	 			
				<cfif isdefined('ProcesarGUI')> 
					<cfset countR += 1>
					<cfset progress = numberFormat((countR * 100)/total,"0")>
					<cfset progressB(progress,'Set tipo transaccion')>
				</cfif>

			</cfloop>	

		<cfif isdefined('ProcesarGUI')> <cfset progress += 1><cfset progressB(progress,'Update Corte in Transaction')> </cfif>
		 
 		
 		<cfset CRCCortesImportacion.updateCorteStatus()>
		<cfset CRCCortesImportacion.updateCorteCerrado()>
 		
		
		<cfif isdefined('ProcesarGUI')> <cfset progress += 1><cfset progressB(progress,'Creating new transactions')> </cfif>
		 



		<!--- se insertan las tarnsaccione--->
		<cfquery datasource="#Session.DSN#" name="rsInsTran">
			 INSERT INTO CRCTransaccion(
						CRCCuentasid
			           ,CRCTipoTransaccionid
			           ,CRCTarjetaid
			           ,Fecha
			           ,Monto
			           ,TipoTransaccion
			           ,Tienda
			           ,Ticket
			           ,Folio
			           ,Cliente
			           ,Observaciones
			           ,Parciales
			           ,FechaInicioPago
			           ,Ecodigo
			           ,CURP 
			           ,TipoMov
			           ,afectaSaldo
			           ,afectaInteres
			           ,afectaCompras
			           ,afectaPagos
			           ,afectaCondonaciones
			           ,afectaGastoCobranza 
			           ,Descripcion
			           ,cadenaEmpresa
			           ,sucursal
			           ,caja 
			           ,Descuento
			           ,afectaSeguro
					   ,TiendaExt)
					    select c.id,
							    tt.id,
							    tc.id,
							    i.FechadeTransaccion,
							    i.Monto,
							    i.CodigoTipoTransaccion,
							    i.Tienda,
							    i.Ticket,
							    i.Folio, 
							    i.Cliente,
							    i.Observaciones,
							    i.Parcialidades,
							    i.FechaInicioPago,
							    #session.Ecodigo#,
							    i.CURP,
							    i.TipoMovimiento,
							    tt.afectaSaldo,
							    tt.afectaInteres,
							    tt.afectaCompras,
							    tt.afectaPagos,
							    tt.afectaCondonaciones,
							    tt.afectaGastoCobranza,
							    tt.Descripcion + '<<' + i.IdentificadorTransaccion  + '>>',
							    i.Cadena,
							    i.Sucursal,
							    i.Caja, 
							    0,
							    tt.afectaSeguro,
								case when i.Codigo_TiendaExt != '0' then  i.Codigo_TiendaExt else null end 
					    from #table_name# i
					    inner join CRCCuentas c
					    on i.NumerodeCuenta = c.Numero
					    inner join CRCTipoTransaccion tt
					    on i.CodigoTipoTransaccion = tt.Codigo
					    left join CRCTarjeta tc
					    on tc.Numero = i.NumerodeTarjeta
					    and not exists( select 1 
					    			    from  CRCTransaccion
					    			    where tt.Descripcion like '%<<'+ i.IdentificadorTransaccion +'>>%')
					  		
       </cfquery>
	  	<cfif isdefined('ProcesarGUI')> <cfset progress = 100><cfset progressB(progress,'Finish')> <cfset session.progressE = true></cfif> 
    </cfif>
	<cfcatch>
		<cftransaction action="rollback">
		<cfscript> 
			sbError ("FATAL", "#cfcatch.message#");
		</cfscript> 
		<cfset ERR = fnVerificaErrores()>
	</cfcatch>    
</cftry>

</cftransaction>


<cffunction  name="progressB">
	<cfargument  name="value">
	<cfargument  name="msg">
	<cfset session.progressB = arguments.value>
	<cfset session.progressM = arguments.msg>
</cffunction>
