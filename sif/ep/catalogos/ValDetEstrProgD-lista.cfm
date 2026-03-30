<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and e.ID_Estr = " & Form.fID_Estr>
</cfif>

<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
	<cfset filtro = filtro & " and a.ID_EstrCtaVal = " & Form.ID_EstrCtaVal>
</cfif>
<cfif isdefined("form.ID_DEstrCtaVal") and Len(Trim(form.ID_DEstrCtaVal))>
	<cfset filtro = filtro & " and a.ID_DEstrCtaVal = " & Form.ID_DEstrCtaVal>
</cfif>

<cfset LB_ListaDetalleValoresalPlan = t.Translate('LB_ListaDetalleValoresalPlan','Lista de Detalles de Valores al Plan de Cuentas a Eliminar por Estructura Programática')>

<cfoutput>
<cfset campos = "">
<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >

<form name="form_4" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input name="tab" type="hidden" value="4">
	<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>#LB_ListaDetalleValoresalPlan#</strong>
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
			<cfif isdefined("Form.ID_EstrCtaVal") and Len(Trim(Form.ID_EstrCtaVal))>
                <cfset params = params & " &ID_EstrCtaVal = " & Form.ID_EstrCtaVal>
            </cfif>

			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="a.ID_DDEstrCtaVal,a.ID_DEstrCtaVal,a.ID_EstrCtaVal,a.PCDcatidref,b.PCDvalor,b.PCDdescripcion,e.ID_Estr,
					e.PCEcatid,e.SoloHijos as chcHijo, b.PCEcatidref,
					case when a.SaldoInv = 1 then '#checked#'
					else '#unchecked#'
				end as SaldoInv"
				tabla="CGDDetEProgVal a
                		inner join CGEstrProgVal e
                        on a.ID_EstrCtaVal=e.ID_EstrCtaVal
                        left outer join PCDCatalogo b
                        on a.PCDcatidref = b.PCDcatid"
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by a.PCDcatidref"
				desplegar="PCDvalor,PCDdescripcion,SaldoInv"
				etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_SaldoInvertido#"
				formatos="S,S,U"
				align="left, left, left"
				checkboxes="N"
				ira="CuentasEstrProg.cfm#params#"
				nuevo="CuentasEstrProg.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="false"
				formname="form_4"
				keys="PCDcatidref"
				mostrar_filtro="false"
				filtrar_automatico="true"
				filtrar_por="a.PCDcodigo,b.PCDdescripcion,' '"
				maxrows="80"
				navegacion="#navegacion#&tab=4"
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

