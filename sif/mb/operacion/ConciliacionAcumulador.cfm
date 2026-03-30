<!---
Nota: Cuando se quiera debuguear No existe alert ni dump por lo cual se debe utilizar la siguiente instruccion
<cfoutput>
	<!---retorna al ajax del fuente que lo llamo--->
	Este es el campo en rojo del total de Libros |  Y este el campo de Bancos separados por este signo->  |			
</cfoutput>	

De forma tal que si quiere ver lo que trae un campo o variable haria lo siguiente
<cfoutput>
	<!---retorna al ajax del fuente que lo llamo--->
	Variable 1:#LvarVariable1# |  Campo de BD:  #rsUsucodigo.CDLacumular#   |			
</cfoutput>

en cualquier de los campos puedo concatener el mensaje que quiera

--->

<!--- Actualiza el total de conciliados al ya sea en el lado de Libros o Bancos--->

<cfset SumaResta='#url.SumaResta#'>
<cfset Nombre='#url.Nombre#'>
<cfset ECid='#url.ECid#'>
<cfset id='#url.id#'>
<cfif isdefined('url.Equivalencia') and len(trim(#url.Equivalencia#))>
	<cfset Equivalencia='#url.Equivalencia#'>
</cfif>
<cfparam name="Equivalencia" default="no">
<cfif isdefined('url.BTid') and len(trim(#url.BTid#))>
	<cfset BTid='#url.BTid#'>
</cfif>
<cfparam name="BTid" default="-1">
<cfif #Nombre# eq 'chkTodosLibros'>
	<!--- JARR se modif  --->
	<!--- ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">  --->
	<!--- <cfquery name="rsActualiza" datasource="#session.DSN#">
		update 	CDLibros
			set CDLacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
				CDLUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
			where
			<cfif #Equivalencia# eq 'si'>
				EXISTS (
						SELECT b.BTid 
						FROM BTransacciones b
						inner join MLibros c 
							on CDLibros.MLid = c.MLid
						left join Usuario d
							on CDLibros.CDLUsucodigo= d.Usucodigo
						WHERE b.BTid = CDLibros.CDLidtrans
						and CDLibros.CDLconciliado <> 'S'
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">						
						and CDLibros.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
						<cfif isdefined('url.BTid')  and url.BTid NEQ -1>
							and CDLibros.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
						</cfif>
						)
			</cfif>
			and CDLUsucodigo<cfif #SumaResta#> is null <cfelse>=#session.Usucodigo#</cfif>
			and CDLconciliado='N'		
	</cfquery> --->
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update 	CDLibros
			set CDLacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
				CDLUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 
			where
			
				MLid in (
						select a.MLid
						  FROM CDLibros a
						INNER JOIN BTransacciones b ON b.BTid = a.CDLidtrans
						AND a.CDLconciliado <> 'S'
						AND b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
						INNER JOIN MLibros c ON a.MLid = c.MLid
						<cfif isdefined("url.LvarBancoID") and len(trim(url.LvarBancoID)) >
							and c.Bid=#url.LvarBancoID#
						</cfif>
						<cfif isdefined("url.LvarCtaBancoID") and len(trim(url.LvarCtaBancoID)) >
							and c.CBid=#url.LvarCtaBancoID#
						</cfif>
						LEFT JOIN Usuario d ON a.CDLUsucodigo= d.Usucodigo
						LEFT JOIN DatosPersonales e ON d.datos_personales = e.datos_personales
						WHERE 1=1
						<cfif isdefined('url.BTid')  and url.BTid NEQ -1>
							and CDLibros.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
						</cfif>
						<cfif isdefined('url.fecha_maxima')  and url.fecha_maxima NEQ ''>
							AND CDLibros.CDLfecha <=  convert(datetime, REPLACE('#url.fecha_maxima#','-',' '), 110) 
						</cfif>
						<cfif #Equivalencia# eq 'si'>
						AND CDLidtrans = 1
						</cfif>
						)

			and CDLconciliado='N'		
	</cfquery>

<!--- SELECT b.BTid 
						FROM BTransacciones b
						inner join MLibros c 
							on CDLibros.MLid = c.MLid
						left join Usuario d
							on CDLibros.CDLUsucodigo= d.Usucodigo
						WHERE b.BTid = CDLibros.CDLidtrans
						and CDLibros.CDLconciliado <> 'S'
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">						
						and CDLibros.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
						<cfif isdefined('url.BTid')  and url.BTid NEQ -1>
							and CDLibros.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
						</cfif> --->









<cfelseif #Nombre# eq 'chkTodosBancos'>
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update 	CDBancos
			set CDBacumular=<cfif #SumaResta#>1<cfelse>0</cfif>,
				CDBUsucodigo=<cfif #SumaResta#>#session.Usucodigo#<cfelse><cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"></cfif> 			
			where 
			<cfif #Equivalencia# eq 'si'>
				EXISTS (
						SELECT tb.BTEdescripcion 
						FROM BTransaccionesEq b						
							inner join TransaccionesBanco tb 
								on b.Bid = tb.Bid 
								and b.BTEcodigo = tb.BTEcodigo 
							left join DCuentaBancaria c 
								on c.Linea = CDBancos.CDBlinref 
							left join Usuario d 
								on CDBancos.CDBUsucodigo= d.Usucodigo 
						
						WHERE b.Ecodigo = CDBancos.Ecodigo
							and b.Bid = CDBancos.Bid 
							and b.BTEcodigo = CDBancos.BTEcodigo 
							and CDBancos.CDBconciliado <> 'S' 
							and CDBancos.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and CDBancos.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
							<cfif isdefined('url.BTid')  and url.BTid NEQ -1>
								and b.BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
							</cfif>
						)
					and
			</cfif>	
			ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
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






<!--- JARR nuevo parametros para el calculo de los montos --->





<cfquery name="rsMontoL" datasource="#session.DSN#">
	select  round(coalesce((sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - 
	sum(case CDLtipomov when 'C' then CDLmonto else 0 end)),0.00),2) as sumaDCL
	from CDLibros
	where  
	EXISTS (
		SELECT b.BTid 
		FROM BTransacciones b
		inner join MLibros c 
			on CDLibros.MLid = c.MLid
			<cfif isdefined("url.LvarBancoID") and len(trim(url.LvarBancoID)) >
				and c.Bid=#url.LvarBancoID#
			</cfif>
			<cfif isdefined("url.LvarCtaBancoID") and len(trim(url.LvarCtaBancoID)) >
				and c.CBid=#url.LvarCtaBancoID#
			</cfif>
		left join Usuario d
			on CDLibros.CDLUsucodigo= d.Usucodigo
		WHERE b.BTid = CDLibros.CDLidtrans
		and CDLibros.CDLconciliado <> 'S'
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">						
		<!--- and CDLibros.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">--->
		<cfif isdefined('url.BTid')  and url.BTid NEQ -1>
			and CDLibros.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
		</cfif>
		)
and CDLacumular = 1
and CDLconciliado <> 'S'
	<!--- and	ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	
	and CDLUsucodigo=#session.Usucodigo#  --->
</cfquery>

<cfquery name="rsMontoB" datasource="#session.DSN#">
	select round(coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
	sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00),2) as sumaDCB
	from CDBancos
	where
	<cfif #Equivalencia# eq 'si'>
	EXISTS (
			SELECT tb.BTEdescripcion 
			FROM BTransaccionesEq b
				inner join TransaccionesBanco tb
					on b.Bid = tb.Bid 
					and b.BTEcodigo = tb.BTEcodigo 					
				left join DCuentaBancaria c 
					on c.Linea = CDBancos.CDBlinref 
				left join Usuario d 
					on CDBancos.CDBUsucodigo= d.Usucodigo 
				
			WHERE b.Ecodigo = CDBancos.Ecodigo
			  and tb.Bid = CDBancos.Bid 
			  and tb.BTEcodigo = CDBancos.BTEcodigo 
			  and CDBancos.CDBconciliado <> 'S' 
		  	  and CDBancos.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and CDBancos.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
			  <cfif isdefined('url.BTid')  and url.BTid NEQ -1>
				and b.BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.BTid#">
			  </cfif>
		)
		and 
	</cfif>
		ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	and CDBacumular = 1
	and CDBconciliado <> 'S' 
	and CDBUsucodigo=#session.Usucodigo#
</cfquery>
					
<cfoutput>
	<!---retorna al ajax--->
	#LSNumberFormat(rsMontoL.sumaDCL,'9,9.99')# | #LSNumberFormat(rsMontoB.sumaDCB,'9,9.99')# 
</cfoutput>

