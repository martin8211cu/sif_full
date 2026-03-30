<cfparam name="Attributes.RVid"  		default="-1" 	type="String">
<cfparam name="Attributes.readonly"  	default="false" type="boolean">
<cfparam name="Attributes.width"  	    default="auto"  type="String">
<cfparam name="Attributes.onchange"  	default=""      type="String">

<cfwindow center="true" width="600" height="400" name="newRegimen"
        minHeight="400" minWidth="600" title="Nuevo Regimen de Vacaciones" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboRegimenVaca.cfm?RVid=#Attributes.RVid#" refreshOnShow="true"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboRegimenVaca-div.cfm?print=true&RVid=#Attributes.RVid#&readonly=#Attributes.readonly#&width=#Attributes.width#&onchange=#Attributes.onchange#" ID="theDivPrintReg"/>
<script>
	function ValidaNewReg(){
		msg = '';
		<!---if(document.getElementById('NewOficodigo').value == '')
			msg += 'El Codigo de la Oficina es requerido';
		if(document.getElementById('NewOdescripcion').value == '')
			msg += '\nLa descripción de la Oficina es requerida';	--->
		if(msg == ''){
			document.getElementById('NewRegCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewRegCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintReg(NewRVid){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboRegimenVaca-div.cfm?print=true&onchange=<cfoutput>#Attributes.onchange#</cfoutput>&readonly=<cfoutput>#Attributes.readonly#</cfoutput>&width=#Attributes.width#&RVid='+NewRVid,'theDivPrintReg');
	}
</script>

<script type="text/javascript">
	window.onload = function() {
		if (window.innerHeight < document.body.scrollHeight) {
			window.resizeBy(window.innerWidth + 50, window.innerHeight + 50);
		}
	}
</script>