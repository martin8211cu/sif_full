<cfparam name="url.tabla" default="">
<cfquery datasource="asp" name="caches">
	select distinct c.Ccache as cache
	from Caches c
		join Empresa e
			on c.Cid = e.Cid
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	order by cache
</cfquery>

<cfparam name="url.dsn" default="#caches.cache#">
<cfset url.dsn = Trim(url.dsn)>
<cfset dbtype = Application.dsinfo[url.dsn].type>

<cfquery datasource="#url.dsn#" name="columnas">
	<cfif dbtype is 'oracle'>
		select c.column_name as column_name
		from user_tab_columns c
		where c.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">
		order by c.column_id
	<cfelseif dbtype is 'sybase' or dbtype is 'sqlserver'>
		select c.name as column_name
		from syscolumns c
			join sysobjects o
				on o.id = c.id
		where o.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">
		order by c.colid
	<cfelseif dbtype is 'db2'>
		select COLNAME as column_name 
		   from SYSCAT.COLUMNS 
		   where upper(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(url.tabla)#">
		order by COLNO
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbtype#">
	</cfif>	
</cfquery>

<cfif dbtype is 'oracle'>
	<cfquery datasource="#url.dsn#" name="indices">
		select s.constraint_type, i.index_name, c.column_name
		from user_indexes i
			join user_ind_columns c
				on i.table_name = c.table_name
				and i.index_name = c.index_name
			left join user_constraints s
				on s.table_name = i.table_name
				and s.index_name = c.index_name
				and s.constraint_type = 'P'
		where i.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">
		order by s.constraint_type, i.index_name, c.column_position
	</cfquery>
	<cfset pk = ''>
	<cfset ak = ''>
	<cfloop query="indices">
		<cfset ak = ListAppend(ak,Trim(indices.column_name))>
		<cfif indices.constraint_type is 'P'>
			<!--- primary key --->
			<cfset pk = ListAppend(ak,Trim(indices.column_name))>
		</cfif>
	</cfloop>
<cfelseif dbtype is 'sybase'>
	<!--- Busca la llave primaria --->
	<!--- <cfquery datasource="#url.ds#" name="PrimaryKey">
			SELECT keycnt, indid
			FROM   sysindexes
			WHERE  id = object_id( <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#"> )
			  AND indid > 0
			  AND status2 & 2 = 2
              and status & 2048 = 2048
			ORDER BY indid
		</cfquery>
        
		<cfloop query="uniqueKeys">
			<cfset keyCols = ArrayNew(1)>
			<cfloop from="1" to="#uniqueKeys.keycnt#" index="i">
				<cfquery datasource="#url.ds#" name="cols">
					select index_col(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#uniqueKeys.indid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">) index_col
				</cfquery>
				<cfif Len(Trim(cols.index_col))>
					<cfset keyCols[ArrayLen(keyCols)+1] = cols.index_col>
                </cfif>
			</cfloop>
			<cfif ArrayLen(keyCols)>
				<cfset keys[CurrentRow] = ArrayToList(keyCols)>
			</cfif>
            <cfdump var="#keys#"><br />
		</cfloop>
        <cfabort>
        <cfquery datasource="#url.ds#" name="AlternativeKey">
			SELECT keycnt, indid
			FROM   sysindexes
			WHERE  id = object_id( <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#"> )
			  AND indid > 0
			  AND status2 & 2 = 2
              and status < 2048
			ORDER BY indid
		</cfquery> --->



	<cfquery datasource="#url.dsn#" name="indices">
		exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">
	</cfquery>
    <!--- En sybase siempre va venir de primero el PK (esto asume que toda tabla tiene llave primaria) --->
	<cfset pk=Replace(indices.index_keys,' ','','all')>
	<cfset ak=Replace(ValueList(indices.index_keys),' ','','all')>
<cfelseif dbtype is 'sqlserver'>
	<cfquery datasource="#url.dsn#" name="indices">
		exec sp_helpindex <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#">
	</cfquery>
	<cfset pk = ''>
	<cfset ak = ''>
	<cfloop query="indices">
		<cfset ak = ListAppend(ak,Replace(indices.index_keys,' ','','all'))>
		<cfif findnocase("primary key",indices.index_description)>
			<!--- primary key --->
			<cfset pk = ListAppend(pk,Replace(indices.index_keys,' ','','all'))>
		</cfif>
	</cfloop>
<cfelseif dbtype is 'db2'>
	<cfquery datasource="#url.dsn#" name="indices">
		select UNIQUERULE, INDNAME, COLNAMES
			from SYSCAT.INDEXES
		where lower(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(url.tabla)#">
		order by UNIQUERULE, INDNAME, IID
	</cfquery><!--- <cfdump var="#indices#"> --->

	<cfset pk = ''>
	<cfset ak = ''>
	<cfloop query="indices">
		<cfif indices.UNIQUERULE is 'U'>
			<cfset ak = ListAppend(ak,Trim(indices.COLNAMES))>
		<cfelseif indices.UNIQUERULE is 'P'>
			<!--- primary key --->
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

<form name="form1" method="get" action="PBitacora.cfm" onSubmit="return validar(this);">
<table  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="4" class="subTitulo"> Selecci&oacute;n de una nueva tabla </td>
    </tr>
  <tr>
    <td width="159" valign="top">Buscar tabla </td>
    <td width="27" valign="top">&nbsp;</td>
    <td width="202" valign="top"><input name="tabla" id="tabla" type="text" value="#HTMLEditFormat(url.tabla)#" 
				maxlength="30"
				onfocus="this.select()"  >
    </td>
    <td width="202" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">Datasource para leer el metadato </td>
    <td valign="top">&nbsp;</td>
    <td valign="top">
      <select name="dsn">
	  <cfloop query="caches">
	  	<option value="#HTMLEditFormat(caches.cache)#" <cfif caches.cache is url.dsn>selected</cfif>>#HTMLEditFormat(caches.cache)#</option>
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
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><input type="submit" name="Submit" value="Continuar >>"></td>
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