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
<cfquery name="rsProdOTcodigo" datasource="#session.DSN#">
    select OTcodigo
    from Prod_OT
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    order by OTcodigo
</cfquery>

<!---El query que trae los datos---->
<cfset ValuesArray=ArrayNew(1)>
<cfif isdefined("Session.Ecodigo") AND isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
	<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
		select OTcodigo, p.SNcodigo,s.SNnombre,SNdireccion,SNidentificacion,OTdescripcion,OTobservacion
		from Prod_OT p
        inner join SNegocios s on p.Ecodigo=s.Ecodigo and p.SNcodigo=s.SNcodigo 
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and p.OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
       
	</cfquery>
    <cfif rsProdOTDatos.recordcount gt 0>
		<cfset ArrayAppend(valuesArray,'#rsProdOTDatos.OTcodigo#')>
        <cfset ArrayAppend(valuesArray,'#rsProdOTDatos.OTdescripcion#')>
        <cfset ArrayAppend(valuesArray,'#rsProdOTDatos.SNnombre#')>
    </cfif>
<cfelse>
    <cfset ArrayAppend(valuesArray,'')>
    <cfset ArrayAppend(valuesArray,'')>
    <cfset ArrayAppend(valuesArray,'')>
</cfif>    
<cfoutput>
<form action="Cuentas_por_Cobrar.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    
    <tr> 
        <td align="left"><b>Orden de Trabajo:</b>&nbsp;</td>
        <td>
         <cf_conlis
                Campos="OTcodigo,OTdescripcion,SNnombre"
                Desplegables="S,S,S"
                Modificables="S,S,S"
                Size="15,20,35"
                ValuesArray="#ValuesArray#"
                Title="Orden de Trabajo"
                Tabla="Prod_OT,SNegocios"
                Columnas="OTcodigo,OTdescripcion,SNnombre"
                Filtro="Prod_OT.Ecodigo = #Session.Ecodigo# and Prod_OT.SNCodigo=SNegocios.SNCodigo and Prod_OT.Ecodigo=SNegocios.Ecodigo order by OTcodigo, OTdescripcion"
                Desplegar="OTcodigo,OTdescripcion,SNnombre"
                Etiquetas="C&oacute;digo,Descripci&oacute;n,Cliente"
                filtrar_por="OTcodigo,OTdescripcion,SNnombre"
                Formatos="S,S,S"
                Align="left,left,left"
                Asignar="OTcodigo,OTdescripcion,SNnombre"
                Asignarformatos="S,S,S"
                tabindex="1" />
        </td>
        <td><input type="submit" name="Buscar" value="Buscar"/></td>
	</tr>
    </table>
	
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr><hr color="blue" /></tr>
        <tr>
            <td colspan="4" align="left"><b>Datos del Cliente</b>&nbsp;</td>
        </tr>
        <tr>
            <td align="left"><b>Nombre del Cliente:</b>&nbsp;</td>
            <td>
                <cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                    #rsProdOTDatos.SNnombre#
                </cfif>
            </td> 
            <td align="right"><b>RFC del Cliente:</b></td>
            <td>
                <cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                    #rsProdOTDatos.SNidentificacion#
                </cfif>
            </td>
        </tr> 
		<tr>
            <td align="left"><b>Direccion:</b></td>
            <td colspan="3">
				<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                  #rsProdOTDatos.SNdireccion#
                </cfif>
            </td>
		</tr>
        
     </table>
	</form>
</cfoutput>

