<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Utilidad Bruta por Orden Comercial'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">

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
from ----ESIFLD_Facturas_Venta E inner join 
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

<cfif rsValores.recordcount EQ 0>
	<cfthrow message="No existen registros nuevos para procesar">
</cfif>

<!---<!---Verifica periodo y mes activos en la contabilidad---->				
<cfquery name="rsVerificaPeriodo" datasource="#session.dsn#">
	select (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                 "#GvarEcodigo#"> and Pcodigo = 60) as Mes,
    (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    "#GvarEcodigo#"> and Pcodigo = 50) as Año
</cfquery>--->

<cfquery datasource="#session.dsn#">
	delete UtilidadBruta where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>			
			
<cfloop query="rsValores">
	<!----Valida que el mes haya sido cerrado---->
<!---	<cfset Valido = false>				
	<cfif form.fltPeriodo LT rsVerificaPeriodo.Año>
	 	<cfset Valido = true>
	<cfelseif rsVerificaPeriodo.Año EQ form.fltPeriodo and form.fltMes LT rsVerificaPeriodo.Mes>
	 	<cfset Valido = true>
	</cfif>
				       				 				
	<cfif Valido EQ true> --->
		<cfquery name="rsVerifica" datasource="#session.dsn#">
	    	select Ecodigo, Periodo, Mes, Clas_Venta, Orden_Comercial, CCTtipo, Moneda, Imp_Ingreso, Imp_Costo, Usuario 		            from UtilidadBruta
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">
			and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#"> 
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#"> 
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">
			and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Orden_Comercial#">
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Moneda#">
			and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
		</cfquery>
		
		<cfif rsVerifica.recordcount EQ 0>		
			<cfquery datasource="#session.dsn#">
				insert into UtilidadBruta
				(Ecodigo, Periodo, Mes, Orden_Comercial, Clas_Venta, CCTtipo, Moneda, Imp_Ingreso, Imp_Costo, Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Orden_Comercial#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.CCTtipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Moneda#">,
				<cfif rsValores.CCTtipo EQ 'D'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Ventas#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Costo#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Ventas#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Costo#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">) 
			</cfquery>						
		<cfelse>
			<cfquery datasource="#session.dsn#">
			    update UtilidadBruta
			    set 
				<cfif rsValores.CCTtipo EQ 'D'>
				   	Imp_Ingreso = Imp_Ingreso + <cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Ventas#">,
				<cfelse>
					Imp_Ingreso = Imp_Ingreso - <cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Ventas#">,
				</cfif>
				Imp_Costo = <cfqueryparam cfsqltype="cf_sql_float" value="#rsValores.Imp_Costo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Ecodigo#">
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Periodo#"> 
				and	Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsValores.Mes#"> 
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Clas_Venta#">
   				and Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Orden_Comercial#">
				and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValores.Moneda#">
				and Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
			</cfquery>
		</cfif>
	<!---<cfelse>
		<cfthrow message="El mes contable que desea seleccionar no ha sido cerrado.">
	</cfif>--->
</cfloop>

<!---Obtiene el ultimo mes generado ???????????--->
<cfquery name="rsUltMes" datasource="#Session.DSN#">
	Select isnull(max(Mes),0) + 1 as Mes, case isnull(max(Mes),0) + 1 when 1 then 'Enero' when 2 then 'Febrero' when 3    then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when    9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end as MesCorrecto from    SaldosUtilidad
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
</cfquery>

<cfif form.fltMes NEQ #rsUltMes.Mes#>
	<cfthrow message="Primero debe de ejecutar el mes de #rsUltMes.MesCorrecto#">
</cfif>
		
<!---<cfloop query="rsOrdenC">--->
	<cfquery name="rsOrdenC" datasource="#session.dsn#">
		select Orden_Comercial, Periodo, Mes, Moneda from UtilidadBruta 
		group by Orden_Comercial, Periodo, Mes, Moneda
		having count(*) > 1
	</cfquery>

<cfloop query="rsOrdenC">	
		<cfquery datasource="#session.dsn#">
			update UtilidadBruta set Imp_Costo = 0 
			where  Orden_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOrdenC.Orden_Comercial#"> 
			and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrdenC.Periodo#"> 
			and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrdenC.Mes#"> 
			and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOrdenC.Moneda#"> 
			and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRNF">
		</cfquery>
</cfloop>

<cfquery name="rsUtilidad" datasource="#session.dsn#">
select Moneda, Orden_Comercial, Ecodigo, convert(varchar,convert(money,Imp_Ingreso),1) as Ingreso, 
convert(varchar,convert(money,Imp_Costo),1) as Costo,
Periodo, case Mes when 1 then 'Enero' when 2 then 'Febrero' 
when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre'
when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'end  as Mes, case Clas_Venta when 'PRFC' then 'FACT' when 'PRNF' then 'NOFACT' end as TipoVenta
from UtilidadBruta U
where Usuario = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">
</cfquery>
				
</cfoutput>		
<cfoutput>
<table>
    <tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Lista Ventas y Costo de Venta por Orden Comercial: </br><strong/></td>
			<tr>&nbsp;</tr> 
			<td align="justify" colspan="4"  width="600" height="30">
			</tr></tr>
            </td>
	</tr> 
<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsUtilidad#"/>
			<cfinvokeargument name="cortes" value="Orden_Comercial"/>
			<cfinvokeargument name="desplegar" value="Periodo, Mes, TipoVenta, Moneda, Ingreso, Costo"/>
			<cfinvokeargument name="etiquetas" value="Periodo, Mes, TipoVenta, Moneda, Ingreso, Costo"/>
			<cfinvokeargument name="formatos" value="S,I,I,S,S,I,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
			<cfinvokeargument name="align" value="center,center,center,center,left,left,left"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="InterfazVtas-CostoOrden-motor.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="false"/>
			<cfinvokeargument name="keys" value=""/>
			<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>
</table>

<cfset session.ListaReg = #rsValores#>
<script type="text/javascript">
function funcRegresar() {
			document.lista.action = "InterfazVtas-CostoOrden-form.cfm";		
		}
</script>
</cfoutput>