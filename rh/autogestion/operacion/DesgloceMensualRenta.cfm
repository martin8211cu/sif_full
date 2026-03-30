<cfif not isdefined('url.RHRentaId')>No se envio ID de la versión (url.RHRentaId)<cfabort></cfif>
<cfif not isdefined('url.RHCRPTid')>No se envio ID de la la linea (url.RHCRPTid)<cfabort></cfif>
<cfif not isdefined('url.Autorizacion')>No se envio el rol del usuario (url.Autorizacion)<cfabort></cfif>

<cfparam name="TotalH" default="0">
<cfparam name="TotalE" default="0">
<cfparam name="TotalA" default="0">

<cfinvoke key="LB_PorcentajeCarga" default="El porcentaje de la carga debe estar entre 0 y 100." returnvariable="LB_PorcentajeCarga" component="sif.Componentes.Translate" method="Translate"/>
<cfset ComProyRenta = createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<cfset rsDatosD = ComProyRenta.GetRHDLiquidacionRenta(url.RHRentaId,url.RHCRPTid)>
<cf_dbfunction name="now" returnvariable="hoy">

<cfquery name="rsPM" datasource="sifcontrol">
    select <cf_dbfunction name="date_part" args="yyyy,#hoy#"> as AnoActual,
           <cf_dbfunction name="date_part" args="mm,#hoy#">   as mesHasta
    from dual
</cfquery>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select a.RHRPTNOrigen, b.RHRPTNcodigo, a.RHCRPTcodigo
    	from RHColumnasReporte a
        	inner join RHReportesNomina b
            	on a.RHRPTNid = b.RHRPTNid
     where a.RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCRPTid#">
</cfquery>
<cfif TRIM(rsReporte.RHCRPTcodigo) EQ 'SalarioBruto'>
	<cfset SalarioBase = true>
<cfelse>
    <cfset SalarioBase = false>
</cfif>
<cfif rsReporte.RHRPTNOrigen NEQ 0>
	<cfif LEN(TRIM(rsDatosD.RHROid))>
    	<cfquery name="rsOrigenes" datasource="#session.dsn#">
        	select RHROid,NIT,FechaIni,FechaFin 
               from RHRentaOrigenes 
             where RHROid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosD.RHROid#">
        </cfquery>
    </cfif>
    <cfif isdefined('rsReporte') and rsReporte.Recordcount GT 0>
    	<cfset RHROid 	= rsOrigenes.RHROid>
		<cfset NIT 		= rsOrigenes.NIT>
        <cfset FechaIni = LSDATEFORMAT(rsOrigenes.FechaIni,'dd/mm/yyyy')>
        <cfset FechaFin = LSDATEFORMAT(rsOrigenes.FechaFin,'dd/mm/yyyy')>
    <cfelse>
    	<cfset RHROid 	= -1>
		<cfset NIT 		= ''>
        <cfset FechaIni = ''>
        <cfset FechaFin = ''>
    </cfif>
    
    <cfform name="formRHRentaOrigenes" method="post">
        <table width="33%" cellpadding="0" cellspacing="0" border="0" align="center">
             <tr><td colspan="2" align="center"><strong>Información de <cfif rsReporte.RHRPTNOrigen EQ 1>Otros <cfelse>Ex-</cfif>Patronos</strong></td></tr>
            <tr>
                <td nowrap="nowrap">
                    Número de identificación tributaria(NIT):
                </td>
                <td width="78%" align="left" nowrap="nowrap">
                    <cfinput name="NIT" id="NIT" type="text" value="#NIT#" onChange="FuncUpdOri(#RHROid#,'NIT',this);">
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Inicio:
                </td>
                <td>
                    <cf_sifcalendario form="formRHRentaOrigenes" name="FechaIni" value="#FechaIni#" tabindex="1" onChange="FuncUpdOri(#RHROid#,'FechaIni',this);">
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Fin:
                </td>
                <td>
                    <cf_sifcalendario form="formRHRentaOrigenes" name="FechaFin" value="#FechaFin#" tabindex="1" onChange="FuncUpdOri(#RHROid#,'FechaFin',this);">
                </td>
            </tr>
        </table>
    </cfform>
