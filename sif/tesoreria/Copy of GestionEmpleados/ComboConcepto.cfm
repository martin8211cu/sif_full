<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.GETid') and #url.GETid# GT 0>
	<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
		select 
			c.GECdescripcion,
			c.GECid,
			c.GETid,
			c.GECcomplemento
		from GEconceptoGasto c
			inner join GEtipoGasto t
		on  c.GETid = t.GETid
	where Ecodigo = #session.Ecodigo#
	and c.GETid= #url.GETid#
	<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and isdefined ('url.GECid') and #url.GECid# GT 0>
		and c.GECid=#url.GECid#
	</cfif>
	</cfquery>
<cfelse>
	<cfquery name="rsconcepto" datasource="#Session.DSN#" >
		select distinct
			c.GECdescripcion,
			c.GECid,
			c.GETid,
			c.GECcomplemento
		  from GEliquidacionAnts a
			inner join GEanticipoDet b
				inner join GEconceptoGasto c
					 on c.GECid= b.GECid
				 on b.GEAid = a.GEAid
				and b.GEADid=a.GEADid
		 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GELid#">
	</cfquery>

</cfif>

<cfif isdefined('url.modoD') and len(trim(url.modoD))>
	<cfset modoD = url.modoD>
</cfif>

<cfoutput>
	<select name="Concepto" id="Concepto" tabindex="1" <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif>>
		<cfif isdefined('rsID_concepto_gasto') and rsID_concepto_gasto.recordcount gt 0 and #url.GETid# GT 0>
			<cfloop query="rsID_concepto_gasto">
				<option value="#rsID_concepto_gasto.GECid#"<cfif modoD neq "ALTA" and rsID_concepto_gasto.GECid  eq rsID_concepto_gasto.GECid>selected="selected" </cfif>>
					#rsID_concepto_gasto.GECdescripcion#
				</option>
			</cfloop>
		<cfelse>
			<cfif isdefined ('rsID_concepto_gasto') and rsID_concepto_gasto.recordcount gt 0>
				<cfloop query="rsconcepto">
					<option value="#rsconcepto.GECid#"selected="selected">#rsconcepto.GECdescripcion#
					</option>
				</cfloop>
			<cfelseif isdefined ('rsconcepto') and rsconcepto.recordcount gt 0>
					<cfloop query="rsconcepto">
						<option value="#rsconcepto.GECid#"selected="selected">#rsconcepto.GECdescripcion#
						</option>
					</cfloop>
			</cfif>
		</cfif>
	</select>
</cfoutput>



