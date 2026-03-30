<cfsetting enablecfoutputonly="yes">

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
    select 	a.CCTcodigo, a.CCTdescripcion
    from CCTransacciones a
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and CCTestimacion = 0
    and CCTtranneteo = 0
    and CCTpago = 0
    and CCTvencim = -1 or (CCTcodigo = 'FC' and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
</cfquery>

<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
	<cfset form.pageNum_lista = url.pageNum_lista>
</cfif>
<cfif isDefined("url.sncodigo") and not isdefined("Form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset Form.Ddocumento = url.Ddocumento>
</cfif>
<cfif isdefined("url.McodigoOri") and not isdefined("form.McodigoOri")>
	<cfset form.McodigoOri = url.McodigoOri> 
</cfif>
<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>
<cfif isdefined("url.TESSPfechaPago_I") and not isdefined("form.TESSPfechaPago_I")>
	<cfset form.TESSPfechaPago_I = url.TESSPfechaPago_I>
</cfif>
<cfif isdefined("url.TESSPfechaPagoV_I") and not isdefined("form.TESSPfechaPagoV_I")>
	<cfset form.TESSPfechaPagoV_I = url.TESSPfechaPagoV_I>
</cfif>
<cfif isdefined("url.TESSPfechaPago_F") and not isdefined("form.TESSPfechaPago_F")>
	<cfset form.TESSPfechaPago_F = url.TESSPfechaPago_F>
</cfif>
<cfif isdefined("url.TESSPfechaPagoV_F") and not isdefined("form.TESSPfechaPagoV_F")>
	<cfset form.TESSPfechaPagoV_F = url.TESSPfechaPagoV_F>
</cfif>

<cfparam name="Navegacion" default="">
<!--- NAVEGACION --->
<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset Navegacion = Navegacion & "SNcodigo=#Form.SNcodigo#&">
</cfif>
<cfif isdefined("form.Ddocumento") and len(trim("form.Ddocumento"))>
	<cfset Navegacion = Navegacion & "Ddocumento=#Form.Ddocumento#&">
</cfif>
<cfif isdefined("form.McodigoOri") and len(trim("form.McodigoOri"))>
	<cfset Navegacion = Navegacion & "McodigoOri=#Form.McodigoOri#&">
</cfif>
<cfif isdefined("form.CCTcodigo") and len(trim("form.CCTcodigo"))>
	<cfset Navegacion = Navegacion & "CCTcodigo=#Form.CCTcodigo#&">
</cfif>
<cfif isdefined("form.TESSPfechaPago_I") and len(trim("form.TESSPfechaPago_I"))>
	<cfset Navegacion = Navegacion & "TESSPfechaPago_I=#Form.TESSPfechaPago_I#&">
</cfif>
<cfif isdefined("form.TESSPfechaPagoV_I") and len(trim("form.TESSPfechaPagoV_I"))>
	<cfset Navegacion = Navegacion & "TESSPfechaPagoV_I=#Form.TESSPfechaPagoV_I#&">
</cfif>
<cfif isdefined("form.TESSPfechaPago_F") and len(trim("form.TESSPfechaPago_F"))>
	<cfset Navegacion = Navegacion & "TESSPfechaPago_F=#Form.TESSPfechaPago_F#&">
</cfif>
<cfif isdefined("form.TESSPfechaPagoV_F") and len(trim("form.TESSPfechaPagoV_F"))>
	<cfset Navegacion = Navegacion & "TESSPfechaPagoV_F=#Form.TESSPfechaPagoV_F#&">
</cfif>

<cfset filtrolista ="a.Ecodigo = #Session.Ecodigo#">

<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">

<!--- Filtros --->
<!--- Socio --->
<cfif isdefined("Form.SNcodigo") and Trim(Form.SNcodigo) NEQ "-1" and len(Trim(Form.SNcodigo))>
	<cfset filtrolista = filtrolista & " and  a.SNcodigo = #Form.SNcodigo#">
</cfif>
<!--- Documento --->
<cfif isdefined("Form.Ddocumento") and len(Trim(Form.Ddocumento))>
	<cfset filtrolista = filtrolista & " and  a.Ddocumento like '%#Form.Ddocumento#%'">
</cfif>
<!--- Moneda --->
<cfif isdefined("Form.McodigoOri") and Trim(Form.McodigoOri) NEQ "-1" and len(Trim(Form.McodigoOri))>
	<cfset filtrolista = filtrolista & " and  a.Mcodigo = '#Form.McodigoOri#'">
</cfif>
<!--- Transaccion CxC --->
<cfif isdefined("Form.CCTcodigo") and Trim(Form.CCTcodigo) NEQ "-1" and len(Trim(Form.CCTcodigo))>
	<cfset filtrolista = filtrolista & " and  a.CCTcodigo = '#Form.CCTcodigo#'">
</cfif>
<cfset filtrolista = filtrolista & " and a.Danulado = 0">

<cfset filtroL = " and cc.CCTvencim = -1 or (cc.CCTcodigo = 'FC' and #filtrolista#)">

<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacion.cfm">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelaci&oacute;n de Documentos'>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
        	<td></td>
        </tr>
        <tr> 
            <td> 
				<cfoutput>
                	<form style="margin: 0" name="form1" action="ListaCancDocumento.cfm" method="post">
                		<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
                			<tr> 
                                <td width="50%"><strong>Documento</strong></td>
                                <td width="46%"><strong>Transaccion</strong></td>
                                <td width="4%">&nbsp;</td>
               				</tr>
                			<tr> 
                				<td>
                					<input type="text" name="Ddocumento" id="Ddocumento" maxlength="20" size="40" tabindex="1" <cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>  value="#form.Ddocumento#" <cfelse> value="" </cfif>> 
                				</td>
                				<td> 
                					<select name="CCTcodigo" tabindex="1">
                					<option value="-1" <cfif isdefined('form.CCTcodigo') and form.CCTcodigo EQ '-1'> selected</cfif>>-- Todas --</option>
                					<cfloop query="rsTransacciones">
                						<option value="#rsTransacciones.CCTcodigo#" <cfif isdefined('form.CCTcodigo') and rsTransacciones.CCTcodigo EQ form.CCTcodigo> selected </cfif>>
                						#rsTransacciones.CCTcodigo# - #rsTransacciones.CCTdescripcion#
                						</option>
                					</cfloop> 
                					</select>
                				</td>
                				<td>&nbsp;</td>
            				</tr>
            			    <tr> 
                                <td width="50%"><strong>Cliente</strong></td>
                                <td width="46%"><strong>Moneda</strong></td>
                                <td width="4%">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td>
									<cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo))>
                                    	<cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C"  size="55" idquery="#form.SNcodigo#">
                                    <cfelse>
                                    	<cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C" size="55" frame="frame2">
                                    </cfif>
                                </td>
                                <td nowrap valign="middle" colspan="2">
                                    <cfquery name="rsMonedas" datasource="#session.DSN#">
                                        select Mcodigo, Mnombre
                                          from Monedas m 
                                          where m.Ecodigo = #session.Ecodigo#
                                    </cfquery>
                                    
                                    <select name="McodigoOri" tabindex="1">
                                        <option value="">(Todas las monedas)</option>
                                        <cfloop query="rsMonedas">
                                            <option value="#Mcodigo#" <cfif isdefined('form.McodigoOri') and len(trim(form.McodigoOri)) and form.McodigoOri EQ Mcodigo>selected</cfif>>#Mnombre#</option>
                                        </cfloop>
                                    </select>					
                                </td>
                            </tr>
                            <tr>
                            	<td nowrap align="left" valign="middle" colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                        	<td nowrap align="left" valign="middle"><strong>Fecha Documento Desde:</strong></td>
                                            <td nowrap valign="middle">
                                                <cf_sifcalendario form="form1" name="TESSPfechaPago_I" tabindex="1">
                                            </td>
                                            <td nowrap align="left" valign="middle"><strong>&nbsp;Hasta:</strong></td>
                                            <td nowrap valign="middle">
                                                <cf_sifcalendario form="form1" name="TESSPfechaPago_F" tabindex="1">
                                            </td>
                                            <td nowrap align="left" valign="middle" width="7%">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                            <td nowrap align="left" valign="middle"><strong>Fecha Vencimiento Desde:</strong></td>
                                            <td nowrap valign="middle">
                                                <cf_sifcalendario form="form1" name="TESSPfechaPagoV_I" tabindex="1">
                                            </td>
                                            <td nowrap align="left" valign="middle"><strong>&nbsp;Hasta:</strong></td>
                                            <td nowrap valign="middle">
                                                <cf_sifcalendario form="form1" name="TESSPfechaPagoV_F" tabindex="1">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                	<input type="submit" name="Filtrar" value="Filtrar">
                                </td>
                            </tr>
            			</table>
            		</form>
            	</cfoutput>
       	 	<!--- FORM PARA FILTRO DE SOCIOS DE NEGOCIOS --->
        	</td>
        </tr>
        <tr> 
            <cfflush interval="64">
            <td>
                <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
                tabla="HDocumentos a
                       inner join Monedas m
                        on m.Mcodigo = a.Mcodigo
                        and m.Ecodigo = a.Ecodigo
                       inner join SNegocios s
                        on s.Ecodigo = a.Ecodigo
                        and s.SNcodigo = a.SNcodigo
                       inner join CCTransacciones cc
                        on cc.CCTcodigo = a.CCTcodigo
                        and cc.Ecodigo = a.Ecodigo" 
                columnas="distinct a.Ddocumento as DdocumentoREF,
                          a.CCTcodigo as CCTcodigoREF, 
                          m.Miso4217 as Mnombre,
                          s.SNnombre, 
                          a.Dtotal,a.HDid,s.SNcodigo"
                desplegar="SNnombre, DdocumentoREF, CCTcodigoREF, Mnombre,  Dtotal"
                etiquetas="Socio,Documento, Transaccion, Moneda, Total"
                formatos="S,S,S,S,M"
                filtro= "#filtrolista##filtroL# order by SNnombre, CCTcodigoREF"
                cortes="SNnombre" 
                align="left, left, left, right, right"
                checkboxes="S"
                ira="ProcCancDocumento.cfm" 
                keys="DdocumentoREF,CCTcodigoREF,HDid"
                MaxRows="#Registros#"
                Navegacion="#Navegacion#"
                botones = "Cancelar">
                </cfinvoke> 
            </td>
        </tr>
    </table>
<cf_web_portlet_end>
<cf_templatefooter>