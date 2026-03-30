<!--- <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">

 --->
<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_RegistroDeRelacionesDevaloracion"
    Default="Registro de Relaciones de valoraci&oacute;n"
    returnvariable="LB_RegistroDeRelacionesDevaloracion"/>	
                        
<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
<cfif isdefined("url.RHVPid") and len(trim(url.RHVPid)) gt 0><cfset form.RHVPid = url.RHVPid></cfif>

<cfif isdefined("url.A") and len(trim(url.A)) gt 0><cfset form.A = url.A></cfif>
<cfif isdefined("url.B") and len(trim(url.B)) gt 0><cfset form.B = url.B></cfif>
<cfif isdefined("url.R") and len(trim(url.R)) gt 0><cfset form.R = url.R></cfif>
<cfif isdefined("url.R2") and len(trim(url.R2)) gt 0><cfset form.R2 = url.R2></cfif>



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

<cfquery name="rsRHValoracionPuesto" datasource="#session.DSN#">
     select RHVPfhasta from RHValoracionPuesto
     where RHVPid =  <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rs_valoracion_header" datasource="#session.DSN#">
	select RHVUsaPropuestos
	from RHValoracionPuesto 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHVPid#">
</cfquery>

<cfset VARUsaPropuestos = rs_valoracion_header.RHVUsaPropuestos>

<cfquery name="rsPuesto" datasource="#session.DSN#">
    select a.RHPcodigo,coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext ,a.RHPdescpuesto,
    coalesce((select sum(LTsalario)/count(DEid) from LineaTiempo b
        inner join RHPlazas c
            on  b.RHPid   = c.RHPid 
            and b.Ecodigo = c.Ecodigo
            <cfif VARUsaPropuestos neq 0>
                and c.RHPpuesto  in (select z.RHPcodigoH  from RHPuestosH z  where z.Ecodigo  = a.Ecodigo  and z.RHPcodigo =  a.RHPcodigo ) 
            <cfelse>
	            and c.RHPpuesto = a.RHPcodigo 
            </cfif>
        where a.Ecodigo = b.Ecodigo
         and <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta 
     ),0) as salariopromedio,
    (select  sum(z.RHGporcvalorfactor)
    from RHGradosFactorPuesto  x
         inner join RHGrados z
            on x.RHFid = z.RHFid
            and x.RHGid = z.RHGid
    where    x.RHPcodigo   	= a.RHPcodigo
    and    x.Ecodigo   		= a.Ecodigo 
    and    x.RHVPid         = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     ) as Puntos,
     coalesce(RHDPAjuste1,0) as RHDPAjuste1,
     coalesce(RHDPAjuste2,0) as RHDPAjuste2,
     coalesce(RHDPAjuste3,0) as RHDPAjuste3
    from RHPuestos a
    inner join  RHDispersionPuesto z
    	on  z.RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
        and z.RHPcodigo    = a.RHPcodigo   
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 	
    and  0 < 
    coalesce((select sum(LTsalario)/count(DEid) from LineaTiempo b
        inner join RHPlazas c
            on  b.RHPid   = c.RHPid 
            and b.Ecodigo = c.Ecodigo
			<cfif VARUsaPropuestos neq 0>
                and c.RHPpuesto  in (select z.RHPcodigoH  from RHPuestosH z  where z.Ecodigo  = a.Ecodigo  and z.RHPcodigo =  a.RHPcodigo ) 
            <cfelse>
	            and c.RHPpuesto = a.RHPcodigo 
            </cfif>
        where a.Ecodigo = b.Ecodigo
         and <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta 
     ),0)
  	 <cfif VARUsaPropuestos eq 1>
		and coalesce(a.RHPropuesto,0) = 1 and a.RHPactivo = 0
	<cfelse>
    	and  coalesce(a.RHPropuesto,0) = 0
	</cfif>
    
    Order by   Puntos
    
</cfquery>

<cfset totalcel =  6>
<cfset TamCel   =  100 /(totalcel)>
<cfset VarRHPcodigo   =  "">
<cfset VarRHPcodigoForm   =  ""> 
<cfset VarCFdescripcion  =  ""> 

<cfset LvarFileName = "GradosXPuesto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_RegistroDeRelacionesDevaloracion#" 
	filename="#LvarFileName#"
    download="false"
	irA="registro_valoracion.cfm?SEL=#form.SEL#&RHVPid=#form.RHVPid#" 
	>

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
<!--- <cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionesDevaloracion#" skin="#Session.Preferences.Skin#">

