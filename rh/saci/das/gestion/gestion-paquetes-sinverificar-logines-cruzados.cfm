<!---Se utiliza para el caso de un cambio de un paquete cablemodem a un paquete no cablomodem--->
<!---Se agrega en la lista de servicios por borrar el servicio cablemodem--->

<cfif (isdefined("session.saci.cambioPQ.logConservar.login") 
		and len(trim(session.saci.cambioPQ.logConservar.login)) and isdefined("ListsinVerificar") and Len(trim(ListsinVerificar)) )
					or( isdefined("logConservar") and ListLen(logConservar) and isdefined("ListsinVerificar") and Len(trim(ListsinVerificar)) ) >
		
<cfquery name="rsServiciosIncons" datasource="#session.DSN#" >
	select b.LGnumero, b.LGlogin, e.TScodigo, '1' as aconservar
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.PQcodigo=a.PQcodigo
			<cfif isdefined("session.saci.cambioPQ") and isdefined("ListsinVerificar") and len(trim(ListsinVerificar))>
			and c.TScodigo in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#ListsinVerificar#">)
			</cfif>
			and c.Habilitado=1
		inner join ISBservicio e
			on e.PQcodigo=c.PQcodigo
			and e.TScodigo=c.TScodigo
			and e.Habilitado =1		
	where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#"> 
	and a.CTcondicion = '1'
	order by   b.LGlogin
</cfquery>

	<cfloop query="rsServiciosIncons">		
		
		<cfset session.saci.cambioPQ.logBorrar.login = session.saci.cambioPQ.logBorrar.login & IIF(len(trim(session.saci.cambioPQ.logBorrar.login)),DE(','),DE('')) & #rsServiciosIncons.LGlogin#>
		<cfset session.saci.cambioPQ.logBorrar.servicios = session.saci.cambioPQ.logBorrar.servicios & IIF(len(trim(session.saci.cambioPQ.logBorrar.servicios)),DE(','),DE('')) & #rsServiciosIncons.TScodigo#>
	
		<cfset session.saci.cambioPQ.logConservar.login = ''>
		<cfset session.saci.cambioPQ.logConservar.servicios = ''>
		
	</cfloop>	

</cfif>

