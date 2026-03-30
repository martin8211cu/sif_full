<!---►►Manejo de Variables◄◄--->
<cfif isdefined('url.EPDid')>
	<cfset form.EPDid_DP = url.EPDid>
<cfelseif isdefined("form.EPDidFiltro")>
    <cfset form.EPDid_DP = form.EPDidFiltro>
</cfif>
<cfif isdefined("url.DdocumentoF") and not isdefined("form.DdocumentoF")>
    <cfset form.DdocumentoF = url.DdocumentoF>
</cfif>
<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
    <cfset form.fechaF = url.fechaF>
</cfif>
<cfif isdefined("url.SNnumeroF") and not isdefined("form.SNnumeroF")>
    <cfset form.SNnumeroF = url.SNnumeroF>
</cfif>
<cfif isdefined("url.SNcodigoF") and not isdefined("form.SNcodigoF")>
    <cfset form.SNcodigoF = url.SNcodigoF>
</cfif>
<cfif isdefined("url.EPDid_DP") and not isdefined("form.EPDid_DP")>
    <cfset form.EPDid_DP = url.EPDid_DP>
</cfif>
<cfif isdefined("form.EPDid_DP") and Len(Trim(form.EPDid_DP)) NEQ 0>
	<cfset Regresar="/cfmx/sif/cm/operacion/EDocumentos-lista.cfm?EPDid=#form.EPDid_DP#">					
</cfif>
<cfset fechaParam = "" >
<cfif isdefined('form.fechaF') and form.fechaF NEQ ''>
	<cfset fechaParam = LSDateFormat(form.fechaF,'dd/mm/yyyy') >
</cfif>
<cfset valSNcodF = ''>
<cfif isdefined('form.SNcodigoF') and form.SNcodigoF NEQ ''>
	<cfset valSNcodF = form.SNcodigoF>
</cfif>	

<!---►►Listado◄◄--->
<cfset navegacion = "">
<cfquery name="rsLista" datasource="#session.DSN#">
    Select CASE EDIestado WHEN 0 THEN 'En Digitación' WHEN 10 THEN 'Aplicada' ELSE 'Desconocido' END AS Estado,
    	   CASE EDIestado WHEN 0 THEN 0 WHEN 10 THEN ed.EDIid ELSE ed.EDIid END as inactive,
          ed.EDIestado,ed.EDIid, Ddocumento,ed.Mcodigo,Mnombre, EDIfecha, SNnumero, SNnombre,sum(DDItotallinea) as totFact
        <cfif isdefined("Form.EPDid_DP") and Len(Trim(Form.EPDid_DP)) NEQ 0>
            , #form.EPDid_DP# as EPDid_DP
        </cfif>
    from EDocumentosI ed
        inner join Monedas m
            on ed.Mcodigo=m.Mcodigo
                and ed.Ecodigo=m.Ecodigo

        inner join SNegocios sn
            on ed.SNcodigo=sn.SNcodigo
                and ed.Ecodigo=sn.Ecodigo

        left outer join DDocumentosI dd
            on ed.EDIid=dd.EDIid
                and ed.Ecodigo=dd.Ecodigo
    where ed.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and ed.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
      
        <cfif isdefined("Form.DdocumentoF") and Len(Trim(Form.DdocumentoF)) NEQ 0>
            and upper(Ddocumento) like '%#UCase(Form.DdocumentoF)#%'
            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DdocumentoF=" & Form.DdocumentoF>
        </cfif>
        <cfif isdefined("Form.fechaF") and Len(Trim(Form.fechaF)) NEQ 0>
            and EDIfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaF)#">
            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechaF=" & Form.fechaF>
        </cfif>
        <cfif isdefined("Form.SNnumeroF") and Len(Trim(Form.SNnumeroF)) NEQ 0>
            and upper(SNnumero) like '%#UCase(Form.SNnumeroF)#%'
            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumeroF=" & Form.SNnumeroF>
            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoF=" & Form.SNcodigoF>
        </cfif>										
        <cfif isdefined("Form.EPDid_DP") and Len(Trim(Form.EPDid_DP))>												
            and ed.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid_DP#">
            and ed.EDIestado in(0,10)<!---►En Digitación, Aplicados◄◄--->
            <cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EPDid_DP=" & Form.EPDid_DP>
        <cfelse>
            and ed.EDIestado = 0 
            and ed.EPDid is null
        </cfif>
        
    group by ed.EDIestado,ed.EDIid, Ddocumento,ed.Mcodigo,Mnombre, EDIfecha, SNnumero, SNnombre
    Order by Ddocumento,EDIfecha
