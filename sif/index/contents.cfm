<!--- 
	Consulta Opciones del usuario logueado en SDC...
--->
<cfquery name="rsContents" datasource="SDC" >
	select 
	  st.nombre as STdescripcion,
	  s.nombre as Snombre,
	  s.descripcion as Sdescripcion, s.snapshot_uri as Simagen,
	  s.servicio as Scodigo, st.sistema as STcodigo, s.home_tipo as Stipo, s.home_uri as Suri
	from Servicios s, Modulo m, Sistema st
	where s.home = 1
	  and s.activo = 1
  	  and s.home_tipo = 'C'
	  and m.sistema = st.sistema
	  and s.modulo = m.modulo
	  and s.servicio in (
	  select distinct sr.servicio
	  from UsuarioPermiso ur, ServiciosRol sr
	  where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		and ur.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		and (sr.rol = ur.rol or sr.rol = 'sys.public'))
	  and ((agregacion = '2' and not exists (select * from ServicioOpcional us1
		where us1.servicio = s.servicio
		  and us1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and us1.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		  and us1.incluir = 0))
	   or (agregacion = '0' and exists (select * from ServicioOpcional us1
		where us1.servicio = s.servicio
		  and us1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		  and us1.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		  and us1.incluir = 1))
	   or (agregacion = '1'))
	order by st.orden, st.sistema, m.orden, m.nombre, s.orden, s.nombre	
</cfquery>
<!--- 
	Calcula la mitad de la lista para partir el pintado de las opciones en dos columnas...
--->
<cfset cuantos = round(rsContents.Recordcount / 2)>
<cfset CurrentSTcodigo = "">
<cfset cuantosg = ArrayNew(1)>
<cfset index = 0>
<cfloop query="rsContents">
	<cfif CurrentSTcodigo neq rsContents.STcodigo>
		<cfset CurrentSTcodigo = rsContents.STcodigo>
		<cfset index = index + 1>
		<cfset cuantosg[index] = rsContents.CurrentRow>
	<cfelse>
		<cfset cuantosg[index] = rsContents.CurrentRow>
	</cfif>
</cfloop>
<!---
	Función para convertir la dirección del sanapshot antiguo a la nueva dirección en Sif.
--->
<cfscript>
function SnapshotConvert(uri) {
		return 'snapshots/' & LCase(REReplaceNoCase(REReplaceNoCase(uri,'/','_','all'),'.jsp','.cfm'));
}
</cfscript>
<!---
	Inicia el pintado de las columnas...
--->
<cfset cualg="1">
<cfset CurrentSTcodigo = "">
<cf_templatecss>
<style>
	.chead {
		font-size: 100%;
		font-weight: bold;
		color: #C77A47;
	}
	.ctitle {
		font-size: x-small;
		font-weight: bold;
		text-decoration: underline;
	}
</style>

<cfif rsContents.RecordCount gt 1 >
<table border="0" width="100%">
	<tr>
	<td valign="top" align="center" height="50%"> <!-- primera columna de servicios --->
		
		<table border="0" cellpadding="4" cellspacing="4">
		<cfoutput query = "rsContents">
			<cfif CurrentSTcodigo neq rsContents.STcodigo>
				<cfif cuantos neq -1 and (cuantosg[cualg] gt cuantos or rsContents.CurrentRow gt rsContents.RecordCount / 2 )>
					<cfset cualg="1">
					<cfset cuantos="-1">
					</table></td><td valign="top" align="center" height="50%"> <!--- segunda columna de servicios --->
					<table border="0" cellpadding="4" cellspacing="4">
				</cfif>
				<cfset CurrentSTcodigo = rsContents.STcodigo>
				<cfset cualg = cualg + 1>
				<tr><td class="#Session.Preferences.Skin#_thcenter">#rsContents.STdescripcion#</td></tr>
			</cfif>
			<tr><td>
			<cfif rsContents.Stipo eq 'D'>
				<cfset uri = '##'>
			<cfelseif rsContents.Stipo eq 'C'>
				<cfset uri = '/cfmx' & rsContents.Suri>
			<cfelse>
				<cfset uri = '##'>
			</cfif>
			<cfif len(trim(rsContents.Simagen)) eq 0 or rsContents.Simagen eq 'NO'>
				<span class="ctitle">
				<a class="ctitle" href="#uri#">#rsContents.Snombre#</a><br>
				</span>&nbsp;#rsContents.Sdescripcion#
			<cfelse>
				<cf_web_portlet title=#rsContents.Snombre# border="false">
					<cftry>
						<cfinclude template="#SnapshotConvert(rsContents.Simagen)#">
					<cfcatch>
						<span class="ctitle">
						<a class="ctitle" href="#uri#">#rsContents.Snombre#</a><br>
						</span>&nbsp;#rsContents.Sdescripcion#
					</cfcatch>
					</cftry>
				</cf_web_portlet>
			</cfif>
			</td></tr>
		</cfoutput>
		</table>
		
</td></tr></table>
<cfelseif rsContents.RecordCount eq 1>
	<cflocation url="/cfmx#rsContents.Suri#">
<cfelseif rsContents.RecordCount eq 0>
	<cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n proceso </cfoutput>
</cfif>