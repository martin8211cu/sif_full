<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Sin_Centro_Funcional"
	Default="Sin Centro Funcional"
	returnvariable="LB_Sin_Centro_Funcional"/>      
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Factores"
	Default="Factores"
	returnvariable="LB_Factores"/> 
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Centro_Funcional"
	Default="Centro Funcional"
	returnvariable="LB_Centro_Funcional"/>       
    

<cfquery name="rs_valoracion_header" datasource="#session.DSN#">
	select RHVUsaPropuestos
	from RHValoracionPuesto 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHVPid#">
</cfquery>

<cfset VARUsaPropuestos = rs_valoracion_header.RHVUsaPropuestos>         

<cfquery name="rsfactor" datasource="#session.DSN#">
    select RHFid,RHFcodigo,RHFdescripcion
    from RHFactores
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by RHFcodigo
</cfquery>  


<cfquery name="rsPuesto" datasource="#session.DSN#">
    select distinct a.RHPcodigo,coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext ,a.RHPdescpuesto,coalesce(b.CFdescripcion,'#LB_Sin_Centro_Funcional#') as CFdescripcion
    from RHPuestos a
    inner join RHGradosFactorPuesto x
        on    x.RHPcodigo   	= a.RHPcodigo
        and    x.Ecodigo   		= a.Ecodigo 
        and    x.RHVPid         = <cfqueryparam value="#URL.RHVPid#" cfsqltype="cf_sql_numeric">      
    left outer join CFuncional b
    	on  a.Ecodigo = b.Ecodigo
        and a.CFid   = b.CFid
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 	<cfif VARUsaPropuestos eq 1>
		and coalesce(a.RHPropuesto,0) = 1 and a.RHPactivo = 0
	<cfelse>
    	and  coalesce(a.RHPropuesto,0) = 0
	</cfif>
	
	
	<cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
        	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfif> 
  	Order by CFdescripcion,RHPdescpuesto
</cfquery>
            


<cfset Cantidad =  rsfactor.recordCount + 1>
<cfset totalcel =  Cantidad + 1>
<cfset TamCel   =  100 /(totalcel)>
<cfset VarRHFid   =  -1>
<cfset VarRHGid    =  -1>
<cfset VarRHPcodigo   =  "">
<cfset VarRHGporcvalorfactor        =  0.0000>
<cfset VarRHGporcvalorfactorTotal   =  0.0000>



<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Puntuacion_de_Factores_Por_Puesto"
				Default="Puntuaci&oacute;n de Factores por Puesto"
				returnvariable="LB_Puntuacion_de_Factores_Por_Puesto"/>

