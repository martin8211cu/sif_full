<cfparam name="Attributes.name" default="">
<cfparam name="Attributes.value" default="">
<cfparam name="Attributes.valueid" default="">
<cfparam name="Attributes.clase_tipo" default="">
<cfparam name="Attributes.id_tipo" default="">
<cfparam name="Attributes.tipo_dato" default="">
<cfparam name="Attributes.mascara" default="">
<cfparam name="Attributes.formato" default="">
<cfparam name="Attributes.valor_minimo" default="">
<cfparam name="Attributes.valor_maximo" default="">
<cfparam name="Attributes.longitud" default="">
<cfparam name="Attributes.escala" default="">
<cfparam name="Attributes.id_tipocampo" default="">
<cfparam name="Attributes.nombre_tabla" default="">
<cfparam name="Attributes.form" default="form1" type="String">
<!--- Nombre del form --->
<cfparam name="Attributes.readonly" default="false" type="boolean">
<!--- Modo Lectura --->

<cfif Attributes.readonly>
  <cfoutput> #HTMLEditFormat(Attributes.value)# </cfoutput>
<cfelse>
  <cfswitch expression="#Attributes.clase_tipo#">
    <cfcase value="S">
    <cf_tipo_simple name="#Attributes.name#" value="#Attributes.value#" 
		tipo_dato="#Attributes.tipo_dato#"
		mascara="#Attributes.mascara#" formato="#Attributes.formato#" 
		valor_minimo="#Attributes.valor_minimo#" valor_maximo="#Attributes.valor_maximo#" 
		longitud="#Attributes.longitud#" escala="#Attributes.escala#"
		form="#Attributes.form#">
    </cfcase>
    <cfcase value="L">
    <cf_tipo_lista name="#Attributes.name#" value="#Attributes.value#"
		valueid="#Attributes.valueid#" id_tipocampo="#Attributes.id_tipocampo#">
    </cfcase>
    <cfcase value="T">
    <cf_tipo_tabla name="#Attributes.name#" value="#Attributes.value#"
		valueid="#Attributes.valueid#" nombre_tabla="#Attributes.nombre_tabla#"
		id_tipo="#Attributes.id_tipo#" form="#Attributes.form#">
    </cfcase>
    <cfcase value="C">
    <cf_tipo_complejo name="#Attributes.name#" value="#Attributes.value#"
		valueid="#Attributes.valueid#" id_tipocampo="#Attributes.id_tipocampo#"
		form="#Attributes.form#">
    </cfcase>
  </cfswitch>
</cfif>
