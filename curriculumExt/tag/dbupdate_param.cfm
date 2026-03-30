<!---
EJEMPLO DE USO: 
<cf_dbupdate	table="#Monedas#">
	<cf_dbupdate_join table="TipoCambioEmpresa a" [ type='inner' ] >
	[ on ] a.Mcodigo = #Monedas#.Mcodigo
	  and a.Mes =  <cf_dbupdate_param type="integer" value="#Mes#">
	</cf_dbupdate_join>
	
	<cf_dbupdate_set name='TC' expr="coalesce(TCEtipocambio,-1)" />
	<cf_dbupdate_set name='nombre' type='varchar' value='#nombre#'>

	<cf_dbupdate_where>
	[ where ] a.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
	  and a.Periodo = <cf_dbupdate_param type="integer" value="#Periodo#" [ null='no' ] >
	  and a.Mes =     <cf_dbupdate_param type="integer" value="#Mes#" [ null='no' ] > 
	</cf_dbupdate_where>
</cf_dbupdate>
--->

<cfparam name="Attributes.type"  type="string">
<cfparam name="Attributes.value">
<cfparam name="Attributes.null" type="boolean" default="no">

<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 3>
	<cfthrow message="Atributos inválidos" detail="Los atributos válidos para cf_dbupdate_param son: type,value,null">
</cfif>

<cfset baseTagList = GetBaseTagList()>
<cfif ListFindNoCase(baseTagList, 'cf_dbupdate_join')>
	<cfassociate basetag="cf_dbupdate" datacollection="join_params">
	<cfoutput> ? </cfoutput>
<cfelseif ListFindNoCase(baseTagList, 'cf_dbupdate_where')>
	<cfassociate basetag="cf_dbupdate" datacollection="where_params">
	<cfoutput> __CF_DBUPDATE_PARAM__ </cfoutput>
<cfelse>
	<cfthrow message="contexto invalido" detail="cf_dbupdate_param debe estar dentro de cf_dbupdate_join o bien cf_dbupdate_where">
</cfif>
