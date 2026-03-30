<cfsetting enablecfoutputonly="yes">
<!--- 
	Creado por Luis A. Bolaños Gómez
		Fecha: 03/09/2008
		Motivo: Pantalla de Aplicacion de Cotizaciones
--->

<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>
<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">

<cfquery name="rsDocumento" datasource="#session.DSN#">
	select a.Ddocumento,a.CCTcodigo,s.SNnombre,
    	a.Dtotal,a.Mcodigo,a.Dtipocambio,o.Odescripcion
    from Documentos a
		inner join Monedas m
		on m.Mcodigo = a.Mcodigo
        and m.Ecodigo = a.Ecodigo
    	inner join SNegocios s
        on s.Ecodigo = a.Ecodigo
        and s.SNcodigo = a.SNcodigo
        inner join Oficinas o
        on a.Ecodigo = o.Ecodigo
        and a.Ocodigo = o.Ocodigo
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoREF#">
    and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoREF#">
</cfquery>

<cfquery name="rsLista" datasource="#session.DSN#">
	select a.Ddocumento,a.CCTcodigo,b.PFTcodigo,b.PFDocumento,
    	b.Descuento,b.Impuesto,b.Total
    from Documentos a
		inner join FAPreFacturaE b
		on b.DdocumentoREF = a.Ddocumento
		and b.CCTcodigoREF = a.CCTcodigo
        and b.TipoDocumentoREF = 2
        and b.Ecodigo = a.Ecodigo
        and a.Dsaldo = a.Dtotal
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and b.DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoREF#">
    and b.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoREF#">
</cfquery>

<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Facturación">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelación de Documentos'>
<cfoutput>
	<form name="form1" action="ProcCancelaDocumento.cfm" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="AreaFiltro">
			  <td align="center">
          		<strong>
	            	<font style="font-size:18px">Documento: #rsDocumento.Ddocumento# </font>
    	        </strong>
        	  </td>
			</tr>
			<tr> 
        		<td  align="center" nowrap="nowrap" bgcolor="00CCFF">
            		<strong> 
                		<font style="font-size:17px"> Pre-Facturas Relacionadas  </font>
	                </strong>
    	    	</td>
			</tr>
	</form>       
	        <tr> 
				<cfflush interval="64">
				<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsLista#" 
						desplegar="PFDocumento, PFTcodigo, Descuento, Impuesto, Total"
						etiquetas="Documento, Transaccion, Descuento, Impuesto, Total"
						formatos="S,S,M,M,M"
						align="left, left, right, right, right"
						checkboxes="N"
						ira="ProcCancelaDocumento.cfm" 
						MaxRows="#Registros#"
        	            keys="Ddocumento,CCTcodigo"
                        form="form1"
                        >
					</cfinvoke> 
				</td>
			</tr>
	<form name="formboton" action="ProcCancelaDocumento.cfm" method="post">
            <tr>
           	  <td align="center">
               	  <input type="hidden" name="DdocumentoC" value="#Form.DdocumentoREF#" />
                  <input type="hidden" name="CCTcodigoC" value="#Form.CCTcodigoREF#" />
                  <input type="submit" name="btnCancelar_Documento" value="Cancelar Documento" />
              </td>
            </tr>
     </form>
		</table>
	
</cfoutput>              
	<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms form="form1" objForm="objForm">
<script language="JavaScript1.2">
	function Confirma(){
		if (confirm('¿Seguro desea Cancelar el documento?'))
			return(true);
		else
			return(false);
	}
</script>