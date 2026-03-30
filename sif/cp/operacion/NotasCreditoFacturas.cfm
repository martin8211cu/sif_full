<!---<cfif isdefined('btnAgregar')>    	    
</cfif>--->
 <cfquery name="rsEFactura" datasource="#session.dsn#">
     select  IDdocumento,Ddocumento, Dtotal, Mcodigo, EDusuario, Dfecha, Rcodigo,EDmontoretori, Icodigo
	    from EDocumentosCP
		  where CPTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo#"> 
		and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
		and SNcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
		and Ecodigo = #session.ecodigo#
  </cfquery>
 <cfif rsEFactura.recordcount  eq 1 and len(trim(rsEFactura.IDdocumento))>
     <cfquery name="rsMoneda" datasource="#session.dsn#">
       select Mnombre, Msimbolo, Miso4217 from Monedas where  Mcodigo = #rsEFactura.Mcodigo# and Ecodigo = #session.Ecodigo# 
     </cfquery>  
   <title>SIF - Cuentas por Pagar</title>
  <cfset titulo = "Registro de Notas de Cr&eacute;dito">			
   <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
		<table width="100%" border="0" align="center">		
		   <tr>
		    <input type="hidden" name="IdDocumento" value="#url.IdDocumento#" />
			 <td colspan="2" align="left"><strong>Detalle de la Factura:</strong></td>
		   </tr>		  
		   <tr align="center" bgcolor="#CCCCCC">
	 		 <td><strong>Factura:</strong> <cfoutput> #rsEFactura.Ddocumento#</cfoutput></td>
			 <td><strong>Monto:</strong> <cfoutput> #rsMoneda.Msimbolo# #NumberFormat(rsEFactura.Dtotal,'9,9.99')# #rsMoneda.Miso4217#</cfoutput></td>
		   </tr>
		     <tr align="center">
	 		 <td><strong>Tipo Retención:</strong> <cfoutput> #rsEFactura.Rcodigo#</cfoutput></td>
			 <td><strong>Monto Retención:</strong> <cfoutput> #rsMoneda.Msimbolo# #NumberFormat(rsEFactura.EDmontoretori,'9,9.99')#</cfoutput></td>
		   </tr>
		   <tr>
			<td align="center"><strong>Fecha:</strong><cfoutput> #DateFormat(rsEFactura.Dfecha,'dd-mm-YYYY')#</cfoutput></td>
			<td align="center"><strong>Usuario:</strong><cfoutput> #rsEFactura.EDusuario#</cfoutput></td>
		   </tr>		 
  </table>

    <cfquery name="rsDetFactura" datasource="#session.dsn#">
     select  a.IDdocumento,
	         a.DDlinea,
	         coalesce(a.Dcodigo,0) as Dcodigo, 
	         a.CPTcodigo,
			 a.Ddocumento,
			 a.DDtipo,
			 a.DDcantidad,
			 a.DDpreciou,
             a.DDtotallin,
             <cf_dbfunction name="sReplace"	args="a.DDescripcion+','+''" delimiters="+">  as DDescripcion, 
			 coalesce(a.Icodigo,'sin impuesto') as Icodigo, 
			 <cf_dbfunction name="sReplace"	args="n.SNnombre+','+''" delimiters="+"> as  SNnombre
	    from DDocumentosCP a  
		    inner join SNegocios n  
			    on a.SNcodigo = n.SNcodigo
				and a.Ecodigo = n.Ecodigo
		  where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEFactura.IDdocumento#"> 
        and a.Ecodigo = #session.ecodigo#
    </cfquery>
	 <cfset LvarRows = #rsDetFactura.recordcount#>
       <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
			<cfinvokeargument name="query" 				value="#rsDetFactura#"/>
			<cfinvokeargument name="desplegar" 			value="DDlinea, DDescripcion, CPTcodigo,DDcantidad,DDpreciou,DDtotallin, Icodigo"/>
			<cfinvokeargument name="etiquetas" 			value="Línea,Descripcion,Tipo,Cantidad, Precio Unit.,Total,Impuesto "/>
			<cfinvokeargument name="formatos" 			value="S,S,S,S,M,M,S"/>
			<cfinvokeargument name="align" 				value="left,left,left,center,center,center,center"/>
			<cfinvokeargument name="formName" 			value="form1"/>
			<cfinvokeargument name="checkboxes" 		value="S"/>
    		<cfinvokeargument name="irA"         		value="SQLRegistroDocumentosCP.cfm?EDocumento=#url.IdDocumento#&TipDoc=NC&URLira=RegistroNotasCreditoCP.cfm&tipo=D"/>	<!---NotasCreditoFacturas.cfm--->
			<cfinvokeargument name="checkall"           value="S">					
			<cfinvokeargument name="MaxRows" 			value="#LvarRows#"/>
			<cfinvokeargument name="showEmptyListMsg"   value="true"/>
			<cfinvokeargument name="PageIndex" 			value="1"/>
		    <cfinvokeargument name="incluyeForm" 		value="true"/>
			<cfinvokeargument name="botones"            value="Agregar, Cerrar">
			<cfinvokeargument name="showLink"        value="false">
			
  </cfinvoke>	  
    </cfif>
	<cfoutput>
	<script language="javascript">
	  function funcCerrar()
	  { 
	    window.close();
	  }
	 	  function funcAgregar()
	  {     
	    if(!fnAlgunoMarcadoform1()){
	     	alert("Debe elegir al menos un registro");
		    return false;	    	
		}
		return true;
	  }
	</script>
	</cfoutput>
   <cf_web_portlet_end>


 