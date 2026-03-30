<cfsetting enablecfoutputonly="yes">
<!--- url.o = ordenamiento --->
<cfparam name="url.o" default="1">
<cfif url.o neq 1 and url.o neq 2 and url.o neq 3 and url.o neq 4>
	<cfset url.o = 1>
</cfif>
<!--- url.s = sistema --->
<cfparam name="url.s" default="">
<!--- url.m = modulo  --->
<cfparam name="url.m" default="">
<!--- url.p = proceso  --->
<cfparam name="url.p" default="">
<!--- url.e = empresa --->
<cfparam name="url.e" default="">

<!--- filtros Cedula, Nombre, Estado --->
<cfparam name="url.fC" default="">
<cfparam name="url.fN" default="">
<cfparam name="url.fA" default="">
<cfparam name="url.fE" default="">

<cfquery datasource="#session.dsn#" name="packageid">
	select p.PackageId, pk.CFdestino
	from WfProcess p
		inner join WfPackage pk
			on pk.PackageId = p.PackageId
		inner join WfActivity a
			on a.ProcessId = p.ProcessId
	where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
</cfquery>

<cfquery datasource="#session.dsn#" name="type_boss">
	select 1
	from WfParticipant wfp
	where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
	  and wfp.ParticipantType = 'BOSS'
</cfquery>

<cfif type_boss.RecordCount is 0>
	<cfquery datasource="#session.dsn#">
	insert into WfParticipant (PackageId, Name, Description, ParticipantType)
	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
		'JEFE', 'Jefe del paso anterior', 'BOSS')
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="type_boss">
	select 1
	from WfParticipant wfp
	where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
	  and wfp.ParticipantType = 'BOSS1'
</cfquery>

<cfif type_boss.RecordCount is 0>
	<cfquery datasource="#session.dsn#">
	insert into WfParticipant (PackageId, Name, Description, ParticipantType)
	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
		'JEFE ORIGEN', 'Jefe del Centro Funcional Origen', 'BOSS1')
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="type_boss">
	select 1
	from WfParticipant wfp
	where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
	  and wfp.ParticipantType = 'BOSSES1'
</cfquery>

<cfif type_boss.RecordCount is 0>
	<cfquery datasource="#session.dsn#">
	insert into WfParticipant (PackageId, Name, Description, ParticipantType)
	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
		'OFICINA ORIGEN', 'Rol Autorizador de Oficina Origen', 'BOSSES1')
	</cfquery>
</cfif>

<cfquery name="rsCFAprobador" datasource="#session.dsn#">
	select 1
	from WfParticipant wfp
	where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
	  and wfp.ParticipantType = 'BOSSAP1' <!--- Jefe aprobador del centro funcional origen --->
</cfquery>

<cfif rsCFAprobador.RecordCount is 0>
	<cfquery datasource="#session.dsn#">
	insert into WfParticipant (PackageId, Name, Description, ParticipantType)
	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
		'APROBADOR ORIGEN', 'Aprobador del Centro Funcional Origen', 'BOSSAP1')
	</cfquery>
</cfif>

<cfif packageid.CFdestino EQ 1>
	<cfquery datasource="#session.dsn#" name="type_boss">
		select 1
		from WfParticipant wfp
		where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
		  and wfp.ParticipantType = 'BOSS2'
	</cfquery>

	<cfif type_boss.RecordCount is 0>
		<cfquery datasource="#session.dsn#">
		insert into WfParticipant (PackageId, Name, Description, ParticipantType)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
			'JEFE DESTINO', 'Jefe del Centro Funcional Destino', 'BOSS2')
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#" name="type_boss">
		select 1
		from WfParticipant wfp
		where wfp.PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
		  and wfp.ParticipantType = 'BOSSES2'
	</cfquery>

	<cfif type_boss.RecordCount is 0>
		<cfquery datasource="#session.dsn#">
		insert into WfParticipant (PackageId, Name, Description, ParticipantType)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">,
			'OFICINA DESTINO', 'Rol Autorizador de Oficina Destino', 'BOSSES2')
		</cfquery>
	</cfif>
