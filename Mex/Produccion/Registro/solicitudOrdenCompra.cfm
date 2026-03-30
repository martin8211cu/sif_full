<cfif isdefined('url.OTcodigo') and not isdefined("form.OTcodigo") >
	<cfset form.OTcodigo = url.OTcodigo>
</cfif>   

<cfquery name="rsProdCliente" datasource="#Session.DSN#">
    select p.OTcodigo as OTSelcodigo,<!---s.SNcodigo as SNSelcodigo,---> s.SNnombre as SNSelnombre
    from Prod_OT p
    inner join SNegocios s on p.Ecodigo=s.Ecodigo and p.SNcodigo=s.SNcodigo
    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND #form.OTcodigo# GT 0>
		and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>
<cfif isdefined("form.SNcodigo") AND #form.SNcodigo# GT 0>
		and p.SNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SNcodigo#">
</cfif>	
    order by p.OTcodigo, p.SNcodigo 
</cfquery>

<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 AND isdefined("form.SNcodigo") AND Len(Trim(form.SNcodigo)) GT 0>
<!---	<cfquery name="rsProdDetProceso" datasource="#Session.DSN#">
    	select p.OTcodigo,s.SNnombre,p.OTseq,a.APinterno,r.AAconsecutivo,
        <cfif #form.OTseq# gt 1>
        	(select ar.APDescripcion 
            	from Prod_Proceso pr                
            	inner join Prod_Area ar on pr.Ecodigo=ar.Ecodigo and pr.APcodigo=ar.APcodigo
                where pr.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        				and	pr.OTseq=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OTseq#-1">)
        	 as APDescripcion
        <cfelse>
        	''	as APDescripcion
        </cfif>
        from Prod_Proceso p
        inner join Prod_OT o on o.Ecodigo=p.Ecodigo and o.OTcodigo=p.OTcodigo
        inner join SNegocios s on p.Ecodigo=s.Ecodigo and o.SNcodigo=s.SNcodigo
        inner join Prod_Area a on p.Ecodigo=a.Ecodigo and p.APcodigo=a.APcodigo
        inner join Prod_OTArchivo r on r.Ecodigo=p.Ecodigo and r.OTcodigo=p.OTcodigo and r.AAdefaultpre = 1
        where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        	and	p.OTseq=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OTseq#">
            and p.OTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
    </cfquery>
--->
</cfif>

<cfparam name="form.MaxRows" default="15">

<cfset Titulo = "Generación de Solicitud de Compra">
<cf_templateheader title="Monitoreo">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bordercolor="red">
			<tr>
				<td width="19%"><cfinclude template="../Registro/formGeneraOC.cfm"></td>
			</tr>
        </table>
		<cfoutput>
        <cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0>
        	<table width="100%" cellspacing="0" cellpadding="0" border="1" bordercolor="blue">
            <tr>
                <td valign="top">
                    <form action="solicitudOrdenCompra.cfm" method="post" name="form2">
                    <input type="hidden" name="OTCodigo" value= "#Form.OTcodigo#" />
                    <input type="hidden" name="SNcodigo" value="#Form.SNcodigo#"/>
                    
                    <table width="30%" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                             <td align="center"><strong>Orden Trabajo</strong></td>
                             <td></td>
                             <td align="center"><strong>Cliente</strong></td>
                        </tr>
                        <cfloop query="rsProdCliente">
                            <tr>
                                <td align="left" class="pStyle_Ddocumento" nowrap  onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsProdCliente.OTSelcodigo#                                   
                                    <input type="hidden" name= "OTSelcodigo#CurrentRow#" value= "#rsProdCliente.OTSelcodigo#" />
                                </td>
                                <td>
                                    <input type="checkbox" name="chk#CurrentRow#" style="border:none; background-color:inherit;" 
                                    <cfif isdefined("form.chk#CurrentRow#")>checked</cfif>>
                                </td>
                                <td align="left" class="pStyle_Ddocumento" nowrap  onmouseover="javascript:  window.status = '';  return true;" onmouseout="javascript:  window.status = '';  return true;">#rsProdCliente.SNSelnombre#                               
<!---                                    <input type="text" name= "SNSelnombre#CurrentRow#" value= #rsProdCliente.SNSelnombre# readonly="readonly" />
--->                                
                                </td>
                            </tr>
                        </cfloop>          
                        <tr>
                            <td align="center" colspan="3">  
                                <input type="submit" name="Seleccionar" value="Seleccionar">
                            </td>
                        </tr>
                    </table>
                    </form>
                </td>
            	<td valign="top"><cfinclude template="../Registro/formArticulosOC.cfm"></td>
        </table>
        </cfif>
        </cfoutput>
	<cf_web_portlet_end>
<!---<cf_templatefooter>
--->
