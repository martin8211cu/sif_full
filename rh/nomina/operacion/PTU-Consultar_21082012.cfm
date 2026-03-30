<!--- Variables por URL --->
<cfif isdefined("url.RHPTUEMid") and len(trim(url.RHPTUEMid))>
	<cfset form.RHPTUEMid = url.RHPTUEMid>
</cfif>
<cfif isdefined("url.RHPTUEid") and len(trim(url.RHPTUEid))>
	<cfset form.RHPTUEid = url.RHPTUEid>
</cfif>

<!--- Consulta de la Empleados PTU --->
<cfquery name="rsEmpleadosPTUconsultar" datasource="#session.DSN#">
	select 
       c.FechaDesde as FechaDesdePTU,
       c.FechaHasta as FechaHastaPTU,
       a.FechaDesde,
       a.FechaHasta,
       a.RHPTUEMfecha,
       a.RHPTUEMDiasAPagar,
       a.RHPTUEMSueldoAnual,
       a.RHPTUEMTotalSueldoPagado,
       a.RHPTUEMTotalDiasLaborados,
       a.RHPTUEMMontoParcialPTU,
       a.RHPTUEMFactorXDias,
       a.RHPTUEMFactorCuotaDiaria,
       a.RHPTUEMxDiasLaborados,
       a.RHPTUEMCuotaDiaria,
       a.RHPTUEMTotalPTU,
       a.RHPTUEMSalarioMinimo,
       a.RHPTUEMExenta,
       a.RHPTUEMGravable,
       a.RHPTUEMGravadaMensual,
       a.RHPTUEMSueldoMensual,
       a.RHPTUEMBaseGravable,
       a.RHPTUEMImpuestoCalculado,
       a.RHPTUEMImpuestoOrdinario,
       a.RHPTUEMDiferenciaISPT,
       a.RHPTUEMProporcionPTU,
       a.RHPTUEMISPTRetencionPTU,
       a.RHPTUEMNetaRecibir,
       case when a.RHPTUEMreconocido = 1
            then 
            	'<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif''; />'
            else 
            	'<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif'';/>'
       end as RHPTUEMreconocido,
       a.RHPTUEMjustificacion,
       b.DEidentificacion,
       {fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } as DEnombre,
       c.RHPTUEcodigo,
       c.RHPTUEdescripcion,
       c.RHPTUEMonto,
       d.Edescripcion,
       rtrim(e.Deptocodigo) as Deptocodigo,
       rtrim(e.Ddescripcion) as Ddescripcion, 
       ltrim(rtrim(f.RHPcodigo)) as RHPcodigo,
       coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigoext, 
       rtrim(f.RHPdescpuesto) as RHPdescpuesto,
       rtrim(g.Oficodigo) as Oficodigo,
       rtrim(g.Odescripcion) as Odescripcion,
       ee.Msimbolo
   
    from RHPTUEMpleados a
        inner join DatosEmpleado b
            on a.DEid = b.DEid
        inner join RHPTUE c
            on c.RHPTUEid = a.RHPTUEid
        inner join Empresas d
            on d.Ecodigo = a.Ecodigo
        inner join Monedas ee
        	on ee.Ecodigo = d.Ecodigo
            and ee.Mcodigo = d.Mcodigo
        left outer join Departamentos e
            on a.Dcodigo = e.Dcodigo
            and a.Ecodigo = e.Ecodigo
        left outer join RHPuestos f
            on a.RHPcodigo = f.RHPcodigo
            and a.Ecodigo = f.Ecodigo
        left outer join Oficinas g
            on a.Ocodigo = g.Ocodigo
            and a.Ecodigo = g.Ecodigo
    where a.RHPTUEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEMid#">
    and a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
    and a.Ecodigo = #Session.Ecodigo#
</cfquery>

<style type="text/css">
	.letra6{font-size:6px;}
	.letra10{font-size:10px;}
	.letra11{font-size:11px;}
	.letra12{font-size:12px;}
	.letra13{font-size:13px;}
	.letra14{font-size:14px;}
	.letra16{font-size:16px;}
	.letra20{font-size:20px;}
	.letra24{font-size:24px;}
</style>
	
<!----================= TRADUCCION =====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"
	returnvariable="BTN_Cerrar"/>



