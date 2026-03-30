<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="ReporteTestransfer.cfm"
	FileName="ReporteTransferencias.xls"
	title="Reporte de Transferencias">
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>
<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery datasource="#session.dsn#" name="lista">
	   select
		  TESTLid,
		  case tesL.TESTLestado
				when  0 then 'En Preparación'
				when  1 then 'En Generacion'
				when  2 then 'Después de Generado'
				when  3 then 'Emitido'
				else 'Estado desconocido'
		end as TESTLestado,
		  TESMPcodigo,
		  CBdescripcion,
		  CBcodigo,
		  CBTcodigo,
		  TESTLfecha,
		  Bdescripcion     
		   from TEStransferenciasL  tesL
		inner join    CuentasBancos cb
           on cb.CBid =  tesL.CBid
		inner join Bancos B
		   on cb.Bid= B.Bid   
        where cb.Ecodigo =  #session.ecodigo#
	        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		<cfif not len(trim(form.LoteNum)) and len(trim(form.CBid)) and form.CBid NEQ '-1'>
				and cb.CBid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
        </cfif>
		<cfif len(trim(form.LoteNum)) gt 0>
			and tesL.TESTLid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LoteNum#">
        </cfif>
    			
		<cfif len(trim(form.TESOTransf_FI))>
			and  tesL.TESTLfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOTransf_FI)#">
		</cfif>
		<cfif len(trim(form.TESOTransf_FF))>
			and tesL.TESTLfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOTransf_FF)#">
		</cfif>		
	     order by TESTLid,TESTLfechaEmsion
</cfquery>
<table align="center" width="100%" border="0" cellpadding="2" cellspacing="2">
   <tr align="center">
      <td colspan="7">&nbsp;	       	</td> 
   </tr>
   <tr>
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><span class="style1"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></span></td>
   </tr>
   <tr align="center">    
      <td colspan="7">
	   <strong> Reporte de Transferencias Bancarias</strong>
     </td>
