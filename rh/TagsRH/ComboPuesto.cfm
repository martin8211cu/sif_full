<cfparam name="Attributes.RHPcodigo"  	default="-1" 	type="String">
<cfparam name="Attributes.readonly" 	default="false" type="boolean">
<cfparam name="Attributes.width"   		default="auto"  type="String">
<cfparam name="Attributes.onchange"  	default=""      type="String">

<cfwindow x="310" y="100" width="300" height="300" name="newPuesto"
        minHeight="300" minWidth="300" title="Nuevo Puesto" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboPuesto.cfm?RHPcodigo=#Attributes.RHPcodigo#" refreshOnShow="true"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboPuesto-div.cfm?print=true&RHPcodigo=#Attributes.RHPcodigo#&readonly=#Attributes.readonly#&width=#Attributes.width#&onchange=#Attributes.onchange#" ID="theDivPrintPues"/>
<script>
	function ValidaNewPues(){
		msg = '';
		if(document.getElementById('NewRHPcodigo').value == '')
			msg += 'El Codigo del Puesto es requerido';
		if(document.getElementById('NewRHPdescpuesto').value == '')
			msg += '\nLa descripción del Puesto es requerida';	
		if(msg == ''){
			document.getElementById('NewPuesCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewPuesCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintPues(NewRHPcodigo){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboPuesto-div.cfm?print=true&onchange=<cfoutput>#Attributes.onchange#</cfoutput>&readonly=<cfoutput>#Attributes.readonly#</cfoutput>&width=#Attributes.width#&RHPcodigo='+NewRHPcodigo,'theDivPrintPues');
	}
</script>