<cfset LvarFileName = "PuntosXFactorPuesto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_Puntuacion_de_Factores_Por_Puesto#" 
	filename="#LvarFileName#"
	irA="../operacion/registro_valoracion.cfm?SEL=#url.SEL#&RHVPid=#url.RHVPid#">

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
  <cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr >
        <td  bgcolor="##CCCCCC" class="Completoline" colspan="#totalcel+1#" align="center"><b><font  style="font-size:14px">#LB_Puntuacion_de_Factores_Por_Puesto#<cfif VARUsaPropuestos eq 1>&nbsp;<cf_translate  key="LB_Puestos Propuestos">(Puestos Propuestos)</cf_translate></cfif></font></b></td>
      </tr>
       <tr >
        <td  colspan="#totalcel+1#" align="center">&nbsp;</td>
      </tr>
      
      
      <tr valign="bottom">
        <td  bgcolor="##CCCCCC" class="LTtopline" rowspan="2"><b><font  style="font-size:11px">#LB_Centro_Funcional#</font></b></td>
        <td  bgcolor="##CCCCCC" class="LTtopline" rowspan="2"><b><font  style="font-size:11px">#LB_Puesto#</font></b></td>
        <td  bgcolor="##CCCCCC" class="RLTtopline" align="center" colspan="#Cantidad#"><b><font  style="font-size:11px">#LB_Factores#</font></b></td>
      </tr>
      <tr>
        <cfloop query="rsfactor">
          <td bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:11px">&nbsp;#trim(rsfactor.RHFdescripcion)#&nbsp;</font> </td>
        </cfloop>
        <td  bgcolor="##CCCCCC"  align="right" class="RLTtopline" ><font  style="font-size:11px"><cf_translate  key="LB_Total">Total</cf_translate></font></td>

      </tr>
      <cfloop query="rsPuesto">
        <cfif rsPuesto.RHPcodigo neq VarRHPcodigo>
          <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
          <tr>
            <td class="LTtopline"  nowrap><font  style="font-size:11px">#trim(rsPuesto.CFdescripcion)#</font></td>
            <td class="LTtopline"  nowrap><font  style="font-size:11px">#trim(rsPuesto.RHPcodigoext)#-#trim(rsPuesto.RHPdescpuesto)#</font></td>
            <cfloop query="rsfactor">
              	<cfset VarRHFid   =  rsfactor.RHFid>
				<cfquery name="rsGradot" datasource="#session.DSN#">
					select  b.RHGporcvalorfactor
                    from RHGradosFactorPuesto  a
                    inner join RHGrados b
                    	on a.RHFid = b.RHFid
                        and a.RHGid = b.RHGid
                    where  a.RHFid   		= <cfqueryparam value="#VarRHFid#" cfsqltype="cf_sql_numeric">
                    and    a.RHPcodigo   	= <cfqueryparam value="#VarRHPcodigo#" cfsqltype="cf_sql_char">
                    and    a.Ecodigo   		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and    a.RHVPid         = <cfqueryparam value="#URL.RHVPid#" cfsqltype="cf_sql_numeric">

                </cfquery>
				<cfif rsGradot.recordCount gt 0 and len(trim(rsGradot.RHGporcvalorfactor))>
					<cfset VarRHGporcvalorfactor   =  rsGradot.RHGporcvalorfactor>
                <cfelse>
					<cfset VarRHGporcvalorfactor   =  0.0000>
				</cfif>
                
                <cfset VarRHGporcvalorfactorTotal   =  VarRHGporcvalorfactorTotal +  VarRHGporcvalorfactor>
                <cfif rsGradot.recordCount eq 0>
                    <td class="LTtopline" align="center">&nbsp;</td>
                <cfelse>
                    <td class="LTtopline" align="right"><font  style="font-size:11px">#LSNumberFormat(VarRHGporcvalorfactor,'____.__')#</font></td>
                </cfif> 
				<!--- <cfif rsPuesto.recordCount eq rsPuesto.currentRow>
					<cfif rsGradot.recordCount eq 0>
                        <td class="<cfif rsfactor.recordCount eq rsfactor.currentRow>Completoline<cfelse>LTtopline</cfif>" align="center">&nbsp;</td>
                    <cfelse>
                        <td class="<cfif rsfactor.recordCount eq rsfactor.currentRow>Completoline<cfelse>LTtopline</cfif>" align="right"><font  style="font-size:11px">#trim(VarRHGporcvalorfactor)#</font></td>
                    </cfif>                
                <cfelse>
					<cfif rsGradot.recordCount eq 0>
                        <td class="<cfif rsfactor.recordCount eq rsfactor.currentRow>RLTtopline<cfelse>LTtopline</cfif>" align="center">&nbsp;</td>
                    <cfelse>
                        <td class="<cfif rsfactor.recordCount eq rsfactor.currentRow>RLTtopline<cfelse>LTtopline</cfif>" align="right"><font  style="font-size:11px">#trim(VarRHGporcvalorfactor)#</font></td>
                    </cfif>                
                </cfif> --->
            </cfloop>
            <cfif rsPuesto.recordCount eq rsPuesto.currentRow>
            	<td class="Completoline" align="right"><font  style="font-size:11px">#LSNumberFormat(VarRHGporcvalorfactorTotal,'____.__')#</font></td>
			<cfelse>
                <td class="RLTtopline" align="right"><font  style="font-size:11px">#LSNumberFormat(VarRHGporcvalorfactorTotal,'____.__')#</font></td>
			</cfif>
			<cfset VarRHGporcvalorfactor        =  0.0000>
			<cfset VarRHGporcvalorfactorTotal   =  0.0000>
          </tr>
        </cfif>
      </cfloop>
      <tr >
        <td  class="topline" colspan="#totalcel#" align="center">&nbsp;</td>
      </tr>
    </table>
  </cfoutput>
