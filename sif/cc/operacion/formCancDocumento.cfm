<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfsetting enablecfoutputonly="yes">

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>
<cfparam name="Form.Registros" default="20">
<cfparam name="Form.pageNum_lista" default="1">

<cfquery name="rsDocumento" datasource="#session.DSN#">
	select a.Ddocumento,a.CCTcodigo,s.SNnombre,
    	a.Dtotal,a.Mcodigo,a.Dtipocambio,o.Odescripcion,a.HDid,
        coalesce(a.ETnumero,0) as ETnumero, coalesce(a.FCid,0) as FCid
    from HDocumentos a
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

<cfquery name="rsTran" datasource="#session.DSN#">
	select count(1) as cant
    from ETransacciones et
    where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and et.ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.ETnumero#">
    and et.FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.FCid#">
    and et.ETestado  = 'C'
</cfquery>

<cfif rsTran.cant gt 0>
    <cfquery name="rsLista" datasource="#session.DSN#">
        select convert(varchar,et.ETdocumento)#_Cat#et.ETserie as Ddocumento, et.CCTcodigo, et.FCid, et.ETnumero,
        et.ETmontodes as Descuento, et.ETimpuesto as Impuesto, et.ETtotal as Total, b.SNnombre, et.ETfecha
        from ETransacciones et
        inner join SNegocios b
        on b.SNcodigo = et.SNcodigo 
        and b.Ecodigo = et.Ecodigo
        where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and et.ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.ETnumero#">
        and et.FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.FCid#">
        and et.ETestado  = 'C'
    </cfquery>
    
    <cfquery name="rsListaD" datasource="#session.DSN#">
        select convert(varchar,b.DTlinea) as DTlinea, b.DTtipo, b.DTdescripcion, b.DTcant, b.DTpreciou, b.DTdeslinea, b.DTtotal,
        case DTtipo when 'S' then 'Servicio' else 'Articulo' end as tipo, c.CFdescripcion, b.DTimpuesto, b.DTreclinea, b.FCid, b.ETnumero	
        from DTransacciones b
        inner join CFuncional c
        on c.Ecodigo = b.Ecodigo
        and c.CFid = b.CFid
        where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and b.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.ETnumero#">
        and b.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.FCid#">
        and DTborrado = 0
    </cfquery>
    
    <cfset desplegar = "Ddocumento, CCTcodigo, SNnombre, ETfecha, Impuesto, Descuento, Total">
    <cfset etiquetas="Documento, Transaccion, Cliente, Fecha, Impuesto, Descuento, Total">
    <cfset formatos="S,S,S,D,M,M,M">
    <cfset align="left, left, left, center, right, right, right">
    <cfset keys="FCid, ETnumero">
    
    <cfset desplegarD = "CFdescripcion, DTdescripcion, tipo, DTcant, DTpreciou, DTimpuesto, DTdeslinea,DTreclinea,DTtotal">
    <cfset etiquetasD = "Centro Funcional, Descripción, Tipo, Cantidad, Precio Unit., Impuestos, Descuento,Recargos,Total">
    <cfset formatosD  = "S,S,S,I,M,M,M,M,M">
    <cfset alignD     = "left, left, left, center, right, right, right, right, right">
    
	<cfset tituloE    = "Encabezado de la Transacción Relacionada al Documento">
    <cfset tituloD    = "Detalle de la Transacción Relacionada al Documento">
<cfelse>
	<cfquery name="rsLista" datasource="#session.DSN#">
        select a.Ddocumento,a.CCTcodigo, a.EDdescuento, a.Icodigo, a.Dtotal, a.HDid
        from HDocumentos a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoREF#">
        and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoREF#">
    </cfquery>
    
    <cfquery name="rsListaD" datasource="#session.DSN#">
        select a.Ddocumento,a.CCTcodigo, a.DDdesclinea as EDdescuento, a.DDimpuesto as Icodigo, a.DDtotal as Dtotal, a.HDid,
        case a.DDtipo when 'S' then 'Servicio' else 'Articulo' end as tipo, a.DDescripcion, a.DDpreciou, a.DDcantidad
        from HDDocumentos a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DdocumentoREF#">
        and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoREF#">
    </cfquery>
    
    <cfset desplegar = "Ddocumento, CCTcodigo, Icodigo, EDdescuento, Dtotal">
    <cfset etiquetas = "Documento, Transaccion, Impuesto, Descuento, Total">
    <cfset formatos  = "S,S,S,M,M">
    <cfset align     = "left, left, left, right, right">
    <cfset keys      = "HDid">
    
    <cfset desplegarD = "Ddocumento, CCTcodigo, DDcantidad, DDescripcion,DDpreciou,Icodigo, EDdescuento, Dtotal">
    <cfset etiquetasD = "Documento, Transaccion, Cantidad, Descripcion, Precio,Impuesto, Descuento, Total">
    <cfset formatosD  = "S,S,I,S,M,S,M,M">
    <cfset alignD     = "left, left, center, left, right, right, right, right">
    <cfset keysD      = "HDid">
    
    <cfset tituloE   = "Encabezado del Documento">
	<cfset tituloD   = "Detalle del Documento">
</cfif>
<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Cuentas por Cobrar">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelación de Documentos'>
<cfoutput>
	<form name="form1" action="ProcCancDocumento.cfm" method="post">
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
                		<font style="font-size:17px"> #tituloE#  </font>
	                </strong>
    	    	</td>
			</tr>
	</form>       
	        <tr> 
				<cfflush interval="64">
				<td>
                	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsLista#" 
						desplegar="#desplegar#"
						etiquetas="#etiquetas#"
						formatos="#formatos#"
						align="#align#"
						checkboxes="N"
						ira="ProcCancDocumento.cfm" 
						MaxRows="#Registros#"
        	            keys="#keys#"
                        form="form1"
                        >
					</cfinvoke> 
				</td>
			</tr>
            
            <tr> 
        		<td>&nbsp;</td>
			</tr>
            
            <tr> 
        		<td  align="center" nowrap="nowrap" bgcolor="00CCFF">
            		<strong> 
                		<font style="font-size:17px"> #tituloD# </font>
	                </strong>
    	    	</td>
			</tr>
            <tr> 
				<td>
                	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsListaD#" 
						desplegar="#desplegarD#"
						etiquetas="#etiquetasD#"
						formatos="#formatosD#"
						align="#alignD#"
						checkboxes="N"
						ira="ProcCancDocumento.cfm" 
						MaxRows="#Registros#"
        	            form="form1"
                        >
					</cfinvoke> 
				</td>
			</tr>
            <tr> 
        		<td>&nbsp;</td>
			</tr>
	<form name="formboton" action="ProcCancDocumento.cfm" method="post" onsubmit="Confirma();">
            <tr>
           	  <td align="center">
               	  <input type="hidden" name="DdocumentoC" value="#Form.DdocumentoREF#" />
                  <input type="hidden" name="CCTcodigoC" value="#Form.CCTcodigoREF#" />
                  <input type="hidden" name="HDidC" value="#rsDocumento.HDid#" />
                  <input type="submit" name="btnCancelar_Documento" value="Cancelar Documento" />
              </td>
            </tr>
     </form>
		</table>
	
</cfoutput>              
<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms form="formboton" objForm="objForm">
<script language="JavaScript1.2">
	function Confirma(){
		if (confirm('¿Seguro desea Cancelar el documento?'))
			return true;
		else
			return false;
	}
</script>