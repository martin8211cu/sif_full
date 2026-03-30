	
<cfset mask = "">
<cfquery datasource="#Session.DSN#" name="rsMask">
	select Pvalor 
		from ISBparametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 60
</cfquery>

<cfif rsMask.recordCount gt 0 and len(trim(rsMask.Pvalor))>
	<cfset mask = trim(rsMask.Pvalor)>
</cfif>

<cfset btnHabilitado = "">
<cfset btnEliminar = "">
<cfset btnGuardar = "Guardar">

<!---<cfif isdefined("form.AGid") and len(trim(form.AGid)) and isdefined("form.CTid") and len(trim(form.CTid))>	
	<cfquery datasource="#Session.DSN#" name="rs">
		select count(1) as tot
			from ISBagente agen
				inner join ISBcuenta cue
			on agen.Pquien = cue.Pquien
				inner join ISBproducto pro
			on cue.CTid = pro.CTid
		where agen.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
		  and cue.CTtipoUso in ('A','F')
		  and pro.CTcondicion not in ('C')
	</cfquery>
	<cfif rs.tot eq 0>
		<cfset btnEliminar = ", Eliminar">
	</cfif>
</cfif>--->

<cfif isdefined("form.AGid") and len(trim(form.AGid))>		
	<!--- EL agente debe tener un servicio --->
	<cfquery datasource="#Session.DSN#" name="rsHabilitado">
		select agen.Habilitado
			from ISBagente agen
		where agen.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AGid#">
	</cfquery>
	<cfset btnEliminar = ", Eliminar">
	<cfif rsHabilitado.RecordCount gt 0 and rsHabilitado.Habilitado eq 0>
		<cfset btnHabilitado = ", Habilitar">
	<cfelseif rsHabilitado.RecordCount gt 0 and rsHabilitado.Habilitado eq 1>
		<cfset btnHabilitado = ", Inhabilitar">
	<cfelseif rsHabilitado.RecordCount gt 0 and rsHabilitado.Habilitado eq 2>	
		<cfset btnEliminar = "">
		<cfset btnGuardar = "">
	</cfif>
</cfif>

<form method="post" name="form1" action="agente_registro-apply.cfm" onsubmit="return validar(this);" style="margin:0">
	<cfinclude template="agente-hiddens.cfm">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>
			<cf_agentes
				id_agente="#form.AGid#"
				TipodeAgente = "#form.tipo#"
			>
		</td></tr>
		<tr><td align="center">
			<cf_botones names="#btnGuardar#,Nuevo#btnEliminar##btnHabilitado#,Lista" values="#btnGuardar#,Nuevo#btnEliminar##btnHabilitado#,Lista Agentes" tabindex="-1">
		</td></tr>
	</table>
</form>


