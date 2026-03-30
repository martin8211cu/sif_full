<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Puestos"
	Default="Puestos"
	returnvariable="LB_Puestos"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Factores"
	Default="Factores"
	returnvariable="LB_Factores"/>  

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Sin_Centro_Funcional"
	Default="Sin Centro Funcional"
	returnvariable="LB_Sin_Centro_Funcional"/>      


<cfset LST_SALARIO = "">
<cfset LST_PUNTOS = "">
<cfset LST_AJUSTE1 = "">
<cfset LST_AJUSTE2 = "">
<cfset LST_AJUSTE3 = "">


<cfif isdefined("url.Tipo") and not isdefined("form.Tipo")>
	<cfset form.Tipo = url.Tipo>
</cfif>
<cfif not isdefined("form.Tipo")>
	<cfset form.Tipo = "1">
</cfif>

<cfif isdefined("url.AJUSTE1") and not isdefined("form.AJUSTE1")>
	<cfset form.AJUSTE1 = url.AJUSTE1>
</cfif>

<cfif not isdefined("url.AJUSTE1") and not isdefined("form.AJUSTE1")>
	<cfset RSAJUSTE1 = ObtenerDato(850)>
	<cfset form.AJUSTE1 = RSAJUSTE1.Pvalor>
</cfif>

<cfif isdefined("url.AJUSTE2") and not isdefined("form.AJUSTE2")>
	<cfset form.AJUSTE2 = url.AJUSTE2>
</cfif>

<cfif not isdefined("url.AJUSTE2") and not isdefined("form.AJUSTE2")>
	<cfset RSAJUSTE2 = ObtenerDato(860)>
	<cfset form.AJUSTE2 = RSAJUSTE2.Pvalor>
</cfif>



<cfquery name="rsRHValoracionPuesto" datasource="#session.DSN#">
     select RHVPfhasta,RHVtipoInterno ,RHVAjuste1Interno ,RHVAjuste2Interno from RHValoracionPuesto
     where RHVPid =  <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif not isdefined("form.radTipo")  and isdefined("rsRHValoracionPuesto.RHVtipoInterno") and len(trim(rsRHValoracionPuesto.RHVtipoInterno))>
	<cfset form.radTipo = rsRHValoracionPuesto.RHVtipoInterno>
</cfif>

<cfif not isdefined("form.AJUSTE1")  and isdefined("rsRHValoracionPuesto.RHVAjuste1Interno") and len(trim(rsRHValoracionPuesto.RHVAjuste1Interno))>
	<cfset form.AJUSTE1 = rsRHValoracionPuesto.RHVAjuste1Interno>
</cfif>

<cfif not isdefined("form.AJUSTE2")  and isdefined("rsRHValoracionPuesto.RHVAjuste2Interno") and len(trim(rsRHValoracionPuesto.RHVAjuste2Interno))>
	<cfset form.AJUSTE2 = rsRHValoracionPuesto.RHVAjuste2Interno>
</cfif>

