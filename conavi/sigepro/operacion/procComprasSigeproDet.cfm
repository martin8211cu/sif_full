<cf_templateheader title="Proceso de Compra SIGEPRO">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Proceso de Compra SIGEPRO'>
		<cfif isdefined('form.CMPid') and len(trim(#form.CMPid#)) gt 0>
		<cfquery name="rsEncabezadoPC" datasource="#session.dsn#">
		   Select a.CMPnumero, a.CMPdescripcion, a.CMPfechapublica from CMProcesoCompra a  where a.CMPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#"> 
		   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		</cfquery>			
		
		<table align="center" width="100%">
		<tr>
		 <td colspan="8" align="center">
		   <strong>Detalle del Proceso</strong>
		 </td>
		</tr>
		<tr align="center">
			 <td width="33%" ><strong>N° de Proceso</strong></td>
			 <td width="33%" ><strong>Descripción</strong></td>
			 <td width="33%" ><strong>Fecha de Publicación</strong></td>
		</tr>
		<cfoutput query="rsEncabezadoPC">
		 <tr align="center">
		      <td bgcolor="##CCCCCC" >#rsEncabezadoPC.CMPnumero#</td>
			  <td bgcolor="##CCCCCC" >#rsEncabezadoPC.CMPdescripcion#</td>
			  <td bgcolor="##CCCCCC" >#dateFormat(rsEncabezadoPC.CMPfechapublica,'yyyy-mm-dd')#</td>		 
	    </tr>
	
		</cfoutput>	
		 <tr align="center">
		    <td colspan="3">&nbsp;</td>			
	    </tr>
		</table>
		<cfquery name="rsCMPEncabezadoDet" datasource="#session.dsn#" >  
		  select dcm.DSdescripcion,
		         dcm.ESnumero,
				 dcm.DSlinea,
				 dcm.ESidsolicitud,
				 dcm.DSlinea,
				 dcm.DScant,
				 cf.CFdescripcion,
				 dcm.DStotallinest,
				 dcm.DSmontoest  
			from CMLineasProceso cm
				 inner join DSolicitudCompraCM dcm
			   on cm.ESidsolicitud = dcm.ESidsolicitud
			      and cm.DSlinea = dcm.DSlinea
			        inner join  CFuncional cf 
                         on dcm.CFid = cf.CFid
		   where cm.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">  
		   and dcm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		</cfquery>
		
		<table align="center" width="100%">
		<tr>
		    <td align="center"><strong>N.Solicitud</strong></td>
			<td align="center"><strong>Descripcion</strong></td>
			<td align="center"><strong>Cantidad</strong></td>
			<td align="center"><strong>Monto Unitario</strong></td>
			<td align="center"><strong>Monto Linea</strong></td>
			<td align="center"><strong>Total en Items</strong></td>
			<td align="center"><strong>Centro Funcional</strong></td>
			<td align="center"><strong>Item del Proceso</strong></td>
			<td align="center"><strong>Item de la Cotización</strong></td>
		</tr>
		<cfloop query="rsCMPEncabezadoDet">
		
		<cfquery name="rsItemsSaldo" datasource="#session.dsn#">
		   Select 
		       sum(coalesce(COItemPCantidad,0) *  coalesce(COItemPPrecio,0)) as SaldoItems
			     from COItemsProceso 
			 where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#"> 
		       and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCMPEncabezadoDet.DSlinea#">  
		</cfquery>				
		<tr>
		    <td align="center"><cfoutput>#rsCMPEncabezadoDet.ESnumero#</cfoutput></td>
			<td align="center"><cfoutput>#rsCMPEncabezadoDet.DSdescripcion#</cfoutput></td>
			<td align="center"><cfoutput>#rsCMPEncabezadoDet.DScant#</cfoutput></td>
			<td align="center"><cfoutput>#rsCMPEncabezadoDet.DSmontoest#</cfoutput></td>
			<td align="center"><cfoutput>#NumberFormat(rsCMPEncabezadoDet.DStotallinest,'9,99.9')#</cfoutput></td>
			<td align="center"><cfoutput>#NumberFormat(rsItemsSaldo.SaldoItems,'9,99.9')#</cfoutput></td>
			<td align="center"><cfoutput>#rsCMPEncabezadoDet.CFdescripcion#</cfoutput></td>	
			<td nowrap align="center">
			    <input type="image" src="../../../sif/imagenes/stop2.gif" onclick="ProcesoItem('I','<cfoutput>#form.CMPid#</cfoutput>','<cfoutput>#rsCMPEncabezadoDet.ESidsolicitud#</cfoutput>','<cfoutput>#rsCMPEncabezadoDet.DSlinea#</cfoutput>')" /> 
    		</td>	
			<td nowrap align="center">               
    		      <a href="CotizacionProceso.cfm?tipo=C&proceso=<cfoutput>#form.CMPid#</cfoutput>&solicitud=<cfoutput>#rsCMPEncabezadoDet.ESidsolicitud#</cfoutput>&lineaSolic=<cfoutput>#rsCMPEncabezadoDet.DSlinea#</cfoutput>"> <input type="image" src="../../../sif/imagenes/stop3.gif"/></a>  
			</td>	    
		</tr>
		</cfloop>
		<tr >
		<td  align="center" colspan="9">
        		<input type="button" value="Atrás" onclick="history.back()" style="font-family: Verdana; font-size: 8 pt">
		</td>
		</tr>
		</table>
		</cfif>	
		<cfoutput>
		<script language="javascript" type="text/javascript">
		function ProcesoItem(tipo,proceso,solicitud,linea)
		{ 
		  if(proceso == "")
		  { 
		    alert("No tiene un proceso definido");
		  }	
		  if(solicitud == "")
		  { 
		    alert("No tiene una  solicitud definida");  
		  }	
		  if(linea == "")
		  { 
		    alert("No tiene una línea definida");
		  }	
		  if(tipo =='I')
		  {	  
		   window.open('evalProcesoCompra.cfm?tipo='+tipo+'&proceso='+proceso+'&solicitud='+solicitud+'&linea='+linea,"Window1","menubar=no,width=900,height=400,toolbar=no, screenX=200,screenY=50");
		  }
		
		}	
			function COtizacionItem(tipo,proceso,solicitud,lineaSolic)
		{ 
		   window.open('evalProcesoCompra.cfm?tipo='+tipo+'&proceso='+proceso+'&solicitud='+solicitud+'&lineaSolic='+lineaSolic,"Window1","menubar=no,width=900,height=400,toolbar=no, screenX=200,screenY=50");   
		}	
			
		</script>
		</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>