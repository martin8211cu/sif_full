<cfinclude template="tabNamesCata.cfm">

<form name="formHeader" method="post" action="">
	<input name="vDEid" id="vDEid" value="<cfif isdefined('form.DEid')><cfoutput>#form.DEid#</cfoutput></cfif>" type="hidden">
</form>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Debe_seleccionar_un_jugador"
	Default="Error, debe seleccionar a un jugador para acceder esta opción"
	returnvariable="vSeleccionarJugador"/>

<script language="JavaScript" type="text/javascript">
	function validaDEid(k,liga){
		var empl = document.formHeader.vDEid.value;
	
		if(k==1){
			if(empl != ''){
				location.href=liga + "&DEid=" + empl;		
			}else{
				location.href=liga;
			}
		}else{
			if(empl != ''){
				location.href=liga + "&DEid=" + empl;
			}else{
				alert('<cfoutput>#vSeleccionarJugador#</cfoutput>');
			}
		}
	}
</script>
