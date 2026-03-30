<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:25px;">
    <tr>
        <td width="30%" valign="top">
          <cfinclude template="exportarUserLista.cfm">
        </td>
        <td width="70%" valign="top">
            <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <fieldset><legend>Lista de Permisos de Usuario a Exportar</legend>
                        <div style="overflow:auto; height: 400px; width: 690px; margin:0;" >
                        
                        <table width="100%"  border="0" cellspacing="1" cellpadding="1" id="demo" class="demo">
                                    <tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas" colspan="2">Centro Funcional</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                        <td class="titulolistas">Aprobaci&oacute;n</td>
                                    </tr>
                        </table>
                        	<cfquery name="rsListatotal" datasource="#session.dsn#">
                                select u.Usulogin, cf.CFcodigo, cf.CFdescripcion, cps.CPSUconsultar , cps.CPSUtraslados ,
                                cps.CPSUreservas , cps.CPSUformulacion , cps.CPSUaprobacion,u.Usucodigo
                                from 
                                Usuario u left join CPSeguridadUsuario cps on cps.Usucodigo=u.Usucodigo
                                join CFuncional cf on cf.CFid=cps.CFid
                                where 
                                cps.Ecodigo=#session.Ecodigo#
                                and u.CEcodigo=#session.CEcodigo#
                                order by u.Usucodigo, u.Usulogin desc
                            </cfquery>
                           <cfset primerF=0> <cfset idlogin=0> <cfset idloginOld=0>
                            <cfoutput query="rsListatotal"><cfset idlogin= Usucodigo>
                            <cfif primerF EQ 0>
                            	<cfset primerF=1>
                                <div name="row#Usucodigo#" id="row#Usucodigo#" class="row#Usucodigo#" style="display:none;">
                                 <table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                    <tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas" colspan="2">Centro Funcional</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                        <td class="titulolistas">Aprobaci&oacute;n</td>
                                    </tr>
                                    <tr style="border-bottom:1px solid gray;">
                                        <td>#Usulogin#</td>
                                        <td>#CFcodigo#</td>
                                        <td>#CFdescripcion#</td>
                                        <td align="center"><cfif CPSUconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUformulacion EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUaprobacion EQ 1 > Si <cfelse> No </cfif></td>                            
                                    </tr>
                            <cfelseif idlogin EQ idloginOld and primerF NEQ 0>
                                    <tr>
                                        <td style="border-top:1px solid gray;">#Usulogin#</td>
                                        <td style="border-top:1px solid gray;">#CFcodigo#</td>
                                        <td style="border-top:1px solid gray;">#CFdescripcion#</td>
                                        <td style="border-top:1px solid gray;" align="center"><cfif CPSUconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td style="border-top:1px solid gray;" align="center"><cfif CPSUtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td style="border-top:1px solid gray;" align="center"><cfif CPSUreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td style="border-top:1px solid gray;" align="center"><cfif CPSUformulacion EQ 1 > Si <cfelse> No </cfif></td>
                                        <td style="border-top:1px solid gray;" align="center"><cfif CPSUaprobacion EQ 1 > Si <cfelse> No </cfif></td>                            
                                    </tr>
                            <cfelseif idlogin NEQ idloginOld and primerF NEQ 0>   
                            			<tr><td colspan="8">&nbsp; </td></tr>                      		
                            			</table>
                            		</div>
                            	<div name="row#Usucodigo#" id="row#Usucodigo#" class="row#Usucodigo#" style="display:none;">
                                 <table width="100%"  border="0" cellspacing="1" cellpadding="1">
                                 	<tr>
                                        <td class="titulolistas">Login</td>
                                        <td class="titulolistas" colspan="2">Centro Funcional</td>
                                        <td class="titulolistas">Consultar</td>
                                        <td class="titulolistas">Traslados</td>
                                        <td class="titulolistas">Reservas</td>
                                        <td class="titulolistas">Formulaci&oacute;n</td>
                                        <td class="titulolistas">Aprobaci&oacute;n</td>
                                    </tr>
                                    <tr style="border-bottom:1px solid gray;">
                                        <td>#Usulogin#</td>
                                        <td>#CFcodigo#</td>
                                        <td>#CFdescripcion#</td>
                                        <td align="center"><cfif CPSUconsultar EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUtraslados EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUreservas EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUformulacion EQ 1 > Si <cfelse> No </cfif></td>
                                        <td align="center"><cfif CPSUaprobacion EQ 1 > Si <cfelse> No </cfif></td>                            
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