<cfinclude template="FnScripts.cfm">
<cftransaction>
	<cftry> 
	<cfif isdefined('ProcesarGUI')> <cfset progress = 0><cfset progressB(progress,'Starting')> </cfif>

	<cfif isdefined('ProcesarGUI')> <cfset progress += 2><cfset progressB(progress,'Retrieving Data')> </cfif>
 
		<!--- se agrupa calendario de pago para buscar el identficador de pago en la tabla de transaccion --->
		<cfquery name="qCalendarioPagos" datasource="#session.dsn#">
			select i.IdentificadorTransaccion  
			from #table_name#  i
			where not exists (select 1 
				             from CRCTransaccion t
				             where t.Descripcion like '%<<' + i.IdentificadorTransaccion + '>>%')
			group by i.IdentificadorTransaccion  
		</cfquery> 
		
  
		<cfif qCalendarioPagos.recordCount gt 0>
			<cfset loc.transacciones = ''>
			<cfloop query="qCalendarioPagos">
				<cfset loc.transacciones =  qCalendarioPagos.IdentificadorTransaccion & "," & loc.transacciones >
			</cfloop>

			<cfthrow message="No existen una transaccion para asociar al calendario de pago. Identificador de transaccion a  importar:#loc.transacciones#">

		<cfelse>

			<cfset CRCCortesImportacion = createObject("component","crc.administracion.importadores.componentes.CRCCortesImportacion")>
			<cfset CRCCortesImportacion.init(DSN=#session.DSN#, Ecodigo=#SESSION.ECodigo#)>		
				
 
			<cfquery name="qTransacciones" datasource="#session.dsn#">
	  			select t.id, t.descripcion, c.Tipo, t.TipoTransaccion, t.Parciales, c.SNegociosSNid
	  			from  CRCTransaccion t
	  			inner join CRCCuentas c
	  				on c.id = t.CRCCuentasid
				where (t.TipoTransaccion = 'TC'
					or    t.TipoTransaccion = 'VC'
					or    t.TipoTransaccion = 'GC'
					or    t.TipoTransaccion = 'IN'
					or    t.TipoTransaccion = 'PG'
					or    t.TipoTransaccion = 'TM')
				  	and exists (select 1 
				             from #table_name# i
				             where t.Descripcion like '%<<' + i.IdentificadorTransaccion + '>>%')
  			</cfquery>		

  			<cfloop query="qTransacciones">


  				<cfif isdefined('ProcesarGUI')> 
					<cfset countR = progress>
					<cfset total = qTransacciones.recordCount + 5>
					<cfset progressB(progress,'calendario de pagos')>
				</cfif>

  				<!--- se buscan los calendarios de la transaccion--->
				<cfset desScruct = REFind("<<(.*)>>",qTransacciones.Descripcion,1,true,"one")> 
				
				<cfif ArrayLen(desScruct.match) gt 1>
					<cfset transactionID = #desScruct.match[2]#> 

					<cfset loc.i = 1>
					<cfquery name="qCalendarioPagos" datasource="#session.dsn#">
						select 
							case when DATEPART(dw,FechaParcialidad) = (select Pvalor from CRCParametros where Pcodigo = '30001455' and Ecodigo = #Session.Ecodigo#) 
								then DATEADD(d,-1,FechaParcialidad) 
								else FechaParcialidad
							end  FechaParcialidad,
							MontoRequerido,
							MontoaPagar,
							Pagado,
							Intereses,
							SaldoVencido,
							Condonaciones							
						from #table_name# 
						where  IdentificadorTransaccion = '#transactionID#'
						order by FechaParcialidad asc
					</cfquery>  

					<cfloop query="qCalendarioPagos"> 
						<cfset loc.corteCP = CRCCortesImportacion.obtenerCorte(fecha='#qCalendarioPagos.FechaParcialidad#', 
																	   SNid=#qTransacciones.SNegociosSNid#,
																	   tipoProducto=#qTransacciones.Tipo#)>  
						<cfif loc.corteCP eq "" > 
							<cfset loc.corteCP = CRCCortesImportacion.process(fecha='#qCalendarioPagos.FechaParcialidad#',
																		  tipoTransaccion=#qTransacciones.TipoTransaccion#,
																		  parcialidades=#qTransacciones.Parciales#, 
																		  SNid=#qTransacciones.SNegociosSNid#,
																		  tipoProducto=#qTransacciones.Tipo#)>
						</cfif>	

						<!---cfset CRCCortesImportacion.updateCorteStatus(corte='#loc.corteCP#'  ) --->
						<cfset loc.status = 0>
						<cfquery name="queryCorte" datasource="#session.dsn#"> 
							select Codigo, status
							from CRCCortes
							where Codigo = '#loc.corteCP#'
						</cfquery>	

						<cfif queryCorte.recordCount gt 0>
							<cfset loc.status = #queryCorte.status#>
						</cfif>		


						<cfquery datasource="#session.dsn#">
		  			
							INSERT INTO CRCMovimientoCuenta
							           (CRCTransaccionid
							           ,TipoMovimiento
							           ,Corte
							           ,MontoRequerido
							           ,MontoAPagar
							           ,Descuento
							           ,Pagado
							           ,Intereses
							           ,PorcientoDescuento
							           ,SaldoVencido
							           ,Condonaciones
							           ,Descripcion
							           ,Ecodigo 
							           ,status)  
							VALUES(#qTransacciones.ID#,
							       'C',
							        '#loc.corteCP#',
							       #qCalendarioPagos.MontoRequerido#,
							       #qCalendarioPagos.MontoaPagar#,
							       0,
							       #qCalendarioPagos.Pagado#,
							       #qCalendarioPagos.Intereses#,
							       0,
							       #qCalendarioPagos.SaldoVencido#,
							       #qCalendarioPagos.Condonaciones#,
							       '(#loc.i#/#qTransacciones.Parciales#) #qTransacciones.Descripcion#',
							       #session.Ecodigo#, 
							       #loc.status#
						       )		
						</cfquery> 


						<cfset loc.i = loc.i + 1>

					</cfloop> 

				</cfif>


  			</cfloop>	

			 <cfset CRCCortesImportacion.updateCorteCerrado()>

  
 		</cfif>
	 

		<cfif isdefined('ProcesarGUI')> <cfset progress = 100>
			<cfset progressB(progress,'Finish')> <cfset session.progressE = true>
		</cfif>
 
	<cfcatch type="Database">
		<cftransaction action="rollback">
		<cfscript> 
		sbError ("FATAL", "#cfcatch.cause.message#");
		</cfscript> 
		<cfset ERR = fnVerificaErrores()>
	</cfcatch>    
	<cfcatch type="any">
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