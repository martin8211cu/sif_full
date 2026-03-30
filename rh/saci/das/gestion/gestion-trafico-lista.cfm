<cfoutput>
	<cfif isdefined("url.Consultar")>
		<!---Esta parte es especificamente para definir que valor viene en el combo si un id de login o un id de cuenta esto por que el combo tiene dos niveles: cuente y logines de la cuenta--->
		<cfif isdefined("url.F_LGnumero") and len(trim(url.F_LGnumero))>
			<cfif listLen(url.F_LGnumero,',') EQ 2>
				<cfset arr = ListToArray(url.F_LGnumero)>
				<cfset cuenta = arr[2]>
				<cfset url.F_LGnumero = arr[1]>
			<cfelseif listLen(url.F_LGnumero,',') EQ 1>
				<cfset cuenta = url.F_LGnumero>
				<cfset url.F_LGnumero="">			
			<cfelse>
				<cfset cuenta = "">
				<cfset url.F_LGnumero="">			
			</cfif>
		</cfif>
		<!---Fechas--->
		<cfset desde = "">
		<cfset hasta = "">
		<cfif isdefined("url.fdesde")and len(trim(url.fdesde))><cfset desde= url.fdesde> </cfif>
		<cfif isdefined("url.fhasta")and len(trim(url.fhasta))><cfset hasta= url.fhasta> </cfif>
		<!---Cuenta--->
		<cfset idcue = "">
		<cfif isdefined("cuenta")and len(trim(cuenta))> <cfset idcue= cuenta> </cfif>
		<!---Login--->
		<cfset iglog = "">
		<cfif isdefined("url.F_LGnumero")and len(trim(url.F_LGnumero))><cfset idlog= url.F_LGnumero> </cfif>
		<!---Nombre del login--->
		<cfset nomlog = "">
		<cfif isdefined("url.fLGlogin")and len(trim(url.fLGlogin))><cfset nomlog= url.fLGlogin> </cfif>
		<!---Telefono--->
		<cfset tel = "">
		<cfif isdefined("url.fEVtelefono")and len(trim(url.fEVtelefono))><cfset tel= url.fEVtelefono> </cfif>
		<!---Direccion IP--->
		<cfset ip = "">
		<cfif isdefined("url.fipaddr")and len(trim(url.fipaddr))><cfset ip= url.fipaddr> </cfif>
		<!---Tag que pinta la lista segun los filtros--->
		<cf_gestion-traficoList
			idcliente="#form.cliente#"
			f_idcuenta="#idcue#"
			f_idlogin="#iglog#"
			f_nomlogin="#nomlog#"
			f_fdesde="#desde#"
			f_fhasta="#hasta#"
			f_tel="#tel#"
			f_ip="#ip#"
			rol="#form.rol#"
		>
			
		<!---<cfif isdefined("url.F_LGnumero") and len(trim(url.F_LGnumero))>
				<cfif listLen(url.F_LGnumero,',') EQ 2>
					<cfset arr = ListToArray(url.F_LGnumero)>
					<cfset cuenta = arr[2]>
					<cfset url.F_LGnumero = arr[1]>
				<cfelseif listLen(url.F_LGnumero,',') EQ 1>
					<cfset cuenta = url.F_LGnumero>
					<cfset url.F_LGnumero="">			
				<cfelse>
					<cfset cuenta = "">
					<cfset url.F_LGnumero="">			
				</cfif>
			</cfif>
			
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select 	a.CTid,
						case a.CUECUE
						when 0 then '&lt;Por Asignar&gt;'
						else <cf_dbfunction name="to_char" args="a.CUECUE"> end as CUECUE,
						c.LGnumero,c.LGlogin
						,e.EVinicio
						,convert(varchar, floor(e.EVduracion / 3600)) || ':' || 
						 right('0' || convert(varchar, floor((e.EVduracion-(3600*floor(e.EVduracion / 3600))) / 60)), 2) || ':' || 
						 right('0' || convert(varchar, e.EVduracion-(3600*floor(e.EVduracion / 3600))-(60*floor((e.EVduracion-(3600*floor(e.EVduracion / 3600))) / 60))), 2) as EVduracion
						,e.EVtelefono
						,e.ipaddr
				from ISBcuenta a
					inner join ISBproducto b
						on b.CTid = a.CTid
					inner join ISBlogin c
						on c.Contratoid = b.Contratoid
						and c.Habilitado=1
					inner join ISBeventoLogin e
						on e.LGnumero = c.LGnumero
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
				and a.Habilitado=1
				<!---Filtro por fechas--->
				<cfif isdefined("url.fdesde")and len(trim(url.fdesde))>
					and e.EVinicio >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fdesde)#">
				</cfif>
				<cfif isdefined("url.fhasta")and len(trim(url.fhasta))>
					and e.EVinicio <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fhasta)#">
				</cfif>
				<!---Filtro por cuenta--->
				<cfif isdefined("cuenta")and len(trim(cuenta))>
					and a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuenta#">
				</cfif>
				<!---Filtro por login--->
				<cfif isdefined("url.F_LGnumero")and len(trim(url.F_LGnumero))>
					and c.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.F_LGnumero#">
				</cfif>
				<!---Filtro por nombre del login--->
				<cfif isdefined("url.fLGlogin")and len(trim(url.fLGlogin))>
					and upper(c.LGlogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.fLGlogin))#%">
				</cfif>
				<!---Filtro por telefono--->
				<cfif isdefined("url.fEVtelefono")and len(trim(url.fEVtelefono))>
					and upper(ltrim(rtrim(e.EVtelefono))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#ucase(trim(url.fEVtelefono))#%">
				</cfif>
				<!---Filtro por direccion IP--->
				<cfif isdefined("url.fipaddr")and len(trim(url.fipaddr))>
					and ltrim(rtrim(e.ipaddr)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(url.fipaddr)#%">
					<!---and ltrim(rtrim(e.ipaddr)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.fipaddr)#">--->
				</cfif> 
			</cfquery>
			<cfif rsConsulta.RecordCount gt 0>
				<cfinvoke  
					component="sif.Componentes.pListas" 
					method="pListaQuery">
					<cfinvokeargument name="query" value="#rsConsulta#"/>
					<cfinvokeargument name="desplegar" value="CUECUE,LGlogin,EVinicio,EVduracion,EVtelefono,ipaddr"/>
					<cfinvokeargument name="etiquetas" value="Cuenta,Login,Fecha,Duraci&oacute;n,Tel&eacute;fono,Direcci&oacute;n IP"/>
					<cfinvokeargument name="formName" value="lista"/>
					<cfinvokeargument name="align" value="left,left,left,left,left,left"/>
					<cfinvokeargument name="formatos" value="V,S,D,S,S,S"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="maxrows" value="18"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="Consultar=1&rol=#url.rol#&cli=#form.cliente#"/>
				</cfinvoke>
				
			<cfelse>
				<strong>----No hay datos disponibles----</strong>
			</cfif>--->
	</cfif>
</cfoutput>	
