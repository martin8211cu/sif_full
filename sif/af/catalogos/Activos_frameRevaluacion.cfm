<br />
<cfset archivo = GetFileFromPath(GetTemplatePath())>
<cfif archivo EQ "Activos.cfm">
	<cfinclude template="Activos_frameEncabezado.cfm">
</cfif>
<cfinvoke component="sif.af.Componentes.Activo" method="getTransaccionesByIDtrans" Aid="#form.Aid#" IDtrans="3" returnvariable="rsRevaluaciones">
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
				  <td class="tituloListas" align="center" height="17" nowrap="nowrap" width="100%">Lista de Revaluaciones </td>
				</tr>
				</tbody>
			</table>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsRevaluaciones#"/>
				<cfinvokeargument name="desplegar" value="CFcodigo, TAperiodo, TAmes, TAmontolocadq, TAmontolocmej, TAmontolocrev, TAmontodepadq,TAmontodepmej,TAmontodeprev,TAsuperavit,ECAsiento, ECPoliza, ECReferencia "/>
				<cfinvokeargument name="etiquetas" value="Centro Funcional,Periodo, Mes,  <center> Revaluación <BR> Adquisición, <center>Revaluación <BR>Mejora,<center> Revaluación <BR> Revaluación,  <center>Revaluación<BR> Dep.<BR>Adquisición,<center>Revaluación <BR>Dep.<BR>Mejora,<center>Revaluación<BR> Dep.<BR>Revaluación,Superavit,Asiento, Póliza, Referencia"/>
				<cfinvokeargument name="formatos" value="S,S,S,M,M,M,M,M,M,M,S,S,S"/>
				<cfinvokeargument name="align" value="left,left,left,right,right,right,right,right,right,right,right,right,right"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" value="TAid"/>
				<cfinvokeargument name="ira" value="Activos.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="totales" value="TAmontolocadq,TAmontolocmej,TAmontolocrev,TAmontodepadq,TAmontodepmej,TAmontodeprev,TAsuperavit"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
