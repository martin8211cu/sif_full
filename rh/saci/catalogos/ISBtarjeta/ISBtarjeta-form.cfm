<cfparam name="url.MTid" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBtarjeta
	where MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.MTid#" null="#Len(url.MTid) Is 0#">
</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	var valor = "";		// Se guarda el contenido del numero de la tarjeta antes de que se oprima una tecla
	var tecla = "";		//Tecla digitada
	var chkExtran=false;//esta variable es para saber si la persona esta escribiendo, si esta escribiendo hace que se validen los caracteres correctos para la mascara

	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBtarjeta - Instrumento de Pago
		
		// Columna: MTnombre Nombre varchar(20)
		if (formulario.MTnombre.value == "") {
			error_msg += "\n - Nombre no puede quedar en blanco.";
			error_input = formulario.MTnombre;
		}
		// Columna: MTnombre Nombre varchar(20)
		if (formulario.MTmascara.value == "") {
			error_msg += "\n - La Mascara no puede quedar en blanco.";
			error_input = formulario.MTmascara;
		}		
	
		// Columna: Habilitado Habilitado bit
		if (formulario.Habilitado.value == "") {
			error_msg += "\n - Habilitado no puede quedar en blanco.";
			error_input = formulario.Habilitado;
		}
					
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		//corrigeTamMascara(formulario.MTmascara);
		return true;
	}
	function funcNuevo(){
		location.href = '#CurrentPage#';
		return false;
	}
	
	function anterior(){
		valor = document.form1.MTmascara.value;
	}				
	function getTecla(e){
		e = (e) ? e : event
		tecla = (e.which) ? e.which : e.keyCode
		chkExtran=true;
	}	
	
	function validaMasc(obj){
		// Solo se permite que el usuario digite un '-' o un '0' o supr o backspace
		if (tecla!=48 && tecla!=45  && tecla!=46 && tecla!=8)
			obj.value=valor;
	}
	function corrigeTamMascara(obj){
		var carac = "";
		var cadenaFin = "";
		var cantDigi = 0;
		for (var i=0; i<obj.value.length; i++){
			carac = obj.value.substr(i,1);	
			if(carac != '-')
				cantDigi = cantDigi + 1;
			if(cantDigi <= 16){
				cadenaFin = cadenaFin + carac;
			}
		}
		
		if(cantDigi < 14){
			var digiFaltantes = 14 - cantDigi;
			for (var j=0; j<digiFaltantes; j++)
				cadenaFin = cadenaFin + '0';
		}		
		obj.value = cadenaFin;
	}
	
	function repasaMasc(obj){
		var aValidar = obj.value;
		var CARACTER = "";
		var newCadena = "";		
		
		for (var i=0; i<aValidar.length; i++){
			CARACTER=aValidar.substr(i,1);		
			
			if ((CARACTER == '-') || (CARACTER == '0')){
				if(newCadena.length > 0){
					if((newCadena.substr(newCadena.length - 1,1) == '-') && (CARACTER != '-')){
						newCadena = newCadena + CARACTER;
					}else{
						if((newCadena.substr(newCadena.length - 1,1) == '0'))
							newCadena = newCadena + CARACTER;
					}
				}else{
					if (CARACTER != '-')
						newCadena = CARACTER;
				}
			}
		}
		
		if(newCadena.substr(newCadena.length - 1,1) == '-')
			obj.value = newCadena.substr(0,newCadena.length-1);
		else
			obj.value = newCadena;
				
		corrigeTamMascara(obj);			
	}
	
	function quitaInvalidChars(obj){
		var re = new RegExp("[^##\(\)-]","ig");
		obj.value = obj.value.replace(re,"");
		return;
	}
	
	function getTecla2(e){
		var tecla=null;
		
		e = (e) ? e : event
		tecla = (e.which) ? e.which : e.keyCode

		return tecla;
	}
		
	function filtraCarac(e,obj){
		var cl = getTecla2(e);
		if((cl != 51)&&(cl != 16)&&(cl != 17)&&(cl != 36)&&(cl != 37)&&(cl != 39)){
			if((cl == 32) || (cl == 8) || (cl == 9) || (cl == 109)||((cl > 47)&&(cl<58))||((cl > 95)&&(cl<106))){
				obj.value=obj.value.substring(0,obj.value.length);
			}else{
				obj.value=obj.value.substring(0,obj.value.length-1);
			}
		}else if((cl == 51)&&(!e.shiftKey)){
				obj.value=obj.value.substring(0,obj.value.length-1);
			}
			
	}
	
	
	  function fnVerificaChar(obj,evt,validos)

      {
  
           if (!evt) evt = window.Event;
            var LvarCharCode = 0;
            if (window.Event) 
				LvarCharCode = (evt.charCode == 0 && evt.keyCode < 32) ? evt.keyCode : evt.charCode;
            else 
				LvarCharCode = evt.charCode ? evt.charCode : evt.keyCode;       

            if (LvarCharCode < 32)
				return true; 
            return (validos.indexOf(String.fromCharCode(LvarCharCode)) >= 0);

      }

	
	