</cfif>
<form name="form1" action="DesgloceMensualRenta-sql.cfm" method="post">
<table width="100%" cellpadding="0" cellspacing="0" border="1">
		<tr bgcolor="999999">
                <td align="center"><cf_translate key="LB_Mes">Periodo</cf_translate></td>
                <td align="center"><cf_translate key="LB_Mes">Mes</cf_translate></td>
                <td align="center"><cf_translate key="LB_MontoHistorico">Monto<br>Histórico</cf_translate></td>
                <td align="center"><cf_translate key="LB_MontoEmpleado">Monto<br>Empleado</cf_translate></td>
		  <cfif url.Autorizacion>
				<td align="center"><cf_translate key="LB_MontoAutorizado">Monto<br>Autorizado</cf_translate></td>					
		  </cfif>			
		  <cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) NEQ Ucase('GLRD'))>
			 	<td align="center"><cf_translate key="LB_PorcSeguro">% Seguro<br />Social</cf_translate></td>
		  </cfif>						
		  <cfif SalarioBase>     			
			  	<td align="center"><cf_translate key="LB_RentaRetEmpleado">Renta Retenida <br>Empleado*(Sólo si no está en Históricos) </cf_translate> </td>
		  </cfif>	
		  <cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) EQ Ucase('GLRB'))>					
		  	<cfif url.Autorizacion><td align="center"><cf_translate key="LB_TotalIGSS">Total IGSS AUT <br /></cf_translate> </td>	
			<cfelse>	
				<td align="center"><cf_translate key="LB_TotalIGSS">Total IGSS <br /></cf_translate> </td>													
			</cfif>				
		  </cfif>	
		   <cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) EQ Ucase('GLRB'))> 
		   		<cfif url.Autorizacion><td align="left"><cf_translate key="LB_Observaciones">Observaciones</cf_translate></td>
                <cfelse>
          			<td align="left"><cf_translate key="LB_Obs.">Obs.</cf_translate></td>
          		</cfif>	
           </cfif>
		</tr>
		<cfoutput query="rsDatosD">
        		<cfset LvarUnique  = rsDatosD.Periodo & rsDatosD.Mes>
       	    	<cfset MesesFuturo = true>
      		<cfif rsDatosD.Periodo LTE rsPM.AnoActual and rsDatosD.Mes LTE rsPM.mesHasta>
            	<cfset MesesFuturo = false>
            </cfif>
			<tr>
            	<td align="center">#rsDatosD.Periodo#</td>
				<td align="center">
				<cfswitch expression="#Mes#">
                    <cfcase value="1">
                        <cf_translate key="LB_Enero">Enero</cf_translate>
                    </cfcase>
                    <cfcase value="2">
                        <cf_translate key="LB_Febrero">Febrero</cf_translate>
                    </cfcase>
                    <cfcase value="3">
                        <cf_translate key="LB_Marzo">Marzo</cf_translate>
                    </cfcase>
                    <cfcase value="4">
                        <cf_translate key="LB_Abril">Abril</cf_translate>
                    </cfcase>
                    <cfcase value="5">
                        <cf_translate key="LB_Mayo">Mayo</cf_translate>
                    </cfcase>
                    <cfcase value="6">
                        <cf_translate key="LB_Junio">Junio</cf_translate>
                    </cfcase>
                    <cfcase value="7">
                        <cf_translate key="LB_Julio">Julio</cf_translate>
                    </cfcase>
                    <cfcase value="8">
                        <cf_translate key="LB_Agosto">Agosto</cf_translate>
                    </cfcase>
                    <cfcase value="9">
                        <cf_translate key="LB_Septiembre">Septiembre</cf_translate>
                    </cfcase>
                    <cfcase value="10">
                        <cf_translate key="LB_Octubre">Octubre</cf_translate>
                    </cfcase>
                    <cfcase value="11">
                        <cf_translate key="LB_Noviembre">Noviembre</cf_translate>
                    </cfcase>
                    <cfcase value="12">
                        <cf_translate key="LB_Diciembre">Diciembre</cf_translate>
                    </cfcase>
				</cfswitch>
				</td>
<!---=====Monto Historico============--->
				<td align="right" <cfif NOT MesesFuturo>  bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
                	<cf_inputNumber name="H_#LvarUnique#" value="#rsDatosD.MontoHistorico#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;">
                </td>
