<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<!--- Se utiliza cuando el que consulta es el empleado --->
<cfif Session.Params.ModoDespliegue EQ 0>

	<cfquery name="rsReferencia" datasource="asp">
		select llave
		from UsuarioReferencia
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
	</cfquery>
	
	<cfif rsReferencia.recordCount GT 0>
	
		<cfquery datasource="#Session.DSN#" name="rsEmpleado">
			select a.DEid,
				   a.Ecodigo,
				   a.Bid,
				   a.NTIcodigo, 
				   a.DEidentificacion, 
				   a.DEnombre, 
				   a.DEapellido1, 
				   a.DEapellido2, 
				   case a.DEsexo when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>' 
				   				 when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>' 
								 else 'N/D' 
				   end as Sexo,
				   a.CBTcodigo,
				   a.DEcuenta, 
				   a.CBcc, 
				   a.DEdireccion, 
				   case a.DEcivil 
						when 0 then '<cf_translate key="LB_Soltero">Soltero(a)</cf_translate>' 
						when 1 then '<cf_translate key="LB_Casado">Casado(a)</cf_translate>' 
						when 2 then '<cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate>' 
						when 3 then '<cf_translate key="LB_Viudo">Viudo(a)</cf_translate>' 
						when 4 then '<cf_translate key="LB_UnionLibre">Unión Libre</cf_translate>' 
						when 5 then '<cf_translate key="LB_Separado">Separado(a)</cf_translate>' 
						else '' 
				   end as EstadoCivil, 
				   a.DEfechanac as FechaNacimiento, 
				   a.DEcantdep, 
				   a.DEobs1, 
				   a.DEobs2, 
				   a.DEobs3,
				   a.DEobs4,
				   a.DEobs5, 
				   a.DEdato1, 
				   a.DEdato2, 
				   a.DEdato3, 
				   a.DEdato4, 
				   a.DEdato5,
				   a.DEdato6,
				   a.DEdato7, 
				   a.DEinfo1, 
				   a.DEinfo2, 
				   a.DEinfo3,
				   a.DEinfo4,
				   a.DEinfo5, 
				   #Session.Usucodigo# as Usucodigo, 
				   a.Ulocalizacion, 
				   a.DEsistema, 
				   a.ts_rversion,
				   b.NTIdescripcion,
				   c.Mnombre,
				   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno">Ninguno</cf_translate>') as Bdescripcion,
				   coalesce(a.DEporcAnticipo,0.00) as DEporcAnticipo
			
			from DatosEmpleado a
				inner join NTipoIdentificacion b
					on a.NTIcodigo = b.NTIcodigo
				inner join Monedas c
					on a.Mcodigo = c.Mcodigo
				left outer join Bancos d
					on a.Ecodigo = d.Ecodigo
					and a.Bid = d.Bid
			
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#">
		</cfquery>
		
		<cfquery datasource="#Session.DSN#" name="rsDependientes">
			select count(*) as DEcantdep
			from FEmpleado a
				inner join RHParentesco b
					on a.Pid = b.Pid	
				inner join NTipoIdentificacion c
					on a.NTIcodigo = c.NTIcodigo
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#"> 
				and a.FEdeducrenta = 0
		</cfquery>
		
	<cfelse>
		<cfinvoke 
			component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"
			Default="El usuario con el que está ingresando, no es un empleado"
			returnvariable="MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado"/>	
	
		<cfthrow detail="#MSG_ElUsuarioConElQueEstaIngresandoNoEsUnEmpleado#">
	</cfif>
		
<!--- Se utiliza cuando el que consulta es el administrador --->
<cfelseif Session.Params.ModoDespliegue EQ 1>

	<cfif isdefined("Form.DEid")>
	
		<cfquery name="rsReferencia" datasource="asp">
			select coalesce(Usucodigo,-1) as Usucodigo
			from UsuarioReferencia
			where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
		</cfquery>
		
		<cfif rsReferencia.recordCount EQ 0>
			<cfset Usucodigo = -1>
		<cfelse>
			<cfset Usucodigo = rsReferencia.Usucodigo>
		</cfif>
		
		<!--- <cfif rsReferencia.RecordCount GT 0> --->
		<cfquery datasource="#Session.DSN#" name="rsEmpleado">
			select a.DEid,
				   a.Ecodigo,
				   a.Bid,
				   a.NTIcodigo, 
				   a.DEidentificacion, 
				   a.DEnombre, 
				   a.DEapellido1, 
				   a.DEapellido2, 
				   case a.DEsexo when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>' 
								 when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>' 
								 else 'N/D' 
				   end as Sexo,
				   a.CBTcodigo, 
				   a.DEcuenta, 
				   a.CBcc, 
				   a.DEdireccion, 
				   case a.DEcivil 
						when 0 then '<cf_translate key="LB_Soltero">Soltero(a)</cf_translate>' 
						when 1 then '<cf_translate key="LB_Casado">Casado(a)</cf_translate>' 
						when 2 then '<cf_translate key="LB_Divorciado">Divorciado(a)</cf_translate>' 
						when 3 then '<cf_translate key="LB_Viudo">Viudo(a)</cf_translate>' 
						when 4 then '<cf_translate key="LB_UnionLibre">Unión Libre</cf_translate>' 
						when 5 then '<cf_translate key="LB_Separado">Separado(a)</cf_translate>' 
						else '' 
				   end as EstadoCivil, 
				   a.DEfechanac as FechaNacimiento, 
				   a.DEcantdep, 
				   a.DEobs1, 
				   a.DEobs2, 
				   a.DEobs3,
				   a.DEobs4, 
				   a.DEobs5,  
				   a.DEdato1, 
				   a.DEdato2, 
				   a.DEdato3, 
				   a.DEdato4, 
				   a.DEdato5,
				   a.DEdato6,
				   a.DEdato7, 
				   a.DEinfo1, 
				   a.DEinfo2, 
				   a.DEinfo3,
				   a.DEinfo4,
				   a.DEinfo5, 
				   #Usucodigo# as Usucodigo, 
				   a.Ulocalizacion, 
				   a.DEsistema, 
				   a.ts_rversion,
				   b.NTIdescripcion,
				   c.Mnombre,
				   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno">Ninguno</cf_translate>') as Bdescripcion,	
				   coalesce(a.DEporcAnticipo,0.00) as DEporcAnticipo
			from DatosEmpleado a
				inner join NTipoIdentificacion b
					on a.NTIcodigo = b.NTIcodigo				
				inner join Monedas c
					on a.Mcodigo = c.Mcodigo
				left outer join Bancos d
					on a.Ecodigo = d.Ecodigo
					and a.Bid = d.Bid

			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
		
		<cfquery datasource="#Session.DSN#" name="rsDependientes">
			select count(*) as DEcantdep
			from FEmpleado a
				inner join RHParentesco b
					on a.Pid = b.Pid	
				inner join NTipoIdentificacion c
					on a.NTIcodigo = c.NTIcodigo
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> 
				and a.FEdeducrenta = 0
		</cfquery>

		<!---
		<cfelse>
			<cfinvoke 
				component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEmpleadoSeleccionadoNoTieneUnUsuarioCorrespondiente"
				Default="El empleado seleccionado no tiene un usuario correspondiente"
				returnvariable="MSG_ElEmpleadoSeleccionadoNoTieneUnUsuarioCorrespondiente"/>
					
			<cfthrow detail="#MSG_ElEmpleadoSeleccionadoNoTieneUnUsuarioCorrespondiente#">
		</cfif>
		--->
	</cfif>
</cfif>