<cfparam name="Attributes.RHJid"  		default="-1" 	type="String">
<cfparam name="Attributes.readonly"  	default="false" type="boolean">
<cfparam name="Attributes.width"  	    default="auto"  type="String">
<cfparam name="Attributes.onchange"  	default=""      type="String">

<cfwindow x="310" y="100" width="300" height="300" name="newJornada"
        minHeight="300" minWidth="300" title="Nueva Jornada" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboJornada.cfm?RHJid=#Attributes.RHJid#" refreshOnShow="true"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboJornada-div.cfm?print=true&RHJid=#Attributes.RHJid#&readonly=#Attributes.readonly#&width=#Attributes.width#&onchange=#Attributes.onchange#" ID="theDivPrintJor"/>
<script>
	function ValidaNewJor(){
		msg = '';
		if(document.getElementById('NewRHJcodigo').value == '')
			msg += 'El Codigo de la jornada es requerido';
		if(document.getElementById('NewRHJdescripcion').value == '')
			msg += '\nLa descripción de la jornada es requerida';	
		if(msg == ''){
			document.getElementById('NewJorCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewJorCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintJor(NewRHJid){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboJornada-div.cfm?print=true&onchange=<cfoutput>#Attributes.onchange#</cfoutput>&readonly=<cfoutput>#Attributes.readonly#</cfoutput>&width=<cfoutput>#Attributes.width#</cfoutput>&RHJid='+NewRHJid,'theDivPrintJor');
	}
</script>