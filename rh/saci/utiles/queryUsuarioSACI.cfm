<!---
<cfif isdefined("url.pq") and Len(Trim(url.pq)) and isdefined("url.sufijo") and isdefined("url.conexion") and Len(Trim(url.conexion))>
--->


<cfif isdefined("url.pq") and Len(Trim(url.pq)) and isdefined("url.sufijo") and isdefined("url.conexion") and Len(Trim(url.conexion))>

	<!--- Instanciar el componente de seguridad --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset rsUsuario = sec.getUsuarioByRef(url.pq, Session.EcodigoSDC, 'ISBpersona')>
	<cfset ExisteUsuario = rsUsuario.recordCount GT 0>
	

		<cfif agente EQ '-1'>
			<cfquery name="rsPersona" datasource="#url.conexion#">
				select b.Pemail, 
				   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) 
				   else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido)		 || ' ' || b.Papellido2) end as NombreCompleto
				from ISBpersona b
				where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pq#">
			</cfquery>
		<cfelse>
			<cfquery name="rsPersona" datasource="#url.conexion#">
				select a.Pemail, 
	   					case when c.Ppersoneria = 'J' 
            			then rtrim(c.PrazonSocial) 
            			else rtrim(rtrim(c.Pnombre) || ' ' || rtrim(c.Papellido) || ' ' || c.Papellido2) end as NombreCompleto
				from ISBlocalizacion a
					inner join ISBagente b
				on a.RefId = b.AGid
			    	inner join ISBpersona c
				on b.Pquien = c.Pquien	
				where a.RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.agente#">
			</cfquery>
		</cfif>
		<!--- Si existe una cuenta se muestra el login de la tabla ISBlogin (servicio correo )--->
		<cfif isdefined("url.Pemail") and Len(url.Pemail)>
			<cfset rsPersona.Pemail = #url.Pemail#>
		</cfif>
<!---
		<cfquery name="rsPersona" datasource="#url.conexion#">
			select b.Pemail, 
				   case when b.Ppersoneria = 'J' then rtrim(b.PrazonSocial) else rtrim(rtrim(b.Pnombre) || ' ' || rtrim(b.Papellido)		 || ' ' || b.Papellido2) end as NombreCompleto
			from ISBpersona b
			where b.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pq#">
		</cfquery>
--->
	
	<cfoutput>
	<script language="JavaScript" type="text/javascript">
		window.parent.CargarValoresUsuario#url.sufijo#(
		
			<cfif ExisteUsuario>true<cfelse>false</cfif>,
			'#rsPersona.NombreCompleto#',
			'#rsPersona.Pemail#'

			<cfif ExisteUsuario>,'#rsUsuario.Usulogin#'</cfif>
		);
	</script>
	</cfoutput>

</cfif>
