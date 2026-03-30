<cfset def = QueryNew('apdo')>

<cfparam 	name="Attributes.query"				type="query"	default="#def#">				<!--- consulta por defecto --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.alignEtiquetas" 	type="string"	default="right">				<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- propiedad read Only para el tag, en este caso es obligatorio el query--->
<cfparam 	name="Attributes.porfila" 			type="boolean"	default="false">				<!--- para pintar los campos en una sola columna vertical --->

<cfset ExisteTarjeta = Attributes.query.recordCount NEQ 0>

<cfquery name="rsTarjetas" datasource="#Attributes.Conexion#">
	select b.MTid, b.MTnombre, b.MTlogo, MTmascara
	from ISBtarjeta b
	where b.Habilitado = 1
	<cfif ExisteTarjeta and Attributes.readOnly and Len(Trim(Evaluate("Attributes.query.MTid#Attributes.sufijo#")))>
		<cfset MTid =  Evaluate("Attributes.query.MTid#Attributes.sufijo#")>
		and b.MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MTid#">
	</cfif>
	order by b.MTnombre
</cfquery>



<cfoutput>
	
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<input type="hidden" name="mascaraTarjeta#Attributes.sufijo#" value="">
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td align="#Attributes.alignEtiquetas#"><label>Tipo Tarjeta</label></td>
		<td>
			<cfif Attributes.readOnly>								
				#HTMLEditFormat(rsTarjetas.MTnombre)#
				<input name="MTid#Attributes.sufijo#" type="hidden" value="#HTMLEditFormat(rsTarjetas.MTid)#" />
			<cfelse>
				<select name="MTid#Attributes.sufijo#" tabindex="1" onchange="javascript: cargarImagenTarjeta#Attributes.sufijo#(this.value); cargaMascara#Attributes.sufijo#(this.value);limpiaNumTar#Attributes.sufijo#();cargaPosGuion#Attributes.sufijo#();">
				<cfloop query="rsTarjetas">
					<option value="#rsTarjetas.MTid#" <cfif ExisteTarjeta and isdefined("Attributes.query.MTid#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.MTid#Attributes.sufijo#"))) and Evaluate("Attributes.query.MTid#Attributes.sufijo#") EQ rsTarjetas.MTid>selected</cfif>>#HTMLEditFormat(rsTarjetas.MTnombre)#</option>
				</cfloop>
				</select>
			</cfif>
		</td>
		
		<cfif Attributes.porfila></tr><tr></cfif>
		
		<td align="#Attributes.alignEtiquetas#">
			<label>No. Tarjeta</label>
		</td>
		<td valign="middle">
			<cfif Attributes.readOnly>
				<cfif ExisteTarjeta and isdefined("Attributes.query.NumTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Right(Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#"),4))#
				<cfelse>
					&lt;No Especificado&gt;
				</cfif>
			<cfelse>
				<cfset numtar = "">
				<cfif ExisteTarjeta and isdefined("Attributes.query.NumTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#")))>
					<cfset numtar = Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#")>
				</cfif>
					<!---<cfset len_numtar = len(numtar)>
					<input 
						type="text" 
						name="NumTarjeta#Attributes.sufijo#" 
						size="30" 
						maxlength="30" 
						 
						onKeyPress="javascript: getTecla#Attributes.sufijo#(event);" 
					    onKeyDown="javascript: anterior#Attributes.sufijo#();"
					    onKeyUp="javascript: validaMasc(this);"
						onBlur="javascript: repasaMasc(this);"
						onFocus="this.select();"
						value="#HTMLEditFormat(Mid(numtar,len_numtar - 3,len_numtar))#"/>					
						<!---muestra los ultimos 4 digitos de la tarjeta de credito--->
				<cfelse>
					<input 
						type="text" 
						name="NumTarjeta#Attributes.sufijo#" 
						size="30" 
						maxlength="30" 
						 
						onKeyPress="javascript: getTecla#Attributes.sufijo#(event);" 						
						onKeyDown="javascript: anterior#Attributes.sufijo#();"
						onKeyUp="javascript: validaMasc(this);"
						onBlur="javascript: repasaMasc(this);"
						onFocus="this.select();"
						value=""/>
						
						onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.NumTarjeta#Attributes.sufijo#.value)"
						
				</cfif>--->
				
					<input type="hidden" 
						tabindex="2"
						name="NumTarjeta#Attributes.sufijo#" 
						id="NumTarjeta#Attributes.sufijo#" 
						value="#HtmlEditFormat(numtar)#">
					
					<input type="text" 
						name="_NumTarjeta#Attributes.sufijo#"
						size="30" 
						maxlength="30" 
						onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.NumTarjeta#Attributes.sufijo#);"
						onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.NumTarjeta#Attributes.sufijo#);"
						onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.NumTarjeta#Attributes.sufijo#.value)"
						value=""
						style="text-align:right;"
						tabindex="2"
					>
				
			</cfif>
		<cfif not Attributes.porfila></td><td></cfif>
			<!---<cfif Attributes.readOnly>--->
				<!---<img id="img_tarjeta#Attributes.sufijo#_#rsTarjetas.MTid#" name="img_tarjeta#Attributes.sufijo#_#rsTarjetas.MTid#" border="0" style="display:none" height="25" src="<cfif Len('Attributes.query.MTlogo#Attributes.sufijo#')>/cfmx/saci/utiles/ISBtarjeta-download.cfm?f=MTlogo&amp;MTid=#URLEncodedFormat('Attributes.query.MTid#Attributes.sufijo#')#<cfelse>about:blank</cfif>">--->			
			<!---<cfelse>--->
				<cfloop query="rsTarjetas">
					<!---<cfif rsTarjetas.MTid eq '2'>--->
						<img id="img_tarjeta#Attributes.sufijo#_#rsTarjetas.MTid#" name="img_tarjeta#Attributes.sufijo#_#rsTarjetas.MTid#" border="0" style="display:none" height="25" src="<cfif Len(rsTarjetas.MTlogo)>/cfmx/saci/utiles/ISBtarjeta-download.cfm?f=MTlogo&amp;MTid=#URLEncodedFormat(rsTarjetas.MTid)#<cfelse>about:blank</cfif>">						
					<!---</cfif>--->
				</cfloop>
		
			<!---</cfif>--->
		</td>
	  </tr>
	  <tr>
		  <cfif not Attributes.porfila>
			<td align="#Attributes.alignEtiquetas#">&nbsp;</td>
			<td>&nbsp;</td>
		  </cfif>
		<cfif Attributes.porfila></tr><tr></cfif>
		<cfif not Attributes.readOnly>  <!---cuando es solo lectura no se debe mostrar campo de confirmación--->
			<td align="#Attributes.alignEtiquetas#"><label>Confirmaci&oacute;n</label></td>
			<td colspan="2">
				<cfset numtar = "">
				<cfif ExisteTarjeta and isdefined("Attributes.query.NumTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#")))>
					<cfset numtar = Evaluate("Attributes.query.NumTarjeta#Attributes.sufijo#")>
					<!---<cfif ProductosEnCaptura>
						<cfset numtar = mid(numtar,len(numtar)-4,len(numtar))>
					</cfif>--->
				</cfif>
					<!---<cfset len_numtar = len(numtar)>
					<input 
						type="password" 
						name="confNumTarjeta#Attributes.sufijo#" 
						id="confNumTarjeta#Attributes.sufijo#"
						size="30" 
						maxlength="30" 
						 
						onKeyPress="javascript: getTecla#Attributes.sufijo#(event);" 						
						onKeyDown="javascript: anterior#Attributes.sufijo#();"
						onKeyUp="javascript: validaMasc(this);"
						onBlur="javascript: repasaMasc(this);"
						onFocus="this.select();"
						value="#HTMLEditFormat(Mid(numtar,len_numtar - 3,len_numtar))#"/>
				<cfelse>
					<input 
						type="password" 
						name="confNumTarjeta#Attributes.sufijo#" 
						id="confNumTarjeta#Attributes.sufijo#"
						size="30" 
						maxlength="30" 
						 
						onKeyPress="javascript: getTecla#Attributes.sufijo#(event);" 						
						onKeyDown="javascript: anterior#Attributes.sufijo#();"
						onKeyUp="javascript: validaMasc(this);"
						onBlur="javascript: repasaMasc(this);"
						onFocus="this.select();"
						value=""/>			
				</cfif>--->
				<input type="hidden" 
							tabindex="3"
							name="confNumTarjeta#Attributes.sufijo#" 
							id="confNumTarjeta#Attributes.sufijo#" 
							value="#HtmlEditFormat(numtar)#">
						
						<input type="password" 
							name="_confNumTarjeta#Attributes.sufijo#"
							size="30" 
							maxlength="30" 
							onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.confNumTarjeta#Attributes.sufijo#);"
							onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.confNumTarjeta#Attributes.sufijo#);"
							onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.confNumTarjeta#Attributes.sufijo#.value)"
							value=""
							style="text-align:right;"
							tabindex="3"
						>
			</td>
		</cfif>		
	  </tr>
	  <tr>
		  <cfif not Attributes.porfila>
			<td align="#Attributes.alignEtiquetas#">&nbsp;</td>
			<td>&nbsp;</td>
		  </cfif>
		<cfif Attributes.porfila></tr><tr></cfif>
		<td>&nbsp;</td>
		<td  <cfif Attributes.readOnly>style="display:none"</cfif> align="left" nowrap="nowrap" colspan="2">
			<font style="font-weight: normal; font-family: Arial, Verdana; font-size: x-small; color: gray;">Capturar como:&nbsp;&nbsp;<input type="text" disabled="disabled" id="lblMask" value="" size="40" style="border:hidden; background-color:transparent;font-weight: normal; font-family: Arial, Verdana; font-size: x-small; color: gray;"></font>
		</td>
	  </tr>
	  <tr>
		<td align="#Attributes.alignEtiquetas#"><label>Vence (mes-a&ntilde;o)</label></td>
		<td>
			<cfif Attributes.readOnly>
				<cfif ExisteTarjeta and isdefined("Attributes.query.MesTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.MesTarjeta#Attributes.sufijo#")))><cfset mess = Attributes.query.MesTarjeta & Attributes.sufijo>#HTMLEditFormat(Evaluate("mess"))#</cfif>
				<cfif ExisteTarjeta and isdefined("Attributes.query.AnoTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.AnoTarjeta#Attributes.sufijo#")))><cfset anno = Attributes.query.AnoTarjeta & Attributes.sufijo>#HTMLEditFormat(Evaluate("anno"))#</cfif>
			<cfelse>
				<cfset valMesTar = "">
				<cfif ExisteTarjeta and isdefined("Attributes.query.MesTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.MesTarjeta#Attributes.sufijo#")))>
					<cfset valMesTar = HTMLEditFormat(Evaluate("Attributes.query.MesTarjeta#Attributes.sufijo#"))>
				</cfif>			
				<cf_campoNumerico 
					name="MesTarjeta#Attributes.sufijo#" 	
					decimales="-1" 
					size="3" 
					maxlength="2" 
					value="#valMesTar#" 
					tabindex="4"
					>			
				<cfset valAnoTar = "">
				<cfif ExisteTarjeta and isdefined("Attributes.query.AnoTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.AnoTarjeta#Attributes.sufijo#")))>
					<cfset valAnoTar = HTMLEditFormat(Evaluate("Attributes.query.AnoTarjeta#Attributes.sufijo#"))>
				</cfif>						
				<cf_campoNumerico 
					name="AnoTarjeta#Attributes.sufijo#" 	
					decimales="-1" 
					size="5" 
					maxlength="4" 
					value="#valAnoTar#" 
					tabindex="5"
					>						
			</cfif>
		</td>
		
		<cfif Attributes.porfila></tr><tr></cfif>
		
		<td align="#Attributes.alignEtiquetas#"><label>D&iacute;gitos Verificaci&oacute;n</label></td>
		<td colspan="2">
			<cfif Attributes.readOnly>
				<cfif ExisteTarjeta and isdefined("Attributes.query.VerificaTarjeta#Attributes.sufijo#") 
				and Len(Trim(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#")))>	 #HTMLEditFormat(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#"))#
				</cfif>
			<cfelse>
				<!---
				<input type="text" name="VerificaTarjeta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" 
				value="<cfif ExisteTarjeta and isdefined("Attributes.query.VerificaTarjeta#Attributes.sufijo#") 
				and Len(Trim(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#")))>
				#HTMLEditFormat(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#"))#</cfif>" 
				size="5" maxlength="4"  />
				--->
				<cfset digitos = "">
				<cfif ExisteTarjeta and isdefined("Attributes.query.VerificaTarjeta#Attributes.sufijo#") 
					and Len(Trim(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#")))>	
					<cfset digitos = #HTMLEditFormat(Evaluate("Attributes.query.VerificaTarjeta#Attributes.sufijo#"))#>
				</cfif>

				<cf_inputNumber2 name="VerificaTarjeta" size="5" maxlength="4" tabindex="6" value="#digitos#" enteros="4"
				codigoNumerico="true">	
											
			</cfif>
		</td>
	  </tr>
	  
	  <tr>
		<td align="#Attributes.alignEtiquetas#"><label>Nombre del tarjetahabiente</label></td>
		<td>
			<cfif Attributes.readOnly>
				<cfif ExisteTarjeta and isdefined("Attributes.query.NombreTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.NombreTarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.NombreTarjeta#Attributes.sufijo#"))#</cfif>
			<cfelse>
				<input type="text" tabindex="7"  name="NombreTarjeta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" value="<cfif ExisteTarjeta and isdefined("Attributes.query.NombreTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.NombreTarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.NombreTarjeta#Attributes.sufijo#"))#</cfif>" size="50" maxlength="80"  />
			</cfif>
		</td>
		
		<cfif Attributes.porfila></tr><tr></cfif>
		
		<!---<td align="#Attributes.alignEtiquetas#"><label>Apellidos</label></td>
		<td colspan="2">
			<cfif Attributes.readOnly>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><cfif ExisteTarjeta and isdefined("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#"))#<cfelse>&nbsp;</cfif></td>
						<td>&nbsp;</td>
						<td><cfif ExisteTarjeta and isdefined("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#"))#<cfelse>&nbsp;</cfif></td>
					</tr>
				</table>
			<cfelse>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><input type="text" tabindex="8" name="Apellido1Tarjeta#Attributes.sufijo#" onblur="javascript: validaBlancos(this);" value="<cfif ExisteTarjeta and isdefined("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.Apellido1Tarjeta#Attributes.sufijo#"))#</cfif>" size="20" maxlength="30"  /></td>
						<td><input type="text" tabindex="9" name="Apellido2Tarjeta#Attributes.sufijo#" value="<cfif ExisteTarjeta and isdefined("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.Apellido2Tarjeta#Attributes.sufijo#"))#</cfif>" size="20" maxlength="30"  /></td>
					</tr>
				</table>
			</cfif>
		</td>--->
	  </tr>
	  
	  <tr>
		<td align="#Attributes.alignEtiquetas#"><label>C&eacute;dula</label></td>
		<td>
			<cfif Attributes.readOnly>
				<cfif ExisteTarjeta and isdefined("Attributes.query.CedulaTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.CedulaTarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.CedulaTarjeta#Attributes.sufijo#"))#</cfif>
			<cfelse>
				<input type="text" tabindex="8" name="CedulaTarjeta#Attributes.sufijo#" onblur="javascript: quitaBlancos(this);" value="<cfif ExisteTarjeta and isdefined("Attributes.query.CedulaTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.CedulaTarjeta#Attributes.sufijo#")))>#HTMLEditFormat(Evaluate("Attributes.query.CedulaTarjeta#Attributes.sufijo#"))#</cfif>" size="20" maxlength="20"  />
			</cfif>
		</td>
		
		<cfif Attributes.porfila></tr><tr></cfif>
		
		<td align="#Attributes.alignEtiquetas#"><label>Pais</label></td>
		<td colspan="2">
			<cfif ExisteTarjeta and isdefined("Attributes.query.CedulaTarjeta#Attributes.sufijo#") and Len(Trim(Evaluate("Attributes.query.CedulaTarjeta#Attributes.sufijo#")))>
				<cfset idPais = Evaluate("Attributes.query.Ppais#Attributes.sufijo#")>
			<cfelse>
				<cfset idPais = session.saci.pais>
			</cfif>
			<cf_pais
				id = "#idPais#"
				form = "#Attributes.form#"
				sufijo = "#Attributes.sufijo#"
				Ecodigo = "#Attributes.Ecodigo#"
				Conexion = "#Attributes.Conexion#"
				readOnly="#Attributes.readOnly#"
				tabindex="-1"
			>
		</td>
	  </tr>
	</table>
	<script language="javascript1.2" type="text/javascript">

	
		function validateMask#Attributes.sufijo#(obj, aux){
			var r = document.all.mascaraTarjeta#Attributes.sufijo#.value;
			
			if(r.length==0)
				return true;
			else 
			if(r.length == obj.value.length){
				var c;
				for(i=0;i<r.length;i++){
					c = r.charAt(i);
					
					if( (c!='##')&&(c!='-')&&(c != obj.value.charAt(i))){
						aux.value = "";
						obj.value = "";
						alert("El número digitado no corresponde con la máscara");
						return true;						
					}
				}
				return true;
			}
			
			if(aux.value.length > 0){
				aux.value = "";
				obj.value = "";
				alert("El número digitado no corresponde con la máscara");
				return true;
			}else{
				aux.value = "";
				obj.value = "";
				return true;
			}
			return false;
		}
		
		function textToMask#Attributes.sufijo#(v){
			var r = document.all.mascaraTarjeta#Attributes.sufijo#.value;
			var re = new RegExp("##");
			var rn = new RegExp("[0-9]","g");
		
			if(r.length == 0) return v;
			
			if(v.length == 0) return "";
			
			r = r.replace(rn,"##");
			
			var c = "";
			
			for(i=0;i<v.length;i++){
					c = v.substr(i,1);
					r = r.replace(re,c);
			}
			for(i=0;(i<r.length && r.substr(i,1)!="##");i++);
			
			return r.substring(0,i);
			
		}
		
		function validaNumero(){
		
		}
		
		function filtraChars#Attributes.sufijo#(e, obj, aux){
			var m = document.all.mascaraTarjeta#Attributes.sufijo#.value;
			var cl = e.keyCode;
			var t;
			
			if(obj.value.length <= m.length && !e.shiftKey){
				
				if((cl > 47)&&(cl<58)){
					aux.value += String.fromCharCode(cl);
					ajusteMask(aux, aux.value);
					obj.value = textToMask#Attributes.sufijo#(aux.value);
					
				}else if((cl > 95)&&(cl<106)){
					aux.value += String.fromCharCode(cl-48);
					ajusteMask(aux, aux.value);
					obj.value = textToMask#Attributes.sufijo#(aux.value);
				}else if(cl==8){
						aux.value=aux.value.substring(0,aux.value.length-1);
						obj.value = textToMask#Attributes.sufijo#(aux.value);
					}
					else
						obj.value = textToMask#Attributes.sufijo#(aux.value);
				
			}else{
				obj.value=obj.value.substring(0,obj.value.length-1);
			}
		}
		
		function ajusteMask(obj,v){
			var m = document.all.mascaraTarjeta#Attributes.sufijo#.value;
			var rn = new RegExp("-","g");
			m = m.replace(rn,"");
			if (v.length > m.length)
				obj.value = obj.value.substring(0,m.length-1)
		}
	
	</script>
	
	
	<script language="javascript" type="text/javascript">
		var valor = "";		// Se guarda el contenido del numero de la tarjeta antes de que se oprima una tecla
		var tecla = "";		//Tecla digitada
		var chkExtran=false;//esta variable es para saber si la persona esta escribiendo, si esta escribiendo hace que se validen los caracteres correctos para el id del extrangero
		var arregloMasc = new Array();	//Arreglo con el contenido de el id de la tarjeta y la mascara para el numero de la tarjeta
		var arregloPosGuion = new Array();	//Arreglo con los numeros de los indices de la cadena que contiene la mascara del numero de la tarjeta seleccionada en donde aparece un '-'

	//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
		function ESNUMERO(aVALOR){
			var NUMEROS="0123456789-"
			var CARACTER=""
			var VALOR = aVALOR.toString();
			
			for (var i=0; i<VALOR.length; i++){	
				CARACTER =VALOR.substring(i,i+1);
				if (NUMEROS.indexOf(CARACTER)<0) {
					return false;
				} 
			}
			return true;
		}
		function limpiaNumTar(){
			valor = '';
			document.forms.#Attributes.form#.NumTarjeta#Attributes.sufijo#.value = valor;
		}
		function getTecla#Attributes.sufijo#(e){
			e = (e) ? e : event
			tecla = (e.which) ? e.which : e.keyCode
			chkExtran=true;
		}
		function anterior#Attributes.sufijo#(){
			valor = document.forms.#Attributes.form#.NumTarjeta#Attributes.sufijo#.value;
		}				
		function validaMasc(obj){
			if (ESNUMERO(obj.value)){		
				// no permite que el usuario digite un '-'
				if (tecla==45 || tecla==32)
					obj.value=valor;
				
				if(obj.value.length <= document.#Attributes.form#.mascaraTarjeta#Attributes.sufijo#.value.length){
					if(arregloPosGuion[0] != ''){	//La mascara de la tarjeta contiene guiones
						for (var i=0;i<arregloPosGuion.length;i++){
							if(arregloPosGuion[i] == obj.value.length)
								obj.value = obj.value + '-';
						}					
					}				
				}else{
					//Solo se permiten el tamanio fijo de la mascara para la tarjeta seleccionada
					obj.value = valor;				
				}
			}else{
				//Solo se permiten numeros
				obj.value = valor;
			}	
		}

		function repasaMasc(obj){
			var arrayNumTar = new Array();
			var mascaraConvert = "";
			var indice=-1;
			
			// Se convierte el campo de la mascara a un arreglo
			for (var i=0;i<obj.value.length;i++){
				if(obj.value.substr(i,1) != '-'){
					indice = indice + 1;
					arrayNumTar[indice] = obj.value.substr(i,1);				
				}
			}
				
			//se le aplica la mascara
			for (var j=0;j<arrayNumTar.length;j++){
				if(mascaraConvert.length < document.#Attributes.form#.mascaraTarjeta#Attributes.sufijo#.value.length){
					for (var i=0;i<arregloPosGuion.length;i++){
						if(arregloPosGuion[i] == mascaraConvert.length)
							mascaraConvert = mascaraConvert + '-';
					}				
					mascaraConvert = mascaraConvert + arrayNumTar[j];
				}
			}
			obj.value = mascaraConvert;
		}
		function cargarImagenTarjeta#Attributes.sufijo#(tarjeta) {
			var imgtarj;
			<cfloop query="rsTarjetas">
				imgtarj = document.getElementById('img_tarjeta#Attributes.sufijo#_#rsTarjetas.MTid#');
				imgtarj.style.display = tarjeta == '#rsTarjetas.MTid#' ? 'inline' : 'none';
			</cfloop>
		}
		function cargarTipoMascara#Attributes.sufijo#(){
			<cfif isdefined('rsTarjetas') and rsTarjetas.recordCount GT 0>
				var indexArray = -1;
				<cfloop query="rsTarjetas">
					indexArray = indexArray + 1;
					// stuff main array entries with arrays
					arregloMasc[indexArray] = new Array("<cfoutput>#rsTarjetas.MTid#</cfoutput>", "<cfoutput>#rsTarjetas.MTmascara#</cfoutput>");
				</cfloop>
			</cfif>			
		}
		function cargaMascara#Attributes.sufijo#(param){
			for (var i=0;i<arregloMasc.length;i++){
				if(arregloMasc[i][0] == param){
					document.#Attributes.form#.mascaraTarjeta#Attributes.sufijo#.value = arregloMasc[i][1];
					document.#Attributes.form#.lblMask.value = arregloMasc[i][1];
				}
			}
		}
		function cargaPosGuion#Attributes.sufijo#(param){
			var posIndexGuiones = -1;
			var mascActual = document.#Attributes.form#.mascaraTarjeta#Attributes.sufijo#.value;
			arregloPosGuion = new Array();
			
			if(mascActual != ''){
				for (var i=0;i<mascActual.length;i++){
					if(mascActual.charAt(i) == '-'){
						posIndexGuiones = posIndexGuiones + 1;
						arregloPosGuion[posIndexGuiones] = i;
					}
				}
			}
		}		
		
		<cfif ExisteTarjeta and Attributes.readOnly>
			cargarImagenTarjeta#Attributes.sufijo#(#Attributes.query.MTid#);
		<cfelse>
			cargarImagenTarjeta#Attributes.sufijo#(document.#Attributes.form#.MTid#Attributes.sufijo#.value);
		</cfif>
		
		cargarTipoMascara#Attributes.sufijo#();
		cargaMascara#Attributes.sufijo#(document.#Attributes.form#.MTid#Attributes.sufijo#.value);				
		cargaPosGuion#Attributes.sufijo#();		
		
		
		/***--se carga los valores iniciales de telefonos--****/
		if (document.all.NumTarjeta#Attributes.sufijo#!= undefined) {
			var fv = document.all.NumTarjeta#Attributes.sufijo#.value;
				if(fv.length > 0){
					document.all._NumTarjeta#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
				}
		}
		if (document.all.confNumTarjeta#Attributes.sufijo#!= undefined) {
			var fv = document.all.confNumTarjeta#Attributes.sufijo#.value;
				if(fv.length > 0){
					document.all._confNumTarjeta#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
				}
		}
			
		/*****Fin de carga****/
	</script>
</cfoutput>
