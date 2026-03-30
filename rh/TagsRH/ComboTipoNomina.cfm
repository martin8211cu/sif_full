<cfparam name="Attributes.Tcodigo" 	 default="-1" 		type="String">
<cfparam name="Attributes.readonly"  default="false" 	type="boolean">

<cfwindow x="310" y="100" width="300" height="300" name="newTiposNomina"
        minHeight="300" minWidth="300" title="Nuevo Tipo de Nomina" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboTipoNomina.cfm?Tcodigo=#Attributes.Tcodigo#"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboTipoNomina-div.cfm?print=true&Tcodigo=#Attributes.Tcodigo#&readonly=#Attributes.readonly#" ID="theDivPrintTnom"/>
<script>
	function ValidaNewTnom(){
		msg = '';
		if(document.getElementById('NewTcodigo').value == '')
			msg += 'El codigo del tipo de nomina es requerido';
		if(document.getElementById('NewTdescripcion').value == '')
			msg += '\nLa descripción del tipo de nomina ses requerida';	
		if(msg == ''){
			document.getElementById('NewTnomCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewTnomCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintTnom (NewTcodigo){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboTipoNomina-div.cfm?print=true&readonly=<cfoutput>#Attributes.readonly#</cfoutput>&Tcodigo='+NewTcodigo,'theDivPrintTnom');
	}
</script>