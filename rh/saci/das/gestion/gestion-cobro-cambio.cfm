<cfif ExisteCuenta>
	<cfquery name="rsExisteTarea" datasource="#session.DSN#">
		select TPid,TPxml,TPfecha
		from ISBtareaProgramada 
		where 	CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and TPestado = 'P'
				and TPtipo = 'CFC'
	</cfquery>
	
	<cfoutput>
  		<form action="gestion-cobro-apply.cfm" name="form1" style="margin:0" method="post" onsubmit="return validar(this);">
			<cfinclude template="gestion-hiddens.cfm">
			<table width="100%"cellpadding="0" cellspacing="2" border="0">
				<!----Pintado del XSL---->
				<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Tarea Programada</td></tr>	
				<cfif isdefined("rsExisteTarea.TPid") and len(trim(rsExisteTarea.TPid))>
					<tr><td align="center"><label>Fecha Programada</label>
						&nbsp;#LSDateFormat(rsExisteTarea.TPfecha,'dd/mm/yyyy')#</td>
					</tr>
					<tr><td>
						<cfsavecontent variable="xsl"><cfinclude template="/saci/xsd/cambioFormaCobro.xsl"></cfsavecontent>
						<cfoutput>#XmlTransform(rsExisteTarea.TPxml, xsl)#</cfoutput>
					</td></tr>
					<tr><td align="center">
							<cf_botones names="Eliminar" values="Eliminar">
					</td></tr>
					<tr><td><hr /></td></tr>
				<cfelse>
					<tr><td align="center"><strong>--- No Existe Tarea Programada ---</strong></td></tr>
				</cfif>
				<!----Pintado del XML---->
				<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Cambio de Forma de Cobro</td></tr>	
				  
				<tr><td>	
					<cfif isdefined("url.PQnuevo")and len(trim(url.PQnuevo))> 
						<cfset PQnuevo=url.PQnuevo>
					<cfelse>
						<cfset PQnuevo ="">				
					</cfif>
					<cf_cuenta 
						id = "#Form.CTid#"
						idpersona = "#Form.cliente#"
						filtroAgente = ""
						form = "form1"
						Ecodigo = "#Session.Ecodigo#"
						Conexion = "#Session.DSN#"
						paso = "3"
						readOnly = "true"
						sufijo="2"
						porfila="true"
					>
				</td>
			  </tr>
			  <tr><td align="center">
					<table cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td align="right"><input name="radio" type="radio" value="1" checked/></td>
								<td align="right"><label>Cambiar en la fecha</label></td>
								<td><cf_sifcalendario  name="fretiro" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
							<td align="right"><input name="radio" type="radio" value="2" /></td>
							<td><label>Cambiar en este momento</label></td>
						</tr>
					</table>
			  </td></tr>	
			
			  <tr><td>&nbsp;</td></tr>
					
			  <tr><td align="center">
			  		<cf_botones names="Cambiar,Regresar" values="Cambiar,Regresar">
					<script language="javascript" type="text/javascript">
						function funcRegresar(){
							document.form1.csub.value=false;
						}
					</script>
			  </td></tr>	
			</table>
		</form>
		<script language="javascript" type="text/javascript">
			function funcEliminar()
			{	
				if (confirm("¿Desea Eliminar la Tarea Programada?")){
					document.form1.botonSel.value="Eliminar";
					return true;
				}
				else return false;
			}
			function validar(formulario){
			
				if (document.form1.botonSel.value != "Eliminar"){
					var error_input;
					var error_msg = '';
					
					
					if(document.form1.CTcobro22.checked){
						if(document.form1.NumTarjeta2.value ==""){
							error_msg += "\n - El Número de Tarjeta es requerido.";
							error_input = document.getElementById("NumTarjeta2");
						}
						if(document.form1.MesTarjeta2.value ==""){
							error_msg += "\n - El Mes es requerido.";
							error_input = document.getElementById("MesTarjeta2");
						}
						if(document.form1.AnoTarjeta2.value ==""){
							error_msg += "\n - El Año es requerido.";
							error_input = document.getElementById("AnoTarjeta2");
						}
						if(document.form1.MTid2.value ==""){
							error_msg += "\n - El Tipo Tarjeta es requerido.";
							error_input = document.getElementById("MTid2");
						}
						if(document.form1.VerificaTarjeta2.value ==""){
							error_msg += "\n - Los Dígitos de Verificación son requeridos.";
							error_input = document.getElementById("MTid2");
						}
						if(document.form1.Ppais2.value ==""){
							error_msg += "\n - El País es requerido.";
							error_input = document.getElementById("Ppais2");
						}
						if(document.form1.NombreTarjeta2.value ==""){
							error_msg += "\n - El Nombre es requerido.";
							error_input = document.getElementById("NombreTarjeta2");
						}
						if(document.form1.Apellido1Tarjeta2.value ==""){
							error_msg += "\n - El Apellido 1 es requerido.";
							error_input = document.getElementById("Apellido1Tarjeta2");
						}
						if(document.form1.Apellido2Tarjeta2.value ==""){
							error_msg += "\n - El Apellido 2 es requerido.";
							error_input = document.getElementById("Apellido2Tarjeta2");
						}
						if(document.form1.CedulaTarjeta2.value ==""){
							error_msg += "\n - La Cédula es requerida.";
							error_input = document.getElementById("CedulaTarjeta2");
						} 	
					}
					if(document.form1.CTcobro32.checked){
						if(document.form1.CuentaTipo2.value ==""){
							error_msg += "\n - El Tipo de Cuenta es requerido.";
							error_input = document.getElementById("CuentaTipo2");
						}
						if(document.form1.NumCuenta2.value ==""){
							error_msg += "\n - El Número de Cuenta es requerido.";
							error_input = document.getElementById("NumCuenta2");
						}
						if(document.form1.EFid2.value ==""){
							error_msg += "\n - El Banco es requerido.";
							error_input = document.getElementById("EFid2");
						}
						if(document.form1.CedulaCuenta2.value ==""){
							error_msg += "\n - La Cédula es requerida.";
							error_input = document.getElementById("CedulaCuenta2");
						}					
						if(document.form1.NombreCuenta2.value ==""){
							error_msg += "\n - El Nombre es requerido.";
							error_input = document.getElementById("NombreCuenta2");
						}
						if(document.form1.Apellido1Cuenta2.value ==""){
							error_msg += "\n - El Apellido 1 es requerido.";
							error_input = document.getElementById("Apellido1Cuenta2");
						}
						if(document.form1.Apellido2Cuenta2.value ==""){
							error_msg += "\n - El Apellido 2 es requerido.";
							error_input = document.getElementById("Apellido2Cuenta2");
						}
					}
						
					
					if (document.form1.fretiro.value =="") {
						error_msg += "\n - Debe seleccionar una fecha para la ejecución de la tarea.";
						error_input = document.form1.fretiro;
					}
					
					<!--- Validacion terminada --->
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						if (error_input && error_input.focus) error_input.focus();
						return false;
					}
					else{
						if(confirm("¿Esta seguro que desea cambiar la forma de cobro?")){
							return true;				
						}else return false;
					}
					
			}else return true;
		}	
		</script>
	</cfoutput>
</cfif>