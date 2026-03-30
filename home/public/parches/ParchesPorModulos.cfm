<cfquery name="rs" datasource="asp">
    select distinct  p.parche,p.psec,p.pnum,rtrim(ltrim(c.SScodigo))+'_'+rtrim(ltrim(c.SMcodigo)) as cod,m.SMdescripcion from APParche p
        inner join APFuente f
         on p.parche=f.parche
        inner join  SComponentes c
            on '/'+f.nombre  = c.SCuri
        inner join SModulos m    
            on c.SMcodigo=m.SMcodigo
            and c.SScodigo=m.SScodigo
      where convert(numeric,pnum)>25
    order by cod,p.pnum,p.psec 
</cfquery>

<cf_templatecss>

<table class="reporte">
  <tr>
    <th>Parche</th>
    <th>Sec</th>
  </tr>
  <cfset cont=1>
  <cfoutput query="rs">
      <tr>
        <cfset y= getInfo(parche)>  
        <td nowrap="nowrap">#cod# - #SMdescripcion#</td>   
        <td width="200px">#y.title#</td>
        <td>#y.descripcion#</td>
      </tr>
  </cfoutput>
</table> 
<cffunction name="getInfo" returntype="struct">
  <cfargument name="parche" type="string">
  <cfset x=structNew()>
 <cfquery name="rsInfo" datasource="asp">
    select p.descripcion, p.nombre
    from APParche p
    where p.parche=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parche#">
</cfquery> 
  <cfset x.title=rsInfo.nombre>
  <cfset x.descripcion=rsInfo.descripcion>
  <cfreturn x>
</cffunction>
