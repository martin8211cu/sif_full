<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<cfparam name="url.tipo_objeto" type="string">
<cfparam name="url.id_objeto" type="numeric">
<cfparam name="url.items" type="string">
<cfparam name="url.buscar" default="">

<cfset url.items = ''>

<cfquery datasource="#session.tramites.dsn#" name="tipoinst">
	select id_tipoinst, nombre_tipoinst
	from TPTipoInst
	where id_tipoinst not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'T')
	order by nombre_tipoinst
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="inst">
	select id_inst, nombre_inst
	from TPInstitucion
	where id_inst not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'I')
	order by nombre_inst
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="grupos">
	select i.nombre_inst, i.id_inst, g.id_grupo, g.nombre_grupo
	from TPInstitucion i join TPGrupo g
		on i.id_inst = g.id_inst
	where g.id_grupo not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'G')
	order by i.nombre_inst, i.id_inst, g.nombre_grupo
</cfquery>


<cfquery datasource="#session.tramites.dsn#" name="permisos">
	select p.tipo_sujeto, p.id_sujeto,
		p.puede_capturar, p.puede_revisar, p.puede_modificar, p.items_ok,
		case p.tipo_sujeto 
			when 'F' then fp.nombre || ' ' || fp.apellido1 || ' (' || fi.nombre_inst || ')'
			when 'I' then i.nombre_inst
			when 'G' then g.nombre_grupo || ' (' || gi.nombre_inst || ')'
			when 'T' then ti.nombre_tipoinst
			else p.tipo_sujeto || ' ' || convert (varchar, p.id_sujeto)
		end as nombre_sujeto
	from TPPermiso p
		left join TPFuncionario f
			on p.tipo_sujeto = 'F'
			and p.id_sujeto = f.id_funcionario
			left join TPPersona fp
				on fp.id_persona = f.id_persona
			left join TPInstitucion fi
				on fi.id_inst = f.id_inst
		left join TPInstitucion i
			on p.tipo_sujeto = 'I'
			and p.id_sujeto = i.id_inst
		left join TPGrupo g
			on p.tipo_sujeto = 'G'
			and p.id_sujeto = g.id_grupo
			left join TPInstitucion gi
				on gi.id_inst = g.id_inst
		left join TPTipoInst ti
			on p.tipo_sujeto = 'T'
			and p.id_sujeto = ti.id_tipoinst
	where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
	  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
</cfquery>

<cfif len(url.buscar)>
<cfquery datasource="#session.tramites.dsn#" name="buscar">
	select
		'F' as tipo_sujeto,
		f.id_funcionario as id_sujeto,
		fp.identificacion_persona as codigo_sujeto,
		fp.nombre || ' ' || fp.apellido1 || ' (' || fi.nombre_inst || ')' as nombre_sujeto 
	from TPFuncionario f
			left join TPPersona fp
				on fp.id_persona = f.id_persona
			left join TPInstitucion fi
				on fi.id_inst = f.id_inst
	where (upper(fp.nombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.buscar)#%">
	   or upper(fp.apellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.buscar)#%">)
	  and f.id_funcionario not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'F')

	/*+*/ UNION /*+*/
	select
		'I' as tipo_sujeto,
		i.id_inst as id_sujeto,
		i.codigo_inst as codigo_sujeto,
		i.nombre_inst as nombre_sujeto
	from TPInstitucion i
	where upper(i.nombre_inst) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.buscar)#%">
	  and i.id_inst not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'I')
	
	/*+*/ UNION /*+*/
	
	select
		'G' as tipo_sujeto,
		g.id_grupo,
		g.codigo_grupo as codigo_sujeto,
		g.nombre_grupo
	from TPGrupo g
	where upper(g.nombre_grupo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.buscar)#%">
	  and g.id_grupo not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'G')

	/*+*/ UNION /*+*/
	
	select
		'T' as tipo_sujeto,
		ti.id_tipoinst as id_sujeto,
		ti.codigo_tipoinst as codigo_sujeto,
		ti.nombre_tipoinst as nombre_sujeto
	from TPTipoInst ti
	where upper(ti.nombre_tipoinst) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.buscar)#%">
	  and ti.id_tipoinst not in (
	  	select id_sujeto from TPPermiso
		where tipo_objeto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tipo_objeto#">
		  and id_objeto   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_objeto#">
		  and tipo_sujeto = 'T')
	
	order by tipo_sujeto, codigo_sujeto, nombre_sujeto
