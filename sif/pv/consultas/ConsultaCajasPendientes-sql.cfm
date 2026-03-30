<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	c.FAM01CODD as CodigoCaja,
			c.FAM01DES as DescripcionCaja,
			c.FAM01RES as ResponsableCaja,
			(select min(t.FAX01FEC) 
				from FAX001 t 
				where t.FAM01COD = c.FAM01COD
				  and t.FAX01STA = 'T') as TransaccionesDesde,
			(select max(t.FAX01FEC) 
				from FAX001 t 
				where t.FAM01COD = c.FAM01COD
				  and t.FAX01STA = 'T') as TransaccionesHasta
    from FAM001 c
    where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		and exists(
				select 1
        		from FAX001 t
        		where t.FAM01COD = c.FAM01COD
          		  and t.FAX01STA = 'T')
	order by c.FAM01CODD
</cfquery>
<!----Empresa----->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfinclude template="ConsultaCajasPendientes_HTML.cfm">
<!--- Invocar reporte --->
<!---
<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
	<cfreport format="#url.formato#" template= "ConsultaCajasPendientes.cfr" query="rsDatos">
		<cfreportparam name="Edescripcion" value="#session.enombre#">
	</cfreport>
<cfelse>
	<cf_errorCode	code = "50570" msg = "No se encontraron Cajas con Transacciones Pendientes de Cierre">
</cfif>
--->

