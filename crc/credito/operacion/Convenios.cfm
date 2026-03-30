
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Convenios" returnvariable="LB_Title"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Intereses" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonado" Default="Monto Condonado" returnvariable="LB_Condonado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoCondo" Default="Monto A Condonar" returnvariable="LB_MontoCondo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td>
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCConvenios A inner join CRCCuentas B on A.CRCCuentasid = B.id"
						columnas="
							  A.id
							, A.CodigoConvenio
							, A.DescripConvenio
							, A.CRCCuentasid
							, case A.convenioAplicado
								when 1 then 
									case A.esPorcentaje
										when 1 then
											A.MontoConvenio + (A.MontoConvenio * (A.MontoGastoCobranza/100))
										else
											A.MontoConvenio + A.MontoGastoCobranza
										end
								else 
									case A.esPorcentaje
										when 1 then
											ISNULL(B.SaldoActual, 0 ) + (ISNULL(B.SaldoActual, 0 ) * (A.MontoGastoCobranza/100))
										else
											ISNULL(B.SaldoActual, 0 ) + A.MontoGastoCobranza
										end 
								end as MontoConvenio
							, A.ConvenioAplicado
							, B.Numero
							, case A.Estado
								when 'V' then 'Vencido'
								when 'A' then 'Aplicado'
								else 'Pendiente' end as Estado
							"
						desplegar="CodigoConvenio,DescripConvenio,Numero,MontoConvenio,ConvenioAplicado,Estado"
						etiquetas="Codigo Convenio,Descripcion,Num. Cuenta,Monto,Aplicado,Estado"
						formatos="S,S,S,M,L,S"
						filtro="A.Ecodigo=#session.Ecodigo#"
						align="left,left,left,left,left,left"
						checkboxes="N"
						mostrar_filtro="yes"
						filtrar_automatico="yes"
						ira="Convenios_form.cfm?a=1&b=0"
						keys="id">
					</cfinvoke>
				</td>
				<td>
					<!--- <cfinclude template="Convenios_form.cfm"> --->
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<form action="Convenios_form.cfm" method="POST">
						<input type="submit" name="newConvenio" value="Nuevo">
						<input type="hidden" name="parentEntrancePoint" value="Convenios.cfm">
					</form>
				</td>
			</tr>
			
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>