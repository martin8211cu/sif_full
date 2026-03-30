<cfif isdefined('url.OTcodigo') and not isdefined("form.OTcodigo") >
	<cfset form.OTcodigo = url.OTcodigo>
</cfif>   

<cfquery name="rsProdOTinfo" datasource="#Session.DSN#">
    select p.OTcodigo,a.APDescripcion,p.OTseq, p.Artid,Pentrada,Psalida,coalesce(Pmerma,0) as Pmerma
    from Prod_Inventario p
    inner join Prod_Proceso c on c.Ecodigo=p.Ecodigo and p.OTcodigo=c.OTcodigo and p.OTseq=c.OTseq
    inner join Prod_Area a on p.Ecodigo=a.Ecodigo and c.APcodigo=a.APcodigo 
<!---    inner join Prod_insumo i on i.Ecodigo=p.Ecodigo and i.Artid=p.Artid and i.OTseq=c.OTseq and i.OTcodigo=p.OTcodigo
--->    
	where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    <cfif isDefined("Form.Actualizar")>
           and p.OTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
    </cfif>              
<!---    i.MPseguimiento=<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
--->    
	order by p.OTcodigo,p.OTseq
</cfquery>

<cfquery name="rsProdDetalle" datasource="#Session.DSN#">
    select p.OTcodigo,p.OTseq,a.APDescripcion,c.OTstatus,p.Artid,p.Pentrada, p.Psalida, p.Pexistencia
    from Prod_Inventario p
    inner join Prod_Proceso c on p.Ecodigo=c.Ecodigo and p.OTcodigo=c.OTcodigo and p.OTseq=c.OTseq
    inner join Prod_Area a    on a.Ecodigo=c.Ecodigo and a.APcodigo=c.APcodigo
    inner join Prod_OT o on p.Ecodigo=o.Ecodigo and p.OTcodigo=o.OTcodigo
    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0>
		and p.OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>
<cfif isdefined("form.APcodigo") AND Len(Trim(form.APcodigo)) GT 0>
		and c.APcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.APcodigo#">
</cfif>	
<cfif isdefined("form.ProdStatus") AND Len(Trim(form.ProdStatus)) GT 0>
		and c.OTstatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ProdStatus#">
</cfif>
<cfif isdefined("form.OTfechaDesde") AND isdefined("form.OTfechaHasta")>
	and o.OTfechaRegistro between #lsparsedatetime(form.OTfechaDesde)# and #lsparsedatetime(form.OTfechaHasta)#
</cfif>
    order by p.OTcodigo, p.OTseq 
</cfquery>

<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 AND isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
<!---	<cfdump var="#form#">  --->
	<cfquery name="rsProdDetProceso" datasource="#Session.DSN#">
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
</cfif>

<cfquery name="rsDatosPie" datasource="#Session.DSN#">
	select a.APDescripcion,count(*)as totales
	from Prod_Proceso p
    inner join Prod_Area a on p.Ecodigo=a.Ecodigo and p.APcodigo=a.APcodigo
    inner join Prod_OT o on o.Ecodigo=p.Ecodigo and o.OTcodigo=p.OTcodigo
    where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	<cfif isdefined("form.OTfechaDesde") AND isdefined("form.OTfechaHasta")>
		and o.OTfechaRegistro between #lsparsedatetime(form.OTfechaDesde)# and #lsparsedatetime(form.OTfechaHasta)#
	</cfif>
    group by a.APcodigo,a.APDescripcion
	order by a.APcodigo    

</cfquery>

<cfparam name="form.MaxRows" default="15">