</cfquery>
</cfif>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<title>Permisos</title>
</head>

<body style="margin:0">
<cfoutput>
<form name="form1" action="javascript:void(0)" method="get" style="margin:0">
<table border="0" cellpadding="4" cellspacing="0" width="100%"
	style="border:1px solid black">
  <tr bgcolor="##CCCCCC">
    <td colspan="3" rowspan="2" valign="bottom"
		style="border-bottom:1px solid black;border-right:1px solid black;">Usuarios o Grupos con acceso </td>
    <td colspan="3" align="center" valign="bottom"
		style="border-bottom:1px solid black;">Registro</td>
	<cfif Len(url.items)>
    <td colspan="#ListLen(url.items)#" align="center" valign="bottom"
		style="border-bottom:1px solid black;border-left:1px solid black;">Administraci&oacute;n</td>
	</cfif>
  </tr>
  <tr>
    <td align="center" valign="bottom" bgcolor="##CCCCCC"
		style="border-bottom:1px solid black;border-right:1px solid black;">Capturar</td>
    <td align="center" valign="bottom" bgcolor="##CCCCCC"
		style="border-bottom:1px solid black;">Revisar</td>
    <td align="center" valign="bottom" bgcolor="##CCCCCC"
		style="border-bottom:1px solid black;border-left:1px solid black;">Modificar</td>
	<cfloop list="#url.items#" index="item">
		<cfset item_code=ListFirst(item,"-")>
		<cfset item_name=ListRest(item,"-")>
		<td align="center" valign="bottom" bgcolor="##CCCCCC"
			style="border-bottom:1px solid black;border-left:1px solid black;">#HTMLEditFormat(item_name)#</td>
	</cfloop>
  </tr>
  <cfif permisos.RecordCount EQ 0>
  <tr>
  	<td colspan="#ListLen(url.items)+6#">No se han definido Permisos.  Eso significa que el acceso
				no se ha asignado.
	</td>
  </tr>
  </cfif>
  <cfloop query="permisos">
  <tr>
    <td valign="top">
		<a href="javascript:borrar_sujeto('#tipo_sujeto#','#id_sujeto#')">
		<img src="../images/Borrar01_S.gif" width="20" height="18" border="0">
		</a>
	 </td>
    <td valign="top">
		<cfif tipo_sujeto eq 'F'>
		 <img src="../images/usuario.jpg" width="16" height="16">
		<cfelseif tipo_sujeto eq 'G'>
		 <img src="../images/grupo.gif" width="14" height="18">
		</cfif>
	</td>
    <td valign="top">
		#HTMLEditFormat(nombre_sujeto)#
	</td>
    <td align="center" valign="top"><input type="checkbox" name="chk_#tipo_sujeto#_#id_sujeto#__CAP" value="1" 
		onchange="save_check('#tipo_sujeto#','#id_sujeto#')" <cfif puede_capturar>checked</cfif>></td>
    <td align="center" valign="top"><input type="checkbox" name="chk_#tipo_sujeto#_#id_sujeto#__REV" value="1"
		onchange="save_check('#tipo_sujeto#','#id_sujeto#')" <cfif puede_revisar>checked</cfif>></td>
    <td align="center" valign="top"><input type="checkbox" name="chk_#tipo_sujeto#_#id_sujeto#__MOD" value="1"
		onchange="save_check('#tipo_sujeto#','#id_sujeto#')" <cfif puede_modificar>checked</cfif>></td>
	<cfloop list="#url.items#" index="item">
		<cfset item_code=ListFirst(item,"-")>
		<cfset item_name=ListRest(item,"-")>
	    <td align="center" valign="top">
			<input type="checkbox" name="chk_#tipo_sujeto#_#id_sujeto#__ITM" value="#item_code#"
				onchange="save_check('#tipo_sujeto#','#id_sujeto#')" 
				<cfif ListFind(items_ok, item_code)>checked</cfif>
			></td>
	</cfloop>
  </tr>
  </cfloop>
  </table>
  </form>
  <table border="0" cellpadding="4" cellspacing="0" width="100%"
	style="border:1px solid black">
  <tr>
    <td colspan="#ListLen(url.items)+6#" bgcolor="##CCCCCC">Agregar Funcionario</td>
  </tr>
  <tr>
    <td colspan="#ListLen(url.items)+6#">
	<form style="margin:0" name="frm_usuario" 
		action="javascript:agregar_permiso('F',document.frm_usuario.id_funcionario.value)">
	<table border="0"><tr><td>
		<cf_conlis title="Lista de Funcionarios"
					campos = "id_funcionario,nombre,apellido1,apellido2" 
					desplegables = "N,S,S,S" 
					size = "0,15,15,15"
					values=""
					tabla="TPFuncionario f
							inner join TPPersona p
								on p.id_persona=f.id_persona
							inner join TPInstitucion i
								on i.id_inst=f.id_inst"
					columnas="id_funcionario,nombre_inst,nombre,apellido1,apellido2"
					filtro="getDate() between f.vigente_desde and f.vigente_hasta and
							getDate() between i.vigente_desde and i.vigente_hasta
							order by nombre_inst,p.nombre, p.apellido1, p.apellido2"
					desplegar="nombre_inst,nombre,apellido1,apellido2"
					etiquetas="Institución,Nombre,Primer Apellido,Segundo Apellido"
					formatos="S,S,S,S"
					align="left,left,left,left"
					asignar="id_funcionario,nombre,apellido1,apellido2"
					conexion="#session.tramites.dsn#"
					form = "frm_usuario">
		</td><td>
		<input type="submit" value="Agregar">
		
		</td></tr></table>
	</form>
	</td>
  </tr>
  <tr>
    <td colspan="#ListLen(url.items)+6#" bgcolor="##CCCCCC">Agregar Organizaci&oacute;n </td>
  </tr>
  <tr>
    <td colspan="#ListLen(url.items)+6#">
	<form style="margin:0" name="frm_organizacion" 
		action="javascript:void(0)">
	  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><select name="add_tipoinst" onchange="agregar_permiso('T',this.value)">
		  	<option value="">- Agregar Tipo de Instituci&oacute;n -</option>
			<cfloop query="tipoinst">
			<option value="#id_tipoinst#">#HTMLEditFormat(nombre_tipoinst)#</option>
			</cfloop>
		  </select></td>
          <td><select name="add_inst" onchange="agregar_permiso('I',this.value)">
            <option value="">- Agregar Instituci&oacute;n -</option>
			<cfloop query="inst">
			<option value="#id_inst#">#HTMLEditFormat(nombre_inst)#</option>
			</cfloop>
          </select></td>
          <td><select name="add_funcion" onchange="agregar_permiso('G',this.value)">
            <option value="">- Agregar Funci&oacute;n -</option>
			</cfoutput>
			<cfoutput query="grupos" group="id_inst">
				<optgroup label="#HTMLEditFormat(nombre_inst)#">
					<cfoutput>
					<option value="#id_grupo#">#HTMLEditFormat(nombre_grupo)#</option>
					</cfoutput>
				</optgroup>
			</cfoutput>
			<cfoutput>
          </select></td>
        </tr>
      </table>	</form></td>
  </tr>
  <tr>
    <td colspan="#ListLen(url.items)+6#" bgcolor="##CCCCCC">Buscar Funcionarios o Grupos </td>
  </tr>
  <!---
  	quitar la busqueda
  <tr>
    <td colspan="#ListLen(url.items)+6#" ><form name="formbuscar" method="get" action="" style="margin:0 ">
	
	<cfoutput>
      <input type="hidden" name="tipo_objeto" value="#HTMLEditFormat(url.tipo_objeto)#">
      <input type="hidden" name="id_objeto" value="#HTMLEditFormat(url.id_objeto)#">
      <input type="hidden" name="items" value="#HTMLEditFormat(url.items)#">
      <input type="text" name="buscar" value="#HTMLEditFormat(url.buscar)#" onfocus="this.select();">
	  </cfoutput>
      <input type="submit" name="Submit" value="Buscar">
    </form></td>
  </tr>
  	<tr><td colspan="#ListLen(url.items)+6#"  >
	<cfif len(url.buscar) EQ 0>
			<em><strong>
				Para agregar un usuario o grupo, indique su
				nombre para buscarlo en el sistema.
			</strong></em>
	<cfelse>
		<cfif buscar.RecordCount EQ 0>
			<em><strong>
				No se encontraron usuarios ni grupos
				con el texto &quot;#HTMLEditFormat(LCase(url.buscar))#&quot;.
				<br>
				Realice una nueva b&uacute;squeda.
			</strong></em>
		<cfelse>
			<em><strong>
				Se encontraron los siguientes usuarios y/o grupos.
				Haga clic en el que desea agregar a los permisos.
			</strong></em>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
					query="#buscar#"
					desplegar="codigo_sujeto,nombre_sujeto"
					etiquetas="C&oacute;digo,Nombre"
					formatos="S,S"
					align="left,left"
					ajustar="N"
					funcion="agregar_permiso"
					fparams="tipo_sujeto,id_sujeto"
					showEmptyListMsg="true"
					keys="tipo_sujeto,id_sujeto"
					navegacion="tipo_objeto=#URLEncodedFormat(url.tipo_objeto)#&id_objeto=#URLEncodedFormat(url.id_objeto)#&items=#URLEncodedFormat(url.items)#&buscar=#URLEncodedFormat(url.buscar)#"
					/>
		</cfif>
	</cfif>
