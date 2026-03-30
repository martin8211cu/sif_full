<cfparam name="url.ctaemp" type="string" default="">
<cfparam name="url.s_login" type="string" default="">
<cfparam name="url.s_nombre" type="string" default="">
<cfparam name="url.s_email" type="string" default="">


<cf_templateheader title="Cambiar Login a Usuarios"><cf_web_portlet_start titulo="Cambiar Login a Usuarios">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfquery datasource="asp" name="ctaemp">
	select CEcodigo, CEnombre , CEaliaslogin, 
		upper(
			case when CEaliaslogin is null or CEaliaslogin = '' or CEaliaslogin = ' '
				then CEnombre
				else CEaliaslogin
			end ) as ordenamiento
	from CuentaEmpresarial
	order by ordenamiento
</cfquery>

<cfif isDefined('url.b')>

<cfquery datasource="asp" name="usuario"> 
	select c.CEnombre, c.CEcodigo,
		u.Usucodigo, u.Usulogin, p.Pnombre, p.Papellido1, p.Papellido2,
		p.Pemail1
		
		<cfif isdefined("url.ctaemp") and len(trim(url.ctaemp)) >, '#url.ctaemp#' as ctaemp</cfif>
		<cfif isdefined("url.s_login") and len(trim(url.s_login)) >, '#url.s_login#' as s_login</cfif>
		<cfif isdefined("url.s_nombre") and len(trim(url.s_nombre)) >, '#url.s_nombre#' as s_nombre</cfif>				
		<cfif isdefined("url.s_email") and len(trim(url.s_email)) >, '#url.s_email#' as s_email</cfif>		
		<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) >, '#url.pageNum_lista#' as pageNum_lista</cfif>		
		
	from Usuario u
		join DatosPersonales p
			on u.datos_personales = p.datos_personales
		join CuentaEmpresarial c
			on c.CEcodigo = u.CEcodigo
	where u.Usucodigo != 1 <!--- proteger a pso --->
	<cfif Len(url.ctaemp)>
	  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctaemp#">
	</cfif>
	<cfif Len(Trim(url.s_login)) or Len(Trim(url.s_nombre)) or Len(Trim(url.s_email))>
		and ( 0 = 1  <!--- sintaxis para concatenar varios OR --->
			<cfif Len(Trim(url.s_login))>
				or upper(Usulogin)   like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.s_login))#%">
			</cfif>
			<cfif Len(Trim(url.s_nombre))>
				or upper(Pnombre)    like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.s_nombre))#%">
				or upper(Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.s_nombre))#%">
				or upper(Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.s_nombre))#%">
			</cfif>
			<cfif Len(Trim(url.s_email))>
				or upper(Pemail1)    like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(url.s_email))#%">
			</cfif>
		)
	</cfif>		
	order by c.CEnombre, u.Usulogin
</cfquery>
</cfif>

<cfoutput>
<form name="form1" id="form1" method="get" action="index.cfm">

<table width="636" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="55">&nbsp;</td>
    <td width="138">&nbsp;</td>
    <td width="386">&nbsp;</td>
    <td width="57">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" class="subTitulo">Cambiar Login a Usuarios</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">Indique el usuario al que desea cambiar el login</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Cuenta Empresarial </td>
    <td><select name="ctaemp">
	<option value=""> - Seleccione -</option>
	<cfloop query="ctaemp">
		<option value="#CEcodigo#" <cfif ctaemp.CEcodigo is url.ctaemp>selected</cfif>>
		<cfif Len(Trim(CEaliaslogin))>
		#HTMLEditFormat(Trim(CEaliaslogin))# - </cfif>#HTMLEditFormat(CEnombre)#</option>
	</cfloop>
	</select></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Login</td>
    <td><input type="text" name="s_login" id="s_login" value="#HTMLEditFormat(url.s_login)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Nombre</td>
    <td><input type="text" name="s_nombre" id="s_nombre" value="#HTMLEditFormat(url.s_nombre)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>E-mail</td>
    <td><input type="text" name="s_email" id="s_email" value="#HTMLEditFormat(url.s_email)#" onFocus="this.select()"></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" value="Buscar" name="b"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
</table>
</form>
</cfoutput>

<cfif isDefined('url.b')>
	<cfif usuario.RecordCount>
		<strong>Seleccione el usuario que desea renombrar.</strong>
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			query="#usuario#"
			desplegar="CEnombre,Usulogin,Pnombre,Papellido1,Papellido2,Pemail1"
			etiquetas="Cuenta,Login,Nombre,Apellidos, ,e-mail"
			formatos="V, V, V, V, V, V"
			align="left, left, left, left, left, left"
			ajustar="N"
			Nuevo=""
			form_method="get"
			irA="rename.cfm"
			showEmptyListMsg="true"
			keys="Usucodigo,CEcodigo">
		</cfinvoke>
	<cfelse>
		<strong>No se encontraron usuarios.  Por favor repita la b&uacute;squeda.</strong>
	
	</cfif>
	
</cfif>
<cf_web_portlet_end>
<cf_templatefooter>
