<cfif not isdefined("Form.Nuevo")>
<!---=================Agregar Formulación======================--->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="sifcontrol">
			insert into CodigoError (
				   CERRcod,
				   CERRmsg,
				   CERRdes,
				   CERRcor,
				   CERRref
				  )
			values (<cfqueryparam cfsqltype="cf_sql_numeric"     value="#form.CERRcod#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"     value="#form.CERRmsg#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.CERRdes#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.CERRcor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"     value="#form.Refer#" null="#IIF(form.Refer EQ "", true, false)#">
				) 
		</cfquery>
	<cfoutput><cflocation url="ErroresPortal.cfm?CERRcod=#form.CERRcod#"></cfoutput>
<!---====================Eliminar  Formulación=======================--->	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="referenciados" datasource="sifcontrol">
			select CERRcod 
			  from CodigoError
			  where CERRref =#form.CERRcod# 
		</cfquery>
		<cfif referenciados.recordcount GT 0>
			<cfset listaErrores = "">
			<cfloop query="referenciados">
				<cfif len(listaErrores)>
					<cfset listaErrores = listaErrores & ','>
				</cfif>
				<cfset listaErrores = listaErrores & referenciados.CERRcod>
			</cfloop>
			<cfthrow message="El Error #form.CERRcod#  no se puede Eliminar, ya que esta siendo referenciado por los siguientes errores: #listaErrores#">
		<cfelse>
			<cfquery datasource="sifcontrol">
				delete from CodigoError
			  		where CERRcod =#form.CERRcod# 
		</cfquery>
		</cfif>
<!---====================Modificar Formulación=======================--->
	<cfelseif isdefined("Form.Cambio")>		
		<cfquery name="update" datasource="sifcontrol">
			update CodigoError set 
				   	CERRmsg = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.CERRmsg#">,
					CERRdes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.CERRdes#">,
					CERRcor = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.CERRcor#">,
					CERRref = <cfqueryparam cfsqltype="cf_sql_numeric"     value="#form.Refer#" null="#IIF(form.Refer EQ "", true, false)#">
			where CERRcod   = #form.CERRcod#
		</cfquery> 
		<cfoutput><cflocation url="ErroresPortal.cfm?CERRcod=#form.CERRcod#"></cfoutput>
	</cfif>
</cfif>
<cflocation url="ErroresPortal.cfm">
