<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cliente" default="Cliente" returnvariable="LB_Cliente" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_FolioFactura" default="Folio Factura" returnvariable="LB_FolioFactura" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Transaccion" default="Transaccion" returnvariable="LB_Transaccion" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="ListaFacturasImpresas.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Socio" default="Socio" returnvariable="LB_Socio" xmlfile="ListaFacturasImpresas.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="Tit_ImprFAct" default="Impresión de Facturas" returnvariable="Tit_ImprFAct" xmlfile="ListaFacturasImpresas.xml"/>

<cfsetting enablecfoutputonly="yes">

<cfparam name="varControlFiltro" default="true">

<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
	<cfset form.pageNum_lista = url.pageNum_lista>
</cfif>
<cfif isDefined("url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfset Form.SNcodigo = url.SNcodigo>
</cfif>
<!---<cfif isdefined("url.OIdocumento") and not isdefined("Form.OIdocumento")>
    <cfset Form.OIdocumento = url.OIdocumento>
</cfif>
<cfif isdefined("url.DdocumentoREF") and not isdefined("form.DdocumentoREF")>
    <cfset form.DdocumentoREF = url.DdocumentoREF> 
</cfif>--->
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
    	select Pvalor as periodo from Parametros
		where Pcodigo=50
        and Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfquery name="rsMes" datasource="#session.dsn#">
    	select Pvalor as mes from Parametros
		where Pcodigo=60
        and Ecodigo = #session.Ecodigo#
    </cfquery>
<cfparam name="Navegacion" default="">
<cfparam name="Form.SNnumero" default="">
	<cfparam name="Form.SNcodigo" default="">
	<cfparam name="filtrosql" default="">
<cfset filtrolista ="a.Ecodigo = #Session.Ecodigo#  and OIEstado in('I','T') ">
<cfset filtrolista = filtrolista & " and year(a.OIfecha) = #rsPeriodo.periodo# ">
<!---<cfset filtrolista = filtrolista & " and month(a.OIfecha)= #rsMes.mes#">--->
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
	<cfif isdefined("form.DdocumentoREF") and len(trim("form.DdocumentoREF"))>
    	<cfset Navegacion = Navegacion & "folioFactura=#Form.DdocumentoREF#&">
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
 
	<cfif isdefined("Form.foliofactura") and Trim(Form.foliofactura) NEQ "-1" and len(Trim(Form.foliofactura))>
		
    	<cfset filtrolista = filtrolista & " and  f.DdocumentoREF = '#Form.foliofactura#'">
	    <cfset Navegacion = "DdocumentoREF='#Form.foliofactura#'">
	</cfif>
<cfelse>
	<cfset form.SNcodigo = "">
</cfif>


<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Facturación">
	<!---<cfinclude template="../../portlets/pNavegacion.cfm">--->
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Tit_ImprFAct#'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td></td>
		</tr>
		<tr> 
			<td> 
            	<cfoutput>
				<form style="margin: 0" name="form1" action="ListaFacturasImpresas.cfm" method="post">
					<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						<tr>
                            <td width="50%"><strong>#LB_Cliente#</strong></td>
							<td width="46%"><strong>#LB_FolioFactura#</strong></td>
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
                            	<input type="text" name="folioFactura" id="folioFactura" maxlength="20" size="40" tabindex="2" <cfif isdefined("form.folioFactura") and len(trim(form.folioFactura))>  value="#form.folioFactura#" <cfelse> value="" </cfif>> 
                            </td>
                            <td>&nbsp;</td>
                       </tr>
                        <tr> 
							<td>&nbsp;</td>
						</tr>
                        
						
                       <tr>
							<td>&nbsp;</td>
                       		<td>&nbsp;</td>
                            <td>
                            	<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
                            </td>
						</tr>
					</table>
				</form>
                </cfoutput>
			<!--- FORM PARA FILTRO DE SOCIOS DE NEGOCIOS --->
			</td>
		  </tr>
		  <tr> 
			<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
						tabla="FAEOrdenImpresion a
								inner join Monedas m
									on m.Mcodigo = a.Mcodigo
                                    and m.Ecodigo = a.Ecodigo
                                inner join SNegocios s
                                	on s.Ecodigo = a.Ecodigo
                                    and s.SNcodigo = a.SNcodigo
                                 inner JOIN FAPreFacturaE f
								    on a.OImpresionID = f.oidocumento
								    and a.Ecodigo = f.Ecodigo" 
						columnas="distinct a.OImpresionID,
                        		a.OImpresionNumero, 
								a.OIdocumento, 
                                a.OItotal,
								a.CCTcodigo, 
                                m.Miso4217 as Mnombre,
                                s.SNnombre, 
								f.DdocumentoREF,
								'&nbsp;&nbsp;<i class=''fa fa-file-pdf-o'' title=''PDF'' onclick=''downloadPDF('+ cast(a.OImpresionID as varchar)  + ');'' style=''cursor:pointer;''></i>&nbsp;&nbsp;
								<i class=''fa fa-file-code-o'' title=''XML'' onclick=''downloadXML('+ cast(a.OImpresionID as varchar)  + ');'' style=''cursor:pointer;''></i>' as Botones"
						desplegar="DdocumentoREF,  CCTcodigo, Mnombre,  OItotal, SNnombre, Botones"
						etiquetas="#LB_FolioFactura#,  #LB_Transaccion#, #LB_Moneda#, #LB_Total#, #LB_Socio#, "
						formatos="S,S,S,M,S,S"
						filtro= "#filtrolista# order by SNnombre"
						cortes="SNnombre" 
						align="left, left, left,left, right, left, center"
						checkboxes="N"
						showlink="false"
						ira="downloadFile.cfm" 
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
    function downloadPDF(OImpresionID) {
		window.location.href = 'downloadFile.cfm?OImpresionID=' + OImpresionID
		    + "&fileType=PDF";
	}

	function downloadXML(OImpresionID) {
		window.location.href = 'downloadFile.cfm?OImpresionID=' + OImpresionID
		    + "&fileType=XML";
	}
</script>