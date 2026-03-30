<!-- CF_conlis: "formOri": "CPcuenta,CPformato" -->
<script language="JavaScript">
	var popUpWin_formOri_CPcuenta=null;
	function rtrim(sString) 
	{
		if (sString == "")
			return "";
		while (sString.substring(sString.length-1, sString.length) == ' ')
			sString = sString.substring(0,sString.length-1);
		return sString;
	}
	function popUpWindow_formOri_CPcuenta(URLStr, left, top, width, height)
	{		
	  if(popUpWin_formOri_CPcuenta)
	  {
		if(!popUpWin_formOri_CPcuenta.closed) popUpWin_formOri_CPcuenta.close();
	  }
	  popUpWin_formOri_CPcuenta = open(URLStr, 'popUpWin_formOri_CPcuenta', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  if (! popUpWin_formOri_CPcuenta && !document.popupblockerwarning) {
		alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
		document.popupblockerwarning = 1;
	  }
	  else
		if(popUpWin_formOri_CPcuenta.focus) popUpWin_formOri_CPcuenta.focus();
	}
	
	function doConlis_formOri_CPcuenta(x)
	{
		var conlisArgs = '';
		var LvarOcodigo	= document.formOri.Ocodigo.value
		<cfoutput>
		if (LvarOcodigo.replace(/\s+/,"") != "")
			conlisArgs += '&ofi=' + LvarOcodigo;
		<cfif rsTrasladoCta.CPNRPTsecuencia NEQ "">
			conlisArgs += '&sec=#rsTrasladoCta.CPNRPTsecuencia#';
		</cfif>
		popUpWindow_formOri_CPcuenta('/cfmx/sif/presupuesto/common/conlis_CPcuenta_query.cfm?NRP=#Form.CPNRPnum#&ano=#rsNRPmeses.CPCano#&mes=#rsNRPmeses.CPCmes#'+conlisArgs,100,250,1000,680);
		</cfoutput>
	}
	function trae_formOri_CPformato(doTraer)
	{
		var LvarCPformato	= document.formOri.CPformato.value
		var LvarOcodigo	= document.formOri.Ocodigo.value
		if (doTraer == false) return;
		if (LvarCPformato.replace(/\s+/,"") != "")	
		{
			limpia_formOri_CPcuenta (document.formOri.CPformato);
			var conlisArgs = '';
			conlisArgs = conlisArgs + '&filtro_CPformato=' + escape(LvarCPformato);
			<cfoutput>
			if (LvarOcodigo.replace(/\s+/,"") != "")
				conlisArgs = conlisArgs + '&ofi=' + escape(LvarOcodigo);
		<cfif rsTrasladoCta.CPNRPTsecuencia NEQ "">
			conlisArgs += '&sec=#rsTrasladoCta.CPNRPTsecuencia#';
		</cfif>
			//sbCF_IFramesStatus_formOri_ontraeAppend("CPformato");
			document.getElementById('frame_formOri_CPcuenta').src = '/cfmx/sif/presupuesto/common/conlis_CPcuenta_query.cfm?query=1&NRP=#Form.CPNRPnum#&ano=#rsNRPmeses.CPCano#&mes=#rsNRPmeses.CPCmes#&CampoOnTrae=CPformato'+conlisArgs;
			</cfoutput>
		} 
		else 
		{ 
			if (window.reset_formOri_CPcuenta) 
			{
				reset_formOri_CPcuenta();
			}
			limpia_formOri_CPcuenta();
		}
	}
	function setReadOnly_formOri_CPcuenta(pReadOnly)
	{
		if (pReadOnly)
		{
			document.formOri.CPformato.tabIndex 			= -1;
			document.formOri.CPformato.readOnly			= true;
			document.formOri.CPformato.style.border		= "solid 1px #CCCCCC";
			document.formOri.CPformato.style.backGround	= "inherit";
		}
		else
		{
			document.formOri.CPformato.tabIndex 			= 1;
			document.formOri.CPformato.readOnly			= false;
			document.formOri.CPformato.style.border		= window.Event ? "" : "inset 2px";
			document.formOri.CPformato.style.backGround	= "";
		}
	
		document.getElementById("img_formOri_CPcuenta").style.display = pReadOnly ? "none" : "";

		return;
	}

	function limpia_formOri_CPcuenta(pInput)
	{
		if (
				document.formOri.CPcuenta
			&&	document.formOri.CPcuenta != pInput
			)
			document.formOri.CPcuenta.value = '';
	
		if (
				document.formOri.CPformato
			&&	document.formOri.CPformato != pInput
			)
			document.formOri.CPformato.value = '';
	
		if (
				document.formOri.CPdescripcion
			&&	document.formOri.CPdescripcion != pInput
			)
			document.formOri.CPdescripcion.value = '';
	
		if (
				document.formOri.CPCPtipoControl
			&&	document.formOri.CPCPtipoControl != pInput
			)
			document.formOri.CPCPtipoControl.value = '';
	
		if (
				document.formOri.CPCPcalculoControl
			&&	document.formOri.CPCPcalculoControl != pInput
			)
			document.formOri.CPCPcalculoControl.value = '';
	}	
	
	function conlis_keyup__formOri_CPcuenta(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {
			doConlis_formOri_CPcuenta();
		}
	}
</script>
<cfoutput>
<table width="1%" border="0" cellspacing="0" cellpadding="0" style="border:0px;">
	<tr>
		<td>
				<input 	type="hidden" id="CPcuenta"  name="CPcuenta" alt="CPcuenta"
						value="<cfif rsTrasladoCta.CPcuenta neq "">#rsTrasladoCta.CPcuenta#</cfif>"
				>
		</td>
		<td>
				<input 
					style="font-size:-1px;"
				
					type="text" id="CPformato" name="CPformato"
					value="<cfif rsTrasladoCta.CPcuenta neq "">#rsTrasladoCta.CPformato#</cfif>"
					size="72" 
				
					tabindex="1"
					onfocus="javascript:LvarCPformato_valueOri = this.value; this.select();"
					onblur="javascript:var LvarChanged = (LvarCPformato_valueOri != this.value);if (this.readOnly) return; LvarCPformato_valueOri = ''; trae_formOri_CPformato(LvarChanged);"
					onkeyup="javascript:conlis_keyup__formOri_CPcuenta(event);"
					alt="CPformato"
					title="CPformato"
				>
		</td>
		<td>
			<a href="javascript:doConlis_formOri_CPcuenta();" tabindex="-1" id="img_formOri_CPcuenta">
				<img src="/cfmx/sif/imagenes/Description.gif"
					alt="Lista de Cuentas de Egreso de Presupuesto con Disponible"
					name="imagen_formOri_CPcuenta"
					width="18" height="14"
					border="0" align="absmiddle">
			</a>		
		</td>
	</tr>
</table>
</cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<iframe id="frame_formOri_CPcuenta" name="frame_formOri_CPcuenta" marginheight="0" marginwidth="0" frameborder="0" 
					height="0" width="0" scrolling="no" style="display:none"
			></iframe>
		</td>
	</tr>
</table>
