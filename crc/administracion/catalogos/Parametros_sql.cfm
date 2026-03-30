<cfparam name="url.Mcodigo" default="">
<cfset LvarPagina = "Parametros.cfm?Mcodigo=#url.Mcodigo#">

<cfquery name="rsParametos" datasource="#session.dsn#">
	SELECT id,Pcodigo,Mcodigo,Pvalor,Pdescripcion,Pcategoria,
       TipoDato,TipoParametro,Parametros
	FROM CRCParametros
	WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset arrFields=listToArray(form.fieldnames,",","false")>
<cfloop array="#arrFields#" index="field">
	<cfif left(field,2) eq "f_">
		<cfset loc.code="#mid(field,3,len(field)-2)#">
		<cfquery name="rsParam" dbtype="query">
			select Pvalor from rsParametos
			where Pcodigo = '#loc.code#'
		</cfquery>
		<cfset loc.valor = trim(form['#field#'])>
		<cfif trim(rsParam.Pvalor) neq loc.valor>
			<cfquery datasource="#session.dsn#">
				update CRCParametros
					set Pvalor = '#loc.valor#',
						Usumodif = #Session.usucodigo#,
						updatedat = #now()#
				where Pcodigo = '#trim(loc.code)#'
					and Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfif>
	</cfif>
</cfloop>


<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">

</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>