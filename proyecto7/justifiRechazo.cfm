<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
    
<div  class="titulo">Justificación del Rechazo</div>
<form name="temporal" method="post" action="/sif/cm/operacion/evaluar-Aplicar.cfm">
 <cfif isdefined("url.Ecodigo")>
 	<cfoutput>
  		<input type="hidden" name="Ecodigo" id="Ecodigo" value="#url.Ecodigo#" />
  	</cfoutput>
 </cfif>
    <div align="center">
        <input type="text" name="CMPjustificacionRechazo" id="CMPjustificacionRechazo" value="" style="width:300px"  />
      <table align="center">
      	<tr>
        	<td>  
        	<a class="btnRechazar" id="btnRechazar" style="cursor:pointer;float:none" title="Rechazar" onclick="funcRechazo()"></a>
            </td>
            <td>
        	<a class="btnCancelar" id="btnCancelar" style="cursor:pointer;float:none" title="Cancelar" onclick="window.parent.fnLightBoxClose_JustRechazo()"></a>
            </td>
        </tr>
     </table>
    </div>
    <cfif isdefined("url.CMPi")>
    	<input type="hidden" name="CMPi" id="CMPi" value="<cfoutput>#url.CMPi#</cfoutput>" />
    <cfelseif isdefined("url.EOidorden")>
		<cfoutput>
            <input type="hidden" name="EOidorden" 	value="#url.Nivel#">
            <input type="hidden" name="CMAid" 		value="#url.EOidorden#">
            <input type="hidden" name="Nivel" 		value="#url.EOidorden#">
            <input type="hidden" name="notificar"  id="notificar" 	value="">
        </cfoutput>
    </cfif>
</form>
<cfif isdefined("url.CMPi")>
<script language="javascript" type="text/javascript">
	function funcRechazo(){
		if(document.temporal.CMPjustificacionRechazo.value.replace(/^\s+|\s+$/g,"") == ""){
			alert("El campo Justificación Rechazo es requerido.");
			return false;
		}
		if(!confirm("Está seguro de Rechazar la cotización?")){
			return false;
		}
		else{
			 <cfif isdefined("url.Ecodigo")>
				 <cfoutput>
				 window.parent.document.lista.action = "/cfmx/sif/cm/operacion/evaluar-Aplicar.cfm?chk="+document.temporal.CMPi.value+"&btnRechazar=btnRechazar&CMPjustificacionRechazo="+document.temporal.CMPjustificacionRechazo.value+"&Ecodigo=#url.Ecodigo#";	
				 </cfoutput>		 
			 </cfif>
			
			window.parent.document.lista.submit();
			window.parent.fnLightBoxClose_JustRechazo();
			return true;
		}
	}
</script>
<cfelseif isdefined("url.EOidorden")>
<script language="javascript" type="text/javascript">
	function funcRechazo(){
		if(document.temporal.CMPjustificacionRechazo.value.replace(/^\s+|\s+$/g,"") == ""){
			alert("El campo Justificación Rechazo es requerido.");
			return false;
		}
		if(!confirm("Está seguro de Rechazar la Orden de Compra?")){
			return false;
		}
		else{
			 if(confirm("Desea enviar una notificación al comprador responsable?"))
				 window.parent.document.formX.notificar.value=1;		 		 
			else
				 window.parent.document.formX.notificar.value=0;	 
				 
			window.parent.document.formX.Nivel.value ="<cfoutput>#url.Nivel#</cfoutput>";
			window.parent.document.formX.CMAid.value = "<cfoutput>#url.CMAid#</cfoutput>";
			window.parent.document.formX.justificacion.value = document.temporal.CMPjustificacionRechazo.value;
			window.parent.document.formX.EOidorden.value = "<cfoutput>#url.EOidorden#</cfoutput>"
			window.parent.document.formX.action = "autorizaOrden-sql.cfm?btnRechazar=btnRechazar";
			window.parent.document.formX.submit();
			window.parent.fnLightBoxClose_JustRechazo();
			return true;
		}
	}
</script>
</cfif>