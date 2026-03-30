<cfparam name="Attributes.Dcodigo"  default="-1" type="String">
<cfwindow x="310" y="100" width="300" height="300" name="newDepartamento"
        minHeight="300" minWidth="300" title="Nuevo Departamento" initshow="false"
        closable="false"
        source="/cfmx/rh/Utiles/ComboDepartamento.cfm?Dcodigo=#Attributes.Dcodigo#"/>
<cfdiv bind="url:/cfmx/rh/Utiles/ComboDepartamento-div.cfm?print=true&Dcodigo=#Attributes.Dcodigo#" ID="theDivPrintDep"/>
<script>
	function ValidaNewDep(){
		msg = '';
		if(document.getElementById('NewDeptocodigo').value == '')
			msg += 'El codigo del departamento es requerido';
		if(document.getElementById('NewDdescripcion').value == '')
			msg += '\nLa descripción del departamento es requerida';	
		if(msg == ''){
			document.getElementById('NewDepCorrecto').value = 1;
			return true;
		}
		else{
			alert(msg);
			document.getElementById('NewDepCorrecto').value = 0;
			return false;
		}
	}
	function refreshtheDivPrintDep(NewDcodigo){
		ColdFusion.navigate('/cfmx/rh/Utiles/ComboDepartamento-div.cfm?print=true&Dcodigo='+NewDcodigo,'theDivPrintDep');
	}
</script>