<script type="text/javascript">
<!--
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
			  if(popUpWin)
			  {
				if(!popUpWin.closed) popUpWin.close();
			  }
			  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcNuevo() {
		<cfif form.tipo eq 'Externo'>
		location.href = "agente.cfm?tab=1&tipo=Externo";
		<cfelse>
		location.href = "agente_interno.cfm?tab=1&tipo=Interno";
		</cfif>
		return false;
	}
		var NuevoAgenteWindow=null;
		
		function closeAgenteWindow() {
			NuevoAgenteWindow.close();
		}
		
		function doConlisChgAgente() {
			var width = 500;
			var height = 300;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			
		 	if(NuevoAgenteWindow){
				if(!NuevoAgenteWindow.closed) NuevoAgenteWindow.close();
		  	}

			NuevoAgenteWindow = open("/cfmx/saci/utiles/conlisHabilitarAgente.cfm?AGid=" + document.form1.AGid.value, "NuevoAgente", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width="+width+",height="+height+",left="+left+", top="+top+",screenX="+left+",screenY="+top);

			
			if (! NuevoAgenteWindow && !document.popupblockerwarning) {
				alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
				document.popupblockerwarning = 1;
		  	}
			NuevoAgenteWindow.focus();
			/*window.onfocus = closeAgenteWindows;*/
		}
	
	function funcHabilitar() {
			var mensaje = "Habilitar";
		
			if (confirm("Desea " + mensaje + " el agente ?")) {

				location.href = "agente_lista-apply.cfm?Cambiar=1&Habilitado=1&tipo=" + document.form1.tipo.value + "&AG=" + document.form1.AGid.value;
				return false;
			}else{

				return false;				
			}
	}
	
	
	function Inhabilitar(MBmotivo,AGid,BLobs) {

			location.href = "../dso/agentes/agente_lista-apply.cfm?Cambiar=1&Habilitado=0&tipo=" + document.form1.tipo.value + "&AG=" + document.form1.AGid.value + "&MBmotivo=" + MBmotivo + "&BLobs=" + BLobs;
			return false;
		}
	function funcInhabilitar() {
			var mensaje = "Inhabilitar";
			
			
			window.doConlisChgAgente();
			return false;
			
			
			/*if (confirm("Desea " + mensaje + " el agente ?")) {
				location.href = "agente_lista-apply.cfm?Cambiar=1&Habilitado=0&tipo=" + document.form1.tipo.value + "&AG=" + document.form1.AGid.value;
				return false;
			}else{

				return false;				
			}*/
	}
	
	function validaPorc(param){
		var valParam = parseInt(param);
		
		if(valParam > 100 || valParam <= 0)
			return false;
			
		return true;
	}
	function checkMask(v){
		var m  = "<cfoutput>#mask#</cfoutput>";
		if(m.length == 0)
			return true;
		m = m.replace(/#/gi,"\\d");
		m = m.replace(/\(/gi,"\\(");
		m = m.replace(/\)/gi,"\\)");
		var myRegExp = new RegExp(m+"$");
		return myRegExp.test(v);
	}
		
	function validar(formulario) {

		var error_input;
		var error_msg = '';
	
			if(btnSelected('Eliminar', formulario)){ /*Se está realizando un borrado de la información*/
				return true;
				
			}
		if (formulario.Ppersoneria.value == "") {
			error_msg += "\n - Personería no puede quedar en blanco.";
			error_input = formulario.Ppersoneria;
		}

		if (formulario.Pid.value == "") {
			error_msg += "\n - Identificación no puede quedar en blanco.";
			error_input = formulario.Pid;
		} else if (!validar_identificacion()) {
			error_msg += "\n - La Identificación no cumple con la máscara permitida.";
			error_input = formulario.Pid;
		}
		
		if (formulario.Ppersoneria.value != "") {
			if (formulario.Ppersoneria.value == 'J') {
				if (trim(formulario.PrazonSocial.value) == "") {
					error_msg += "\n - La razón social no puede quedar en blanco.";
					error_input = formulario.PrazonSocial;
				}
			
			
				if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.PrazonSocial.value))) 
					{
						error_msg += "\n - El campo razón social sólo se permite el ingreso de letras.";
						error_input = formulario.PrazonSocial;
					}

			
			
			} else {
				if (formulario.Pnombre.value == "") {
					error_msg += "\n - Nombre no puede quedar en blanco.";
					error_input = formulario.Pnombre;
				}

				if (formulario.Papellido.value == "") {
					error_msg += "\n - 1er Apellido no puede quedar en blanco.";
					error_input = formulario.Papellido;
				}
			
					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pnombre.value))) 
					{
						error_msg += "\n - El campo Nombre sólo se permite el ingreso de letras.";
						error_input = formulario.Pnombre;
					}

					
					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Papellido.value))) 
					
					{
						error_msg += "\n - El campo Apellido sólo se permite el ingreso de letras.";
						error_input = formulario.Papellido;
					}

					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ]*$/.test(formulario.Papellido2.value))) 
					
					{
						error_msg += "\n - El campo 2do Apellido sólo se permite el ingreso de letras.";
						error_input = formulario.Papellido2;
					}

			}
		}
		

		if (formulario.Ppais.value == "") {
			error_msg += "\n - País no puede quedar en blanco.";
			error_input = formulario.Ppais;
		}

		if (formulario.AEactividad != undefined) {
				if (formulario.AEactividad.value == "") {
					error_msg += "\n - Actividad Económica no puede quedar en blanco.";
					error_input = formulario.AEactividad;
				}
		}
		if (formulario.CPid.value == "") {
			formulario.Papdo.value = "";
		}
		
		if (formulario.Ptelefono1.value == "") {
			error_msg += "\n - Teléfono no puede quedar en blanco.";
			error_input = formulario._Ptelefono1;
		}

		if (formulario.AAcomisionTipo.value == 0 && formulario.tipo.value == "Externo") {
			error_msg += "\n - Debe seleccionar un tipo de comisión.";
			error_input = formulario.AAcomisionPctj;
		
		}
		
		if(formulario.AAcomisionTipo.value == 1 && formulario.tipo.value == "Externo"){
			if (!validaPorc(formulario.AAcomisionPctj.value)) {
				error_msg += "\n - El porcentaje de comisión es inválido.";
				error_input = formulario.AAcomisionPctj;
			}		
		}
		
			if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pbarrio.value))) 
			
			{
				error_msg += "\n - El campo Barrio sólo se permite el ingreso de letras.";
				error_input = formulario.Pbarrio;
			}

			if (formulario.Pdireccion.value == "") {
				error_msg += "\n - La Dirección no puede quedar en blanco.";
				error_input = formulario.CPid;
			}

			
			if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(formulario.Pdireccion.value))) 
			
			{
				error_msg += "\n - El campo Dirección Exacta tiene caracteres no válidos.";
				error_input = formulario.Pdireccion;
			}

			if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pobservacion.value))) 
			
			{
				error_msg += "\n - El campo Observaciones tiene caracteres no válidos.";
				error_input = formulario.Pobservacion;
			}

		
		if(formulario.AAplazoDocumentacion.value.length > 0 && formulario.tipo.value == "Externo"){
			var v = parseInt(formulario.AAplazoDocumentacion.value); 
			if (v < 0 || v > 365) {
				error_msg += "\n - El plazo de entrega de Documentacion de estar entre 0 y 365";
				error_input = formulario.AAplazoDocumentacion;
			}		
		}

		if (formulario.AAfechacontrato.value == "" && formulario.tipo.value == "Externo") {
			error_msg += "\n - Fecha Firma Contrato no puede quedar en blanco.";
			error_input = formulario._Ptelefono1;
		}

		
		<cfquery name="rsNiveles" datasource="#session.dsn#">
			select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
			from DivisionPolitica
			where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
		</cfquery>
		<cfset minnivel = rsNiveles.minNivel>
		<cfset maxnivel = rsNiveles.maxNivel>
		<cfoutput><cfloop condition="maxnivel GTE minnivel">
			if (formulario.LCcod_#minnivel#.value == "") {
				error_msg += "\n - " + formulario.LCcod_#minnivel#.alt + " no puede quedar en blanco.";
				error_input = formulario.LCcod_#minnivel#;
			}
			<cfset minnivel = minnivel + 1>
		</cfloop></cfoutput>
		
		if (formulario.AAcomisionTipo.value == 2 && formulario.tipo.value == "Externo") { 
			formulario.AAcomisionMnto.value = qf(formulario.AAcomisionMnto.value);
		
			if (parseInt(formulario.AAcomisionMnto.value) == 0) {
				error_msg += "\n - El monto de comisión no puede ser cero.";
				error_input = formulario.AAcomisionMnto;
			}

		}
		
		
		<!--- validar los datos del agente --->
		if (formulario.AAplazoDocumentacion.value == "" && formulario.tipo.value == "Externo") {
			error_msg += "\n - Plazo Entrega Documentación no puede quedar en blanco.";
			error_input = formulario.AAplazoDocumentacion;
		}
		
		<!--- Validacion terminada --->
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		else{
			eliminaMascara();//esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
		}
		
		if(!emailCheck(formulario.Pemail.value))
			return false;
		
		return true;
	}
//-->
</script>

