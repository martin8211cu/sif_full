<!---El query que trae los datos---->
<cfset ValuesArrayOT=ArrayNew(1)>
<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
   	select OTcodigo, OTdescripcion
    from Prod_OT
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 AND #form.OTcodigo# neq "-1">
		and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>
order by OTcodigo
</cfquery>
<cfif rsProdOTDatos.recordcount gt 0>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTcodigo#')>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTdescripcion#')>
</cfif>

<cfset ValuesArrayClientes=ArrayNew(1)>
<cfquery name="rsClientes" datasource="#Session.DSN#">
    select distinct s.SNcodigo, s.SNnombre
    from Prod_OT p
    inner join SNegocios s on p.Ecodigo=s.Ecodigo and p.SNcodigo=s.SNcodigo
    where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.SNcodigo") AND Len(Trim(form.SNcodigo)) GT 0 AND "#form.SNcodigo#" neq "-1">
		and p.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
</cfif>
	order by s.SNcodigo
</cfquery>
<cfif rsClientes.recordcount gt 0>
    <cfset ArrayAppend(ValuesArrayClientes,'#rsClientes.SNcodigo#')>
    <cfset ArrayAppend(ValuesArrayClientes,'#rsClientes.SNnombre#')>
</cfif>

<cfoutput>

<form action="solicitudOrdenCompra.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr> 
			<td nowrap><strong>Orden de trabajo:&nbsp;</strong></td>
            <td>
                <select name="OTcodigo">
                    <option value="-1">--- Todos ---</option>
                    <cfloop query="rsProdOTDatos">
                        <option value="#rsProdOTDatos.OTcodigo#" <cfif isdefined("form.OTcodigo") and form.OTcodigo eq rsProdOTDatos.OTcodigo>selected</cfif> >#rsProdOTDatos.OTcodigo# #rsProdOTDatos.OTdescripcion#</option>
					</cfloop>
                </select>
<!---             <cf_conlis
					Campos="OTcodigo,OTdescripcion"
					Desplegables="S,S"
					Modificables="S,S"
					Size="15,30"
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
--->            
			</td>
			<td nowrap><strong>Cliente:&nbsp;</strong></td>
            <td>
                <select name="SNcodigo">
                    <option value="-1">--- Todos ---</option>
                    <cfloop query="rsClientes">
                        <option value="#rsClientes.SNcodigo#" <cfif isdefined("form.SNcodigo") and form.SNcodigo eq rsClientes.SNcodigo>selected</cfif>>#rsClientes.SNnombre#</option>
					</cfloop>
                </select>
            
<!---             <cf_conlis
					Campos="SNcodigo, SNnombre"
					Desplegables="S,S"
					Modificables="S,S"
					Size="3,30"
					ValuesArray="#ValuesArrayClientes#"
					Title="Cliente"
					Tabla="Prod_OT,SNegocios"
					Columnas="Prod_OT.SNcodigo, SNnombre"
					Filtro="Prod_OT.Ecodigo = #Session.Ecodigo# and Prod_OT.SNCodigo=SNegocios.SNCodigo and Prod_OT.Ecodigo=SNegocios.Ecodigo order by Prod_OT.SNCodigo"
					Desplegar="SNcodigo, SNnombre"
					Etiquetas="Codigo,Nombre"
					filtrar_por="SNcodigo,SNnombre"
					Formatos="I,S"
					Align="center,left"
					Asignar="SNcodigo, SNnombre"
					Asignarformatos="I,S"
					tabindex="2" />
--->         
   
			</td>
			<td align="right">  
            	<input type="submit" name="Buscar" value="Buscar">
          	</td>
        </tr>
	</table>           
</form>
</cfoutput>

