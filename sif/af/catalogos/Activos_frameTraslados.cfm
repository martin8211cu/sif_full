<br />
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfif archivo EQ "Activos.cfm">
	<cfinclude template="Activos_frameEncabezado.cfm">
</cfif>
<cfinvoke component="sif.af.Componentes.Activo" method="getTransaccionesByIDtrans" Aid="#form.Aid#" IDtrans="8" returnvariable="rsTraslados">
	<cfif isdefined("form.Periodoini") and len(trim(form.Periodoini)) and form.Periodoini gt 0>
		<cfinvokeargument name="Periodoini" value="#form.Periodoini#">
		<cfif isdefined("form.Mesini") and len(trim(form.Mesini)) and form.Mesini gt 0>
			<cfinvokeargument name="Mesini" value="#form.Mesini#">
		<cfelse>
			<cfinvokeargument name="Mesini" value="1">
		</cfif>
	</cfif>
	<cfif isdefined("form.Periodofin") and len(trim(form.Periodofin)) and form.Periodofin gt 0>
		<cfinvokeargument name="Periodofin" value="#form.Periodofin#">
		<cfif isdefined("form.Mesfin") and len(trim(form.Mesfin)) and form.Mesfin gt 0>
			<cfinvokeargument name="Mesfin" value="#form.Mesfin#">
		<cfelse>
			<cfinvokeargument name="Mesfin" value="12">
		</cfif>
	</cfif>
</cfinvoke>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr align="center">
		<td width="10%">&nbsp;</td>
		<td valign="top"  align="center">
			<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
				<tbody>
				<tr>
				  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Lista de Traslados </td>
				</tr>
				</tbody>
			</table>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsTraslados#"/>
				<cfinvokeargument name="desplegar" value="CFcodigo, ADTPrazon, TAperiodo, TAmes, TAmontolocadq, TAmontolocmej, TAmontolocrev, TAmontodepadq, TAmontodepmej, TAmontodeprev, ECAsiento, ECPoliza, ECReferencia"/>
				<cfinvokeargument name="etiquetas" value="Centro Funcional, Justificaci&oacute;n, Periodo, Mes, Adquisición, Mejoras, Revaluación, <center>Dep.<BR>Adquisición,<center>Dep.<BR>Mejoras,<center>Dep.<BR>Revaluación,Asiento, Póliza, Referencia"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M,M,M,M,M,S,S,S"/>
				<cfinvokeargument name="align" value="left,left,left,left,right,right,right,right,right,right,right,right,right"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" value="TAid"/>
				<cfinvokeargument name="ira" value="Activos.cfm"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="totales" value="TAmontolocadq,TAmontolocrev,TAmontolocmej,TAmontodepadq,TAmontodeprev,TAmontodepmej"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="ajustar" value="S"/>
			</cfinvoke>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>