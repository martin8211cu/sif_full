<cfif isdefined("url.snTipo") and not isdefined("form.snTipo")>
	<cfparam name="form.snTipo" default="#url.snTipo#">
</cfif>
<cfif isdefined("url.snEstado") and not isdefined("form.snEstado")>
	<cfparam name="form.snEstado" default="#url.snEstado#">
</cfif>
<cfif isdefined("url.snE") and not isdefined("form.snE")>
	<cfparam name="form.snE" default="#url.snE#">
</cfif>
<cfif isdefined("url.snD") and not isdefined("form.snD")>
	<cfparam name="form.snD" default="#url.snD#">
</cfif>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">




<cfquery name="snreporte" datasource="#session.DSN#">

	<cfif form.snE EQ "all">
        select distinct 
            sn.SNidentificacion, sn.SNnombre, sn.SNtelefono,sn.SNFax,sn.SNemail, ds.atencion, sne.SNCEdescripcion,snd.SNCDdescripcion,
			case when sn.SNtipo = 'E' then 'Internacional' else 'Nacional' end as SNtipo
        from
            SNegocios sn left join DireccionesSIF ds on sn.id_direccion =ds.id_direccion
            left outer join SNClasificacionSN as snc on snc.SNid=sn.SNid
            left join SNClasificacionD as snd on snd.SNCDid=snc.SNCDid
            left join SNClasificacionE as sne on sne.SNCEid = snd.SNCEid
        where sn.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
    <cfelse>
        select distinct 
            sn.SNidentificacion, sn.SNnombre, sn.SNtelefono,sn.SNFax,sn.SNemail, ds.atencion, sne.SNCEdescripcion,snd.SNCDdescripcion, 
			case when sn.SNtipo = 'E' then 'Internacional' else 'Nacional' end as SNtipo
        from
            SNegocios sn left join DireccionesSIF ds on sn.id_direccion =ds.id_direccion
            inner join SNClasificacionSN as snc on snc.SNid=sn.SNid
            inner join SNClasificacionD as snd on snd.SNCDid=snc.SNCDid
            inner join SNClasificacionE as sne on sne.SNCEid = snd.SNCEid
        where sn.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
    </cfif> 

	  <cfif #form.snTipo# eq "N">
       	and sn.SNtipo<>'E' 
        
      <cfelseif #form.snTipo# eq "E">
        and sn.SNtipo='E' 
      <cfelse>
         and sn.SNtipo<>''
      </cfif>
 
	<cfif #form.snEstado# NEQ "all">
		and 
        sn.SNinactivo=#form.snEstado#  
    </cfif>
    <cfif form.snE NEQ "all">
    	and sne.SNCEid=#form.snE#
        <cfif form.snD NEQ "all">
        	and snd.SNCDid=#form.snD#
        </cfif>
    </cfif>
    order by sne.SNCEdescripcion,sn.SNnombre, sn.SNidentificacion
</cfquery>

<cf_templatecss>

<cf_sifHtml2Word>
    <cfinclude template="socios-formInc.cfm">
</cf_sifHtml2Word>