<cfelse>
	<cfquery datasource="#session.dsn#" name="type_boss">
		delete from WfParticipant
		where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
		  and ParticipantType = 'BOSS2'
	</cfquery>
	<cfquery datasource="#session.dsn#" name="type_boss">
		delete from WfParticipant
		where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
		  and ParticipantType = 'BOSSES2'
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="lista">
	select
		ParticipantId, Name, Description, ParticipantType
	from WfParticipant
	where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#packageid.PackageId#">
	  and ParticipantType <> 'ADMIN'
	<cfif Len(url.fC)>
	  and lower(Name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fC)#%">
	</cfif>
	<cfif Len(url.fN)>
	  and lower(Description) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(url.fN)#%">
	</cfif>
	<cfif Len(url.fE)>
	  and ParticipantType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.fE#">
	</cfif>
	  and not exists (
	  	select 1
		from WfActivityParticipant
		where WfActivityParticipant.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
		  and WfActivityParticipant.ParticipantId = WfParticipant.ParticipantId )
	order by case when ParticipantType in ('BOSS','BOSS1','BOSS2','BOSSES2','BOSSES1') then 0 else 1 end,
	<cfif url.o is 1>
		upper(Name), upper(Description), upper(ParticipantType)
	<cfelseif url.o is 2>
		upper(Description), upper(Name), upper(ParticipantType)
	<cfelseif url.o is 3>
		upper(Description), upper(Name), upper(ParticipantType)
	<cfelseif url.o is 4>
		upper(ParticipantType), upper(Name), upper(Description)
	<cfelse>
		upper(Name), upper(Description), upper(ParticipantType)
	</cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_lista" default="1">
<cfset MaxRows_lista=10>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,lista.RecordCount)>
<cfset TotalPages_lista=Ceiling(lista.RecordCount/MaxRows_lista)>
<cfset QueryString_lista=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<link href="../../css/web_portlet.css" rel="stylesheet" type="text/css">
<title><cf_translate key="LB_SeleccioneUnUsuario">Seleccione un usuario</cf_translate></title>
</head>

<body>

<cfinclude template="conlis_part_tab.cfm">

<div class="subTitulo" style="width:90%"> <cf_translate key="LB_ItemsRecientes">Items recientes</cf_translate>
</div>
<form action="#CurrentPage#" method="get" name="form1"><input type="hidden" name="ActivityId" value="#HTMLEditFormat(url.ActivityId)#">
	<table border="0" cellpadding="0" cellspacing="0" width="90%" align="center">
		<tr class="tituloListas">
			<td>&nbsp;</td>
			<td><a href="#CurrentPage#?o=3&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Tipo" XmlFile="/sif/generales.xml">Tipo</cf_translate></a> <cfif url.o is 3>&darr;</cfif></td>
			<td>&nbsp;</td>
			<td><a href="#CurrentPage#?o=1&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Cedula" XmlFile="/sif/generales.xml">C&eacute;dula</cf_translate></a> <cfif url.o is 1>&darr;</cfif></td>
			<td>&nbsp;</td>
			<td><a href="#CurrentPage#?o=2&amp;ActivityId=#url.ActivityId#"><cf_translate key="LB_Nombre" XmlFile="/sif/generales.xml">Nombre</cf_translate></a> <cfif url.o is 2>&darr;</cfif></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<select name="fE" id="fE" onChange="form.submit()">
					<option value="" <cfif url.fE is "">selected</cfif>>- <cf_translate key="CMB_Todos" XmlFile="/sif/generales.xml">Todos</cf_translate> -</option>
					<option value="HUMAN" <cfif url.fE is 'HUMAN'>selected</cfif>><cf_translate key="CMB_Usuario">USUARIO</cf_translate></option>
					<option value="ROLE" <cfif url.fE is 'ROLE'>selected</cfif>><cf_translate key="CMB_Rol">ROL</cf_translate></option>
					<option value="ORGUNIT" <cfif url.fE is 'ORGUNIT'>selected</cfif>><cf_translate key="CMB_CFuncional">C. FUNCIONAL</cf_translate></option>
					<option value="BOSS" <cfif url.fE is 'BOSS'>selected</cfif>><cf_translate key="CMB_Jefe">JEFE</cf_translate></option>
					<!--- // no se muestra puesto que aun no hay manera de definir grupos //
					<option value="GROUP" <cfif url.fE is 'GROUP'>selected</cfif>>GRUPO</option>
					--->
				</select>
			</td>
			<td>&nbsp;</td>
			<td><input name="fC" type="text" id="fC" value="#HTMLEditFormat(url.fC)#" onFocus="this.select()"></td>
			<td>&nbsp;</td>
			<td><input name="fN" type="text" id="fN" value="#HTMLEditFormat(url.fN)#" onFocus="this.select()"></td>
			<td>&nbsp;</td>
		</tr>
  <cfloop query="lista" startRow="#StartRow_lista#" endRow="#StartRow_lista+MaxRows_lista-1#">

    <tr onclick="regresar('#JSStringFormat(ParticipantType)#','#JSStringFormat(Name)#','#JSStringFormat(Description)#','','','',#ParticipantId#)"
		style="cursor:pointer"
		class="<cfif lista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"
		onMouseOver="listmov(this)"
		onMouseOut="listmout(this)" >
      <td>&nbsp;</td>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Usuario"
			Default="USUARIO"
			returnvariable="LB_Usuario"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CFuncional"
			Default="C.FUNCIONAL"
			returnvariable="LB_CFuncional"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Grupo"
			Default="GRUPO"
			returnvariable="LB_Grupo"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Rol"
			Default="ROL"
			returnvariable="LB_Rol"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Jefe"
			Default="JEFE"
			returnvariable="LB_Jefe"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Jefe1"
			Default="JEFE ORIGEN"
			returnvariable="LB_Jefe1"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Jefe2"
			Default="JEFE DESTINO"
			returnvariable="LB_Jefe2"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_AUTORZ"
			Default="AUTORIZADOR"
			returnvariable="LB_AUTORZ"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_APROB1"
			Default="APROBADOR ORIGEN"
			returnvariable="LB_APROB1"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_APROB2"
			Default="APROBADOR DESTINO"
			returnvariable="LB_APROB2"/>

