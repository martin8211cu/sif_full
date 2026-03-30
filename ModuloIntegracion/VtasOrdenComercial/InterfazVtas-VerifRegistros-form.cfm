<!--- 
	Creado por Raúl Bravo
		Fecha: 3 Mayo 2012
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Utilidad Bruta por Orden Comercial'>

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cfset GvarEcodigo   = Session.Ecodigo>
<cfset GvarUsucodigo = Session.Usucodigo>	

<cfoutput>
<cfset LvarNavegacion = ""> 

<cfif Form.fltPeriodo NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltPeriodo=#Form.fltPeriodo#">
</cfif>

<cfif Form.fltMes NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltMes=#Form.fltMes#">
</cfif>

<cfquery name="rsValores" datasource="sifinterfaces">
select  E.Moneda, E.Tipo_Documento, I.Ecodigo, E.Contrato as Orden_Comercial, E.Periodo, E.Mes, CCTtipo, E.Clas_Venta, Tipo_Doc = case E.Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end,
Imp_Ventas = isnull((select sum(Subtotal) from ESIFLD_Facturas_Venta where Contrato = E.Contrato and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Clas_Venta = E.Clas_Venta and Tipo_Documento = E.Tipo_Documento and Moneda = E.Moneda and Utilidad_Reg = 0),0),
Imp_Costo = isnull((select sum(Monto) from SIFLD_Costo_Venta where Venta = E.Contrato and Periodo = E.Periodo and Mes <= 
<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = E.Moneda and Costo_Reg = 0),0)
from #sifinterfacesdb#..ESIFLD_Facturas_Venta E 
left join #sifinterfacesdb#..SIFLD_Costo_Venta C on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) and I.CodICTS = convert (varchar(10),C.Ecodigo)
inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where E.Estatus = 2 and E.Clas_Venta in ('PRFC','PRNF') and E.Periodo is not null and E.Mes is not null 
and Utilidad_Reg = 0 
and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((E.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (E.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= 12)) 
group by I.Ecodigo, E.Contrato, E.Mes, E.Periodo, C.Venta, CCTtipo, E.Clas_Venta, E.Tipo_Documento, E.Moneda
union
select C.Moneda, Tipo_Documento = 'FC', I.Ecodigo, C.Venta as Orden_Comercial, C.Periodo, C.Mes, CCTtipo = 'D', Clas_Venta = 'PRFC',
Tipo_Doc = 'FACT',
Imp_Ventas = 0,
Imp_Costo = isnull((select sum(Monto) from SIFLD_Costo_Venta where Venta = C.Venta and Periodo = C.Periodo and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = C.Moneda and Costo_Reg = 0),0)
from ----ESIFLD_HFacturas_Venta E inner join 
#sifinterfacesdb#..SIFLD_Costo_Venta C ----on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),C.Ecodigo)
----inner join #minisifdb#....CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where C.Estatus = 2 and C.Periodo is not null and C.Mes is not null 
----and Utilidad_Reg = 0 
and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((C.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
C.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (C.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
C.Mes <= 12)) 
group by I.Ecodigo, C.Mes, C.Periodo, C.Venta, C.Moneda
union
select  E.Moneda, E.Tipo_Documento, I.Ecodigo, E.Contrato as Orden_Comercial, E.Periodo, E.Mes, CCTtipo, E.Clas_Venta, Tipo_Doc = case E.Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end,
Imp_Ventas = isnull((select sum(Subtotal) from ESIFLD_Facturas_Venta where Contrato = E.Contrato and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Clas_Venta = E.Clas_Venta and Tipo_Documento = E.Tipo_Documento and Moneda = E.Moneda and Utilidad_Reg = 0),0),
Imp_Costo = isnull((select sum(Monto) from SIFLD_Costo_Venta where Venta = E.Contrato and Periodo = E.Periodo and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = E.Moneda and Costo_Reg = 0),0)
from #sifinterfacesdb#..ESIFLD_Facturas_Venta E 
----left join SIFLD_Costo_Venta C on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) ----and I.CodICTS = convert (varchar(10),C.Ecodigo)
inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where E.Estatus = 2 and E.Clas_Venta in ('PRFC','PRNF') and E.Periodo is not null and E.Mes is not null 
and Utilidad_Reg = 0 
---and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((E.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (E.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= 12)) 
group by I.Ecodigo, E.Contrato, E.Mes, E.Periodo,  CCTtipo, E.Clas_Venta, E.Tipo_Documento, E.Moneda ----C.Venta,
order by Orden_Comercial, Periodo, Mes, Clas_Venta
</cfquery>

<cfquery name="rsValoresHIST" datasource="sifinterfaces">
select  E.Moneda, E.Tipo_Documento, I.Ecodigo, E.Contrato as Orden_Comercial, E.Periodo, E.Mes, CCTtipo, E.Clas_Venta, Tipo_Doc = case E.Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end,
Imp_Ventas = isnull((select sum(Subtotal) from ESIFLD_HFacturas_Venta where Contrato = E.Contrato and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Clas_Venta = E.Clas_Venta and Tipo_Documento = E.Tipo_Documento and Moneda = E.Moneda and Utilidad_Reg = 0),0),
Imp_Costo = isnull((select sum(Monto) from SIFLD_HCosto_Venta where Venta = E.Contrato and Periodo = E.Periodo and Mes <= 
<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = E.Moneda and Costo_Reg = 0),0)
from #sifinterfacesdb#..ESIFLD_HFacturas_Venta E 
left join #sifinterfacesdb#..SIFLD_HCosto_Venta C on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) and I.CodICTS = convert (varchar(10),C.Ecodigo)
inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where E.Estatus = 2 and E.Clas_Venta in ('PRFC','PRNF') and E.Periodo is not null and E.Mes is not null 
and Utilidad_Reg = 0 
and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((E.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (E.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= 12)) 
group by I.Ecodigo, E.Contrato, E.Mes, E.Periodo, C.Venta, CCTtipo, E.Clas_Venta, E.Tipo_Documento, E.Moneda
union
select C.Moneda, Tipo_Documento = 'FC', I.Ecodigo, C.Venta as Orden_Comercial, C.Periodo, C.Mes, CCTtipo = 'D', Clas_Venta = 'PRFC',
Tipo_Doc = 'FACT',
Imp_Ventas = 0,
Imp_Costo = isnull((select sum(Monto) from SIFLD_HCosto_Venta where Venta = C.Venta and Periodo = C.Periodo and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = C.Moneda and Costo_Reg = 0),0)
from ----ESIFLD_HFacturas_Venta E inner join 
#sifinterfacesdb#..SIFLD_HCosto_Venta C ----on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),C.Ecodigo)
----inner join #minisifdb#....CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where C.Estatus = 2 and C.Periodo is not null and C.Mes is not null 
----and Utilidad_Reg = 0 
and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((C.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
C.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (C.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
C.Mes <= 12)) 
group by I.Ecodigo, C.Mes, C.Periodo, C.Venta, C.Moneda
union
select  E.Moneda, E.Tipo_Documento, I.Ecodigo, E.Contrato as Orden_Comercial, E.Periodo, E.Mes, CCTtipo, E.Clas_Venta, Tipo_Doc = case E.Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end,
Imp_Ventas = isnull((select sum(Subtotal) from ESIFLD_HFacturas_Venta where Contrato = E.Contrato and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Clas_Venta = E.Clas_Venta and Tipo_Documento = E.Tipo_Documento and Moneda = E.Moneda and Utilidad_Reg = 0),0),
Imp_Costo = isnull((select sum(Monto) from SIFLD_HCosto_Venta where Venta = E.Contrato and Periodo = E.Periodo and Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#"> and Moneda = E.Moneda and Costo_Reg = 0),0)
from #sifinterfacesdb#..ESIFLD_HFacturas_Venta E 
----left join SIFLD_HCosto_Venta C on E.Contrato = C.Venta 
inner join #sifinterfacesdb#..int_ICTS_SOIN I on I.CodICTS = convert (varchar(10),E.Ecodigo) ----and I.CodICTS = convert (varchar(10),C.Ecodigo)
inner join #minisifdb#..CCTransacciones T on T.CCTcodigo = E.Tipo_Documento and T.Ecodigo = I.Ecodigo
where E.Estatus = 2 and E.Clas_Venta in ('PRFC','PRNF') and E.Periodo is not null and E.Mes is not null 
and Utilidad_Reg = 0 
---and Costo_Reg = 0 
and I.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
and ((E.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
or  (E.Periodo < <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> and 
E.Mes <= 12)) 
group by I.Ecodigo, E.Contrato, E.Mes, E.Periodo,  CCTtipo, E.Clas_Venta, E.Tipo_Documento, E.Moneda ----C.Venta,
order by Orden_Comercial, Periodo, Mes, Clas_Venta
</cfquery>

	<form name="form1" method="post" action="InterfazVtas-CostoOrden-sql.cfm">
    	<input name="fltPeriodo" type="hidden" tabindex="-1" value="#form.fltPeriodo#">	
		<input name="fltMes" type="hidden" tabindex="-1" value="#form.fltMes#">	
		<table cellpadding="" cellspacing="0" border="0" align="center"> 
            <tr><td colspan="2">&nbsp;</td></tr>  
            <tr>
                <td colspan="2" align="left">#rsValores.recordcount# Registros Pendientes de Archivar</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>            
            <tr>
                <td colspan="2" align="left">#rsValoresHIST.recordcount# Registros a Procesar</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
				<td align="left"><strong>Periodo :</strong></td>
                <td align="left">#Form.fltPeriodo#</td>
            </tr>
            <tr>
                <td align="left"><strong>Mes :</strong></td>
                <td align="left">#Form.fltMes#</td>
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
            <tr>
            	<td colspan="2">
                   <table  cellpadding="" cellspacing="0" border="0" align="center">
                        <tr>
 							<td><cf_botones values="Confirmar" names="Confirmar"></td>
                            <td><cf_botones values="Cancelar" names="Cancela"></td>
                        </tr>
                    </table>
				</td> 
            </tr>
            <tr><td colspan="2">&nbsp;</td></tr>
        </table>
	</form>

    <cf_web_portlet_end>
    <cf_templatefooter>
    <cf_qforms form = 'form1'>
    
    <script language="javascript" type="text/javascript">
        function funcConfirmar() {
            if (#rsValores.recordcount#>0)
            {
                if (confirm('¿Desea Aplicar, con Registros Pendientes de Archivar?') )
                	{return true;}   <!---+++--->
                else
                	{return false;}
            }
            return true;
        }
        
        function funcCancela() {
            document.form1.action = "InterfazVtas-CostoOrden-form.cfm";		
        }
    </script>
</cfoutput>


