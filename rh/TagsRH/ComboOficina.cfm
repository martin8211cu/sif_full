<cfparam name="Attributes.Ocodigo"  default="-1" type="String">
<cfwindow x="310" y="100" width="300" height="300" name="newOficina"
        minHeight="300" minWidth="300" title="Nueva Oficina" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboOficina.cfm?Ocodigo=#Attributes.Ocodigo#"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboOficina-div.cfm?print=true&Ocodigo=#Attributes.Ocodigo#" ID="theDivPrintOfi"/>
<script>
	function ValidaNewOfi(){
		msg = '';
		if(document.getElementById('NewOficodigo').value == '')
			msg += 'El Codigo de la Oficina es requerido';
		if(document.getElementById('NewOdescripcion').value == '')
			msg += '\nLa descripción de la Oficina es requerida';	
		if(msg == ''){
			document.getElementById('NewOfiCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewOfiCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintOfi(NewOcodigo){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboOficina-div.cfm?print=true&Ocodigo='+NewOcodigo,'theDivPrintOfi');
	}
</script>