<cfquery name="rsPuesto" datasource="#session.DSN#">
    select a.RHPcodigo,coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext ,a.RHPdescpuesto,
    case when x.CFcodigo is not null then
        {fn concat(x.CFcodigo,{fn concat('-',x.CFdescripcion)})}
    else
        '#LB_Sin_Centro_Funcional#'
    end as  CFdescripcion,
    (select sum(LTsalario)/count(DEid) from LineaTiempo b
        inner join RHPlazas c
            on  b.RHPid   = c.RHPid 
            and b.Ecodigo = c.Ecodigo
            <cfif VARUsaPropuestos eq 1 >
                and c.RHPpuesto  in (select z.RHPcodigoH  from RHPuestosH z  where z.Ecodigo  = a.Ecodigo  and z.RHPcodigo =  a.RHPcodigo ) 
            <cfelse>
                and c.RHPpuesto = a.RHPcodigo 
            </cfif> 
        where a.Ecodigo = b.Ecodigo
         and <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta 
     ) as salariopromedio,
	coalesce((select  sum(z.RHGporcvalorfactor)
    from RHGradosFactorPuesto  x
         inner join RHGrados z
            on x.RHFid = z.RHFid
            and x.RHGid = z.RHGid
    where    x.RHPcodigo   	= a.RHPcodigo
    and    x.Ecodigo   		= a.Ecodigo 
    and    x.RHVPid         = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     ),0) as Puntos,coalesce(a.RHPropuesto,0) as RHPropuesto,RHPactivo
    from RHPuestos a
    left outer join CFuncional x
        on  a.Ecodigo = x.Ecodigo
        and a.CFid    = x.CFid    
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
     <cfif VARUsaPropuestos eq 1>
		and coalesce(a.RHPropuesto,0) = 1 and a.RHPactivo = 0
	<cfelse>
    	and  coalesce(a.RHPropuesto,0) = 0
	</cfif>
    and (select sum(LTsalario)/count(DEid) from LineaTiempo b
        inner join RHPlazas c
            on  b.RHPid   = c.RHPid 
            and b.Ecodigo = c.Ecodigo
            <cfif VARUsaPropuestos eq 1 >
                and c.RHPpuesto  in (select z.RHPcodigoH  from RHPuestosH z  where z.Ecodigo  = a.Ecodigo  and z.RHPcodigo =  a.RHPcodigo ) 
            <cfelse>
                and c.RHPpuesto = a.RHPcodigo 
            </cfif> 
        where a.Ecodigo = b.Ecodigo
         and <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta 
     ) > 0
     and 
     coalesce((select  sum(z.RHGporcvalorfactor)
    from RHGradosFactorPuesto  x
         inner join RHGrados z
            on x.RHFid = z.RHFid
            and x.RHGid = z.RHGid
    where    x.RHPcodigo   	= a.RHPcodigo
    and    x.Ecodigo   		= a.Ecodigo 
    and    x.RHVPid         = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     ),0) > 0
    Order by Puntos,RHPdescpuesto
</cfquery>

<cfquery name="rs_ajustesX" datasource="#session.DSN#">
    select RHPcodigo,RHDPAjuste1,RHDPAjuste2,RHDPAjuste3
    from RHDispersionPuesto  
    where  RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
    and    RHPcodigo    = <cfqueryparam value="#rsPuesto.RHPcodigo#" 		cfsqltype="cf_sql_char">
</cfquery>


<!--- <cfif rs_ajustesX.recordCount GT 0 and len(trim(rs_ajustesX.RHDPAjuste1)) gt 0 and len(trim(rs_ajustesX.RHDPAjuste2)) gt 0 and len(trim(rs_ajustesX.RHDPAjuste3)) gt 0  and not isdefined("form.btnRecalcular")>
    <cfset FORM.AJUSTE1 =  round((rs_ajustesX.RHDPAjuste2 - rs_ajustesX.RHDPAjuste1)*100 / rs_ajustesX.RHDPAjuste1)>
    <cfset FORM.AJUSTE2 =  round((rs_ajustesX.RHDPAjuste3 - rs_ajustesX.RHDPAjuste1)*100 / rs_ajustesX.RHDPAjuste1)>
</cfif> --->
<cfinclude template="calculos.cfm">


<cfset totalcel =  6>
<cfset TamCel   =  100 /(totalcel)>
<cfset VarRHPcodigo   =  "">
<cfset VarRHPcodigoForm   =  ""> 
<cfset VarCFdescripcion  =  ""> 
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
		
