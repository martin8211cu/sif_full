<cfquery name="rsTitulo" datasource="#session.DSN#">
    select Edescripcion from Empresas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif url.Formato eq 1> <!--- Html / Excel --->
	<style type="text/css">
        <!--
        .style1 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            font-weight: bold;
        }
        .style6 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
        }
        .style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
        
        .style4 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
            font-weight: bold;
        }
        .style5 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 11px;
            font-weight: bold;
        }
        .style2 {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 7px;
            font-weight: bold;
        }
        -->
    </style>	

	<cfset LvarFileName = "Empresas-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
    <cf_htmlReportsHeaders 
        title="Empresas" 
        filename="#LvarFileName#"
        preview="no"
        irA="Consultas.cfm" 
        method = "get"
        >
        <table width="100%" border="0">
            <tr>
                <td  align="center" colspan="8"><span class="style3"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></span></td>
            </tr>
            <tr>
                <td  align="center" colspan="8"><span class="style3"><cf_translate key="LB_Empresa">Empresa</cf_translate></span></td>
            </tr>
            <tr>
                <td colspan="8">
                    <cfinclude template="Reporte2_Emp.cfm"> 
                </td>
            </tr>
        </table>
<cfelse><!--- PDF / FLASH --->
	<cfif url.Formato eq 2>
        <cfset formato = "pdf">
    <cfelseif url.Formato eq 3>
        <cfset formato = "flashpaper">
    </cfif>
   
    <cfdocument format="#formato#" 
        marginleft="2" 
        marginright="2" 
        marginbottom="3"
        margintop="1" 
        unit="cm"  fontembed="yes"
    	pagetype="letter">
		<style type="text/css">
            <!--
            .style1 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 14px;
                font-weight: bold;
            }
            .style2 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 9px;
            }
            .style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
            
            .style4 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 10px;
                font-weight: bold;
            }
            .style5 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .style6 {
                font-family: Arial, Helvetica, sans-serif;
                font-size: 8px;
            }
            -->
        </style>	        
        <table width="100%" border="0">
            <cfdocumentitem type="footer">
                <tr>
                    <td  align="center" colspan="8"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></td>
                </tr>
            </cfdocumentitem>
            <tr>
                <td  align="center" colspan="8"><span class="style3"><cfoutput>#rsTitulo.Edescripcion#</cfoutput></span></td>
            </tr>

            <tr>
                <td  align="center" colspan="8"><span class="style3"><cf_translate key="LB_Empresa">Empresa</cf_translate></span></td>
            </tr>
            <tr>
                <td colspan="8">
                    <cfinclude template="Reporte2_Emp.cfm"> 
                </td>
            </tr>

        </table>
	</cfdocument>
</cfif>        