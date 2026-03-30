<cfparam 	name="Attributes.name"			type="string"	default="text1">
<cfparam 	name="Attributes.value" 		type="string"	default="">
<cfparam 	name="Attributes.decimales" 	type="string"	default="2">
<cfparam 	name="Attributes.size" 			type="string"	default="20">
<cfparam 	name="Attributes.maxlength" 	type="string"	default="18">
<cfparam 	name="Attributes.tabindex" 		type="string"	default="-1">
<cfparam	name="Attributes.readonly"		type="boolean"	default="false">
<cfparam name="Attributes.nullable" type="boolean" default="false">

<cfif not isdefined("Request.utilesMonto")>
	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<cfset Request.utilesMonto = true>
</cfif>

<cfoutput><input type="text" 
		<cfif Attributes.readonly> readonly="true"</cfif>
		name="#Attributes.name#" id="#Attributes.name#"
		onfocus="javascript:this.value=qf(this); this.select();" 
		onBlur="javascript:<cfif Attributes.nullable>if(this.value.length)</cfif>fm(this,#Attributes.decimales#);"  
		onkeyup="javascript:if(snumber(this,event,#Attributes.decimales#)){ if(Key(event)=='13') {this.blur();}}" 
		value="#Attributes.value#" 
		size="#Attributes.size#" maxlength="#Attributes.maxlength#"
		tabindex="#Attributes.tabindex#"
		style="text-align: right;"></cfoutput>
