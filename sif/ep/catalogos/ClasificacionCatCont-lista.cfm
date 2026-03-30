<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
</cfquery>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and a.ID_Estr = " & Form.fID_Estr>
</cfif>

<cfoutput>
<cfset campos = "">
<form name="filtro2" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="3">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Clasificación del Catálogo</strong>
		</td>
      </tr>
	  <tr>
		<td valign="top">
			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
			<cfset params = '?tab=5'>
			<cfif isdefined("Form.ID_Estr") and Len(Trim(Form.ID_Estr))>
                <cfset params = params & " &ID_Estr = " & Form.ID_Estr>
            </cfif>            
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
               	columnas="ID_Estr, PCEcatidClasificado, c.PCEcodigo, c.PCEdescripcion"
				tabla="CGEstrProg v
					   inner join PCECatalogo c on v.PCEcatidClasificado = c.PCEcatid"
				filtro="1=1"
				desplegar="PCEcodigo, PCEdescripcion"
				etiquetas="Catálogo"
				formatos="S,S"
				align="left, left"
				checkboxes="N"
				ira="CuentasEstrProg.cfm#params#"
				nuevo="CuentasEstrProg.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="false"
				formname="filtro2"
				keys="PCEcatidClasificado"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="PCEcodigo, PCEdescripcion"
				maxrows="15"
				navegacion="#navegacion#&tab=5"
				/>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>    
</cfoutput>

