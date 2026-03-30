<cfset modo = "ALTA">
<cfif isdefined('form.MRid') and form.MRid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select MRid, EMid, access_server, MRdesde, MRhasta, Ecodigo, BMUsucodigo, ts_rversion
		from  ISBmedioRango 
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MRid#" null="#Len(form.MRid) Is 0#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="cias">
	select EMid, EMnombre
	from ISBmedioCia
	order by EMnombre
</cfquery>

<script type="text/javascript">
<!--
	//Validacion de IP al formato permitido 		N (1..3) + "." + N (1..3) + "." + N (1..3) + "." + N (1..3)
	function validaIP(ip){
		var NUMEROS="0123456789."
		var numPuntos = 0;
		var numSegm = '';		
		var numSegmNUM = 0;		
		var numTrios = 0;	

		if((ip.substr(0,1) == '.') || (ip.substr(ip.length - 1,1) == '.')){
			return false;
		}else{
			if(ip.length < 7)
				return false;		
					
			for (var i=0; i<ip.length; i++){
				CARACTER=ip.substr(i,1);
				if (NUMEROS.indexOf(CARACTER)<0) {
					return false;
				}else{
					if(CARACTER == '.'){
						if(numTrios == 0){
							return false;
						}else{
							numPuntos = numPuntos + 1;
							numSegmNUM = new Number(numSegm);
							if(numSegmNUM > 255)
								return false;
							numTrios = 0;					
							numSegm = '';
							numSegmNUM = 0;
						}
					}else{
						if(numTrios >= 3){
							return false;
						}else{
							numSegm = numSegm + CARACTER;
							numTrios = numTrios + 1;		
						}
					}
				} 			
			}	
			if((numPuntos < 3) || (numPuntos > 3))
				return false;
			if(ip.length > 15)
				return false;
			if(ip.length > 15)
				return false;
		}
			
		return true;
	}
	
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBmedioRango - Rango Medios 
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: EMid Empresa Medio numeric
			if (formulario.EMid.value == "") {
				error_msg += "\n - Empresa Medio no puede quedar en blanco.";
				error_input = formulario.EMid;
			}
		
			// Columna: access_server Servidor de acceso varchar(100)
			if (formulario.access_server.value == "") {
				error_msg += "\n - Servidor de acceso desde no puede quedar en blanco.";
				error_input = formulario.access_server;
			}
		
			// Columna: MRdesde Direccin IP desde varchar(255)
			if (formulario.MRdesde.value == "") {
				error_msg += "\n - Direccin IP inicial no puede quedar en blanco.";
				error_input = formulario.MRdesde;
			}else{
				if(!validaIP(formulario.MRdesde.value)){
					error_msg += "\n - Direccin IP inicial es inválida.";
					error_input = formulario.MRdesde;					
				}
			}
		
			// Columna: MRhasta Direccin IP hasta varchar(255)
			if (formulario.MRhasta.value == "") {
				error_msg += "\n - Direccin IP final no puede quedar en blanco.";
				error_input = formulario.MRhasta;
			}else{
				if(!validaIP(formulario.MRhasta.value)){
					error_msg += "\n - Direccin IP final es inválida.";
					error_input = formulario.MRhasta;					
				}
			}
		
			// Columna: MRdesdeNormal IP desde Normalizado varchar(255)
			/*if (formulario.MRdesdeNormal.value == "") {
				error_msg += "\n - IP desde Normalizado no puede quedar en blanco.";
				error_input = formulario.MRdesdeNormal;
			}
		
			// Columna: MRhastaNormal IP hasta Normalizado varchar(255)
			if (formulario.MRhastaNormal.value == "") {
				error_msg += "\n - IP hasta Normalizado no puede quedar en blanco.";
				error_input = formulario.MRhastaNormal;
			}*/
		}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>
<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
<cfoutput>
	<form action="ISBmedioRango-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBmedioRango-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Rango Medios
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td>
			</tr>			
			<tr>
				<td width="20%" align="right" valign="top">
					<label for="EMid">
						Empresa Medio:
					</label>
				</td>
				<td width="80%" valign="top">
					<select name="EMid" tabindex="1">
						<cfloop query="cias">
						<option value="#HTMLEditFormat(cias.EMid)#" <cfif modo NEQ 'ALTA' and isdefined('data') and cias.EMid eq data.EMid>selected</cfif>> #HTMLEditFormat(cias.EMnombre) #</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>	
				<td valign="top" align="right">
					<label for="access_server">
						Servidor de acceso:
					</label>	
				</td>
				<td valign="top">
					<input name="access_server" 
					id="access_server" 
					onblur="javascript: validaBlancos(this);"
					type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.access_server)#</cfif>" 
					maxlength="100" size="80"
					onfocus="this.select()"  
					onblur="this.value = this.value.toLowerCase()" >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="MRdesde">
						Dirección IP inicial:
					</label>
				</td>
				<td valign="top">
					<input name="MRdesde" id="MRdesde" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.MRdesde)#</cfif>" 
						maxlength="255" size="80"
						onfocus="this.select()"  >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="MRhasta">
						Dirección IP final:
					</label>
				</td>
				<td valign="top">
					<input name="MRhasta" id="MRhasta" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.MRhasta)#</cfif>" 
						maxlength="255" size="80"
						onfocus="this.select()"  >
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td>			
			<tr>
				<td colspan="2" class="formButtons">
					<cf_botones modo="#modo#" include="Regresar" tabindex="1">
				</td>
			</tr>
		</table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>
			<input type="hidden" name="MRid" value="#HTMLEditFormat(data.MRid)#">
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
</cfoutput>

