<cfif isdefined("url.Generar")>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select 	
				a.EPdocumento,  
				a.EPfecha, 
				a.CPTcodigo,
				a.EPtotal,
				coalesce((select sum(Anti.NC_total)
							from APagosCxP Anti 
						 where Anti.IDpago = a.IDpago), 0.00) NC_total,
				a.EPtipocambio,
				c.Cdescripcion, 
				d.Odescripcion,
				h.Dfecha,
				h.Ddocumento,
				h.CPTcodigo as CPTcodigoDetalle,
				e.DPmontodoc,
				e.DPtotal,
				e.IDpago,
				g.Edescripcion,
				f.Mnombre,
				b.SNnombre, 
				b.SNidentificacion

		 from EPagosCxP a
			inner join SNegocios b
				on b.Ecodigo = a.Ecodigo
				and b.SNcodigo = a.SNcodigo
			inner join Oficinas d
				on d.Ecodigo =a.Ecodigo
				and d.Ocodigo = a.Ocodigo
			left outer join DPagosCxP e
				inner join CContables c
					on c.Ecodigo = e.Ecodigo
					and c.Ccuenta = e.Ccuenta 
				inner join EDocumentosCP h <!--- -- Aplicados --->
					on h.Ecodigo = e.Ecodigo 
					and h.IDdocumento = e.IDdocumento
				on e.IDpago = a.IDpago
				and e.Ecodigo = a.Ecodigo
			inner join Monedas f
				on f.Ecodigo = a.Ecodigo
				and f.Mcodigo = a.Mcodigo
			inner join Empresas g
				on g.Ecodigo = a.Ecodigo
				
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 <!---and c.Cmovimiento = 'S' ---> <!--- Cuentas que aceptan movimientos --->
			 <!---and c.Mcodigo = 3 Para Proveedores (CC) --->
			<!--- Socio de negocios --->
			<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
				<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
						and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
				<cfelse>
						and b.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
				</cfif>											
			<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
				and b.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#"> 
			<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
				and b.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			</cfif>
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Transaccion") and len(trim(url.Transaccion)) and isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
				<cfif url.Transaccion gt url.Transaccion2>
					and a.CPTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#"> 
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
				<cfelse>
					and a.CPTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
				</cfif>
			<cfelseif isdefined("url.Transaccion") and len(trim(url.Transaccion))>
				and a.CPTcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
			<cfelseif isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
				and a.CPTcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
			</cfif>

			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
					and a.EPfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
					and a.EPfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
					and a.EPfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and a.EPfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and a.EPfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			</cfif>
			
			<!--- Monedas Inicial / Final --->
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and isdefined("url.Moneda2") and len(trim(url.Moneda2))>
				<cfif url.Moneda gt Moneda2><!--- si el primero es mayor que el segundo. --->
						and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#"> 
											and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#">
				<cfelse>
						and f.Mcodigo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
											and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
				</cfif>											
			<cfelseif isdefined("url.Moneda") and len(trim(url.Moneda))>
				and f.Mcodigo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
			<cfelseif isdefined("url.Moneda2") and len(trim(url.Moneda2))>
				and f.Mcodigo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda2#">
			</cfif>
			<!--- Oficina Inicial / Final --->
			<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
				<cfif url.Oficodigo gt Oficodigo2><!--- si el primero es mayor que el segundo. --->
						and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#">
				<cfelse>
						and d.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
											and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
				</cfif>											
			<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
				and d.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> 
			<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
				and d.Oficodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo2#">
			</cfif>

		order by f.Mnombre, b.SNnombre, e.IDpago
	</cfquery>
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>
	
	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Busca nombre del Socio de Negocios 2 --->
	<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la Oficina Inicial --->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfquery name="rsOficinaIni" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
		</cfquery>
	</cfif>
	
	
	<!--- Busca el nombre de la Oficina Final --->
	<cfif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
		<cfquery name="rsOficinaFin" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo2#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la moneda inicial --->
	<cfif isdefined("url.moneda")	and len(trim(url.moneda))>
		<cfquery name="rsMonedaIni" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
		</cfquery>
	</cfif>


	<!--- Busca el nombre de la moneda Final --->
	<cfif isdefined("url.moneda2")	and len(trim(url.moneda2))>
		<cfquery name="rsMonedaFin" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda2#">
		</cfquery>
	</cfif>
	
	<!--- Busca el nombre de la Transacción Inicial --->	
	<cfquery name="rsTransaccion" datasource="#session.DSN#">
		select CPTdescripcion 
		from CPTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
		  and CPTtipo = '#url.tipo#' 
		  and coalesce(CPTpago,0) = 1
	</cfquery>
	
	<!--- Busca el nombre de la Transacción Final --->	
	<cfquery name="rsTransaccion2" datasource="#session.DSN#">
		select CPTdescripcion 
		from CPTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
		  and CPTtipo = '#url.tipo#' 
		  and coalesce(CPTpago,0) = 1
	</cfquery>
	
	
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos eq "excel">
	  <cfset typeRep = 1> 
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.PagosSinAplicarDetCP"/>
	<cfelse>
		<cfreport format="#formatos#" template= "PagosSinAplicarDetCP.cfr" query="rsReporte">	
		
			<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
				<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
			</cfif>
			<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
				<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
			</cfif>
			
			<cfif isdefined("rsOficinaIni") and rsOficinaIni.recordcount gt 0>
				<cfreportparam name="Oficina" value="#rsOficinaIni.Odescripcion#">
			</cfif>
			<cfif isdefined("rsOficinaFin") and rsOficinaFin.recordcount gt 0>
				<cfreportparam name="Oficina2" value="#rsOficinaFin.Odescripcion#">
			</cfif>

			<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				<cfreportparam name="fechaDes" value="#url.fechaDes#">
			</cfif>		
			<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfreportparam name="fechaHas" value="#url.fechaHas#">
			</cfif>		

			<cfif isdefined("rsMonedaIni") and rsMonedaIni.recordcount gt 0>
				<cfreportparam name="MonedaIni" value="#rsMonedaIni.Mnombre#">
			</cfif>		
			<cfif isdefined("rsMonedaFin") and rsMonedaFin.recordcount gt 0>
				<cfreportparam name="MonedaFin" value="#rsMonedaFin.Mnombre#">
			</cfif>		

			<cfif isdefined("rsTransaccion") and rsTransaccion.recordcount gt 0>
				<cfreportparam name="Transaccion" value="#rsTransaccion.CPTdescripcion#">
			</cfif>
			<cfif isdefined("rsTransaccion2") and rsTransaccion2.recordcount gt 0>
				<cfreportparam name="Transaccion2" value="#rsTransaccion2.CPTdescripcion#">
			</cfif>
			<cfif isdefined("url.usuario") and len(trim(url.usuario))>
				<cfreportparam name="Usuario" value="#url.usuario#">
			</cfif>

		</cfreport>
	</cfif>
</cfif>





