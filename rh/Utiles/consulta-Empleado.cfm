<!--- Consulta los datos de un empleado a partir de su codigo de Usuario --->
<!---  Se usa en Evalaución de Desempeño y Capacitacion y Desarrollo --->

<cfquery name="rsReferencia" datasource="asp">
	select llave
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
</cfquery>

<cfif len(trim(rsReferencia.llave)) eq 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa"
		Default="Usted no ha sido definido como empleado de la empresa"
		returnvariable="MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa"/>
	<cfthrow message="#MSG_UstedNoHaSidoDefinidoComoEmpleadoDeLaEmpresa# #session.Enombre#. ">
</cfif>

<cfquery datasource="#Session.DSN#" name="rsEmpleado">
	select a.DEid as DEid, 
		   a.Ecodigo as Ecodigo, 
		   a.Bid as Bid, 
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   a.DEnombre, 
		   a.DEapellido1, 
		   a.DEapellido2, 
		   case a.DEsexo 
		   		when 'M' then '<cf_translate key="LB_Masculino">Masculino</cf_translate>' 
				when 'F' then '<cf_translate key="LB_Femenino">Femenino</cf_translate>' 
				else '<cf_translate key="LB_ND">N/D</cf_translate>' end as Sexo,
		   a.CBTcodigo as CBTcodigo, 
		   a.DEcuenta, 
		   a.CBcc, 
		   a.DEdireccion, 
		   case a.DEcivil 
				when 0 then '<cf_translate key="LB_Soltero_a">Soltero(a)</cf_translate>' 
				when 1 then '<cf_translate key="LB_Casado_a">Casado(a)</cf_translate>' 
				when 2 then '<cf_translate key="LB_Divorciado_a">Divorciado(a)</cf_translate>' 
				when 3 then '<cf_translate key="LB_Viudo_a">Viudo(a)</cf_translate>' 
				when 4 then '<cf_translate key="LB_UnionLibre">Unión Libre</cf_translate>' 
				when 5 then '<cf_translate key="LB_Separado_a">Separado(a)</cf_translate>' 
				else '' 
		   end as EstadoCivil, 
		   a.DEfechanac as FechaNacimiento, 
		   a.DEcantdep, 
		   a.DEobs1, 
		   a.DEobs2, 
		   a.DEobs3, 
		   a.DEdato1, 
		   a.DEdato2, 
		   a.DEdato3, 
		   a.DEdato4, 
		   a.DEdato5, 
		   a.DEinfo1, 
		   a.DEinfo2, 
		   a.DEinfo3, 
		    a.Usucodigo as Usucodigo, 
		   a.Ulocalizacion, 
		   a.DEsistema, 
		   a.ts_rversion,
		   b.NTIdescripcion,
		   c.Mnombre,
		   coalesce(d.Bdescripcion, '<cf_translate key="LB_Ninguno">Ninguno</cf_translate>') as Bdescripcion
	from DatosEmpleado a
	inner join NTipoIdentificacion b
		on a.NTIcodigo = b.NTIcodigo
	left outer join Monedas c
		on a.Mcodigo = c.Mcodigo
	left outer join Bancos d
		on  a.Ecodigo = d.Ecodigo
		and a.Bid = d.Bid
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReferencia.llave#">
</cfquery>
