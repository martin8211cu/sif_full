<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---El query que trae los numeros---->
<cfset ValuesArrayOT=ArrayNew(1)>
<cfquery name="rsProdOTcodigo" datasource="#session.DSN#">
    select OTcodigo,OTdescripcion
    from Prod_OT
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    order by OTcodigo
</cfquery>
<cfif rsProdOTcodigo.recordcount gt 0>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTcodigo.OTcodigo#')>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTcodigo.OTdescripcion#')>
</cfif>

<!---El query que trae los datos---->

<cfif isdefined("Session.Ecodigo") AND isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
	<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
		select OTcodigo, p.SNcodigo,s.SNnombre, OTdescripcion, OTfechaRegistro, OTfechaCompromiso, OTobservacion
		from Prod_OT p
        inner join SNegocios s on p.Ecodigo=s.Ecodigo and p.SNcodigo=s.SNcodigo
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and p.OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
	</cfquery>
</cfif>    
<cfoutput>
<form action="Consulta-OT.cfm" method="post" name="form1">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td align="right" nowrap><b>Orden de trabajo :</b>&nbsp;</td>
        <td>
         <cf_conlis
                Campos="OTcodigo,OTdescripcion"
                Desplegables="S,S"
                Modificables="S,S"
                Size="15,20"
                ValuesArray="#ValuesArrayOT#"
                Title="Orden de Trabajo"
                Tabla="Prod_OT"
                Columnas="OTcodigo,OTdescripcion"
                Filtro="Prod_OT.Ecodigo = #Session.Ecodigo# order by OTcodigo"
                Desplegar="OTcodigo,OTdescripcion"
                Etiquetas="Codigo,Descripcion"
                filtrar_por="OTcodigo,OTdescripcion"
                Formatos="S,S"
                Align="left,left"
                Asignar="OTcodigo,OTdescripcion"
                Asignarformatos="S,S"
                tabindex="1" />
        </td>
        <td align="right"><b>Cliente:</b>&nbsp;</td>
        <td>
			<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                "#rsProdOTDatos.SNnombre#"
            </cfif>
        </td>
      </tr>  
      <tr>
        <td align="right"><b>Desde:</b>&nbsp;</td>
        <td>
            <cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
              "#rsProdOTDatos.OTfechaRegistro#"
            </cfif> 
        </td>
        <td align="right"><b>Hasta:</b>&nbsp;</td>
        <td>
            <cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                "#rsProdOTDatos.OTfechaCompromiso#"
            </cfif> 
        </td>
      </tr> 
      <tr>
            <td align="right"><b>Descripcion OT:&nbsp;</b></td>
            <td>
				<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                  "#rsProdOTDatos.OTdescripcion#"
                </cfif>
            </td>
            <td align="right" colspan="2">  
                <input type="submit" name="Actualizar" value="Actualizar" onClick="javascript: return valida();">
            </td>
      </tr>
</table>           
</form>
</cfoutput>

