<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ImpresionTransaccionesCajaChica" default = "Impresion de Transacciones de Caja Chica" returnvariable="LB_ImpresionTransaccionesCajaChica" xmlfile = "ConsultaTRAN_form.xml">

    <cf_htmlReportsHeaders 
		title="#LB_ImpresionTransaccionesCajaChica#" 
		filename="Transacciones.xls"
		irA="ConsultaTRAN#LvarCFM#.cfm?regresar=1"
		download="no"
		preview="no"
		>

<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>

<cfif isdefined ('form.tipoMovimiento') and #form.tipoMovimiento# neq 'ALL'>
	 <cfif #form.tipoMovimiento# eq 1>
	  	<cfset LvarFiltro = "'APERTURA','AUMENTO','DISMINUCION','CIERRE'">
	  	<cfset LvarTipoMov = "Afectan Monto Asignado">
	 <cfelseif #form.tipoMovimiento# eq 2>
	  	<cfset LvarFiltro = "'ANTICIPO','GASTO','COMISION'">
	  	<cfset LvarTipoMov = "Entrega de Efectivo">
	 <cfelseif #form.tipoMovimiento# eq 3>
	  	<cfset LvarFiltro = "'REINTEGRO'">
	  	<cfset LvarTipoMov = "Reintegros">
	 </cfif>
<cfelse>
	  	<cfset LvarTipoMov = "TODOS">
</cfif> 	

