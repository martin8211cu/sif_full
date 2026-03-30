<!---El query que trae los datos---->
<cfset ValuesArrayOT=ArrayNew(1)>
<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
   	select OTcodigo, OTdescripcion
    from Prod_OT
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0>
		and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>order by OTcodigo
</cfquery>
<cfif rsProdOTDatos.recordcount gt 0>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTcodigo#')>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTdescripcion#')>
</cfif>

<cfset ValuesArrayArea=ArrayNew(1)>
<cfquery name="rsAreaDatos" datasource="#Session.DSN#">
    select APcodigo, APdescripcion
    from Prod_Area
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.APcodigo") AND Len(Trim(form.APcodigo)) GT 0>
		and APcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.APcodigo#">
</cfif>	
    order by APcodigo
</cfquery>
<cfif rsAreaDatos.recordcount gt 0>
    <cfset ArrayAppend(valuesArrayArea,'#rsAreaDatos.APcodigo#')>
    <cfset ArrayAppend(valuesArrayArea,'#rsAreaDatos.APdescripcion#')>
</cfif>

<cfquery name="rsProdStatus" datasource="#Session.DSN#">
   	select distinct OTstatus
    from Prod_Proceso
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0>
		and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>
    order by OTstatus
</cfquery>

<cfoutput>

<form action="Monitoreo-OT.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr> 
			<td nowrap><b>Orden de trabajo:&nbsp;</b></td>
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
			<td nowrap><b>Area de trabajo:&nbsp;</b></td>
            <td>
             <cf_conlis
					Campos="APcodigo,APdescripcion"
					Desplegables="S,S"
					Modificables="S,S"
					Size="15,20"
					ValuesArray="#ValuesArrayArea#"
					Title="Area de Trabajo"
					Tabla="Prod_Area"
					Columnas="APcodigo,APdescripcion"
					Filtro="Prod_Area.Ecodigo = #Session.Ecodigo# order by APcodigo"
					Desplegar="APcodigo,APdescripcion"
					Etiquetas="Codigo,Descripcion"
					filtrar_por="APcodigo,APdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="APcodigo,APdescripcion"
					Asignarformatos="S,S"
					tabindex="2" />
            </td>
			<td nowrap><b>Status:&nbsp;</b></td>
            <td>
                <select name="ProdStatus" id="ProdStatus" tabindex="3">
                    <cfloop query="rsProdStatus">
                    	<option value="#rsProdStatus.OTstatus#"> #rsProdStatus.OTstatus# </option>
                    </cfloop>
                </select>
            </td>
      	</tr>
        <tr>
            <td><b>Desde:&nbsp;</b></td>
            <td>
                <cfset fecha = createdate(year(now()),month(now()),1)>
                <cfset fecha = "#LSDateFormat(fecha,'dd/mm/yyyy')#">
                <cf_sifcalendario name="OTfechaDesde"  value = "#fecha#" tabindex="2">
            </td>
            <td><b>Hasta:&nbsp;</b></td>
            <td>
				<cfset fecha = "#LSDateFormat(Now(),'dd/mm/yyyy')#">
                <cf_sifcalendario name="OTfechaHasta"  value = "#fecha#" tabindex="4">
            </td>
			<td align="right" colspan="3">  
            	<input type="submit" name="Buscar" value="Buscar">
          	</td>
        </tr>
	</table>           
</form>
</cfoutput>

