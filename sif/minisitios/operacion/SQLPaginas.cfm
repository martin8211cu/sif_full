<!--- INSERCION DE LA PLANTILLA SELECCIONADA --->

<!--- 2. Calcula Consecutivo --->
<cfquery name="rsConsecutivo" datasource="sdc">
	select isnull(max(convert(numeric, MSPcodigo)),0) + 1 as codigo
	from MSPagina
	where Scodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
</cfquery>
<cfset MSPcodigo = rsConsecutivo.codigo >

<!--- 3. Inserta MSPagina, Modifica MSMenu --->
<cfquery name="rsPagina" datasource="sdc">
	set nocount on
	
	declare @categoria numeric
	select @categoria = MSCcategoria from MSCategoria
	
	insert MSPagina( Scodigo, MSPcodigo, MSPplantilla, MSCcategoria, MSPtitulo, MSPumod, MSPfmod )
	values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(MSPcodigo)#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MSPplantilla)#">,
			 @categoria,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MSMtexto)#">,
			 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			 getdate()
		   )
		   
	update MSMenu
	set MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(MSPcodigo)#">
	where MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MSMmenu#">
		   
	set nocount off		
</cfquery>

<!--- PROCESAR la plantilla, lo que hay que hacer es insertar en MSPaginaArea--->
<cfset area      = "area" & form.MSPplantilla >
<cfset listaArea = Evaluate(area) >
<cfset cont      = 1 > 
<cfloop list="#listaArea#" index="i">
	<cfquery name="rsArea" datasource="sdc">
		set nocount on
		insert MSPaginaArea (Scodigo, MSPcodigo, MSPAarea, MSPAnombre, MSCcontenido)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">,
				#cont#,
				'#i#',
				null)
		set nocount off	
	</cfquery>
	<cfset cont = cont+1 >
</cfloop>