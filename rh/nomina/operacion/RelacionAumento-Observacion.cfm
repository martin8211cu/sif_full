

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExisteUnaObservacionParametrizada"
	Default="Existe una observaci&oacute;n parametrizada en Par&aacutemetros Generales > N&oacute;mina:"	
	returnvariable="LB_ExisteUnaObservacionParametrizada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CualquierRelacionQueSeAplique"
	Default="Cualquier Relaci&oacute;n de Aumento que se Aplique indicar&aacute la siguiente Observaci&oacute;n"	
	returnvariable="LB_CualquierRelacionQueSeAplique"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorcentajeIncremento"
	Default="Aumento Salarial Masivo "	
	returnvariable="LB_SalarioAumentoMensajeDefault"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorcentajeIncremento"
	Default="(porcentaje/incremento)"	
	returnvariable="LB_PorcentajeIncremento"/>	

<cfquery datasource="#session.dsn#" name="rsRelacionAumentoObservacion">
SELECT Pvalor
FROM RHParametros
WHERE Pcodigo=2541
and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rsRelacionAumentoCheck">
SELECT Pvalor
FROM RHParametros
WHERE Pcodigo=2542
and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsRelacionAumentoCheck.recordcount and trim(rsRelacionAumentoCheck.Pvalor) EQ '1'>
	<cfoutput>	
	
	
	<table width="100%" style="border:solid thin" >
	  <tr>
		<td align="left" style="font-size:9px">
				#LB_ExisteUnaObservacionParametrizada# <u style="font-size:9px">#LB_CualquierRelacionQueSeAplique# :</u>
		</td>
	  </tr>
	  <tr>
		<td align="center">
				<b>" 
					<cfif rsRelacionAumentoObservacion.recordcount GT 0 and len(trim(rsRelacionAumentoObservacion.Pvalor)) GT 0>
						#rsRelacionAumentoObservacion.Pvalor#
					<cfelse>	
						#LB_SalarioAumentoMensajeDefault#
					</cfif>
					#LB_PorcentajeIncremento#
				"</b>
		</td>
	  </tr>
	</table>


	</cfoutput>
</cfif>