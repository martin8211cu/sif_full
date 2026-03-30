<!-- Establecimiento del modo -->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<form action="SQLMenu.cfm" method="post" name="form1" onSubmit="return validar();">
	<table width="100%" cellpadding="0" cellspacing="0">
		
		<tr>
			<td><cfinclude template="Datos.cfm"></td>
		</tr>
		
		<cfif modo eq 'ALTA'>
			<!--- Seleccion de Plantilla, solo en ALTA --->
			<tr id="plantilla" style="display:none" >
				<td><cfinclude template="Plantillas.cfm"></td>
			</tr>

		</cfif>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><input type="submit" name="btnAgregar" value="Agregar"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>		
	</table>
</form>

<script type="text/javascript" language="javascript1.2">
	function seleccion(value){
		var vEstilo = document.getElementById("plantilla");
		var vLink   = document.getElementById("link");

		if ( value == 'E' ){
			vEstilo.style.display = '';
			vLink.style.display = 'none';
		}
		else{
			vEstilo.style.display = 'none';
			vLink.style.display = '';
		}
		
	}
	
	function validar(){
	
		var msg   = "Se presentaron los siguientes errores:\n";
		var error = false;
		var colorError = "#FFFFCC";

		if (document.form1.MSMtexto.value == '' ){
			msg += " - El campo Nombre es requerido.\n"
			document.form1.MSMtexto.style.backgroundColor = colorError;
			error = true;
		}

		if (document.form1.MSMorden.value == '' ){
			msg += " - El campo Orden es requerido.\n"
			document.form1.MSMorden.style.backgroundColor = colorError;
			error = true;
		}
		
		if ( document.form1.MSMestilo.value == 'E' && document.form1.MSPplantilla.value == '' ){
			msg += " - Debe seleccionar una plantilla.\n"
			error = true;
		}

		if ( document.form1.MSMestilo.value == 'L' && document.form1.MSMlink.value == '' ){
			msg += " - El campo Link es requerido.\n"
			error = true;
		}


		if (error){
			alert(msg);
			return !error;
		}

		return true;
	}
	
	function reset_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}
	
	<cfif modo eq 'ALTA'>
		seleccion(document.form1.MSMestilo.value);
	</cfif>
	
</script>