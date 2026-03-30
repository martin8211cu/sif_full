<cfparam name="form.autor" default="">
<cfset form.autor = Replace(form.autor, ' ',' ', 'all')>
<cfset form.ruta = Replace(form.ruta, '\','/', 'all')>
<cfloop list="#form.ruta#" index="la_ruta">
	<cfset mapkey = la_ruta>
  <cftry>
    <cfinvoke component="asp.parches.comp.path" method="concatURL"
	dir="#session.parche.svnBranch#" file="#la_ruta#"
	returnvariable="branchAndFile"/>
    <cfinvoke component="asp.parches.comp.path" method="concatURL"
	dir="#session.parche.reposURL#" file="#branchAndFile#"
	returnvariable="fullURL"/>
	
    <cfinvoke component="asp.parches.comp.svnclient"
		method="get_log"
		svnURL="#fullURL#"
		PathFilter="/#branchAndFile#"
		fecha_desde="#LSParseDateTime(form.rev1)#"
		returnvariable="the_log" />
    <cfset Prefix = '/' & session.parche.svnBranch & '/'>
    <cfloop from="1" to="#ArrayLen(the_log)#" index="i">
      <cfif Trim(form.autor) EQ '*' or Len(trim(form.autor)) EQ 0 or ListFindNoCase(form.autor, the_log[i].Author)>
        <cfloop from="1" to="#ArrayLen(the_log[i].Paths)#" index="j">
          <!--- Action="#the_log[i].Paths[j].action#" --->
          <cfset mapkey = the_log[i].Paths[j].path>
          <cfif Left(mapkey, Len(Prefix)) EQ Prefix>
            <cfset mapkey = Mid(mapkey, Len(Prefix) + 1, Len(mapkey) - Len(Prefix))>
          </cfif>
          <cfif ListLen(mapkey, '.') GT 1 AND Find('/', ListLast(mapkey,'.')) EQ 0
		  		  And (Len(form.rutarex) EQ 0 Or REFindNoCase(form.rutarex, the_log[i].Paths[j].path) ) >
            <!--- excluye las rutas sin extension (directorios), y las que no cumplan la expr. regular, si hay --->

			<cfquery datasource="asp" name="rsCurrentRev">
				select revision from APFuente
				where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
				  and nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mapkey#">
			</cfquery>
			<cfif Len(rsCurrentRev.revision)>
				<cfset currentRev = rsCurrentRev.revision>
			</cfif>
			<cfif Len(rsCurrentRev.revision) EQ 0>
				<cfquery datasource="asp">
					insert into APFuente (
						parche, nombre, revision, autor, fecha, msg, checksum)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mapkey#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#the_log[i].Revision#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#the_log[i].Author#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#the_log[i].Date#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#the_log[i].Msg#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="">)
				</cfquery>
				<!--- después volvemos a contar, esto es solo para validar los 1000 archivos --->
				<cfset session.parche.cant_fuentes = session.parche.cant_fuentes + 1>
				<cfif session.parche.cant_fuentes GT 1000 >
					<cfthrow message="Se excedió el máximo de 1,000 archivos por parche.">
				</cfif>
			<cfelseif the_log[i].Revision GT rsCurrentRev.revision>
				<cfquery datasource="asp">
					update APFuente
					set revision = <cfqueryparam cfsqltype="cf_sql_integer" value="#the_log[i].Revision#">,
					  autor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#the_log[i].Author#">,
					  fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#the_log[i].Date#">,
					  msg = <cfqueryparam cfsqltype="cf_sql_clob" value="#the_log[i].Msg#">,
					  checksum = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
					where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
					  and nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mapkey#">
				</cfquery>
			</cfif>
          </cfif>
        </cfloop>
      </cfif>
    </cfloop>
	<cfinvoke component="asp.parches.comp.parche" method="contar" />
    <cfcatch type="any">
      <cfset str = StructNew()>
      <cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
      <cfset str.archivo = mapkey>
      <cfset ArrayAppend(session.parche.errores, str)>
    </cfcatch>
  </cftry>
</cfloop>
<cflocation url="svnconfirmar.cfm">