<!---=====Monto Empleado============--->
				<cfif  Ucase(trim(rsReporte.RHCRPTcodigo)) NEQ  Ucase('Cuotas')>	
			  		<cfif url.Autorizacion><td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>> 
                        	<cf_inputNumber name="E_#LvarUnique#" value="#LSNumberFormat(rsDatosD.MontoEmpleado, '99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;">
                         </td>
					<cfelse>
                        <td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
                            <cf_inputNumber name="E_#LvarUnique#" value="#LSNumberFormat(rsDatosD.MontoEmpleado,'99.99')#" decimales="2" modificable="true" tabindex="1" style="border: 0; background-color: transparent;" onchange="UpdDesg('MontoEmpleado',#url.RHRentaId#,#url.RHCRPTid#,#rsDatosD.Periodo#,#rsDatosD.Mes#,this);">
                        </td>
					</cfif>	
				<cfelse>	
					<td align="right" <cfif NOT MesesFuturo>  bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
                    	<cf_inputNumber name="E_#LvarUnique#" value="#LSNumberFormat(rsDatosD.MontoEmpleado, '99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;">
                    </td>			
				</cfif>
<!---=====Monto Autorizado============--->				
				<cfif url.Autorizacion><td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>> 
                        <cf_inputNumber name="A_#LvarUnique#" value="#LSNumberFormat(rsDatosD.MontoAutorizado,'99.99')#" decimales="2" modificable="true" tabindex="1" style="border: 0; background-color: transparent;" onchange="UpdDesg('MontoAutorizado',#url.RHRentaId#,#url.RHCRPTid#,#rsDatosD.Periodo#,#rsDatosD.Mes#,this);">
                    </td>
				</cfif>
<!---=====Seguro Social============--->						
				<cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) NEQ Ucase('GLRD'))>
					<td align="center" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
                    	<cf_inputNumber name="S_#LvarUnique#" value="#rsDatosD.PorcCargaSocial#" decimales="2" modificable="true" tabindex="1" style="border: 0; background-color: transparent;" onchange="UpdDesg('PorcCargaSocial',#url.RHRentaId#,#url.RHCRPTid#,#rsDatosD.Periodo#,#rsDatosD.Mes#,this);">
                     </td>
				</cfif>		
 <!---=====Renta Retenida Empleado============--->	               		
				<cfif SalarioBase>							 				  
					<td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
                        <cf_inputNumber name="RetencionRet_#LvarUnique#" value="#LSNumberFormat(rsDatosD.RentaRetenida,'99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;">
                    </td>					
				</cfif>
<!---=====Total IGSS============--->		
				<cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) EQ Ucase('GLRB'))>
					<cfif url.Autorizacion><td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse> bgcolor="CCCCCC" </cfif>> 
                        	<cf_inputNumber name="TotalIGSS_AUT_#LvarUnique#" value="#LSNumberFormat(rsDatosD.IGSSAut, '99.99')#" decimales="2" modificable="false" tabindex="1" style="border:0; background-color: transparent;">
                        </td>
                    <cfelse>
                        <td align="right" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse> bgcolor="CCCCCC"</cfif>> 
                        	<cf_inputNumber name="TotalIGSS_#LvarUnique#" value="#LSNumberFormat(rsDatosD.IGSSEmp, '99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
                    </cfif>	
				</cfif>	
<!---=====Observaciones============--->		
				<cfif (Ucase(trim(rsReporte.RHRPTNcodigo)) EQ Ucase('GLRB'))> 						
					 <td align="center" <cfif NOT MesesFuturo> bgcolor="Yellow" <cfelse>  bgcolor="CCCCCC" </cfif>>
						 <cfif url.Autorizacion><textarea name="O_#LvarUnique#" rows="1" cols="50" onchange="UpdDesg('Observaciones',#url.RHRentaId#,#url.RHCRPTid#,#rsDatosD.Periodo#,#rsDatosD.Mes#,this);" <cfif NOT MesesFuturo> style="background:Yellow; border:thin;" <cfelse>style="background:##CCCCCC;border:thin;"</cfif>>#rsDatosD.Observaciones#</textarea>
                        <cfelseif rsDatosD.Observaciones NEQ 'Sin Observaciones'>
                        	<cfset ButonNotes = '<input name="imageField" type="image" src="../../imagenes/notas2.gif" alt="Notas" width="16" height="16" border="0">'>
                            <cf_notas titulo="Observaciones" link="#ButonNotes#" pageIndex="#rsDatosD.CurrentRow#" msg = "#rsDatosD.Observaciones#" animar="true">
                        </cfif> 
                    </td>
				</cfif>
			</tr>
			<cfset TotalH = TotalH + rsDatosD.MontoHistorico>
			<cfset TotalE = TotalE + rsDatosD.MontoEmpleado>
			<cfset TotalA = TotalA + rsDatosD.MontoAutorizado>			
		 </cfoutput>	
		 <tr> 
                <td align="center" colspan="2"><cf_translate key="LB_Totales">Totales</cf_translate></td>
                <td align="right"><cf_inputNumber name="TotalH" value="#TotalH#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>		
                <td align="right"><cf_inputNumber name="TotalE" value="#TotalE#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>		
			<cfif url.Autorizacion><td align="right"><cf_inputNumber name="TotalA" value="#TotalA#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>		
			</cfif>
		 </tr>		
		<tr><td colspan="<cfif url.Autorizacion>7<cfelse>6</cfif>"><cf_botones values="Cerrar"></td></tr>
