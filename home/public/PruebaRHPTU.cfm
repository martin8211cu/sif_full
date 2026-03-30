<cfquery name="rs" datasource="#session.DSN#">
    select FechaDesde, FechaHasta, DEid, RHPTUEid
    from RHPTUEMpleados
    where RHPTUEMid =67
</cfquery>
<cfdump var="#rs#">

<cfinvoke component="rh.Componentes.RH_PTU" 
method="fnDiasPagar"
returnvariable="LvarResultado"
DEid = "#rs.DEid#"
RHPTUEid="#rs.RHPTUEid#"
FvarFechaDesde = "#rs.FechaDesde#"
FvarFechaHasta = "#rs.FechaHasta#"
/>

<cfoutput>Resultado: #LvarResultado#</cfoutput>

<!---
<cfset LvarArray = arraynew(2)> 
<cfset LvarArray[1][1] = createdate(2006,5,1)>
<cfset LvarArray[1][2] = createdate(2006,5,1)>
<cfset LvarArray[1][3] = createdate(6100,1,1)>
<cfset LvarArray[1][4] = createdate(2008,1,1)>
<cfset LvarArray[1][5] = createdate(2008,12,31)>

<cfset LvarArray[2][1] = createdate(2008,5,1)>
<cfset LvarArray[2][2] = createdate(2008,5,1)>
<cfset LvarArray[2][3] = createdate(6100,1,1)>
<cfset LvarArray[2][4] = createdate(2008,1,1)>
<cfset LvarArray[2][5] = createdate(2008,12,31)>

<cfset LvarArray[3][1] = createdate(2008,5,1)>
<cfset LvarArray[3][2] = createdate(2008,5,1)>
<cfset LvarArray[3][3] = createdate(2008,10,30)>
<cfset LvarArray[3][4] = createdate(2008,1,1)>
<cfset LvarArray[3][5] = createdate(2008,12,31)>

<cfset LvarArray[4][1] = createdate(2006,5,1)>
<cfset LvarArray[4][2] = createdate(2008,2,2)>
<cfset LvarArray[4][3] = createdate(6100,1,1)>
<cfset LvarArray[4][4] = createdate(2008,1,1)>
<cfset LvarArray[4][5] = createdate(2008,12,31)>

<cfset LvarArray[5][1] = createdate(2006,5,1)>
<cfset LvarArray[5][2] = createdate(2007,7,31)>
<cfset LvarArray[5][3] = createdate(2008,7,31)>
<cfset LvarArray[5][4] = createdate(2008,1,1)>
<cfset LvarArray[5][5] = createdate(2008,12,31)>

<cfset LvarArray[6][1] = createdate(2006,5,1)>
<cfset LvarArray[6][2] = createdate(2007,7,3)>
<cfset LvarArray[6][3] = createdate(6100,1,1)>
<cfset LvarArray[6][4] = createdate(2008,1,1)>
<cfset LvarArray[6][5] = createdate(2008,12,31)>


<cfdump var="#LvarArray#">


<table border="1" cellpadding="1" cellspacing="1">
    <cfloop from="1" to="6" step="1" index="i">
        <tr>
	        <td>
			   <cfset LvarResult = fnDiasPagarParams(rs.Deid,LvarArray[i][1],LvarArray[i][2],LvarArray[i][3],LvarArray[i][4],LvarArray[i][5])>
               <cfoutput>Resultado: #LvarResult#</cfoutput>
	        </td>
        </tr>
    </cfloop>
</table>






