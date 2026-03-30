<!---<cf_dump var="#form#">--->
<cfif IsDefined("form.btnAgregar")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select PCEcatid from CGEstrProgVal
        where
        ID_Estr    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
     	and EPCPcodigo   = <cfqueryparam value="#Form.EPCPcodigo#" cfsqltype="cf_sql_varchar">
	</cfquery>
    <cfif BuscaCtaM.RecordCount EQ 0 >
        <cfquery name="insCGEstrProgVal" datasource="#Session.DSN#">
            insert into CGEstrProgVal (ID_Estr, PCEcatid, EPCPcodigo, EPCPdescripcion, ID_Grupo, EPCPnota, EPCPcodigoref ,BMUsucodigo, SoloHijos)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCEcatid#">,
              	<cfqueryparam value="#Form.EPCPcodigo#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Form.EPCPdescripcion#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Grupo#">,
                <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
  			    <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfif IsDefined("form.chcHijo")> 1 <cfelse> 0 </cfif>
            )
        </cfquery>
	<cfelse>
		<cfthrow message="El código de Clasificador al Plan ya existe">
    </cfif>
<cfelseif IsDefined("form.btnModificar")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select top 1 e.SoloHijos from CGDEstrProgVal d
		inner join CGEstrProgVal e on d.ID_EstrCtaVal = e.ID_EstrCtaVal
        where e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fID_Estr#">
        and d.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
	</cfquery>
    <cfif BuscaCtaM.SoloHijos EQ "1" and not IsDefined("form.chcHijo") >
        <cfthrow message="Existen valores al plan de cuentas ligados al clasificador">
	<cfelse>
		<cfquery datasource="#Session.DSN#">
	        update CGEstrProgVal
			set  PCEcatid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PCEcatid#">,
			EPCPcodigo = <cfqueryparam value="#Form.EPCPcodigo#" cfsqltype="cf_sql_varchar">,
			EPCPdescripcion = <cfqueryparam value="#Form.EPCPdescripcion#" cfsqltype="cf_sql_varchar">,
	        ID_Grupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ID_Grupo#">,
	        EPCPcodigoref = <cfqueryparam value="#Form.EPCPcodigoref#" cfsqltype="cf_sql_varchar">,
	        EPCPnota = <cfqueryparam value="#Form.EPCPnota#" cfsqltype="cf_sql_varchar">,
			SoloHijos = <cfif IsDefined("form.chcHijo")> 1 <cfelse> 0 </cfif>
	        Where ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
		</cfquery>
    </cfif>
<cfelseif IsDefined("form.btnEliminar")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select PCDcatid from CGDEstrProgVal d
		inner join CGEstrProgVal e on d.ID_EstrCtaVal = e.ID_EstrCtaVal
        where e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fID_Estr#">
        and d.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
	</cfquery>
    <cfif BuscaCtaM.RecordCount EQ 0 >
        <cfquery name="DelCGEstrProgVal" datasource="#Session.DSN#">
            Delete from CGEstrProgVal
            Where ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
        </cfquery>
	<cfelse>
		<cfthrow message="Existen valores al plan de cuentas ligados al clasificador">
    </cfif>
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
<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
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
</cfif>
<cfif isdefined("Form.PCEcatid") and Len(Trim(Form.PCEcatid))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PCEcatid=" & Form.PCEcatid>
</cfif>
<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=4">
<cflocation url="CuentasEstrProg.cfm#params#">

