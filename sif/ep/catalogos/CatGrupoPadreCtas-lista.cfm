<!---<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
</cfquery>--->

<cfif isdefined("Form.fID_Grupo") and Len(Trim(Form.fID_Grupo))>
<cfquery name="rsTiposGrupos" datasource="#Session.DSN#">
    select ID_GrupoPadre, ID_Estr, EPGcodigo, EPGdescripcion
    from CGGrupoPadreCtas
    where ID_GrupoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Grupo#">
	and  ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
    and EPTipoAplica = 1
</cfquery>
</cfif>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and ID_Estr = " & Form.fID_Estr>
</cfif>

<!--- <cfif isdefined("Form.fID_Grupo") and Len(Trim(Form.fID_Grupo))>
	<cfset filtro = filtro & " and ID_Grupo = " & Form.fID_Grupo>
</cfif> --->

<cfoutput>
<cfset campos = "">

<form name="filtro6" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fID_Grupo" value="<cfif isdefined ("form.fID_Grupo") and len(trim(form.fID_Grupo))><cfoutput>#form.fID_Grupo#</cfoutput></cfif>">
	<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="6">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de Grupos Padres</strong>
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
			<cfset params = '?tab=6'>
			<cfif isdefined("Form.ID_GrupoCtaVal") and Len(Trim(Form.ID_GrupoCtaVal))>
                <cfset params = params & " &ID_GrupoCtaVal = " & Form.ID_GrupoCtaVal>
            </cfif>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRetPadre"
				columnas="ID_GrupoPadre, ID_Estr, EPGcodigo, EPGdescripcion"
				tabla="CGGrupoPadreCtas"
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by EPGcodigo"
				desplegar="EPGcodigo,EPGdescripcion"
				etiquetas="C&oacute;digo,Descripci&oacute;n"
				formatos="S,S"
				align="left, left"
				checkboxes="N"
				ira="CatGrupoPadreCtas-form.cfm#params#"
				nuevo="CatGrupoPadreCtas-form.cfm#params#"
				formname="filtro6"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="true"
				keys="ID_GrupoPadre,ID_Estr"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="ID_GrupoPadre, ID_Estr"
				maxrows="15"
				navegacion="#navegacion#&tab=6"
				/>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>
</cfoutput>

