<!---
	Se realizo la siguente modificacion se cambio la referencia a la tabla  UsuarioProceso 
	por vUsuarioProcesos ya que solo estaba tomando encuenta los usuarios que tienian procesos
	asociados y no tomaba en cuenta los usarios que solo tenia asociados roles.
	modificacion realiza por Gustavo Gutierrez

este es el query que tenia anteriormente

		select c.Usucodigo,
			'00' as Ulocalizacion,
			c.Usulogin, 
			d.Papellido1 || ' ' || d.Papellido2 || ' ' || d.Pnombre as Usunombre
		from Usuario c
			inner join DatosPersonales d
			on d.datos_personales = c.datos_personales
		where c.Usulogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Url.Usulogin#">
			and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and c.Utemporal = 0
			and c.Uestado = 1
			<cfif isdefined("Url.quitar") and Url.quitar NEQ ''>
				and c.Usucodigo not in (#Form.quitar#)
			</cfif>
			order by c.Usulogin

--->
		

<cfif isdefined("Url.Usulogin") and Len(Trim(Url.Usulogin)) and isdefined("Url.Ecodigo") and Len(Trim(Url.Ecodigo)) and isdefined("Url.roles") and Len(Trim(Url.roles))>	<cfset filtro = "">
	<cfquery name="rsUsuario" datasource="asp">
		select distinct a.Usucodigo, '00' as Ulocalizacion,
		 a.Usulogin, 
		  {fn concat({fn concat({fn concat({fn concat(e.Papellido1 , ' ' )}, e.Papellido2 )}, ', ' )}, e.Pnombre )} 	
		 		 as Usunombre
		from Usuario a 
			inner join DatosPersonales e
				on a.datos_personales = e.datos_personales  
			inner join Empresa d
				on  d.Ereferencia =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			inner join vUsuarioProcesos b
				on  a.Usucodigo = b.Usucodigo
				and d.Ecodigo = b.Ecodigo 
		where a.Utemporal = 0  
		and a.Uestado = 1
		and a.Usulogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Url.Usulogin#">
		<cfif isdefined("Url.quitar") and Url.quitar NEQ ''>
			and a.Usucodigo not in (#Url.quitar#)
		</cfif>
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctl1.value = "";
		parent.ctl2.value = "";
		parent.ctl3.value = "";
		parent.ctl4.value = "";

		parent.ctl1.value = "<cfoutput>#rsUsuario.Usucodigo#</cfoutput>";
		parent.ctl2.value = "<cfoutput>#rsUsuario.Ulocalizacion#</cfoutput>";
		parent.ctl3.value = "<cfoutput>#rsUsuario.Usulogin#</cfoutput>";
		parent.ctl4.value = "<cfoutput>#rsUsuario.Usunombre#</cfoutput>";
	</script>
</cfif>
