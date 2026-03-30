<!--- Actualiza el total de conciliados al ya sea en el lado de Libros o Bancos--->

<cfset SumaResta='#url.SumaResta#'>
<cfset Nombre='#url.Nombre#'>
<cfset ECid='#url.ECid#'>
<cfset id='#url.id#'>

<cfif #Nombre# eq 'chkTodosLibros'>
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update 	CDLibros
			set CDLacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
				CDLUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"> 
			and CDLUsucodigo<cfif #SumaResta#> is null <cfelse>=#session.Usucodigo#</cfif>
			and CDLconciliado='N'
	</cfquery>

<cfelseif #Nombre# eq 'chkTodosBancos'>
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update 	CDBancos
			set CDBacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
				CDBUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
			and CDBUsucodigo<cfif #SumaResta#> is null <cfelse>=#session.Usucodigo#</cfif>
			and CDBconciliado='N'
	</cfquery>

<cfelseif #Nombre# eq 'chkLibros'>
	<cfquery name="rsUsucodigo" datasource="#session.DSN#">
		select CDLacumular,CDLUsucodigo as Usucodigo
			from CDLibros
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"> 
			and MLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
	</cfquery>
	
	<cfif #rsUsucodigo.Usucodigo# eq #session.Usucodigo# or not len(trim('#rsUsucodigo.Usucodigo#'))> 
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update 	CDLibros
				set CDLacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
					CDLUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
				where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"> 
				and MLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
		</cfquery>
	<cfelse>
		<cfquery name="rsUsuario" datasource="#session.DSN#">
			select Pid,Pnombre,Papellido1 
				from Usuario a
				inner join DatosPersonales b
				on a.datos_personales = b.datos_personales 
				where Usucodigo=#rsUsucodigo.Usucodigo#
		</cfquery>
		<cfoutput>
			<!---retorna al ajax--->
			actualizar | el usuario #rsUsuario.Pnombre# #rsUsuario.Papellido1# cedula:#rsUsuario.Pid# ya modifico este registro, actualice la pantalla para ver el cambio. Desea actualizar?|			
		</cfoutput>	
	</cfif>	

<cfelseif #Nombre# eq 'chkBancos'>
	<cfquery name="rsUsucodigo" datasource="#session.DSN#">
		select CDBacumular,CDBUsucodigo  as Usucodigo
			from CDBancos
			where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"> 
			and CDBlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
	</cfquery>

	<cfif #rsUsucodigo.Usucodigo# eq #session.Usucodigo# or not len(trim('#rsUsucodigo.Usucodigo#'))> 
		<cfquery name="rsActualiza" datasource="#session.DSN#">
			update 	CDBancos
				set CDBacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
					CDBUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
				where ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
				and CDBlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
		</cfquery>
	<cfelse>
		<cfquery name="rsUsuario" datasource="#session.DSN#">
			select Pid,Pnombre,Papellido1 
				from Usuario a
				inner join DatosPersonales b
				on a.datos_personales = b.datos_personales 
				where Usucodigo=#rsUsucodigo.Usucodigo#
		</cfquery>
		<cfoutput>
			<!---retorna al ajax--->
			actualizar | el usuario #rsUsuario.Pnombre# #rsUsuario.Papellido1# cedula:#rsUsuario.Pid# ya modifico este registro, actualice la pantalla para ver el cambio. Desea actualizar? |			
		</cfoutput>		
	</cfif>	
</cfif>


<cfquery name="rsMontoL" datasource="#session.DSN#">
	select round(coalesce((sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - sum(case CDLtipomov when 'C' then CDLmonto else 0 end)),0.00),2) as sumaDCL
	from CDLibros
	where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	  and CDLacumular = 1
	  and CDLUsucodigo=#session.Usucodigo#
</cfquery>

<cfquery name="rsMontoB" datasource="#session.DSN#">
	select coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
	sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00) as sumaDCB
	from CDBancos
	where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	  and CDBacumular = 1
	  and CDBUsucodigo=#session.Usucodigo#
</cfquery>



<cfoutput>
	<!---retorna al ajax--->#rsActualiza#
	#LSNumberFormat(rsMontoL.sumaDCL,'9,9.99')# | #LSNumberFormat(rsMontoB.sumaDCB,'9,9.99')# 
</cfoutput>

