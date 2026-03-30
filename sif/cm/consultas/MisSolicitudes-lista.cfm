<!---    Combo de tipos de solicitud de compra --->
<!-----
<cfquery name="rsTiposSolicitud" datasource="#session.DSN#">
	select CMTScodigo, CMTSdescripcion
	from 	CMTiposSolicitud
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
---->

<cf_templateheader title="Consulta de Solicitudes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitudes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

			<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
			<cfif isdefined("url.fESnumeroD") and not isdefined("form.fESnumeroD") >
				<cfset form.fESnumeroD = url.fESnumeroD >
			</cfif>
			
			<cfif isdefined("url.fESnumeroH") and not isdefined("form.fESnumeroH") >
				<cfset form.fESnumeroH = url.fESnumeroH >
			</cfif>
			
			<cfif isdefined("url.fechaD") and not isdefined("form.fechaD") >
				<cfset form.fechaD = url.fechaD >
			</cfif>
			
			<cfif isdefined("url.LTipos") and not isdefined("form.LTipos") >
				<cfset form.LTipos = url.LTipos >
			</cfif>
			
			<cfif isdefined("url.fechaH") and not isdefined("form.fechaH") >
				<cfset form.fechaH = url.fechaH >
			</cfif>

			<cfif isdefined("url.fCFid") and not isdefined("form.fCFid") >
				<cfset form.fCFid = url.fCFid >
			</cfif>
			
			<cfif isdefined("url.LEstado") and not isdefined("form.LEstado") >
				<cfset form.LEstado = url.LEstado >
			</cfif>
			
			<cfif isdefined("url.fCMTScodigo") and not isdefined("form.fCMTScodigo") >
				<cfset form.fCMTScodigo = url.fCMTScodigo >
			</cfif>
			
			<cfif isdefined("url.fCMTSdescripcion") and not isdefined("form.fCMTSdescripcion") >
				<cfset form.fCMTSdescripcion = url.fCMTSdescripcion >
			</cfif>
			
			
			<!--- *** Asigna a la variable navegacion los filtros  --->
			<cfset navegacion = "">
			<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) >
				<cfset navegacion = navegacion & "&fESnumeroD=#form.fESnumeroD#">
			</cfif>
			
			<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) >
				<cfset navegacion = navegacion & "&fESnumeroH=#form.fESnumeroH#">
			</cfif>

			<cfif isdefined("Form.LTipos") and len(trim(form.LTipos)) >
				<cfset navegacion = navegacion & "&LTipos=#form.LTipos#">
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(form.fechaD)) >
				<cfset navegacion = navegacion & "&fechaD=#form.fechaD#">
			</cfif>
			
			<cfif isdefined("Form.fechaH") and len(trim(form.fechaH)) >
				<cfset navegacion = navegacion & "&fechaH=#form.fechaH#">
			</cfif>

			<cfif isdefined("Form.fCFid") and len(trim(form.fCFid))>
				<cfset navegacion = navegacion & "&fCFid=#form.fCFid#">
			</cfif>
			
			<cfif isdefined("Form.LEstado") and len(trim(form.LEstado))>
				<cfset navegacion = navegacion & "&LEstado=#form.LEstado#">
			</cfif>
			
			<cfif isdefined("Form.fCMTScodigo") and len(trim(form.fCMTScodigo))>
				<cfset navegacion = navegacion & "&fCMTScodigo=#form.fCMTScodigo#">
			</cfif>
			
			<cfif isdefined("Form.fCMTSdescripcion") and len(trim(form.fCMTSdescripcion))>
				<cfset navegacion = navegacion & "&fCMTSdescripcion=#form.fCMTSdescripcion#">
			</cfif>
			
			<form style="margin: 0" action="MisSolicitudes-lista.cfm" name="form1" method="post">
		      <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
                <tr>
                  <td align="right" class="fileLabel" nowrap><label for="fESnumeroD">Del N&uacute;mero:</label></td>
                  <td nowrap>
                    <table>
                      <tr>
                        <td>
                          <input type="text" name="fEsnumeroD" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroD')><cfoutput>#form.fESnumeroD#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">
                        </td>
                        <td width="32">&nbsp;</td>
						<td align="right" class="fileLabel" nowrap><label for="fESnumeroH">Al N&uacute;mero:</label></td>
                        <td nowrap align="right">
                          <input type="text" name="fEsnumeroH" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroH')><cfoutput>#form.fESnumeroH#</cfoutput></cfif>" onBlur="javascript:fm(this,0)" onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">
                        </td>
                      </tr>
                    </table>
                 
                   	<td align="right" class="fileLabel" nowrap >Fecha Desde:</td>
                    <td width="33%">
                    <table>
                      <tr>
						<td nowrap>
                          <cfif isdefined('form.fechaD')>
                            <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
                            <cfelse>
                            <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
                          </cfif>
                        </td>
                        <td align="right" nowrap class="fileLabel">Fecha Hasta:</td>
                        <td nowrap>
                          <cfif isdefined('form.fechaH')>
                            <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
                            <cfelse>
                            <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
                          </cfif>
                        </td>
                      </tr>
                    </table>
				<td width="1">&nbsp;</td>	
                  <td align="right" class="fileLabel" nowrap><label for="LEstado">Estado:</label></td>
                  <td width="19%" nowrap class="fileLabel">
                    <select name="LEstado" id="LEstado">
                      <option value="">- No especificado -</option>
                      <!---<cfif isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))> --->
                      <option value="0" <cfif isdefined('form.LEstado') and form.LEstado EQ 0>selected</cfif>>Pendiente</option>
                      <option value="-10" <cfif isdefined('form.LEstado') and form.LEstado EQ -10>selected</cfif>>Rechazada por presupuesto</option>
                      <option value="10" <cfif isdefined('form.LEstado') and form.LEstado EQ 10>selected</cfif>>En trámite de aprobación</option>
                      <!---</cfif> --->
                      <option value="20" <cfif isdefined('form.LEstado') and form.LEstado EQ 20>selected</cfif>>Aplicada</option>
                      <option value="25" <cfif isdefined('form.LEstado') and form.LEstado EQ 25>selected</cfif>>Orden de Compra Directa</option>
                      <!---<option value="30" <cfif isdefined('form.LEstado') and form.LEstado EQ 30>selected</cfif>>Incluida en Publicación</option>--->
                      <option value="40" <cfif isdefined('form.LEstado') and form.LEstado EQ 40>selected</cfif>>Parcialmente Surtida</option>
                      <option value="50" <cfif isdefined('form.LEstado') and form.LEstado EQ 50>selected</cfif>>Surtida</option>
                      <option value="60" <cfif isdefined('form.LEstado') and form.LEstado EQ 60>selected</cfif>>Cancelada</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td width="11%" align="right" nowrap class="fileLabel">
                    <label for="fCFid">Ctro.Funcional:</label>
                  </td>
                  <td width="21%" nowrap class="fileLabel">
                    <cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
                      <cfquery name="rscfuncional" datasource="#Session.DSN#">
							select CFid as fCFid, CFcodigo, CFdescripcion 
							from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
					  </cfquery>
					  	<cf_rhcfuncional id="fCFid" form="form1" query="#rscfuncional#">
					  <cfelse>
					  	<cf_rhcfuncional id="fCFid" form="form1">
                    </cfif>
                  </td>
				  
                  <td width="8%" align="right" nowrap class="fileLabel"><label for="fTipoSolicitud">Tipo:</label></td>
                  <td><table><tr>
				  <td width="73%" nowrap> <cfoutput>
                      <input name="fCMTScodigo" type="text" value="<cfif isDefined("form.fCMTScodigo")><cfoutput>#form.fCMTScodigo#</cfoutput></cfif>"  id="fCMTScodigo" size="5" maxlength="5" tabindex="-1" onBlur="javascript:traerTSolicitud(this.value,1);">
                      <input name="fCMTSdescripcion" type="text" id="fCMTSdescripcion" value="<cfif isDefined("form.fCMTSdescripcion")><cfoutput>#form.fCMTSdescripcion#</cfoutput></cfif>" size="40" readonly>
                      <a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTSolicitudes();"> </a> </cfoutput> </td>
                  </tr></table></td>
				  <td width="1">&nbsp;</td>
				  <td width="7%" align="center" colspan="2"><input type="submit" name="btnFiltro" value="Filtrar"></td>
                </tr>
              </table>
			</form>
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rsLista" datasource="#session.DSN#">
				select a.ESidsolicitud, a.Ecodigo, a.ESnumero, a.CFid, 
					   a.CMSid, a.CMTScodigo, a.SNcodigo, a.Mcodigo, 
					   a.CMCid, a.CMElinea, a.EStipocambio, a.ESfecha, 
					   a.ESobservacion, a.NAP, a.NRP, a.NAPcancel, 
					   a.EStotalest, a.ESestado, a.Usucodigo, a.ESfalta, 
					   a.Usucodigomod, a.fechamod, a.ESreabastecimiento,
					   a.EStotalest,
					   b.CFdescripcion,
					   c.CMTScodigo, c.CMTSdescripcion,
					   c.CMTScodigo#_Cat#' - '#_Cat#c.CMTSdescripcion as Corte,
					   d.Mnombre
				from ESolicitudCompraCM a
						inner join CFuncional b
							on b.CFid = a.CFid
						inner join CMTiposSolicitud c 			
							on c.Ecodigo = a.Ecodigo 
							and c.CMTScodigo = a.CMTScodigo
						inner join Monedas d
							on a.Mcodigo = d.Mcodigo 
							and a.Ecodigo = d.Ecodigo

				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante))>
					and a.CMSid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.solicitante#"> 
				</cfif>
					
				<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
					<cfif form.fESnumeroD  GT form.fESnumeroH>
						and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
						and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
					<cfelseif form.fESnumeroD EQ form.fESnumeroH>
						and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
					<cfelse>
							and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
							and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
					</cfif>
				</cfif>
				
				<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and not (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
						and a.ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
				</cfif>
				
				<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) and not (isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD))) >
						and a.ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
				</cfif>
											
				<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
					and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fCMTScodigo#">
				</cfif>
				
				<cfif isdefined("form.LEstado") and len(trim(form.LEstado)) >
					and a.ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
				</cfif>

				<cfif isdefined("Form.fCFid") and len(trim(Form.fCFid)) >
					and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
				</cfif>

				<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
					<cfif form.fechaD EQ form.fechaH>
						and a.ESfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
					<cfelse>
						and a.ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
					</cfif>
				</cfif>

				<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
					and a.ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
					<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
				</cfif>

				<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
					and a.ESfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
					<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
				</cfif>

				order by Corte, a.ESnumero
			</cfquery>

			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="cortes" value="Corte"/>
				<cfinvokeargument name="desplegar" value="ESnumero, ESobservacion,  ESfecha, CFdescripcion, Mnombre, EStotalest"/>
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Fecha, Centro Funcional, Moneda, Total"/>
				<cfinvokeargument name="formatos" value="V, V, D, V, V, M "/>
				<cfinvokeargument name="align" value="left, left, left, left, left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="MisSolicitudes-lista.cfm "/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="ESidsolicitud"/>
				<cfinvokeargument name="funcion" value="doConlis"/>
				<cfinvokeargument name="fparams" value="ESidsolicitud,ESestado"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/> 
				<!----<cfinvokeargument name="maxrows" value="3"/>---->
			</cfinvoke>

<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor,estado) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/MisSolicitudes-vista.cfm?&ESidsolicitud="+valor+"&ESestado="+estado,20,20,950,600);
	}
	
	//Funcion del conlis de tipos de solicitud
	function doConlisTSolicitudes() {
		popUpWindow("../operacion/conlisTSolicitudesSolicitante.cfm?formulario=form1",250,150,550,400);
	}
	
	//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
	function traerTSolicitud(value){
	  if (value!=''){	   
	   document.getElementById("fr").src = '../operacion/traerTSolicitudSolicitante.cfm?formulario=form1&fCMTScodigo='+value;
	  }
	  else{
	   document.form1.fCMTScodigo.value = '';
	   document.form1.fCMTSdescripcion.value = '';
	  }
	 }	

	<cfif isdefined("Regresar")>
		function funcRegresar(){
			location.href = "<cfoutput>#Regresar#</cfoutput>";
			return true;
		}
	</cfif>
//-->
</script>
			
		<cf_web_portlet_end>
	<cf_templatefooter>
