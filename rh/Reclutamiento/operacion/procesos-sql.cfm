<cfparam name="form.SRcodigo" default="">
<cfinclude template="fnUriNotExists.cfm">

	<!--- procesa la imagen --->
	
	<cffunction name="addMenu">
		<cfif len(form.SMNcodigo) is 0>
			<cfreturn>
		</cfif>
		<cfquery datasource="asp" name="ordenmenu">
			select coalesce (max(SMNorden), 0) maxorden
			from SMenues
			where SMNcodigoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SMNcodigo#">
		</cfquery>
		<cfquery datasource="asp" name="menuid">
			Select coalesce((max(SMNcodigo)),0)+1 as SMNcodigo
			from SMenues
		</cfquery>

		<cfset orden = NumberFormat(ordenmenu.maxorden + 1,'000')>
		<cfquery name="rs" datasource="asp">
			insert into SMenues
				(SScodigo, SMcodigo, SPcodigo, SMNcodigo, SMNcodigoPadre,
				 SMNnivel, SMNpath, SMNtipo, SMNorden)
			select
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.SScodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#menuid.SMNcodigo#">,
				padre.SMNcodigo SMNcodigoPadre,
				SMNnivel + 1,
				{ fn concat({fn concat(SMNpath, '|')}, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#orden#">)},					<!---SMNpath || '|' || <cfqueryparam cfsqltype="cf_sql_char" value="#orden#">,--->
				'P' SMNtipo,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#orden#">
			from SMenues padre
			where SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SMNcodigo#">
		</cfquery>
	</cffunction>
	
	<cffunction name="getMenuPadre" returntype="string">
		<cfquery name="rs" datasource="asp">
			select SMNcodigoPadre
			from SMenues
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
			order by SMNcodigo
		</cfquery>
		<cfreturn rs.SMNcodigoPadre>
	</cffunction>
	
	<cffunction name="delMenu">
		<cfquery name="rs" datasource="asp">
			delete from SMenues
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
		</cfquery>
	</cffunction>

	<cffunction name="resecuenciar">
		<cfargument name="SScodigo" type="string" required="yes">
		<cfargument name="SMcodigo" type="string" required="yes">
		<cfargument name="SPcodigo" type="string" required="yes">

		<cfquery name="datos" datasource="asp">
			select SSdestino, SMdestino, SPdestino, posicion
			from SProcesoRelacionado
			where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SScodigo#"> 
			  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMcodigo#"> 
			  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPcodigo#"> 
			order by posicion
		</cfquery>
		
		<cfset numero = 0 >
		<cfloop query="datos">
			<cfset numero = numero + 10 >
			<cfif datos.posicion neq numero>
				<cfquery datasource="asp">
					update SProcesoRelacionado
					set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#numero#">
					where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SScodigo#"> 
					  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMcodigo#"> 
					  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPcodigo#"> 
					  and SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.SSdestino#"> 
					  and SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.SMdestino#">
					  and SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.SPdestino#">
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="insertarRelacionado">
		<cfargument name="SSorigen"  type="string" required="yes">
		<cfargument name="SMorigen"  type="string" required="yes">
		<cfargument name="SPorigen"  type="string" required="yes">
		<cfargument name="SSdestino" type="string" required="yes">
		<cfargument name="SMdestino" type="string" required="yes">
		<cfargument name="SPdestino" type="string" required="yes">
		<cfargument name="posicion"  type="string" required="yes">
		<cfargument name="ocultar"   type="string" required="yes">

		<cfquery name="data" datasource="asp">
			select 1
			from SProcesoRelacionado
			where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSorigen#"> 
			  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMorigen#"> 
			  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPorigen#"> 
			  and SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSdestino#"> 
			  and SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMdestino#">
			  and SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPdestino#">
		</cfquery>
		<cfif data.recordCount eq 0 >
			<cfif len(trim(arguments.posicion)) eq 0 >
				<cfquery name="dataPosicion" datasource="asp">
					select coalesce(max(posicion),0) as posicion
					from SProcesoRelacionado
					where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSorigen#"> 
					  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMorigen#"> 
					  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPorigen#"> 
				</cfquery>
				<cfset LvarPosicion = dataPosicion.posicion + 10 >	
			<cfelse>
				<cfset LvarPosicion = arguments.posicion >	
			</cfif>
		
			<cfquery datasource="asp">
				insert into SProcesoRelacionado( SSorigen, SMorigen, SPorigen, SSdestino, SMdestino, SPdestino, posicion, ocultar, BMfecha, BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSorigen#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMorigen#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPorigen#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SSdestino#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SMdestino#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SPdestino#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPosicion#">,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.ocultar#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					   )
			</cfquery>
		</cfif>

	</cffunction>

	<cfif not ( isdefined("form.AgregarRelacionado") or isdefined("form.ModificarRelacionado") or isdefined("form.EliminarRelacionado") or isdefined("form.Nuevo") )>
		<cfset form.SPhomeuri = trim(form.SPhomeuri)>
		<cfset LvarSPhomeuri = form.SPhomeuri>
		<cfset LvarSignoPto = find("?",LvarSPhomeuri)>
		<cfif LvarSignoPto>
			<cfset LvarSPhomeuriP = mid(LvarSPhomeuri,LvarSignoPto,len(LvarSPhomeuri))>
			<cfset LvarSPhomeuri  = mid(LvarSPhomeuri,1,LvarSignoPto-1)>
		<cfelse>
			<cfset LvarSPhomeuriP = "">
		</cfif>
		<cfif LvarSPhomeuri EQ "/">
			<cfset LvarUri.NotExists = 0>
		<cfelse>
			<cfset LvarUri = fnUriNotExists(LvarSPhomeuri, 'P')>
			<cfif LvarUri.NotExists EQ 1>
				<cfset LvarSPhomeuri  = LvarUri.Uri>
				<cfset form.SPhomeuri = LvarUri.Uri & LvarSPhomeuriP>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("form.Agregar")>
	<cfif LvarUri.NotExists EQ 2><cfthrow message="No existe la Pagina Inicial: #LvarSPhomeuri#"></cfif>
	<cftransaction>
		<cfquery name="rs" datasource="asp">
			insert into SProcesos ( SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, SPorden, SPlogo, SPhablada, SPanonimo, SPpublico, SPinterno, BMUsucodigo, BMfecha )
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPdescripcion)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPhomeuri)#">,
					 <cfif isdefined("form.SPmenu")>1<cfelse>0</cfif>,
					<cfif len(trim(form.SPorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SPorden#"><cfelse>null</cfif>,
					<cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SPhablada#">,
					<cfif isdefined("form.SPanonimo")>1<cfelse>0</cfif>,
					<cfif isdefined("form.SPpublico")>1<cfelse>0</cfif>,
					<cfif isdefined("form.SPinterno")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				   )
		</cfquery>
		
		<cfif LvarSPhomeuri NEQ "/">
			<cfquery name="rs" datasource="asp">
				insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, BMUsucodigo, BMfecha)
				values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSPhomeuri#">, 'P',
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
			</cfquery>
		</cfif>
		
		<cfset addMenu()>
		</cftransaction>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo#">
			<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo#">
		</cfinvoke>
	<cfelseif isdefined("form.btnCopiar")>
	<cftransaction>
		<cfquery name="rs" datasource="asp">
			insert into SProcesos ( SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, SPorden, SPlogo, SPhablada, SPanonimo, SPpublico, SPinterno, BMUsucodigo, BMfecha )
			select 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
				<cfif trim(form.SPdescripcion) EQ "Copiando...">
					SPdescripcion,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPdescripcion)#">,
				</cfif>
				<cfif trim(form.SPhomeuri) EQ "/">
					SPhomeuri,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPhomeuri)#">,
				</cfif>
					SPmenu, SPorden, SPlogo, SPhablada, SPanonimo, SPpublico, SPinterno, BMUsucodigo, BMfecha 
			  from SProcesos
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,1)#">
			   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,2)#">
			   and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,3)#">
		</cfquery>

		<cfquery name="rs" datasource="asp">
			insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, BMUsucodigo, BMfecha)
			select 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
					SCuri, SCtipo, BMUsucodigo, BMfecha
			  from SComponentes
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,1)#">
			   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,2)#">
			   and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,3)#">
		</cfquery>
		
		<cfquery datasource="asp">
			insert into SProcesosRol (SScodigo, SRcodigo, SMcodigo, SPcodigo, BMfecha, BMUsucodigo)
			select 	<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
					SRcodigo,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
					BMfecha, BMUsucodigo
			  from SProcesosRol
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,1)#">
			   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,2)#">
			   and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,3)#">
		</cfquery>

		<cfquery name="rs" datasource="asp">
			select SMNcodigo
			  from SMenues
			 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,1)#">
			   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,2)#">
			   and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#listGetAt(form.cboCopiar,3)#">
		</cfquery>

		<cfset form.SMNcodigo = rs.SMNcodigo>
		<cfset addMenu()>
		
		</cftransaction>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo#">
			<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo#">
		</cfinvoke>
	<cfelseif isdefined("form.Guardar")>
		<cfif LvarUri.NotExists EQ 2><cfthrow message="No existe la Pagina Inicial: #LvarSPhomeuri#"></cfif>
		<cfquery datasource="asp" name="roles">
				select SRcodigo from SProcesosRol
				where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				order by SRcodigo
			</cfquery>
			<cfloop query="roles">
				<cfif ListFind(form.SRcodigo, roles.SRcodigo) Is 0>
					<cfquery datasource="asp">
						delete from SProcesosRol
						where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
						  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
						  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
						  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#roles.SRcodigo#">
					</cfquery>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#ListLen(form.SRcodigo)#" index="i">
				<cfif ListFind(ValueList(roles.SRcodigo), ListGetAt(form.SRcodigo,i)) is 0>
					<cfquery datasource="asp">
						insert into SProcesosRol (SScodigo, SRcodigo, SMcodigo, SPcodigo, BMfecha, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#ListGetAt(form.SRcodigo,i)#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
				</cfif>
			</cfloop>
			<cftransaction>
			<cfquery name="rs" datasource="asp">
				update SProcesos
				set SPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPdescripcion)#">,
					SPhomeuri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SPhomeuri)#">,
					SPmenu = <cfif isdefined("form.SPmenu")>1<cfelse>0</cfif>,
			    	SPorden = <cfif len(trim(form.SPorden)) gt 0 ><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SPorden#"><cfelse>null</cfif>,
			    	<cfif Len(Trim(form.logo))>
				      SPlogo = <cf_dbupload filefield="logo" accept="image/*" datasource="asp">,
				    </cfif>
					SPhablada = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.SPhablada#">,
					SPanonimo = <cfif isdefined("form.SPanonimo")>1<cfelse>0</cfif>,
					SPpublico = <cfif isdefined("form.SPpublico")>1<cfelse>0</cfif>,
					SPinterno = <cfif isdefined("form.SPinterno")>1<cfelse>0</cfif>,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
			</cfquery>
			
			<cfif Trim(form.SPcodigo) neq Trim(form.SPcodigo2)>
				<cfquery name="rs" datasource="asp">
					insert into SProcesos 
						(SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, 
						BMfecha, BMUsucodigo, SPorden, SPhablada, SPlogo, SPanonimo, SPpublico, SPinterno)
					select
						SScodigo, SMcodigo, <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#"> SPcodigo,
						SPdescripcion, SPhomeuri, SPmenu, 
						BMfecha, BMUsucodigo, SPorden, SPhablada, SPlogo, SPanonimo, SPpublico, SPinterno
					from SProcesos
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
				
				<cfquery name="rs" datasource="asp">
					update SComponentes
					set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
				
				<cfquery name="rs" datasource="asp">
					update SProcesoRelacionado
					set SPorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SSorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
				
				<cfquery name="rs" datasource="asp">
					update SProcesoRelacionado
					set SPdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SSdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
				
				<cfquery name="rs" datasource="asp">
					update SProcesosRol
					set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>

				<cfquery name="rs" datasource="asp">
					update UsuarioProceso
					set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>

				<cfquery name="rs" datasource="asp">
					update SMenues
					set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>

				<cfquery name="rs" datasource="asp">
					update MSDominio
					set SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
				
				<cfquery name="rs" datasource="asp">
					delete from SProcesos
					where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
				</cfquery>
			</cfif>

			<cfif LvarSPhomeuri NEQ "/">
				<cfquery datasource="asp" name="exists1">
					select 1 from SComponentes
					where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
					  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
					  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
					  and SCuri    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSPhomeuri#">
				</cfquery>
				<cfif exists1.RecordCount Is 0>
					<cfquery name="rs" datasource="asp">
						insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, BMUsucodigo, BMfecha)
						values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSPhomeuri#">, 'P',
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
					</cfquery>
				</cfif>
			</cfif>
			</cftransaction>

			<cfif trim(form.SMNcodigo) neq trim(getMenuPadre())>
				<cfset delMenu()>
				<cfset addMenu()>
			</cfif>
			<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
				method="actualizar">
				<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
				<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo#">
				<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo#">
			</cfinvoke>
	<cfelseif isdefined("form.Eliminar")>
		<cftransaction>
		<cfquery name="rs" datasource="asp">
			delete from SProcesosRol
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from UsuarioProceso
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SMenues
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SRelacionado
			where id_padre in (select id_item
				from SMenuItem
				where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">)
			  or id_hijo in (select id_item
				from SMenuItem
				where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
				  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
				  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">)
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SMenuItem
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			update MSDominio
			set SPcodigo = null, SMcodigo = null, SScodigo = null
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SComponentes
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SProcesoRelacionado
			where SPorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SSorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SProcesoRelacionado
			where SPdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SSdestino = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery>
		<cfquery name="rs" datasource="asp">
			delete from SProcesos
			where SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo2#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		</cfquery></cftransaction>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar">
			<cfinvokeargument name="SScodigo" value="#Form.SScodigo#">
			<cfinvokeargument name="SMcodigo" value="#Form.SMcodigo#">
			<cfinvokeargument name="SPcodigo" value="#Form.SPcodigo2#">
		</cfinvoke>

		<cfelseif isdefined("form.AgregarRelacionado")>
			<cfset LvarPosicion = form.posicion >
			
			<cfset LvarOcultar = 0 >
			<cfif isdefined("form.ocultar")>
				<cfset LvarOcultar = 1 >
			</cfif>

			<cfset insertarRelacionado( form.SScodigo, form.SMcodigo, form.SPcodigo, form.SSdestino, form.SMdestino, form.SPdestino, LvarPosicion, LvarOcultar ) >
			<cfset resecuenciar(form.SScodigo, form.SMcodigo, form.SPcodigo) >
			
			<cfif isdefined("form.bidireccion")>
				<cfset insertarRelacionado( form.SSdestino, form.SMdestino, form.SPdestino, form.SScodigo, form.SMcodigo, form.SPcodigo, LvarPosicion, LvarOcultar ) >
				<cfset resecuenciar(form.SSdestino, form.SMdestino, form.SPdestino ) >
			</cfif>

		<cfelseif isdefined("form.ModificarRelacionado") >
			<cfif len(trim(form.posicion)) eq 0 >
				<cfquery name="dataPosicion" datasource="asp">
					select coalesce(max(posicion),0) as posicion
					from SProcesoRelacionado
					where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> 
					  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#"> 
					  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#"> 
				</cfquery>
				<cfset LvarPosicion = dataPosicion.posicion + 10 >	
			<cfelse>
				<cfset LvarPosicion = form.posicion >	
			</cfif>

			<cfquery datasource="asp">
				update SProcesoRelacionado
				set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPosicion#">,
				    ocultar = <cfif isdefined("form.ocultar")>1<cfelse>0</cfif>
				where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> 
				  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#"> 
				  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#"> 
				  and SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SSdestino#"> 
				  and SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMdestino#">
				  and SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPdestino#">
			</cfquery>
			<cfset resecuenciar(form.SScodigo, form.SMcodigo, form.SPcodigo) >

		<cfelseif isdefined("form.EliminarRelacionado") >
			<cfquery datasource="asp">
				delete from SProcesoRelacionado
				where SSorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#"> 
				  and SMorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#"> 
				  and SPorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPcodigo#"> 
				  and SSdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SSdestino#"> 
				  and SMdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMdestino#">
				  and SPdestino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SPdestino#">
			</cfquery>
			<cfset resecuenciar(form.SScodigo, form.SMcodigo, form.SPcodigo) >

	</cfif>

<cfoutput>
<form action="<cfif isdefined("form.componentes")>componentes.cfm<cfelse>procesos.cfm</cfif>" method="post" name="sql">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">

	<cfif not isdefined("form.componentes")>
		<cfif isdefined("form.fSScodigo")>
			<input type="hidden" name="fSScodigo" value="#Form.fSScodigo#">
		<cfelse>
			<input type="hidden" name="fSScodigo" value="#Form.SScodigo#">
		</cfif>
		<cfif isdefined("form.fSMcodigo")>
			<input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#">
		<cfelse>
			<input type="hidden" name="fSMcodigo" value="#Form.SMcodigo#">
		</cfif>
		<cfif not isdefined("form.Eliminar")>
			<input type="hidden" name="SScodigo" value="<cfif isdefined("form.SScodigo")>#Form.SScodigo#</cfif>">
			<input type="hidden" name="SMcodigo" value="<cfif isdefined("form.SMcodigo")>#form.SMcodigo#</cfif>">
			<input type="hidden" name="SPcodigo" value="<cfif isdefined("form.SPcodigo")>#form.SPcodigo#</cfif>">
		</cfif>
	<cfelse>
		<input type="hidden" name="fSScodigo" value="<cfif isdefined("form.fSScodigo")>#Form.fSScodigo#<cfelse>#form.SScodigo#</cfif>">
		<input type="hidden" name="fSMcodigo" value="<cfif isdefined("form.fSMcodigo")>#form.fSMcodigo#<cfelse>#form.SMcodigo#</cfif>">
		<input type="hidden" name="SScodigo" value="<cfif isdefined("form.SScodigo")>#Form.SScodigo#</cfif>">
		<input type="hidden" name="SMcodigo" value="<cfif isdefined("form.SMcodigo")>#form.SMcodigo#</cfif>">
		<input type="hidden" name="SPcodigo" value="<cfif isdefined("form.SPcodigo2")>#form.SPcodigo2#</cfif>">
	</cfif>
	

<cfif isdefined("Form.fProceso")>
	<input type="hidden" name="fProceso" value="#form.fProceso#">
</cfif>
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>