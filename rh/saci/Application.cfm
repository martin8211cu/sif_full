<cfinclude template="/Application.cfm"><cfsilent>

	<cfparam name="session.saci.pais" default="">
	
	<!--- En caso de que sea un usuario autenticado --->
	<cfif Session.Usucodigo NEQ 0>
		<!--- Llenado de datos de uso general para SACI --->
		<cfif not isdefined("session.EcodigoAnterior")>
			<cfset session.EcodigoAnterior = '' >
		</cfif>
		<cfif session.Ecodigo neq session.EcodigoAnterior>
		
			<!--- Averiguar el país de la empresa --->
			<cfquery name="rsPais" datasource="#Session.DSN#">
				select b.Ppais
				from Empresa a
					inner join Direcciones b
						on b.id_direccion = a.id_direccion
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			</cfquery>
			<cfif rsPais.recordCount>
				<cfset session.saci.pais = rsPais.Ppais>
			</cfif>
		
			<!--- Componente de Seguridad para Usuarios --->
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	
			<cfset session.saci.diccionario = '/saci/utiles/diccionario.xml'>
			<cfset session.saci.persona = StructNew()>
			<cfset session.saci.persona.id = '0'>
			<cfset session.saci.vendedor = StructNew()>
			<cfset session.saci.vendedor.id = '0'>
			<cfset session.saci.vendedor.agentes = '0'>
			<cfset session.saci.vendedor.interno = '0'>
			<cfset session.saci.agente = StructNew()>
			<cfset session.saci.agente.id = '0'>
	
			<cfset _persona = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'ISBpersona')>
			<cfif _persona.recordCount gt 0 and len(trim(_persona.llave))>
				<cfset session.saci.persona.id = _persona.llave>
			</cfif>
	
			<cfset _vendedor = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'ISBvendedor')>
			<!--- Averiguar si es un vendedor --->
			<cfif _vendedor.recordCount gt 0 and len(trim(_vendedor.llave))>
				<cfquery name="rsVendedor" datasource="#session.DSN#">
					select a.Vid, a.Pquien, a.AGid, a.Vprincipal, b.AAinterno
					from ISBvendedor a
						inner join ISBagente b
							on b.AGid = a.AGid
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					where a.Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_vendedor.llave#">
					and a.Habilitado = 1
				</cfquery>
	
				<cfif rsVendedor.recordCount gt 0>
					<cfset session.saci.vendedor.id = rsVendedor.Vid>
					<cfset session.saci.vendedor.agentes = ValueList(rsVendedor.AGid,',')>
					<cfset session.saci.vendedor.interno = rsVendedor.AAinterno>
				</cfif>
			</cfif>
	
			<cfset _agente = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'ISBagente')>
			<!--- Averiguar si es un agente --->
			<cfif _agente.recordCount gt 0 and len(trim(_agente.llave))>
				<cfset session.saci.agente.id = _agente.llave>
			</cfif>
			
			<!--- Establecer el EcodigoAnterior hasta el final, por si algo dio error --->
			<cfset session.EcodigoAnterior = session.Ecodigo>
			
		</cfif>
	</cfif>
</cfsilent>