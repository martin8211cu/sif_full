 <cfoutput>
 <!--- <link href="/css/soinasp01_azul.css" rel="stylesheet" type="text/css"> --->

	<style type="text/css">
		body{padding: 20px;background: ##FFF;color: ##3C0012;text-align: center;
			font:85%/1.45 "Lucida Sans Unicode","Lucida Grande",Arial,sans-serif}
		h1{margin: 0;padding: 0 10px;letter-spacing: -1px;font-weight:100;color: ##FFF}
		h2{margin: 0;padding: 0 10px;letter-spacing: -1px;font-weight:100;color: white}
		h3{margin: 0;padding: 0 10px;letter-spacing: -1px;font-weight:100;color: ##80a440}
		
		h1{font-size: 150%}
		h2{font-size: 85%}
		h3{font-size: 150%}

		div##container{width:600px;margin: 0 auto;padding:10px 0;text-align:left}
		div##content{float:left;width:300px;padding:10px 0;background:url(images/Cuadro.png)}
		div##nav{float:right;width:300px;padding:10px 0;background:url(images/Cuadro1.png)}
		div##header{clear:both;width:602px;background: ##C4E786;padding:5px 0;text-align:center}
		div##footer{clear:both;width:602px;background: ##C4E786;padding:5px 0;text-align:center}

	</style>

<!--- Nifty Corners: incluir css y js --->
<link rel="stylesheet" type="text/css" href="/cfmx/commons/js/niftyCorners.css">
<script type="text/javascript" src="/cfmx/commons/js/nifty.js"></script>
<!--- Nifty Corners: modificar onload para que aplique Rounded(clase, "all/top/bottom", color, backcolor, "small/smooth/border") --->
	<script type="text/javascript">
		window.onload=function(){
			if(!NiftyCheck())
				return;
			Rounded("div##content",	"all",		"##FFF","transparent","smooth");
			Rounded("div##nav",		"all",		"##FFF","transparent","smooth");
			Rounded("div##footer",	"all",		"##FFF","##C4E786","smooth");
		}
	</script>
	<form style="margin:0" name="form1" method="post" onSubmit="return validar();">
	
	<div id="container">
		<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
			<tr>
				<td colspan="2">
					<div id="header">
						<h3>Bienvenido</h3>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div id="content">
						<h1>Login</h1>
								<table width="100%" border="0" cellspacing="1" cellpadding="1">
									<tr>
										<td>
											<p>Correo electr&oacute;nico</p>
										</td>
									</tr>
									<tr>
										<td>
											<input TYPE="text" NAME="txtUsername" SIZE=32 MAXLENGTH=32 alt="Usuario">
										</td>
									</tr>
									<tr>
										<td>
											<p>Contrase&ntilde;a</p>
										</td>
									</tr>
									<tr>
										<td>
											<input type="Password" NAME="txtPassword" SIZE=32 MAXLENGTH=32 alt="Password">
										</td>
									</tr>
									<tr>
									<td>
										<br>
									</td>
								</tr>
									<tr>
										<td align="center" nowrap="nowrap">
											<input style="font-size:11px" type="submit" NAME="txtLogueo"  value="Ingresar"  SIZE=32 MAXLENGTH=32 alt="Ingresar" onclick="javascript: putname(this);">
											<input style="font-size:11px" type="submit" NAME="txtOlvidar"  value="Olvid&eacute; mi clave"  SIZE=32 MAXLENGTH=32 alt="Olvid&eacute; mi clave" onclick="javascript: putname(this);">
											<input style="font-size:11px" type="submit" NAME="txtCambio"  value="Cambiar clave"  SIZE=32 MAXLENGTH=32 alt="Cambiar clave" onclick="javascript: putname(this);">
										</td>
									</tr>
								</table>
					</div>
				</td>
				<td valign="top">
					<div id="nav">
						<h1>Registrarse</h1>
							<table width="100%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td align="justify">
										<h2>Al registrase en nuestra selecta Base de Datos de Oferentes, usted podr&aacute;
										   incrementar la efectividad en la b&uacute;squeda de empleo, una pr&aacute;ctica y valiosa herramienta 
										   que le ayudar&aacute; a multiplicar las posibilidades de conseguir el puesto que usted siempre ha anhelado.</h2>
									</td>
								</tr>
								<tr>
									<td>
										<br>
									</td>
								</tr>
								<tr>
									<td align="center">
										<input style="font-size:11px" type="submit" NAME="txtRegistrar"  value="Registrar"  SIZE=32 MAXLENGTH=32 alt="Registrar" onclick="javascript: putname(this);">
									</td>
								</tr>
							</table>
						
					</div>		
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<div id="footer">
					<cfif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 1>
						El usuario fue creado exitosamente
						<br>antes de ingresar a la aplicaci&oacute;n es necesario que autorize el usuario 
						<br>con la informaci&oacute;n enviada en el correo electr&oacute;nico
						<br>Ingrese su correo electr&oacute;nico y contrase&ntilde;a<br>Para agregar su curriculum
					<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 2>
						El password fue modicado exitosamente<br>Ingrese su correo electr&oacute;nico y la nueva contrase&ntilde;a<br>Para agregar o modificar su curriculum
					<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 3>
						Correo electr&oacute;nico o contraseña invalida
					<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 4>
						La nueva contrase&ntilde;a  fue enviada  a su correo electr&oacute;nico	
					<cfelseif isdefined("session.Estado") and len(trim(session.Estado)) and session.Estado eq 5>
						Este usuario no ha aplicado la autorizaci&oacute;n enviada al correo electr&oacute;nico al momento de registrarse
					<cfelse>
						<h3>&nbsp;</h3>
					</cfif>				
				</div>				
				</td>
			</tr>
			
		</table>			
	</div>
	<input type="hidden" name="bottonselect" id="bottonselect" value="">
	</form>
</cfoutput> 
<cfset session.Estado = "0">

	<script language="JavaScript" type="text/JavaScript">
		function trim(dato) {
			return dato.replace(/^\s*|\s*$/g,"");
		}

		function putname(obj) {
			document.form1.bottonselect.value = trim(obj.name);
		}
		
		function validarEmail(valor) {
			if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(valor)){
				return (true)
			} 
			else {
				return (false);
			}
		}
		
		function  validar(){
			
			if (trim(document.form1.bottonselect.value) == 'txtLogueo' ){
				var error = false;
				var mensaje = 'Se presentaron los siguientes errores:\n';
				if ( trim(document.form1.txtUsername.value) == '' ){
					error = true;
					mensaje = mensaje + " - El correo electrónico es requerido.\n";
				}
				
				if ( trim(document.form1.txtUsername.value) != '' ){
						if (validarEmail(document.form1.txtUsername.value) == false){
							error = true;
							mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
						
						}
					}
				
				if ( trim(document.form1.txtPassword.value) == '' ){
					error = true;
					mensaje = mensaje + " - la contraseña es requerida.\n";
				}
				
				if (error){
					alert(mensaje);
					return false;
				}
				else
					return true;
			}
			else{
				return true;
			}
			
		}	
</script>