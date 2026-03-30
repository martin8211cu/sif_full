<cfinclude template="FnScripts.cfm">
<cfif isdefined('ProcesarGUI')> <cfset progress = 5><cfset progressB(progress,'Starting')> </cfif>

<cftransaction>
	<cftry> 

		<cfquery name="qMCC" datasource="#Session.DSN#"> 
			select i.*, c.SNegociosSNid, c.Tipo, c.id as cuentaID from #table_name# i
			inner join CRCCuentas c
		    on i.NumeroCuenta = c.Numero
		</cfquery>


		<cfset CRCCortesImportacion = createObject("component",
										"crc.administracion.importadores.componentes.CRCCortesImportacion")>
		<cfset CRCCortesImportacion.init(DSN=#session.DSN#, Ecodigo=#SESSION.ECodigo#)>	


		<cfloop query="qMCC">
 
			<cfset loc.corteCP = CRCCortesImportacion.process(fecha='#qMCC.FechaCorte#',
										tipoTransaccion=#qMCC.Tipo#,
										parcialidades=1, 
										SNid=#qMCC.SNegociosSNid#,
										tipoProducto=#qMCC.Tipo#)>


				<cfset CRCCortesImportacion.updateCorteStatus(corte='#loc.corteCP#')>
				<cfset loc.status = 0>
				<cfquery name="queryCorte" datasource="#session.dsn#"> 
					select Codigo, status
					from CRCCortes
					where Codigo = '#loc.corteCP#'
				</cfquery>	

				<cfif queryCorte.recordCount gt 0>
					<cfset loc.status = #queryCorte.status#>
				</cfif>
 
				<cfquery datasource="#Session.DSN#">
				 	insert into CRCMovimientoCuentaCorte(
								CRCCuentasid
								,MontoRequerido
								,MontoAPagar
								,MontoPagado
								,Intereses
								,SaldoVencido 
								,Condonaciones   
								,Corte
								,FechaLimite
								,Ecodigo 
					 			)
				 		values(
							    #qMCC.cuentaID#,
							    #qMCC.MontoRequerido#,
							    #qMCC.MontoPagar#,
							    #qMCC.MontoPagado#,
							    #qMCC.Intereses#,
							    #qMCC.SaldoVencido#,
							    #qMCC.Condonaciones#,
							    '#loc.corteCP#',
							    #loc.status#,
							    #session.Ecodigo#
							    )

				</cfquery>
		</cfloop>

		<cfif isdefined('ProcesarGUI')> <cfset progress = 100><cfset progressB(progress,'Finish')> 
			<cfset session.progressE = true></cfif>

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
	<cfset sleep(1000)>
</cffunction>