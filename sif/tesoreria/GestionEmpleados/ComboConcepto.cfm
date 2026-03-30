<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras = (rsUsaPlanCuentas.Pvalor EQ 1)>

<cfsetting enablecfoutputonly="yes">
<cfif isdefined ('url.GETid') and #url.GETid# GT 0>
	<cfset LvarTipo = "PorTipo">
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
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
		<cfif LvarConPlanCompras and isdefined ('url.GECid') and #url.GECid# GT 0>
			and c.GECid=#url.GECid#
		</cfif>
	</cfquery>
<cfelseif isdefined ('url.GETid') and #url.GETid# LT 0>
	<cfset LvarTipo = "PorImpuesto">
	<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select 
			Idescripcion as GECdescripcion,
			Icodigo		 as GECid
		from Impuestos
		where Ecodigo = #session.Ecodigo#
		  and Icreditofiscal = 1
	</cfquery>
<cfelse>
	<cfset LvarTipo = "PorAnticipo">
	<cfquery name="rsConceptos" datasource="#Session.DSN#" >
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
		 order by c.GECid
	</cfquery>
</cfif>

<cfif isdefined('url.modoD') and len(trim(url.modoD))>
	<cfset modoD = url.modoD>
</cfif>

<cfoutput>
	<select name="Concepto" id="Concepto" tabindex="1" <cfif LvarConPlanCompras>disabled="disabled"</cfif>>
		<cfloop query="rsConceptos">
			<option value="#rsConceptos.GECid#">
				#rsConceptos.GECdescripcion#
			</option>
		</cfloop>
	</select>
</cfoutput>



