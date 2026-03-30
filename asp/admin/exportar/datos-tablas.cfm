<cfscript>
	 factory = CreateObject("java", "coldfusion.server.ServiceFactory");
	 ds_service = factory.datasourceservice;
</cfscript> 
 
 <!--- obtiene los nombres de los datasources --->
 <cfset caches = ds_service.getNames()>
 <cfset ArraySort( caches, 'textnocase', 'asc'  )>

<cfparam name="url.fTabla" 		default="">
<cfparam name="url.ds" 			default="">
<cfparam name="url.ord" 		default="a">
<cfparam name="url.dbms" 		default="syb">
<cfparam name="url.identity" 	default="1">
<cfparam name="url.soloinsert" 	default="">

<cfif ListFind('a,d,s',url.ord) is 0>
	<cfset url.ord = 'a'>
</cfif>

<cfif Len(url.fTabla) and len(url.ds)>
	<cfset sourcedbtype = Application.dsinfo[url.ds].type>
	<cfif url.ord is 'a'>
	
	<cfquery datasource="#url.ds#" name="tablas">
		<cfif ListFind('sybase,sqlserver', sourcedbtype)>
				select name, 0 as depth from sysobjects
				where upper(name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
				  and type = 'U'
				order by upper(name)
		<cfelseif sourcedbtype is 'oracle'>
				select tname as name, 0 as depth from sys.tab
				where upper(tname) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
				  and tabtype = 'TABLE'
				order by upper(tname)
		<cfelseif sourcedbtype is 'db2'>
			select TABNAME as name, 0 as depth from SYSCAT.TABLES 
			 where TYPE = 'T'
		       and upper(TABNAME) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
		    order by TABNAME
		<cfelse>
			<cfthrow message="DBMS no soportado: #sourcedbtype#">
		</cfif>
	</cfquery>
		<!--- fin 'a' --->
	<cfelseif url.ord is 'd'>
		<!--- filtrar con dependencias --->
		<cfif ListFind('sybase,sqlserver', sourcedbtype)>
			<cfquery datasource="#url.ds#" name="tablas">
				create table ##t (id int, name varchar(30), orden int)
				while (1=1) begin
				
					insert ##t
					select id, name, (select coalesce (max(orden), 0) + 1 from ##t)
					from sysobjects o
					where o.type = 'U'
					  and upper(o.name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
					  and id not in (select id from ##t)
					  and not exists (
						select 1
						from sysreferences c
						where c.tableid = o.id
						  and c.reftabid not in (select id from ##t))
					if @@rowcount = 0 break
				end
				
				select name, orden as depth from ##t
				order by orden, upper(name)
				drop table ##t
			</cfquery>
			<!--- fin 'd'.sybase --->
		<cfelseif sourcedbtype is 'oracle'>
			<cfset tablas = QueryNew('name,depth')>
			<cfloop from="0" to="99" index="depth">
				<cfquery datasource="#url.ds#" name="addtab">
					select tname from sys.tab a
					where tabtype = 'TABLE'
					  and upper(tname) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
					  <cfif tablas.RecordCount>
					  and tname not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(tablas.name)#" list="yes">)
					  </cfif>
					  and not exists (
						select 1
						from user_constraints c1 join user_constraints c2
						  on c1.owner = c2.owner and c1.r_constraint_name = c2.constraint_name
						where c1.owner = 'ASP_ORACLE'
						  and c1.table_name = a.tname
						  <cfif tablas.RecordCount>
						  and c2.table_name not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(tablas.name)#" list="yes">)
						  </cfif>
						  and c1.constraint_type = 'R'		  
					  )
					  order by upper(tname)
				</cfquery>
				<cfif addtab.RecordCount Is 0><cfbreak></cfif>
				<cfloop query="addtab">
					<cfset QueryAddRow(tablas)>
					<cfset tablas.name = addtab.tname>
					<cfset tablas.depth = depth></cfloop>
				<!---
				<cfdump var="#addtab#" label="addtab">
				<cfdump var="#tablas#" label="tablas">--->
			</cfloop>
			<!--- fin 'd'.oracle --->
		<cfelse>
			<cfthrow message="DBMS no soportado: #sourcedbtype#">
		</cfif>
		<!--- fin 'd' --->
	<cfelseif url.ord is 's'>
		<!--- subarbol con dependencias --->
		<cfif ListFind('sybase,sqlserver', sourcedbtype)>
			<cfquery datasource="#url.ds#" name="tablas">
				declare @depth int
				select @depth = 0
				create table ##t (id int, name varchar(30), path varchar(255), depth int)
				insert ##t
				select id, name, name, @depth
				from sysobjects o
				where o.type = 'U'
				  and upper(o.name) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
					  
				while (@depth < 30) begin
					select @depth = @depth + 1
					insert ##t
					select o.id, 
						   o.name, 
						   {fn concat({fn concat(##t.path, '/')}, o.name)}, 		<!--- ##t.path || '/' || o.name, --->
						   @depth
					from sysobjects o
						join sysreferences c
							on c.reftabid = o.id
						join ##t
							on c.tableid = ##t.id
					where o.type = 'U'
					  and o.id not in (select id from ##t)
					if @@rowcount = 0 break
				end
				
				select name, depth from ##t
				order by upper(path)
				drop table ##t
			</cfquery>
			<!--- fin 's'.sybase --->
		<cfelseif sourcedbtype is 'oracle'>
			<!--- esta igual que 'd'.oracle --->
			<cfset tablas = QueryNew('name')>
			<cfloop from="0" to="99" index="depth">
				<cfquery datasource="#url.ds#" name="addtab">
					select tname from sys.tab a
					where tabtype = 'TABLE'
					  and upper(tname) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.fTabla)#%">
					  <cfif tablas.RecordCount>
					  and tname not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(tablas.name)#" list="yes">)
					  </cfif>
					  and not exists (
						select 1
						from user_constraints c1 join user_constraints c2
						  on c1.owner = c2.owner and c1.r_constraint_name = c2.constraint_name
						where c1.owner = 'ASP_ORACLE'
						  and c1.table_name = a.tname
						  <cfif tablas.RecordCount>
						  and c2.table_name not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(tablas.name)#" list="yes">)
						  </cfif>
						  and c1.constraint_type = 'R'		  
					  )
					  order by upper(tname)
				</cfquery>
				<cfif addtab.RecordCount Is 0><cfbreak></cfif>
				<cfloop query="addtab">
					<cfset QueryAddRow(tablas)>
					<cfset tablas.name = addtab.tname>
					<cfset tablas.depth = depth></cfloop>
				<!---
				<cfdump var="#addtab#" label="addtab">
				<cfdump var="#tablas#" label="tablas">--->
			</cfloop>
			<!--- fin 's'.oracle --->
		<cfelse>
			<cfthrow message="DBMS no soportado: #sourcedbtype#">
		</cfif>
		<!--- fin 's' --->
	</cfif>
    <cfparam name="url.tabla" default="#tablas.name#">
</cfif>

	<cfoutput>
	<form method="get" action="" id="filtro" name="filtro" onSubmit="copyvalues()">
	<input type="hidden" name="dbms" value="#HTMLEditFormat(url.dbms)#">
	<input type="hidden" name="identity" value="#HTMLEditFormat(url.identity)#">
	<input type="hidden" name="soloinsert" value="#HTMLEditFormat(url.soloinsert)#">
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" class="subTitulo">Buscar Tablas </td>
    </tr>
  <tr>
    <td>Datasource</td>
    <td><select name="ds" id="ds">
      <cfloop from="1" to="#ArrayLen(caches)#" index="i">
          <option value="#caches[i]#" <cfif url.ds is caches[i]>selected</cfif>>#caches[i]#</option>
      </cfloop>
    </select></td>
  </tr>
  <tr>
    <td>Tabla</td>
    <td><input type="text" name="fTabla" id="fTabla" value="#HTMLEditFormat(url.fTabla)#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td>Modo</td>
    <td><select name="ord" id="ord">
	<option value="a" <cfif url.ord is 'a'>selected</cfif> >Alfab&eacute;tico</option>
	<option value="d" <cfif url.ord is 'd'>selected</cfif> >Dependencias</option>
	<option value="s" <cfif url.ord is 's'>selected</cfif> >Sub&aacute;rbol</option>
	</select></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="g" type="submit" id="g" value="Buscar"></td>
  </tr>
</table>
<cfparam name="url.tabla" default="">
<cfif IsDefined("tablas") and tablas.RecordCount gt 0>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr class="tituloListas">
    <td>Tablas (#tablas.RecordCount#)</td>
  </tr></table><div style="width:100%;height:200px;overflow:auto">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
<cfloop query="tablas">
  <tr class="<cfif tablas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
    <td style="text-indent:0;<cfif url.tabla is tablas.name>font-weight:bold;</cfif>" >
	<a name="tabla#HTMLEditFormat(tablas.name)#" href="javascript:sel('#JSStringFormat(url.ds)#','#JSStringFormat(tablas.name)#')">
	#RepeatString('&nbsp;', tablas.depth*2+1)##tablas.name#</a></td>
  </tr></cfloop>
</table></div></cfif>
	</form>
<script type="text/javascript">
function sel(ds,tabla){
	location.href = "datos.cfm?ds=" + escape(ds) +
		"&tabla=" + escape(tabla) +
		"&fTabla=#URLEncodedFormat(url.fTabla)#" +
		"&ord=" + escape(document.filtro.ord.value) +
		"&dbms=" + escape(document.form1.dbms.value) +
		"&identity=" + (document.form1.identity.checked?1:0) +
		"&soloinsert=" + (document.form1.soloinsert.checked?1:0) +
		"##tabla" + escape(tabla);
	}
function copyvalues(){
	document.filtro.dbms.value = document.form1.dbms.value;
	document.filtro.identity.value = document.form1.identity.checked?1:0;
	document.filtro.soloinsert.value = document.form1.soloinsert.checked?1:0;
	return true;
}
</script>
</cfoutput>