<!--- 	  <cfset PartType = ListGetAt(ParticipantType & ',USUARIO,C. FUNCIONAL,GRUPO,ROL,JEFE', 1+ListFindNoCase('HUMAN,ORGUNIT,GROUP,ROLE,BOSS',ParticipantType))>
 --->	  <cfset PartType = ListGetAt(ParticipantType & ','&LB_Usuario&','&LB_CFuncional&','
					&LB_Grupo&','&LB_Rol&','&LB_Jefe&','&LB_AUTORZ&','&LB_AUTORZ&','&LB_Jefe1&','
					&LB_Jefe2&','&LB_APROB1&','&LB_APROB2,
					1+ListFindNoCase('HUMAN,ORGUNIT,GROUP,ROLE,BOSS,BOSSES1,BOSSES2,BOSS1,BOSS2,BOSSAP1,BOSSAP2',ParticipantType))>
      <td>#PartType#</td>
      <td>&nbsp;</td>
      <td>#Name#</td>
      <td>&nbsp;</td>
      <td>#Description#</td>
      <td>&nbsp;</td>
    </tr>
  </cfloop>
  <tr><td colspan="7">&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;
      <table border="0" width="50%" align="center">
          <tr>
            <td width="23%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#"><img src="../../imagenes/First.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
            <td width="31%" align="center"><cfif PageNum_lista GT 1>
                <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#"><img src="../../imagenes/Previous.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#"><img src="../../imagenes/Next.gif" width="14" height="13" border=0></a>
              </cfif>
            </td>
            <td width="23%" align="center"><cfif PageNum_lista LT TotalPages_lista>
                <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#"><img src="../../imagenes/Last.gif" width="18" height="13" border=0></a>
              </cfif>
            </td>
          </tr>
      </table></td>
    <td>&nbsp;</td>
  </tr>
  <tr><td colspan="7">&nbsp;</td></tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp; <cf_translate key="MSG_MostrandoUsuarios">Mostrando usuarios</cf_translate> #StartRow_lista# <cf_translate key="MSG_A">a</cf_translate> #EndRow_lista# <cf_translate key="MSG_De">de</cf_translate> #lista.RecordCount# </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Buscar"
			Default="Buscar"
			XmlFile="/sif/generales.xml"
			returnvariable="BTN_Buscar"/>
		<input type="submit" value="#BTN_Buscar#"  tabindex="1">
	</td>
    <td colspan="5">&nbsp;</td>
  </tr>
</table>
</form>

</body>
</html>
</cfoutput>