</td></tr>
--->

</table>


<form name="formagregarpermiso" action="permisos-sql.cfm" method="post" style="margin:0">

<cfoutput>
<input type="hidden" name="tipo_objeto" value="#HTMLEditFormat(url.tipo_objeto)#">
<input type="hidden" name="id_objeto" value="#HTMLEditFormat(url.id_objeto)#">
<input type="hidden" name="items" value="#HTMLEditFormat(url.items)#">
<input type="hidden" name="buscar" value="#HTMLEditFormat(url.buscar)#">
<input type="hidden" name="tipo_sujeto" value="">
<input type="hidden" name="id_sujeto" value="">
<input type="hidden" name="agregar" value="">
</cfoutput>
</form>
<script type="text/javascript">
function agregar_permiso(tipo_sujeto,id_sujeto)
{
	if(id_sujeto.length==0)return;
	document.formagregarpermiso.tipo_sujeto.value = tipo_sujeto;
	document.formagregarpermiso.id_sujeto.value = id_sujeto;
	document.formagregarpermiso.submit();
}
function save_check(tipo_sujeto,id_sujeto)
{
	var myframe = document.getElementById('frupdate');
	var f = document.form1;
	
	var url = 'permisos-sql.cfm?upd=1'
		+ '&tipo_objeto=#JSStringFormat(url.tipo_objeto)#'
		+ '&id_objeto=#JSStringFormat(url.id_objeto)#'
		+ '&tipo_sujeto=' + escape(tipo_sujeto)
		+ '&id_sujeto=' + escape(id_sujeto);
	if (f['chk_'+tipo_sujeto+'_'+id_sujeto+'__CAP'].checked)
		url += '&cap=1';
	if (f['chk_'+tipo_sujeto+'_'+id_sujeto+'__REV'].checked)
		url += '&rev=1';
	if (f['chk_'+tipo_sujeto+'_'+id_sujeto+'__MOD'].checked)
		url += '&mod=1';
	var itm = f['chk_'+tipo_sujeto+'_'+id_sujeto+'__ITM'];
	if (itm) {
		if (itm.length) {
			for(var i=0;i<itm.length;i++) {
				if (itm[i].checked) {
					url += '&itm=' + escape(itm[i].value);
				}
			}
		} else if (itm.checked) {
			url += '&itm=' + escape(itm.value);
		}
	}
	myframe.src = url;
}
function borrar_sujeto(tipo_sujeto,id_sujeto)
{
	var f = document.form1;
	var url = 'permisos-sql.cfm?baja=1'
		+ '&tipo_objeto=#JSStringFormat(URLEncodedFormat(url.tipo_objeto))#'
		+ '&id_objeto=#JSStringFormat(URLEncodedFormat(url.id_objeto))#'
		+ '&items=#JSStringFormat(URLEncodedFormat(url.items))#'
		+ '&buscar=#JSStringFormat(URLEncodedFormat(url.buscar))#'
		+ '&tipo_sujeto=' + escape(tipo_sujeto)
		+ '&id_sujeto=' + escape(id_sujeto);
	location.href = url;
}
</script>
</cfoutput>

<iframe id="frupdate" width="100" height="20" frameborder="0" style="margin:1px solid black;display:none;"></iframe>
</body>
</html>