<cfset Titulo = "Monitoreo">
<cf_templateheader title="Monitoreo">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bordercolor="red">
			<tr>
				<td width="19%"><cfinclude template="formMonitoreo-OT.cfm"></td>
			</tr>
		<cfoutput>
        <form name="form2" action="Monitoreo-OT.cfm" method="post" enctype="multipart/form-data">          
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bordercolor="red">
            <tr valign="top">
            	<td>
                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                    <cfinvokeargument name="query" 		value="#rsProdDetalle#"/>
                    <cfinvokeargument name="desplegar" 	value="OTcodigo,APDescripcion,OTstatus, Pentrada, Psalida, Pexistencia"/>
                    <cfinvokeargument name="etiquetas" 	value="C&oacute;digo,Area,Status,Producto Recibido,Producto en Proceso, Producto Terminado"/>
                    <cfinvokeargument name="formatos" 	value="V,V,V,I,I,I"/>
                    <cfinvokeargument name="align" 		value="center, center,center, center, center,center"/>
                    <cfinvokeargument name="ajustar" 	value="N"/>
                    <cfinvokeargument name="checkboxes" value="N"/>
                    <cfinvokeargument name="irA" 		value="Monitoreo-OT.cfm"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/> 
                    <cfinvokeargument name="formName" 			value="form2"/> 
                    <cfinvokeargument name="incluyeForm" 	value="false"/>              
                </cfinvoke>
                </td>
                <td>
                	<table width="100%" cellspacing="0" cellpadding="0" border="0" bordercolor="red">
                    	<tr align="center">
                        	<td colspan="3"><b>Detalle</b></td>
                            <td rowspan="4">
                               	<cfif isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
                                    <img id="IMAGEN" 
                                    src="../Registro/img_ot.cfm?o=#htmleditformat(rsProdDetProceso.OTcodigo)#&t=#rsProdDetProceso.AAconsecutivo#"
									width="122" height="78" />
                                </cfif>
                            </td>
                        </tr>
                    	<tr align="left">
                        	<td><b>Orden de Trabajo:&nbsp;</b></td>
                            <cfif isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
                            	<td>#rsProdDetProceso.OTcodigo#</td>
                            </cfif>
                        </tr>
                    	<tr align="left">
                        	<td><b>Cliente:&nbsp;</b></td>
                            <cfif isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
                            	<td>#rsProdDetProceso.SNnombre#</td>
                            </cfif>
                        </tr>
                    	<tr align="left">
                        	<td><b>Area Anterior:&nbsp;</b></td>
                            <cfif isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
                            	<td>#rsProdDetProceso.APDescripcion#</td>
                            </cfif>
                        </tr>
                        
                    	<tr align="left">
                        	<td><b>Externo:&nbsp;</b></td>
                            <cfif isdefined("form.OTseq") AND Len(Trim(form.OTseq)) GT 0>
                            	<cfif #rsProdDetProceso.APinterno# eq 1>
                                <td>NO</td>
                                <cfelse>
                            	<td>SI</td>
                                </cfif>
                            </cfif>
                        </tr>
                    	<tr>
                        	<td><b>Ordenes de Trabajo</b></td>
                        </tr>
                        <tr align="center">
                            <td colspan="4">
                                <cfchart
                                    format = "flash"
                                    chartwidth = "350"
                                    scalefrom = "0"
                                    scaleto = "0"
                                    showxgridlines = "yes"
                                    showygridlines = "yes"
                                    gridlines = "5"
                                    seriesplacement = "stacked"
                                    showborder = "no"
                                    font = "Arial"
                                    fontsize = "10"
                                    fontbold = "no"
                                    fontitalic = "no"
                                    labelformat = "number"
									sortxaxis = "no"
                                    show3d = "yes"
                                    rotated = "no"
                                    showlegend = "yes"
                                    tipstyle = "MouseOver"
                                    showmarkers = "yes"
                                    markersize = "50"
                                    pieslicestyle="sliced">
                                    <cfchartseries 
                                        type="pie" 
                                        query="rsDatosPie" 
                                        valuecolumn="totales" 
                                        itemcolumn="APDescripcion"
                                        colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
                                </cfchart>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            </table>
		</table>	
        </form>
        </cfoutput>
	<cf_web_portlet_end>
<!---<cf_templatefooter>
--->
