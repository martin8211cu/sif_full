<cfif isdefined('url.OTcodigo') and not isdefined("form.OTcodigo") >
	<cfset form.OTcodigo = url.OTcodigo>
</cfif>   

	<cfquery name="rsProdOTinfo" datasource="#Session.DSN#">
        select p.OTcodigo,a.APDescripcion,p.OTseq, p.Artid,Pentrada,Psalida, coalesce(Pmerma,0) as Pmerma ,r.AAconsecutivo
        from Prod_Inventario p
        inner join Prod_Proceso c on c.Ecodigo=p.Ecodigo and p.OTcodigo=c.OTcodigo and p.OTseq=c.OTseq
        inner join Prod_Area a on p.Ecodigo=a.Ecodigo and c.APcodigo=a.APcodigo 
        inner join Prod_insumo i on i.Ecodigo=p.Ecodigo and i.Artid=p.Artid and i.OTseq=c.OTseq and i.OTcodigo=p.OTcodigo
        inner join Prod_OTArchivo r on r.Ecodigo=p.Ecodigo and r.OTcodigo=p.OTcodigo and r.AAdefaultpre = 1
        where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> and
        <cfif isDefined("Form.Actualizar")>
        	  p.OTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#"> and
        </cfif>              
        i.MPseguimiento=<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
        order by p.OTcodigo,p.OTseq
    </cfquery>

<cfset Titulo = "Consulta-OT">
<cf_templateheader title="Consulta-OT">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="19%"><cfinclude template="formConsulta-OT.cfm"></td>
			</tr>
				<cfoutput>
                <table width="70%">
                	<cfloop query="rsProdOTinfo">
					<tr>
						<td><b>#rsProdOTinfo.OTcodigo#</b></td>
                        <td colspan="4"></td>
                        <td rowspan="4">
                            <img id="IMAGEN" 
                            src="../Registro/img_ot.cfm?o=#htmleditformat(rsProdOTinfo.OTcodigo)#&t=#rsProdOTinfo.AAconsecutivo#"
                            width="122" height="78" />
                        </td>
                    </tr>
                 	<tr>
                     	<td>&nbsp;</td>
       					<td width="20%"><b>Area</b></td>
                        <td width="16%"><p><b>Cantidad <br/>Recibida</b></p></td>
                        <td width="15%"><p><b>Cantidad <br/>Liberada</b></p></td>
                        <td width="30%"><b>Merma</b></td>
                	</tr>
					<cfset Totalentrada = 0>
                    <cfset OTcod =#rsProdOTinfo.OTcodigo#>
                    <cfloop query="rsProdOTinfo">
                    	<cfif #OTcod# eq #rsProdOTinfo.OTcodigo#>
                        <tr height="30px">
                            <td>&nbsp;</td>
                            <td>#rsProdOTinfo.APDescripcion#</td>
                            <td>#rsProdOTinfo.Pentrada#</td>
                            <td>#rsProdOTinfo.Psalida#</td>
                            <td>#rsProdOTinfo.Pmerma#</td>
                            <cfset Totalentrada = Totalentrada+#rsProdOTinfo.Pmerma#>
                        </tr>
                        </cfif>
                    </cfloop>
                     </tr>
                            <td colspan="3">&nbsp;</td>
                            <td align="left"><b>Total:</b></td>
                            <td>#Totalentrada#</td>
                      </tr>
                    </cfloop>
                </table>
                </cfoutput>
<!---                    </cfif>
---> 
			</tr>
		</table>	
        
        	   
	<cf_web_portlet_end>
<cf_templatefooter>
