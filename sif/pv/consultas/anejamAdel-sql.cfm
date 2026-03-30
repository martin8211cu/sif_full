<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="501">
	 select 
		  e.Oficodigo
		, e.Odescripcion	 
		, case 
			when (datediff(dd,FAX14FEC,getDate()) between 1 and 30) then 'Periodo: De 1 a 30'
			when (datediff(dd,FAX14FEC,getDate()) between 31 and 60) then 'Periodo: De 31 a 60'
			when (datediff(dd,FAX14FEC,getDate()) between 61 and 90) then 'Periodo: De 61 a 90'
			when (datediff(dd,FAX14FEC,getDate()) between 91 and 120) then 'Periodo: De 91 a 120'
			when (datediff(dd,FAX14FEC,getDate()) between 121 and 150) then 'Periodo: De 121 a 150'
			when (datediff(dd,FAX14FEC,getDate()) between 151 and 180) then 'Periodo: De 151 a 180'
			when (datediff(dd,FAX14FEC,getDate()) >= 181) then 'Periodo: De 181 en adelante'
		end periodo
		, b.FAM01CODD
		, a.FAX14DOC
		, a.CDCcodigo
		, c.CDCidentificacion
		, c.CDCnombre
		, a.FAX14FEC
		, a.FAX14MON
		, a.Mcodigo
		, d.Miso4217
		, a.FAX14MAP
		, (FAX14MON-FAX14MAP) as Saldo
	from FAX014 a
		inner join FAM001 b
			on b.FAM01COD=a.FAM01COD
			and b.Ecodigo=a.Ecodigo
			<!--- FILTRO DE OFICINA--->
			<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
				and b.Ocodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
			</cfif>				
			 <!--- FILTRO DE CAJA--->
			<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
				and b.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
			</cfif>					
		inner join FAX001 f
			on f.FAX01NTR = a.FAX01NTR
			and f.FAM01COD = a.FAM01COD
			and f.FAX01STA in ('T', 'C')
		inner join ClientesDetallistasCorp c
			on c.CDCcodigo=a.CDCcodigo
		inner join Monedas d
			on d.Mcodigo=a.Mcodigo
		inner join Oficinas e
			on e.Ecodigo=a.Ecodigo
			and e.Ocodigo=b.Ocodigo
				
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.FAX14MON > a.FAX14MAP
		and a.FAX14STS = '1'
		and a.FAX14CLA = '2'
		<!--- FILTRO DE CLIENTE --->
		<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo))>
			and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo#">
		</cfif>		
	order by a.FAX14FEC desc
</cfquery>
<cfif rsReporte.recordcount GT 500>
	<br>
	<br>
	<br>
	<div align="center">Se han Generado más de 500 registros.  Por favor Limite la Consulta</div>
<cfelse>
	<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "pdf">
	</cfif>
	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formatos#" template= "anejamAdel.cfr" query="rsReporte">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
</cfif>

