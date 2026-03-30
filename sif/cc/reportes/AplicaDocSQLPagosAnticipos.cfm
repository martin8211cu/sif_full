<cfif isdefined("url.Generar")>
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select  
			a.EFfecha as EFfecha,
			a.CCTcodigo,
			a.EFtotal  as EFtotal,
			a.EFtipocambio,
			b.SNnombre, 
			b.SNnumero,
			b.SNidentificacion,
			h.Dfecha,
			h.Dsaldo,
			h.Dtotal,
			b.SNid,
			coalesce(e.Ddocumento, ' -- ') as Ddocumento,	 
			coalesce(e.DFmonto, 0.00) as DFmonto,
			n.CCTtipo,
			f.Mnombre,
			g.Edescripcion,
			e.DRdocumento,
			a.CCTcodigo, 
 			sum(e.DFmonto) as MontoDet ,
 			round(h.Dsaldo - sum(e.DFmonto),2) as disponible
		from EFavor a
			inner join  DFavor e
				on a.Ecodigo = e.Ecodigo
  				and a.CCTcodigo = e.CCTcodigo
 				and rtrim(a.Ddocumento)	= rtrim(e.Ddocumento)
				
		    inner join Documentos h
  				on a.Ecodigo = h.Ecodigo
  				and a.CCTcodigo	= h.CCTcodigo
  				and rtrim(a.Ddocumento)	= rtrim(h.Ddocumento)

			inner join SNegocios b
				on b.Ecodigo = a.Ecodigo
				and b.SNcodigo = a.SNcodigo

			inner join Monedas f
				on f.Mcodigo = a.Mcodigo

				
			inner join Empresas g
				on g.Ecodigo = a.Ecodigo

			inner join CCTransacciones n 
				on a.Ecodigo = n.Ecodigo
				and a.CCTcodigo = n.CCTcodigo 
				and n.CCTtipo = 'C' 
			where a.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
					and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#"> 
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
				<cfelse>
					and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
						and <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
				</cfif>
			<cfelseif isdefined("url.Transaccion") and len(trim(url.Transaccion))>
				and a.CCTcodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
			<cfelseif isdefined("url.Transaccion2") and len(trim(url.Transaccion2))>
				and a.CCTcodigo <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
			</cfif>
			<cfif isdefined("url.Usuario") and url.Usuario NEQ "-1">
				and a.EFusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#">
			</cfif>

			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
					and a.EFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
					and a.EFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
					and a.EFfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and a.EFfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and a.EFfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
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
	GROUP BY  a.CCTcodigo,e.Ddocumento,b.SNnombre, b.SNnumero,g.Edescripcion,f.Mnombre,EFfecha, a.CCTcodigo,EFtotal,
			  a.EFtipocambio,b.SNidentificacion,h.Dfecha,h.Dsaldo, h.Dtotal,b.SNid,DFmonto,n.CCTtipo, e.DRdocumento
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
		select CCTdescripcion 
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion#">
		  and CCTtipo = '#url.tipo#' 
		  and coalesce(CCTpago,0) = 1
	</cfquery>
	
	<!--- Busca el nombre de la Transacción Final --->	
	<cfquery name="rsTransaccion2" datasource="#session.DSN#">
		select CCTdescripcion 
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Transaccion2#">
		  and CCTtipo = '#url.tipo#' 
		  and coalesce(CCTpago,0) = 1
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
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.AplicaDoc"/>
	<cfelse>
	  <cfreport format="#formatos#" template= "AplicaDoc.cfr" query="rsReporte">
	  	
		
		<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
			<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
		</cfif>
		<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
			<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
		</cfif>
		
		<cfif isdefined("rsMonedaIni") and rsMonedaIni.recordcount gt 0>
			<cfreportparam name="MonedaIni" value="#rsMonedaIni.Mnombre#">
		</cfif>		
		<cfif isdefined("rsMonedaFin") and rsMonedaFin.recordcount gt 0>
			<cfreportparam name="MonedaFin" value="#rsMonedaFin.Mnombre#">
		</cfif>		
		
		<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
			<cfreportparam name="fechaDes" value="#url.fechaDes#">
		</cfif>		
		<cfif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
			<cfreportparam name="fechaHas" value="#url.fechaHas#">
		</cfif>		
		<cfif isdefined("rsTransaccion") and rsTransaccion.recordcount gt 0>
			<cfreportparam name="Transaccion" value="#rsTransaccion.CCTdescripcion#">
		</cfif>
		<cfif isdefined("rsTransaccion2") and rsTransaccion2.recordcount gt 0>
			<cfreportparam name="Transaccion2" value="#rsTransaccion2.CCTdescripcion#">
		</cfif>
		
		<cfif isdefined("url.Usuario") and url.Usuario NEQ '-1'>
				<cfreportparam name="Usuario" value="#url.Usuario#">
		<cfelseif isdefined("url.Usuario") and url.Usuario EQ '-1'>
				<cfreportparam name="Usuario" value="Todos">
		</cfif>
	</cfreport>
	</cfif>
</cfif>


