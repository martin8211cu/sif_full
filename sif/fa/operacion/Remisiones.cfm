<cfset sqlRemision = "Remisiones-SQL.cfm">

<cfif not isdefined("form.SNcodigo") and isdefined ("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif not isdefined("form.IDdocumento") and isdefined ("url.IDdocumento") and len(trim(url.IDdocumento))>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<cfif not isdefined("form.Mcodigo") and isdefined ("url.Mcodigo") and len(trim(url.Mcodigo))>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>

<style type = "text/css">
    .navegbar tr, a, td {
        color: #656565;
    }


    input[type=text], select {
        height: 1.5em;
        margin: .1em;
        font-size: 13px;
        line-height: 1.428571429;
        color: #555;
        vertical-align: middle;
        background-color: #fff;
        background-image: none;
        border: 1px solid #ccc;
        border-radius: 4px;
        -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
        box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
        -webkit-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    }
</style>


<cfif isdefined ("form.SNcodigo") and len(trim(form.SNcodigo))>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    <tr>
     		<td>
				<!---  Filtro  --->							
				<cfif isdefined("url.fnumero") and len(url.fnumero) and not isdefined("form.fnumero")><cfset form.fnumero = url.fnumero></cfif>
				<cfif isdefined("url.fObservaciones") and len(url.fObservaciones) and not isdefined("form.fObservaciones")><cfset form.fObservaciones = url.fObservaciones></cfif>
				<cfif isdefined("url.fEOfecha") and len(url.fEOfecha) and not isdefined("form.fEOfecha")><cfset form.fEOfecha = url.fEOfecha></cfif>
				<cfif isdefined("url.SNcodigoF") and len(url.SNcodigoF) and not isdefined("form.SNcodigoF")><cfset form.SNcodigoF = url.SNcodigoF></cfif>

				<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>						
					<cfoutput>
                        <!--- FORM DEL FILTRO DE REMISIONES ---->
						<form style="margin: 0" action="Remisiones.cfm" name="fsolicitud" id="fsolicitud" method="post">
							<input type="hidden" value="#form.IDdocumento#" name="IDdocumento">
							<input type="hidden" value="#form.SNcodigo#" name="SNcodigo">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
							  <tr> 
								<td class="fileLabel" nowrap width="8%" align="right"><label for="fnumero">Numero:</label></td>
								<td nowrap width="31%">
									<input type="text" 
										name="fnumero" size="30" maxlength="20" value="<cfif isdefined('form.fnumero')>#form.fnumero#</cfif>" 
                                        style="text-transform: uppercase; text-align: right;" tabindex="1">
								</td>
								<td class="fileLabel" nowrap width="9%" align="right">Descripci&oacute;n:</td>
								<td nowrap width="25%"><input type="text" name="fObservaciones" size="40" maxlength="100" value="<cfif isdefined('form.fObservaciones')>#form.fObservaciones#</cfif>" style="text-transform: uppercase;" tabindex="1">
								</td>
								<td width="27%" rowspan="2" align="center" valign="middle"><input type="submit" name="btnFiltro" class="btnFiltrar" value="Filtrar"></td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap width="10%">Proveedor:</td>
								<td nowrap width="10%">
									<cfset valSNcodF = ''>
									<cfif isdefined('form.SNcodigoF') and Len(Trim(form.SNcodigoF))>
									  <cfset valSNcodF = form.SNcodigoF>
									</cfif>
									<cf_sifsociosnegocios2 form="fsolicitud" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1" tabindex="1">
								</td>
								<td class="fileLabel" align="right" nowrap>Fecha:</td>
								<td nowrap>
									<cfif isdefined('form.fEDfecha') and Len(Trim(form.fEDfecha))>
										<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEDfecha" value="#form.fEDfecha#" tabindex="1">
									<cfelse>
										<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEDfecha" value="" tabindex="1">
									</cfif>	
								</td>
							  </tr>
							</table>
                            <input type="hidden" name = "statusRM" value = "<cfif isdefined('form.statusRM')>#form.statusRM#</cfif>"/>
						</form>
					</cfoutput>
				<!---  /Filtro  --->
				<cfset navegacion = "">
				<cfif isdefined("form.fnumero") and len(trim(form.fnumero)) >
					<cfset navegacion = navegacion & "&fnumero=#form.fnumero#">
				</cfif>
				<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
					<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
				</cfif>
				<cfif isdefined("Form.fEDfecha") and len(trim(form.fEDfecha))>
					<cfset navegacion = navegacion & "&fEDfecha=#form.fEDfecha#">
				</cfif>
				<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
					<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
				</cfif>
				<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) >
					<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
				</cfif>
				<cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento)) >
					<cfset navegacion = navegacion & "&IDdocumento=#form.IDdocumento#">
				</cfif>	
                <cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo)) >
					<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
				</cfif>					
			
				<cfquery name="rsLista" datasource="#session.DSN#">
					select 
                        a.EOidorden, a.Ecodigo, a.EOnumero, a.SNcodigo, #form.IDdocumento# as IDdocumentoPrefactura,
						a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo, 
						a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot, 
						a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo, 
						a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo, 
						a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado, 
						b.Mnombre, 
						(( select min(c.CMCnombre) from CMCompradores c where c.CMCid = a.CMCid )) as CMCnombre, 
						(( select min(d.Rdescripcion) from Retenciones d where a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo)) as Rdescripcion ,
						e.SNnombre
						from ERemisionesFA a
    					inner join Monedas b 
						on a.Mcodigo = b.Mcodigo 
						inner join SNegocios e 
						on a.Ecodigo  = e.Ecodigo 
					    and a.SNcodigo = e.SNcodigo 
						where a.Ecodigo = #session.Ecodigo#
						and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
						and a.EOestado = 10
					    /*and ( 
							(select count(*)  
									from FAPreFacturaD g  
									where g.DOlinea = d.DOlinea) > 0
						)*/
						and (select count(1) from DPedido g 
										where g.EOidorden = a.EOidorden)
										>
							  			(select count(1)  
										from DPedido g 
											inner join FAPreFacturaD aa 
											on aa.DOlinea = g.DOlinea 
										where g.EOidorden = a.EOidorden )
				        <cfif isdefined("form.fnumero") and len(trim(form.fnumero))>
							and upper(a.EOnumero) like  upper('%#form.fnumero#%')
						</cfif>

						<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones))>
							and upper(a.Observaciones) like  upper('%#form.fObservaciones#%')
						</cfif>
								
						<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
							and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigoF#">
						</cfif>
                                
                        <cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo)) >
							and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
						</cfif>
                                
						<cfif isdefined("Form.fEDfecha") and len(trim(Form.fEDfecha)) >
							and a.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEDfecha)#">
						</cfif>
						order by a.Observaciones, a.EOidorden
				</cfquery>
			
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#rsLista#"/>
					<cfinvokeargument name="desplegar" 			value="EONumero, Observaciones, SNnombre, EOfecha, Mnombre, EOtotal"/> 
					<cfinvokeargument name="etiquetas" 			value="N&uacute;mero, Descripci&oacute;n, Proveedor, Fecha, Moneda, Total"/> 
					<cfinvokeargument name="formatos" 			value="V,V,V,D,V,M"/> 
					<cfinvokeargument name="align" 				value="left,left,left,center,left,right"/> 
					<cfinvokeargument name="maxrows" 			value="50"/>
					<cfinvokeargument name="ajustar" 			value="S"/>
                    <cfif isdefined ("rsLista") and rsLista.recordcount GT 0>
                        <cfinvokeargument name="botones" value="Agregar"/>
                    </cfif>
                    <cfinvokeargument name="irA" value="#sqlRemision#">
                    <cfinvokeargument name="formName" value="form3">
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="checkboxes" value="S"/>
                    <cfinvokeargument name="checkall" value="S"/>
					<cfinvokeargument name="keys" 				value="IDDocumentoPrefactura, EOidorden"/>
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="funcion" value="ProcesarRemision">
                    <cfinvokeargument name="fparams" value="IDDocumentoPrefactura">
					<!---<cfinvokeargument name="inactivecol" 		value="marca"/>--->
					<cfinvokeargument name="usaAjax" 			value="true"/>
					<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
				</cfinvoke>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
 		<tr><td>&nbsp;</td></tr>
	</table>
    <script language='javascript' type='text/JavaScript' >
        <!--//
            function ProcesarRemision(IDDocumentoPrefactura){
                return false;
            }
        //-->
    </script>
</cfif>

