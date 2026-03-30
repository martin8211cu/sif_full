
<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
	<!---<cfif isdefined("fID_Estr")>
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
	<cfelse>
	    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ID_Estr#">
	</cfif>--->
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
			<strong>Lista de Cuentas a incluir/excluir por Estructura Programática</strong>
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
			<cfset params = '?tab=2'>
			<cfif isdefined("Form.ID_EstrCtaDet") and Len(Trim(Form.ID_EstrCtaDet))>
                <cfset params = params & " &ID_EstrCtaDet = " & Form.ID_EstrCtaDet>
            </cfif>

			<cfif tipoCuenta EQ "1">
				<cfquery name="rsCuentas" datasource="#Session.DSN#">
						select a.ID_EstrCtaDet,a.FormatoC
						from CGEstrProgCtaD a
						where 1=1 #PreserveSingleQuotes(filtro)#
						and a.FormatoC is not null
						order by FormatoC
				</cfquery>
				<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaQuery"
						query="#rsCuentas#"
						columnas="ID_EstrCtaDet,FormatoC"
						desplegar="FormatoC"
						etiquetas="Cuenta"
						formatos="S"
						align="left"
						checkboxes= "N"
						ira="CuentasEstrProg.cfm#params#"
						nuevo="CuentasEstrProg.cfm#params#"
						incluyeform="false"
						formname="filtro2"
						keys="ID_EstrCtaDet"
						mostrar_filtro="true"
						filtrar_automatico="true"
						filtrar_por="FormatoC,' '"
						maxrows="15"
						navegacion="#navegacion#&tab=3"
				/>
			<cfelse>
				<cfquery name="rsCuentas" datasource="#Session.DSN#">
						select a.ID_EstrCtaDet,a.FormatoP
						from CGEstrProgCtaD a
						where 1=1 #PreserveSingleQuotes(filtro)#
						and a.FormatoP is not null
						order by FormatoP
				</cfquery>
				<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaQuery"
						query="#rsCuentas#"
						columnas="ID_EstrCtaDet,FormatoP"
						desplegar="FormatoP"
						etiquetas="Cuenta"
						formatos="S,S"
						align="left,left"
						checkboxes= "N"
						ira="CuentasEstrProg.cfm#params#"
						nuevo="CuentasEstrProg.cfm#params#"
						incluyeform="false"
						formname="filtro2"
						keys="ID_EstrCtaDet"
						mostrar_filtro="true"
						filtrar_automatico="true"
						filtrar_por="FormatoP,' '"
						maxrows="15"
						navegacion="#navegacion#&tab=3"
				/>
			</cfif>

		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>
</cfoutput>