<cfquery name="rsTransac" datasource="#session.dsn#">
	select CCHTid,tp.CCHcod,(select Usulogin from Usuario where Usucodigo=tp.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
	tp.BMfecha,tp.CCHTtipo, CCHid
	 from CCHTransaccionesProceso tp where CCHid= #form.CCHid#
	<cfif isdefined ('form.tipoMovimiento') and #form.tipoMovimiento# neq 'ALL'>
	 	and CCHTtipo in (#preservesinglequotes(LvarFiltro)#)
     </cfif>
	 <cfif isdefined ('form.TESSPfechaPago_I') and len(trim(form.TESSPfechaPago_I)) gt 0>
	 	and BMfecha >=#LSParseDateTime(form.TESSPfechaPago_I)#
	 </cfif>
	 <cfif isdefined ('form.TESSPfechaPago_F') and len(trim(form.TESSPfechaPago_F)) gt 0>
	 	and BMfecha <=#LSParseDateTime(form.TESSPfechaPago_F)#
	 </cfif>
     order by CCHTid
</cfquery>
<cfquery name="rsCCH" datasource="#session.dsn#">
	select CCHcodigo,CCHdescripcion from CCHica where CCHid= #form.CCHid#
</cfquery>
<cfoutput>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<table width="100%">
	<tr>
		<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong><cf_translate key = LB_TransaccionesCajaChica xmlfile = "ConsultaTRAN_form.xml">Transacciones de Caja Chica</cf_translate>.</strong></td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong><cf_translate key = LB_CajaChica xmlfile = "ConsultaTRAN_form.xml">Caja Chica</cf_translate>:</strong>&nbsp;#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="8"><strong><cf_translate key = LB_TipoMovimiento xmlfile = "ConsultaTRAN_form.xml">Tipo de Movimiento</cf_translate>:</strong>&nbsp;#LvarTipoMov#</td>
	</tr>
<cfloop query="rsTransac"> 
  	<tr>
		<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong><cf_translate key = LB_Transaccion xmlfile = "ConsultaTRAN_form.xml">Transacción</cf_translate>:</strong>&nbsp;&nbsp;#rsTransac.CCHTtipo#</td>
	</tr>
	<tr>
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_SeguimientoTransaccion xmlfile = "ConsultaTRAN_form.xml">Seguimiento de Transacción</cf_translate></strong></td>
	</tr>
	<tr  class="listaPar">
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_Estado xmlfile = "ConsultaTRAN_form.xml">Estado</cf_translate></strong></td>
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_UsuarioAprobador xmlfile = "ConsultaTRAN_form.xml">Usuario Aprobador</cf_translate></strong></td>
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_Fecha xmlfile = "ConsultaTRAN_form.xml">Fecha</cf_translate></strong></td>
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_TransaccionRelacionada xmlfile = "ConsultaTRAN_form.xml">Transaccion Relacionada</cf_translate></strong></td>
		<td align="left" nowrap="nowrap"><strong><cf_translate key = LB_Monto xmlfile = "ConsultaTRAN_form.xml">Monto</cf_translate></strong></td>
	</tr>
       
        <cfquery name="rsRep" datasource="#session.dsn#">
            select CCHTtipo,CCHTestado,(select Usulogin from Usuario where Usucodigo=a.BMUsucodigo and CEcodigo = #session.CEcodigo#) as Usu,
            CCHTfecha, coalesce(CCHTtrelacionada,CCHTtipo) as trans,CCHTtrelacionada,
            CCHTrelacionada,
      <cfif #form.tipoMovimiento# eq 1><!----Afectan Monto Asignado---->
        case when CCHTtipo = 'DISMINUCION' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'DISMINUCION' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)  
             when CCHTtipo = 'APERTURA' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'APERTURA' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)  
             when CCHTtipo = 'AUMENTO' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'AUMENTO' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)     
             when CCHTtipo = 'CIERRE' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'CIERRE' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada) 
              else                        
                  (Select CCHcod from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)                       
           end as rel,            
        case when CCHTtipo = 'DISMINUCION' then              
                    (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)                 
             when CCHTtipo = 'APERTURA' then              
                   (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
             when CCHTtipo = 'AUMENTO' then              
                    (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
             when CCHTtipo = 'CIERRE' then              
                    (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)       
               else                        
               coalesce((select TESSPtipoCambioOriManual * TESSPtotalPagarOri from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada), (select TESOPtotalPago from TESordenPago op where op.TESOPid = a.CCHTrelacionada)) 
               end as monto           
      <cfelseif #form.tipoMovimiento# eq 2><!----Entrega de Efectivo----->
            case when CCHTtipo = 'ANTICIPO'  then 
               (Select GEAnumero from GEanticipo ga where ga.GEAid = a.CCHTrelacionada)
                 when CCHTtipo = 'GASTO' then     
               (Select GELnumero from GEliquidacion gl where gl.GELid = a.CCHTrelacionada)  
             end as rel,  
             case when CCHTtipo = 'ANTICIPO' and CCHTestado = 'CONFIRMADO' then 
               (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#) 
               when CCHTtipo = 'ANTICIPO'  then 
               (Select GEAtotalOri from GEanticipo ga where ga.GEAid = a.CCHTrelacionada) 
              when CCHTtipo = 'GASTO' and CCHTestado = 'CONFIRMADO' then     
               (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#) 
              when CCHTtipo = 'GASTO' then     
               (Select GELtotalAnticipos from GEliquidacion gl where gl.GELid = a.CCHTrelacionada)  
             end as monto  
       <cfelseif #form.tipoMovimiento# eq 3><!----Reintegros ------>
           case  when  CCHTtrelacionada = 'Solicitud de Pago' then                                           
                    (select TESSPnumero from  TESsolicitudPago sp where sp.TESSPid =  a.CCHTrelacionada)
		        when  CCHTtrelacionada = 'Orden de Pago' then                                           
                    (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)
                else
                    (Select CCHcod from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)    
                end
             as rel, 
             case when CCHTtrelacionada = 'Solicitud de Pago' then 
                (select TESSPtipoCambioOriManual * TESSPtotalPagarOri from  TESsolicitudPago sp where sp.TESSPid =  a.CCHTrelacionada)
             when CCHTtrelacionada = 'Orden de Pago' then 
                (select TESOPtotalPago from TESordenPago op where op.TESOPid = a.CCHTrelacionada)
              else  
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
              end   
              as monto
       <cfelse>     <!-----Todas las transacciones------->          
           case when CCHTtrelacionada = 'ANTICIPO' then             
                (Select GEAnumero from GEanticipo ga where ga.GEAid = a.CCHTrelacionada)
          when CCHTtipo = 'DISMINUCION' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'DISMINUCION' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)  
             when CCHTtipo = 'APERTURA' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'APERTURA' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)  
             when CCHTtipo = 'AUMENTO' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'AUMENTO' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)     
             when CCHTtipo = 'CIERRE' and CCHTtrelacionada = 'Solicitud de Pago' then              
               (select TESSPnumero from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada) 
             when CCHTtipo = 'CIERRE' and CCHTtrelacionada = 'Orden de Pago' then  
               (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)                         
            when CCHTtipo = 'GASTO' then              
                (Select GELnumero from GEliquidacion gl where gl.GELid = a.CCHTrelacionada)   
            when CCHTtipo = 'REINTEGRO' and  CCHTtrelacionada = 'Solicitud de Pago' then                           
                (select TESSPnumero from  TESsolicitudPago sp where sp.TESSPid =  a.CCHTrelacionada)
            when CCHTtipo = 'REINTEGRO' and  CCHTtrelacionada = 'Orden de Pago' then                                
                (select TESOPnumero from TESordenPago op where op.TESOPid = a.CCHTrelacionada)
            else    
                (Select CCHcod from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)           
            end
            as rel,             
       case when CCHTtipo = 'ANTICIPO' and CCHTestado = 'CONFIRMADO' then 
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#) 
            when CCHTtrelacionada = 'ANTICIPO' then            
                (Select GEAtotalOri from GEanticipo ga where ga.GEAid = a.CCHTrelacionada)                 
            when CCHTtipo ='APERTURA' then
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#) 
            when CCHTtipo = 'AUMENTO' then              
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
            when CCHTtipo = 'CIERRE' then              
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
            when CCHTtipo = 'DISMINUCION' then              
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)
            when CCHTtipo = 'GASTO' and CCHTestado = 'CONFIRMADO'  then   
                (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#) 
           when CCHTtipo = 'GASTO' then              
                (Select GELtotalAnticipos from GEliquidacion gl where gl.GELid = a.CCHTrelacionada)     
           when CCHTtipo = 'REINTEGRO' and CCHTtrelacionada = 'Solicitud de Pago' then                                           
                    (select TESSPtipoCambioOriManual * TESSPtotalPagarOri from  TESsolicitudPago sp where sp.TESSPid =  a.CCHTrelacionada)
		   when CCHTtipo = 'REINTEGRO' and CCHTtrelacionada = 'Orden de Pago' then                                           
                    (select TESOPtotalPago from TESordenPago op where op.TESOPid = a.CCHTrelacionada)
           when CCHTtipo = 'REINTEGRO' then  
                    (Select CCHTmonto from CCHTransaccionesProceso tp where tp.CCHTid = #rsTransac.CCHTid#)             
             else 
                coalesce((select TESSPtipoCambioOriManual * TESSPtotalPagarOri from  TESsolicitudPago  sp where sp.TESSPid =  a.CCHTrelacionada), (select TESOPtotalPago* TESOPtipoCambioPago from TESordenPago  op where op.TESOPid = a.CCHTrelacionada))       
            end             
            as monto    
       </cfif>              
             from STransaccionesProceso a
              
               left outer join  TESsolicitudPago b 
                    on a.CCHTrelacionada = b.TESSPid                   
              
               left outer join  TESordenPago c
                    on a.CCHTrelacionada = c.TESOPid                                           
                                         
             where CCHTid = #rsTransac.CCHTid#
            <cfif isdefined ('form.tipoMovimiento') and #form.tipoMovimiento# neq 'ALL'>
	 	         and CCHTtipo in (#preservesinglequotes(LvarFiltro)#)
             </cfif>                
         </cfquery>    
        <cfloop query="rsRep">
            <tr>
                <td align="left" nowrap="nowrap">#rsRep.CCHTestado#</td>
                <td align="left" nowrap="nowrap">#rsRep.Usu#</td>
                <td align="left" nowrap="nowrap">#LSDateFormat(rsRep.CCHTfecha,'DD/MM/YYYY')#</td>
                <td align="left" nowrap="nowrap">#rsRep.trans# #rsRep.rel#</td>
                <td align="left" nowrap="nowrap">#LsNumberFormat(rsRep.monto,'9,9.99')#</td>
            </tr>
        </cfloop>
        <tr>
            <td>&nbsp;
             
            </td>
        </tr>

</cfloop>
</table>
</cfoutput>
