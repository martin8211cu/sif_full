<cfif isdefined("url.fCMTScodigo") and len(url.fCMTScodigo) and not isdefined("form.fCMTScodigo")><cfset form.fCMTScodigo= url.fCMTScodigo></cfif>
<cfif isdefined("url.fCMTSdescripcion") and len(url.fCMTSdescripcion) and not isdefined("form.fCMTSdescripcion")><cfset form.fCMTSdescripcion= url.fCMTSdescripcion></cfif>

<cfif isdefined("url.fESnumero") and len(url.fESnumero) and not isdefined("form.fESnumero")><cfset form.fESnumero= url.fESnumero></cfif>
<cfif isdefined("url.fESnumero2") and len(url.fESnumero2) and not isdefined("form.fESnumero2")><cfset form.fESnumero2 = url.fESnumero2></cfif>
<cfif isdefined("url.fObservaciones") and len(url.fObservaciones) and not isdefined("form.fObservaciones")><cfset form.fObservaciones = url.fObservaciones></cfif>
<cfif isdefined("url.CFid_filtro") and len(url.CFid_filtro) and not isdefined("form.CFid_filtro")><cfset form.CFid_filtro = url.CFid_filtro></cfif>
<cfif isdefined("url.CFcodigo_filtro") and len(url.CFcodigo_filtro) and not isdefined("form.CFcodigo_filtro")><cfset form.CFcodigo_filtro = url.CFcodigo_filtro></cfif>
<cfif isdefined("url.fESfecha") and len(url.fESfecha) and not isdefined("form.fESfecha")><cfset form.fESfecha = url.fESfecha></cfif>
<cfif isdefined("url.CMSnombre1") and len(url.CMSnombre1) and not isdefined("form.CMSnombre1")><cfset form.CMSnombre1 = url.CMSnombre1></cfif>
<cfif isdefined("url.CMScodigo1") and len(url.CMScodigo1) and not isdefined("form.CMScodigo1")><cfset form.CMScodigo1 = url.CMScodigo1></cfif>
<cfif isdefined("url.CMSid1") and len(url.CMSid1) and not isdefined("form.CMSid1")><cfset form.CMSid1 = url.CMSid1></cfif>

<cfset solicitante = -1 >
<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante))>
	<cfset solicitante = session.compras.solicitante >
</cfif>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cfoutput>
	<form action="#GetFileFromPath(GetTemplatePath())#" name="form1" method="post" style="margin: 0">
      <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
        <tr>
          <td class="fileLabel" nowrap width="1%" align="right">Tipo de Solicitud:</td>
          <td nowrap width="1%">
            <input type="text" name="fCMTScodigo" id="fCMTScodigo" value="<cfif isDefined("form.fCMTScodigo")>#form.fCMTScodigo#</cfif>" size="5" maxlength="5" tabindex="-1" onBlur="javascript:traerTSolicitud(this.value,1);">
            <input type="text" name="fCMTSdescripcion" id="fCMTSdescripcion" value="<cfif isDefined("form.fCMTSdescripcion")>#form.fCMTSdescripcion#</cfif>" size="40" readonly>
            <a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTSolicitudes();"> </a> </td>
          <td class="fileLabel" nowrap width="1%" align="right">N&uacute;mero:</td>
          <td nowrap width="1%"> desde
              <input type="text" name="fESnumero" value="<cfif isdefined('form.fESnumero')>#form.fESnumero#</cfif>" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
      hasta
      <input type="text" name="fESnumero2" value="<cfif isdefined('form.fESnumero2')>#form.fESnumero2#</cfif>" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
          </td>
          <td class="fileLabel" align="right">Fecha:</td>
          <td>
            <cfif isdefined('form.fESfecha')>
              <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fESfecha" value="#form.fESfecha#">
              <cfelse>
              <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fESfecha" value="">
            </cfif>
          </td>
        </tr>
        <tr>
			<td class="fileLabel" align="right" nowrap>Solicitante:</td>
			<td nowrap>
				<cfif isdefined("form.CMSid1") and len(trim(form.CMSid1))>
				  <cfquery name="rsSolicitante" datasource="#session.DSN#">
					select CMScodigo,CMSnombre, CMSid from CMSolicitantes where CMSid =
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid1#">
				  </cfquery>
				</cfif>
				<input type="text" name="CMScodigo1" maxlength="10" value="<cfif isdefined("rsSolicitante")>#trim(rsSolicitante.CMScodigo)#</cfif>" size="10" onBlur="javascript:funcBuscaSolicitante(this.value);" >
				<input type="text" name="CMSnombre1" id="CMSnombre1" tabindex="1" readonly  disabled value="<cfif isdefined("rsSolicitante") >#rsSolicitante.CMSnombre#</cfif>" size="40" maxlength="80">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitantes" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisSolicitantes();'></a>
				<input type="hidden" name="CMSid1" id="CMSid1" value="<cfif isdefined("rsSolicitante") >#rsSolicitante.CMSid#</cfif>" >
			</td>

          <td class="fileLabel" align="right" nowrap>Descripci&oacute;n:</td>
          <td colspan="2">
            <input type="text" name="fObservaciones" size="40" maxlength="100" value="<cfif isdefined('form.fObservaciones')>#form.fObservaciones#</cfif>"  >
          </td>
        </tr>
        <tr>
		  <td class="fileLabel" nowrap width="1%" align="right">Centro Funcional:</td>
          <td nowrap width="1%">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <cfif isdefined('form.CFcodigo_filtro') and len(trim(form.CFcodigo_filtro)) and isdefined('form.CFid_filtro') and len(trim(form.CFid_filtro))>
                  <cfquery name="dataCF_filtro" datasource="#session.DSN#">
            select CFid, CFcodigo, CFdescripcion from CFuncional where Ecodigo =
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and CFid =
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid_filtro#">
                  </cfquery>
                </cfif>
                <td>
                  <input tabindex="1" type="text" name="CFcodigo_filtro" id="CFcodigo_filtro" value= "<cfif isdefined('dataCF_filtro') and dataCF_filtro.recordcount GT 0>#dataCF_filtro.CFcodigo#</cfif>" onBlur="javascript: TraeCFuncional(this); " size="10" maxlength="10" onFocus="javascript:this.select();">
                  <input type="hidden" name="CFid_filtro" value="<cfif isdefined('dataCF_filtro') and dataCF_filtro.recordcount GT 0>#dataCF_filtro.CFid#</cfif>">
                </td>
                <td>
                  <input type="text" name="CFdescripcion_filtro" id="CFdescripcion_filtro" disabled value="<cfif isdefined('dataCF_filtro') and dataCF_filtro.recordCount GT 0>#dataCF_filtro.CFdescripcion#</cfif>" size="30" maxlength="80" tabindex="1">
                </td>
                <td valign="middle"><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a></td>
              </tr>
          </table></td>

		  	<td align="right" colspan="2">
				<input type="submit" name="btnFiltro" value="Filtrar">
			</td>
        </tr>
      </table>
	</form>
