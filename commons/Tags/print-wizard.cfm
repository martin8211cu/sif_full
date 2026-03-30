
<!--- <cfif ThisTag.ExecutionMode is 'start'> --->
	<cfparam name="Attributes.codigo" 			type="string"> <!--- nombre unico de instancia del TAG --->
	<cfparam name="Attributes.codigo"  			type="string"> <!--- codigo del reporte --->
<!--- </cfif>
<cfif ThisTag.ExecutionMode is 'end'> --->

	<cfhtmlhead text='<script src="/cfmx/commons/js/print-wizard.js"></script>'>
	<cfhtmlhead text='<script src="/cfmx/commons/GeneraReportes/js/ReporteColumna.js"></script>'>

	<cfset Session.rtp_Codigo = "#Attributes.codigo#">
	<cfquery name="rsRPT" datasource="#Session.DSN#">
		select RPTId,RPCodigo,RPDescripcion from RT_Reporte where (Ecodigo = #Session.Ecodigo# or Ecodigo is null) and RPCodigo = '#Attributes.codigo#'
	</cfquery>
	<!--- <cf_dump var="#rsRPT#"> --->

	<cfset Session.rtp_Id = "#rsRPT.RPTId#">

	<div id="popupWizard_<cfoutput>#Attributes.codigo#</cfoutput>" style="display: none;">
	</div>

	<i class='fa fa-print' style='cursor:pointer;' onclick='showWiz_<cfoutput>#Attributes.codigo#</cfoutput>(0);'>&nbsp;<cfoutput>#rsRPT.RPDescripcion#</cfoutput></i>

	<script type="text/javascript">


		function showWiz_<cfoutput>#Attributes.codigo#</cfoutput>(lvarpage)
		{
			$.ajax({
			    url : "../../commons/Componentes/PrintWizard.cfc?method=getPage",
			    type: "POST",
			    data : {
			    	page: lvarpage,
			    	codigo: '<cfoutput>#Attributes.codigo#</cfoutput>'
			    },
			    success: function(result){
			    	$("#popupWizard_<cfoutput>#Attributes.codigo#</cfoutput>").html(result);
			    },
			    error: function (request, error) {
			        alert("Error Inesperado");
			    }
			});


			$("#popupWizard_<cfoutput>#Attributes.codigo#</cfoutput>").dialog({
		        width: 850,
		        modal:true,
		        title:"Asistente de Reporte",
		        height: 600,
		        resizable: "false",
		    });
		}
	</script>

	<!--- <script type="text/javascript">
	    $('#rootwizard').bootstrapWizard({'tabClass': 'nav nav-tabs'});
	</script> --->

<!--- </cfif> --->