<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="formDispersionPuestoR.cfm">
  <input type="hidden" name="SEL" value="<cfoutput>#form.SEL#</cfoutput>">
  <input type="hidden" name="RHVPid" value="<cfoutput>#form.RHVPid#</cfoutput>"> --->
  
  
  <!--- <input type="hidden" name="tienefiltros" value="<cfoutput>#tienefiltros#</cfoutput>"> --->
  <cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="MSG_Lista_de_Puestos"
        Default="Lista de Puestos "
        returnvariable="MSG_Lista_de_Puestos"/>
      <tr>
        <td colspan="#totalcel#"><fieldset>
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
           <!---  <tr>
            	<td colspan="3" align="right">
            		<cf_botones values="Regresar" tabindex="1">
                </td>
            </tr> --->
            
            <!--- <tr> 
                <td colspan="3">
                    <strong>Intersecci&oacute;n : #LSNumberFormat(url.A,'____,.__')#&nbsp;&nbsp;&nbsp;Pendiente : #LSNumberFormat(url.B,'____,.__')# </strong>
                </td>
            </tr>
             --->
          </table>
        </fieldset></td>
      </tr>
      
      
      <!--- ************************************************************************************* --->
      <tr valign="bottom">
        <td  bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px">#LB_Puestos#</font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_Puntos">Puntos</cf_translate></font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_SalarioPromedio">Salario Promedio</cf_translate></font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_Ajuste1">Ajuste (1)</cf_translate></font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_Ajuste2">Ajuste (2)</cf_translate></font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="RLTtopline" ><b><font  style="font-size:10px"><cf_translate  key="LB_Ajuste3">Ajuste (3)</cf_translate></font></b></td>
      </tr>
      <cfloop query="rsPuesto">
        <cfif rsPuesto.RHPcodigo neq VarRHPcodigo>
           <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
           <cfset VarRHPcodigoForm   =  replace(VarRHPcodigo,"-","_","All")>
          <tr>
            <td class="LTtopline"  nowrap><font  style="font-size:10px">#trim(rsPuesto.RHPcodigoext)#-#trim(rsPuesto.RHPdescpuesto)#</font></td>
            <td align="right" class="LTtopline"  nowrap><font  style="font-size:10px">#round(rsPuesto.Puntos)#</font></td>
            <td align="right" class="LTtopline"  nowrap><font  style="font-size:10px">#LSNumberFormat(rsPuesto.salariopromedio,'____,.__')#</font></td>
            <td align="right" class="LTtopline"  nowrap>
                <font  style="font-size:10px">#LSNumberFormat(rsPuesto.RHDPAjuste1,'____,.__')#    </font>        
            </td>
            <td align="right" class="LTtopline"  nowrap>
                <font  style="font-size:10px">#LSNumberFormat(rsPuesto.RHDPAjuste2,'____,.__')#</font>          
            </td>
            <td align="right" class="RLTtopline" nowrap>
                <font  style="font-size:10px">#LSNumberFormat(rsPuesto.RHDPAjuste3,'____,.__')#</font>
            </td>
            
          </tr>
        </cfif>
      </cfloop>
      <tr >
        <td  class="topline" colspan="#totalcel#" align="center">&nbsp;</td>
      </tr>
       <tr >
        <td  class="topline" colspan="#totalcel#" align="center">
    	<cfquery dbtype="query" name="tot">
            select sum(RHDPAjuste1) as total1,
            sum(RHDPAjuste2) as total2,
            sum(RHDPAjuste3) as total3
            from rsPuesto
		</cfquery>
        
        <cfquery dbtype="query" name="AG1">
            select Puntos,RHDPAjuste1 from rsPuesto
            order by Puntos ASC ,RHDPAjuste1 ASC
		</cfquery>
        <cfquery dbtype="query" name="AG2">
            select Puntos,RHDPAjuste2 from rsPuesto
            order by Puntos ASC ,RHDPAjuste2 ASC
		</cfquery>
        <cfquery dbtype="query" name="AG3">
            select Puntos,RHDPAjuste3  from rsPuesto
            order by Puntos ASC ,RHDPAjuste3 ASC
		</cfquery>
         <cfquery dbtype="query" name="SAL">
            select Puntos,salariopromedio from rsPuesto
            order by Puntos ASC ,salariopromedio ASC
            
		</cfquery>

        <cfchart  	
            format="flash" 
            chartWidth = "1000" 
            chartheight = "400" 
            font = "Arial"
            fontSize = "10" 
            fontBold = "no" 
            fontItalic = "no"  
            xAxisTitle = "Puntos" 
            xAxisType = "Scale"  
            yAxisTitle = "salario" 
            showLegend = "yes"  
            show3d="no"    
            markersize="3"  
        >
       		<!--- AJUSTE 1 --->
			 <cfif AG1.recordCount GT 0 and tot.total1 GT 0>
                 <cfchartseries
                     type="line"
                     serieslabel="Ajuste 1"  
                     seriescolor="##00CC00">
                    <cfloop query="AG1">
                        <cfchartdata item="#Round(AG1.Puntos)#" value="#AG1.RHDPAjuste1#">
                    </cfloop>
                </cfchartseries>
            </cfif>
       		<!--- AJUSTE 2 --->
       		<cfif AG2.recordCount GT 0 and tot.total2 GT 0>
                <cfchartseries
                     type="line"
                     serieslabel="Ajuste 2"  
                     seriescolor="##FF9933">
                    <cfloop query="AG2">
                        <cfchartdata item="#Round(AG2.Puntos)#" value="#AG2.RHDPAjuste2#">
                    </cfloop>
                </cfchartseries>
            </cfif>
       		<!--- AJUSTE 3 --->
            <cfif AG3.recordCount GT 0 and tot.total3 GT 0>
                <cfchartseries
                     type="line"
                     serieslabel="Ajuste 3" 
                     seriescolor="##FF0000">
                    <cfloop query="AG3">
                        <cfchartdata item="#Round(AG3.Puntos)#" value="#AG3.RHDPAjuste3#">
                    </cfloop>
                </cfchartseries>
            </cfif>
       		<!--- SALARIO --->
            <cfchartseries
                 type="scatter"
                 serieslabel="salario"  markerstyle="triangle"   
                 seriescolor="##000000">
                <cfloop query="SAL">
                	<cfchartdata item="#Round(SAL.Puntos)#" value="#SAL.salariopromedio#">
                </cfloop>
            </cfchartseries>
    </cfchart>
        </td>
      </tr>
    </table>
  </cfoutput>
<!--- </form>      
<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action='registro_valoracion.cfm?SEL=<cfoutput>#form.SEL#</cfoutput>&RHVPid=<cfoutput>#form.RHVPid#</cfoutput>';
		document.form1.submit();
	}


</script>     --->