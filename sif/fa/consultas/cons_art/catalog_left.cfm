<cfparam name="url.cat" default="#session.comprar_cat#">
<cfparam name="url.s" default="">
<cfquery datasource="#session.dsn#" name="categorias" >
set rowcount 200
	select c.Ccodigo, c.Cdescripcion
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif url.cat>
	  and c.Ccodigopadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	<cfelse>
	  and c.Ccodigopadre is null
	</cfif>
	order by case when c.Ccodigo = 0 then 0 else 1 end, c.Cpath, c.Cdescripcion
set rowcount 0
</cfquery>
<cfif categorias.RecordCount is 0 and url.cat>
<cfquery datasource="#session.dsn#" name="categorias" >
set rowcount 200
	select hermanos.Ccodigo, hermanos.Cdescripcion
	from Clasificaciones c
		join Clasificaciones hermanos
			on hermanos.Ecodigo = c.Ecodigo
			and hermanos.Ccodigopadre = c.Ccodigopadre
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	<cfif url.cat>
	  and c.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	</cfif>
	order by case when hermanos.Ccodigo = 0 then 0 else 1 end, hermanos.Cpath, hermanos.Cdescripcion
set rowcount 0
</cfquery>
</cfif>
<form action="catsearch.cfm" method="get" style="margin:0 ">
  <table cellspacing="0" cellpadding="2" width="180" class="catview_table">
  <tr><td width="148" class="catview_thinv"><b>Buscar</b></td></tr>
  <tr>
        <td><select name="cat">
		<option value="0">Todas</option>
          <cfoutput query="categorias">
		  	<cfif Ccodigo neq 0>
            <option value="#Ccodigo#" <cfif url.cat EQ Ccodigo>selected</cfif> >
			  #Cdescripcion#</option></cfif>
          </cfoutput>
        </select></td>
        </tr>
      <tr>
        <td><input name="s" type="text" id="s" size="10" onFocus="select()" value="<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>" >        <input type="submit" name="Submit" value="Buscar" style="font-size:xx-small;"></td>
        </tr>
  </table>
</form>
<div style="height:12px"></div>
<table cellspacing="0" cellpadding="2" width="180" border="0" class="catview_table">
  <tr>
    <td width="150" class="catview_thinv"><b>Categor&iacute;as</b></td>
  </tr>
  <cfoutput query="categorias">
  <tr>
    <td >
    <a href="index.cfm?cat=#Ccodigo#" <cfif Ccodigo is url.cat>style="font-weight:bold"</cfif> ><cfif Ccodigo>
  	  #Cdescripcion#<cfelse>
	  Todas</cfif></a>
    </td>
  </tr></cfoutput>
</table>
