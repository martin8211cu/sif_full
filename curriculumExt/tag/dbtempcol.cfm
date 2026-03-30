<cfparam name="Attributes.name"      type="string">
<cfparam name="Attributes.type"      type="string">
<cfparam name="Attributes.mandatory" type="boolean" default="no">
<cfparam name="Attributes.identity"  type="boolean" default="no">
<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 4>
	<cfthrow message="Atributos inválidos: #UCase(StructKeyList(Attributes))#. Utilice solamente: name (requerido), type (requerido), mandatory (default=no), identity(default=no)">
</cfif>
<cfassociate basetag="cf_dbtemp" datacollection="columns">