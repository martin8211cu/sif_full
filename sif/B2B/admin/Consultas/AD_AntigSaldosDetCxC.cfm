<cfif isdefined("url.venc") and Len(trim(url.venc))>
	<cfif not isdefined("form.venc") or len(trim(form.venc)) eq 0>
		<cfset form.venc = url.venc>
	</cfif>
</cfif>

<cfset venc1 = #Trim(get_val(310).Pvalor)#>
<cfset venc2 = #Trim(get_val(320).Pvalor)#>
<cfset venc3 = #Trim(get_val(330).Pvalor)#>
<cfset venc4 = #Trim(get_val(340).Pvalor)#>

<cfset LvarFechaHoy = createdate(year(now()), month(now()), day(now()))>
<cfset LvarInicioMes = createdate(year(now()), month(now()), 1)>
<cfset LvarFinMes =  dateadd("m", 1, LvarInicioMes)>
<cfset LvarFinMes =  dateadd("d", -1, LvarFinMes)>

<cfset LvarVenc1 = dateadd('d', -venc1, LvarFechaHoy)>
<cfset LvarVenc2 = dateadd('d', -venc2, LvarFechaHoy)>
<cfset LvarVenc3 = dateadd('d', -venc3, LvarFechaHoy)>
<cfset LvarVenc4 = dateadd('d', -venc4, LvarFechaHoy)>

<!--- <cftransaction isolation="read_uncommitted"> --->
	<cfquery name="rsConsulta" datasource="#session.dsn#">
	    select 
		  c.SNnombre as socio, 
		   coalesce((
					select HD.HDid
					from HDocumentos HD
					where HD.Ecodigo = a.Ecodigo
					  and HD.CCTcodigo = a.CCTcodigo
					  and HD.Ddocumento = a.Ddocumento
					  and HD.SNcodigo = a.SNcodigo
				),-1) as HDid,
           a.CCTcodigo as transaccion,
           a.Ddocumento as documento,
           a.Dfecha as fecha,
           a.Dvencimiento as fechavenc,
           round((case d.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) * a.Dtotal,2) as monto,
           round((case d.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) * a.Dsaldo,2) as saldo,
           b.Mnombre as moneda,
           round((case d.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) * (a.Dsaldo*a.Dtcultrev),2) as saldolocal
		from Documentos a
				inner join CCTransacciones d
					on d.CCTcodigo = a.CCTcodigo
					and d.Ecodigo = a.Ecodigo

				inner join Monedas b
					on b.Mcodigo = a.Mcodigo
	
				inner join SNegocios c
					on c.SNcodigo = a.SNcodigo
					and c.Ecodigo = a.Ecodigo
	
		where a.Ecodigo = #session.Ecodigo#
		and a.Dsaldo > 0
		<cfif isdefined("form.SNcodigo") and form.SNcodigo GT -1>
			and a.SNcodigo = #form.SNcodigo#
		</cfif>
		<cfif isdefined("form.Ocodigo") and form.Ocodigo GT -1>
			and a.Ocodigo = #form.Ocodigo#
		</cfif>
		<cfif form.venc GT -1>
			<cfif form.venc EQ 1>
				and a.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				and a.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
			</cfif>
			<cfif form.venc EQ 'Corriente'>
				and a.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
			</cfif>
			<cfif form.venc EQ 2>
			    and a.Dvencimiento <   <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#"> 
				and a.Dvencimiento >=  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#">
			</cfif>
			<cfif form.venc EQ 3>
			    and a.Dvencimiento <   <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#"> 
				and a.Dvencimiento >=  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#">
			</cfif>
			<cfif form.venc EQ 4>
			    and a.Dvencimiento <   <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#"> 
				and a.Dvencimiento >=  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#">
			</cfif>
			<cfif form.venc EQ 5>
			    and a.Dvencimiento <   <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#"> 
				and a.Dvencimiento >=  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#">
			</cfif>
			<cfif form.venc EQ 6>
			    and a.Dvencimiento <   <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#"> 
			</cfif>
		</cfif>
		order by c.SNnombre, b.Mnombre, a.Dvencimiento desc, transaccion, documento
	</cfquery>
<!--- </cftransaction> --->