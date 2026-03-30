<cfparam name="Attributes.name"      type="string">
<cfparam name="Attributes.type"      type="string">
<cfparam name="Attributes.mandatory" type="boolean" default="no">
<cfparam name="Attributes.identity"  type="boolean" default="no">
<cfparam name="Attributes.default"   type="string"  default="">
<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 5>
	<cf_errorCode	code = "50656"
					msg  = "Atributos inválidos: @errorDat_1@. Utilice solamente: name (requerido), type (requerido), mandatory (default=no), identity(default=no)"
					errorDat_1="#UCase(StructKeyList(Attributes))#"
	>
</cfif>

<cfassociate basetag="cf_dbtemp" datacollection="columns">

