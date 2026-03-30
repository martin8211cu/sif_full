<cfinclude template="formPuestos-tabnames.cfm">

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>
<cfif isdefined("Url.RHDPPid") and not isdefined("Form.RHDPPid")>
	<cfset Form.RHDPPid = Url.RHDPPid>
</cfif>

<form name="formHeader" method="post" action="">
	<input name="vRHDPPid" id="vRHDPPid" value="<cfif isdefined('form.RHDPPid')><cfoutput>#form.RHDPPid#</cfoutput></cfif>" type="hidden">
	<input name="vRHPcodigo" id="vRHPcodigo" value="<cfif isdefined('form.RHPcodigo')><cfoutput>#form.RHPcodigo#</cfoutput></cfif>" type="hidden">
	<input name="vUSUARIO" id="vUSUARIO" value="<cfif isdefined('form.USUARIO')><cfoutput>#form.USUARIO#</cfoutput></cfif>" type="hidden">
</form>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion"
	Default="Debe seleccionar un puesto para acceder a esta opción"
	returnvariable="MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion"/>

<script language="JavaScript" type="text/javascript">
	function validaDEid(k,liga){
		var vRHDPPid   = document.formHeader.vRHDPPid.value;
		var vRHPcodigo = document.formHeader.vRHPcodigo.value;
		var vUSUARIO   = document.formHeader.vUSUARIO.value;
	
		if(k==1){
			if(vRHDPPid != ''){
				location.href=liga + "&RHDPPid=" + vRHDPPid + "&RHPcodigo=" + vRHPcodigo + "&USUARIO=" + vUSUARIO;		
			}else{
				location.href=liga;
			}
		}else{
			if(vRHDPPid != ''){
				location.href=liga + "&RHDPPid=" + vRHDPPid + "&RHPcodigo=" + vRHPcodigo + "&USUARIO=" + vUSUARIO;
			}else{
				alert('<cfoutput>#MSG_DebeSeleccionarUnPuestoParaVerEstaOpcion#</cfoutput>');
			}
		}
	}
</script>