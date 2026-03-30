<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cf_templateheader title="Gestion de Autorizaciones" bloquear="false">
  	<div id="circle-menu2">
<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo)) and isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud)) >
	<cfquery name="dataSolicitud" datasource="#session.DSN#">
		select NAP, NRP
		from ESolicitudCompraCM
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		  and ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
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
					popUpWindow("/cfmx/sif/cm/operacion/imprimeSolicitud.cfm?ESidsolicitud=<cfoutput>#url.ESidsolicitud#</cfoutput>",250,200,650,400);
				}
				imprime();
			</script>
		</cfoutput>
	<!--- CONSULTA DE NRP --->
	<cfelseif len(trim(dataSolicitud.NRP)) >
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(dataSolicitud.NRP)#">
	</cfif>
	<cfinclude template="TramiteSolicitud.cfm">

</cfif>
	</div>
<cf_templatefooter>