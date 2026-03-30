<!--- <cf_dump var="DMcontacto"> --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.border01 {
	border: thin solid #000000;
}
-->
</style>
 
<style type="text/css">
<!--
@import url("../stylesheet.css");
-->
</style>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" marginwidth="0" marginheight="0" bottommargin="0">

	<cfquery name="rsPaises" datasource="asp">
		select Ppais,Pnombre
		from Pais
		Order by Pnombre
	</cfquery>
	
	<cfquery name="rsMonedas" datasource="asp">
		select Mcodigo, Mnombre
		from Moneda
		Order by Mnombre
	</cfquery>
	
	<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="">
		<tr> 
			<td colspan="2"  bgcolor="">
				<form name="form1" method="POST" action="demo/SQLDMcontacto.cfm" onSubmit="javascript: return validar();"><!---CorreoPerfil.cfm--->
					<p>
						<input type="hidden" name="recipient" value="netsol@sitiotico.com">
						<input type="hidden" name="redirect" value="http://netssolutions.com.com/gracias.html">
						<input type="hidden" name="subject" value="pagina web NETS SOLUTIONS">
					</p>					
					<table width="100%" height="434" border="0" align="center" cellpadding="0" cellspacing="0">
						<tr> 
							<td width="39%">
								<font face="Verdana" size="1" color="#003366">&nbsp;&nbsp;&nbsp;Seleccione un Producto<br></font>
								&nbsp;&nbsp;
								<font color="#003366" size="1"> 
								  <select name="Rproducto" size="1" id="Rproducto" style="border: 1px solid #FFFFFF">
									<option></option>
									<option value="RH">Soin - Recursos Humanos</option>
									<option value="SIF">Soin - SIF</option>
									<option value="Educacion">Educaci&oacute;n</option>
								  </select>
								</font>
							</td>
							<td width="1%" rowspan="9" valign="top"><font size="1"><img src="/images/linea.jpg" width="1" height="410"></font></td>
							<td width="60%"><font color="#003366" size="1"><font face="Verdana">&nbsp;&nbsp; Giro de Negocio<br>
							  </font><span lang="ES-CR" style="font-family: Verdana; font-weight: 700"> 
							  &nbsp;&nbsp;&nbsp; </span></font><font size="1"><b><font face="Verdana" color="#003366"> 
							  <select name="Rareacomercial" size="1" style="border: 1px solid #FFFFFF">
								<option> </option>
								<option value="Comercio">Comercio</option>
								<option value="Produccion">Produccion</option>
								<option value="Contaduria">Contaduria</option>
								<option value="Distribucion">Distribucion</option>
								<option value="Ventas">Ventas</option>
								<option value="Turismo">Turismo</option>
								<option value="Mecanica">Mecanica</option>
								<option value="Medicina(doctores)">Medicina(doctores)</option>
								<option value="Legal(abogados)">Legal(abogados)</option>
							  </select>
							  </font></b></font>
							</td>
						</tr>
						<tr> 
							<td><font face="Verdana" size="1" color="#003366">&nbsp;&nbsp;&nbsp; 
								<span lang="ES-CR">Nombre</span><br>
								</font> <font color="#003366" size="1">&nbsp;&nbsp;&nbsp;&nbsp; 
								<input name="Pnombre" type="text" style="border: 1px solid #003366; " size="38" maxlength="60">
								</font>
							</td>
							<td><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp; 
								Nombre de la Empresa<br>
								&nbsp;&nbsp; </font> <font color="#003366" size="1"> 
								<input name="Pnombreemp" type="text" id="Pnombreemp" style="border: 1px solid #003366; " size="40" maxlength="80">
								</font>
							</td>
						</tr>
					  	<tr> 
							<td><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp; 
							  <span lang="ES-CR">Primer apellido<br>
							  </span> &nbsp;&nbsp;&nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Papellido1" type="text" style="border: 1px solid #003366; " size="38" maxlength="60">
							  </font>
							</td>
							<td><font color="#003366" size="1"><font face="Verdana">&nbsp;&nbsp; 
							  N&uacute;mero de Empleados<br>
							  </font><span style="font-family: Verdana; font-weight: 700">&nbsp;&nbsp;&nbsp; 
							  </span> </font><font size="1"><b><font face="Verdana" color="#003366"> 
							  <select name="Rnumemp" size="1" style="border: 1px solid #FFFFFF">
								<option> </option>
								<option value="0">0 a 50</option>
								<option value="50">50 a 100</option>
								<option value="100">100 a 500</option>
								<option value="500">500 a 1000</option>
								<option value="1000">mas de 1000</option>
							  </select>
							  </font></b></font>
							</td>
					  	</tr>
					  	<tr> 
							<td><font color="#003366" size="1" face="Verdana"><span lang="ES-CR">&nbsp;&nbsp;&nbsp;&nbsp;Segundo apellido<br>
							  </span>&nbsp; &nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Papellido2" type="text" style="border: 1px solid #003366; " size="38" maxlength="60">
							  </font></td>
							<td><font color="#003366" size="1"><font face="Verdana">&nbsp;&nbsp; 
							  Pa&iacute;s<br>
							  </font><span style="font-family: Verdana; font-weight: 700">&nbsp;&nbsp;&nbsp; 
							  </span> </font><font size="1"><b><font face="Verdana" color="#003366"> 
							  <select name="Ppais" size="1" style="border: 1px solid #FFFFFF">
								<option> </option>
								<cfoutput>
									<cfloop query="rsPaises">								
										<option value="#rsPaises.Ppais#">#HTMLEditformat(rsPaises.Pnombre)#</option>
									</cfloop>
								</cfoutput>
							  </select>
							</font></b></font>
							</td>						
					  	</tr>
						<tr> 
							<td height="37"><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp; 
							  <span lang="ES-CR">&nbsp;Rol de Contacto</span><br>
							  &nbsp; &nbsp; </font> <font color="#003366" size="1"> 
							  <select name="Rrol" size="1" id="Rrol">
								<option> </option>
								<option value="CEO/Owner/Principal">CEO/Owner/Principal</option>
								<option value="Sales Manager/User">Sales Manager/User</option>
								<option value="Support Manager/User">Support Manager/User</option>
								<option value="Marketing Manager/User">Marketing Manager/User</option>
								<option value="Finance Manager/user">Finance Manager/user</option>
								<option value="WarehouseManager/User">WarehouseManager/User</option>
								<option value="IS/IT manager">IS/IT manager</option>
								<option value="Website Manager">Website Manager</option>
							  </select>
							</font>
							</td>
							<td><font color="#003366" size="1"><font face="Verdana">&nbsp;&nbsp; 
							  Moneda<br>
							  </font><span style="font-family: Verdana; font-weight: 700">&nbsp;&nbsp;&nbsp; 
							  </span> </font><font size="1"><b><font face="Verdana" color="#003366"> 
							  <select name="Mcodigo" size="1" style="border: 1px solid #FFFFFF">
								<option> </option>
								<cfoutput>
									<cfloop query="rsMonedas">								
										<option value="#rsMonedas.Mcodigo#">#HTMLEditformat(rsMonedas.Mnombre)#</option>
									</cfloop>
								</cfoutput>
							  </select>
							</font></b></font>
							</td>		
					  	</tr>
						<tr> 
							<td><font color="#003366" size="1" face="Verdana">&nbsp; 
							  &nbsp;&nbsp;Tel&eacute;fono<br>
							  &nbsp;&nbsp;&nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Poficina" type="text" style="border: 1px solid #003366; " size="25" maxlength="30">						 
							</font></td>
							<td> 
							  <font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&iquest;Como Escuch&oacute; de Nosotros?<br></font>
							  &nbsp;&nbsp;
							  <font color="#003366" size="1"> 
							  <select name="Rescucho" size="1"  id="Rescucho">
								<option> </option>
								<option value="Anuncios">Anuncios</option>
								<option value="Correo Directo">Correo Directo</option>
								<option value="Correo Electronico">Correo Electr&oacute;nico</option>
								<option value="Amigo/Asociado">Amigo/Asociado</option>
								<option value="Online Banner/Ad">Online Banner/Ad</option>
								<option value="Press Releases Article">Press Releases Article</option>
								<option value="Print">Print</option>
								<option value="Programa de Radio">Programa de Radio</option>
								<option value="Search Engine">Search Engine</option>
								<option value="Solution Provider/Consultant">Solution Provider/Consultant</option>
								<option value="Trade Show">Trade Show</option>
								<option value="Seminario Web">Seminario Web</option>
							  </select>
							  </font>
							</td>														
						</tr>
					  	<tr> 
							<td ><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp; 
							  Fax&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
							  &nbsp;<br>
							  &nbsp;&nbsp;&nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Pfax" type="text" style="border: 1px solid #003366; " size="25" maxlength="30">
							</font>
							</td>			
							<td rowspan="2">
								<font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp;Observaciones<br>&nbsp;&nbsp;</font> 
								<font color="#003366" size="1">
								<textarea name="Observaciones" rows="5" cols="50"></textarea> 
								</font>
							</td>			
						</tr>
					  	<tr> 
							<td><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp; 
							  C&oacute;digo Postal<br>
							  &nbsp;&nbsp;&nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Codpostal" type="text" style="border: 1px solid #003366; " size="30" maxlength="30">
							</font></td>
											
					  	</tr>
					  	<tr> 
							<td height="58" ><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp; 
							  E-mail<br>
							  &nbsp; &nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Pemail1" type="text" style="border: 1px solid #003366; " size="40" maxlength="60"> 
							</font></td>
							<td ><font color="#003366" size="1" face="Verdana">&nbsp;&nbsp;&nbsp; 
							  Verifique el E-mail<br>
							  &nbsp; &nbsp; </font> <font color="#003366" size="1"> 
							  <input name="Pemail2" type="text" style="border: 1px solid #003366; " size="40" maxlength="60" onBlur="javascript: funcValida(this);"> 
							  </font></td>
						</tr>
						<tr>
							<td align="center" colspan="3">
							  <p><font color="#003366" size="1"> &nbsp;&nbsp;&nbsp;&nbsp; 
								<input name="submit" type="submit" value="Enviar">
								<img src="../images/pixel.gif" width="20" height="10" border="0"> 
								<input name="reset" type="reset" value="Limpiar">
								</font></p>
							</td>
					  	</tr>
					</table>
                	<p align="center"> 

				</form>
			</td>
		</tr>
	</table></td>
	</tr>
	</table></td>
	</tr>
	</table>
	<script language="JavaScript1.2" type="text/javascript">				
		function funcValida(obj){//Valida q' los email sean iguales
			if (document.form1.Pemail1.value != obj.value){
				alert("Los correos electrónicos ingresados deben ser iguales")
				obj.value = "";
				obj.focus();
			}
		}
		
		function validar(){
			var error = '';

			if ( document.form1.Pnombreemp.value == '' ) {
				error = error + ' - El campo nombre de la empresa es requerido.\n';
			}
	
			if ( document.form1.Rproducto.value == '' ){				
				error = error + ' - El campo producto es requerido.\n';
			} 
					
			if ( document.form1.Pnombre.value == '' ) {
				error = error + ' - El campo nombre es requerido.\n';
			} 
			
			if ( document.form1.Papellido1.value == '' ) {
				error = error + ' - El campo primer apellido es requerido.\n';
			} 
			
			if ( document.form1.Papellido2.value == '' ) {
				error = error + ' - El campo segundo apellido es requerido.\n';
			} 
			
			if ( document.form1.Rrol.value == '' ) {
				error = error + ' - El campo rol del contact es requerido.\n';
			} 
			
			if ( document.form1.Pemail1.value == '' ) {
				error = error + ' - El campo e-mail es requerido.\n';
			} 
	
			if ( document.form1.Poficina.value == '' ) {
				error = error + ' - El campo número telefónico es requerido.\n';
			} 
			
			if ( document.form1.Ppais.value == '' ) {
				error = error + ' - El campo país es requerido.\n';
			} 
	
			if ( document.form1.Codpostal.value == '' ) {
				error = error + ' - El campo código postal es requerido.\n';
			} 
	
			if ( document.form1.Rnumemp.value == '' ) {
				error = error + ' - El campo es requerido.\n';
			} 
	
			if ( document.form1.Rareacomercial.value == '' ) {
				error = error + ' - El campo giro de negocio es requerido.\n';
			} 
	
			if ( document.form1.Rescucho.value == '' ) {
				error = error + ' - El campo cómo escucho de nosotros es requerido.\n';
			} 
	
			if ( document.form1.Mcodigo.value == '' ) {
				error = error + ' - El campo Moneda es requerido.\n';
			} 
			
			var email = true;
			if ( document.form1.Pemail1.value == '' ){
				error = error + ' - El campo E-mail es requerido.\n';
				email = false;
			}	

			if ( document.form1.Pemail2.value == '' ){
				error = error + ' - El campo verificar E-mail es requerido.\n';
				email = false;
			}	

			if (email){
				if ( (document.form1.Pemail1.value != document.form1.Pemail2.value) ){
					error = error + ' - Verifique que los correos electrónicos ingresados sean iguales';
				}	
			}

			if (error != '' ){
				alert('Se presentaron los siguientes errores: \n' + error);
				return false
			}
			
			return true;
		}
	</script>
</body>
</html>