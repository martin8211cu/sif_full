<!--- <cf_dump var="#form#"> --->
<cfset tipoCuenta = "1">
<cfif isdefined("form.Tipoaplica")>
	<cfset tipoCuenta = form.Tipoaplica>
</cfif>
<cfset params= "">
<cfif IsDefined("form.btnAgregar")>

	<cfset formato = #Form.CmayorInc#&"-"&#Form.CformatoInc#>

	<cfloop from="1" to="#Len(formato)#" index="i">
		<cfset currentChar=Mid(formato,i,1)>
		<cfif not isnumeric(currentChar)>
			<cfif currentChar NEQ '-' and currentChar NEQ '_'>
				<cfset formato = Replace(formato,currentChar,"X","all") >
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="insCtaTipoEstr" datasource="#Session.DSN#">
		insert into CGEstrProgCtaD
			( <!--- CFcuenta, --->
			  	<cfif tipoCuenta EQ "1">
			  		FormatoC,
			  	<cfelse>
			  		FormatoP,
			  	</cfif>
				ID_Estr,
				TipoAplica,
				BMUsucodigo
			)
			values
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#formato#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Tipoaplica#">,
	         <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
	        )
	</cfquery>

<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="updCtaTipoEstr" datasource="#Session.DSN#">
		delete from CGEstrProgCtaD
		where ID_EstrCtaDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaDet#">
	</cfquery>
<cfelse>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "t_cuenta=" & Form.TipoAplica>
</cfif>


<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum>
</cfif>

<cfif isdefined("Form.ID_EstrCta") and Len(Trim(Form.ID_EstrCta))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "ID_EstrCta=" & Form.ID_EstrCta>
</cfif>

<cfif isdefined("form.btnAgregar")>
	<cfif isdefined("Form.ID_EstrCtaDet") and Len(Trim(Form.ID_EstrCtaDet))>
        <cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "ID_EstrCtaDet=" & Form.ID_EstrCtaDet>
    </cfif>
</cfif>

<cfif isdefined("Form.ID_Estr") and Len(Trim(Form.ID_Estr))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fID_Estr=" & Form.ID_Estr>
</cfif>

<cfif isdefined("form.tipocuenta")>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "t_cuenta=" & Form.tipoCuenta>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=3">

<cflocation url="CuentasEstrProg.cfm#params#">


