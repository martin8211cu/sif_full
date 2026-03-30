<!--- Variables Generales --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!--- Pintado de la pantalla --->
<cf_templateheader template="#session.sitio.template#" title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 		
				<td width="60%" valign="top">
					<cfinclude template="ctasmayor-form.cfm">
				</td>
				<td width="40%" valign="top">
					<cfoutput>
						<form method="post" name="form1" id="form1" action="ctasmayor-sql.cfm">
							<table width="98%" align="center" cellpadding="0" cellspacing="0" style="border:1px solid ##cccccc;">
								<tr><td class="tituloListas" align="center">Agregar Cuentas</td></tr>
								<tr><td nowrap="nowrap"> Cuenta <label>(Digite la cuenta mayor y presione TAB)</label></td></tr>
								<tr>
									<td>
										<cfset ArrayCuenta=ArrayNew(1)>
										<cf_cajascuenta tabindex="1" objeto="formato" Completar=true CompletarTodo=true CaracterComp="_">
										<input type="hidden" name="modo" value="ALTA" tabindex="-1">
									</td>
								</tr>
								<tr>
									<td align="center">
										<cf_botones values="Agregar" tabindex="2">
									</td>
								</tr>
							</table>
						</form>	
					</cfoutput>	
				</td>
			</tr> 
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<!--- JavaScript --->
<script language="javascript1.2" type="text/javascript">
	<!--//
	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction(){
		// RetornaCuenta() es máscara parcial, permite digitar cuentas padre
		window.cuentasIframe.RetornaCuenta();
	}
	//Se ejecuta al inicio del Form
	try{
		document.form1.formato.focus();
	}catch(e){
		//No hace nada
	}	
	//Se dispara desde el botón de Agregar
	function funcAgregar() {			
		FrameFunction();
		var valido=true;		
		if (document.form1.txt_Cmayor.value == "") {
			alert('Debe de digitar una Cuenta de Mayor.');
			return false
		}
		if (document.form1.formato.value == "") {
			alert('Debe de digitar la mascara de la cuenta de mayor.');
			return false
		}
		return true;
	}
	//-->
</script>