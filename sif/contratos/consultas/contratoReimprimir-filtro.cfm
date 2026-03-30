<cfif isdefined("url.CTCid1") and len(url.CTCid1) and not isdefined("form.CTCid1")><cfset form.CTCid1= url.CTCid1></cfif>

<cfif isdefined("url.fCTCnumContrato") and len(url.fCTCnumContrato) and not isdefined("form.fCTCnumContrato")><cfset form.fCTCnumContrato= url.fCTCnumContrato></cfif>
<cfif isdefined("url.fDescripcion") and len(url.fDescripcion) and not isdefined("form.fDescripcion")><cfset form.fDescripcion = url.fDescripcion></cfif>
<cfif isdefined("url.SNcodigo") and len(url.SNcodigo) and not isdefined("form.SNcodigo")><cfset form.SNcodigo = url.SNcodigo></cfif>
<cfif isdefined("url.fCTfecha") and len(url.fCTfecha) and not isdefined("form.fCTfecha")><cfset form.fCTfecha = url.fCTfecha></cfif>

<cfif isdefined("url.CTCcodigo") and len(url.CTCcodigo) and not isdefined("form.CTCcodigo")><cfset form.CTCcodigo= url.CTCcodigo></cfif>
<cfif isdefined("url.CTCdescripcion") and len(url.CTCdescripcion) and not isdefined("form.CTCdescripcion")><cfset form.CTCdescripcion= url.CTCdescripcion></cfif>


<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisCompradores() {
		var params = "";
			params = "?formulario=fcontrato&CTCid=CTCid1&CTCcodigo=CTCcodigo1&desc=CTCnombre1";
		popUpWindow("/cfmx/sif/contratos/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
	}
	
	function comprador(value){
		if ( value !='' ){
			document.getElementById("frComprador").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=fcontrato&CTCcodigo="+value+"&opcion=1";
		}
		else{
			document.fcontrato.CTCid1.value = '';
			document.fcontrato.CTCcodigo1.value = '';
			document.fcontrato.CTCnombre1.value = '';
		}
	}

</script>


<cfif not isdefined("form.CTCid1") or len(trim(form.CTCid1)) eq 0 >
	<cfset form.CTCid1 = session.compras.comprador >
</cfif>

<cfquery name="rsComprador" datasource="#session.DSN#" >
	select CTCid, CTCcodigo, CTCnombre
	from CTCompradores
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.CTCid1") and len(trim(form.CTCid1))>
		and CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCid1#">
	</cfif>
</cfquery>

<cfoutput>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<form style="margin: 0" action="contrato-reimprimir.cfm" name="fcontrato" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		<tr> 
			<td align="right" nowrap><strong>Comprador:</strong>&nbsp;</td>
			<td nowrap width="15%" >
				<input type="text" name="CTCcodigo1" maxlength="10" value="<cfif isdefined("rsComprador")>#trim(rsComprador.CTCcodigo)#</cfif>" size="10" onBlur="javascript:comprador(this.value);" >
				<input type="text" name="CTCnombre1" id="CTCnombre1" tabindex="1" readonly value="<cfif isdefined("rsComprador") >#rsComprador.CTCnombre#</cfif>" size="40" maxlength="80">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
				<input type="hidden" name="CTCid1" id="CTCid1" value="<cfif isdefined("rsComprador") >#rsComprador.CTCid#</cfif>" >
			</td>

			<td nowrap width="1%">
				<label for="fCMTScodigo"><strong>Tipo de Contrato:&nbsp;</strong></label>
			</td>	
			<td nowrap width="15%">
				<input name="CTCcodigo" type="text" value="<cfif isDefined("form.CTCcodigo")><cfoutput>#form.CTCcodigo#</cfoutput></cfif>" 
					id="CTCcodigo" size="5" maxlength="5" tabindex="-1" onblur="javascript:traerTOrden(this.value,1);">
				<input name="CTCdescripcion" type="text" id="CTCdescripcion" value="<cfif isDefined("form.CTCdescripcion")><cfoutput>#form.CTCdescripcion#</cfoutput></cfif>" size="40" readonly>
				<a href="##" tabindex="-1">
				<img src="../../imagenes/Description.gif" alt="Lista de tipos de Órdenes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTContrato();">
				</a>        											

			</td>
			
			<td nowrap width="1%" align="right">
				<strong>N&uacute;mero:&nbsp;</strong>
			</td>	
			<td nowrap >
				<input type="text" name="fCTCnumContrato" value="<cfif isdefined('form.fCTCnumContrato')>#form.fCTCnumContrato#</cfif>" size="50" maxlength="50" style="text-align: left;"    >
			</td>
		</tr>

		<tr>
			<td nowrap width="1%" align="right">
				<strong>Descripci&oacute;n:&nbsp;</strong>
			</td>
			<td>
				<input type="text" name="fDescripcion" size="40" maxlength="100" value="<cfif isdefined('form.fDescripcion')>#form.fDescripcion#</cfif>"  >
			</td>

			<td class="fileLabel" nowrap width="1%" align="right">
				<strong>Proveedor:&nbsp;</strong>
			</td>	
			<td class="fileLabel" nowrap width="1%">
				<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
					<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="fcontrato">
				<cfelse>
					<cf_sifsociosnegocios2 form="fcontrato">
				</cfif>
			</td>
			
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td>
				<cfif isdefined('form.fESfecha')>
					<cf_sifcalendario conexion="#session.DSN#" form="fcontrato" name="fCTfecha" value="#form.fCTfecha#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="fcontrato" name="fCTfecha" value="">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="6" align="center" ><input type="submit" name="btnFiltro"  value="Consultar"></td>
		</tr>		

	</table>
</form>
<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
</cfoutput>

<!---  Iframe para el conlis de tipos de Contratos ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	//Funcion del conlis de tipos de solicitud
	function doConlisTContrato() {
		popUpWindow("conlisTContratos.cfm?formulario=fcontrato",250,150,550,400);
	}
	
	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTOrden(value){
	  if (value!=''){	   
	   document.getElementById("fr").src = 'traerTOrdenesSolicitante.cfm?formulario=fcontrato&CTCcodigo='+value;
	  }
	  else{
	   document.fcontrato.CTCcodigo.value = '';
	   document.fcontrato.CTCdescripcion.value = '';
	  }
	 }	
</script>


