<!---<cf_dump var="#form#">--->
<cfif IsDefined("form.btnGuardar")>
        <cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
			update CGEstrProg 
			set PCEcatidClasificado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCEcatid#">
            where ID_Estr    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
        </cfquery>
</cfif>

<cfset params= "">
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum>
</cfif>
<cfif isdefined("Form.ID_Estr") and Len(Trim(Form.ID_Estr))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fID_Estr=" & Form.ID_Estr>
</cfif>
<!---<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGEPCtaMayor=" & Form.Cmayor>
</cfif>
<cfif isdefined("Form.Csubtipo1") and Len(Trim(Form.Csubtipo1))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGEPctaGrupo=" & Form.Csubtipo1>
</cfif>
<cfif isdefined("Form.Ctipo") and Len(Trim(Form.Ctipo))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGEPctaTipo=" & Form.Ctipo>
</cfif>
<cfif isdefined("Form.CGEPctaBalance") and Len(Trim(Form.CGEPctaBalance))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGEPctaBalance=" & Form.CGEPctaBalance>
</cfif>

<cfif isdefined("Form.fID_EstrCtaVal") and Len(Trim(Form.fID_EstrCtaVal))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fID_EstrCtaVal=" & Form.fID_EstrCtaVal>
</cfif>--->

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=5">
<cflocation url="CuentasEstrProg.cfm#params#">

