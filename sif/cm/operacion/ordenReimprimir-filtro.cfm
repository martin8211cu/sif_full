<cfif isdefined("url.CMCid1") and len(url.CMCid1) and not isdefined("form.CMCid1")><cfset form.CMCid1= url.CMCid1></cfif>
<!----<cfif isdefined("url.fCMTOcodigo") and len(url.fCMTOcodigo) and not isdefined("form.fCMTOcodigo")><cfset form.fCMTOcodigo= url.fCMTOcodigo></cfif>---->
<cfif isdefined("url.fEOnumero") and len(url.fEOnumero) and not isdefined("form.fEOnumero")><cfset form.fEOnumero= url.fEOnumero></cfif>
<cfif isdefined("url.fObservaciones") and len(url.fObservaciones) and not isdefined("form.fObservaciones")><cfset form.fObservaciones = url.fObservaciones></cfif>
<cfif isdefined("url.SNcodigo") and len(url.SNcodigo) and not isdefined("form.SNcodigo")><cfset form.SNcodigo = url.SNcodigo></cfif>
<cfif isdefined("url.fEOfecha") and len(url.fEOfecha) and not isdefined("form.fEOfecha")><cfset form.fEOfecha = url.fEOfecha></cfif>

<cfif isdefined("url.CMTOcodigo") and len(url.CMTOcodigo) and not isdefined("form.CMTOcodigo")><cfset form.CMTOcodigo= url.CMTOcodigo></cfif>
<cfif isdefined("url.CMTOdescripcion") and len(url.CMTOdescripcion) and not isdefined("form.CMTOdescripcion")><cfset form.CMTOdescripcion= url.CMTOdescripcion></cfif>


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
			params = "?formulario=forden&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
		popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
	}
	
	function comprador(value){
		if ( value !='' ){
			document.getElementById("frComprador").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=forden&CMCcodigo="+value+"&opcion=1";
		}
		else{
			document.forden.CMCid1.value = '';
			document.forden.CMCcodigo1.value = '';
			document.forden.CMCnombre1.value = '';
		}
	}

</script>

<!----
<cfquery name="rsTipos" datasource="#session.DSN#">
	select CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
---->

<cfif not isdefined("form.CMCid1") or len(trim(form.CMCid1)) eq 0 >
	<cfset form.CMCid1 = session.compras.comprador >
</cfif>

<cfquery name="rsComprador" datasource="#session.DSN#" >
	select CMCid, CMCcodigo, CMCnombre
	from CMCompradores
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1))>
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
	</cfif>
</cfquery>

<cfoutput>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<form style="margin: 0" action="orden-reimprimir.cfm" name="forden" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		<tr> 
			<td align="right" nowrap><strong>Comprador:</strong>&nbsp;</td>
			<td nowrap width="15%" >
				<input type="text" name="CMCcodigo1" maxlength="10" value="<cfif isdefined("rsComprador")>#trim(rsComprador.CMCcodigo)#</cfif>" size="10" onBlur="javascript:comprador(this.value);" >
				<input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="<cfif isdefined("rsComprador") >#rsComprador.CMCnombre#</cfif>" size="40" maxlength="80">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
				<input type="hidden" name="CMCid1" id="CMCid1" value="<cfif isdefined("rsComprador") >#rsComprador.CMCid#</cfif>" >
			</td>

			<td nowrap width="1%">
				<label for="fCMTScodigo"><strong>Tipo de Orden:&nbsp;</strong></label>
			</td>	
			<td nowrap width="15%">
				<input name="CMTOcodigo" type="text" value="<cfif isDefined("form.CMTOcodigo")><cfoutput>#form.CMTOcodigo#</cfoutput></cfif>" 
					id="CMTOcodigo" size="5" maxlength="5" tabindex="-1" onblur="javascript:traerTOrden(this.value,1);">
				<input name="CMTOdescripcion" type="text" id="CMTOdescripcion" value="<cfif isDefined("form.CMTOdescripcion")><cfoutput>#form.CMTOdescripcion#</cfoutput></cfif>" size="40" readonly>
				<a href="##" tabindex="-1">
				<img src="../../imagenes/Description.gif" alt="Lista de tipos de Órdenes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTOrdenes();">
				</a>        											
				<!----
				<select name="fCMTOcodigo">
					<option value="">Todos</option> 
					<cfloop query="rsTipos">
						<option value="#rsTipos.CMTOcodigo#" <cfif isdefined("form.fCMTOcodigo") and trim(form.fCMTOcodigo) eq trim(rsTipos.CMTOcodigo) >selected</cfif>  >#rsTipos.CMTOdescripcion#</option> 
					</cfloop>
				</select>
				---->
			</td>
			
			<td nowrap width="1%" align="right">
				<strong>N&uacute;mero:&nbsp;</strong>
			</td>	
			<td nowrap >
				<input type="text" name="fEOnumero" value="<cfif isdefined('form.fEOnumero')>#form.fEOnumero#</cfif>" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
		</tr>

		<tr>
			<td nowrap width="1%" align="right">
				<strong>Descripci&oacute;n:&nbsp;</strong>
			</td>
			<td>
				<input type="text" name="fObservaciones" size="40" maxlength="100" value="<cfif isdefined('form.fObservaciones')>#form.fObservaciones#</cfif>"  >
			</td>

			<td class="fileLabel" nowrap width="1%" align="right">
				<strong>Proveedor:&nbsp;</strong>
			</td>	
			<td class="fileLabel" nowrap width="1%">
				<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
					<cf_sifsociosnegocios2 idquery="#form.SNcodigo#" form="forden">
				<cfelse>
					<cf_sifsociosnegocios2 form="forden">
				</cfif>
			</td>
			
			<td align="right"><strong>Fecha:&nbsp;</strong></td>
			<td>
				<cfif isdefined('form.fESfecha')>
					<cf_sifcalendario conexion="#session.DSN#" form="forden" name="fEOfecha" value="#form.fEOfecha#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="forden" name="fEOfecha" value="">
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

<!---  Iframe para el conlis de tipos de Solicitud ---->
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
	function doConlisTOrdenes() {
		popUpWindow("conlisTOrdenesSolicitante.cfm?formulario=forden",250,150,550,400);
	}
	
	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTOrden(value){
	  if (value!=''){	   
	   document.getElementById("fr").src = 'traerTOrdenesSolicitante.cfm?formulario=forden&CMTOcodigo='+value;
	  }
	  else{
	   document.forden.CMTOcodigo.value = '';
	   document.forden.CMTOdescripcion.value = '';
	  }
	 }	
</script>


