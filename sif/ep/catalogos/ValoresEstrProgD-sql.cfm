<!---<cf_dump var="#form#">--->
<cfif IsDefined("form.btnAgregar")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select PCDcatid from CGDEstrProgVal d
		inner join CGEstrProgVal e on d.ID_EstrCtaVal = e.ID_EstrCtaVal
        where  d.PCDcatid   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCDcatid#">
        and e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fID_Estr#">
        and d.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
	</cfquery>
    <cfif BuscaCtaM.RecordCount EQ 0 >
        <cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
			insert into CGDEstrProgVal (ID_EstrCtaVal, PCDcatid,SaldoInv, BMUsucodigo)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCDcatid#">,
                <cfif IsDefined("form.chcSaldoInv")> 1 <cfelse> 0 </cfif>,
                <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
            )
        </cfquery>
	<cfelse>
		<cfthrow message="El valor al Plan de Cuentas ya existe en para el clasificador">
    </cfif>
<cfelseif IsDefined("form.btnModificar")>
	<cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
			update CGDEstrProgVal
				set SaldoInv = <cfif IsDefined("form.chcSaldoInv")> 1 <cfelse> 0 </cfif>
			Where ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DEstrCtaVal#">
        </cfquery>
		<cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
			update CGDDetEProgVal
				set SaldoInv = <cfif IsDefined("form.chcSaldoInv")> 1 <cfelse> 0 </cfif>
			Where ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DEstrCtaVal#">
     </cfquery>
<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="DelCGDetEProgVal" datasource="#Session.DSN#">
        Delete from CGDDetEProgVal
        Where ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DEstrCtaVal#">
	</cfquery>
	<cfquery name="DelCGEstrProgVal" datasource="#Session.DSN#">
        Delete from CGDEstrProgVal
        Where ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DEstrCtaVal#">
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
<cfif isdefined("Form.ID_EstrCta") and Len(Trim(Form.ID_EstrCta))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "ID_EstrCta=" & Form.ID_EstrCta>
</cfif>
<cfif isdefined("Form.ID_EstrCtaVal") and Len(Trim(Form.ID_EstrCtaVal))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fID_EstrCtaVal=" & Form.ID_EstrCtaVal>
</cfif>
<cfif isdefined("Form.ID_DEstrCtaVal") and Len(Trim(Form.ID_DEstrCtaVal))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "ID_DEstrCtaVal=" & Form.ID_DEstrCtaVal>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=4">
<cflocation url="CuentasEstrProg.cfm#params#">