</cfquery>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cf_templateheader title="Compras">
	<cfinclude template="../../portlets/pNavegacion.cfm">	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Transacciones'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<cfif isdefined('form.EPDid_DP') and len(trim(form.EPDid_DP))>
                <tr><td colspan="2"><cfinclude template="encPoliza.cfm"></td></td></tr>			
            </cfif>
				<tr>
					<td>
						<cfoutput>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<form style="margin:0;" name="filtroOrden" method="post" action="EDocumentos-lista.cfm">
									<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
										<tr>
											<td align="right"><strong>Documento:</strong></td>
											<td> 
												<input name="DdocumentoF" type="text" id="desc" size="20" maxlength="20" value="<cfif isdefined("Form.DdocumentoF") and Form.DdocumentoF NEQ ''>#Form.DdocumentoF#</cfif>" onFocus="javascript:this.select();">
											</td>
											<td align="right"><strong>Fecha</strong></td>
											<td>
												<cf_sifcalendario form="filtroOrden" value="#fechaParam#" tabindex="1" name="fechaF">													
											</td>
											<td align="right"><strong>N&uacute;mero Socio</strong></td>
											<td> 
												<cf_sifsociosnegocios2 form="filtroOrden" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">												
											</td>
											<td align="center">
												<cfif isdefined('form.EPDid_DP') and len(trim(form.EPDid_DP))>
													<input type="hidden" name="EPDidFiltro" value="#form.EPDid_DP#">
												</cfif>
												<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
											</td>
										</tr>
									</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
									<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
										<cfinvokeargument name="query" 				value="#rsLista#"/> 
										<cfinvokeargument name="desplegar" 			value="Ddocumento,EDIfecha,SNnumero,SNnombre,Estado,Mnombre,totFact"/>
										<cfinvokeargument name="etiquetas" 			value="Documento,Fecha,N&uacute;mero de Socio, Nombre Socio,Estado,Moneda,Total"/>
										<cfinvokeargument name="formatos" 			value="S,D,S,S,S,S,M"/> 
										<cfinvokeargument name="align" 				value="left,left,left,left,left,left,right"/> 
										<cfinvokeargument name="ajustar" 			value="N"/> 
										<cfinvokeargument name="keys" 				value="EDIid"/>
										<cfinvokeargument name="checkboxes" 		value="S"/>
										<cfinvokeargument name="irA" 				value="EDocumentosI.cfm"/> 
										<cfinvokeargument name="formName" 			value="listaTrans"/>
										<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
										<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
										<cfinvokeargument name="botones" 			value="Nuevo,Aplicar"/>
                                        <cfinvokeargument name="inactivecol" 		value="inactive"/>
                                        <cfinvokeargument name="lineaAzul" 			value="EDIestado EQ 10"/>
									</cfinvoke> 
								</td>
							</tr>
						</table>
						</cfoutput>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
    
<!---►►Funciones de Javascrip◄◄--->
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		<cfif isdefined('form.EPDid_DP')>
			document.listaTrans.EPDID_DP.value = <cfoutput>#form.EPDid_DP#</cfoutput>;			
		</cfif>		
	}
	
	function hayAlgunoChequeado(){
		if (document.listaTrans.chk) {
			if (document.listaTrans.chk.value) {
				if (document.listaTrans.chk.checked)
					return true;
			} else {
				for (var i=0; i<document.listaTrans.chk.length; i++) {
					if (document.listaTrans.chk[i].checked) return true;
				}
			}
		}
		alert("Debe seleccionar al menos una transacción !");
		return false;
	}

	function funcAplicar(){
		if (hayAlgunoChequeado()) {
			if (confirm('Desea aplicar las transacciones marcadas')){
				document.listaTrans.action = "EDocumentosI-sql.cfm";
				return true;
			}else{
				return false;
			}
		}
		return false;
	}
	
	<cfif isdefined("url.ImprimirTG") and isdefined("url.ListaTG") and len(trim(url.ListaTG)) gt 0>
		<cfoutput>
				var popUpWinTG = 0;
				function popUpWindowTG(URLStr, left, top, width, height){
					if(popUpWinTG){
						if(!popUpWinTG.closed) popUpWinTG.close();
					}
					popUpWinTG = open(URLStr, 'popUpWinTG', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
	
				function imprimeTrackingsGenerados() {
					var params ="";		
					popUpWindowTG("/cfmx/sif/cm/operacion/imprimeTrackingsGenerados.cfm?ListaTG=#url.ListaTG#" + params,250,200,650,400);
				}
				imprimeTrackingsGenerados();
		</cfoutput>
	</cfif>
</script>