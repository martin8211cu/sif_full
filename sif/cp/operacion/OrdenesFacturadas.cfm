<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">

<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>

<cfif isdefined("Url.documento") and len(trim(Url.documento))>
	<cfset IDocumento = Url.documento>
</cfif>
	
        <cfquery name="rsLineas" datasource="#Session.DSN#">				
				Select 				
				c.EOidorden					
				from DDocumentosCxP a
			    	inner join DOrdenCM b
					    on a.DOlinea = b.DOlinea
					inner join EOrdenCM c
				 		on c.EOidorden = b.EOidorden						
				       and a.Ecodigo = b.Ecodigo 			
				where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(url.documento)#">				
		</cfquery>

			
		<title>SIF - Cuentas por Pagar</title><table align="center" border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr> 
		  <td colspan="10" align="center">
		     <strong>Ordenes de Compra de esta factura</strong>	
		  </td>
	   </tr>
		<tr bgcolor="#33CCFF">
			  <td align="center"><strong>Numero de Orden</strong></td>
			  <td align="center"><strong>Documento</strong></td>
			  <td align="center"><strong>Fecha Alta</strong></td>
		      <td align="center"><strong>Moneda</strong></td>
			  <td align="center"><strong>Impuesto</strong></td>
			  <td align="center"><strong>Total</strong></td>
			  <td colspan="5">&nbsp;</td>			    			    
		</tr>
	<cfloop query="rsLineas">
        <cfquery name="rsDetallesOC" datasource="#Session.DSN#">
              select
			        a.EOidorden,			       
					a.EOnumero,
					a.Observaciones,
					a.EOfalta,
					m.Msimbolo,
					m.Mnombre,				
					a.Impuesto,
					a.EOtotal					
			   from EOrdenCM a
			       inner join Monedas m
				      on a.Mcodigo = m.Mcodigo									  
				 where a.EOidorden =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineas.EOidorden#">		
				    and a.Ecodigo = #session.ecodigo#					
      </cfquery>				
			 <cfloop  query="rsDetallesOC">
			 <tr bgcolor="#666666">
			  <td><cfoutput><span class="style1">#rsDetallesOC.EOnumero#</strong></span></cfoutput></td>
			  <td><cfoutput><span class="style1">#rsDetallesOC.Observaciones#</strong></span></cfoutput></td>
			  <td align="center"><cfoutput><span class="style1">#DateFormat(rsDetallesOC.EOfalta,'YYYY-mm-dd')#</strong></span></cfoutput></td>
			  <td><cfoutput><span class="style1">#rsDetallesOC.Mnombre#</strong></span></cfoutput></td>
			  <td nowrap="nowrap"><cfoutput><span class="style1">#rsDetallesOC.Msimbolo# #NumberFormat(rsDetallesOC.Impuesto,'9,99.99')#</strong></span></cfoutput></td>
			  <td nowrap="nowrap"><cfoutput><span class="style1">#rsDetallesOC.Msimbolo# #NumberFormat(rsDetallesOC.EOtotal,'9,99.99')#</strong></span></cfoutput></td>
			  <td colspan="5"><span class="style1"></span></td>			   
			  </tr>
			  
			    <cfquery name="rsLinDetOC" datasource="#Session.DSN#">
					  select
							b.DOconsecutivo,							
							<!---<cf_dbfunction name='sPart' args='b.DOdescripcion|1|50' delimiters="|">#_Cat#'</label>' #_Cat# case when <cf_dbfunction name="length"	args="b.DOdescripcion"> > 50 then '...' else '' end as DOdescripcion,	--->		              	
							b.DOdescripcion,	
							b.DOlinea,
							b.DOcantidad,
							b.DOpreciou,
							b.DOtotal,
							b.Ucodigo,
							c.Mcodigo,
							b.Icodigo,
							imp.Idescripcion,
							cfun.CFdescripcion,	
							cmp.CMPid			
					   from DOrdenCM b						
							inner join EOrdenCM c
								on b.EOidorden = c.EOidorden
							inner join CFuncional cfun
								on cfun.CFid = b.CFid	
							inner join Impuestos imp
							    on b.Icodigo = imp.Icodigo
							left join CMLineasProceso cmp
							    on b.DSlinea = cmp.DSlinea	 									  
						 where b.EOidorden =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetallesOC.EOidorden#">
						 and b.Ecodigo = #session.ecodigo#
						 and imp.Ecodigo = #session.ecodigo#		
						 and b.DSlinea is not null
						 order by DOconsecutivo
			   </cfquery>	
				 <cfif rsLinDetOC.recordcount gt 0>
				      <cfquery name="rsCodigoProceso" datasource="#session.dsn#">
					   Select coalesce(CMPcodigoProceso,'--') as CMPcodigoProceso from CMProcesoCompra 
					     where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinDetOC.CMPid#">
						 and  Ecodigo = #session.Ecodigo#
					 </cfquery>
				      <tr bgcolor="#999999">
						  <td>&nbsp;</td>	
						  <td align="center"><strong>Línea</strong></td>
						  <td align="center"><strong>Descripción</strong></td>
						  <td align="center"><strong>Código Proceso</strong></td>
						  <td align="center"><strong>Centro Funcional</strong></td>
						  <td align="center"><strong>Cantidad</strong></td>
						  <td align="center"><strong>Precio Unitario</strong></td>
						  <td align="center"><strong>Unidad de Medida</strong></td>						  
						  <td align="center"><strong>Impuesto</strong></td>			    
						  <td align="center"><strong>Total</strong></td>			    
				   </tr>  	
					  <cfloop  query="rsLinDetOC">
						 <tr>
						   <td>&nbsp;</td>	
						   <td align="center"><cfoutput>#rsLinDetOC.DOconsecutivo#</cfoutput></td>
						   <td ><cfoutput>#rsLinDetOC.DOdescripcion#</cfoutput></td>
						    <td align="center" ><cfoutput>#rsCodigoProceso.CMPcodigoProceso#</cfoutput></td>
						   <td><cfoutput>#rsLinDetOC.CFdescripcion#</cfoutput></td>
						   <td align="center"><cfoutput>#rsLinDetOC.DOcantidad#</cfoutput></td>
						   <td align="right"><cfoutput>#rsDetallesOC.Msimbolo# #NumberFormat(rsLinDetOC.DOpreciou,'9,99.99')#</cfoutput></td>	
						   <td align="center"><cfoutput>#rsLinDetOC.Ucodigo#</cfoutput></td>						  								   
						   <td align="right"><cfoutput>#rsLinDetOC.Icodigo#</cfoutput></td>						   
						   <td align="right" nowrap="nowrap"><cfoutput>#rsDetallesOC.Msimbolo# #NumberFormat(rsLinDetOC.DOtotal,'9,99.99')#</cfoutput></td>	
					    </tr> 
					 </cfloop> 
			  </cfif>
	  </cfloop>
	</cfloop>	 
	                  <tr>
					  <td colspan="9" align="center">
					  	  ______________________________________________________________________________________________________________________
					  </td>
					  </tr>
					  <tr>
					  <td colspan="9" align="center">
					        <input type="button" value="Cerrar" onClick="javascript:window.close();" />
					  </td>
					  </tr>
	 </table>
			