//-->
</script>
<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
<form action="ISBtarjeta-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada" width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr><td colspan="2" class="subTitulo">
	Instrumento de Pago
	</td></tr>
		<tr><td valign="top">Nombre
		</td><td valign="top">
		
			<input name="MTnombre" 
				id="MTnombre" 
				type="text" 
				onblur="javascript: validaBlancos(this);"
				value="#HTMLEditFormat(data.MTnombre)#" 
				maxlength="40"
				onfocus="this.select()"  >
		
		</td></tr>
		<tr>
			<td valign="top">Mascara</td>
			<td valign="top">
				<!----<input 
					name="MTmascara" 
					type="text" 
					id="MTmascara"
					onfocus="this.select()" 
					value="#HTMLEditFormat(data.MTmascara)#" 
					onKeyPress="javascript: getTecla(event);"
					onKeyDown="javascript: anterior();"
					onKeyUp="javascript: validaMasc(this);"
					onBlur="javascript: repasaMasc(this);"
					size="50" 
					maxlength="60">--->
					
						<input type="text" 
						name="MTmascara"
						id="MTmascara"
						size="50" 
						maxlength="60" 
						onBlur="javascript: quitaBlancos(this);"
						onblur="javascript: validaBlancos(this);"
						<!---onkeydown="javascript: filtraCarac(event,this);"--->
						onkeypress="return fnVerificaChar(this, event,'##-0123456789');"
						<!---onKeyUp="javascript: filtraCarac(event,this);"--->
						value="#HtmlEditFormat(Trim(data.MTmascara))#" 
						>
			</td>
		</tr>		
		<tr><td valign="top">Logo
		</td><td valign="top">
		
			<!---
				Nota: El onchange funciona en Internet Explorer 6.0 o anteriores, pero no funciona en Mozilla Firefox
				Más detalles en http://kb.mozillazine.org/Firefox_:_Issues_:_Links_to_Local_Pages_Don%27t_Work
			--->
			<input name="MTlogo" id="MTlogo" type="file" value="" onfocus="this.select()" onchange="document.getElementById('img_MTlogo').src=this.value"><br />
			<img id="img_MTlogo" height="60" src="<cfif Len(data.MTlogo)>/cfmx/saci/utiles/ISBtarjeta-download.cfm?f=MTlogo&amp;MTid=#URLEncodedFormat(data.MTid)#<cfelse>about:blank</cfif>">
		
		</td></tr>
		<tr><td valign="top">Habilitado
		</td><td valign="top">
		
			<input name="Habilitado" id="Habilitado" type="checkbox" value="1" <cfif Len(data.Habilitado) And data.Habilitado> checked</cfif> tabindex="1">
			<label for="Habilitado">Habilitado</label>
		
		</td></tr>
		
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones modo="CAMBIO" tabindex="1">
		<cfelse>
			<cf_botones modo="ALTA" tabindex="1">
		</cfif>
	</td></tr>
	</table>

	<input type="hidden" name="MTid" value="#HTMLEditFormat(data.MTid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	
</form>

</cfoutput>
