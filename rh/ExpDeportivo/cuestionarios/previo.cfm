<cfif isdefined("url.PCid") and not isdefined('form.PCid') >
	<cfset form.PCid = url.PCid >
</cfif>

<cfquery name="pcdata" datasource="sifcontrol">
    select PCnombre
    from PortalCuestionario
    where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
</cfquery>

<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Titulo"
		Default="Previo del Formulario"
		returnvariable="Titulo"/>
		<cfoutput>#Titulo# (#pcdata.PCnombre#)</cfoutput>
</title>

<cfquery name="data" datasource="sifcontrol">
    select pc.PCid,
           pc.PCcodigo,
           pc.PCnombre,
           pcp.PPparte,
           pcp.PCPmaxpreguntas,
           pcp.PCPdescripcion,
           pp.PPid,	
           pp.PPnumero, 
           pp.PPpregunta,
           pp.PPmantener,
           pp.PPtipo,
           pp.PPrespuesta,
           pc.PCtiempototal,
           coalesce(pp.PPorientacion,0) as PPorientacion
    
    from PortalCuestionario pc
    
    inner join PortalCuestionarioParte pcp
    on pc.PCid=pcp.PCid
    
    inner join PortalPregunta pp
    on pp.PCid=pcp.PCid
    and pp.PPparte=pcp.PPparte
    
    where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
    
    order by pc.PCcodigo, pp.PPparte, pp.PPnumero, pp.PPorden
</cfquery>

<cfquery name="partes" datasource="sifcontrol">
    select PCid, PPparte, PCPmaxpreguntas 
    from PortalCuestionarioParte
    where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
    order by PCid
</cfquery>

