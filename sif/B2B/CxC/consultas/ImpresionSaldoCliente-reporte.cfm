<!---
	Creado por Gustavo Fonseca H.
		Fecha: 9-12-2005.
		Motivo: Permitir imprimir un reporte donde haga constatar que el socio de negocios tiene saldo cero.
--->

<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("SNcodigo")>
	<cfset SNcodigo = url.SNcodigo>
</cfif>

<cfquery name="rsGraficoBar" datasource="#session.dsn#">
	select
		<cfif isdefined('Ocodigo_F') and Ocodigo_F NEQ ''>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ocodigo_F#"> as Ocodigo_F,
		<cfelse>
			'-1' as Ocodigo_F,
		</cfif>
		
		 <cfif isdefined("SNcodigo") and SNcodigo gt -1>
			 d.SNcodigo,	 
			 coalesce(d.id_direccionFact, 1) as id_direccion,
			 case when datalength(coalesce(di.direccion1,'-- N/A --')) > 25 then <cf_dbfunction name="concat" args="substring(di.direccion1,1,22)+'...'" delimiters="+">  else coalesce(di.direccion1,'-- N/A --') end as direccion,
			 
		 </cfif>
		  sum(round(coalesce(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,0),2)) as Dsaldo
	from
		 Documentos d
			inner join CCTransacciones t
				on t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			<cfif isdefined("SNcodigo") and SNcodigo gt -1>
				left outer join DireccionesSIF di
					on  di.id_direccion = d.id_direccionFact
			</cfif>
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and d.Dsaldo <> 0.00
		
		<cfif isdefined("SNcodigo") and SNcodigo gt -1>
		  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
		</cfif>
		
		<cfif isdefined("url.Ocodigo_F") and url.Ocodigo_F gt -1>
		  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo_F#">
		</cfif>

		<cfif isdefined("SNcodigo") and SNcodigo gt -1>
			group by d.SNcodigo,coalesce(d.id_direccionFact, 1), case when datalength(coalesce(di.direccion1,'-- N/A --')) > 25 then <cf_dbfunction name="concat" args="substring(di.direccion1,1,22)+'...'" delimiters="+"> else coalesce(di.direccion1,'-- N/A --') end
		</cfif>																									
</cfquery>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select
		coalesce(d.id_direccionFact, 1) as id_direccion,
		coalesce(di.direccion1, '-- N/A --')  as direccion,
		d.CCTcodigo,
		d.Ddocumento,
		d.Dfecha,
		d.Dvencimiento,
		coalesce(ofi.Oficodigo, ' N/A') as Oficina,
		round(d.Dtotal * d.Dtcultrev * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2) as Monto,
		round(d.Dsaldo  * d.Dtcultrev * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2) as Saldo
	from
		 Documentos d
			inner join CCTransacciones t
				on t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			left outer join Oficinas ofi
				on ofi.Ecodigo = d.Ecodigo
				and ofi.Ocodigo = d.Ocodigo
			left outer join DireccionesSIF di
				on  di.id_direccion = d.id_direccionFact
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and d.Dsaldo <> 0.00
	  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
	  
		<cfif isdefined("url.Ocodigo_F") and url.Ocodigo_F gt -1>
		  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo_F#">
		</cfif>
	  
	  order by id_direccionFact, d.Dfecha, d.CCTcodigo 
</cfquery>

<cfquery name="rsGraficoBar2" dbtype="query"> 
	select 
		sum(Dsaldo) as Saldo
	from rsGraficoBar
</cfquery>
<cfset LvarSaldo = rsGraficoBar2.saldo>

<cfif not len(trim(rsReporte.id_direccion))>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select
			' ' as id_direccion,
			' ' as direccion,
			' ' as CCTcodigo,
			' ' as Ddocumento,
			<cf_dbfunction name="now">  as Dfecha,
			<cf_dbfunction name="now">  as Dvencimiento,
			' ' as Oficina,
			0 as Monto,
			0 as Saldo
		from dual
	</cfquery>
	<cfset LvarSaldo = '0'>
</cfif>

<!--- Busca nombre del Socio de Negocios 1 --->
<cfif isdefined("SNcodigo") and len(trim(SNcodigo))>
	<cfquery name="rsSNcodigo" datasource="#session.DSN#">
		select SNnombre, SNnumero, SNidentificacion, SNemail
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
		and Ecodigo =   #session.Ecodigo# 
	</cfquery>
</cfif>

<!--- Busca nombre de la Empresa --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo =   #session.Ecodigo# 
	</cfquery>

<cfset Formato = 1><!--- para que escoja el Formato de flashpaper --->
	
<!--- Invoca el Reporte --->		
	<cfif isdefined("Formato") and len(trim(Formato)) and Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("Formato") and len(trim(Formato)) and Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("Formato") and len(trim(Formato)) and Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>
	
	 <cfreport format="pdf" template= "../reportes/ImpresionSaldoCliente.cfr" query="rsReporte">
		<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
			<cfreportparam name="SNnombre" value="#rsSNcodigo.SNnombre#">
			<cfreportparam name="SNnumero" value="#rsSNcodigo.SNnumero#">
			<cfreportparam name="SNidentificacion" value="#rsSNcodigo.SNidentificacion#">
			<cfreportparam name="SNemail" value="#rsSNcodigo.SNemail#">
		</cfif>
		<cfif isdefined("LvarSaldo") and len(trim(LvarSaldo))>
			<cfreportparam name="Saldo" value="#LvarSaldo#">
		<cfelse>
			<cfreportparam name="Saldo" value="0">
		</cfif>
		
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
		<cfelse>
			<cfreportparam name="Empresa" value="#session.Enombre#">
		</cfif>
	</cfreport>