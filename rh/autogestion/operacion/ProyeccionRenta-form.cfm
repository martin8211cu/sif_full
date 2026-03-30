<!---►►►Variables de Traducción◄◄◄--->
<cfinclude template = "ProyeccionRenta-translate.cfm">
<!---►►►Instancia de Componente de proyeccion de renta◄◄◄--->
<cfset ComProyRenta = createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<!---►►►Acccion del Form◄◄◄--->
<cfif isdefined('Autorizacion')>
	<cfset accion = '/cfmx/rh/nomina/liquidacionRenta/ProyeccionRentaA.cfm'>
<cfelse>
	<cfset accion = '/cfmx/rh/autogestion/operacion/ProyeccionRenta.cfm'>
</cfif>
<!---►►►Obtienen el Paramentro 30: Tabla de Impuesto de Renta◄◄◄--->
<cfset rsIRc		= ComProyRenta.GetParam30()>
<!---►►►Modo Autorizador o Empleado◄◄◄--->
<cfif isdefined('Autorizacion') and Autorizacion>
	<cfset Autorizador = true>
    <cfset FiltroExtra = "and NOT (USRInicia = 'Usuario' and Estado in (0,20))">
<cfelse>
		<cfset Autorizador 		 = false>
        <cfset rsDatosEmpleado   = ComProyRenta.GetEmpleado()>
        <cfset FiltroExtra 		 = " and USRInicia = 'Usuario' and Estado in (0,20)">
    <cfif rsDatosEmpleado.recordcount and len(trim(rsDatosEmpleado.llave))>
    	<cfset form.DEid 	 	 = rsDatosEmpleado.llave>
    <cfelse>
		<cfthrow message="#MSGJS_ERROR_DEID#">
	</cfif>
</cfif>
<!---►►►Paso de variables◄◄◄--->
<cfif NOT isdefined('form.RHRentaId') and isdefined('url.RHRentaId')>
	<cfset form.RHRentaId = url.RHRentaId>
</cfif>
<cfif NOT isdefined('form.DEid') and isdefined('url.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>
<!---►►►Modo Alta o Cambio◄◄◄--->
<cfif isdefined('form.RHRentaId')>
	<cfset Selecccionado = true>
<cfelse>
	<cfset Selecccionado = false>
</cfif>
<!---►►►Portlets de Empleado◄◄◄--->
<cfinclude template="/rh/portlets/pEmpleado.cfm">
<cf_web_portlet_start>
	<cfoutput>
		<cfif Selecccionado>
        	<cfinclude template="ProyeccionRentaDet-form.cfm">
        <cfelse>
            <table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                    	<cf_dbfunction name="dateadd" 	   args="IRfactormeses, EIRdesde,MM" returnvariable="EIRhastaTemp">
                        <cf_dbfunction name="to_sdateDMY"  args="b.EIRdesde" 	  			 returnvariable="EIRdesde">
                        <cf_dbfunction name="to_sdateDMY"  args="#EIRhastaTemp#"  			 returnvariable="EIRhasta">
                        <cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="rsCantidad">
							<cfinvokeargument name="tabla" 		value="RHLiquidacionRenta a
                                                                        inner join EImpuestoRenta b
                                                                            on b.EIRid = a.EIRid
                                                                                inner join ImpuestoRenta c
                                                                                    on c.IRcodigo = b.IRcodigo"/>
							<cfinvokeargument name="columnas" 	value="a.DEid, a.RHRentaId,#EIRdesde# EIRdesde, #EIRhasta# EIRhasta, Nversion, a.USRInicia,
                                                                       case a.Estado 
                                                                          when 0  then 'En Proceso' 
                                                                          when 10 then 'En Revisión'
                                                                          when 20 then 'Rechazado'
                                                                          when 30 then 'Finalizado' end Estado"/>
							<cfinvokeargument name="desplegar" 	value="EIRdesde,EIRhasta, Nversion, Estado, USRInicia"/>
							<cfinvokeargument name="etiquetas" 	value="Fecha Desde, Fecha Hasta, Version,  Estado, Inicio"/>
							<cfinvokeargument name="formatos" 	value=""/>
							<cfinvokeargument name="filtro" 	value="a.DEid = #form.DEid# and a.Tipo = 'P' and a.Estado <> 30 #FiltroExtra# order by EIRdesde"/>
							<cfinvokeargument name="align" 		value="left,left,center,left,left"/>
							<cfinvokeargument name="ajustar" 	value="N,N,N,N,N"/>
							<cfinvokeargument name="keys" 		value="RHRentaId"/>
							<cfinvokeargument name="irA"	 	value="#accion#"/>
							<cfinvokeargument name="maxRows" 	value="20"/>
						</cfinvoke> 
                    </td>
                </tr>
               <cfif NOT rsCantidad>
                    <tr>
                        <td align="center">
                            <cfform>
                                <cfinput name="Nuevo" class="btnNuevo" value="Nuevo" type="button" onClick="fnNewCalcRenta(#form.DEid#,#Autorizador#)">
                            </cfform>
                        </td>
                    </tr>
               </cfif>
            </table>
       </cfif>		
	</cfoutput>
<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
	function fnNewCalcRenta(DEid,Autorizador) {
		var PARAM  = "/cfmx/rh/autogestion/operacion/ProyeccionRenta-PopUp.cfm?Tipo=P&DEid="+DEid+'&Autorizador='+Autorizador;
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400');
		return false;
	}
</script>