<!--- 
Situación Propuesta
Empresa 	Quiznos
Acción Masiva 	Prueba
Fecha Desde 	01/01/2010
Fecha Hasta 	01/02/2010
Empleado 	Carlos Andres Chaves Muýoz
Reconocido 
Reconocido por 	Lizandro Villalobos Castro
Fecha 	09/09/2010
Reevaluado 
 --->

<cfoutput>
    <form name="form1" style="margin: 0;" >
        <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" style="border: 1px solid gray;">
            <tr>
                <td class="letra14" align="center" colspan="4" bgcolor="##00CCFF">
                    <cf_translate key="LB_Situacion_Propuesta"><strong>Situaci&oacute;n Propuesta</strong></cf_translate>
                </td>
            </tr>
            <tr>
                <td class="letra20" colspan="4" align="center">
                    <strong>Empresa:</strong> #rsEmpleadosPTUconsultar.Edescripcion# 
                </td>
            </tr>
            <tr class="letra24">
                <td colspan="4" align="center">
                    <strong>Relación PTU:</strong> #rsEmpleadosPTUconsultar.RHPTUEcodigo# - #rsEmpleadosPTUconsultar.RHPTUEdescripcion#
                </td>
            </tr>
            <tr class="letra20">
                <td colspan="4" align="center">
                    <strong>Periodo:</strong> #year(rsEmpleadosPTUconsultar.FechaDesdePTU)#
                </td>
            </tr>
            <tr>
            	<td colspan="4">&nbsp;</td>
            </tr>
			<tr class="letra14">
                <td>
                    <strong>Fecha Rige:</strong>
                </td>
                <td>  
                    #dateformat(rsEmpleadosPTUconsultar.FechaDesdePTU,'dd/mm/yyyy')#
                </td>
                <td>
                    <strong>Fecha Vence:</strong>
                </td>
                <td>
                    #dateformat(rsEmpleadosPTUconsultar.FechaHastaPTU,'dd/mm/yyyy')#
                </td>
            </tr>
            <tr class="letra14">
                <td  style="border-bottom-style:inset"><strong>
                <label title="Importe Total otorgado por la empresa a repartir entre los empleados">Monto total a distribuir:</label></strong> </td>
                <td colspan="3"  style="border-bottom-style:inset"><label title="Importe Total otorgado por la empresa a repartir entre los empleados">#numberformat(rsEmpleadosPTUconsultar.RHPTUEMonto,',.__')#</label></td>
            </tr>
            
            <tr class="letra6">
                <td colspan="4">&nbsp;
                    
                </td>
            </tr>
            <tr class="letra14">
                <td>
                    <strong>Empleado:</strong> </td>
                <td>
                    #rsEmpleadosPTUconsultar.DEnombre#
                </td>
                <td>
                    <strong>Identificación:</strong>
                </td>
                <td>
                    #rsEmpleadosPTUconsultar.DEidentificacion#
                </td>
            </tr>
            <tr style="border-bottom-style:dotted" class="letra14">
                <td>
                    <strong>Fecha Inicio Periodo:</strong>
                </td>
                <td> 
                    #dateformat(rsEmpleadosPTUconsultar.FechaDesde,'dd/mm/yyyy')#
                </td>
                <td>
                    <strong>Fecha Fin Periodo:</strong> 
                </td>
                <td>
                    #dateformat(rsEmpleadosPTUconsultar.FechaHasta,'dd/mm/yyyy')#
                </td>
            </tr>
            <tr class="letra14">
                <td colspan="4" style="border-bottom-style:inset">
                    <strong>Reconocido:</strong> #rsEmpleadosPTUconsultar.RHPTUEMreconocido#
                </td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Días trabajados durante el ejercicio a pagar - (menos) faltas del ejercicio">Días a Pagar:</label></strong> </td>
                <td><label title="Días trabajados durante el ejercicio a pagar - (menos) faltas del ejercicio">#rsEmpleadosPTUconsultar.RHPTUEMDiasAPagar#</label></td>
                <td><strong><label title="El total de sueldo mensual dividido entre 30 y ese resultado es multiplicado por los Días a Pagar">Sueldo Anual:</label></strong> </td>
                <td colspan="3" align="right"><label title="El total de sueldo mensual dividido entre 30 y ese resultado es multiplicado por los Días a Pagar">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMSueldoAnual,',.__')#</label></td>
            </tr>
            <tr class="letra6">
                <td colspan="4">&nbsp;
                    
                </td>
            </tr>
            <tr class="letra14">
            	<td><strong><label title="Suma de los días laborados de todos los empleados">Total Días Laborados*:</label></strong> </td>
                <td><label title="Suma de los días laborados de todos los empleados"> #numberformat(rsEmpleadosPTUconsultar.RHPTUEMTotalDiasLaborados,',.__')#</label></td>
                <td><strong><label title="Suma de los sueldos percibidos al año de todos los empleados">Total Sueldo Pagado*:</label></strong> </td>
                <td align="right"><label title="Suma de los sueldos percibidos al año de todos los empleados">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMTotalSueldoPagado,',.__')#</label></td>
            </tr>
            <tr class="letra6">
            	<td colspan="4">&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Monto del PTU divido entre 2">Monto Parcial PTU:</label></strong> </td>
                <td align="right"><label title="Monto del PTU divido entre 2">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMMontoParcialPTU,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Monto Parcial de PTU dividido entre total de días laborados del año (todos los empleados)">Factor por días*:</label></strong> </td>
                <td align="right"><label title="Monto Parcial de PTU dividido entre total de días laborados del año (todos los empleados)"> #numberformat(rsEmpleadosPTUconsultar.RHPTUEMFactorXDias,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Monto parcial dividido entre total de sueldo pagados de todo el año (todos los empleados)">Factor cuota diaria*:</label></strong> </td>
                <td align="right"><label title="Monto parcial dividido entre total de sueldo pagados de todo el año (todos los empleados)"> #numberformat(rsEmpleadosPTUconsultar.RHPTUEMFactorCuotaDiaria,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Días a pagar multiplicado por Factor por días">Días Laborados:</label></strong> </td>
                <td align="right"><label title="Días a pagar multiplicado por Factor por días"> #numberformat(rsEmpleadosPTUconsultar.RHPTUEMxDiasLaborados,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Sueldo Anual multiplicado por Factor cuota diaria">Cuota Diaria:</label></strong> </td>
                <td align="right"><label title="Sueldo Anual multiplicado por Factor cuota diaria">#rsEmpleadosPTUconsultar.Msimbolo#  #numberformat(rsEmpleadosPTUconsultar.RHPTUEMCuotaDiaria,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td style="border-bottom-style:inset"><strong><label title="PTU días laborados mas PTU Cuota Diaria">Total PTU:</label></strong> </td>
                <td style="border-bottom-style:inset" align="right"><label title="PTU días laborados mas PTU Cuota Diaria">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMTotalPTU,',.__')#</label></td>
                <td style="border-bottom-style:inset">&nbsp;</td>
                <td style="border-bottom-style:inset">&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Parametro de RH: Salario Mínimo General Zona A (SMGA)">Salario mínimo:</label></strong> </td>
                <td align="right"><label title="Parametro de RH: Salario Mínimo General Zona A (SMGA)">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMSalarioMinimo,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Salario mínimo multiplicado por 15">PTU Exenta:</label></strong> </td>
                <td align="right"><label title="Salario mínimo multiplicado por 15">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMExenta,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Total PTU menos PTU Exenta">PTU Gravable:</label></strong> </td>
                <td align="right"><label title="Total PTU menos PTU Exenta">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMGravable,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td><strong>
                <label title="Se divide el importe obtenido en el PTU Gravable entre 365 días y el total es multiplicado por el factor fijo 30.4">PTU Gravable mensual:</label></strong> </td>
                <td align="right"><label title="Se divide el importe obtenido en el PTU Gravable entre 365 días y el total es multiplicado por el factor fijo 30.4">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMGravadaMensual,',.__')#</label></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td style="border-top-style:inset"><strong><label title="Sueldo mensual del empleado">Sueldo Mensual:</label></strong> </td>
                <td align="right" style="border-top-style:inset"><label title="Sueldo mensual del empleado">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMSueldoMensual,',.__')#</label></td>
                <td style="border-top-style:inset"><strong>
                <label title="((((Sueldo Mensual - limite inferior tabla) * % Sobre Excedente) + Cuota Fija) - Subsidio al Empleo)">ISPT Ordinario:</label></strong> </td>
                <td align="right" style="border-top-style:inset"><label title="((((Sueldo Mensual - limite inferior tabla) * % Sobre Excedente) + Cuota Fija) - Subsidio al Empleo)">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMImpuestoOrdinario,',.__')#</label></td>
            </tr>
            <tr class="letra14">
                <td><strong><label title="Se obtiene sumando el importe del PTU Gravada mensual y el importe del sueldo mensual">Base Gravable:</label></strong> </td>
                <td align="right"><label title="Se obtiene sumando el importe del PTU Gravada mensual y el importe del sueldo mensual">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMBaseGravable,',.__')#</label></td>
                <td><strong>
                <label title="((((Base Gravable - limite inferior tabla) * % Sobre Excedente) + Cuota Fija) - Subsidio al Empleo)">ISPT Calculado:</label></strong> </td>
                <td align="right"><label title="((((Total Gravable - limite inferior tabla) * % Sobre Excedente) + Cuota Fija) - Subsidio al Empleo)">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMImpuestoCalculado,',.__')#</label></td>
            </tr>
            <tr class="letra6">
            	<td colspan="4" style="height:1px">&nbsp;</td>
            </tr>
            <tr class="letra14">
            	<td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><strong><label title="Si el impuesto ordinario es mayor al impuesto calculado no se descuenta impuesto al PTU se da integro el importe calculado la Diferencia ISPT es cero, en caso contrario se resta el impuesto ordinario y se obtiene una diferencia">Diferencia ISPT:</label></strong> </td>
                <td align="right"><label title="Si el impuesto ordinario es mayor al impuesto calculado no se descuenta impuesto al PTU se da integro el importe calculado la Diferencia ISPT es cero, en caso contrario se resta el impuesto ordinario y se obtiene una diferencia">#rsEmpleadosPTUconsultar.Msimbolo#  #numberformat(rsEmpleadosPTUconsultar.RHPTUEMDiferenciaISPT,',.__')#</label></td>
            </tr>
			<tr class="letra6">
            	<td colspan="4">&nbsp;</td>
            </tr>
            <tr class="letra14">
           	  <td>&nbsp;</td>
                <td><strong><label title="Si la Diferencia ISPT es mayor que la PTU Gravable mensual Calculado no se descuenta impuesto al PTU y pa Proporción del PTU es cero, se da integro el importe calculado, en caso contrario divide la Diferencia ISPT entre la PTU Gravable Mensual">Proporción PTU:</label></strong> </td>
                <td align="right"><label title="Si la Diferencia ISPT es mayor que la PTU Gravable mensual Calculado no se descuenta impuesto al PTU y pa Proporción del PTU es cero, se da integro el importe calculado, en caso contrario divide la Diferencia ISPT entre la PTU Gravable Mensual"> #rsEmpleadosPTUconsultar.RHPTUEMProporcionPTU#</label></td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
                <td>&nbsp;</td>
                <td><strong><label title="Se multiplica la Proporción del PTU por PTU Gravable">ISPT Retención PTU:</label></strong> </td>
                <td align="right"><label title="Se multiplica la Proporción del PTU por PTU Gravable">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMISPTRetencionPTU,',.__')#</label></td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra14">
           	  <td>&nbsp;</td>
                <td><strong><label title="Se resta el Total PTU menos Retención PTU">PTU neta a recibir:</label></strong> </td>
                <td align="right"><label title="Se resta el Total PTU menos Retención PTU">#rsEmpleadosPTUconsultar.Msimbolo# #numberformat(rsEmpleadosPTUconsultar.RHPTUEMNetaRecibir,',.__')#</label></td>
                <td>&nbsp;</td>
            </tr>
            <tr class="letra6">
            	<td>&nbsp;</td>
            </tr>
            <tr class="letra12">
            	<td colspan="4">
                	* Corresponde a todos los empleados que se incluyeron en la nómina del PTU.
                </td>
            </tr>
        </table>
        <table border="0" width="100%">
            <tr>
                <td align="center" colspan="4">
                	<input type="button" name="Cerrar" value="#BTN_Cerrar#" onClick="javascrip: return cerrar()">
                </td>
            </tr>
        </table>
    </form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function cerrar() {
		window.close();
	}
</script>
