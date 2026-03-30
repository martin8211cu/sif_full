

<cfset navegacion = "">
<cfif isdefined("form.idDocCompensacion")>
	<cfset navegacion = navegacion & "&idDocCompensacion=#form.idDocCompensacion#">
</cfif>
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset navegacion = navegacion & "&Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset navegacion = navegacion & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset navegacion = navegacion & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>

<cfif isDefined("rslistacxc")>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td align="center">&nbsp;</td></tr>
	<tr><td align="center"><cfoutput><strong>#LB_SubTit#</strong></cfoutput></td></tr>
	<tr><td align="center">&nbsp;</td></tr>
  	<tr>
	    <td>
			<cfinvoke component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pLista"
				formname="form1"
				query="#rslistacxc#"
				cortes="SNnombre,CCTdescripcion"
				totales="Dsaldo,Dmonto"
				totalgenerales="Dsaldo,Dmonto"
				desplegar="Ddocumento,Dsaldo,Dmonto"
				etiquetas="#LB_Documento#,#LB_Saldo#,#LB_Monto#"
				formatos="S,M,M"
				align="left,right,right"
				irA=""
				showEmptyListMsg="true"
				EmptyListMsg="#LB_Noseha#"
				navegacion="#navegacion#"
				PageIndex="2"
			/>
		</td>
  	</tr>
</table>
</cfif>