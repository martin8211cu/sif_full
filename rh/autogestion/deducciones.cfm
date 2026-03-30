<!--- Variables de Traduccion --->
<cfinvoke key="LB_Deduccion" default="Deducci&oacute;n" returnvariable="LB_Deduccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Metodo" default="M&eacute;todo" returnvariable="LB_Metodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor" default="Valor" returnvariable="LB_Valor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaInicial" default="Fecha Inicial" returnvariable="LB_FechaInicial"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaFin" default="Fecha Fin" returnvariable="LB_FechaFin"component="sif.Componentes.Translate" method="Translate"/>
<!--- fin varibles de traduccion --->
<cfset navegacionDed = "">
<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "o=7">
<cfif isdefined("Form.DEid")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionDed = navegacionDed & Iif(Len(Trim(navegacionDed)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 


<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
		<table align="center" width="95%">
			<tr>
				<td align="center">
					<cfinclude template="/rh/portlets/pEmpleado.cfm">
				</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td>
		<table align="center" width="95%">
			<tr>
				<td align="center">
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaDed">
							<cfinvokeargument name="tabla" value="DeduccionesEmpleado a, SNegocios b"/>
							<cfinvokeargument name="columnas" value="a.DEid, a.Did, a.Ddescripcion, a.SNcodigo, b.SNnombre, case a.Dmetodo when 0 then 'Porcentaje' when 1 then 'Valor' end as Dmetodo, a.Dvalor, Dfechaini, Dfechafin, 7 as o, 1 as sel"/>
							<cfinvokeargument name="desplegar" value="Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin"/>
							<cfinvokeargument name="etiquetas" value="#LB_Deduccion#, #LB_Metodo#,#LB_Valor# , #LB_FechaInicial#, #LB_FechaFin#"/>
							<cfinvokeargument name="formatos" value="V, V, M, D, D"/>
							<cfinvokeargument name="formName" value="listaDeducciones"/>	
							<cfinvokeargument name="filtro" value="a.Ecodigo=b.Ecodigo and a.SNcodigo=b.SNcodigo and DEid=#form.DEid# and a.Ecodigo=#session.Ecodigo# order by Ddescripcion"/>
							<cfinvokeargument name="align" value="left, left, right, center, center"/>
							<cfinvokeargument name="ajustar" value=""/>
							<cfinvokeargument name="irA" value="expediente-cons.cfm"/>			
							<cfinvokeargument name="navegacion" value="#navegacionDed#"/>
							<cfinvokeargument name="showLink" value="false"/>
					</cfinvoke>		
				</td>
			</tr>
		</table>
	</td>
  </tr>
</table>
