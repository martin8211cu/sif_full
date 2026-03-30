<!---<cfquery name="rsTiposRep" datasource="#Session.DSN#">
    select ID_Estr,EPcodigo, EPdescripcion
    from CGEstrProg
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fID_Estr#">
</cfquery>--->

<cfif isdefined("Url.fID_Estr") and Len(Trim(Url.fID_Estr))>
	<cfparam name="Form.ID_Estr" default="#Url.fID_Estr#">
</cfif>
<cfif isdefined("Url.fID_EstrCtaVal") and Len(Trim(Url.fID_EstrCtaVal))>
	<cfparam name="Form.ID_EstrCtaVal" default="#Url.fID_EstrCtaVal#">
</cfif>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and e.ID_Estr = " & Form.fID_Estr>
</cfif>

<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
	<cfset filtro = filtro & " and a.ID_EstrCtaVal = " & Form.ID_EstrCtaVal>
</cfif>

<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

<cfoutput>
<cfset campos = "">
<form name="form_3" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">

	<input name="tab" type="hidden" value="4">
	<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de Valores al Plan de Cuentas a Eliminar por Estructura Programática</strong>
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
			<cfset params = '?tab=4'>
            <cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
				<cfset params = params & " &fID_Estr = " & Form.fID_Estr>
            </cfif>
			<!--- <cfif isdefined("Form.ID_EstrCtaVal") and Len(Trim(Form.ID_EstrCtaVal))>
                <cfset params = params & " &ID_EstrCtaVal = " & Form.ID_EstrCtaVal>
            </cfif> --->

			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="a.ID_DEstrCtaVal,a.ID_EstrCtaVal,a.PCDcatid,b.PCDvalor,b.PCDdescripcion,e.ID_Estr,e.PCEcatid,e.SoloHijos as chcHijo, b.PCEcatidref, case
					when a.SaldoInv = 0 then '#unchecked#'
					else '#checked#'
				end as SaldoInv"
				tabla="CGDEstrProgVal a
                		inner join CGEstrProgVal e
                        on a.ID_EstrCtaVal=e.ID_EstrCtaVal
                        left outer join PCDCatalogo b
                        on a.PCDcatid = b.PCDcatid"
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by a.PCDcatid"
				desplegar="PCDvalor,PCDdescripcion,SaldoInv"
				etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_SaldoInvertido#"
				formatos="S,S,U"
				align="left,left,left"
				checkboxes="N"
				irA="CuentasEstrProg.cfm#params#"
				nuevo="CuentasEstrProg.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="false"
				formname="form_3"
				keys="PCDcatid"
				mostrar_filtro="false"
				filtrar_automatico="true"
				filtrar_por="a.PCDcodigo,b.PCDdescripcion,' '"
				maxrows="50"
<!---				navegacion="#navegacion#&tab=4"--->
				navegacion="CuentasEstrProg.cfm#params#"
			/>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
	</cfif>
</form>
</cfoutput>

