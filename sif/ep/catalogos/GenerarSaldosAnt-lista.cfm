
<cfif isdefined("Form.fID_Saldo") and Len(Trim(Form.fID_Saldo))>
<cfquery name="rsSaldo" datasource="#Session.DSN#">
    select ID_Saldo
		      ,ID_Estr
		      ,Descripcion
		      ,BMUsucodigo
		      ,ts_rversion
		      ,TipoAplica
		      ,Cant
       from CGEstrProgConfigSaldo
			where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Saldo#">
			and  ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
</cfquery>
</cfif>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and ID_Estr = " & Form.fID_Estr>
</cfif>
<cfif isdefined("Form.fID_Saldo") and Len(Trim(Form.fID_Saldo))>
	<cfset filtro = filtro & " and ID_Saldo = " & Form.fID_Saldo>
</cfif>

<cfoutput>
<cfset campos = "">

<form name="filtro6" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fID_Saldo" value="<cfif isdefined ("form.fID_Saldo") and len(trim(form.fID_Saldo))><cfoutput>#form.fID_Saldo#</cfoutput></cfif>">
	<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="6">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Saldos a Generar</strong>
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
			<cfset params = '?tab=1'>
			<cfif isdefined("Form.ID_Estr") and Len(Trim(Form.ID_Estr))>
                <cfset params = params & " &ID_Estr = " & Form.ID_Estr>
            </cfif>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRetPadre"
				columnas="ID_Saldo,ID_Estr,Descripcion,
					case when TipoAplica = 1 then  'Mes anterior ('+cast(Cant as varchar)+')' else 'Mes cierre año anterior ('+cast(Cant as varchar)+')' end TipoAplica,
					Cant"
				tabla="CGEstrProgConfigSaldo"
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by ID_Saldo"
				desplegar="Descripcion,TipoAplica"
				etiquetas="Descripci&oacute;n,Aplica para"
				formatos="S,S"
				align="left, left"
				checkboxes="N"
				ira="CatGrupoPadreCtas-form.cfm#params#"
				nuevo="CatGrupoPadreCtas-form.cfm#params#"
				formname="filtro6"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="true"
				keys="ID_Saldo,ID_Estr"
				filtrar_automatico="true"
				filtrar_por="ID_Saldo,ID_Estr"
				maxrows="15"
				navegacion="#navegacion#&tab=1"
				/>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>
</cfoutput>

