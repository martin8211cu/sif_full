
<cfparam name="lvarperiodo" default="2006">
<cfparam name="lvarmes" default="12">
<cfif isdefined("url.periodo") and url.periodo gt 2000 and url.periodo lt 2010>
	<cfset Lvarperiodo = url.periodo>
</cfif>
<cfif isdefined("url.mes") and url.mes gt 0 and url.mes lt 13>
	<cfset lvarmes = url.mes>
</cfif>

<cfquery name="rsKardex" datasource="#session.dsn#">
	select 
		a.Acodigo, 
		b.Almcodigo, 
		k.Aid, 
		k.Alm_Aid, 
		k.Kid, 
		k.Kperiodo, 
		k.Kmes, 
		k.Kcosto, 
		k.Kunidades, 
		k.Kcostoant, 
		k.Kexistant
	from Kardex k
		inner join Articulos a
		on a.Aid = k.Aid
		and a.Ecodigo = #session.Ecodigo#
		inner join Almacen b
		on b.Aid = k.Alm_Aid
	where k.Kperiodo = #lvarperiodo#
	  and k.Kmes = #lvarmes#
	order by k.Aid, k.Alm_Aid, k.Kid
</cfquery>

<table width="100%" title="Ajuste de Kardex de Inventario">
<cfoutput><tr><td colspan="8" align="center"><strong>Ajuste de Kardex de Inventario para el periodo #Lvarperiodo# - #LvarMes#</strong></td></tr></cfoutput>
<cfflush interval="64">
<cfoutput query="rsKardex" group="Aid">
	<cfoutput group="Alm_Aid">
		<cfquery name="rsExistenciaInicial" datasource="#session.dsn#">
			select EIcosto, EIexistencia
			from ExistenciaInicial
			where Aid = #rsKardex.Aid#
			  and Alm_Aid = #rsKardex.Alm_Aid#
			  and EIperiodo = #rsKardex.Kperiodo#
			  and EIMes = #rsKardex.Kmes#
		</cfquery>
		<cfif rsExistenciaInicial.recordcount GT 0>
			<cfset LvarKcostoAnt = numberformat(rsExistenciaInicial.EIcosto, "0.00")>
			<cfset LvarExistAnt = rsExistenciaInicial.EIexistencia>
		<cfelse>
			<cfset LvarKcostoAnt = 0.00>
			<cfset LvarExistAnt = 0>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2"><strong>Articulo: #rsKardex.Acodigo#</strong></td>
			<td colspan="2"><strong>Almacen:  #rsKardex.Almcodigo#</strong></td>
		</tr>
		<tr>
			<td align="right"><strong>Unidades</strong></td>
			<td align="right"><strong>Exist. Ant.</strong></td>
			<td align="right"><strong>Exist. Ant. Calc</strong></td>
			<td align="right"><strong>Diferencia</strong></td>
			<td align="right"><strong>Costo</strong></td>
			<td align="right"><strong>Costo Ant.</strong></td>
			<td align="right"><strong>Costo Ant. Calc.</strong></td>
			<td align="right"><strong>Diferencia</strong></td>
		</tr>
		
		<cfoutput>
			<tr>
				<td align="right">#Kunidades#</td>
				<td align="right">#rsKardex.Kexistant#</td>
				<td align="right"> #LvarExistAnt#</td>
				<td align="right"> #rsKardex.Kexistant - LvarExistAnt#</td>
				<td align="right">#numberformat(Kcosto, ",9.00")#</td>
				<td align="right">#numberformat(rsKardex.Kcostoant, ",9.00")#</td>
				<td align="right"> #numberformat(LvarKcostoAnt, ",9.00")#</td>
				<td align="right"> #numberformat(rsKardex.Kcostoant - LvarKcostoAnt, ",9.00")#</td>
			</tr>
			<cfquery datasource="#session.dsn#">
				update Kardex
				set Kcostoant  = <cfqueryparam cfsqltype="cf_sql_money" value="#Numberformat(LvarKcostoAnt,"0.00")#">,
					Kexistant = <cfqueryparam cfsqltype="cf_sql_float" value="#LvarExistAnt#">
				where Kid      = #rsKardex.Kid#
				  and Aid      = #rsKardex.Aid#
				  and Alm_Aid  = #rsKardex.Alm_Aid#
				  and Kperiodo = #rsKardex.Kperiodo#
				  and Kmes     = #rsKardex.Kmes#
			</cfquery>
			<cfset LvarKcostoAnt = LvarKcostoAnt + numberformat(rsKardex.Kcosto, "0.00")>
			<cfset LvarExistAnt = LvarExistAnt + rsKardex.Kunidades>
		</cfoutput>
	</cfoutput>
</cfoutput>
</table>
