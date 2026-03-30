<!--- <cf_dump var="#Form#"> --->
<cfif IsDefined("form.Alta")>
	<cfquery name="BuscaCtaM" datasource="#Session.DSN#">
    	select CGEPCtaMayor from CGEstrProgCtaM
        where
        	CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
        and ID_Estr      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">
	</cfquery>
    <cfif BuscaCtaM.RecordCount EQ 0 >
	<cfquery name="insCtaEstrProg" datasource="#Session.DSN#">
		insert into CGEstrProgCtaM (ID_Estr, ID_Grupo, CGEPCtaMayor, CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance,CGEPDescrip,CGEPInclCtas,BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_Estr#">,
	 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GrupoCta#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CGEPctaBalance#">,
            <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CGEPDescrip#">,
			<cfif isdefined("form.CGEPInclCtas")>
            	<cfqueryparam value="#form.CGEPInclCtas#" cfsqltype="cf_sql_numeric">,
            <cfelse>
            	1,
            </cfif>
            <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		)
	</cfquery>
    </cfif>
<cfelseif IsDefined("form.Cambio")>
	<cfquery name="UpdCtaEstrProg" datasource="#Session.DSN#">
		Update CGEstrProgCtaM
		set CGEPctaTipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
			ID_Grupo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GrupoCta#">,
			CGEPctaGrupo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
			CGEPctaBalance = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CGEPctaBalance#">,
            CGEPDescrip    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CGEPDescrip#">,
			<cfif isdefined("form.CGEPInclCtas")>
            	CGEPInclCtas = <cfqueryparam value="#form.CGEPInclCtas#" cfsqltype="cf_sql_numeric">,
            <cfelse>
            	CGEPInclCtas = 1,
            </cfif>
            BMUsucodigo    = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		Where ID_EstrCta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCta#">
		 <!--- and CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">--->
	</cfquery>

<cfelseif IsDefined("form.Baja")>
	<cfquery name="insCtaTipoRep" datasource="#Session.DSN#">
		Delete from CGEstrProgCtaM
		Where ID_EstrCta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCta#">
		<!--- and CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">--->
	</cfquery>
<cfelse>
	<cfif isdefined("Form.BotonSel") and trim(Form.BotonSel) EQ "">
		<cfset doPostBack="true">
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
<cfif isdefined("Form.CGEPDescrip") and Len(Trim(Form.CGEPDescrip))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGEPDescrip=" & Form.CGEPDescrip>
</cfif>
<cfif isdefined("Form.CGEPInclCtas") and Len(Trim(Form.CGEPInclCtas))>
	<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "CGEPInclCtas=" & Form.CGEPInclCtas>
</cfif>

<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=2">
<cfif isdefined("doPostBack")>
	<cfif isdefined("Form.BotonSel") and trim(Form.BotonSel) EQ "">
			<cfif isdefined("Form.Cmayor") and trim(Form.Cmayor) NEQ "">
				<cfquery name="rsCmayor" datasource="#Session.DSN#">
					select Cmayor, Ctipo,Cdescripcion,
						case Cbalancen
							when 'D' then 1
							when 'C' then -1
						end	Cbalancen
					from CtasMayor
					where Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				</cfquery>

				<cfif rsCmayor.recordCount NEQ 0 >
					<cfoutput>
						<form action="CuentasEstrProg.cfm#params#" method="post" name="sql">
						    <input name="Cmayor" type="hidden" value="#rsCmayor.Cmayor#">
						    <input name="CGEPDescrip" type="hidden" value="#rsCmayor.Cdescripcion#">
						    <input name="Ctipo" type="hidden" value="#rsCmayor.Ctipo#">
						    <input name="CGEPctaBalance" type="hidden" value="#rsCmayor.Cbalancen#">
						</form>
					</cfoutput>
				</cfif>
			</cfif>
	</cfif>
		<HTML>
			<head>
			</head>
			<body>
				<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
			</body>
		</HTML>
<cfelse>
	<cflocation url="CuentasEstrProg.cfm#params#">
</cfif>

