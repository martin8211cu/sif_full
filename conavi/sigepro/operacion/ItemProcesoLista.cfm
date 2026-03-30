<cfif isdefined("url.tipo") and len(trim(url.tipo)) gt 0>
    <cfset LvarTipo =  url.tipo> 
<cfelseif isdefined("Form.tipo") and len(trim( Form.tipo)) gt 0>
    <cfset LvarTipo =  Form.tipo>
</cfif>

<cfif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>
    <cfset LvarProceso =  url.proceso> 
<cfelseif isdefined("Form.proceso") and len(trim( Form.proceso)) gt 0>
    <cfset LvarProceso =  Form.proceso>
</cfif>

<cfif isdefined("url.linea") and len(trim(url.linea)) gt 0>
    <cfset LvarLinea =  url.linea> 
<cfelseif isdefined("Form.linea") and len(trim( Form.linea)) gt 0>
    <cfset LvarLinea =  Form.linea>
</cfif>

<cfif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
    <cfset LvarSolicitud =  url.solicitud> 
<cfelseif isdefined("Form.solicitud") and len(trim( Form.solicitud)) gt 0>
    <cfset LvarSolicitud =  Form.solicitud>
</cfif>

<!---<cf_dbfunction name="to_char" args="COItemPId" returnVariable="LvarCOItemPId">	
	<cfset LvarImgDelete	= "<img border=''0'' src=""/cfmx/sif/imagenes/borrar01_S.gif"" style=''cursor:pointer;'' onClick=''CMIPbaja('#LvarCNCT# #LvarCOItemPId# #LvarCNCT#',#LvarProceso#,#LvarSolicitud#,#LvarLinea#);''>">
--->
   <table><cfoutput>
      <form name="ListaItems" method="post" action="evalProcesoCompra.cfm?tipo=#LvarTipo#&proceso=#LvarProceso#&solicitud=#LvarSolicitud#&linea=#LvarLinea#">
	 </cfoutput>
	  <tr>
		<td>
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="COItemsProceso cip inner join COItemsSigepro cis  
                                  						 on  cip.COItemId = cis.COItemId"/>
				<cfinvokeargument name="columnas" value="cip.COItemPId,cis.COItemId,cis.COItemDescripcion, cis.COItemUnidad, (cip.COItemPCantidad * cip.COItemPPrecio) as Monto
				"/>
				<cfinvokeargument name="desplegar" value="COItemDescripcion, COItemUnidad,Monto"/>
				<cfinvokeargument name="etiquetas" value="Descripcion,Unidad,Monto"/>
				<cfinvokeargument name="formatos" value="S,S,UM,U"/>
				<cfinvokeargument name="filtro" value=" cip.CMPid = #LvarProceso#  and cip.DSlinea = #LvarLinea# 
				                        and cip.Ecodigo = #session.ecodigo# and cis.Ecodigo = #session.ecodigo#"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="formName" value="ListaItems"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="usaAjax" value="true"/>						
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="yes"/>
				<cfinvokeargument name="filtrar_Por=" value="COItemDescripcion, COItemUnidad"/>		
				<cfinvokeargument name="irA" value="evalProcesoCompra.cfm?tipo=#LvarTipo#&proceso=#LvarProceso#&solicitud=#LvarSolicitud#&linea=#LvarLinea#"/>
				<cfinvokeargument name="keys" value="COItemPId"/>							
			</cfinvoke>
		   </td>
		  </tr>
		</form>
		</table>
		
<script type="text/javascript" language="javascript1.2">

	function filtrar_Plista(){
		return true;
	}
</script>
