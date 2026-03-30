<!--- Variables de Traduccion --->
<cfinvoke key="LB_Carga" default="Carga" returnvariable="LB_Carga" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Metodo" default="M&eacute;todo" returnvariable="LB_Metodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ValorEmpleado" default="Valor Empleado" returnvariable="LB_ValorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ValorPatrono" default="Valor Patrono" returnvariable="LB_ValorPatrono" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate" method="Translate"/>
<!--- fin variables de traduccion --->
<cfset navegacionCar = "">
<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "o=6">
<cfif isdefined("Form.DEid")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.DClinea")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "DClinea=" & Form.DClinea>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionCar = navegacionCar & Iif(Len(Trim(navegacionCar)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
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
						returnvariable="pListaCar">
							<cfinvokeargument name="tabla" value="CargasEmpleado a, DCargas b, ECargas c"/>
							<cfinvokeargument name="columnas" value="c.ECdescripcion, a.DClinea, 
															a.DEid, b.DCdescripcion, CEdesde, CEhasta, 
															case b.DCmetodo when 0 then 'Monto' when 1 then 'Porcentaje' else '' end as DCmetodo, 
															coalesce(a.CEvaloremp,b.DCvaloremp) as DCvaloremp,
															coalesce(a.CEvalorpat,b.DCvalorpat) as DCvalorpat,
															6 as o, 1 as sel"/>
							<cfinvokeargument name="desplegar" value="DCdescripcion, DCmetodo, DCvaloremp, DCvalorpat, CEdesde, CEhasta"/>
							<cfinvokeargument name="etiquetas" value="#LB_Carga#,#LB_Metodo#, #LB_ValorEmpleado#, #LB_ValorPatrono#, #LB_Desde#, #LB_Hasta#"/>
							<cfinvokeargument name="formatos" value="V, V, M, M, D, D"/>
							<cfinvokeargument name="formName" value="listaCargas"/>	
							<cfinvokeargument name="filtro" value="a.DClinea=b.DClinea and b.ECid=c.ECid and DEid=#form.DEid# and c.Ecodigo=#session.Ecodigo# order by c.ECdescripcion, b.DCdescripcion"/>
							<cfinvokeargument name="align" value="left, left, right, right, center, center"/>
							<cfinvokeargument name="ajustar" value=""/>				
							<cfinvokeargument name="irA" value="autogestion.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacionCar#"/>
							<cfinvokeargument name="Cortes" value="ECdescripcion"/>
							<cfinvokeargument name="showLink" value="false"/>
					</cfinvoke>		
				</td>
			</tr>
		</table>
	</td>
  </tr>
</table>
