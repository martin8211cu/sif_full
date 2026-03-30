<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TipoIdentif" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert Idioma (Icodigo,Descripcion,Iactivo,Inombreloc,Iid_idioma)
				values (
					 	<cfqueryparam value="#form.Icodigo#" 	cfsqltype="cf_sql_varchar">
					 , 	<cfqueryparam value="#form.Descripcion#" 	cfsqltype="cf_sql_varchar">
					 <cfif isdefined('form.Iactivo')>
					 	, 1
					 <cfelse>
					 	, 0
					 </cfif>
 					 , 	<cfqueryparam value="#form.Inombreloc#" 	cfsqltype="cf_sql_varchar">
 					 , 	<cfqueryparam value="#form.Iid_idioma#" 	cfsqltype="cf_sql_numeric">
					 )
			<cfelseif isdefined("form.Cambio")>
				update Idioma
					set Icodigo = <cfqueryparam value="#form.Icodigo#" cfsqltype="cf_sql_varchar">
						, Descripcion = <cfqueryparam value="#form.Descripcion#" cfsqltype="cf_sql_varchar">
						 <cfif isdefined('form.Iactivo')>
							, Iactivo = 1
						 <cfelse>
							, Iactivo = 0
						 </cfif>
					 	, Inombreloc = <cfqueryparam value="#form.Inombreloc#" cfsqltype="cf_sql_varchar">
				where Iid = <cfqueryparam value="#form.Iid#" cfsqltype="cf_sql_numeric">
				  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete Idioma
				where Iid= <cfqueryparam value="#form.Iid#" cfsqltype="cf_sql_numeric">
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="idioma.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Iid_padre"   type="hidden" value="#form.Iid_padre#">
	<cfif modo eq 'CAMBIO'><input name="Iid" type="hidden" value="#form.Iid#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
