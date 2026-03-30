<cf_templateheader title="Proceso de Compra SIGEPRO">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cotizaciones de la solicitud'>
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	
		<style type="text/css">
		<!--
		.style2 {
			color: #003399;
			font-weight: bold;
		}
		-->
			</style>
	<cfif isdefined('url.proceso') and len(trim(#url.proceso#)) gt 0>
	    <cfset LvarProceso = #url.proceso#>
	</cfif>
    <cfif isdefined('url.solicitud') and len(trim(#url.solicitud#)) gt 0>
	    <cfset LvarSolicitud = #url.solicitud#>
	</cfif>
    <cfif isdefined('url.lineaSolic') and len(trim(#url.lineaSolic#)) gt 0>
	    <cfset LvarLineaSol = #url.lineaSolic#>
	</cfif>
	
	<cfquery name="rsDetProcesoCM" datasource="#session.dsn#">	 
     select 
          a.CMPnumero,
		  a.CMPdescripcion
      from CMProcesoCompra a 
	      where a.CMPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarProceso#" >
	</cfquery>

	<cfquery name="rsDetSolicitud" datasource="#session.dsn#">	 
     select 
          b.ESnumero,
		  a.DSdescripcion
      from DSolicitudCompraCM a  
	       inner join  ESolicitudCompraCM b 
		      on a.ESidsolicitud = b.ESidsolicitud  
			     where a.DSlinea= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarLineaSol#" >
	</cfquery>

	
	<table align="center" border="0" width="60%">
	      <tr align="center">
	          <td colspan="2" align="center">
			       <strong>Detalle de la Solicitud</strong>
			  </td>
	     </tr>
	      <tr bgcolor="#CCCCCC" align="center">
	          <td align="center">
			       <strong>Proceso de Compra:</strong>	              
			  </td>
			  <td align="center">
			      <cfoutput>#rsDetProcesoCM.CMPnumero# - #rsDetProcesoCM.CMPdescripcion#</cfoutput>
		      </td >
	     </tr>	
	     <tr  align="center">
	        <td align="center">
			      <strong>Solicitud:</strong> 
			</td>
			<td align="left">
			      <cfoutput>#rsDetSolicitud.ESnumero# - #rsDetSolicitud.DSdescripcion#</cfoutput>
	        </td>
	     </tr>
	</table>
	<cf_dbfunction name="to_char" args="DClinea" returnVariable="LvarCOTLinea">	
	<cfset LvarImgItems	= "<img border=''0'' src=""/cfmx/sif/imagenes/stop2.gif"" style=''cursor:pointer;'' onClick=''CotizarItems('#LvarCNCT# #LvarCOTLinea# #LvarCNCT#',#LvarProceso#,#LvarSolicitud#,#LvarLineaSol#);''>">
   
	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="DSolicitudCompraCM sc 
			inner join DCotizacionesCM Dcot
				on sc.DSlinea = Dcot.DSlinea
			inner join ECotizacionesCM Ecot
				on Dcot.ECid = Ecot.ECid	
				"/>
		<cfinvokeargument name="columnas" value="Dcot.DClinea,coalesce(Ecot.ECdescprov,'N/D') as DescripCot,  coalesce((select sum( COItemCCantidad * COItemCPrecio) from COItemsCotizacion where CMPid = 8000000000000140 and DSlinea= 1570 and DClinea=Dcot.DClinea ),0) as ItemsCotizados, Dcot.DCcantidad,Dcot.DCpreciou, Dcot.DCtotallin as MontoCot, '#preserveSingleQuotes(LvarImgItems)#' as items"/>
		<cfinvokeargument name="desplegar" value="DClinea,DescripCot,DCcantidad, DCpreciou,MontoCot,ItemsCotizados,items "/>
		<cfinvokeargument name="etiquetas" value="Linea,Descripci&oacute;n, Cantidad, Precio, Monto, Monto en Items,Items"/>
		<cfinvokeargument name="formatos" value="V,V,V,M,M,M,U"/>
		<cfinvokeargument name="filtro" value=" sc.DSlinea = #url.lineaSolic#
													and sc.Ecodigo = #session.ecodigo#"/>
		<cfinvokeargument name="align" value="left, left, center, center, center,center,center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true">
		<cfinvokeargument name="EmptyListMsg" value="No existen cotizaciones">	
		<cfinvokeargument name="keys" value="DClinea"/>				
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="formName" value="listaCotizacion"/>
		<cfinvokeargument name="incluyeForm" value="true"/>
		<cfinvokeargument name="usaAjax" value="true"/>						
		<cfinvokeargument name="mostrar_filtro" value="true"/>
				
		<cfinvokeargument name="filtrar_automatico" value="yes"/>
		<cfinvokeargument name="filtrar_Por=" value="COItemDescripcion, COItemUnidad"/>		
    	<cfinvokeargument name="irA" value="CotizacionProceso.cfm?solicitud=#LvarSolicitud#"/>
			
		<cfinvokeargument name="showLink" value="false">
	</cfinvoke>
	<table align="center">
	  <tr>
		<td align="center">
		  <input type="button" value="Atrás" onclick="history.back()" style="font-family: Verdana; font-size: 8 pt">
		</td>
	  </tr>
	</table>
		<cfoutput>
		  <script language="javascript" type="text/javascript">
			 function CotizarItems(cotlinea,proceso,solicitud,lineaSolic)
			 { 
			   window.open('CotizacionItems.cfm?lineaCot='+cotlinea+'&proceso='+proceso+'&solicitud='+solicitud+'&lineaSolic='+lineaSolic,"Window1","menubar=no,width=1000,height=400,toolbar=no, screenX=200,screenY=50");   
		     }				
		  </script>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>		
