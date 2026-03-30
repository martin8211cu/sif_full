<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Inhabilitaci&oacute;n Agentes</title>
<style type="text/css">
<!--
.style3 {
	color: #333333;
	font-weight: bold;
}
.style6 {font-size: x-small}
.style7 {font-size: 16px}
.style9 {font-size: 12px; font-weight: bold; }
-->
</style>
<body>


	<cfif isdefined("url.AGid")><cfparam name="AGid" default="#url.AGid#"></cfif>


	<cfif isdefined("form.Aceptar") and isdefined("form.MBmotivo") and Len(Trim(form.MBmotivo))>
			<cfoutput>
				<script language="javascript" type="text/javascript">
					window.opener.Inhabilitar('#form.MBmotivo#','#form.AGid#','#form.BLobs#');
					window.close();
				</script>
			</cfoutput>
			<!---<cfset solicitarDatos = false>--->
	<cfelseif isdefined("form.Cancelar")>
			<cfoutput>
				<script language="javascript" type="text/javascript">
					window.close();
				</script>
			</cfoutput>	
	</cfif>

		<cfquery name="rsmotivos" datasource="#session.dsn#">
			select MBmotivo, MBdescripcion
			from ISBmotivoBloqueo
		</cfquery>
	

		<form name="form1" method="post" onSubmit="return ValidaConlis(this);" style="margin: 0;" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
			<input type="hidden" name="AGid" value="<cfoutput>#AGid#</cfoutput>">

			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			  <tr>
			    <td ><div align="center" class="style3">
			      <h1 class="style7"><label><span class="style7">Inhabilitación de Agentes Autorizados.</span></label> </h1>
			    </div></td>
		      </tr>
			  <tr>
			    <td ><div align="center" class="style6">
			      <div align="center">Atención...<br>
				  Se realizará el bloqueo de los logines<br> 
				  asociados a la cuenta del agente,<br>
			      por el motivo que sea seleccionado.
			      </div>
			    </div></td>
		      </tr>			  
			  
			  <tr>
				<td>
				  <div align="left" class="style9">Seleccione un motivo de Bloqueo: </div>				</td>
			  </tr>
			  <tr>
				<td>	<cf_conlis 
						title = "Motivos de Bloqueo"
						campos = "MBmotivo,MBdescripcion"
						desplegables = "S,S" 
						modificables = "S,S"
						size = "5,40"
						tabla = "ISBmotivoBloqueo"
						columnas = "MBmotivo,MBdescripcion" 
						filtro = "MBagente = 1 and Habilitado = 1"
						filtrar_por = ""
						desplegar = "MBmotivo, MBdescripcion"
						etiquetas = "C&oacute;digo,Descripci&oacute;n"
						formatos = "S,S"
						align = "left,left"
						asignar = "MBmotivo,MBdescripcion"
						form = "form1"
						asignarformatos = "S,S"
						closeOnExit = "true"
						tabindex="1"						
						readonly="false">				</td>
			  </tr>
			  <tr>&nbsp;&nbsp;
				<td><div align="left" class="style9">Observaciones: </div>
				<textarea name="BLobs" id="BLobs" rows="3" onblur="javascript: this.value = this.value.toUpperCase(); " style="width: 100%" tabindex="1"></textarea>				</td>
			  </tr>
			  <tr>
				<td align="center" >
				<cf_botones names="Aceptar,Cancelar" values="Aceptar,Cancelar" tabindex="-1"></td>		 	
			  </tr>				  
			</table>
		</form>
	
		<script language="javascript" type="text/javascript">
			function ValidaConlis(formulario) {
			var error_input;
			var error_msg = '';
			
				if (formulario.MBmotivo && formulario.MBmotivo.value == '') {
				error_msg += "\n - Seleccione un motivo de bloqueo.";
				error_input = formulario.MBmotivo;}
			
			
				if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.BLobs.value))) 
			
				{
					error_msg += "\n - El campo Observaciones tiene caracteres no válidos.";
					error_input = formulario.BLobs;
				}
			
				if (formulario.BLobs.value.length > 255) 
			
				{
					error_msg += "\n - El campo Observaciones tiene un máximo de 255 caracteres.";
					error_input = formulario.BLobs;
				}
				
				if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;}
			}
			
			function funcCancelar() {
				window.close();
			
			}
			
		</script>
</body>
</html>



				