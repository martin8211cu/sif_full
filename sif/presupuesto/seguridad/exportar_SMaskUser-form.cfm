<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:25px;">
    <tr>
        <td width="30%" valign="top">
          <cfinclude template="exportarSMaskUserLista.cfm">
        </td>
        <td width="70%" valign="top">
            <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <fieldset><legend>Lista de Mascaras de Cuentas de Usuario a Exportar</legend>
                        <div style="overflow:auto; height: 400px; width: 690px; margin:0;" >
                        
                        <table width="100%"  border="0" cellspacing="1" cellpadding="1" id="demo" class="demo">
                                    <tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas">Descripci&oacute;n</td>
										<td class="titulolistas">Mascara</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                    </tr>
                        </table>
                        	<cfquery name="rsListatotal" datasource="#session.dsn#">
                                select distinct 
								u.Usulogin, u.Usucodigo, 
								m.CPSMascaraP, m.CPSMdescripcion,
								m.CPSMconsultar, m.CPSMtraslados, m.CPSMreservas, m.CPSMformulacion

								from 
								CPSeguridadMascarasCtasP m inner join Usuario u
								on u.Usucodigo=m.Usucodigo  
								where
                                m.Ecodigo=#session.Ecodigo#
                                and u.CEcodigo=#session.CEcodigo#
                                order by u.Usucodigo , u.Usulogin asc
                            </cfquery>
                           <cfset primerF=0> <cfset idlogin=0> <cfset idloginOld=0>
                            <cfoutput query="rsListatotal"><cfset idlogin= Usucodigo>
                            <cfif primerF EQ 0>
                            	<cfset primerF=1>
                                <div name="row#Usucodigo#" id="row#Usucodigo#" class="row#Usucodigo#" style="display:none;">
                                 <table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                    <tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas">Descripci&oacute;n</td>
										<td class="titulolistas">Mascara</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                    </tr>
                                    <tr style="border-bottom:1px solid gray;">
                                        <td>#Usulogin#</td>
                                        <td>#CPSMdescripcion#</td>
                                        <td>#CPSMascaraP#</td>
                                        <td align="center"><cfif CPSMconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMformulacion EQ 1 > Si <cfelse> No </cfif></td>                           
                                    </tr>
                            <cfelseif idlogin EQ idloginOld and primerF NEQ 0>
                                    <tr style="border-bottom:1px solid gray;">
                                        <td>#Usulogin#</td>
                                        <td>#CPSMdescripcion#</td>
                                        <td>#CPSMascaraP#</td>
                                        <td align="center"><cfif CPSMconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMformulacion EQ 1 > Si <cfelse> No </cfif></td>                           
                                    </tr>
                            <cfelseif idlogin NEQ idloginOld and primerF NEQ 0>   
                            			<tr><td colspan="8">&nbsp; </td></tr>                      		
                            			</table>
                            		</div>
                            	<div name="row#Usucodigo#" id="row#Usucodigo#" class="row#Usucodigo#" style="display:none;">
                                 <table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                 	<tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas">Descripci&oacute;n</td>
										<td class="titulolistas">Mascara</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                    </tr>
                                    <tr style="border-bottom:1px solid gray;">
                                        <td>#Usulogin#</td>
                                        <td>#CPSMdescripcion#</td>
                                        <td>#CPSMascaraP#</td>
                                        <td align="center"><cfif CPSMconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSMformulacion EQ 1 > Si <cfelse> No </cfif></td>                            
                                    </tr>
                            </cfif>
                            
                            <cfset idloginOld=idlogin>
                            </cfoutput>
                            </table>
                            </div>
                        </div>
                    </fieldset>
                    </td>
                </tr>
            </table>				
        </td>
    </tr>
</table>
<cfif isdefined("form.Usucodigo") and  len(trim(form.Usucodigo)) NEQ 0 >
<script>

<!--- chekear checkbox y mostrar permisos --->
<cfloop index="x" from="1" to="#arrayLen(listaCod)#">
	<cfset temp=listaCod[x]>
	setTimeout("mostrarPerf('<cfoutput>#temp#</cfoutput>')",1000);
</cfloop> 
</script>
</cfif>