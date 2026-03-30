
<cfif IsDefined("form.btnAgregar")>
	<cfif IsDefined("form.PCDcatidref")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select PCDcatidref from CGDDetEProgVal d
        inner join CGEstrProgVal c
        on c.ID_EstrCtaVal=d.ID_EstrCtaVal
        where  d.PCDcatidref = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCDcatidref#">
        and c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Estr#">
<!---        and d.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_EstrCtaVal#">
        and d.ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_DEstrCtaVal#">
--->
	</cfquery>

   <cfif BuscaCtaM.RecordCount EQ 0 >
	        <cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
	            insert into CGDDetEProgVal (ID_DEstrCtaVal,ID_EstrCtaVal,PCDcatidref, BMUsucodigo
	            	<cfif isdefined("form.chcSaldoInv")>, SaldoInv</cfif>
	            )
	            values (
	            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DEstrCtaVal#">,
	                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">,
	                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCDcatidref#">,
	                <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
	                <cfif isdefined("form.chcSaldoInv")>, 1</cfif>
	            )
	        </cfquery>
		<cfelse>
			<cfthrow message="El valor del detalle al Plan de Cuentas ya existe en otro clasificador">
	    </cfif>
	</cfif>
<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="DelCGEstrProgVal" datasource="#Session.DSN#">
        Delete from CGDDetEProgVal
        Where ID_DDEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DDEstrCtaVal#">
	</cfquery>
<cfelseif IsDefined("form.btnModificar")>
	<cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
			update CGDDetEProgVal
				set SaldoInv = <cfif IsDefined("form.chcSaldoInv")> 1 <cfelse> 0 </cfif>
			Where ID_DDEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_DDEstrCtaVal#">
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

