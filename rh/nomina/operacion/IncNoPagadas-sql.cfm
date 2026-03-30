<cfset ira = "ListIncNoPagadas.cfm">

<cftransaction>
	<cfif isdefined("Form.accion")>
		<cfif Form.accion eq 'DEL'>
		   <cfquery name="rsRespaldo" datasource="#Session.DSN#">
				insert into HIncidencias 
				(	Iid,
					DEid, 
					CIid, 
					CFid, 
					IfechaAnt, 
					Ifecha, 
					Ivalor, 
					Ifechasis, 
					Usucodigo, 
					Ulocalizacion, 
					BMUsucodigo, 
					Iespecial, 
					RCNid, 
					Mcodigo, 
					RHJid, 
					Imonto, 
					Icpespecial, 
					IfechaRebajo, 
					HIEstado, 
					HBMUsucodigo, 
					BMfechaalta)
				select 
					Iid,
					DEid, 
					CIid, 
					CFid, 
					null, 
					Ifecha, 
					Ivalor, 
					Ifechasis, 
					Usucodigo, 
					Ulocalizacion, 
					BMUsucodigo, 
					Iespecial, 
					RCNid, 
					Mcodigo, 
					RHJid, 
					Imonto, 
					Icpespecial, 
					IfechaRebajo, 
					1, 
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">			
				from Incidencias
                where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
            </cfquery>
            <cfquery name="rsborrado" datasource="#Session.DSN#">
                delete Incidencias
                where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
            </cfquery>
        </cfif>
	</cfif>
</cftransaction>
<cfoutput>
<form action="#ira#" method="post" name="sql">
	<cfif isdefined("form.RHTid") and len(trim(form.RHTid))>
        <input type="hidden" name="RHTid" value="#form.RHTid#">
    </cfif>
    <cfif isdefined("form.Ifecha") and len(trim(form.Ifecha))>
        <input type="hidden" name="Ifecha" value="#form.Ifecha#">
    </cfif>
    <cfif isdefined("form.IfechaF") and len(trim(form.IfechaF))>
        <input type="hidden" name="Ifecha" value="#form.IfechaF#">
    </cfif>
    <cfif isdefined("form.DEid") and len(trim(form.DEid))>
        <input type="hidden" name="DEid" value="#form.DEid#">
    </cfif>
    <cfif isdefined("form.CIid") and len(trim(form.CIid))>
        <input type="hidden" name="CIid" value="#form.CIid#">
    </cfif> 
    <cfif isdefined("form.Iid") and len(trim(form.Iid))>
        <input type="hidden" name="Iid" value="#form.Iid#">
    </cfif> 
</form>
</cfoutput>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>