</cfoutput>

<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<!---- Iframe de los centros funcionales ----->
<iframe name="frcf" id="frcf" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<!---- Iframe de los solicitantes ----->
<iframe name="frcf" id="frmSolic" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	//Funcion del conlis de tipos de solicitud
	function doConlisTSolicitudes() {
		popUpWindow("conlisTSolicitudesSolicitante.cfm?formulario=form1&NoEsSolicitante=true",250,150,550,400);
	}
	
	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTSolicitud(value) {
	  if (value!='') {
	   document.getElementById("fr").src = 'traerTSolicitudSolicitante.cfm?formulario=form1&fCMTScodigo='+value;
	  }
	  else {
	   document.form1.fCMTScodigo.value = '';
	   document.form1.fCMTSdescripcion.value = '';
	  }
	}	

	function TraeCFuncional(dato) {
		var params ="";
		params = "&CMSid="+document.form1.CMSid1.value+"&id=CFid_filtro&name=CFcodigo_filtro&desc=CFdescripcion_filtro";
		if (dato.value != "") {
			if (document.form1.CMSid1.value != ''){
				document.getElementById("frcf").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;		
			}
			else{
				alert("Debe seleccionar el solicitante")
				return false;
			}	
		}else{
			document.form1.CFid_filtro.value = "";
			document.form1.CFcodigo_filtro.value = "";
			document.form1.CFdescripcion_filtro.value = "";
		}
		return;
	}

	function doConlisCFuncional() {
		var params ="";
		params = "?CMSid="+document.form1.CMSid1.value+"&form=form1&id=CFid_filtro&name=CFcodigo_filtro&desc=CFdescripcion_filtro";
		if (document.form1.CMSid1.value != ''){
			popUpWindow("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
		}
		else{
			alert("Debe seleccionar el solicitante")
		}
	}
	
		//Conlis de compradores 
	function doConlisSolicitantes() {	
		var params = "";
			params = "?formulario=form1&idx=1" //&CMSid=CMSid1&CMScodigo=CMScodigo1&desc=CMSnombre1";
		popUpWindow("/cfmx/sif/cm/operacion/ConlisSolicitantes.cfm"+params,250,200,650,400);
	}
	
	function funcBuscaSolicitante(value){
		if ( value !='' ){
			document.getElementById("frmSolic").src = "/cfmx/sif/cm/operacion/traeSolicitantes.cfm?formulario=form1&CMScodigo="+value+"&indice=1";
		}
		else{
			document.form1.CMSid1.value = '';
			document.form1.CMScodigo1.value = '';
			document.form1.CMSnombre1.value = '';
		}
	}


</script>
