<cfparam name="url.srch" default="">
<cfparam name="form.srch" default="#url.srch#">
<form action="" method="post" style="margin:0" id="formsrch" name="formsrch">
<cfoutput><table border="0">
  <tr>
    <td>&nbsp;</td>
    <td>Buscar:</td>
    <td><cfoutput>
		<input type="hidden" name="srty" value="d"><!--- d=dominio,s=sitio --->
        <input onFocus="this.select()" maxlength="20" size="30" type="text" name="srch" value="#HTMLEditFormat(Trim(form.srch))#">
</cfoutput></td>
    <td><input name="submit" type="submit" value="Buscar"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">Puede utilizar los comodines * y ?&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

</cfoutput>
</form>
<cfif Len(Trim(form.srch))>
	<cfset srch = UCase( Trim ( form.srch ))>
	<cfset srch = Replace(srch, '%', '[%]')>
	<cfset srch = Replace(srch, '_', '[_]')>
	<cfif Find ("*", srch) NEQ 0 or Find ("?", srch) NEQ 0>
		<cfset srch = Replace(srch, '*', '%', 'all')>
		<cfset srch = Replace(srch, '?', '_', 'all')>
	<cfelse>
		<cfset srch = '%' & srch & '%'>
	</cfif>
	<cfset srch = Replace(srch, "'", "''",'all')>
<cfelse>
	<cfset srch = "">
</cfif>
<cfquery datasource="asp" name="sitioDefault">
	select Scodigo from MSDominio where dominio = '*'
</cfquery>
<cfif sitioDefault.RecordCount GE 1>
	<cfset sitioDefault=sitioDefault.Scodigo>
<cfelse>
	<cfset sitioDefault=-1>
</cfif>

<cfquery datasource="asp" name="lista_dominios">
	select s.Snombre, s.Scodigo, a.dominio, sm.SMdescripcion, sp.SPdescripcion, b.CEnombre,
	<!--- 
		no se hace <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.srch#" null="#Len(form.srch) Is 0#">
		porque en DB2 da
			Error Executing Database Query. [Macromedia]
			[DB2 JDBC Driver]
			[DB2]
			STRING TO BE PREPARED CONTAINS INVALID USE OF PARAMETER MARKERS 			
	--->
		c.Enombre, '#form.srch#' as srch,
		'd' as srty, ap.descripcion from Sitio s 
	left outer join MSDominio a
		on s.Scodigo = a.Scodigo 
	left outer join  CuentaEmpresarial b
		on a.CEcodigo = b.CEcodigo
	left outer join Empresa c
		on a.Ecodigo = c.Ecodigo 
	left outer join  SModulos sm
		on sm.SMcodigo = a.SMcodigo
	left outer join  SProcesos sp
		on sp.SMcodigo = a.SMcodigo
		and sp.SPcodigo = a.SPcodigo
	left outer join  MSApariencia ap
		on ap.id_apariencia = a.id_apariencia
	<cfif Len(srch)>
	where ( upper(a.dominio)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(b.CEnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(c.Enombre)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(s.Snombre)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(a.dominio)  like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(sm.SMdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 or upper(sp.SPdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#srch#">
		 )
	</cfif>
	order by
		case when a.Scodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#sitioDefault#">
			then 0 else 1 end,
		upper(s.Snombre), upper(a.dominio)
</cfquery>

<cfinvoke 
component="commons.Componentes.pListas"
method="pListaQuery"
returnvariable="pListaRet">
	<cfinvokeargument name="desplegar" value="dominio, descripcion, CEnombre, Enombre, SMdescripcion, SPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Dominio, Plantilla, Cuenta Empresarial, Empresa, Módulo, Servicio"/>
	<cfinvokeargument name="formatos" value="V, V, V, V, V, V"/>
	<cfinvokeargument name="align" value="left, left, left, left, left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="Nuevo" value=""/>
	<cfinvokeargument name="irA" value="dominio-edit.cfm"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
	<cfinvokeargument name="Nuevo" value="dominio-edit.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys" value="Scodigo"/>
	<cfinvokeargument name="cortes" value="Snombre"/>
	<cfinvokeargument name="query" value="#lista_dominios#"/>
</cfinvoke>
<script type="text/javascript">
<!--
	window.setTimeout ("document.formsrch.srch.focus()",0);
//-->
</script>