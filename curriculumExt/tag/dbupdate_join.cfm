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

<cfparam name="Attributes.table" type="string">
<cfparam name="Attributes.type" type="string" default="inner">

<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 2>
	<cfthrow message="Atributos inválidos" detail="Los atributos válidos para cf_dbupdate_param son: table,type">
</cfif>
<cfif Find(',', Attributes.table)>
	<cfthrow message="Atributo table inválido: Debe usarse un cf_dbupdate_join por cada tabla con la que se quiera hacer join">
</cfif>


<cfif ThisTag.ExecutionMode is 'start'>
	<cfset ThisTag.params = ArrayNew(1)>
<cfelse>
	<cfset Attributes.text = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = ''>
	<cfassociate basetag="cf_dbupdate" datacollection="join">
</cfif>
