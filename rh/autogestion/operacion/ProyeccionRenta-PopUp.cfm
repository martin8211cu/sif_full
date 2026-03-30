<!---►►►Paso de Variables◄◄◄--->
<cfif NOT ISDEFINED('form.DEid') and ISDEFINED('url.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<cfif NOT ISDEFINED('form.Autorizador') and ISDEFINED('url.Autorizador')>
	<cfset form.Autorizador = url.Autorizador>
</cfif>
<cfif NOT ISDEFINED('form.Tipo') and ISDEFINED('url.Tipo')>
	<cfset form.Tipo = url.Tipo>
</cfif>
<cfif form.Autorizador>
	<cfset UsuarioInicia ='Autorizacion' >
<cfelse>
	<cfset UsuarioInicia ='Usuario' >
</cfif>
<cfif form.Tipo EQ 'P'>
	<cfset Title = 'Nueva Proyección de Renta'>
    <cfset LabelButon = "Crear Proyección">
<cfelseif form.Tipo EQ 'L'>
	<cfset Title = 'Nueva Liquidación de Renta'>
    <cfset LabelButon = "Crear Liquidación">
</cfif>
<!---►►►Instancia de Componente de proyeccion de renta◄◄◄--->
<cfset ComProyRenta    		= createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<!---►►►Obtencio de la tabla de Renta de la empresa◄◄◄--->
<cfset tablaRenta 	   	    = ComProyRenta.GetParam30()>
<!---►►►Versiones Nuevas, todos aquellos Periodos de Renta, que no han tenido proyecciones◄◄◄--->
<cfset VersionesNuevas 	    = ComProyRenta.GetEImpuestoRenta(form.DEid,tablaRenta.IRcodigo,-1,-1,-1,'(select count(1) from RHLiquidacionRenta d where d.EIRid=a.EIRid and d.DEid=#form.DEid#)=0')>
<!---►►►Versiones Finalizadas, se pueden Clonar Versiones de Proyecciones Finalizadas sin Liquidaciones--->
<cfset F_NoLiquidada 	   = "(select count(1) 
									from RHLiquidacionRenta d 
								 where d.EIRid = a.EIRid 
								   and d.DEid  = #form.DEid# 
								   and d.Tipo  = 'L')=0">
								   
<cfset F_VersionFinalizada = "and (select count(1) 
										from RHLiquidacionRenta d 
									where d.EIRid  = a.EIRid 
									  and d.DEid   = #form.DEid# 
									  and d.Tipo   = 'P' 
									  and d.Estado = 30
									  and d.Nversion = (select max(c.Nversion) 
														   from RHLiquidacionRenta c 
														 where c.EIRid = d.EIRid 
														   and c.DEid  = d.DEid)) > 0">

<cfset VersionesFinalizadas = ComProyRenta.GetEImpuestoRenta(form.DEid,tablaRenta.IRcodigo,-1,-1,-1,"#F_NoLiquidada# #F_VersionFinalizada#")>

