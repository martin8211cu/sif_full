<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>

<!---►►Proveduria Corporativa◄◄--->
<cfparam name="url.Ecodigo_f"  	default="#session.Ecodigo#">
<cfparam name="form.Ecodigo_f" 	default="#url.Ecodigo_f#">
<cfparam name="lvarProvCorp" 	default="false">

<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	 from Parametros 
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo = #session.Ecodigo#
         and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(EOidorden,EOnumero,Observaciones) {
	if (window.opener != null) {		
		window.opener.document.form1.EOidorden<cfoutput>#index#</cfoutput>.value = EOidorden;
		window.opener.document.form1.EOnumero<cfoutput>#index#</cfoutput>.value = EOnumero;
		window.opener.document.form1.Observaciones<cfoutput>#index#</cfoutput>.value = Observaciones;
		window.close();
	}
}
</script>

<cfif isdefined("Url.EOidorden") and not isdefined("Form.EOidorden")>
	<cfparam name="Form.EOidorden" default="#Url.EOidorden#">
</cfif>

<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
	<cfparam name="Form.fecha" default="#Url.fecha#">
</cfif>

<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>

<cfset filtroorden = "">
<cfset navegacion = "">

<cfif isdefined("Form.EOidorden") and Len(Trim(Form.EOidorden)) NEQ 0>
	<cfset filtroorden = filtroorden & " and EOidorden = " & Form.EOidorden >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOidorden=" & Form.EOidorden>
</cfif>
<cfif isdefined("Form.Observaciones") and Len(Trim(Form.Observaciones)) NEQ 0>
 	<cfset filtroorden = filtroorden & " and upper(Observaciones) like '%" & #UCase(Form.Observaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Observaciones=" & Form.Observaciones>
</cfif>
<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0>
 	<cfset filtroorden = filtroorden & " and EOnumero = " & trim(form.EOnumero)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOnumero=" & Form.EOnumero>
</cfif>
<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>
<cfif isdefined("index") and Len(Trim(index)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "index=" & index>
</cfif>

<html>
<head>
<title>Lista de Ordenes de Compra de Importacion </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<cfquery name="rsLista" datasource="#session.DSN#">
	select eo.EOidorden, eo.EOnumero, eo.EOfecha, eo.Observaciones, eo.EOfecha
	from EOrdenCM eo
		inner join CMTipoOrden cmto
			on cmto.Ecodigo = eo.Ecodigo
			and cmto.CMTOcodigo = eo.CMTOcodigo
			and cmto.CMTgeneratracking = 1
			and cmto.CMTOimportacion = 1
	where eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
	<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
		and eo.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
	</cfif>
		and eo.EOestado = 10
		#preservesinglequotes(filtroorden)#
	order by eo.EOnumero, eo.EOfecha
</cfquery>
<cfparam name="Form.EOnumero" 		default="">
<cfparam name="Form.Observaciones"  default="">
<cfparam name="_fecha"  			default="">

<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset _fecha = Form.fecha >
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroOrden" method="post" action="ConlisOrdenCompraImportacion.cfm">
				<cfif Len(Trim(index))><input type="hidden" name="idx" value="#index#"></cfif>
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
                    	<!---►►Numero de Orden◄◄--->
						<td align="right" nowrap><strong>Número Orden:</strong></td>
						<td><input name="EOnumero" type="text" id="desc" size="10" maxlength="80" value="#Form.EOnumero#" onFocus="javascript:this.select();"></td>
						<!---►►Observación◄◄--->
                        <td align="right"><strong>Observación:</strong></td>
						<td><input name="Observaciones" type="text" id="desc" size="40" maxlength="80" value="#Form.Observaciones#" onFocus="javascript:this.select();"></td>
					</tr>
					<tr>
                    	<!---►►Empresa◄◄--->
                    	<cfif lvarProvCorp>
                        	<td align="right" nowrap><strong>Empresa: </strong></td>
                            <td>
                                <select name="Ecodigo_f" id="Ecodigo_f" onchange="this.form.submit();">
                                    <cfloop query="rsDProvCorp">
                                        <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                    </cfloop>	
                                </select>
                             </td>
                        </cfif>		
                    	<!---►►Fecha◄◄--->
						<td align="right"><strong>Fecha:</strong></td>
						<td><cf_sifcalendario form="filtroOrden" value="#_fecha#"></td>
						
					</tr>
                    <tr>
                    	<td colspan="4" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" class="BtnFiltrar" value="Filtrar"></td>
                    </tr>
			</table>
			</form>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
				<cfinvokeargument name="query" 				value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" 			value=" EOnumero, Observaciones, EOfecha"/>
				<cfinvokeargument name="etiquetas"			value="N&uacute;mero de Orden, Orden, Fecha"/> 
				<cfinvokeargument name="formatos" 			value="S,S,D"/> 
				<cfinvokeargument name="align" 				value="left,left,left"/> 
				<cfinvokeargument name="ajustar" 			value="N"/> 
				<cfinvokeargument name="checkboxes" 		value="N"/> 
				<cfinvokeargument name="irA" 				value="ConlisOrdenCompraImportacion.cfm"/> 
				<cfinvokeargument name="formname"	 		value="listaOC"/> 
				<cfinvokeargument name="maxrows" 			value="15"/>
				<cfinvokeargument name="funcion" 			value="Asignar#index#"/>
				<cfinvokeargument name="fparams" 			value="EOidorden,EOnumero,Observaciones"/>
				<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
			</cfinvoke> 
		</td>
	</tr>
</table>
</cfoutput>
</body>
</html>