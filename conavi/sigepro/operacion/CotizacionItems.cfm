<title>Evaluación del Proceso de Compra -  SIGEPRO</title>
	
	<cfif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>
        <cfset LvarProceso =  url.proceso> 
	<cfelseif isdefined("Form.proceso") and len(trim( Form.proceso)) gt 0>
		<cfset LvarProceso =  Form.proceso>
	</cfif>
	
	<cfif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
		<cfset LvarSolicitud =  url.solicitud> 
	<cfelseif isdefined("Form.solicitud") and len(trim( Form.solicitud)) gt 0>
		<cfset LvarSolicitud =  Form.solicitud>
	</cfif>
	
	<cfif isdefined("url.lineaSolic") and len(trim(url.lineaSolic)) gt 0>
		<cfset LvarLinea =  url.lineaSolic> 
	<cfelseif isdefined("Form.lineaSolic") and len(trim( Form.lineaSolic)) gt 0>
		<cfset LvarLinea =  Form.linea>
	</cfif>
	
	<cfif isdefined("url.lineaCot") and len(trim(url.lineaCot)) gt 0>
		<cfset LvarLineaCot =  url.lineaCot> 
	<cfelseif isdefined("Form.lineaCot") and len(trim( Form.lineaCot)) gt 0>
		<cfset LvarLineaCot =  Form.lineaCot>
	</cfif>	
	

	<cfquery name="rsCantidadItems" datasource="#session.dsn#">
	   select count(COItemCId) as NumItems
	     from COItemsCotizacion
		 where 
		    CMPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#">
		   and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLinea#">
		   and DClinea= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaCot#">
		   and  Ecodigo = #Session.Ecodigo#   
	</cfquery>
	<cfif rsCantidadItems.NumItems eq 0>
	     <cfquery name="rsItemsProceso" datasource="#session.dsn#">
	      select COItemId,COItemPCantidad,COItemPPrecio
		    from COItemsProceso
				where 
				 CMPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#">
				 and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLinea#">
				 and  Ecodigo = #Session.Ecodigo#   
	     </cfquery>
		 <cfloop query="rsItemsProceso">
			  <cfquery name="rsInsertItemsCot" datasource="#session.dsn#" >	
				  insert into COItemsCotizacion 
				  (
					 CMPid,
					 COItemId,
					 DClinea,
					 DSlinea,
					 COItemCCantidad,
					 COItemCPrecio,
					 COItemCFecha,
					 Ecodigo, 
					 BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItemsProceso.COItemId#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaCot#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLinea#">,
					0,
					0,
					<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"yyyy-mm-dd")#">,				
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">							
				)				    
			</cfquery>		  
	     </cfloop>
	   
	</cfif>	
	
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Items por Linea de Cotización'>
	
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="3">
				
				</td>
              </tr>
              <tr> 
                <td valign="top"> 
                  <cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
                    <cfinvokeargument name="tabla" value="COItemsCotizacion a
															inner join COItemsSigepro b
															  on b.COItemId = a.COItemId"/>
     				<cfinvokeargument name="columnas" value="a.COItemCId,
					                                         b.COItemClave,
					                                         b.COItemDescripcion,
															 a.COItemCCantidad,
															 a.COItemCPrecio,
															 (a.COItemCCantidad * a.COItemCPrecio) as monto"/>
															 
                    <cfinvokeargument name="desplegar" value="COItemClave, COItemDescripcion,COItemCCantidad,COItemCPrecio, monto "/>
                    <cfinvokeargument name="etiquetas" value="Clave,Descripción,Cantidad,Precio,Monto"/>
                    <cfinvokeargument name="formatos" value="S,S,S,M,M"/>
                    <cfinvokeargument name="filtro" value="a.CMPid=#LvarProceso# 
					                                   and DSlinea = #LvarLinea#
													   and DClinea= #LvarLineaCot#
													   and  a.Ecodigo = #Session.Ecodigo#
													   and b.Ecodigo = #Session.Ecodigo# "/>
                    <cfinvokeargument name="align" value="left,center,rigth,rigth,rigth"/>
                    <cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="usaAjax" value="true"/>	
					<cfinvokeargument name="irA" value="CotizacionItems.cfm?proceso=#LvarProceso#&solicitud=#LvarSolicitud#&lineaSolic=#LvarLinea#&lineaCot=#LvarLineaCot#"/>
				    <cfinvokeargument name="keys" value="COItemCId"/>
    			 </cfinvoke>
                </td>				
                <td valign="top">
                   <cfinclude template="CotizacionItemsform.cfm">
                  &nbsp;</td>
              </tr>
			  <tr>
			     <td>
				 </td>
			  </tr>
            </table>
<cf_web_portlet_end>
<table align="center">
    <tr>
      <td>
		<input type="button" name="cerrar" value="Cerrar ventana" onclick="javascript:window.close();" />
      </td>
	</tr>
</table>