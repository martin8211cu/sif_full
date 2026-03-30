<cfsetting requesttimeout="3600">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
    select ETLCid, ETLCpatrono,ETLCnomPatrono from EmpresasTLC
    where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.ETLCid#">
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
            font-size: 9px;
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
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr  bgcolor="#A9C9CD">
					<td  align="center" colspan="8"><span class="style3">Alianza para el Si</span></td>
				</tr>
            <tr>
                <td colspan="8">
                    <cfinclude template="Reporte3_Emp.cfm"> 
                </td>
            </tr>
        </table>
<cfelse><!--- PDF / FLASH --->
	<cfif url.Formato eq 2>
		<cfset formato = "pdf">
	<cfelseif url.Formato eq 3>
		<cfset formato = "flashpaper">
	</cfif>
	<!---
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select 
			ETLCid, 
			ETLCpatrono,
			ETLCnomPatrono
		from EmpresasTLC
		where ETLCcantidadEmpleados between 50 and 60
		order by ETLCcantidadEmpleados desc, ETLCpatrono asc
	</cfquery>
	--->

	<cfloop query="rsEmpresa">
		<cfset URL.ETLCid = rsEmpresa.ETLCid>
		<cfset LvarNombre = "#left(rsEmpresa.ETLCnomPatrono, 45)#-#rsEmpresa.ETLCpatrono#">
		<cfset LvarNombre = replace(LvarNombre, '"', '','all')>
		<cfset LvarNombre = replace(LvarNombre, "'", '','all')>
		<cfset LvarNombre = replace(LvarNombre, ":", ' ','all')>
		<cfset LvarNombre = replace(LvarNombre, ".", ' ','all')>
		<cfset LvarNombre = replace(LvarNombre, ",", ' ','all')>
		<cfset LvarNombre = replace(LvarNombre, ";", ' ','all')>
		<cfset LvarNombre = "c:\Alianza\#LvarNombre#.#formato#">
		<cfdocument format="#formato#"  filename="#LvarNombre#" overwrite="yes"
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
					font-size: 8px;
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
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr  bgcolor="#A9C9CD">
					<td  align="center" colspan="8"><span class="style3">Alianza para el Si</span></td>
				</tr>
				<tr>
					<td colspan="8">
						<cfinclude template="Reporte3_Emp.cfm"> 
					</td>
				</tr>
			</table>
		</cfdocument>
	</cfloop>
	Terminado!!!
</cfif>        