<cfif isdefined('form.GUARDAR')>
	<cfset arrayEIRid = listtoarray(form.EIRid)>
    
	<cfif form.Tipo EQ 'P'>
		<!---►►►Proceso de Clonacion de Versiones◄◄◄--->
        <cfif arrayEIRid[1] EQ 'S'>
            <cfquery datasource="#Session.dsn#" name="UltimaVersion">
                select a.RHRentaId,a.EIRid,a.DEid,a.Nversion
                    from RHLiquidacionRenta a
                where a.EIRid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayEIRid[2]#">
                  and a.DEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
                  and a.Tipo	 = 'P'
				  and a.Estado	 = 30
                  and a.Nversion = (select max(Nversion) from RHLiquidacionRenta b where b.EIRid = a.EIRid and b.DEid = a.DEid)
            </cfquery>
            <cfset ComProyRenta.ClonarProyeccionRenta(UltimaVersion.RHRentaId,form.Autorizador)>
        <cfelse>
        <!---►►►Proceso de Clonacion de Versiones◄◄◄--->
        
        <!---►►►Paso 1: Obtencio de la informacion de la tabla de Renta a Crear◄◄◄--->
            <cfset PeriodoRentaActual = ComProyRenta.GetEImpuestoRenta(-1,-1,arrayEIRid[2])>
        <!---►►►Paso 2: Se obtienen los Items del Reporte Dinamico◄◄◄--->        
             <cfset rsFRentaBruta     = ComProyRenta.GetLineasReporte('GLRB')>				<!---Renta Bruta--->
             <cfset rsColumnSalarioB  = ComProyRenta.GetLineasReporte('GLRB','SalarioBruto')><!---Salario Bruto--->
             <cfset rsFDeduc 		  = ComProyRenta.GetLineasReporte('GLRD')>			    <!---Deducciones--->
             <cfset rsFCredito 		  = ComProyRenta.GetLineasReporte('GLRC')>			    <!---Credito Fiscal--->
        <cftransaction>
        <!---►►►Paso 3: Creacion del Encabezado◄◄◄--->
                <cfset RHRentaId = ComProyRenta.AltaRHLiquidacionRenta(form.DEid,PeriodoRentaActual.AnoDesde,arrayEIRid[2],PeriodoRentaActual.MesHasta,1,#UsuarioInicia#)>
        <!---►►►Paso 4:Se Agrega la Renta Bruta◄◄◄---> 
            <cfloop query="rsFRentaBruta">
                <cfif TRIM(rsFRentaBruta.RHCRPTcodigo) EQ 'SalarioBruto'>
                    <cfset Lvar_SalBase = 1>
                <cfelse>
                    <cfset Lvar_SalBase = 0>
                </cfif>               										
                <cfset rsDRentaBruta= ComProyRenta.InsertaDesgloce(RHRentaId,arrayEIRid[2],form.DEid,1,rsFRentaBruta.RHCRPTID, Lvar_SalBase, rsFRentaBruta.RHCRPTcodigo,rsFRentaBruta.RHRPTNcodigo,0,PeriodoRentaActual.AnoDesde,PeriodoRentaActual.MesDesde,PeriodoRentaActual.AnoHasta,PeriodoRentaActual.MesHasta) >                     
            </cfloop>
         <!---►►►Paso 5: Se agregan Deducciones◄◄◄--->
            <cfloop query="rsFDeduc">												
                <cfset rsDLiquidacion= ComProyRenta.InsertaDesgloce(RHRentaId,arrayEIRid[2],form.DEid,1,rsFDeduc.RHCRPTID, 0, rsFDeduc.RHCRPTcodigo, rsFDeduc.RHRPTNcodigo,0,PeriodoRentaActual.AnoDesde,PeriodoRentaActual.MesDesde,PeriodoRentaActual.AnoHasta,PeriodoRentaActual.MesHasta,PeriodoRentaActual.IRcodigo)>																		
            </cfloop>
        <!---►►►Paso 6: Se agrega el credito Fiscal◄◄◄--->
            <cfloop query="rsFCredito">
                <cfset rsDCreditoFiscal= ComProyRenta.InsertaDesgloce(RHRentaId,arrayEIRid[2],form.DEid,1,rsFCredito.RHCRPTID,0, rsFCredito.RHCRPTcodigo, RHRPTNcodigo,0,PeriodoRentaActual.AnoDesde,PeriodoRentaActual.MesDesde,PeriodoRentaActual.AnoHasta,PeriodoRentaActual.MesHasta,PeriodoRentaActual.IRcodigo)>																		
            </cfloop>
        <!---►►►Paso 7:--->
             <cfloop query="rsFRentaBruta">
                <cfif rsFRentaBruta.RHRPTNOrigen NEQ 0>
                    <cfset ComProyRenta.AltaRentaOrigenes(RHRentaId,rsFRentaBruta.RHCRPTid)>
                </cfif>
             </cfloop>
            </cftransaction>
          </cfif>
	<cfelseif form.Tipo EQ 'L'>
    	  <cfquery datasource="#Session.dsn#" name="UltimaVersion">
                select a.RHRentaId,a.EIRid,a.DEid,a.Nversion
                    from RHLiquidacionRenta a
                where a.EIRid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayEIRid[2]#">
                  and a.DEid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
                  and a.Tipo	 = 'P'
				  and a.Estado	 = 30
                  and a.Nversion = (select max(Nversion) from RHLiquidacionRenta b where b.EIRid = a.EIRid and b.DEid = a.DEid)
            </cfquery>
   		<cfset ComProyRenta.CargaProyeccionRenta(UltimaVersion.RHRentaId,form.Autorizador)>
    <cfelse>
    	<cfthrow message="Tipo #form.Tipo# no Implementado">
    </cfif>
    
    <script language="javascript" type="text/javascript">
		if(window.opener.location.href.indexOf('?') == -1)
			postFin = window.opener.location.href.length;
		else
			postFin = window.opener.location.href.indexOf('?');
		window.opener.location.href = window.opener.location.href.substring(0,postFin) +"?DEid=<cfoutput>#form.DEid#</cfoutput>";
		window.close();
	</script>
</cfif>
<cf_templatecss>
<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#Title#">
    <cfoutput>
        <cfform action="ProyeccionRenta-PopUp.cfm" method="post" name="newVersion">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
                <tr>
                    <td align="center">
                    	<input name="DEid" 		  type="hidden" value="#form.DEid#"/>
                        <input name="Autorizador" type="hidden" value="#form.Autorizador#"/>
                        <input name="Tipo" 		  type="hidden" value="#form.Tipo#"/>
                        <select name="EIRid" id="EIRid">
                            <cfif form.Tipo EQ 'P'>
                                <optgroup label="Nuevas Versiones">
                                    <cfloop query="VersionesNuevas">
                                        <option value="N,#VersionesNuevas.EIRid#">Periodo del #lsdateformat(VersionesNuevas.EIRdesde,'DD/MM/YYYY')# al #lsdateformat(VersionesNuevas.EIRhasta,'DD/MM/YYYY')#</option>
                                    </cfloop>
                                </optgroup>
                                <optgroup label="Copia de Versiones">
                                    <cfloop query="VersionesFinalizadas">
                                        <option value="S,#VersionesFinalizadas.EIRid#">Periodo del #lsdateformat(VersionesFinalizadas.EIRdesde,'DD/MM/YYYY')# al #lsdateformat(VersionesFinalizadas.EIRhasta,'DD/MM/YYYY')#</option>
                                    </cfloop>
                                </optgroup>
                            <cfelse>
                            	 <optgroup label="Versiones de Proyecciones Finalizadas">
                                    <cfloop query="VersionesFinalizadas">
                                        <option value="N,#VersionesFinalizadas.EIRid#">Periodo del #lsdateformat(VersionesFinalizadas.EIRdesde,'DD/MM/YYYY')# al #lsdateformat(VersionesFinalizadas.EIRhasta,'DD/MM/YYYY')#</option>
                                    </cfloop>
                                </optgroup>
                            </cfif>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <cfinput name="Guardar" id="Guardar" type="submit" value="#LabelButon#" class="btnAplicar">
                    </td>
                </tr>
            </table>
        </cfform>
        <cf_qforms form="newVersion" objForm="newVersion">
            <cf_qformsRequiredField args="EIRid,Versión de Proyección">
        </cf_qforms>
    </cfoutput>
<cf_web_portlet_end>