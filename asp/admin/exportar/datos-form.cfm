<!--- Consultas --->


<cfscript>
	 factory = CreateObject("java", "coldfusion.server.ServiceFactory");
	 ds_service = factory.datasourceservice;
   </cfscript> 
 
 <!--- obtiene los nombres de los datasources --->
 <cfset caches = ds_service.getNames()>
 
 <!--- obtiene un struct con la propiedades de los datasources
 <cfset ds = "#ds_service.getDataSources()#" > --->
 
	<cfset ArraySort( caches, 'textnocase', 'asc'  )>
	
 <cfparam name="url.ds" default="">
 <cfparam name="url.dbms" default="">
 <cfparam name="url.tabla" default="">
 <cfparam name="url.maxrows" default="">
 <cfset keys = ArrayNew(1)>
 <cfif len(url.tabla)>
	<cfset sourcedbtype = Application.dsinfo[url.ds].type>
	<cfif ListFind('sybase,sqlserver', sourcedbtype)>
		<cfquery datasource="#url.ds#" name="uniqueKeys">
			SELECT keycnt, indid
			FROM   sysindexes
			WHERE  id = object_id( <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tabla#"> )
			  AND indid > 0
			  <cfif sourcedbtype IS 'sybase'>
			  AND status2 & 2 = 2
			  <cfelseif sourcedbtype IS 'sqlserver'>
			  AND status & 64 = 0 <!--- statistics --->
			  AND status & ( 2 | 2048 | 4096 ) != 0 <!--- unique | primary key | unique key --->
			  <cfelse>
			  	<cfthrow message="DBMS no esperado: #sourcedbtype#">
			  </cfif>
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
					<cfset keyCols[ArrayLen(keyCols)+1] = cols.index_col></cfif>
			</cfloop>
			<cfif ArrayLen(keyCols)>
				<cfset keys[CurrentRow] = ArrayToList(keyCols)>
			</cfif>
		</cfloop>
	<cfelseif sourcedbtype is 'oracle'>
		<cfquery datasource="#url.ds#" name="getkeys">
			select i.column_name
			from user_constraints c join user_ind_columns i
			on c.index_name = i.index_name
			where c.table_name =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(UCase(url.tabla))#"> 
			and c.constraint_type = 'P'
			order by i.column_position
		</cfquery>
		<cfset keys[1] = ValueList(getkeys.column_name)>
	<cfelseif sourcedbtype is 'db2'>
		<cfquery datasource="#url.ds#" name="getkeys">
			select UNIQUERULE, INDNAME, COLNAMES
				from SYSCAT.INDEXES
			where lower(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(url.tabla)#">
			and UNIQUERULE in ('P','U')
			order by UNIQUERULE, INDNAME, IID
		</cfquery>
		
		<cfloop query="getkeys">
			<cfset keys[CurrentRow] =Replace(Mid(getkeys.COLNAMES, 2, LEN(getkeys.COLNAMES)-1),'+',',','all')>
		</cfloop>
	<cfelse>
		<cfthrow message="DBMS no soportado: #sourcedbtype#">
	</cfif>
 </cfif>
 
<cfoutput>
  <form action="datos-apply.cfm" method="post" name="form1"><input type="hidden" name="ds" id="ds" value="#HTMLEditFormat(url.ds)#">
<table width="45%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="17%" valign="top" nowrap><div align="center"></div></td>
    <td width="7%" valign="top" nowrap>&nbsp;</td>
    <td width="76%" valign="top" nowrap>&nbsp;</td>
  </tr>

	  <tr>
		<td colspan="3" valign="top" nowrap class="itemtit"><div align="center">Especifique la informaci&oacute;n que quiere extraer </div></td>
	  </tr>
	  <tr>
	    <td valign="top" nowrap>Destino</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><select name="dbms" id="dbms">
	      <option value="syb" <cfif url.dbms is 'syb'>selected</cfif>>Sybase</option>
	      <option value="ora" <cfif url.dbms is 'ora'>selected</cfif>>Oracle</option>
	      <option value="db2" <cfif url.dbms is 'db2'>selected</cfif>>DB2</option>
	      <option value="mss" <cfif url.dbms is 'mss'>selected</cfif>>MS SQL Server</option>
		</select></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>Tabla</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><input name="tabla" type="text" id="tabla" size="50" maxlength="30" value="#HTMLEditFormat(url.tabla)#" onFocus="this.select()"></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>MaxRows</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><input name="maxrows" type="text" id="maxrows" size="50" maxlength="8" value="#HTMLEditFormat(url.maxrows)#" onFocus="this.select()"></td>
      </tr>
	  <tr>
	    <td valign="top" nowrap>PrimaryKey </td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap>
		<cfif ArrayLen(keys)>
		<cfset primary_key = keys[1]>
			<cfloop from="1" to="#ArrayLen(keys)#" index="i">
			<input type="radio" id="key#i#" name="key" onClick="this.form.pk.value=this.value" value="#HTMLEditFormat(keys[i])#" <cfif i is 1>checked</cfif>>
			<label for="key#i#">#keys[i]#</label><br>
			</cfloop>
		<cfelse>
			<cfset primary_key = "">
		</cfif>
		<input type="radio" id="custkey" name="key"><label for="custkey">Otra: </label> 
		<input name="pk" type="text" id="pk" size="70" maxlength="60" value="#primary_key#" onFocus="this.select()" onkeydown="form.custkey.checked=true" onBlur="this.value=this.value.replace(/\s+/g,'')"></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><em>pkcampo1,pkcampo2,..</em></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><cfparam name="url.identity" default="1">
		<input name="identity" type="checkbox" id="identity" value="1" <cfif url.identity is 1>checked</cfif>>
		<label for="identity">
        Habilitar identity_insert on </label></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><cfparam name="url.identityfield" default="">
		<label for="identityfield">&nbsp;&nbsp;&nbsp;&nbsp;Para</label>
		<input name="identityfield" type="text" id="identityfield" size="30" onFocus="this.select()" value="#HTMLEditFormat(identityfield)#"></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><cfparam name="url.soloinsert" default="0">
		<input name="soloinsert" type="checkbox" id="soloinsert" value="1" <cfif url.soloinsert is 1>checked</cfif>>
        <label for="soloinsert">Solamente generar insert</label></td>
      </tr>
	  <tr>
	    <td valign="top" nowrap>Where (opcional)<br>
	      incluya la<br> 
	      palabra &quot;where&quot;</td>
	    <td valign="top" nowrap>&nbsp;</td>
	    <td valign="top" nowrap><textarea name="where" cols="40" rows="4" id="where" style="font-family:sans-serif"></textarea></td>
    </tr>
	  <tr>
	    <td valign="top" nowrap>&nbsp;</td>
		<td valign="top" nowrap>&nbsp;</td>
		<td valign="top" nowrap>
		    <div align="center">
		     <input name="exportar" type="submit" id="exportar" value="Exportar">
	        </div>
		</td>
	  </tr>
  <tr>
    <td valign="top" nowrap><div align="center"></div></td>
    <td valign="top" nowrap>&nbsp;</td>
    <td valign="top" nowrap>&nbsp;</td>
  </tr>
</table>
  </form>
  <script type="text/javascript">
  document.form1.pk.focus();
  </script>
</cfoutput>