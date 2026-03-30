<cfparam name="url.sec" default="026">
<cfparam name="url.num" default="096">

<cfquery name="rs" datasource="asp">
    select distinct p2.parche
        from APParche p
        inner join APFuente f
         on p.parche=f.parche
        inner join APFuente f2
         on f.nombre=f2.nombre 
         and f.revision>f2.revision 
        inner join APParche p2
          on p2.parche=f2.parche 
      where p.pnum='#url.sec#'  and p.psec='#url.num#'
    order by p2.nombre desc
</cfquery> 

<cf_templatecss>

<table class="reporte">
  <tr>
    <th colspan="2">Parches dependientes del <cfoutput>#url.sec#_#url.num#</cfoutput></th> 
  </tr>
  <cfset cont=1>
  <cfoutput query="rs">
      <tr>
        <cfset y= getInfo(parche)>  
        <td nowrap="nowrap" >#y.title#</td>
        <td nowrap="nowrap" >#y.autor#</td>
        <td>#y.descripcion#</td>
      </tr>
  </cfoutput>
</table> 
<cffunction name="getInfo" returntype="struct">
  <cfargument name="parche" type="string">
  <cfset x=structNew()>
 <cfquery name="rsInfo" datasource="asp">
    select p.descripcion, p.nombre, p.autor
    from APParche p
    where p.parche=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parche#">
</cfquery> 
  <cfset x.title=rsInfo.nombre>
  <cfset x.descripcion=rsInfo.descripcion>
  <cfset x.autor=rsInfo.autor>
  <cfreturn x>
</cffunction>
