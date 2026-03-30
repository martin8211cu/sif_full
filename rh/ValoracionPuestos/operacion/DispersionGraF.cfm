	<cfset ARR_SALARIO = listtoarray(url.LST_SALARIO,'|')>							
    <cfset ARR_PUNTOS  = listtoarray(url.LST_PUNTOS,'|')>							
    <cfset ARR_AJUSTE1 = listtoarray(url.LST_AJUSTE1,'|')>							
    <cfset ARR_AJUSTE2 = listtoarray(url.LST_AJUSTE2,'|')>							
    <cfset ARR_AJUSTE3 = listtoarray(url.LST_AJUSTE3,'|')>	

	<cfset VAR_SALARIO = 0>							
    <cfset VAR_AJUSTE1 = 0>							
    <cfset VAR_AJUSTE2 = 0>							
    <cfset VAR_AJUSTE3 = 0>	

	<cfoutput>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td   align="center">
                    <font  style="font-size:11px">
                        <cf_translate  key="LB_Ayuda">Este gr&aacute;fico muestra la dispersi&oacute;n propuesta, para ver el gr&aacute;fico definitivo guarde los datos.</cf_translate>
                	</font>                
                </td>
            </tr>
            <tr>
                <td   align="center">&nbsp;</td>
            </tr>
            <tr>
                <td   align="center">
                <cfchart  	 
                    format="flash" 
                    font = "Arial"
                    fontSize = "10" 
                    fontBold = "no" 
                    fontItalic = "no"  
                    xAxisTitle = "Puntos" 
                    xAxisType = "Scale"  
                    yAxisTitle = "salario" 
                    showLegend = "yes"  
                    chartwidth="280"
                    chartheight="200"
                    show3d="no"    
                    markersize="3"  
                    <!--- url="formDispersionPuestoR.cfm?RHVPid=#url.RHVPid#&SEL=3" --->
                >
                <!--- AJUSTE 1 --->
                <cfif isdefined("LST_AJUSTE1") and len(trim(LST_AJUSTE1))>
                    <cfchartseries 
                    type="line"
                    serieslabel="Ajuste 1"  
                    seriescolor="##00CC00">
                    <cfloop from="1" to ="#arraylen(ARR_AJUSTE1)#" index="i">
						<cfset VAR_AJUSTE1 = ARR_AJUSTE1[i] >							
                        <cfchartdata item="#ARR_PUNTOS[i]#" value="#VAR_AJUSTE1#">
                    </cfloop>
                    </cfchartseries>
                </cfif>
                <!--- AJUSTE 2 --->
                <cfif isdefined("LST_AJUSTE2") and len(trim(LST_AJUSTE2))>
                    <cfchartseries
                    type="line"
                    serieslabel="Ajuste 2"  
                    seriescolor="##FF9933">
                    <cfloop from="1" to ="#arraylen(ARR_AJUSTE2)#" index="i">
						<cfset VAR_AJUSTE2 = ARR_AJUSTE2[i] >	
                        <cfchartdata item="#ARR_PUNTOS[i]#" value="#VAR_AJUSTE2#">
                    </cfloop>
                    </cfchartseries>
                </cfif>
                <!--- AJUSTE 3 --->
                <cfif isdefined("LST_AJUSTE3") and len(trim(LST_AJUSTE3))>
                    <cfchartseries
                    type="line"
                    serieslabel="Ajuste 3" 
                    seriescolor="##FF0000">
                    <cfloop from="1" to ="#arraylen(ARR_AJUSTE3)#" index="i">
                         <cfset VAR_AJUSTE3 = ARR_AJUSTE3[i] >
                        <cfchartdata item="#ARR_PUNTOS[i]#" value="#VAR_AJUSTE3#">
                    </cfloop>
                    </cfchartseries>
                </cfif>
                <!--- SALARIO --->
                <cfchartseries
                type="scatter"
                serieslabel="salario"  markerstyle="triangle"   
                seriescolor="##000000">
                <cfloop from="1" to ="#arraylen(ARR_SALARIO)#" index="i">
                        <cfset VAR_SALARIO = ARR_SALARIO[i]>						
                    <cfchartdata item="#ARR_PUNTOS[i]#" value="#VAR_SALARIO#">
                </cfloop>
                </cfchartseries>
                </cfchart>
                </td>
            </tr>
       </table>
    </cfoutput>
