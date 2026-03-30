
<cfquery name="Menu" datasource="asp">
	select mn.SMNtitulo as SubCategory, case mn.SMNnivel when 1 then mn.SMNcodigo else mn.SMNcodigoPadre end as SubCategoryID, sp.SPdescripcion as Name, SPhomeuri as Link, SPhablada as Description
	from SMenues mn
		left outer join SProcesos sp
			on mn.SScodigo = sp.SScodigo
			and mn.SMcodigo = sp.SMcodigo
			and mn.SPcodigo = sp.SPcodigo
	where mn.SScodigo = 'SIF'
		and mn.SMcodigo = 'MB'
		and mn.SMNnivel > 0
		and exists ( select *
					from SMenues mnp, vUsuarioProcesos up
					where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					  and up.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigosdc#">
					  and up.SScodigo = mnp.SScodigo
					  and up.SMcodigo = mnp.SMcodigo
					  and up.SPcodigo = mnp.SPcodigo
					  and mn.SScodigo = mnp.SScodigo
					  and mn.SMcodigo = mnp.SMcodigo)
	order by substring(mn.SMNpath,1,9), sp.SPorden
</cfquery>
<cfset Menues = QueryNew("Name, Description, Link, Category, SubCategory")>
<cfset QueryAddRow(Menues,1)>
<cfset QuerySetCell(Menues,"Name","Inicio",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Description","Bancos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Link","/cfmx/sif/mb/MenuMB.cfm",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"Category","Bancos",Menues.RecordCount)>
<cfset QuerySetCell(Menues,"SubCategory","Inicio",Menues.RecordCount)>
<cfset Lvar_Actual_SubCategoryID = -1>
<cfset Lvar_Actual_SubCategory = ''>

<cfoutput query="Menu">
	<cfif Lvar_Actual_SubCategoryID neq SubCategoryID>
		<cfif SubCategory eq 'Operaciones' or (len(SubCategory) eq 0 and Lvar_Actual_SubCategoryID eq -2)>
			<cfset Lvar_Actual_SubCategory = Name>
			<cfset Lvar_Actual_Name = Name>
			<cfset Lvar_Actual_SubCategoryID = -2>
		<cfelse>
			<cfset Lvar_Actual_SubCategoryID = SubCategoryID>
			<cfset Lvar_Actual_SubCategory = SubCategory>
			<cfset Lvar_Actual_Name = SubCategory>
		</cfif>
	</cfif>
	<cfif (len(Lvar_Actual_Name) or len(Name))
		or (len(Lvar_Actual_SubCategory))>
		<cfset QueryAddRow(Menues,1)>
		<cfif len(Lvar_Actual_Name)>
			<cfset QuerySetCell(Menues,"Name","#Lvar_Actual_Name#",Menues.RecordCount)>
		<cfelse>
			<cfset QuerySetCell(Menues,"Name","#Name#",Menues.RecordCount)>
		</cfif>
		<cfset QuerySetCell(Menues,"Description","#Description#",Menues.RecordCount)>
		<cfif len(Link)>
			<cfset QuerySetCell(Menues,"Link","/cfmx#Link#",Menues.RecordCount)>
		</cfif>
		<cfset QuerySetCell(Menues,"Category","Bancos",Menues.RecordCount)>
		<cfset QuerySetCell(Menues,"SubCategory","#Lvar_Actual_SubCategory#",Menues.RecordCount)>
	</cfif>
	<cfset Lvar_Actual_Name = ''>	
</cfoutput>