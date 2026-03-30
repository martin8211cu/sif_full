<cfloop condition="true">
	<!--- por si la búsqueda no regresa usuarios --->
	<cfquery datasource="asp" name="filtro_usuario" maxrows="10">
		select top 10 Usucodigo, lower(Usulogin) as orden_Usulogin
		from Usuario
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
		<cfif Len(Trim(session.simple._buscar))>
		  and lower(Usulogin) like lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#Trim(session.simple._buscar)#%">)
		 </cfif>
		order by Usulogin, lower(Usulogin)
	</cfquery>
	<cfif filtro_usuario.RecordCount><cfbreak></cfif>
	<cfif Not Len(session.simple._buscar)><cfbreak></cfif>
	<cfset session.simple._buscar = ''>
</cfloop>
<cfquery datasource="asp" name="filtro_sistema">
	select SScodigo
	from ModulosCuentaE
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
</cfquery>
<cfquery datasource="asp" name="matriz">
	select
		u.Usucodigo,
		u.Usulogin,
		lower(u.Usulogin) as orden_Usulogin,
		rtrim (r.SScodigo) as SScodigo,
		rtrim (r.SRcodigo) as SRcodigo,
		ltrim (rtrim (r.SRdescripcion)) as SRdescripcion,
		lower (r.SRdescripcion) as orden_SRdescripcion,
		(select count(1) from UsuarioRol ur
		where ur.SScodigo  = r.SScodigo
		  and ur.SRcodigo  = r.SRcodigo
		  and ur.Usucodigo = u.Usucodigo
		  and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._emp#">) as existe
	from SRoles r left join Usuario u on 1=1
	where u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
	<cfif filtro_usuario.RecordCount>
	  and u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(filtro_usuario.Usucodigo)#" list="yes">)
	</cfif>	  
	  and r.SRinterno = 0
	 <cfif filtro_sistema.RecordCount>
	  and r.SScodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#ValueList(filtro_sistema.SScodigo)#" list="yes"> )
	 </cfif>
 	order by lower(u.Usulogin), u.Usulogin, r.SScodigo, lower (r.SRdescripcion), r.SRcodigo
</cfquery>

<table border="0" cellspacing="1" cellpadding="1" align="center" style="background-color:gray;cursor:pointer;" id="matriz">
<cfset row = 0>
	<cfoutput query="matriz" group="Usucodigo">
	<cfset row = row+1>
	<cfif CurrentRow is 1>
  <tr>
    <td class="listaPar">&nbsp;</td>
	<cfoutput group="SScodigo">
		<cfset colspan = 0>
		<cfoutput><cfset colspan = colspan+1></cfoutput>
		<cfif colspan>
		<td class="listaPar" align="center" colspan="#colspan#">#LCase(SScodigo)#&nbsp;</td>
		</cfif>
	</cfoutput>
	<td class="listaPar">&nbsp;</td>
  </tr>
  <tr>
    <cfset emptymsg = ' Buscar '>
   <td class="listaPar">
	<form action="javascript:void(0)" onsubmit="bsubmit(this,'#JSStringFormat(emptymsg)#')" style="margin:0">
	<input type="text" name="buscar"
		style="width:100%;<cfif Len(session.simple._buscar) is 0>color:gray;</cfif>border:1px solid black" value="<cfif Len(session.simple._buscar)>#HTMLEditFormat(session.simple._buscar)#<cfelse>#HTMLEditFormat(emptymsg)#</cfif>" 
		 onfocus="ufocus(this,'#JSStringFormat(emptymsg)#')" onblur="ublur(this,'#JSStringFormat(emptymsg)#')" /></form></td>
	<cfoutput>
	<td id="c#CurrentRow#" class="listaPar" align="center" width="20" valign="top" style="vertical-align:top">
	<cfif Compare( SRdescripcion , UCase(SRdescripcion)) is 0>
	#UCase(Left(SRdescripcion,1)) & LCase( Right(SRdescripcion,Len(SRdescripcion)-1))#<cfelse>#SRdescripcion#</cfif>&nbsp;</td>
	</cfoutput>
	<td class="listaPar">&nbsp;</td>
  </tr></cfif>
  <tr>
    <td id="r#row#" class="listaPar">
	<table width="100%" border="0"><tr><td>#Usulogin#&nbsp;</td><td align="right">
		<a href="javascript:void(editUser('#JSStringFormat(Usucodigo)#'))">Edit</a></td></tr></table></td>
	<cfset col= 0>
	<cfoutput>
	<cfset col = col+1>
	<td class="listaNon" id="r#row#c#col#" valign="top" align="center" onmouseover="om1(this)" onmouseout="om2(this)" 
		onclick="oc(this,'#JSStringFormat(Usucodigo)#','#JSStringFormat(SScodigo)
			#','#JSStringFormat(SRcodigo)#')">
		<img id="img_r#row#c#col#" border="0" src="/cfmx/asp/admin/empresa/permiso/<cfif existe>simple-check.gif<cfelse>blank.gif</cfif>" 
		width="18" height="15" />
	</td>
	</cfoutput>
	<td class="listaNon">
	<div class="btnEliminar" onclick="du('#JSStringFormat(Usulogin)#','#JSStringFormat(Usucodigo)#')">[Borrar]</div>
	</td>
  </tr>
  </cfoutput>
</table>