</style>
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="SQLDispersionPuesto.cfm">
  <input type="hidden" name="SEL" value="3">
  <input type="hidden" name="RHVPid" value="<cfoutput>#form.RHVPid#</cfoutput>">
  <cfoutput>
  
  
  
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr>
        	<td  colspan="5" sclass="RLTtopline" align="center"><b><font  style="font-size:10px"><cf_translate  key="LB_Coeficientes_de_Determinacion ">Coeficientes de Determinaci&oacute;n</cf_translate></font></b></td>
        </tr>
        <tr>
        	<td class="LTtopline" align="center">&nbsp;</td>
            <td class="LTtopline" align="center">
                <input name="radTipo"  id="radTipo0" type="radio" tabindex="1" value="1" onClick="javascript: funcRecalcular();" 
				<cfif not isdefined("form.radTipo") and  R_LINEAL LT 1 and R_LINEAL GT 0  and  R_LINEAL GT R_EXPONENCIAL and  R_LINEAL GT R_LOGARITMICA and  R_LINEAL GT R_POTENCIAL>
                    checked
                <cfelseif isdefined("form.radTipo") and form.radTipo eq 1 >
                    checked
                </cfif>>      
                <label for="radTipo0"><b><font  style="font-size:10px"><cf_translate  key="LB_Lineal">Lineal</cf_translate></font></b></label>
            </td>
            <td class="LTtopline" align="center">
                <input name="radTipo"  id="radTipo1" type="radio" tabindex="1" value="2" onClick="javascript: funcRecalcular();"
                <cfif not isdefined("form.radTipo") and  R_EXPONENCIAL LT 1 and R_EXPONENCIAL GT 0  and  R_EXPONENCIAL  GT R_LINEAL  and  R_EXPONENCIAL GT R_LOGARITMICA and  R_EXPONENCIAL GT R_POTENCIAL>
                    checked
                <cfelseif isdefined("form.radTipo") and form.radTipo eq 2 >
                    checked
                </cfif>>      
                <label for="radTipo1"><b><font  style="font-size:10px"><cf_translate  key="LB_Exponencial">Exponencial</cf_translate></font></b></label>
            </td>
            <td class="LTtopline" align="center">
                <input name="radTipo"  id="radTipo2" type="radio" tabindex="1" value="3" onClick="javascript: funcRecalcular();"
                <cfif not isdefined("form.radTipo") and  R_LOGARITMICA LT 1 and R_LOGARITMICA GT 0  and  R_LOGARITMICA  GT R_LINEAL  and  R_LOGARITMICA  GT R_EXPONENCIAL and  R_LOGARITMICA GT R_POTENCIAL>
                    checked
                <cfelseif isdefined("form.radTipo") and form.radTipo eq 3 >
                    checked
                </cfif>>                   
                <label for="radTipo2"><b><font  style="font-size:10px"><cf_translate  key="LB_Logaritmica">logar&iacute;tmica</cf_translate></font></b></label>
            </td>
            <td class="RLTtopline" align="center">
                <input name="radTipo"  id="radTipo3" type="radio" tabindex="1" value="4"  onClick="javascript: funcRecalcular();"
				<cfif not isdefined("form.radTipo") and  R_POTENCIAL LT 1 and R_POTENCIAL GT 0  and  R_POTENCIAL  GT R_LINEAL  and  R_POTENCIAL  GT R_EXPONENCIAL and  R_POTENCIAL  GT R_LOGARITMICA>
                    checked
                <cfelseif isdefined("form.radTipo") and form.radTipo eq 4 >
                    checked
                </cfif>>                 
                      
                <label for="radTipo3"><b><font  style="font-size:10px"><cf_translate  key="LB_Logaritmica">Potencial</cf_translate></font></b></label>
            </td>
        </tr>  
    	<tr>
        	<td class="LTtopline" align="center"><b><font  style="font-size:10px"><cf_translate  key="LB_R">R</cf_translate></font></b></td>
          <td class="LTtopline"   
            <cfif  R_LINEAL LT 1 and R_LINEAL GT 0  and  R_LINEAL GT R_EXPONENCIAL and  R_LINEAL GT R_LOGARITMICA and  R_LINEAL GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style=" font-size:10px">#LSNumberFormat(R_LINEAL,',.0000')#</font></td>
            
            <td class="LTtopline" 
			<cfif   R_EXPONENCIAL LT 1 and R_EXPONENCIAL GT 0  and  R_EXPONENCIAL  GT R_LINEAL  and  R_EXPONENCIAL GT R_LOGARITMICA and  R_EXPONENCIAL GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style="font-size:10px">#LSNumberFormat(R_EXPONENCIAL,',.0000')#</font></td>
            <td class="LTtopline" 
            <cfif  R_LOGARITMICA LT 1 and R_LOGARITMICA GT 0  and  R_LOGARITMICA  GT R_LINEAL  and  R_LOGARITMICA  GT R_EXPONENCIAL and  R_LOGARITMICA GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style="font-size:10px">#LSNumberFormat(R_LOGARITMICA,',.0000')#</font></td>
            <td class="RLTtopline" 
			<cfif  R_POTENCIAL LT 1 and R_POTENCIAL GT 0  and  R_POTENCIAL  GT R_LINEAL  and  R_POTENCIAL  GT R_EXPONENCIAL and  R_POTENCIAL  GT R_LOGARITMICA>
				style="color:##0000FF"
			</cfif> 
            align="center"><font  style="font-size:10px">#LSNumberFormat(R_POTENCIAL,',.0000')#</font></td>
        </tr>
        <tr>
        	<td class="LTtopline" align="center"><b><font  style="font-size:10px"><cf_translate  key="LB_R2">R^2</cf_translate></font></b></td>
            <td class="LTtopline" 
            <cfif  R_LINEAL LT 1 and R_LINEAL GT 0  and  R_LINEAL GT R_EXPONENCIAL and  R_LINEAL GT R_LOGARITMICA and  R_LINEAL GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style="font-size:10px">#LSNumberFormat(R2_LINEAL,',.0000')#</font></td>
            <td class="LTtopline" 
            <cfif   R_EXPONENCIAL LT 1 and R_EXPONENCIAL GT 0  and  R_EXPONENCIAL  GT R_LINEAL  and  R_EXPONENCIAL GT R_LOGARITMICA and  R_EXPONENCIAL GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style="font-size:10px">#LSNumberFormat(R2_EXPONENCIAL,',.0000')#</font></td>
            <td class="LTtopline" 
            <cfif  R_LOGARITMICA LT 1 and R_LOGARITMICA GT 0  and  R_LOGARITMICA  GT R_LINEAL  and  R_LOGARITMICA  GT R_EXPONENCIAL and  R_LOGARITMICA GT R_POTENCIAL>
				style="color:##0000FF"
			</cfif>
            align="center"><font  style="font-size:10px">#LSNumberFormat(R2_LOGARITMICA,',.0000')#</font></td>
          <td class="RLTtopline" 
            <cfif  R_POTENCIAL LT 1 and R_POTENCIAL GT 0  and  R_POTENCIAL  GT R_LINEAL  and  R_POTENCIAL  GT R_EXPONENCIAL and  R_POTENCIAL  GT R_LOGARITMICA>
				style="color:##0000FF"
			</cfif>
          align="center"><font  style="font-size:10px">#LSNumberFormat(R2_POTENCIAL,',.0000')#</font></td>
        </tr>
        <tr>
          <td  colspan="5" class="Completoline" align="center">
            <b><font  style="font-size:10px">
            	<cf_translate  key="LB_Interseccion">Intersecci&oacute;n</cf_translate>: #LSNumberFormat(A,'____,._________')#&nbsp;&nbsp;&nbsp;<cf_translate  key="LB_Pendiente">Pendiente</cf_translate>: #LSNumberFormat(B,'____,._________')#
            </font></b>
          </td>
        </tr>
        
        <tr >
            <td  colspan="5" align="center">&nbsp;</td>
        </tr>       
    </table>
    
    <table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="bottom">
    <td  align="right" >
    
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="MSG_Lista_de_Puestos"
        default="Lista de Puestos "
        returnvariable="MSG_Lista_de_Puestos"/>    
      <tr>
        <td colspan="#totalcel#"><fieldset>
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="center"><cf_botones values="Guardar,Recalcular" tabindex="1">              </td>
            </tr>
            <tr>
              <td ><img src="/cfmx/rh/imagenes/help_small.gif"/><font  style="font-size:10px">
                <cf_translate  key="LB_Para_ver_los_resultados_en_el_reporte_dispersion_es_necesario_guardar_los_datos">Para ver los resultados en el reporte dispersi&oacute;n, es necesario guardar los datos.</cf_translate>
              </font> </td>
            </tr>
            <tr>
              <td ><img src="/cfmx/rh/imagenes/help_small.gif"/><font  style="font-size:10px">
                <cf_translate  key="LB_advertencia2">Si alg&uacute;n ajuste es manual y se presionan los botones recalcular y guardar secuencialmente se perderan los ajustes manuales.</cf_translate>
              </font> </td>
            </tr>
          </table>
        </fieldset></td>
      </tr>
      <!--- ************************************************************************************* --->
      <tr valign="bottom">
        <td  bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">#LB_Puestos#</font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">
          <cf_translate  key="LB_Puntos">Puntos</cf_translate>
        </font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">
          <cf_translate  key="LB_SalarioPromedio">Salario Promedio</cf_translate>
        </font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">
          <cf_translate  key="LB_Ajuste1">Ajuste (1)</cf_translate>
        </font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">
          <cf_translate  key="LB_Ajuste2">Ajuste (2)</cf_translate>
        </font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="RLTtopline" ><b><font  style="font-size:10px">
          <cf_translate  key="LB_Ajuste3">Ajuste (3)</cf_translate>
        </font></b></td>
      </tr>
      <tr>
        <td class="topline" colspan="#totalcel-2#" align="center">&nbsp;</td>
        <td class="topline" align="right"><input 
                name="AJUSTE1" 
                type="text" 
                id="AJUSTE1"
                tabindex="1"
                size="10"
                style="text-align: right; font-size:10px" 
                onblur="javascript: fm(this,2);"  
                onfocus="javascript:this.value=qf(this); this.select();"  
                onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                value="<cfif (isdefined("FORM.AJUSTE1") and len(trim(FORM.AJUSTE1)))>#LSNumberFormat(FORM.AJUSTE1,'____,.__')#</cfif>" />
            <b>%</b> </td>
        <td class="topline" align="right"><input 
                name="AJUSTE2" 
                type="text" 
                id="AJUSTE2"
                tabindex="1"
                size="10"
                style="text-align: right; font-size:10px" 
                onblur="javascript: fm(this,2);"  
                onfocus="javascript:this.value=qf(this); this.select();"  
                onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                value="<cfif (isdefined("FORM.AJUSTE2") and len(trim(FORM.AJUSTE2)))>#LSNumberFormat(FORM.AJUSTE2,'____,.__')#</cfif>" />
            <b>%</b> </td>
      </tr>
      <cfset calculo = 0>
      <cfset var_Puntos = 0>
      <cfset listaVarRHPcodigo = "">
      <cfset AJUSTE1 = (FORM.AJUSTE1 /100)>
      <cfset AJUSTE2 = (FORM.AJUSTE2 /100)>
      <cfloop query="rsPuesto">
        <cfset var_Puntos =  rsPuesto.Puntos >
		<cfif rsPuesto.RHPcodigo neq VarRHPcodigo>
          <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
          <cfset VarRHPcodigoForm   =  replace(VarRHPcodigo,"-","_","All")>
          <cfset listaVarRHPcodigo = listaVarRHPcodigo  & "'" & trim(VarRHPcodigoForm) & "',">
          <cfquery name="rs_ajustes" datasource="#session.DSN#">
                select coalesce(RHDPAjuste1,0) as RHDPAjuste1,coalesce(RHDPAjuste2,0) as RHDPAjuste2, coalesce(RHDPAjuste3,0) as RHDPAjuste3
                from RHDispersionPuesto  
                where  RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                and    RHPcodigo    = <cfqueryparam value="#VarRHPcodigo#" 		cfsqltype="cf_sql_char">
            </cfquery>

          <tr>
            <td class="LTtopline"  nowrap><font  style="font-size:10px">#trim(rsPuesto.RHPcodigoext)#-#trim(rsPuesto.RHPdescpuesto)#</font></td>
            <td align="right" class="LTtopline"  nowrap><font  style="font-size:10px">#round(rsPuesto.Puntos)#</font></td>
            <td align="right" class="LTtopline"  nowrap><font  style="font-size:10px">#LSNumberFormat(rsPuesto.salariopromedio,'____,.__')#</font></td>
            <td align="right" class="LTtopline"  nowrap><cfif rsPuesto.Puntos eq 0>
			<cfset calculo = 0>
       <cfelse>
			<cfif  isdefined("form.radTipo") and form.radTipo eq 1 or ( not isdefined("form.radTipo") and R_LINEAL LT 1 and R_LINEAL GT 0  and  R_LINEAL GT R_EXPONENCIAL and  R_LINEAL GT R_LOGARITMICA and  R_LINEAL GT R_POTENCIAL)>
                    <cfset calculo = A + (B * var_Puntos)>
            <cfelseif  isdefined("form.radTipo") and form.radTipo eq 2 or (  not isdefined("form.radTipo") and R_EXPONENCIAL LT 1 and R_EXPONENCIAL GT 0  and  R_EXPONENCIAL  GT R_LINEAL  and  R_EXPONENCIAL GT R_LOGARITMICA and  R_EXPONENCIAL GT R_POTENCIAL)>
					<cfset calculo = A * exp(B*var_Puntos)>
            <cfelseif  isdefined("form.radTipo") and form.radTipo eq 3 or ( not isdefined("form.radTipo") and  R_LOGARITMICA LT 1 and R_LOGARITMICA GT 0  and  R_LOGARITMICA  GT R_LINEAL  and  R_LOGARITMICA  GT R_EXPONENCIAL and  R_LOGARITMICA GT R_POTENCIAL)>
					<cfset calculo = A + (B * log10(var_Puntos))>
            <cfelseif  isdefined("form.radTipo") and form.radTipo eq 4 or ( not isdefined("form.radTipo") and R_POTENCIAL LT 1 and R_POTENCIAL GT 0  and  R_POTENCIAL  GT R_LINEAL  and  R_POTENCIAL  GT R_EXPONENCIAL and  R_POTENCIAL  GT R_LOGARITMICA)>
					<cfset calculo = A + (B * log10(var_Puntos))>
                     <cfset calculo = 10 ^ calculo> 
            </cfif>          
       </cfif>
            <cfset calculo = round(calculo)>
            <font  style="font-size:10px">
            #LSNumberFormat(calculo,'____,.__')#
            </font>
            <input  type="hidden" 
                    name="AG1_#trim(VarRHPcodigoForm)#" 
                    id="AG1_#trim(VarRHPcodigoForm)#"  
                    value="<cfif (isdefined("rs_ajustes.RHDPAjuste1") and len(trim(rs_ajustes.RHDPAjuste1))) and rs_ajustes.RHDPAjuste1 eq calculo>#rs_ajustes.RHDPAjuste1#<cfelse>#calculo#</cfif>" />            </td>
            <cfif rsPuesto.Puntos eq 0>
              <cfset calculo2 = 0>
              <cfelse>
              <cfset calculo2 = calculo + (calculo * AJUSTE1)>
            </cfif>
            <td align="right" class="LTtopline"  nowrap><input 
                name="AG2_#trim(VarRHPcodigoForm)#" 
                type="text" 
                id="AG2_#trim(VarRHPcodigoForm)#"
                tabindex="1"
                size="15"
                style="text-align: right; font-size:10px" 
                onblur="javascript: fm(this,2);"  
                onchange="javascript: graficar1(this,#rsPuesto.currentRow#,2);" 
                onfocus="javascript:this.value=qf(this); this.select();"  
                onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                value="<cfif (isdefined("rs_ajustes.RHDPAjuste2") and len(trim(rs_ajustes.RHDPAjuste2)) and rs_ajustes.RHDPAjuste2 eq calculo2)>#LSNumberFormat(rs_ajustes.RHDPAjuste2,'____,.__')#<cfelse>#LSNumberFormat(calculo2,'____,.__')#</cfif>" />            </td>
            <cfif rsPuesto.Puntos eq 0>
              <cfset calculo3 = 0>
              <cfelse>
              <cfset calculo3 = calculo + (calculo * AJUSTE2)>
            </cfif>
            <td align="right" class="RLTtopline" nowrap><input 
                name="AG3_#trim(VarRHPcodigoForm)#" 
                type="text" 
                id="AG3_#trim(VarRHPcodigoForm)#"
                tabindex="1"
                size="15"
                onchange="javascript: graficar1(this,#rsPuesto.currentRow#,3);" 
                style="text-align: right; font-size:10px" 
                onblur="javascript: fm(this,2);"  
                onfocus="javascript:this.value=qf(this); this.select();"  
                onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                value="<cfif (isdefined("rs_ajustes.RHDPAjuste3") and len(trim(rs_ajustes.RHDPAjuste3)) and rs_ajustes.RHDPAjuste3 eq calculo3 )>#LSNumberFormat(rs_ajustes.RHDPAjuste3,'____,.__')#<cfelse>#LSNumberFormat(calculo3,'____,.__')#</cfif>" />            </td>
          </tr>
        </cfif>
        <cfif rsPuesto.recordCount NEQ rsPuesto.currentRow>
          <cfset LST_PUNTOS  = LST_PUNTOS  & round(rsPuesto.Puntos) & '|'>
          <cfset LST_SALARIO = LST_SALARIO & round(rsPuesto.salariopromedio) & '|'>
          <cfset LST_AJUSTE1 = LST_AJUSTE1 & round(calculo) & '|'>
          <cfif (isdefined("rs_ajustes.RHDPAjuste2") and len(trim(rs_ajustes.RHDPAjuste2)) and rs_ajustes.RHDPAjuste2 eq calculo2)>
            <cfset LST_AJUSTE2 = LST_AJUSTE2 & round(rs_ajustes.RHDPAjuste2) & '|'>
            <cfelse>
            <cfset LST_AJUSTE2 = LST_AJUSTE2 & round(calculo2) & '|'>
          </cfif>
          <cfif (isdefined("rs_ajustes.RHDPAjuste3") and len(trim(rs_ajustes.RHDPAjuste3)) and rs_ajustes.RHDPAjuste3 eq calculo3)>
            <cfset LST_AJUSTE3 = LST_AJUSTE3 & round(rs_ajustes.RHDPAjuste3) & '|'>
            <cfelse>
            <cfset LST_AJUSTE3 = LST_AJUSTE3 & round(calculo3) & '|'>
          </cfif>
          <cfelse>
          <cfset LST_PUNTOS  = LST_PUNTOS  & round(rsPuesto.Puntos) >
          <cfset LST_SALARIO = LST_SALARIO & round(rsPuesto.salariopromedio) >
          <cfset LST_AJUSTE1 = LST_AJUSTE1 & round(calculo) >
          <cfif (isdefined("rs_ajustes.RHDPAjuste2") and len(trim(rs_ajustes.RHDPAjuste2)) and rs_ajustes.RHDPAjuste2 eq calculo2)>
            <cfset LST_AJUSTE2 = LST_AJUSTE2 & round(rs_ajustes.RHDPAjuste2)>
            <cfelse>
            <cfset LST_AJUSTE2 = LST_AJUSTE2 & round(calculo2)>
          </cfif>
          <cfif (isdefined("rs_ajustes.RHDPAjuste3") and len(trim(rs_ajustes.RHDPAjuste3)) and rs_ajustes.RHDPAjuste3 eq calculo3)>
            <cfset LST_AJUSTE3 = LST_AJUSTE3 & round(rs_ajustes.RHDPAjuste3)>
            <cfelse>
            <cfset LST_AJUSTE3 = LST_AJUSTE3 & round(calculo3)>
          </cfif>
        </cfif>
      </cfloop>
      <cfset listaVarRHPcodigo = listaVarRHPcodigo  &"'-1'">
      <tr >
        <td  class="topline" colspan="#totalcel#" align="center">&nbsp;</td>
      </tr>
    </table>
      <b><font  style="font-size:10px"><cf_translate  key="LB_Puntos"></cf_translate></font></b></td>
        </tr>
    </table>
  </cfoutput>
    <input type="hidden" name="LST_PUNTOS"  value="<cfoutput>#LST_PUNTOS#</cfoutput>">
    <input type="hidden" name="LST_SALARIO" value="<cfoutput>#LST_SALARIO#</cfoutput>">
    <input type="hidden" name="LST_AJUSTE1" value="<cfoutput>#LST_AJUSTE1#</cfoutput>">
    <input type="hidden" name="LST_AJUSTE2" value="<cfoutput>#LST_AJUSTE2#</cfoutput>">
    <input type="hidden" name="LST_AJUSTE3" value="<cfoutput>#LST_AJUSTE3#</cfoutput>">
</form>      
<script language="javascript" type="text/javascript">
	function funcRecalcular(){
		document.form1.action='registro_valoracion.cfm';
		document.form1.submit();
	}

</script>    
    
    
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>