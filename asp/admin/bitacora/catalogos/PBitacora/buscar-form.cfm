<cfif NOT ISDEFINED('form.dsn') AND ISDEFINED('url.dsn')>
	<cfset form.dsn = url.dsn>
</cfif>
<cfif NOT ISDEFINED('form.tabla') AND ISDEFINED('url.tabla')>
	<cfset form.tabla = url.tabla>
</cfif>
<cfparam name="form.tabla" default="">
<cfquery datasource="asp" name="caches">
	select distinct c.Ccache as cache
	from Caches c
		join Empresa e
			on c.Cid = e.Cid
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by cache
</cfquery>

<cfparam name="form.dsn" default="#caches.cache#">

<!--- con este cfset se asegura que solo se puedan utilizar los datasources que se cargaron en la variable Application.dsinfo descartando que mentan en el url sentencias sql--->
<cfset dbtype = Application.dsinfo[form.dsn].type>
<cfquery name="rsTablas" datasource="asp">
	select PBtabla from PBitacora where PCache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(form.dsn)#">
</cfquery>
<cfset ListTablas = ValueList(rsTablas.PBtabla)>
<cfquery datasource="#form.dsn#" name="tablas">
	<cfif dbtype is 'oracle'>
		select table_name as tabla,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(form.dsn)#"> as dsn
		from user_tables
		where lower(table_name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(form.tabla)#%">
		order by table_name
	<cfelseif dbtype is 'sybase' or dbtype is 'sqlserver'>
		select s.name as tabla, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dsn#"> as dsn,
		case when (
		SELECT COUNT(o.name)
        FROM sysconstraints c, sysobjects o
        WHERE c.id =  OBJECT_ID(s.name)
        AND c.constid = o.id
        AND o.xtype in ('PK','UQ')
		) > 0 then '' else s.name end as pk
		from sysobjects s
		where s.type = 'U'
		   and s.name not in(<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#ListTablas#">)
		  and lower(s.name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(form.tabla)#%">
		order by s.name
	<cfelseif dbtype is 'db2'>
    	<!--- TABSCHEMA es el esquema de la base de datos y lo que se necesita es el dsn definido en el administrador de coldfusion, se debe usar form.dsn!  --->
		select TABNAME as tabla,
				'#form.dsn#' as dsn
		from SYSCAT.TABLES
		where TYPE = 'T'
		  and lower(TABNAME) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCase(form.tabla)#%">
		order by TABNAME
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbtype#">
	</cfif>
</cfquery>

<cfif tablas.RecordCount is 1>
	<cflocation url="buscar2.cfm?DSN=#URLEncodedFormat(form.dsn)#&TABLA=#URLEncodedFormat(tablas.tabla)#">
</cfif>

<cfoutput>
<!---cfif ISDEFINED("form.PageNum_lista2")>
	<cfset PageNum_lista = form.PageNum_lista2>
</cfif>
<cfif not ISDEFINED("form.PageNum_lista2")>
	<cfset url.PageNum_lista = 1>
</cfif--->

<form name="form1" method="post" action="buscar.cfm">
<table  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="4" class="subTitulo"> Selecci&oacute;n de una nueva tabla </td>
    </tr>
  <tr>
    <td width="159" valign="top">Tabla</td>
    <td width="27" valign="top">&nbsp;</td>
    <td width="202" valign="top"><input name="tabla" id="tabla" type="text" value="#HTMLEditFormat(form.tabla)#"
				maxlength="30"
				onfocus="this.select()"  >
    </td>
    <td width="202" valign="top"><input type="submit" name="Submit" class="btnFiltrar" value="Buscar"></td>
  </tr>
  <tr>
    <td valign="top">Datasource para leer el metadato</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">
      <select name="dsn" onchange="funcBusca()">
	  <cfloop query="caches">
	  	<option value="#HTMLEditFormat(caches.cache)#" <cfif #caches.cache# eq #form.dsn#>selected</cfif>>#HTMLEditFormat(caches.cache)#</option>
		</cfloop>
      </select>
    </td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
</form>

<cfif tablas.RecordCount>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#tablas#"
			desplegar="tabla"
			etiquetas="Tablas encontradas"
			formatos="S"
			align="left"
			ira="buscar2.cfm"
			form_method="post"
			formname="lista2"
			keys="tabla,dsn"
		/>
<cfelse>
	No se encontraron tablas con este nombre.
</cfif>

</cfoutput>

<script language="javascript" type="text/javascript">
	function funcBusca(){
		document.form1.submit();
	}

</script>



