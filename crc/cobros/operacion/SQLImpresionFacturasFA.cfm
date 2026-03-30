	<cfset imprimir = false>
	<cfif isDefined("Form.Aplicar")>
		<!--- Obtiene los valores que vienen en el chk --->
		<cfif isDefined("Form.chk")>
			<cfset valores = ListToArray(Form.chk,'|')>
			<cfif ArrayLen(valores) lt 7>
				<cfset valores[7] = 'A'>
			</cfif>
			
			
			<cftransaction action="begin">
				<cfif Url.tipo EQ "I">										
					<cfquery name="TImpresas" datasource="#Session.DSN#">
						update ETransacciones set ETimpresa = 1 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
						  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[2]#">
						  
						insert TImpresas (FCid, ETnumero, TIfecha, Usucodigo, Ulocalizacion, TItipo, ETdocumento, ETserie, ETdocumentoant, ETserieant)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[2]#">,							
							<cfqueryparam cfsqltype="cf_sql_date" value="#valores[3]#">,							
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,				
							'I',
							<cfqueryparam cfsqltype="cf_sql_integer" value="#valores[6]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#valores[7]#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#valores[6]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#valores[7]#">
						)
					</cfquery>
							
					<cfset imprimir = true>
					
				<cfelseif Url.tipo EQ "R">

					<!--- Cambia numero de factura si en parametros(510) se ha definido hacerlo ---> 
					<cfquery name="rsModificaNumero" datasource="#session.DSN#">
						select Pvalor
						from Parametros
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Pcodigo = 510 
					</cfquery>
					
					<cfset siguiente = valores[7]>
					<cfset anterior = valores[9]>

					<cfif rsModificaNumero.RecordCount gt 0 and rsModificaNumero.Pvalor eq 'S'>
						<!--- Incrementa el Talonario --->
						<cfquery name="rsTalonario" datasource="#session.DSN#">
							select Tid 
							from ETransacciones 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
							  and ETnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#valores[2]#">
						</cfquery>
	
						<cfquery name="updateTalonario" datasource="#session.DSN#">
							update Talonarios
							set RIsig = RIsig + 1
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">
						</cfquery>
						
						<cfquery name="rsTalonarioSig" datasource="#session.DSN#">
							select RIsig
							from Talonarios
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">
						</cfquery>
						<cfset siguiente = rsTalonarioSig.RIsig >
	
						<cfquery name="rsImpresionAnt" datasource="#session.DSN#">
							select max(ETdocumento) as anterior
							from TImpresas
							where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
							  and ETnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#valores[2]#">
						</cfquery>
						<cfset anterior = rsImpresionAnt.anterior >
						<cfquery name="updateTransaccion" datasource="#session.DSN#">
							update ETransacciones
							set ETdocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#siguiente#" >
							where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
						  	  and ETnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#valores[2]#">
						</cfquery>					
					</cfif>

					<cfquery name="TImpresas" datasource="#Session.DSN#">
						insert TImpresas (FCid, ETnumero, TIfecha, Usucodigo, Ulocalizacion, TItipo, ETdocumento, ETserie, ETdocumentoant, ETserieant)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[2]#">,							
							<cfqueryparam cfsqltype="cf_sql_date" value="#valores[3]#">,							
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[4]#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#valores[5]#">,				
							'R',
							<cfqueryparam cfsqltype="cf_sql_integer" value="#siguiente#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#valores[8]#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#anterior#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#valores[10]#">
						)
					</cfquery>
					
					<cfset imprimir = true>
				</cfif>
			</cftransaction>			
		</cfif> <!--- if de chk --->
		
		<cfif imprimir>
			<cfset session.Impr.imprimir = 'S'>
            <cfset session.Impr.caja = #valores[1]#>
            <cfset session.Impr.TRANnum = #valores[2]#>
            <cfset session.Impr.RegresarA=#URLencodedFormat("ImpresionFacturasFA.cfm?tipo=#Url.tipo#")#>				
		</cfif>	
		<cflocation addtoken="no" url="ReImpresionFacturas.cfm?tipo=#Url.tipo#">
		
	</cfif> <!--- if de Aplicar --->