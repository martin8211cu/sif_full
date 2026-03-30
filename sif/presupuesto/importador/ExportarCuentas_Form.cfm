<!--- Exportación a Archivo Excel --->
<cffunction name="write_to_buffer" output="false">
	<cfargument name="contents" type="string" required="yes">
	<cfargument name="flush" type="boolean"   default="no">
	<cfset buffer.append(Arguments.contents)>
	<cfif Arguments.flush Or (buffer.length() GE 64000)>
		<cffile action="append" file="#temporaryFileName#" output="#buffer.toString()#"  addnewline="no">
		<cfset buffer.setLength(0)>
	</cfif>
</cffunction>
<cffunction name="to_buffer" output="false">
	<cfargument name="contents" type="string" required="yes">
	<cfreturn "'" & replace (trim(Arguments.contents),chr(9),"","ALL")>
</cffunction>

<cfsetting requesttimeout="900" enablecfoutputonly="yes">
<cfflush interval="128">
<cfset LvarNewLine	= Chr(13) & Chr(10)>
<cfset LvarTab		= Chr(9)>
<cfset buffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 65536 ))>
<cfset temporaryFileName = GetTempFile( GetTempDirectory(), 'ExportCuentas')>
<cffile action="write" file="#temporaryFileName#" output="" addNewLine="no">

<cfquery name="data" datasource="#session.DSN#">
	select distinct
		'F' as TipoCuenta,
		CFformato as FormatoCuenta, 
		coalesce(CFdescripcionF, CFdescripcion) as Descripcion
		, cf.CFformato, 1 as OrderBy
	 from CFinanciera cf
	 	where cf.Ecodigo = #session.Ecodigo#
		  and cf.CFmovimiento = 'S'
		  and cf.CFformato <> cf.Cmayor 
		
		<cfif isdefined("form.finicio") and len(trim(form.finicio))>
			and cf.BMUfechaAlta >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.finicio,'dd/mm/yyyy')#">
		</cfif>
		<cfif isdefined("form.ffinal") and len(trim(form.ffinal))>
			and cf.BMUfechaAlta <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.ffinal,'dd/mm/yyyy')#">
		</cfif>

		<cfif isdefined("form.CFformato") and len(trim(form.CFformato))>
			and CFformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato#">
		</cfif>
		<cfif isdefined("form.CFformato2") and len(trim(form.CFformato2))>
			and CFformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato2#">
		</cfif>
	UNION
	select 
		'C' as TipoCuenta,
		t.Cformato as FormatoCuenta, 
		coalesce(t.CdescripcionF, t.Cdescripcion) as Descripcion
		, cf.CFformato, 2 as OrderBy
	 from CFinanciera cf
	 	inner join CContables t
			  on t.Ccuenta = cf.Ccuenta
			 and t.Cformato <> cf.CFformato
	 	where cf.Ecodigo = #session.Ecodigo#
		  and cf.CFmovimiento = 'S'
		  and cf.CFformato <> cf.Cmayor 
		
		<cfif isdefined("form.finicio") and len(trim(form.finicio))>
			and cf.BMUfechaAlta >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.finicio,'dd/mm/yyyy')#">
		</cfif>
		<cfif isdefined("form.ffinal") and len(trim(form.ffinal))>
			and cf.BMUfechaAlta <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.ffinal,'dd/mm/yyyy')#">
		</cfif>

		<cfif isdefined("form.CFformato") and len(trim(form.CFformato))>
			and CFformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato#">
		</cfif>
		<cfif isdefined("form.CFformato2") and len(trim(form.CFformato2))>
			and CFformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato2#">
		</cfif>
	UNION
	select 
		'P' as TipoCuenta,
		t.CPformato as FormatoCuenta, 
		coalesce(t.CPdescripcionF, t.CPdescripcion) as Descripcion
		, cf.CFformato, 3 as OrderBy
	 from CFinanciera cf
	 	inner join CPresupuesto t
			  on t.CPcuenta = cf.CPcuenta
			 and t.CPformato <> cf.CFformato
	 	where cf.Ecodigo = #session.Ecodigo#
		  and cf.CFmovimiento = 'S'
		  and cf.CFformato <> cf.Cmayor 
		
		<cfif isdefined("form.finicio") and len(trim(form.finicio))>
			and cf.BMUfechaAlta >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.finicio,'dd/mm/yyyy')#">
		</cfif>
		<cfif isdefined("form.ffinal") and len(trim(form.ffinal))>
			and cf.BMUfechaAlta <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.ffinal,'dd/mm/yyyy')#">
		</cfif>

		<cfif isdefined("form.CFformato") and len(trim(form.CFformato))>
			and CFformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato#">
		</cfif>
		<cfif isdefined("form.CFformato2") and len(trim(form.CFformato2))>
			and CFformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFformato2#">
		</cfif>
	order by OrderBy, CFformato
</cfquery>
<cfquery name="data" dbtype="query">
	select 	TipoCuenta,
			FormatoCuenta, 
			Descripcion
	  from data
</cfquery>
<cf_queryToFile queryName="data" FileName="ExportacionCuentas.xls">
<cfabort>
<cfsilent>
	<cfset write_to_buffer('#LvarTab##LvarTab#TIPO: F=Financiero+Contable+Presupuesto, C=Sólo Contable, P=Sólo Presupuesto#LvarNewLine#')>
	<cfset write_to_buffer('#LvarTab##LvarTab#(Elimine los títulos en el archivo de importación y genere un archivo CVS=Separado por comas)#LvarNewLine#')>
	<cfset write_to_buffer('TIPO#LvarTab#FORMATO#LvarTab#DESCRIPCION#LvarNewLine#')>
</cfsilent>

<cfloop query="data">
	<cfsilent><cfset write_to_buffer('#to_buffer(TipoCuenta)##LvarTab##to_buffer(FormatoCuenta)##LvarTab##to_buffer(Descripcion)##LvarNewLine#')></cfsilent>
</cfloop>

<cfset write_to_buffer('', true)>
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfheader name="Content-Disposition"	value="attachment;filename=ExportCuentas.xls">
<cfcontent type="application/msexcel" reset="yes" file="#temporaryFileName#" deletefile="yes">