<cffunction name="fnDiasPagarParams" access="public" output="true" returntype="numeric"  hint="Calculos de Días a Pagar">
	<cfargument name="DEid" type="numeric" required="yes" hint="Empleado">
    <cfargument name="EVfantig" type="date" required="yes" hint="Fecha Antiguedad">
    <cfargument name="LTdesde" type="date" required="yes" hint="Fecha Desde Linea T">
    <cfargument name="LThasta" type="date" required="yes" hint="Fecha Hasta Linea T">
    <cfargument name="FvarFechaDesde" type="date" required="yes" hint="Fecha Desde PTU">
    <cfargument name="FvarFechaHasta" type="date" required="yes" hint="Fecha Hasta PTU">
    <cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
    
    <!--- 
        DateCompare:
          -1: La fecha 1 es anterior a la fecha 2, 
          0: las dos fechas son iguales, 
          1: la fecha 1 es porsterior a la fecha 2--->
    <!--- La fecha Desde compara primero la fecha de antiguedad (no considera Ecodigo) contra LTdesde el resultado contra la Fecha Desde Periodo PTU --->
    <cfset LvarFechaDesde = 0>
    <cfif DateCompare(arguments.EVfantig, arguments.LTdesde, 'd') LTE 0>
        <cfif DateCompare(arguments.LTdesde, arguments.FvarFechaDesde, 'd') LTE 0>
            <cfset LvarFechaDesde = arguments.FvarFechaDesde>
        <cfelse>
            <cfset LvarFechaDesde = arguments.LTdesde>
        </cfif>
    <cfelse>
        <cfif DateCompare(arguments.EVfantig, arguments.FvarFechaDesde, 'd') LTE 0>
            <cfset LvarFechaDesde = arguments.FvarFechaDesde>
        <cfelse>
            <cfset LvarFechaDesde = arguments.EVfantig>
        </cfif>
    </cfif>
    <cfoutput>Fecha Desde: #LvarFechaDesde#</cfoutput><br>
<!---     <cfoutput>arguments.FvarFechaHasta: #arguments.FvarFechaHasta#</cfoutput><br>
    <cfoutput>arguments.LThasta :#arguments.LThasta#</cfoutput><br> --->
    
    <!--- La fehca hasta solo compara LThasta contra FechaHasta Periodo PTU --->
    <cfset LvarFechaHasta = 0>
    <!--- <cfoutput>Datecompare: #DateCompare(arguments.LThasta, arguments.FvarFechaHasta, 'd')#</cfoutput><br> --->
    <cfif DateCompare(arguments.LThasta, arguments.FvarFechaHasta, 'd') GT 0><!--- Entra1<br> --->
        <cfset LvarFechaHasta = arguments.FvarFechaHasta>
    <cfelse><!--- Entra2<br> --->
        <cfset LvarFechaHasta = arguments.LThasta>
    </cfif>
    <cfoutput>Fecha Hasta: #LvarFechaHasta#</cfoutput>
    
    <!--- Si entra por acá se debe calcular los días laborados (menos de 1 año) --->
    <cfset LvarDias = DateDiff("d", LvarFechaDesde, LvarFechaHasta)> <!---  FechaHasta - FechaDesde --->

    <cfif LvarDias gt 365>
        <cfset LvarDias = 365>
    </cfif>
    
    <cfset LvarDiasFalta = 0>
    <cfquery name="rsDiasFalta" datasource="#arguments.conexion#">
        select coalesce(sum(b.PEcantdias),0) as DiasFalta
        from HRCalculoNomina a
            inner join HPagosEmpleado b
              on b.RCNid = a.RCNid
            inner join RHTipoAccion c
              on c.RHTid = b.RHTid
        where b.DEid = #arguments.DEid#
            and c.RHTcomportam = 13 <!--- Ausencia / Falta --->
            and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
            and a.Ecodigo = #session.Ecodigo#
            and a.RCdesde >= #LvarFechaDesde#
            and a.RChasta <= #LvarFechaHasta#
            and b.PEdesde >= #LvarFechaDesde#
            and b.PEhasta <= #LvarFechaHasta#
    </cfquery><cfdump var="#rsDiasFalta#">
    
    <cfif rsDiasFalta.recordcount gt 0 and rsDiasFalta.DiasFalta gt 0>
        <cfset LvarDiasFalta = rsDiasFalta.DiasFalta>
    </cfif>
    <cfoutput>dias: #LvarDias#</cfoutput><br>
    <cfoutput>diasFalta: #LvarDiasFalta# </cfoutput><br>
    <cfset LvarResultado = LvarDias + (LvarDiasFalta * -1)>
    
    <cfreturn LvarResultado>
</cffunction>
 --->

<!--- <cfinvoke component="rh.Componentes.RH_PTU" 
method="fnDiasPagar"
returnvariable="LvarResultado"
DEid = "#rs.DEid#"
RHPTUEid="#rs.RHPTUEid#"
FvarFechaDesde = "#Lvardes#"
FvarFechaHasta = "#Lvarhas#"
/>  --->




<!--- <cfinvoke component="rh.Componentes.RH_PTU" 
method="fnSueldoAnual"
returnvariable="LvarResultado"
DEid = "#rs.DEid#"
FechaDesde = "20090301"
FechaHasta = "20090401"
/> --->
<!--- 
<cfoutput>Resultado: #LvarResultado#</cfoutput>  --->