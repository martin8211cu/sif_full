<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Pagos M&iacute;nimos" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SaldoMin" Default="Saldo M&iacute;nimo." returnvariable="LB_SaldoMin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SaldoMax" Default="Saldo M&aacute;ximo" returnvariable="LB_SaldoMax"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoPagoMin" Default="Monto Pago M&iacute;nimo" returnvariable="LB_MontoPagoMin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Porciento" Default="Porcentaje" returnvariable="LB_Porciento"/>



<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCPagoMinimo"
						columnas="id,SaldoMin,SaldoMax,MontoPagoMin,Porciento"
						desplegar="SaldoMin,SaldoMax,MontoPagoMin,Porciento"
						etiquetas="#LB_SaldoMin#,#LB_SaldoMax#,#LB_MontoPagoMin#,#LB_Porciento#"
						formatos="M,M,M,L"
						filtro="Ecodigo=#session.Ecodigo#"
						align="left,left,left,left"
						checkboxes="N"
						ira="PagoMinimo.cfm"
						keys="id">
					</cfinvoke>
				</td>
				<td width="50%">
					<cfinclude template="PagoMinimo_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	<cfoutput>
		<cfif isdefined("form.resultT") and form.resultT neq ""> 
			<script type="text/javascript">
				alert("#form.resultT#");
			</script> 
		</cfif>					
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>