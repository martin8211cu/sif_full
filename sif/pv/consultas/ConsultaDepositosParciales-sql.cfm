<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsDatos" datasource="#session.DSN#" maxrows="1001">
	select 	a.Depositospid,
			a.Mcodigo,			
			e.FAM01CODD as Caja,
			(select ltrim(rtrim(Oficodigo)) #_Cat# ' - ' #_Cat# ltrim(rtrim(Odescripcion)) 
				from Oficinas o 
				where o.Ecodigo = e.Ecodigo 
				and o.Ocodigo = e.Ocodigo) as Oficina,
			a.NumDeposito as NumeroDeposito,
			a.MontoEfectivo as MontoEfectivo,
			(select Miso4217 
				from Monedas m 
				where m.Mcodigo = a.Mcodigo) as Moneda,
			a.NumCuenta as NumeroCuenta,
			a.NumReferencia as NumeroReferencia,
			a.Observaciones as Observaciones,
			b.CCTcodigo #_Cat# ' - ' #_Cat# b.FAX01DOC as Documento,
			b.FAX01FEC as FechaTransaccion, 
			c.FAX12NUM as NumeroCheque,
			c.FAX12CTA as NumeroCuentaCheque,
			d.Bdescripcion as NombreBanco,
			c.FAX12TOTMF as MontoCheque
 
	from FADepositosp a 
		inner join FAX001 b
			on a.Ecodigo = b.Ecodigo
		   	and a.FAM01COD = b.FAM01COD

			inner join FAX012 c
				on b.Ecodigo = c.Ecodigo
		   		and b.FAX01NTR = c.FAX01NTR
		   		and a.Depositospid = c.Depositopid
			
				inner join Bancos d
					on c.Bid = d.Bid
		inner join FAM001 e
			on a.Ecodigo = e.Ecodigo
		   	and a.FAM01COD = e.FAM01COD

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		  and b.FAX01STA in ('T','C')
		  and c.FAX12TIP = 'CK'
		  	<!---Filtro de oficina---->
			<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
				and  e.Ocodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
			</cfif>
		  	<!---Filtro de caja---->
			<cfif isdefined("url.FAM01COD") and len(trim(url.FAM01COD))>
				and e.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01COD#">
			</cfif>
			<!---Filtro de fechas---->		
			<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde)) and isdefined("url.fechahasta") and len(trim(url.fechahasta))>
				<cfif url.fechadesde EQ url.fechahasta>
					and a.FechaDepositop = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
				<cfelseif url.fechadesde LT url.fechahasta>
					and a.FechaDepositop between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
				<cfelse>
					and a.FechaDepositop between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
				</cfif>
			</cfif>
			<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde)) and not (isdefined("url.fechahasta") and len(trim(url.fechahasta)))>
				and a.FechaDepositop >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechadesde)#">
			</cfif>		
			<cfif isdefined("url.fechahasta") and len(trim(url.fechahasta)) and not (isdefined("url.fechadesde") and len(trim(url.fechadesde)))>
				and a.FechaDepositop <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.fechahasta)#">
			</cfif> 
			<!----Filtro de No.Deposito---->
			<cfif isdefined("url.NumDeposito") and len(trim(url.NumDeposito))>
				and a.NumDeposito = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.NumDeposito)#">
			</cfif>
			<!----Filtro de No.referencia---->
			<cfif isdefined("url.NumReferencia") and len(trim(url.NumReferencia))>
				and a.NumReferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.NumReferencia)#">
			</cfif>
	order by a.Depositospid, a.Mcodigo, e.FAM01CODD 
</cfquery>

<cfif isdefined("rsDatos") and rsDatos.RecordCount EQ 0>
	<cfinclude template="POSDatosNoEncontrados.cfm">
</cfif>

<cfif isdefined("rsDatos") and rsDatos.RecordCount GT 1000>
	<cfinclude template="POSRegistrosExcedidos.cfm">
</cfif>

<!----Empresa----->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- Invocar reporte --->
<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
	<cfreport format="#url.formato#" template= "ConsultaDepositosParciales.cfr" query="rsDatos">
		<cfreportparam name="Edescripcion" value="#session.enombre#">
	</cfreport>
</cfif>
