<!---<cfdump var="#form#">
<cf_dump var="#url#">--->
<cfif not isdefined("form.formato") >
	<cfset tipoformato = "html">
<cfelse>
	<cfset tipoformato = #form.formato#>
</cfif>
<cfif isDefined("url.Oficina") and len(trim(url.Oficina)) NEQ 0>
	<cfquery name="rsOficinas" datasource="minisif">
		select Odescripcion 
		from Oficinas 
		where Ecodigo = #session.ecodigo#
		  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Oficina#">
	</cfquery>
</cfif>
<cfquery name="meses" datasource="minisif">
	select distinct CPCmes, case when CPCmes = 1 then 'Enero' 
								 when CPCmes = 2 then 'Febrero' 
								 when CPCmes = 3 then 'Marzo' 
								 when CPCmes = 4 then 'Abril' 
								 when CPCmes = 5 then 'Mayo' 
								 when CPCmes = 6 then 'Junio' 
								 when CPCmes = 7 then 'Julio' 
								 when CPCmes = 8 then 'Agosto' 
								 when CPCmes = 9 then 'Septiembre' 
								 when CPCmes = 10 then 'Octubre' 
								 when CPCmes = 11 then 'Noviembre' 
								when CPCmes = 12 then 'Diciembre' 
							end as mes
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	  and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPCmes#">
</cfquery>

<cfinclude template="PresupGastosUN.cfm">



