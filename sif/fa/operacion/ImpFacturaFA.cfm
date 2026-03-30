<cfparam name="LvarXproveedor"  default="FALSE">
<cfparam name="LvarPrint" 		default="FALSE">

<style type="text/css">
	
	.TituloPrincipal {
		font-size: 18px;
		font-weight: bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraTitulo{
		font-size: 12px;
		font-weight: bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraEncab{
		font-size:12px;
		font-weight:bold;
		font-family:Arial, Helvetica, sans-serif
	}
	.LetraInfo{
		font-size:12px;
		font-family:Arial, Helvetica, sans-serif
	}	
	
	body {
		overflow-x: hidden;
		margin: 0;
	}

</style>

<script language="JavaScript1.2" type="text/javascript">
	<cfoutput>
	<cfparam name="url.RegresarA" default="ImpresionFacturasFA.cfm?tipo=R">
	printThis();
	<!--
	function printThis() {
	window.print();
	self.close();
	window.opener.location.href = '#Url.RegresarA#';
	}
	//-->
	</cfoutput>
</script>

<cfquery name="Empresa" datasource="#Session.DSN#">
	select Edescripcion,ETelefono1,EDireccion1,ts_rversion,EIdentificacion   from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsTransaccionE" datasource="#Session.DSN#">
    select *
    from ETransacciones 
    where Ecodigo = #Session.Ecodigo#
    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.caja#">
    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.transaccion#">				  
</cfquery>

<cfquery name="rsTransaccionD" datasource="#Session.DSN#">
    select *
    from DTransacciones 
    where Ecodigo = #Session.Ecodigo#
    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.caja#">
    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.transaccion#">	
    and DTborrado = 0			  
</cfquery>

<cfquery name="rsSubTotal" datasource="#Session.DSN#">
    select sum(DTtotal) as subtotal 
    from DTransacciones 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.caja#">		
    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.transaccion#">
    and DTborrado = 0
</cfquery>

<cfquery name="rsFPagoT" datasource="#Session.DSN#">
    select sum(FPmontolocal) as FPmontolocal
    from FPagos
    where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.caja#">		
    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.transaccion#">
</cfquery>

<cfquery name="rsFPago" datasource="#Session.DSN#">
    select Tipo, coalesce(FPtipotarjeta,0) as FPtipotarjeta, coalesce(FPautorizacion,'no') as FPautorizacion, FPdocnumero, FPmontolocal
    from FPagos
    where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.caja#">		
    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.transaccion#">
    group by Tipo, FPdocnumero, FPtipotarjeta, FPautorizacion, FPmontolocal
</cfquery>

<cfoutput>
    <cfquery name="Comprador" datasource="#session.dsn#">
        select  SNcodigo, SNnombre
        from SNegocios
        where Ecodigo = #session.Ecodigo#
        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccionE.SNcodigo#">	 
    </cfquery>
    
    <cfquery name="Caja" datasource="#session.dsn#">
        select FCcodigo 
        from FCajas
        where Ecodigo = #session.Ecodigo#
        and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransaccionE.FCid#">	 
    </cfquery>
    
    <cfquery name="Cajero" datasource="#session.dsn#">
        select  Pnombre, Papellido1
        from DatosPersonales d 
        inner join Usuario u 
        on u.datos_personales = d.datos_personales
        where u.Usucodigo = #rsTransaccionE.Usucodigo#   
    </cfquery>
    
    <table width="100%" border="0" cellpadding="2" cellspacing="1" align="center">
        <tr>
        	<td colspan="6">
        		<table align="center" width="100%" border="0" cellpadding="0" cellspacing="3">
        			<cfset PrintHeader()>
        			<tr>
                        <td class="LetraTitulo">CLIENTE:</td>
                        <td colspan="2" class="LetraInfo" nowrap="nowrap"><cfoutput>#Comprador.SNnombre#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraTitulo">NOMBRE:</td>
                        <td colspan="2" class="LetraInfo" nowrap="nowrap"><cfoutput>#rsTransaccionE.ETnombredoc#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraTitulo">FACTURA ##:</td>
                        <td class="LetraInfo"><cfoutput>#rsTransaccionE.ETdocumento##rsTransaccionE.ETserie# - #rsTransaccionE.ETnumero#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraTitulo" nowrap="nowrap">VENDEDOR:</td>
                        <td class="LetraInfo"><cfoutput>#Cajero.Pnombre#&nbsp;#Cajero.Papellido1#</cfoutput></td>
                    </tr>
                    <tr>
                        <td class="LetraTitulo" nowrap="nowrap">FECHA:</td>
                        <td class="LetraInfo"><cfoutput>#dateformat(rsTransaccionE.ETfecha,'dd-mm-yyyy')#&nbsp;&nbsp;#TimeFormat(rsTransaccionE.ETfecha, 'hh:mm:sstt')#</cfoutput></td>
                    </tr>
	        	</table>  
    	 	</td>
        </tr>
        <cfset PrintLineasHeader()>  
        
        <cfloop query="rsTransaccionD">
        	<cfset rsVariablesFac = ""> 
        	<cfif isdefined ("rsTransaccionD.Cid") and rsTransaccionD.Cid gt 0>
            	
                <cfset CCid = -1>
                <cfquery name="rsClasificacion" datasource="#Session.DSN#">
                    select c.CCid
                    from CConceptos cc
                    inner join Conceptos c
                    on c.CCid = cc.CCid
                    and c.Ecodigo = cc.Ecodigo
                    where c.Cid = #rsTransaccionD.Cid#
                    and c.Ecodigo = #session.Ecodigo#
                </cfquery>
				<cfif isdefined ("rsClasificacion.CCid") and rsClasificacion.CCid gt 0>
                	<cfset CCid = rsClasificacion.CCid>
                </cfif>
                
                
                <cfquery name="rsVariablesFac" datasource="#Session.DSN#">
                    select dv.DVetiqueta, dv.DVtipoDato, coalesce(v.DVVvalor,'0') as DVVvalor, ct.DVCid, ct.DVid
                        from DVconfiguracionTipo ct
                        inner join DVdatosVariables dv
                            on dv.DVid = ct.DVid
                            and dv.Ecodigo = #session.Ecodigo# 
                        inner join DVvalores v
                            on v.DVTcodigoValor = ct.DVTcodigoValor 
                            and v.DVid = ct.DVid
                            and v.DVVidTablaVal = #rsTransaccionD.DTlinea#
                        where ct.DVTcodigoValor = 'FA'
                       	       and ct.DVTcodigo = 'FA'
            		union
                    select dv.DVetiqueta, dv.DVtipoDato, coalesce(v.DVVvalor,'0') as DVVvalor, ct.DVCid, ct.DVid
                        from DVconfiguracionTipo ct
                        inner join DVdatosVariables dv
                            on dv.DVid = ct.DVid
                            and dv.Ecodigo = #session.Ecodigo# 
                        inner join DVvalores v
                            on v.DVTcodigoValor = ct.DVTcodigoValor 
                            and v.DVid = ct.DVid
                            and v.DVVidTablaVal = #rsTransaccionD.DTlinea#
                        where ct.DVTcodigoValor = 'FA'
                               and ct.DVTcodigo = 'FA_CLASIF'
                           and ct.DVCidTablaCnf = #CCid#
                    union
                    select dv.DVetiqueta, dv.DVtipoDato, coalesce(v.DVVvalor,'0') as DVVvalor, ct.DVCid, ct.DVid
                        from DVconfiguracionTipo ct
                        inner join DVdatosVariables dv
                            on dv.DVid = ct.DVid
                            and dv.Ecodigo = #session.Ecodigo# 
                        inner join DVvalores v
                            on v.DVTcodigoValor = ct.DVTcodigoValor 
                            and v.DVid = ct.DVid
                            and v.DVVidTablaVal = #rsTransaccionD.DTlinea#
                        where ct.DVTcodigoValor = 'FA'
                               and ct.DVTcodigo = 'FA_CONCEP'
                           and ct.DVCidTablaCnf = #rsTransaccionD.Cid#
                    order by ct.DVCid
                </cfquery>
                
            </cfif>
            <cfset PrintLineas()>
            <cfif isdefined ("rsVariablesFac.DVVvalor") and rsVariablesFac.recordcount gt 0>
               <tr> 
                    <td colspan="5">
                        <table border="0" width="100%" cellpadding="-2" cellspacing="-2">           
                        <cfloop query="rsVariablesFac">
                        	
                        	<cfif len(trim(rsVariablesFac.DVVvalor))>
                            	<cfset PrintCVariables()>		
                            </cfif>
                        </cfloop>                            
                        </table>
                    </td>
                </tr>
            </cfif>
        </cfloop> 
        
        <cfset PrintTotal()>  
        
        <cfset PrintFooter()>  
    </table>
</cfoutput>

<cffunction name="Printheader" output="yes">
    <tr>
    	<td  colspan="6" class="TituloPrincipal" align="center">#Empresa.Edescripcion#</td>    
    </tr>
    <tr>
    	<td  colspan="6" align="center"><span class="LetraInfo">C&eacute;dula Jur&iacute;dica: #Empresa.EIdentificacion#</span></td>    
    </tr>
    <tr>
    	<td  colspan="6" align="center"><span class="LetraInfo">#Empresa.EDireccion1#</span></td>    
    </tr>
    <tr>
    	<td  colspan="6" align="center"><span class="LetraInfo">#Empresa.ETelefono1#</span></td>    
    </tr>
    <tr>
    	<td colspan="6">&nbsp;</td>
    </tr>
</cffunction>

<cffunction name="PrintLineasHeader">
    <tr><td colspan="5"><hr style="border-top-width: 2px;"></hr></td><tr>  
    <tr>
        <td class="LetraEncab" align="center">CANT.</td>
        <td class="LetraEncab"  width="60%" align="left">DESCRIPCI&Oacute;N</td>
        <td class="LetraEncab"  align="right">TOTAL</td>			
    </tr>
    <tr><td colspan="5"><hr style="border-top-width: 2px;"/></td><tr>
</cffunction>

<cffunction name="PrintLineas" output="yes">
    <tr>
        <td  class="LetraInfo" align="center" ><cfoutput>#rsTransaccionD.DTcant#</cfoutput>&nbsp;</td>
        <td  class="LetraInfo" width="60%" align="left"><cfoutput>#rsTransaccionD.DTdescripcion#</cfoutput>&nbsp;</td>
        <td  class="LetraInfo" align="right"><cfoutput>#LSCurrencyFormat(rsTransaccionD.DTtotal, 'none')#</cfoutput>&nbsp;</td>                 
    </tr>	
</cffunction>

<cffunction name="PrintCVariables" output="yes">
    <cfif rsVariablesFac.DVtipoDato eq 'L'>
    	<cfquery name="rsListaV" datasource="#Session.DSN#">
        	select DVLdescripcion 
            from DVlistaValores
            where DVid = #rsVariablesFac.DVid#
            and DVLcodigo = '#rsVariablesFac.DVVvalor#'
        </cfquery>
        <cfset rsVariablesFac.DVVvalor = rsListaV.DVLdescripcion>
	<cfelseif rsVariablesFac.DVtipoDato eq 'H'>
    	<cfset LvarHHMM = int(rsVariablesFac.DVVvalor / 60)>
		<cfset rsVariablesFac.DVVvalor = "#numberFormat(LvarHHMM,"00")#:#numberFormat(LvarMinutos - LvarHHMM*60,"00")#">
    </cfif>
    
    <tr>
        <td  colspan="1" align="center" width="45">&nbsp;</td>
        <td  class="LetraInfo" style="padding:0;" width="1" nowrap="nowrap">
			<cfoutput>#rsVariablesFac.DVetiqueta#:</cfoutput>&nbsp;&nbsp;
        </td>
        <td  class="LetraInfo" colspan="3" >
			<cfoutput>#rsVariablesFac.DVVvalor#</cfoutput>
        </td>
    </tr>	
</cffunction>

<cffunction name="PrintTotal" output="yes">
    
    <tr><td colspan="5"><hr style="border-top-width: 2px;"/></td><tr>  
    <tr>
    	<td colspan="5">
        	<table border="0" align="center" width="100%" cellpadding="0" cellspacing="3">
                
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" align="left">Subtotal..........:</td>
                    <td class="LetraInfo" align="right" style="width: 100px;"><cfoutput>#LSCurrencyFormat(rsSubTotal.subtotal, 'none')#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" align="left">I.V....................:</td>
                    <td class="LetraInfo" align="right"><cfoutput>#LSCurrencyFormat(rsTransaccionE.ETimpuesto, 'none')#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" align="left">Descuento......:</td>
                    <td class="LetraInfo" align="right"><cfoutput>#LSCurrencyFormat(rsTransaccionE.ETmontodes, 'none')#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" nowrap="nowrap" align="left" style="font-size:18px; font-family:Verdana, Geneva, sans-serif; width:74px;">TOTAL..:</td>
                    <td class="LetraInfo" nowrap="nowrap" align="right" style="font-size:16px;"><strong><cfoutput>#LSCurrencyFormat(rsTransaccionE.ETtotal, 'none')#</cfoutput></strong></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" align="left">Monto Canc....:</td>
                    <td class="LetraInfo" align="right"><cfoutput>#LSCurrencyFormat(rsFPagoT.FPmontolocal, 'none')#</cfoutput></td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                    <td class="LetraTitulo" align="left">Cambio...........:</td>
                    <cfset cambio = rsFPagoT.FPmontolocal - rsTransaccionE.ETtotal>
                    <td class="LetraInfo" align="right"><cfoutput>#LSCurrencyFormat(cambio, 'none')#</cfoutput></td>
                </tr>
    		</table>
    	</td>  
    </tr>  
</cffunction> 

<cffunction name="PrintFooter" output="yes">
    <tr><td colspan="5"><hr style="border-top-width: 2px;" /></td><tr>  
    <tr>
        <td class="LetraInfo" align="center" colspan="5" nowrap="nowrap"><strong>Forma de Pago&nbsp;</strong></td>
    </tr>
    
        <tr>
            <td colspan="5"> 
            	<table align="center" width="100%" border="0">
                	<tr>
                    	<td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>Tipo de pago</strong></td>
                        <td class="LetraInfo" align="left" colspan="2" nowrap="nowrap"><strong>No. Documento</strong></td>
                        <td class="LetraInfo" align="right" colspan="1" nowrap="nowrap"><strong>Monto</strong></td>
                    </tr>
                    <cfoutput query="rsFPago">
                    <tr>
                    	<cfif rsFPago.Tipo eq 'E'>
                		<td align="left" colspan="2" class="LetraInfo">EFECTIVO&nbsp;</td>
            			<td align="left" colspan="2" class="LetraInfo">--</td>
						<cfelseif rsFPago.Tipo eq 'T'>
                		<td align="left" colspan="2" class="LetraInfo">TARJETA&nbsp;</td>
                        <td align="left" colspan="2" class="LetraInfo">#rsFPago.FPautorizacion#</td>
            			<cfelseif rsFPago.Tipo eq 'D'>
                		<td align="left" colspan="2" class="LetraInfo">DEPOSITO&nbsp;</td>
                        <td align="left" colspan="2" class="LetraInfo">#rsFPago.FPdocnumero#</td>
            			<cfelseif rsFPago.Tipo eq 'C'>
                		<td align="left" colspan="2" class="LetraInfo">CHEQUE&nbsp;</td>
                        <td align="left" colspan="2" class="LetraInfo">#rsFPago.FPdocnumero#</td>
            			<cfelseif rsFPago.Tipo eq 'A'>
                		<td align="left" colspan="2" class="LetraInfo">DOCUMENTO&nbsp;</td>
                        <td align="left" colspan="2" class="LetraInfo">#rsFPago.FPdocnumero#</td>
                        </cfif>
                    	<td align="right" colspan="1" class="LetraInfo">#LSCurrencyFormat(rsFPago.FPmontolocal, 'none')#</td>
                    </tr>
					</cfoutput> 
                </table>
            </td>
        </tr>
    
    <tr><td colspan="5">&nbsp;</td><tr>  
    <tr>
 	   <td class="LetraTitulo" align="center" colspan="5">MUCHAS GRACIAS POR SU PREFERENCIA</td>
    </tr>
    <tr>
    	<td colspan="5">&nbsp;</td>
    </tr>     
</cffunction>
