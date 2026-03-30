<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo)) and isdefined("url.TESSPid") and len(trim(url.TESSPid)) >
	<cfquery name="dataSolicitud" datasource="#session.DSN#">
		select NAP, NRP
		from TESsolicitudPago
		where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		  and TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESSPid#">
	</cfquery>

	<!--- IMPRIME SOLICITUD --->
	<cfif len(trim(dataSolicitud.NAP))>
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}

				function imprime() {
					var params ="";
					popUpWindow("/cfmx/sif/tesoreria/Solicitudes/imprimeSolicitudP.cfm?TESSPid=<cfoutput>#url.TESSPid#&TipoSol=#url.TipoSol#</cfoutput>",250,200,650,400);
				}
				imprime();
			</script>
		</cfoutput>
	<!--- CONSULTA DE NRP --->
	<cfelseif len(trim(dataSolicitud.NRP)) >
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(dataSolicitud.NRP)#">
	</cfif>

	<cfinclude template="TramiteSolicitudP.cfm">

</cfif>