<!---   </tr>
     <tr align="center">
     <td colspan="7">&nbsp;	       
	 </td> 
  </tr>--->
   <cfif isdefined('form.TESOTransf_FI') and len(trim(#form.TESOTransf_FI#)) and isdefined('form.TESOTransf_FF') and len(trim(#form.TESOTransf_FF#))>
   <tr align="center">
     <td colspan="7"><strong>Lotes con fecha desde:</strong> <cfoutput>#LsDateFormat(form.TESOTransf_FI,'YYYY-mm-dd')#</cfoutput> <strong>Hasta:</strong><cfoutput> #LsDateFormat(form.TESOTransf_FF,'YYYY-mm-dd')# </cfoutput>    
	 </td> 
   </tr>
   </cfif>
    <cfif isdefined('form.TESOTransf_FI') and len(trim(#form.TESOTransf_FI#)) and isdefined('form.TESOTransf_FF') and not len(trim(#form.TESOTransf_FF#))>
   <tr align="center">
     <td colspan="7"><strong>Lotes con fecha desde:</strong> <cfoutput>#LsDateFormat(form.TESOTransf_FI,'YYYY-mm-dd')#</cfoutput>  
	 </td> 
   </tr>
   </cfif>
    <cfif isdefined('form.TESOTransf_FI') and not len(trim(#form.TESOTransf_FI#)) and isdefined('form.TESOTransf_FF') and len(trim(#form.TESOTransf_FF#))>
   <tr align="center">
     <td colspan="7"><strong>Lotes con fecha hasta:</strong><cfoutput> #LsDateFormat(form.TESOTransf_FF,'YYYY-mm-dd')# </cfoutput>    
	 </td> 
   </tr>
   </cfif>
   <cfif isdefined('form.LoteNum') and len(trim(form.LoteNum))>
   <tr align="center">
     <td colspan="7"><strong>Lote con Número:</strong><cfoutput>#form.LoteNum#</cfoutput>    
	 </td> 
   </tr>
   </cfif>
 
 <tr bgcolor="#99CCFF">     
	  <td align="left" valign="top" nowrap="nowrap"><strong> Numero de Lote</strong></td>
	  <td align="left" valign="top" nowrap="nowrap"><strong> Banco</strong></td>
      <td align="left" valign="top" nowrap="nowrap"><strong> Cuenta</strong></td>
	  <td align="left" valign="top" nowrap="nowrap"><strong> Fecha Lote</strong></td>
      <td align="left" valign="top" nowrap="nowrap"><strong> Medio de pago</strong></td>
	  <td align="left" valign="top" nowrap="nowrap"><strong> Estado del lote</strong></td>
 <tr>   

<cfif lista.recordcount GT 0>
	<cfloop query="lista">
	  <tr bgcolor="#999999">     
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#lista.TESTLid#</cfoutput></td>
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#lista.Bdescripcion#- #lista.CBTcodigo#</cfoutput></td>		
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#lista.CBdescripcion#</cfoutput></td>
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#LSDateFormat(lista.TESTLfecha,'YYYY-mm-dd')#</cfoutput></td>
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#lista.TESMPcodigo#</cfoutput></td>		  
		  <td align="left" valign="top" nowrap="nowrap"><cfoutput>#lista.TESTLestado#</cfoutput></td>
	   <tr>   
	   <cfquery name="rsDetalles" datasource="#session.dsn#">
		  Select 
             tesD.TESTDid,
			 tesD.TESTDreferencia,
			 tesD.TESOPid,
			 tesD.CBid,
			 case tesD.TESTDestado
				when  0 then 'En Preparación'
				when  1 then 'Generado'
				when  2 then 'Entregado'
				when  3 then 'Anulado' #_Cat#' ' #_Cat# tesOP.TESOPmsgRechazo
				else 'Estado desconocido'
		     end as TESTDestado,
			 tesD.UsucodigoEmision,
			 tesD.TESTDfechaEmision,
			 tesD.UsucodigoAnulacion,
			 tesD.TESTDfechaAnulacion,
			 tesD.TESTDmsgAnulacion, 
             tesD.TESTLidReimpresion,
			 tesD.TESTDfechaGeneracion ,
			 tesOP.TESOPbeneficiario,
			 tesOP.TESOPnumero,
			 tesOP.Miso4217Pago,
			 tesOP.TESOPtotalPago,
			 cb.CBdescripcion,
		     cb.CBcodigo,
		     cb.CBTcodigo,
			 coalesce(ip.TESTPbanco,'--') as TESTPbanco
			from  TEStransferenciasD tesD
			  inner join TESordenPago tesOP
			     on tesD.TESOPid =  tesOP.TESOPid 
			  inner join    CuentasBancos cb
                on cb.CBid =  tesOP.CBidPago
			  left outer join TEStransferenciaP ip
				on ip.TESTPid	= tesOP.TESTPid		 				
			where tesD.TESTLid = #lista.TESTLid#	
            	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
		</cfquery>	
	
		<cfif rsDetalles.recordcount gt 0 >
			<tr bgcolor="#CCCCCC">     
			  <td align="center" valign="top" nowrap="nowrap"><strong>Número de transacción</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Beneficiario</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Banco Destino</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Fecha Creación</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Moneda</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Monto</strong></td>
			  <td align="center" valign="top" nowrap="nowrap"><strong>Estado de la Transacción</strong></td>
			<tr>  
			 <cfloop query="rsDetalles">
				<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">     
				  <td align="center" valign="top" nowrap="nowrap"><cfoutput>#rsDetalles.TESOPnumero#</cfoutput></td>
				   <td align="center" valign="top" nowrap="nowrap"><cfoutput>#rsDetalles.TESOPbeneficiario#</cfoutput></td>
				  <td align="center" valign="top" nowrap="nowrap"><cfoutput>#rsDetalles.TESTPbanco#</cfoutput></td>
				  <td align="center" valign="top" nowrap="nowrap"><cfoutput>#LSDateFormat(rsDetalles.TESTDfechaGeneracion,'YYYY-mm-dd')#</cfoutput></td>
				  <td align="center" valign="top" nowrap="nowrap"><cfoutput>#rsDetalles.Miso4217Pago#</cfoutput></td>
			      <td align="center" valign="top" nowrap="nowrap"><cfoutput>#NumberFormat(rsDetalles.TESOPtotalPago,'9,9.99')#</cfoutput></td> 
				  <td align="center" valign="top" nowrap="nowrap"><cfoutput>#rsDetalles.TESTDestado#</cfoutput></td>
				<tr>  
			</cfloop>	
		</cfif>		
   </cfloop>
<cfelse>
    <tr align="center">
        <td colspan="7">&nbsp;</td> 
    </tr>
	<tr align="center">
	   <td colspan="7">
	     --------------   No se encontraron registros ----------------
	   </td>
	</tr>
	<tr align="center">
        <td colspan="7">&nbsp;</td> 
    </tr>
</cfif>  
      <tr align="center">
	   <td colspan="7">
	     --------------   fin del reporte ----------------
	   </td>
	  </tr>
</table>




