<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'
</cfquery>

<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif #nivel.Pvalor# neq '-1'>
	<cfset LvarFiltro = 'and (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cco.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor - 1#'>
<cfelse>
<cfset LvarFiltro = "and cco.Cmovimiento = 'S'">
</cfif>

<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = " and m.Ctipo <> 'O' ">
	</cfif>
</cfif>


<cfquery name="rsReporte" datasource="#session.DSN#">
	select * from (
	 select
		Cformato,Cdescripcion,Ccuenta,
	       case Ctipo
			when 'A' then 'Activo'
			when 'P' then 'Pasivo'
			when 'C' then 'Capital'
			when 'I' then 'Ingreso'
			when 'G' then 'Gasto'
			when 'O' then 'Orden'
			else 'N/A'
		end as DescripcionTipo
     from (	select Cformato,Cdescripcion,Ctipo,ctasSaldos.Ccuenta
       from (
            SELECT	distinct ctas.Ccuenta, ctas.Cformato, ctas.Cdescripcion, ctas.Ecodigo,ctas.Cmayor, ctas.PCDCniv,ctas.Ctipo
            from (
            			select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
                    	from CContables a
						inner join CtasMayor cm
							on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
                    	INNER JOIN PCDCatalogoCuenta b
                     		on a.Ccuenta = b.Ccuentaniv
                    	<cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
							and a.Cmovimiento = 'S'
						<cfelse>
                        	and b.PCDCniv <= (
                        						select isnull(Pvalor,2) Pvalor
                                            	from Parametros
                                            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                                                	and Pcodigo = 200080) -1
                    	</cfif>
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and not exists (select 1 from CEInactivas e where a.Ccuenta = e.Ccuenta and a.Ecodigo = e.Ecodigo)
			) ctas
			INNER JOIN (
            			select Ccuenta, Ecodigo from SaldosContables
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						<cfif isdefined("form.periodo") and form.periodo neq "-1" and isdefined("form.mes") and form.mes neq "-1">
			            	and Speriodo*100+Smes <= #form.periodo*100+form.mes#
						</cfif>
			) c
               	on ctas.Ccuenta = c.Ccuenta
				and ctas.Ecodigo = c.Ecodigo
			where ctas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 ) ctasSaldos
         left join CEMapeoSAT cSAT
             on ctasSaldos.Ccuenta = cSAT.Ccuenta
             and cSAT.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">
			 and cSAT.Ecodigo = #Session.Ecodigo#
         where cSAT.Ccuenta is null
		 <cfif #valOrden.Pvalor# eq 'N'>
			and ctasSaldos.Ctipo <> 'O'
		 </cfif>
	) ctaNomap
	UNION ALL
	select
		Cformato,Cdescripcion,Ccuenta,
	       case Ctipo
			when 'A' then 'Activo'
			when 'P' then 'Pasivo'
			when 'C' then 'Capital'
			when 'I' then 'Ingreso'
			when 'G' then 'Gasto'
			when 'O' then 'Orden'
			else 'N/A'
		end as DescripcionTipo
	FROM (
		select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
        from CContables a
		inner join CtasMayor cm
			on a.Cmayor = cm.Cmayor
			and a.Ecodigo = cm.Ecodigo
        INNER JOIN PCDCatalogoCuenta b
            on a.Ccuenta = b.Ccuentaniv
        <cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
			and a.Cmovimiento = 'S'
		<cfelse>
            and b.PCDCniv <= (
                select isnull(Pvalor,2) Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                	and Pcodigo = 200080) -1
        </cfif>
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and not exists (select 1 from CEInactivas e where a.Ccuenta = e.Ccuenta and a.Ecodigo = e.Ecodigo)
		and not exists (select 1 from CEMapeoSAT cst where a.Ccuenta = cst.Ccuenta and a.Ecodigo = cst.Ecodigo and cst.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAgrupador#">)
		<cfif #valOrden.Pvalor# eq 'N'>
			and cm.Ctipo <> 'O'
		</cfif>
	) a
	where not exists (
			select 1 from SaldosContables b where a.Ecodigo = b.Ecodigo and a.Ccuenta = b.Ccuenta
		)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
) result
where not exists (select 1 from  (select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
					from CContables a
					inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
					INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
					where b.PCDCniv = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)) cmns
				where result.Ccuenta = cmns.Ccuenta)
</cfquery>

<cfquery name="Empresas" datasource="#Session.DSN#">
	select
		Ecodigo,
		Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfhtmlhead text="
<style type='text/css'>
td {  font-size: 11px; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
a {
	text-decoration: none;
	color: ##000000;
}
.listaCorte { font-size: 11px; font-weight:bold; background-color:##CCCCCC; text-align:left;}
.listaNon { background-color:##FFFFFF; vertical-align:middle; padding-left:5px;}
.listaPar { background-color:##FAFAFA; vertical-align:middle; padding-left:5px;}
.tituloSub { background-color:##FFFFFF; font-weight: bolder; text-align: center; vertical-align: middle; font-size: smaller; border-color: black black ##CCCCCC; border-style: inset; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.tituloListas {

	font-weight: bolder;
	vertical-align: middle;
	padding: 5px;
	background-color: ##F5F5F5;
}
</style>">

<cfset Title = "Cuentas sin Mapear">
<cfset FileName = "CuentasSinMapear">
<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
<cfset LvarIrA  = 'ReporteMapeoCuentasCE.cfm'>

<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" ira="#LvarIrA#">

<table style="width:95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="8" align="right">

		</td>
	</tr>
	<tr class="area">
		<td  align="center" colspan="8" nowrap class="tituloAlterno"><cfoutput>#Empresas.Edescripcion#</cfoutput></td>
	</tr>
	<tr class="area">
		<td align="center" colspan="8" nowrap><strong><cf_translate key=LB_Titulo>Cuentas sin Mapear</cf_translate></strong></td>
	</tr>
	<tr>
		<td colspan="8" align="right"><strong><cf_translate key=LB_Fecha>Fecha</cf_translate>: <font color="##006699"><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></font></strong></td>
	</tr>
	<tr class="listaCorte">
		<td><strong><cf_translate key = LB_FormatoCuenta>Formato Cuenta </cf_translate></strong></td>
		<td><strong><cf_translate key = LB_Cuenta>Cuenta</cf_translate></strong></td>
		<td><strong><cf_translate key = LB_Tipo>Tipo</cf_translate></strong></td>
	</tr>
	<cfflush interval="128">
	<cfoutput query="rsReporte">
		<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td>
				#rsReporte.Cformato#
			</td>
			<td>
				#rsReporte.Cdescripcion#
			</td>
			<td colspan="5">
				#rsReporte.DescripcionTipo#
			</td>
		</tr>
	</cfoutput>
</table>