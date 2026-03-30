<!--- Parámetros del TAG --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.name" default="persona" type="String"> <!--- Nombre del campo que contiene el nombre de persona que ya existe --->
<cfparam name="Attributes.frame" default="frmPersonas" type="String">

<cfoutput>
	<script language="JavaScript" type="text/javascript">
		var popUpWin=0;
		//Levanta el Conlis
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWin){
				if(!popUpWin.closed) popUpWin.close();
			}
			popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
		}
		//Llama el conlis
		function doConlisPersonas() {
			var width = 650;
			var height = 500;
			var left = (screen.width - width) / 2;
			var top = (screen.height - height) / 2;
			var params ="?f=#Attributes.form#&p1=#Attributes.name#&p2=#Attributes.name#_text";
			popUpWindow("/cfmx/educ/utiles/ConlisPersonas.cfm"+params,left,top,width,height);
		}
		// Funcion que carga los datos de una persona
		function CargaPersona(usr) {
			if (document.#Attributes.form#.id != null) window.id = document.#Attributes.form#.id;
			if (document.#Attributes.form#.nombre != null) window.nombre = document.#Attributes.form#.nombre;
			if (document.#Attributes.form#.apellido1 != null) window.apellido1 = document.#Attributes.form#.apellido1;
			if (document.#Attributes.form#.apellido2 != null) window.apellido2 = document.#Attributes.form#.apellido2;
			if (document.#Attributes.form#.nacimiento != null) window.nacimiento = document.#Attributes.form#.nacimiento;
			if (document.#Attributes.form#.sexo != null) window.sexo = document.#Attributes.form#.sexo;
			if (document.#Attributes.form#.casa != null) window.casa = document.#Attributes.form#.casa;
			if (document.#Attributes.form#.oficina != null) window.oficina = document.#Attributes.form#.oficina;
			if (document.#Attributes.form#.celular != null) window.celular = document.#Attributes.form#.celular;
			if (document.#Attributes.form#.fax != null) window.fax = document.#Attributes.form#.fax;
			if (document.#Attributes.form#.pagertel != null) window.pagertel = document.#Attributes.form#.pagertel;
			if (document.#Attributes.form#.pagernum != null) window.pagernum = document.#Attributes.form#.pagernum;
			if (document.#Attributes.form#.email1 != null) window.email1 = document.#Attributes.form#.email1;
			if (document.#Attributes.form#.email2 != null) window.email2 = document.#Attributes.form#.email2;
			if (document.#Attributes.form#.web != null) window.web = document.#Attributes.form#.web;
			if (usr != "") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/educ/utiles/getPersona.cfm?usr="+usr;
			}
			return true;
		}
		
	</script>
	
	<table width="" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td nowrap>
				<input type="hidden" name="#Attributes.name#" id="#Attributes.name#">
				<input type="text" name="#Attributes.name#_text" id="#Attributes.name#_text" tabindex="-1" maxlength="255" size="40" readonly>
				<a href="##" tabindex="-1"><img src="/cfmx/educ/imagenes/Description.gif" alt="Lista de materias" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPersonas();'></a>
			</td>
		</tr>
	</table>
</cfoutput>

<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
