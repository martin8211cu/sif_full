
<!--- leer configuracion --->

<!---
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>
<cfset lvarRSSurl=objParam.ObtenerValor("#request.WidCodigo#","001")>
<cfset lvarHeight=objParam.ObtenerValor("#request.WidCodigo#","002")>
--->

<cfset lvarHeight = 250>


<cfquery name="q_Actual" datasource="#session.dsn#">
    select Codigo,FechaInicio,FechaFin,rtrim(ltrim(Tipo)) as Tipo from CRCCortes where 
		status = 0 
		and '#dateFormat(Now(),"yyyy-mm-dd")#' between FechaInicio and DATEADD(D,1,FechaFin)
		and ecodigo = #session.ecodigo# 
	ORDER BY tipo desc;
</cfquery>

<cfquery name="q_Cerrado" datasource="#session.dsn#">
    select Codigo,FechaInicio,FechaFin,rtrim(ltrim(Tipo)) as Tipo from CRCCortes where status = 1 and ecodigo = #session.ecodigo# ORDER BY tipo desc;
</cfquery>

<cfquery name="q_Vencido" datasource="#session.dsn#">
    select Codigo,FechaInicio,FechaFin,rtrim(ltrim(Tipo)) as Tipo from CRCCortes where status = 2 and ecodigo = #session.ecodigo# ORDER BY tipo desc;
</cfquery>

<cfquery name="q_Productos" datasource="#session.dsn#">
	select 
	case(A.Tipo)
		when 'D' then 'Distribuidores'
		when 'TC' then 'Tarjeta Habientes'
		when 'TM' then 'Tarjeta Mayorista'
        end as Descripcion
	, A.Tipo
	from (select distinct(rtrim(ltrim(Tipo))) as Tipo from CRCCuentas where ecodigo = #session.ecodigo#) as A
</cfquery>


<cfset padding = 'padding-left:5px; padding-right:5px; padding-top:2px; padding-bottom:2px;'>
<cfset paddingA = "#padding# color:##7cffaa;">
<cfset paddingC = "#padding# color:##ffff7c;">
<cfset paddingV = "#padding# color:##ff9191;">
<cfset styleTDB1 = "#padding# text-align:center;">
<cfset tableB = "font-size:11px;">

<cfoutput>
    <div style="column-count: 3; margin:10px;" align="center">
    <cfloop query="#q_Productos#">
        <cfquery name="q_CortesA" dbtype="query">
            select * from q_Actual where tipo = '#trim(q_Productos.Tipo)#'
        </cfquery>
        <cfquery name="q_CortesC" dbtype="query">
            select * from q_Cerrado where tipo = '#q_Productos.Tipo#'
        </cfquery>
        <cfquery name="q_CortesV" dbtype="query">
            select * from q_Vencido where tipo = '#q_Productos.Tipo#'
        </cfquery>
        <table class="table table-sm" style="width:95%;">
                <tr> <th colspan="2" style="#styleTDB1#">#q_Productos.Descripcion#</th></tr>
                <tr style="#paddingA##tableB#" >
                    <th >Corte Actual</th>
                    <td> <table> 
                        <cfif q_CortesA.recordCount neq 0>
                            <cfloop query="#q_CortesA#">
                                <tr>
                                    <td style="#paddingA#"><b>#q_CortesA.Codigo#</b></td>
                                    <td style="#paddingA#">(#DateFormat(q_CortesA.FechaInicio,'dd/mm/yyyy')# - #DateFormat(q_CortesA.FechaFin,'dd/mm/yyyy')#)</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td style="#paddingA#"><b> N/D</b></td>
                                <td style="#paddingA#"> N/D - N/D</td>
                            </tr>
                        </cfif>
                    </table> </td>
                </tr>
                <tr style="#paddingC##tableB#">
                    <th >Ultimo Corte Cerrado</th>
                    <td> <table> 
                        <cfif q_CortesC.recordCount neq 0>
                            <cfloop query="#q_CortesC#">
                                <tr>
                                    <td style="#paddingC#"><b>#q_CortesC.Codigo#</b></td>
                                    <td style="#paddingC#">(#DateFormat(q_CortesC.FechaInicio,'dd/mm/yyyy')# - #DateFormat(q_CortesC.FechaFin,'dd/mm/yyyy')#)</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td style="#paddingC#"><b> N/D</b></td>
                                <td style="#paddingC#"> N/D - N/D</td>
                            </tr>
                        </cfif>
                    </table> </td>
                </tr>
                <tr style="#paddingV##tableB#">
                    <th >Ultimo Corte Vencido</th>
                    <td> <table> 
                        <cfif q_CortesV.recordCount neq 0>
                            <cfloop query="#q_CortesV#">
                                <tr>
                                    <td style="#paddingV#"><b>#q_CortesV.Codigo#</b></td>
                                    <td style="#paddingV#">(#DateFormat(q_CortesV.FechaInicio,'dd/mm/yyyy')# - #DateFormat(q_CortesV.FechaFin,'dd/mm/yyyy')#)</td>
                                </tr>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td style="#paddingV#"><b> N/D</b></td>
                                <td style="#paddingV#"> N/D - N/D</td>
                            </tr>
                        </cfif>
                    </table> </td>
                </tr>
        </table>
    </cfloop>
    </div>
</cfoutput>