
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Condonaciones" returnvariable="LB_Title"/>

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
						tabla="CRCCondonaciones A inner join CRCCuentas B on A.CRCCuentasid = B.id"
						columnas="A.id,A.CodigoCondonacion,A.DescripCondonacion,A.CRCCuentasid,A.MontoCondonacion,B.Numero,A.esFutura, 
						case A.Estado 
							when 'A' then 'Aplicada'
							when 'V' then 'Vencida'
							else ''
						end as Estado"
						desplegar="CodigoCondonacion,DescripCondonacion,Numero,MontoCondonacion,esFutura,Estado"
						etiquetas="Codigo Condonacion,Descripcion,Num. Cuenta,Monto,A Futuro,Estado"
						formatos="S,S,S,M,L,S"
						filtro="A.Ecodigo=#session.Ecodigo#"
						align="left,left,left,left,left,left"
						checkboxes="N"
						mostrar_filtro="yes"
						filtrar_automatico="yes"
						ira="Condonaciones_form.cfm"
						keys="id">
					</cfinvoke>
				</td>
				<td>
					<!--- <cfinclude template="Condonaciones_form.cfm"> --->
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" name="newCondonacion" value="Nuevo" onclick="location.href='Condonaciones_form.cfm'">
				</td>
			</tr>
			
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>