<cfoutput>
<cfdocument format="flashpaper" 
			marginleft="2" 
			marginright="2" 
			marginbottom="3"
			margintop="1" 
			unit="cm" 
			pagetype="letter">            
    <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
        <tr><td align="center">
            <cfset cuestionario = '' >
            <cfset parte = '' >
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <cfloop query="data" >
                <cfset LvarPPorientacion = data.PPorientacion >
				<cfset LvarPCid = data.PCid >
                <cfset LvarParte = data.PPparte >
                <cfset pregunta = data.PPid >

                <cfif LvarPCid neq cuestionario >
                    <cfset parte = '' >
                    <tr><td colspan="2"style="padding:0;"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; ">#data.PCcodigo# - #data.PCnombre#</strong></td></tr>
                    <tr><td>&nbsp;</td></tr>
                </cfif>

                <cfif parte neq data.PPparte>
                    <tr><td colspan="2" style="border-bottom: 1px solid black; "><strong>#data.PCPdescripcion#</strong></td></tr>
                    <tr><td>&nbsp;</td></tr>
                </cfif>
                
                <cfif data.PPtipo eq 'E'>
                    <tr>
                        <td colspan="2">#data.PPpregunta#</td>
                    </tr>
                <cfelse>
                    <tr>
                        <td  valign="top"width="1%" style="padding-left:15px; ">#data.PPnumero#.</td>
                        <td style="padding-left:5px; ">#data.PPpregunta#</td>
                    </tr>
                </cfif>
                <tr>
                    <td colspan="2" style="padding-left:15px; ">
                        <table width="100%" border="0" cellpadding="1" cellspacing="0">
                        <cfquery name="datarespuestas" datasource="sifcontrol">
                           select pr.PPid, 
                                   pr.PCid,
                                   pp.PPparte as parte,
                                   pp.PPtipo, 
                                   pp.PPrespuesta, 
                                   pr.PRid,
                                   pr.PRvalor, 
                                   pr.PRtexto, 
                                   pr.PRimagen
                            from PortalCuestionario pc
                            
                            inner join PortalPregunta pp
                            on pc.PCid=pp.PCid
                    
                            left outer join PortalRespuesta pr
                            on pp.PPid=pr.PPid
                    
                            where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
                              and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
                              and pp.PPtipo != 'E'
                              order by pr.PRorden
                        </cfquery>
                       
						<script type="text/javascript" language="javascript1.2">
                                respuestas#pregunta# = new Array();
                        </script>
                            
						<cfif listcontains('V', data.PPtipo)>
                            <cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
                        </cfif>
                        
                        <cfif data.PPtipo eq 'U' >
                                <cfif LvarPPorientacion eq 1 >
                                  	<tr>
                                </cfif>
                                <cfloop query="datarespuestas">
                                    <cfif LvarPPorientacion eq 0>
                                        <tr>
                                    </cfif>
                                        <td width="1%"  style="padding-left:5px; ">&nbsp;</td>
                                        <td colspan="2">
                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td align="1%" valign="top" >
                                                       <img src="/cfmx/rh/imagenes/radio.gif" />
                                                       
                                                    </td>
                                                    <td width="99%" style="padding-left:3px;" valign="bottom"><font size="2">#datarespuestas.PRtexto#</font></td>
                                                </tr>
                                            </table>
                                        </td>
                                    <cfif LvarPPorientacion  eq 0>
                                        </tr>
                                    </cfif>
                                </cfloop>
                                <tr><td width="1%" >&nbsp;</td>
                                <cfif LvarPPorientacion eq 1 >
                                    </tr>
                                </cfif> 
                            <cfelseif data.PPtipo eq 'M'>
                                <cfif LvarPPorientacion eq 1 >
                                  	<tr>
                                </cfif>
                               
                                <cfloop query="datarespuestas">	
									 <cfif LvarPPorientacion eq 0>
                                        <tr>
                                    </cfif>
                                        <td width="1%"   style="padding-left:5px; ">&nbsp;</td>
                                        <td colspan="2" align="right">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" align="right">
                                                <tr>
                                                   <td width="1%" valign="top">
                                                        <img src="/cfmx/rh/imagenes/unchecked.gif"/>
                                                    </td>
                                                    <td  style="padding-left:3px;" valign="top"><font size="2">#trim(datarespuestas.PRtexto)#</font></td>
                                                </tr>
                                            </table>
                                        </td>
									<cfif LvarPPorientacion eq 0>
                                        </tr>
                                    </cfif>
                                </cfloop>
                                <tr><td>&nbsp;</td>
								<cfif LvarPPorientacion eq 1 >
                                    </tr>
                                </cfif>                                
                        
                            <cfelseif data.PPtipo eq 'D'>
                                <tr>
                                    <td width="1%" style="padding-left:5px; ">&nbsp;</td>
                                    <td colspan="2"  >
                                        <table width="664" height="100" bgcolor="##fafafa" style="border:1px solid ##808080" cellpadding="2" cellspacing="0">
                                            <tr><td valign="top">&nbsp;</td></tr>
                                        </table>				
                                    </td>
                                </tr>
                        
                            <cfelseif data.PPtipo eq 'V'>
                                <cfif datarespuestas.recordcount gt 0 >
                                    <cfif ArrayLen(valores)>
                                        <cfloop query="datarespuestas">
                                            <tr>
                                                <td width="1%"   style="padding-left:5px; ">&nbsp;</td>
                                                <td width="3%" align="center" style="border-bottom:1px solid black;" >&nbsp;</td>
                                                <td width="99%" style="padding-left:3px;"><font size="2">#trim(datarespuestas.PRtexto)#</font></td>
                                            </tr>
                                        </cfloop>
                                    <cfelse>
                                        <cfloop query="datarespuestas">
                                            <tr>
                                                <td  nowrap align="left">#datarespuestas.PRtexto#:</td>
                                                <td width="1%"   style="padding-left:5px; ">&nbsp;</td>
                                                <td >________________</td>
                                            </tr>
                                        </cfloop>
                                    </cfif>
                                <cfelse>
                                    <tr>
                                        <td width="1%"   style="padding-left:5px; ">&nbsp;</td>
                                        <td colspan="2" >______________</td>
                                    </tr>
                                </cfif>
                                <tr><td width="1%" >&nbsp;</td></tr>
                           	<cfelseif data.PPtipo eq 'O'>
                                <cfloop query="datarespuestas">
                                    <tr>
                                        <td width="1%"   style="padding-left:5px; ">&nbsp;</td>
                                        <td width="3%" style="border-bottom:1px solid black;" align="center"  >&nbsp;
                                       		
                                        </td>
                                        <td width="99%" style="padding-left:3px;"><font size="2">
                                            #datarespuestas.PRtexto#
                                        </font></td>
                                    </tr>
                                </cfloop>
                                <tr><td width="1%" >&nbsp;</td></tr>
                            </cfif>
                        </table>                       
                    </td>
                </tr>
                <cfset cuestionario = data.PCid >
                <cfset parte = data.PPparte >
            </cfloop>
            </table>							
        </td></tr>
    </table>
</cfdocument>
</cfoutput>