</table>
</form>
<table border="0" cellpadding="0" cellspacing="0" align="left">
	<tr>
    	<td bgcolor="Yellow">AMARILLO:</td>
        <td>Renta del Mes Actual o Anteriores</td>
    </tr>
    <tr>
    	<td bgcolor="CCCCCC">GRIS:</td>
        <td>Renta de Meses Futuros</td>
    </tr>
</table>

<iframe frameborder="0" name="frDesglose" height="200" width="200" src=""></iframe>
<script>
	function UpdDesg(column, RHRentaId, RHCRPTid, Periodo, Mes, valor)
	{
		<cfoutput>document.all["frDesglose"].src="DesgloceMensualRenta-sql.cfm?UpdDesg=true&column="+column+"&RHRentaId="+RHRentaId+"&RHCRPTid="+RHCRPTid+"&Periodo="+Periodo+"&Mes="+Mes+"&valor="+escape(valor.value)+"";</cfoutput>
	}
	function FuncUpdOri(RHROid, column, valor)
	{
		<cfoutput>document.all["frDesglose"].src="DesgloceMensualRenta-sql.cfm?UpdOrig=true&RHROid="+RHROid+"&column="+column+"&valor="+valor.value;</cfoutput>
	}
	function Verifica(valor1,valor2){
		if (valor1.value >= valor2.value){
			valor2.value = valor1.value;
		}
	}
	function funcCerrar(){
		if (window.opener != null) {	
			<cfif url.Autorizacion>
				<cfoutput>window.opener.location.href = "/cfmx/rh/nomina/liquidacionRenta/ProyeccionRentaA.cfm?RHRentaId=#url.RHRentaId#&DEid=#rsDatosD.DEid#";</cfoutput>
			<cfelse>
				<cfoutput>window.opener.location.href = "/cfmx/rh/autogestion/operacion/ProyeccionRenta.cfm?RHRentaId=#url.RHRentaId#&DEid=#rsDatosD.DEid#";</cfoutput>
			</cfif>
			window.close();
		}
	}
	function funcGuardar()
	{
	   if (window.opener != null) 
	   {	
		   window.opener.document.filtro1.action = window.opener.document.filtro1.action + "?BTNSeleccionar=true"
		   window.opener.document.filtro1.submit();
	   }
		
	}
	function RecalcularEmp(valorAnt,valorAct){	
		var TotalE = parseFloat(qf(document.form1.TotalE.value));	
		var valorAntCal = parseFloat(valorAnt.value);	
		var valorActIngresado = parseFloat(qf(valorAct.value));		
		var result = Math.round( ((TotalE - valorAntCal) + valorActIngresado) * 100 ) /100;
		document.form1.TotalE.value = 	result;				
	}
	
	function RecalcularIGSS(SeguroSoc,  total, monto) {
		var SeguroSocCal = parseFloat(qf(SeguroSoc.value));
		var montoCal= parseFloat(qf(monto.value));
		var NuevoIgss = (parseFloat(montoCal) * parseFloat(SeguroSocCal)) / 100 ;
		var result =  Math.round(NuevoIgss * 100) / 100;
		total.value= result;	  
	}
	
	function RecalcularAut(valorAnt,valorAct){		
		var TotalA = parseFloat(qf(document.form1.TotalA.value));	
		var valorAntCal = parseFloat(valorAnt.value);		
		var valorActIngresado = parseFloat(qf(valorAct.value));		
		var result = Math.round( ((TotalA - valorAntCal) + valorActIngresado) * 100 ) /100;
		document.form1.TotalA.value = 	result;	
	}
</script>