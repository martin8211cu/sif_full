<cfparam name="Attributes.CFid"  	default="-1" 	type="String">
<cfparam name="Agregar" 			default="true" 	type="boolean">
<cfparam name="Attributes.readonly" default="false" type="boolean">
<cfparam name="Attributes.width"  	default="auto"  type="String">

<cfwindow bodyStyle="background-color: ##ffffff" x="310" y="100" width="300" height="300" name="newCentroFuncional"
        minHeight="300" minWidth="300" title="Nuevo Centro Funcional" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboCentroFuncional.cfm?CFid=#Attributes.CFid#"/>
<cfset lvarFunciones = "">


<cfif isdefined('Attributes.onChange') and len(trim(Attributes.onChange))>
	<cfset lvarFunciones = "&onChange=#Attributes.onChange#">
</cfif>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboCentroFuncional-div.cfm?print=true&CFid=#Attributes.CFid#&Agregar=#Attributes.Agregar#&#lvarFunciones#&readonly=#Attributes.readonly#&width=#Attributes.width#" ID="theDivPrintCF"/>
<script>
	function ValidaNewCF()
	{
		msg = '';
		if(document.getElementById('NewCFcodigo').value == '')
			msg += 'El Codigo del Centro Funcional es requerido';
		if(document.getElementById('NewCFdescripcion').value == '')
			msg += '\nLa descripción del Centro Funcional es requerido';	
		if(document.getElementById('NewCFOcodigo').value == '')
			msg += '\nLa Oficina del Centro Funcional es requerido';
		if(document.getElementById('NewCFDcodigo').value == '')
			msg += '\nEl Departamento del Centro Funcional es requerido';
		if(msg == ''){
			document.getElementById('NewCFCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewCFCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintCF(NewCFid, Ocodigo, dep){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboCentroFuncional-div.cfm?print=true&Agregar=<cfoutput>#Attributes.Agregar#</cfoutput>&readonly=<cfoutput>#Attributes.readonly#</cfoutput>&width=#Attributes.width#&CFid='+NewCFid+'&Ocodigo='+Ocodigo,'theDivPrintCF');
	}
</script>