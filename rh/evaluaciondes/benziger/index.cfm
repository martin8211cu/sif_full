<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Recursos Humanos - Test de Benziger</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/rh/css/soinasp01_azul.css" rel="stylesheet" type="text/css">

<!---<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
<link href="/cfmx/plantillas/soinasp01/css/soinasp01_azul.css" rel="stylesheet" type="text/css">--->
<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">

<body>
	<form name="form1" method="url" action="datos_persona.cfm" style="margin:0;" >
		<cfinclude template="header.cfm">

	<br>

		<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td align="center" class="tituloProceso">
			Cuestionario de Estilos de Pensamiento de Benziger
		</td></tr>
		</table>

		<table width="40%" align="center" border="0" cellpadding="3" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center">All sections of this 6-part Assessment are important.</td></tr>
			<tr><td></td></tr>
			<tr><td align="center">Research has shown that many individuals modify their natural preferences in order to be accepted or to succeed in life.</td></tr>
			<tr><td></td></tr>			
			<tr><td align="center">By completing all the sections of the Assessment you will enable us to more accurately identify your original preference as well as any adaptive patterns you may have developed.</td></tr>
			<tr><td></td></tr>						
		</table>
		
		<table width="40%" align="center" border="0" cellpadding="3" cellspacing="0">
			<tr>
				<td colspan="3" bgcolor="#A0BAD3"><strong>Datos Generales:</strong></td>
			</tr>			
			<tr>
				<td><strong>Identificaci&oacute;n:</strong></td>
				<td><input name="BUidentificacion" type="text" size="20" maxlength="60"></td>
				<td>* es requerida solo si modifica cuestionario que ya existe</td>
			</tr>
			<tr>
				<td><strong>Idioma:</strong></td>
				<td colspan="2">
					<table width="30%" >
						<tr>
							<td width="1%" ><input type="radio" name="PCcodigo" value="BTSAes" checked="checked"></td>
							<td width="30%" >Espa&ntilde;ol</td>
							<td width="1%" ><input type="radio" name="PCcodigo" value="BTSAen"></td>
							<td width="30%" >Ingl&eacute;s</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="3" align="center"><cf_botones values="Nuevo Cuestionario, Modificar Cuestionario m&aacute;s reciente" names="Nuevo,Modificar" exclude="Alta,Limpiar"></td></tr>			
		</table>		
	</form>

	<script language="javascript1.2" type="text/javascript">
		function funcModificar(){
			if ( document.form1.BUidentificacion.value == '' ){
				alert('Debe digitar la identificación');
				return false;
			}

			return true;
		}
	</script>


	
</body>
</html>