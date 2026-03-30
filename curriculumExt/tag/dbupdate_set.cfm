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

<cfparam name="Attributes.name" type="string">

<cfif IsDefined('Attributes.expr')>
	<cfparam name="Attributes.expr" type="string">
	<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 2>
		<cfthrow message="Atributos inválidos" detail="Combinaciones de atributos válidas para cf_dbupdate_set: name,expr; name,type,value,null">
	</cfif>
<cfelseif IsDefined('Attributes.type') And IsDefined('Attributes.value')>
	<cfparam name="Attributes.type" type="string">
	<cfparam name="Attributes.value" default="">
	<cfparam name="Attributes.null" type="boolean" default="no">
	<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 4>
		<cfthrow message="Atributos inválidos" detail="Combinaciones de atributos válidas para cf_dbupdate_set: name,expr; name,type,value,null">
	</cfif>
<cfelse>
	<cfthrow message="Atributos inválidos" detail="Combinaciones de atributos válidas para cf_dbupdate_set: name,expr; name,type,value,null">
</cfif>

<cfif ThisTag.ExecutionMode is 'end' or Not ThisTag.HasEndTag>
<cfassociate basetag="cf_dbupdate" datacollection="set">
</cfif>
