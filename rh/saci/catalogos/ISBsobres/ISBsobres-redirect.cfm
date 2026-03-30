<cfset params="">
<cfset location = "ISBsobres.cfm">

<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Pagina=" & Form.Pagina>
</cfif>
<cfif isdefined("Form.filtro_Snumero") and Len(Trim(Form.filtro_Snumero))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Snumero=" & Form.filtro_Snumero>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Snumero=" & Form.filtro_Snumero>	
</cfif>
<cfif isdefined("Form.filtro_Sdonde") and Len(Trim(Form.filtro_Sdonde))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Sdonde=" & Form.filtro_Sdonde>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Sdonde=" & Form.filtro_Sdonde>	
</cfif>				
<cfif isdefined("Form.filtro_LGlogin") and Len(Trim(Form.filtro_LGlogin))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_LGlogin=" & Form.filtro_LGlogin>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_LGlogin=" & Form.filtro_LGlogin>	
</cfif>		
<cfif isdefined("Form.filtro_nombreAgente") and Len(Trim(Form.filtro_nombreAgente))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_nombreAgente=" & Form.filtro_nombreAgente>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_nombreAgente=" & Form.filtro_nombreAgente>	
</cfif>
<cfif isdefined("Form.filtro_Sestado") and Len(Trim(Form.filtro_Sestado))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "filtro_Sestado=" & Form.filtro_Sestado>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "hfiltro_Sestado=" & Form.filtro_Sestado>	
</cfif>

<cfif not IsDefined("form.Regresar") and not isdefined('form.masivo')>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "Snumero="& Form.Snumero>
	<cfset location = "ISBsobres-edit.cfm">
</cfif>

<cfset Request.Error.Url="#location#">
<cflocation url="#location##params#">