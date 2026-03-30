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
<cfset form.dsn = Trim(form.dsn)>
<cfset dbtype = Application.dsinfo[form.dsn].type>

<cfquery datasource="#form.dsn#" name="columnas">
	<cfif dbtype is 'oracle'>
		select c.column_name as column_name
		from user_tab_columns c
		where c.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
		order by c.column_id
	<cfelseif dbtype is 'sybase' or dbtype is 'sqlserver'>
		select c.name as column_name
		from syscolumns c
			join sysobjects o
				on o.id = c.id
		where o.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
		order by c.colid
	<cfelseif dbtype is 'db2'>
		select COLNAME as column_name
		   from SYSCAT.COLUMNS
		   where upper(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(form.tabla)#">
		order by COLNO
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbtype#">
	</cfif>
</cfquery>
<!---►►►►►►Se Obtienen los Primary key y Unique Key en ORACLE◄◄◄◄◄◄◄◄--->
<cfif dbtype is 'oracle'>
	<cfquery datasource="#form.dsn#" name="indices">
		select s.constraint_type, i.index_name, c.column_name
		from user_indexes i
			join user_ind_columns c
				on i.table_name = c.table_name
				and i.index_name = c.index_name
			left join user_constraints s
				on s.table_name = i.table_name
				and s.index_name = c.index_name
				and s.constraint_type = 'P'
		where i.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
           and i.UniqueNess = 'UNIQUE'
		order by s.constraint_type, i.index_name, c.column_position
	</cfquery>
	<cfset pk = ''>
	<cfset ak = ''>
	<cfloop query="indices">
		<cfset ak = ListAppend(ak,Trim(indices.column_name))>
		<cfif indices.constraint_type is 'P'>
			<cfset pk = ListAppend(ak,Trim(indices.column_name))>
		</cfif>
	</cfloop>
<!---►►►►►►Se Obtienen los Primary key y Unique Key en SYBASE◄◄◄◄◄◄◄◄--->
<cfelseif dbtype is 'sybase'>
	<cfquery datasource="#form.dsn#" name="indices">
		exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
	</cfquery>
    <cfquery datasource="#form.dsn#" name="sysindexes">
        SELECT name,case when (status & 2048 = 2048) then 'P' else 'A' end as type
          FROM sysindexes
         WHERE id = OBJECT_ID('#form.tabla#')
           AND indid > 0
           AND status2 & 2 = 2
    </cfquery>
    <cfset pk = ''>
	<cfset ak = ''>
    <cfloop query="sysindexes">
    	<cfquery name="rsCampos" dbtype="query">
        	select index_keys from indices where index_name = '#sysindexes.name#'
        </cfquery>
        <cfif sysindexes.type EQ 'P'>
        	<cfset pk=Replace(rsCampos.index_keys,' ','','all')>
        <cfelse>
        	<cfset ak=Replace(ValueList(rsCampos.index_keys),' ','','all')>
        </cfif>
    </cfloop>
<!---►►►►►►Se Obtienen los Primary key y Unique Key en SQL-SERVER◄◄◄◄◄◄◄◄--->
<cfelseif dbtype is 'sqlserver'>
	<cfset pk = ''>
	<cfset ak = ''>
    <cfquery datasource="#form.dsn#" name="indices">
		exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
	</cfquery>
    <cfquery name="rsPKsAKs" datasource="#form.dsn#">
       SELECT o.name, case when xtype = 'PK' then 'P' else 'A' end as type
         FROM sysconstraints c, sysobjects o
        WHERE c.id =  OBJECT_ID('#form.tabla#')
          AND c.constid = o.id
          AND o.xtype in ('PK','UQ')
	</cfquery>
	<cfloop query="rsPKsAKs">
    	<cfquery name="rsColumns" dbtype="query">
        	select index_keys
            	from indices
             where index_name = '#rsPKsAKs.name#'
        </cfquery>
    	<cfif rsPKsAKs.type EQ 'P'>
        	<cfset pk = ListAppend(pk,Replace(rsColumns.index_keys,' ','','all'))>
        <cfelse>
        	<cfset ak = ListAppend(ak,Replace(rsColumns.index_keys,' ','','all'))>
        </cfif>
	</cfloop>
<!---►►►►►►Se Obtienen los Primary key y Unique Key en DB2◄◄◄◄◄◄◄◄--->
<cfelseif dbtype is 'db2'>
	<cfquery datasource="#form.dsn#" name="indices">
		select UNIQUERULE, INDNAME, COLNAMES
			from SYSCAT.INDEXES
		where lower(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(form.tabla)#">
		order by UNIQUERULE, INDNAME, IID
	</cfquery>
	<cfset pk = ''>
	<cfset ak = ''>
	<cfloop query="indices">
		<cfif indices.UNIQUERULE is 'U'>
			<cfset ak = ListAppend(ak,Trim(indices.COLNAMES))>
		<cfelseif indices.UNIQUERULE is 'P'>
			<cfset pk = ListAppend(pk,Trim(indices.COLNAMES))>
		</cfif>
	</cfloop>
	<cfset pk=Replace(pk,'+','','all')>
	<cfset ak=Replace(ak,'+',',','all')>
<cfelse>
	<cfthrow message="DBMS no soportado: #dbtype#">
</cfif>

<cfoutput>

<script type="text/javascript">
<!--
function validar(f) {
	<cfif columnas.RecordCount GT 1>
	var cpk=0<!---,cak=0,cde=0--->;
	for (i=0;i<#columnas.RecordCount#;i++) {
		if (f.pk[i].checked) cpk++;
		<!--- if (f.ak[i].checked) cak++; --->
		<!--- if (f.de[i].checked) cde++; --->
	}
	</cfif>
	var msg="";
	if (cpk == 0) msg += "\nDebe definir una llave primaria";
	<!---	solamente vamos a obligar la llave primaria, no asi la alterna ni la descripcion --->
	<!---	if (cak == 0) msg += "\nDebe definir una llave alterna"; --->
	<!---	if (cde == 0) msg += "\nDebe definir una descripción";   --->
	if (msg.length) {
		alert("Falta la siguiente información:"+msg);
		return false;
	}
	return true;
}
//-->
</script>

<form name="form1" method="post" action="PBitacora.cfm" onSubmit="return validar(this);">
<table  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="4" class="subTitulo"> Selecci&oacute;n de una nueva tabla </td>
    </tr>
  <tr>
    <td width="159" valign="top">Buscar tabla </td>
    <td width="27" valign="top">&nbsp;</td>
    <td width="202" valign="top"><input name="tabla" id="tabla" type="text" value="#HTMLEditFormat(form.tabla)#"
				maxlength="30"
				onfocus="this.select()"  >
    </td>
    <td width="202" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">Datasource para leer el metadato </td>
    <td valign="top">&nbsp;</td>
    <td valign="top">
      <select name="dsn" disabled>
	  <cfloop query="caches">
	  	<option value="#HTMLEditFormat(caches.cache)#" <cfif caches.cache is form.dsn>selected</cfif>>#HTMLEditFormat(caches.cache)#</option>
		</cfloop>
      </select>
	  <input type="hidden" name="PCache" value="#HTMLEditFormat(form.dsn)#">
    </td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><input type="submit" name="Submit" value="Continuar" class="btnSiguiente"></td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<table  border="1" cellspacing="0" cellpadding="2">
  <tr>
    <td>Columna</td>
    <td>Es llave primaria </td>
    <td>Es llave alterna </td>
    <td>Descripci&oacute;n</td>
    </tr>
  <cfloop query="columnas">
  <tr>
    <td>#HTMLEditFormat(column_name)#</td>
    <td align="center"><input type="checkbox" name="pk" value="#HTMLEditFormat(column_name)#" <cfif ListFind(pk,column_name)>checked</cfif>></td>
    <td align="center"><input type="checkbox" name="ak" value="#HTMLEditFormat(column_name)#" <cfif ListFind(ak,column_name) and not ListFind(pk,column_name)>checked</cfif>></td>
    <td align="center"><input type="checkbox" name="de" value="#HTMLEditFormat(column_name)#" <cfif (FindNoCase('descrip', column_name) or FindNoCase('nombre', column_name)) and not ListFind(ak,column_name) and not ListFind(pk,column_name)>checked</cfif>></td>
    </tr>
  </cfloop>
</table>
</form>



</cfoutput>