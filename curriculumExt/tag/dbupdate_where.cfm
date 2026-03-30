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

<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 0>
	<cfthrow message="Atributos inválidos" detail="cf_dbupdate_where no admite atributos">
</cfif>
<cfif Not ThisTag.HasEndTag>
	<cfthrow message="cf_dbupdate requiere de el tag de cierre">
</cfif>
<cfif ThisTag.ExecutionMode is 'start'>
	<cfset ThisTag.params = ArrayNew(1)>
<cfelse>
	<cfset Attributes.text = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = ''>
	<cfassociate basetag="cf_dbupdate" datacollection="where">
</cfif>
