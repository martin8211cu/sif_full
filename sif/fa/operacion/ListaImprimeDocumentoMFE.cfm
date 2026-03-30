<cfsetting enablecfoutputonly="yes">

<cfparam name="varControlFiltro" default="true">
<!--- 
	Creado por Luis A. Bolaños Gómez
		Fecha: 03/09/2008
		Motivo: Pantalla de Aplicacion de Cotizaciones
--->

<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
	<cfset form.pageNum_lista = url.pageNum_lista>
</cfif>
<cfif isDefined("url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.OIdocumento") and not isdefined("Form.OIdocumento")>
    <cfset Form.OIdocumento = url.OIdocumento>
</cfif>
<cfif isdefined("url.PFDocumento") and not isdefined("form.PFDocumento")>
    <cfset form.PFDocumento = url.PFDocumento> 
</cfif>

<cfparam name="Navegacion" default="">
<cfparam name="Form.SNnumero" default="">
	<cfparam name="Form.SNcodigo" default="">
	<cfparam name="filtrosql" default="">
<cfset filtrolista ="a.Ecodigo = #Session.Ecodigo# and OIEstado in('P','I','R')">
<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">

<cfif varControlFiltro>
	<!--- NAVEGACION --->
	<cfif isdefined("Form.SNcodigo") and len(trim(form.SNcodigo))>
		<cfset Navegacion = Navegacion & "SNcodigo=#Form.SNcodigo#&">
	</cfif>	
	<cfif isdefined("form.OIdocumento") and len(trim("form.OIdocumento"))>
    	<cfset Navegacion = Navegacion & "OIdocumento=#Form.OIdocumento#&">
	</cfif>
	<cfif isdefined("form.PFDocumento") and len(trim("form.PFDocumento"))>
    	<cfset Navegacion = Navegacion & "PFDocumento=#Form.PFDocumento#&">
	</cfif>

	<cfif isdefined("Form.SNumero") and Trim(Form.SNumero) NEQ "-1" and Trim(Form.SNumero) NEQ "">
		<!---<cfabort showerror="MIRA">--->
	</cfif>

	<!--- Filtros --->
	<!---Socio--->
	<cfif isdefined("Form.SNcodigo") and Trim(Form.SNcodigo) NEQ "-1" and len(Trim(Form.SNcodigo))>
		<cfset filtrolista = filtrolista & " and  a.SNcodigo = #Form.SNcodigo#">
	    <cfset Navegacion = "SNcodigo=#Form.SNcodigo#">
	</cfif>
	<!--- Orden de Impresion --->
	<cfif isdefined("Form.OIdocumento") and len(Trim(Form.OIdocumento))>
	    <cfset filtrolista = filtrolista & " and  a.OIdocumento like '%#Form.OIdocumento#%'">
    	<cfset Navegacion = "OIdocumento='#Form.OIdocumento#'">
	</cfif>
	<!--- PreFactura --->
	<cfif isdefined("Form.PFDocumento") and Trim(Form.PFDocumento) NEQ "-1" and len(Trim(Form.PFDocumento))>
		<cfset filtrosql = "b.PFDocumento = #Form.PFDocumento#">
    	<cfset filtrolista = filtrolista & " and  b.PFDocumento = '#Form.PFDocumento#'">
	    <cfset Navegacion = "PFDocumento='#Form.PFDocumento#'">
	</cfif>
<cfelse>
	<cfset form.SNcodigo = "">
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
				<form style="margin: 0" name="form1" action="ListaImprimeDocumentoMFE.cfm" method="post">
					<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						<tr> 
							<td width="50%"><strong>Orden de Impresión</strong></td>
							<td width="46%"><strong>Pre-Factrura</strong></td>
                            <td width="4%">&nbsp;</td>
						</tr>
                        <tr> 
							<td>
					    		<input type="text" name="OIdocumento" id="OIdocumento" maxlength="20" size="40" tabindex="1" <cfif isdefined("form.OIdocumento") and len(trim(form.OIdocumento))>  value="#form.OIdocumento#" <cfelse> value="" </cfif>> 
							</td>
                            <td> 
                            	<input type="text" name="PFDocumento" id="PFDocumento" maxlength="20" size="40" tabindex="2" <cfif isdefined("form.PFdocumento") and len(trim(form.PFDocumento))>  value="#form.PFDocumento#" <cfelse> value="" </cfif>> 
                            </td>
                            <td>&nbsp;</td>
                       </tr>
                        <tr> 
							<td>&nbsp;</td>
						</tr>
                        <tr> 
							<td ><strong>Cliente</strong></td>
						</tr>
						<tr> 
							<td>
						    	<cfif isdefined('form.SNcodigo') and LEN(trim(form.SNcodigo))>
                                	<cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C"  size="55" idquery="#form.SNcodigo#">
                			    <cfelse>
				                    <cf_sifsociosnegocios2 tabindex="3" SNtiposocio="C" size="55" frame="frame2">
                				</cfif>
							</td>
<!---                            <td> 
                            	<input type="text" name="Cotizacion" id="Cotizacion" maxlength="15" size="19" 
								tabindex="3" value=""> 
                            </td>--->
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
						tabla="FAEOrdenImpresion a
								inner join FAPreFacturaE b
									on b.DdocumentoREF = a.OIdocumento
									and b.CCTcodigoREF = a.CCTcodigo
                                    and b.TipoDocumentoREF = 1
                                    and b.Ecodigo = a.Ecodigo
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
                                    and m.Ecodigo = a.Ecodigo
                                inner join SNegocios s
                                	on s.Ecodigo = a.Ecodigo
                                    and s.SNcodigo = a.SNcodigo" 
						columnas="distinct a.OImpresionID,
                        		a.OImpresionNumero, 
								a.OIdocumento, 
								a.CCTcodigo, 
                                m.Miso4217 as Mnombre,
                                s.SNnombre, 
								a.OItotal"
						desplegar="OImpresionNumero, OIdocumento, CCTcodigo, Mnombre,  OItotal, SNnombre"
						etiquetas="Numero Orden, Orden Impresion, Transaccion, Moneda, Total, Socio"
						formatos="I,S,S,S,M,S"
						filtro= "#filtrolista# order by SNnombre"
						cortes="SNnombre" 
						align="left, left, left,left, right, right"
						checkboxes="N"
						ira="ProcImprimeDocumentoMFE.cfm" 
						keys="OImpresionID"
						MaxRows="#Registros#"
                        Navegacion="#Navegacion#">
					</cfinvoke> 
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">

</script>