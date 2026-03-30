<cfparam name="Attributes.args" 		  type="string" default="">
<cfparam name="Attributes.name"           type="string" default="">
<cfparam name="Attributes.description"    type="string" default="">
<cfparam name="Attributes.validate" 	  type="string" default="">
<cfparam name="Attributes.validateonblur" type="boolean" default="false">
<cfparam name="Attributes.form" 		  type="string" default="form1">

<cfif len(trim(Attributes.args))>
	<cfset arrArgs = ListToArray(Attributes.args)>
	<cfset Attributes.name =  arrArgs[1]>
	<cfif ArrayLen(arrArgs) GT 1 and len(trim(arrArgs[2])) gt 0>
		<cfset Attributes.description =  arrArgs[2]>
	<cfelse>
		<cfset Attributes.description =  arrArgs[1]>
	</cfif>
	<cfif ArrayLen(arrArgs) GT 2 and len(trim(arrArgs[3])) gt 0>
		<cfset Attributes.validate =  arrArgs[3]>
		<cfif ArrayLen(arrArgs) GT 3  and len(trim(arrArgs[3])) gt 0>
			<cfset Attributes.validateonblur =  arrArgs[4]>
		<cfelse>
			<cfset Attributes.validateonblur =  false>
		</cfif>
	</cfif>
</cfif>

<cfif len(trim(Attributes.description)) eq 0>
	<cfset Attributes.description =  Attributes.name>
</cfif>

<cfassociate basetag="cf_qforms" datacollection="requiredfields">