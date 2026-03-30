<cfinclude template="isadmin.cfm">

<!--- Guardar el estado del tramite: 6 = cerrado --->
<cfquery datasource="sdc">
	update TramitePasaporte
	set Procesado = 1
	where TPID = #TPID#
	  and Pagado = 1
	  and Procesado = 0
	  and Avance in ('5', '6')
</cfquery>

<cflocation url="consulta.cfm" >