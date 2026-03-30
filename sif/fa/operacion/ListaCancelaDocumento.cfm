<cfsetting enablecfoutputonly="yes">
<!--- 
	Creado por Luis A. Bolaños Gómez
		Fecha: 03/09/2008
		Motivo: Pantalla de Aplicacion de Cotizaciones
--->

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, a.CCTdescripcion
	from CCTransacciones a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and CCTestimacion = 0
    and CCTtranneteo = 0
    and CCTpago = 0
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
<cfif isdefined("url.PFDocumento") and not isdefined("form.PFDocumento")>
    <cfset form.PFDocumento = url.PFDocumento> 
</cfif>
<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
    <cfset form.CCTcodigo = url.CCTcodigo>
</cfif>

<cfparam name="Navegacion" default="">
<!--- NAVEGACION --->
<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset Navegacion = Navegacion & "SNcodigo=#Form.SNcodigo#&">
</cfif>
<cfif isdefined("form.Ddocumento") and len(trim("form.Ddocumento"))>
    <cfset Navegacion = Navegacion & "Ddocumento=#Form.Ddocumento#&">
</cfif>
<cfif isdefined("form.PFDocumento") and len(trim("form.PFDocumento"))>
    <cfset Navegacion = Navegacion & "PFDocumento=#Form.PFDocumento#&">
</cfif>
<cfif isdefined("form.CCTcodigo") and len(trim("form.CCTcodigo"))>
    <cfset Navegacion = Navegacion & "CCTcodigo=#Form.CCTcodigo#&">
</cfif>

<cfset filtrolista ="a.Ecodigo = #Session.Ecodigo#">
<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">

<!--- Filtros --->
<!---Socio--->
<cfif isdefined("Form.SNcodigo") and Trim(Form.SNcodigo) NEQ "-1" and len(Trim(Form.SNcodigo))>
	<cfset filtrolista = filtrolista & " and  a.SNcodigo = #Form.SNcodigo#">
</cfif>
<!--- Orden de Impresion --->
<cfif isdefined("Form.Ddocumento") and len(Trim(Form.Ddocumento))>
    <cfset filtrolista = filtrolista & " and  a.Ddocumento like '%#Form.Ddocumento#%'">
</cfif>
<!--- PreFactura --->
<cfif isdefined("Form.PFDocumento") and Trim(Form.PFDocumento) NEQ "-1" and len(Trim(Form.PFDocumento))>
    <cfset filtrolista = filtrolista & " and  b.PFDocumento = '#Form.PFDocumento#'">
</cfif>
<!--- Transaccion CxC --->
<cfif isdefined("Form.CCTcodigo") and Trim(Form.CCTcodigo) NEQ "-1" and len(Trim(Form.CCTcodigo))>
    <cfset filtrolista = filtrolista & " and  a.CCTcodigo = '#Form.CCTcodigo#'">
</cfif>



<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Facturación">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Impresión de Documentos'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td></td>
		</tr>
		<tr> 
			<td> 
            	<cfoutput>
				<form style="margin: 0" name="form1" action="ListaCancelaDocumento.cfm" method="post">
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
							<td>&nbsp;</td>
						</tr>
                        <tr> 
							<td width="50%"><strong>Cliente</strong></td>
							<td width="46%"><strong>Pre-Factrura</strong></td>
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
                            <td> 
                            	<input type="text" name="PFDocumento" id="PFDocumento" maxlength="20" size="40" tabindex="2" <cfif isdefined("form.PFdocumento") and len(trim(form.PFDocumento))>  value="#form.PFDocumento#" <cfelse> value="" </cfif>> 
                            </td>
                            <td>&nbsp;</td>
                       </tr>
                       <tr>
							<td>&nbsp;</td>
                       		<td>&nbsp;</td>
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
						tabla="Documentos a
								inner join FAPreFacturaE b
									on b.DdocumentoREF = a.Ddocumento
									and b.CCTcodigoREF = a.CCTcodigo
                                    and b.TipoDocumentoREF = 2
                                    and b.Ecodigo = a.Ecodigo
                                    and a.Dsaldo = a.Dtotal
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
                                    and m.Ecodigo = a.Ecodigo
                                inner join SNegocios s
                                	on s.Ecodigo = a.Ecodigo
                                    and s.SNcodigo = a.SNcodigo" 
						columnas="distinct a.Ddocumento as DdocumentoREF,
								a.CCTcodigo as CCTcodigoREF, 
                                m.Miso4217 as Mnombre,
                                s.SNnombre, 
								a.Dtotal"
						desplegar="SNnombre, DdocumentoREF, CCTcodigoREF, Mnombre,  Dtotal"
						etiquetas="Socio,Documento, Transaccion, Moneda, Total"
						formatos="S,S,S,S,M"
						filtro= "#filtrolista#"
						cortes="SNnombre" 
						align="left, left, left, right, right"
						checkboxes="S"
						ira="ProcCancelaDocumento.cfm" 
						keys="DdocumentoREF,CCTcodigoREF"
						MaxRows="#Registros#"
                        Navegacion="#Navegacion#"
                        botones = "Cancelar">
					</cfinvoke> 
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">

</script>