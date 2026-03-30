<cfset LvarCBesTCE = 0>
<cfif isdefined("LvarRPregistroFrame")>
	<cfset LvarCBesTCE = 1>
</cfif>


<cfif isdefined("url.ECid") and  not isdefined("form.ECid")>
	<cfset form.ECid = url.ECid>
</cfif>

<cfif isdefined("url.formato") and  not isdefined("form.formato")>
	<cfset form.formato = url.formato>
</cfif>

<cfif isdefined("url.CBesTCE") and  not isdefined("form.CBesTCE")>
	<cfset form.CBesTCE = url.CBesTCE>
</cfif>


<cfset param = "">
<cfif isdefined("form.ECid") and Len(Trim(form.ECid))>
   <cfset param = param & "&ECid=#form.ECid#">
</cfif>

<cfif isdefined("form.formato") and Len(Trim(form.formato))>
   <cfset param = param & "&formato=#form.formato#">
</cfif>

<cfif isdefined("form.CBesTCE") and Len(Trim(form.CBesTCE))>
   <cfset param = param & "&CBesTCE=#form.CBesTCE#">
</cfif>	

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif isdefined('form.formato') and isdefined('form.ECid')>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.ECid,ECdescripcion, ECfecha, CBdescripcion, Bdescripcion, ECsaldoini, ECsaldofin, Mnombre, f.BTEdescripcion, f.BTEcodigo,
			   Documento, DCfecha, DCReferencia, coalesce(DCmontoori, 0.00) as DCmontoori,
               case when ECStatus = 0 then 'En revisión' when ECStatus = 1 then 'Revisado' end as ECStatus,
               ECdebitos,
               ECcreditos,
               coalesce((select case e.CBPTCestatus  
						                        when 10 then'En Digitación'  
						                        when 11 then 'En Proceso' 
												when 12 then 'Emitido' 
												when 13 then 'Anulado' 												 
												end
							 from CBEPagoTCE e inner join CBDPagoTCEdetalle d
						   on e.CBPTCid = d.CBPTCid
						  where
						   d.ECid = a.ECid
	    and not exists (select 1 from CBEPagoTCE g where CBPTCidOri= e.CBPTCid)), 'Sin pago registrado') as CBPTCestatus 
		from ECuentaBancaria a 
			left outer join DCuentaBancaria b
				on a.ECid = b.ECid 
			left outer join Bancos c
				on a.Bid = c.Bid 
			left outer join CuentasBancos d
				on a.Bid = c.Bid 
				and c.Bid = d.Bid 
				and a.CBid = d.CBid 
			left outer join Monedas e
				on d.Ecodigo = e.Ecodigo 
				and d.Mcodigo = e.Mcodigo 
			left outer join TransaccionesBanco f
				on f.Bid = b.Bid
				and f.BTEcodigo = b.BTEcodigo
		where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and coalesce(d.CBesTCE,0) = #form.CBesTCE#
	  		and a.ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	 	order by a.ECid,ECdescripcion, BTEdescripcion, DCfecha
	</cfquery>
     <cfset LvarECid = "">
     <cfset LvarLinea = 1>  
    <cfif isdefined('form.CBesTCE') and form.CBesTCE eq 1 >
      <table align="center" width="100%" border="0">
               <tr>
                  <td colspan="10" align="left">
                  <cf_rhimprime datos="/sif/mb/Reportes/RPRegistroEstadosCtas-frame.cfm" paramsuri="#param#">
                 </td>
               </tr> 
               <tr>
                 <td colspan="10" align="center" bgcolor="#0099FF">              
                     <cfoutput><strong>Estados de Cuenta TCE (Detallado)</strong></cfoutput>              
                 </td>
               </tr>
               <tr>
                 <td colspan="10" bgcolor="#CCCCCC">
                   <cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
                     <cfoutput><strong>#rsEmpresa.Edescripcion#</strong></cfoutput>
                   </cfif>
                 </td>
               </tr>       
               <tr>  
                 <td colspan="10" nowrap="nowrap"> <strong>Fecha del reporte:</strong><cfoutput> #DateFormat(now(),'dd-mm-YYYY')#</cfoutput></td>
               </tr>               			
        <cfloop query="rsReporte"> 		
                   <cfif LvarECid neq rsReporte.ECid> 
                      <cfif  len(trim(LvarECid)) gt 0>
                       <tr>
                         <td colspan="10">
                           <hr width="99%"  align="center"/>
                         </td>
                       </tr>  
                       <tr>
                          <td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>         
                       </tr>  
                      </cfif>    
                      <cfset LvarLinea = 1>                   
                       <tr>
                          <td><strong>Banco</strong>:</td><td nowrap="nowrap"><cfoutput>#rsReporte.Bdescripcion#</cfoutput></td><td><strong>Saldo Anterior:</strong></td><td colspan="7"><cfoutput>#LsNumberFormat(rsReporte.ECsaldoIni,'9,99.99')#</cfoutput></td>         
                       </tr> 
                       <tr>
                          <td><strong>Tarjeta</strong>:</td><td><cfoutput>#rsReporte.CBdescripcion#</cfoutput></td><td><strong>Total Débitos:</strong></td><td colspan="7"><cfoutput>#LsNumberFormat(rsReporte.ECdebitos,'9,99.99')#</cfoutput></td>
                       </tr>
                       <tr>
                          <td><strong>Status</strong>:</td><td><cfoutput>#rsReporte.ECStatus#</cfoutput></td><td><strong>Total Créditos:</strong></td><td colspan="7"><cfoutput>#LsNumberFormat(rsReporte.ECcreditos,'9,99.99')#</cfoutput></td>
                       </tr> 
                       <tr>
                          <td><strong>Moneda</strong>:</td><td><cfoutput>#rsReporte.Mnombre#</cfoutput></td><td><strong>Estado Pago:</strong></td><td colspan="7"><cfoutput>#rsReporte.CBPTCestatus#</cfoutput></td>                       
                       </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><strong>Importe a Pagar:</strong>
                          </td>
                          <td colspan="7"><cfoutput>#LsNumberFormat(rsReporte.ECsaldofin,'9,99.99')#</cfoutput>
                          </td>
                       </tr>                              
                       <tr bgcolor="#CCCCCC"> <td><strong>Línea</strong></td><td><strong>Movimiento</strong></td> <td><strong>Documento</strong></td><td><strong>Referencia</strong></td><td><strong>Fecha</strong></td><td><strong>Moneda</strong></td> <td><strong>Débitos</strong></td><td><strong>Créditos</strong></td>
                       </tr>                       
                  </cfif>    
                  <cfset LvarDocumento = replace(#rsReporte.Documento#,'Estado de Cta:','','all')>
                  <tr>
                    <td><cfoutput>#LvarLinea#</cfoutput></td>
                    <td><cfoutput>#rsReporte.BTEcodigo# - #rsReporte.BTEdescripcion#</cfoutput></td>
                    <td nowrap="nowrap"><cfoutput>#LvarDocumento#</cfoutput></td>
                    <td><cfoutput>#rsReporte.DCReferencia#</cfoutput></td>
                    <td><cfoutput>#DateFormat(rsReporte.DCfecha,'dd-mm-YYYY')#</cfoutput></td>
                    <td><cfoutput>#rsReporte.Mnombre#</cfoutput></td>
                    <td><cfoutput>0.00</cfoutput></td>
                    <td><cfoutput>#LsNumberFormat(rsReporte.DCmontoori,'9,99.99')#</cfoutput></td>
                  </tr>                                                                  
           <cfset LvarLinea = LvarLinea + 1>  
           <cfset LvarECid =  #rsReporte.ECid#>
      </cfloop> 
      <tr>
       <td colspan="10" width="100%" align="center">
           ------------------------------------------------------    Última Línea ---------------------------------------------------------
       </td>
      </tr>
     </table>     
    <cfelse>
       <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
				select Pvalor as valParam
				from Parametros
				where Pcodigo = 20007
				and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
		<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
			<cfset typeRep = 1>
			<cfif form.formato EQ "pdf">
				<cfset typeRep = 2>
			</cfif>
			<cf_js_reports_service_tag queryReport = "#rsReporte#" 
				isLink = False 
				typeReport = typeRep
				fileName = "mb.consultas.RPRegistroEstadosCtas"/>
		<cfelse>
       <cfreport format="#form.formato#" template= "RPRegistroEstadosCtas.cfr" query="rsReporte">
			<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
                <cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
            </cfif>
        </cfreport>
        </cfif>
    </cfif>   
<cfelse>
	<table align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center">-----No hay datos para reportar-----</td></tr>
	</table>
</cfif>