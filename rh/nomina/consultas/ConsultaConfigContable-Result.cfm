<cf_templatecss>
<style type="text/css">
	.stitulo{
		font-weight:bold;
		font-size:14px;
		text-transform:uppercase;
	}
	.subrayados{
		border-bottom:ridge;
	}
</style>
<cfoutput>
<cf_htmlReportsHeaders 
	title="Consulta de Configuración Contable" 
	filename="Consulta_de_Configuracion_Contable_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="ConsultaConfigContable.cfm" 
	>
	
<!---- traduccion ----->	
<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_Acciones"
Default="Acciones"
returnvariable="LB_Acciones"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ConceptosDePago"
Default="Conceptos de Pago"
returnvariable="LB_ConceptosDePago"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_Deducciones"
Default="Deducciones"
returnvariable="LB_Deducciones"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_SociosDeNegocio"
Default="Socios de Negocio"
returnvariable="LB_SociosDeNegocio"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CargasObreroPatronales"
Default="Cargas Obrero Patronales"
returnvariable="LB_CargasObreroPatronales"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CentrosFuncionales"
Default="Centros Funcionales"
returnvariable="LB_CentrosFuncionales"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CatalogoContable"
Default="Cat&aacute;logo Contable"
returnvariable="LB_CatalogoContable"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CombinacionDeCuentas"
Default="Combinaci&oacute;n de Cuentas"
returnvariable="LB_CombinacionDeCuentas"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ConsultaConfiguracion"
Default="Consulta de Configuración Contable"
returnvariable="LB_ConsultaConfiguracion"/>	 

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_CodigoEmpresa"
Default="C&oacute;digo Empresa"
returnvariable="LB_CodigoEmpresa"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_NombreEmpresa"
Default="Nombre Empresa"
returnvariable="LB_NombreEmpresa"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ObjetoGasto"
Default="Objeto Gasto"
returnvariable="LB_ObjetoGasto"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_NoExistenRegistros"
Default="No existen Registros que coinciden con el filtro suministrado"
returnvariable="LB_NoExistenRegistros"/>


<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				
				<cfif form.cmbOpcion eq 1>	<cfset filtro = "#LB_Acciones#"></cfif>
				<cfif form.cmbOpcion eq 2>	<cfset filtro = "#LB_ConceptosDePago#"></cfif>
				<cfif form.cmbOpcion eq 3>	<cfset filtro = "#LB_Deducciones#"></cfif>
				<cfif form.cmbOpcion eq 4>	<cfset filtro = "#LB_SociosDeNegocio#"></cfif>
				<cfif form.cmbOpcion eq 5>	<cfset filtro = "#LB_CargasObreroPatronales#"></cfif>
				<cfif form.cmbOpcion eq 6>	<cfset filtro = "#LB_CentrosFuncionales#"></cfif>
				<cfif form.cmbOpcion eq 7>	<cfset filtro = "#LB_CatalogoContable#"></cfif>
				<cfif form.cmbOpcion eq 8>	<cfset filtro = "#LB_CombinacionDeCuentas#"></cfif>

				<cf_EncReporte Titulo="#LB_ConsultaConfiguracion#"	Color="##E3EDEF"	filtro1="#filtro#"	>
			</td>
		</tr>
	
		<tr><td>
				<table border="0" width="100%" cellpadding="0" cellspacing="0" >
						<tr >
						<td   align="left" >
						<b>Detalles para verificar:</b><br>
						<cfif form.cmbOpcion eq 1><!--- si se trata de acciones------------------------------->
						<cf_translate key="LB_DetallesVerificarAcciones"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Acci&oacute;n</b> cumpla con lo siguiente:<br /><br />
							- Debe tener un <b>Objeto de Gasto</b><br /><br />
							*Por favor verifique que todas las <b>Acciones</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 2>	<!--- INCIDENCIAS------------------------------->
						<cf_translate key="LB_DetallesVerificarIncidencias"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Concepto de Pago</b> cumpla con lo siguiente:<br /><br />
							- Debe tener un <b>Objeto de Gasto</b>, o bien, una <b>Cuenta Contable</b> Asignada<br /><br /><br />
							*Por favor verifique que todos las <b>Conceptos de Pago</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 3>	<!--- si se trata de Deducciones------------------------------->
						<cf_translate key="LB_DetallesVerificarDeducciones"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Deducci&oacute;</b> cumpla con lo siguiente:<br /><br />
							- Debe tener un <b>Socio de Negocio por defecto</b><br /><br />
							*Por favor verifique que todas las <b>Deducciones</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 4>	<!--- SOCIOS DE NEGOCIO------------------------------->
						<cf_translate key="LB_DetallesVerificarSociosNegocio"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Socio de Negocio</b> cumpla con lo siguiente:<br /><br />
							- Debe tener un <b>Cuenta Contable de Cuentas X Pagar</b><br /><br />
							*Por favor verifique que todas los <b>Socios de Negocio</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 5>	<!--- CARGAS------------------------------------------>
						<cf_translate key="LB_DetallesVerificarCargarOP"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Cargas Obrero Patronales</b> cumpla con lo siguiente:<br /><br />
							- Si la Carga tiene asignado un <b>Valor Patrono</b> se debe tener un <b>Objeto de Gasto</b>, o bien, una <b>Cuenta por Cobrar</b> asignada <br /> <br /><br />
							*Por favor verifique que todas las <b>Cargas Obrero Patronales</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 6>	<!--- CENTROS FUNCIONALES------------------------------------------>
						<cf_translate key="LB_DetallesVerificarCentroF"> 
							<br />Para obtener un resultado exitoso al momento de realizar la contabilidad se necesita que cada <b>Centro Funcional</b> cumpla con lo siguiente:<br /><br />
							- Debe tener una <b>M&aacute;scara Contable</b> asignada<br /><br />
							*Por favor verifique que todos los <b>Centros Funcionales</b> cumplan con las condiciones indicadas.<br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 7>	<!--- CATALOGO CONTABLE------------------------------------------>
						<cf_translate key="LB_DetallesVerificarCatalogoCont"> 
							<br />A continuaci&oacute;n se muestran las Cuentas del <b>Cat&aacute;logo Contable</b> de su Empresa:<br /><br /><br />
						</cf_translate>	
						<cfelseif form.cmbOpcion eq 8>	<!--- Combinación de Cuentas---------------------------------------->
						<cf_translate key="LB_DetallesVerificarCombinaCuenta"> 
							<br />A continuaci&oacute;n se muestran las <b> Combinaciones de Cuentas</b> que el sistema crear&aacute; a partir de las 
							<b>M&aacute;scaras de los Centros Funcionales</b> y  los <b>Objetos de Gasto</b> de las <b>Acciones</b>, 
							<b> Conceptos de Pago</b> y <b> Cargas Obrero Patronales</b> parametrizados:<br /><br /><br />
							*Por favor verifique que todas las <b> Combinaciones son V&aacute;lidas</b>, de lo contrario existe un riesgo que la Contabilidad no resulte exitosa al finalizar una N&oacute;mina<br />
						</cf_translate>	
						</cfif>
						<br />
						<HR> 
						<br /><br /><br />
						</td>
						</tr>
				</table>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<cfif form.cmbOpcion eq 1>	<!--- ACCIONES ---------------------------------------------->
					<cfquery name="rsAcciones" datasource="#session.dsn#">
							Select b.Ecodigo as CodigoEmpresa, 
						   b.Edescripcion as NombreEmpresa , 
						   a.RHTcodigo as CodigoAccion, 
						   a.RHTdesc as DescripcionAccion, 
						   a.RHTcuentac as ObjetoGasto
							from RHTipoAccion a 
								inner join Empresas b
								on a.Ecodigo=b.Ecodigo
							Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and a.RHTespecial=0
							order by b.Ecodigo, a.RHTcodigo
						</cfquery><!--- no toma en cuenta las acciones especiales--->
		
						<tr class="stitulo">
								<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
								<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
								<td align="left" class="subrayados" nowrap><cf_translate key="LB_CodigoAccion"> C&oacute;digo Acci&oacute;n</cf_translate></td>
								<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescripcionAccion"> Descripci&oacute;n Acci&oacute;n</cf_translate></td>
								<td align="center" class="subrayados" nowrap>#LB_ObjetoGasto#</td>
						</tr>
						<cfloop query="rsAcciones">	
							<tr class="sRegistros">
								<td align="center" nowrap>#rsAcciones.CodigoEmpresa#</td>
								<td nowrap>#rsAcciones.NombreEmpresa #</td>	
								<td align="left" nowrap>#rsAcciones.CodigoAccion#</td>
								<td align="left" nowrap>#rsAcciones.DescripcionAccion#</td>
								<cfif  len(trim(rsAcciones.ObjetoGasto)) eq 0>
									<td align="center" bgcolor="FF0000">#rsAcciones.ObjetoGasto# XXXX</td>
								<cfelse>
									<td align="center" nowrap>#rsAcciones.ObjetoGasto#</td>
								</cfif>
							<tr>		
						</cfloop>
						<cfif rsAcciones.recordcount eq 0>
							<tr><td colspan="#colspan#">&nbsp;</td></tr>
							<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
						</cfif>
			</cfif>
					
			<cfif form.cmbOpcion eq 2>	<!--- INCIDENCIAS------------------------------------------->
					<cfquery name="rsIncidencias" datasource="#session.dsn#">
				Select b.Ecodigo as CodigoEmpresa, 
					   b.Edescripcion as NombreEmpresa, 
					   a.CIcodigo as CodigoConcepto, 
					   a.CIdescripcion as NombreConcepto, 
					   a.CIcuentac as ObjetoGasto, 
					   a.Ccuenta as CodigoInternoContable, 
					   e.Cformato as CuentaContable
				from CIncidentes a
					left outer join CContables e
					on a.Ccuenta= e.Ccuenta
					inner join Empresas b
					on a.Ecodigo=b.Ecodigo
				Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
				order by a.Ecodigo, a.CIcodigo
				</cfquery>
				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoConcepto">C&oacute;digo Concepto</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_NombreConcepto">Nombre Concepto</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap>#LB_ObjetoGasto#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoInternoContable">C&oacute;digo Interno Contable</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuentaContable">Cuenta Contable</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
				</tr>
				<cfloop query="rsIncidencias">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsIncidencias.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsIncidencias.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsIncidencias.CodigoConcepto#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsIncidencias.NombreConcepto#</td><td>&nbsp;&nbsp;</td>
						
						<cfif  len(trim(rsIncidencias.ObjetoGasto))  eq 0 and len(trim(rsIncidencias.CuentaContable))  eq 0>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" >#rsIncidencias.ObjetoGasto# </td><td>&nbsp;&nbsp;</td>
						</cfif>
						
							<td align="center" nowrap>#rsIncidencias.CodigoInternoContable#</td><td>&nbsp;&nbsp;</td>
								
							<cfif  len(trim(rsIncidencias.ObjetoGasto))  eq 0 and len(trim(rsIncidencias.CuentaContable))  eq 0>
	
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" >#rsIncidencias.CuentaContable#</td><td>&nbsp;&nbsp;</td>
						</cfif>
			
					<tr>		
				</cfloop>
				<cfif rsIncidencias.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>

			<cfif form.cmbOpcion eq 3>	<!--- si se trata de Deducciones------------------------------->
					<cfquery name="rsDeducciones" datasource="#session.dsn#">
					Select  c.Ecodigo as CodigoEmpresa, 
							c.Edescripcion as NombreEmpresa, 
							h.TDcodigo as TipoDeduccion, 
							h.TDdescripcion as DescripcionDeduccion, 
							h.SNcodigo as CodSocioNegocioDefecto, 
							g.SNnombre as DescSocioNegocioDefecto
					from TDeduccion h
						left outer join SNegocios g
						on h.SNcodigo=g.SNcodigo
						and h.Ecodigo=g.Ecodigo
						inner join Empresas c
						on h.Ecodigo=c.Ecodigo
					Where h.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					order by c.Ecodigo, h.TDcodigo
				</cfquery>

				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_TipoDeduccion">Tipo Deducci&oacute;n</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescripcionAccion">Descripci&oacute;n Acci&oacute;n</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoSNegocioDefecto">Cod. S. Negocio Defecto</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescripcionSNegocioDefecto">Descrip. S. Negocio Defecto</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>						</tr>
				<cfloop query="rsDeducciones">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsDeducciones.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDeducciones.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsDeducciones.TipoDeduccion#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsDeducciones.DescripcionDeduccion#</td><td>&nbsp;&nbsp;</td>
						
						<cfif  len(trim(rsDeducciones.CodSocioNegocioDefecto))  eq 0>
							<td align="center" bgcolor="FF0000">#rsDeducciones.CodSocioNegocioDefecto# XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" nowrap>#rsDeducciones.CodSocioNegocioDefecto#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						
						<cfif  len(trim(rsDeducciones.DescSocioNegocioDefecto)) eq 0>
							<td align="center" bgcolor="FF0000">#rsDeducciones.DescSocioNegocioDefecto# XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" nowrap>#rsDeducciones.DescSocioNegocioDefecto#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						
					<tr>		
				</cfloop>
				<cfif rsDeducciones.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>

			<cfif form.cmbOpcion eq 4>	<!--- SOCIOS DE NEGOCIO-------------------------------->
					<cfquery name="rsSNegocio" datasource="#session.dsn#">
					Select e.Ecodigo as CodigoEmpresa, 
						   e.Edescripcion as NombreEmpresa, 
						   b.SNcodigo as CodigoSocioNegocios, 
						   b.SNnombre as NombreSocioNegocios, 
						   b.SNcuentacxp as CodigoInternoCXP, 
						   c.Cformato as DescripcionCuentaContableCxP, 
						   b.SNcuentacxc as CodigoInternoCxC, 
						   d.Cformato as DescripcionCuentaContableCxC
					from SNegocios b
						left outer join CContables c
							on b.SNcuentacxp=c.Ccuenta
						left outer join CContables d
							on b.SNcuentacxc=d.Ccuenta
						inner join Empresas e
						on b.Ecodigo=e.Ecodigo
					Where b.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					order by e.Ecodigo, b.SNcodigo
				</cfquery>

				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoSocioNegocios">C&oacute;digo S. Negocios </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_NomSNegocio"> Nombre S. Negocio</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoInternoCXP"> C&oacute;digo Interno CXP</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescInternoCXP">Descrip. Cuenta Contable CxP </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoInternoCXC"> C&oacute;digo Interno CxC</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescInternoCXC"> Descrip. Cuenta Contable CxC</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
				</tr>
				<cfloop query="rsSNegocio">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsSNegocio.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsSNegocio.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsSNegocio.CodigoSocioNegocios#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsSNegocio.NombreSocioNegocios#</td><td>&nbsp;&nbsp;</td>
						
							<cfif  len(trim(rsSNegocio.CodigoInternoCXP))  eq 0 and len(trim(rsSNegocio.CodigoInternoCxC))  eq 0>
								<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
								<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
								<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
								<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
							<cfelse>
								<td align="center" >#rsSNegocio.CodigoInternoCXP# </td><td>&nbsp;&nbsp;</td>
								<td align="center" nowrap>#rsSNegocio.DescripcionCuentaContableCxP#</td><td>&nbsp;&nbsp;</td>
								<td align="center" >#rsSNegocio.CodigoInternoCxC# </td><td>&nbsp;&nbsp;</td>
								<td align="center" nowrap>#rsSNegocio.DescripcionCuentaContableCxC#</td><td>&nbsp;&nbsp;</td>
							</cfif>

					<tr>		
				</cfloop>
				<cfif rsSNegocio.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>
		
			<cfif form.cmbOpcion eq 5>	<!--- CARGAS-------------------------------------------------->
					<cfquery name="rsCargas" datasource="#session.dsn#">
					Select d.Ecodigo as CodigoEmpresa, 
				   d.Edescripcion as NombreEmpresa, 
				   b.ECcodigo as CodigoGrupoCargas, 
				   b.ECdescripcion as DescripcionGrupoCargas, 
				   a.DCcodigo as CodigoDetalleCargas, 
				   a.DCdescripcion as DetalleCargas, 
				   a.DCvaloremp as ValorEmp,       
				   a.DCvalorpat as ValorPat,
				   a.DCcuentac as ObjetoGasto, 
				   c.SNcodigo as CodigoSocioNegociosProveedor, 
				   c.SNnombre as DescSocioNegociosProveedor, 
				   e.Cformato as CuentaContableAsocProveedor,
				   f.SNcodigo as CodigoSocioNegociosCxC,
				   f.SNnombre as DescSocioNegociosProveedorCxC, 
				   g.Cformato as CuentaContableAsocProveedorCxC
			from DCargas a
				inner join ECargas b
				on a.ECid=b.ECid
				inner join Empresas d
				on a.Ecodigo=d.Ecodigo
				inner join SNegocios c
				on a.SNcodigo=c.SNcodigo
				and a.Ecodigo=c.Ecodigo
				left outer join CContables e
				 on c.SNcuentacxp = e.Ccuenta
				left outer join SNegocios f
				 on a.SNreferencia = f.SNcodigo 
				 and a.Ecodigo=f.Ecodigo     
					left outer join CContables g
					 on c.SNcuentacxc = g.Ccuenta
			where  a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			order by d.Ecodigo,b.ECcodigo,  a.DCcodigo
				</cfquery>

				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_No_tiene_ninguna_Cuenta_definida"> </cf_translate>C&oacute;digo Grupo Cargas</td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_No_tiene_ninguna_Cuenta_definida"> </cf_translate>Descripci&oacute;n Grupo Cargas</td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigDetalleCargas">C&oacute;digo Detalle Cargas </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DetalleCargas">Detalle Cargas </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_ValorEmp"> Valor Emp</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_ValorPat"> Valor Pat</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap>#LB_ObjetoGasto#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodSocNegProv">C&oacute;digo Socio Negocios Proveedor</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescCodSocNegProv">Desc. Socio Negocios Proveedor </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuentAsocProv">Cuenta Contable Asoc. Proveedor </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodSNCxC"> C&oacute;d. S.Negocio CxC</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_DescSNCxC"> Desc. S. Negocios Proveedor CxC</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuentContAsocProveeCxC">Cuenta Contable Asoc. Proveedor CxC </cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
	
				</tr>
				<cfloop query="rsCargas">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsCargas.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsCargas.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsCargas.CodigoGrupoCargas#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.DescripcionGrupoCargas#</td><td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsCargas.CodigoDetalleCargas#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.DetalleCargas#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.ValorEmp#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.ValorPat#</td><td>&nbsp;&nbsp;</td>
						<cfif trim(rsCargas.ValorPat) neq 0 and (len(trim(rsCargas.ObjetoGasto))  eq 0  and len(trim(rsCargas.CodigoSocioNegociosCxC))  eq 0 )>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" nowrap>#rsCargas.ObjetoGasto#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						<td align="left" nowrap>#rsCargas.CodigoSocioNegociosProveedor#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.DescSocioNegociosProveedor#</td><td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsCargas.CuentaContableAsocProveedor#</td><td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsCargas.CodigoSocioNegociosCxC#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCargas.DescSocioNegociosProveedorCxC#</td><td>&nbsp;&nbsp;</td>
						
						<cfif trim(rsCargas.ValorPat) neq 0 and (len(trim(rsCargas.ObjetoGasto))  eq 0  and len(trim(rsCargas.CodigoSocioNegociosCxC))  eq 0 )>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
						<td align="center" nowrap>#rsCargas.CuentaContableAsocProveedorCxC#</td><td>&nbsp;&nbsp;</td>
						</cfif>
					<tr>		
				</cfloop>
				
				<cfif rsCargas.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>
			
			<cfif form.cmbOpcion eq 6>	<!--- CENTROS FUNCIONALES--------------------------->
					<cfquery name="rsCF" datasource="#session.dsn#">
				Select  b.Ecodigo as CodigoEmpresa, 
						b.Edescripcion as NombreEmpresa, 
						CFcodigo as CodigoCentroFuncional, 
						CFdescripcion as DescCentroFuncional, 
						CFcuentac as MascaraContable
				from CFuncional a
				inner join Empresas b
				on a.Ecodigo=b.Ecodigo
				Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					and a.CFestado=1

				</cfquery>

				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="left" class="subrayados" nowrap><cf_translate key="LB_CodCF">C&oacute;digo Centro Funcional</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="left" class="subrayados" nowrap> <cf_translate key="LB_DescCF">Descrip. Centro Funcional</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_MascaraCont">Mascara Contable</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
				</tr>
				<cfloop query="rsCF">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsCF.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsCF.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCF.CodigoCentroFuncional#</td><td>&nbsp;&nbsp;</td>
						<td align="left" nowrap>#rsCF.DescCentroFuncional#</td><td>&nbsp;&nbsp;</td>

						<cfif  len(trim(rsCF.MascaraContable))  eq 0>
							<td align="center" bgcolor="FF0000">#rsCF.MascaraContable# XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" nowrap>#rsCF.MascaraContable#</td><td>&nbsp;&nbsp;</td>
						</cfif>
					<tr>		
				</cfloop>
				
				<cfif rsCF.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>
			
			<cfif form.cmbOpcion eq 7>	<!--- CATALOGO CONTABLE----------------------------->
					<cfquery name="rsCatContable" datasource="#session.dsn#">
					Select  b.Ecodigo as CodigoEmpresa, 
							b.Edescripcion as NombreEmpresa, 
							c.Cmayor as CodCuentaMayor,
							c.Cdescripcion as DescCuentaMayor,
							a.CFformato as CodigoCentroFuncional, 
							a.CFdescripcion as DescCuenta,
							a.CFmovimiento as PermiteMovimientos
					from CFinanciera a
					inner join Empresas b
					on a.Ecodigo=b.Ecodigo
					inner join CtasMayor c
					on a.Cmayor=c.Cmayor
					and c.Ecodigo=a.Ecodigo
					Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					order by c.Cmayor, a.Ecodigo, a.CFformato
				</cfquery>

				<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>#LB_CodigoEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>#LB_NombreEmpresa#</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuentaMayor"> Cuenta Mayor</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuenCont">Cuenta Contable</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_CodigoCentroF">C&oacute;digo Centro Funcional</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="left" class="subrayados" nowrap><cf_translate key="LB_DescrCuenta">Descripci&oacute;n Cuenta</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
						<td align="center" class="subrayados" nowrap><cf_translate key="LB_PermiteMov">Permite Movimientos</cf_translate></td>
						<td class="subrayados">&nbsp;&nbsp;</td>		
				</tr>
				<cfloop query="rsCatContable">	
					<tr class="sRegistros">
						<td align="center" nowrap>#rsCatContable.CodigoEmpresa#</td><td>&nbsp;&nbsp;</td>
						<td nowrap>#rsCatContable.NombreEmpresa #</td>	<td>&nbsp;&nbsp;</td>
						
						<cfif  len(trim(rsCatContable.CodCuentaMayor))  eq 0>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="center" nowrap>#rsCatContable.CodCuentaMayor#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						
						<cfif  len(trim(rsCatContable.DescCuentaMayor))  eq 0>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="left" nowrap>#rsCatContable.DescCuentaMayor#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						
						<td align="left" nowrap>#rsCatContable.CodigoCentroFuncional#</td><td>&nbsp;&nbsp;</td>
					
						<cfif  len(trim(rsCatContable.DescCuenta))  eq 0>
							<td align="center" bgcolor="FF0000">XXXX</td><td>&nbsp;&nbsp;</td>
						<cfelse>
							<td align="left" nowrap>#rsCatContable.DescCuenta#</td><td>&nbsp;&nbsp;</td>
						</cfif>
						
						<td align="center" nowrap>#rsCatContable.PermiteMovimientos#</td><td>&nbsp;&nbsp;</td>

					<tr>		
				</cfloop>
				
				<cfif rsCatContable.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">#LB_NoExistenRegistros#</td></tr>
				</cfif>
			</cfif>
			
			<cfif form.cmbOpcion eq 8><!--- combinacion de cuentas--->	
								
			<!--- verificación post combinacion :  La funcionalidad de la combinación de Cuentas es para verificar que las cuentas se formen correctamente-
			por lo que para realizar esta verificación de combinaciones se debería de verificar que los Objetos de gastos y demás configuraciones ya se realizaron--->
							
			<!--- verificando Acciones de personas--->
					<cfquery name="verificacionAcciones" datasource="#session.dsn#">
					   select  distinct rtrim(a.RHTcuentac) as valor
						from RHTipoAccion a 
							inner join Empresas b
							on a.Ecodigo=b.Ecodigo
						Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">  
						and a.RHTcuentac is null
						and a.RHTespecial=0
					</cfquery>
					
			<!--- verificando Conceptos de pago--->
					<cfquery name="verificacionConceptos" datasource="#session.dsn#">
						Select 1
						from CIncidentes a
							left outer join CContables e
							on a.Ccuenta= e.Ccuenta
							inner join Empresas b
							on a.Ecodigo=b.Ecodigo
						Where b.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">  
						and rtrim(a.CIcuentac) is null
						and rtrim(e.Cformato) is null
					</cfquery>
					
			
			<!--- verificando Cargas--->
				<cfquery name="verificacionCargas" datasource="#session.dsn#">
							Select 1
						from DCargas a
						inner join ECargas b
						on a.ECid=b.ECid
						inner join Empresas d
						on a.Ecodigo=d.Ecodigo
						inner join SNegocios c
						on a.SNcodigo=c.SNcodigo
						and a.Ecodigo=c.Ecodigo
						left outer join CContables e
						 on c.SNcuentacxp = e.Ccuenta
						left outer join SNegocios f
						 on a.SNreferencia = f.SNcodigo 
						 and a.Ecodigo=f.Ecodigo     
							left outer join CContables g
							 on c.SNcuentacxc = g.Ccuenta
						where  a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">  
						and  a.DCvalorpat <>0
						and rtrim(a.DCcuentac) is null
						and  f.SNcodigo is null
				</cfquery>
				<cfset varAbortar=false>
				<cfoutput>
				
				<cfif verificacionAcciones.RecordCount GT 0  or verificacionConceptos.RecordCount GT 0  or verificacionCargas.RecordCount GT 0>
								<b  style="color:FF0000"><center><u><cf_translate key="LB_Errores">INCONVENIENTES ENCONTRADOS:</cf_translate></center></u></b>
								<br>
				</cfif>
				<cfif verificacionAcciones.RecordCount GT 0 >
					<br /> <span style='display:inline; white-space:pre;'> </span><cf_translate key="LB_VerifiqueAcciones">• Algunas <b>Acciones</b> no se están correctamente configuradas. Por favor consulte por '<b><i>Acciones'</i></b> y corrija los errores</cf_translate><br />
					<cfset varAbortar=true>
				</cfif>
				<cfif verificacionConceptos.RecordCount GT 0 >
					<br /> <span style='display:inline; white-space:pre;'> </span><cf_translate key="LB_VerifiqueConceptos">• Algunos <b>Conceptos de Pago</b> no se están correctamente configurados. Por favor consulte por '<b><i>Conceptos de Pago</i></b>' y corrija los errores</cf_translate><br />
					<cfset varAbortar=true>
				</cfif>
				<cfif verificacionCargas.RecordCount GT 0 >
					<br /><span style='display:inline; white-space:pre;'> </span><cf_translate key="LB_VerifiqueCargas">• Algunas <b>Cargas Obrero Patronales</b> no se están correctamente configuradas. Por favor consulte por '<b><i>Cargas Obrero Patronales</i></b>' y corrija los errores</cf_translate><br />
					<cfset varAbortar=true>
				</cfif>
				</cfoutput>
				<cfif varAbortar><cfabort></cfif>
				
				<!--- fin de verificaciones --->
				
				<!---- comienzo de combinaciones--->	
								
						<!--- máscaras de los centros funcionales--->
						<cfquery name="rsCFmascara" datasource="#session.dsn#">		
							select cf.CFid, cf.CFdescripcion, cf.CFcuentac as cuenta
							from CFuncional cf						
							Where cf.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							and cf.CFestado=1
						</cfquery>
						<!--- cuentas contables válidas---->					
						<cfquery name="rsCatContable" datasource="#session.dsn#">
							Select distinct rtrim(a.CFformato) as formato
		
							from CFinanciera a
							inner join Empresas b
							on a.Ecodigo=b.Ecodigo
							inner join CtasMayor c
							on a.Cmayor=c.Cmayor
							and c.Ecodigo=a.Ecodigo
							Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							order by c.Cmayor, a.Ecodigo, a.CFformato
						</cfquery>
					
						<cfquery name="rsAcciones" datasource="#session.dsn#">
						   select  distinct rtrim(a.RHTcuentac) as ObjetoGasto
							from RHTipoAccion a 
								inner join Empresas b
								on a.Ecodigo=b.Ecodigo
							Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
								and a.RHTespecial=0
						</cfquery>
						
						<cfquery name="rsIncidencias" datasource="#session.dsn#">
								Select distinct a.CIcuentac as ObjetoGasto
							from CIncidentes a
								left outer join CContables e
								on a.Ccuenta= e.Ccuenta
								inner join Empresas b
								on a.Ecodigo=b.Ecodigo
							Where a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
								and rtrim(e.Cformato) is null
						</cfquery>

						<cfquery name="rsCargas" datasource="#session.dsn#">
								Select distinct a.DCcuentac as ObjetoGasto
								from DCargas a
								inner join ECargas b
								on a.ECid=b.ECid
								inner join Empresas d
								on a.Ecodigo=d.Ecodigo
								inner join SNegocios c
								on a.SNcodigo=c.SNcodigo
								and a.Ecodigo=c.Ecodigo
								left outer join CContables e
								 on c.SNcuentacxp = e.Ccuenta
								left outer join SNegocios f
								 on a.SNreferencia = f.SNcodigo 
								 and a.Ecodigo=f.Ecodigo     
									left outer join CContables g
									 on c.SNcuentacxc = g.Ccuenta
								where  a.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric"> 
								and  a.DCvalorpat <>0
								and  f.SNcodigo is null
						</cfquery>
	
		
						<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
					
						<cfset okAll=true>	
						<cfloop query="rsCFmascara">
							<cfset titulo = true>
							
								<cfif len(rtrim(rsCFmascara.cuenta)) eq 0>
									<tr>
												<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
												
												<td  align="center" colspan="6"nowrap bgcolor="FF0000"><b><i><cf_translate key="LB_No_tiene_ninguna_Cuenta_definida">El Centro Funcional '<b>#uCase(rsCFmascara.CFdescripcion)#</b>' est&aacute; activo pero no tiene ninguna Cuenta definida</cf_translate></i></b></td>
												<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
												<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
												<cfset okAll=false>	
									<tr>						
								<cfelse>  
								
								<cfset tabla="">

								<cfloop from="1" to="3" index="i">
										<cfif i eq 1>
											<cfset tabla=#rsAcciones#>
										<cfelseif i eq 2>		
											<cfset tabla=#rsIncidencias#>
										<cfelseif i eq 3>		
											<cfset tabla=#rsCargas#>
										</cfif>
										
										<!---  combinaciones ---->
									
										<cfset okObjeto = true>
									
									
										<cfloop query="tabla">
											<cfset ok=false>	
											
											<cfset LvarFormatoCuenta = mascara.AplicarMascara(rsCFmascara.cuenta,tabla.ObjetoGasto)>
											
												<cfloop query="rsCatContable">
														<cfif rtrim(LvarFormatoCuenta) eq rtrim(rsCatContable.formato)><cfset ok=true></cfif>
												</cfloop>
											
												<cfif ok eq false>
												<cfif titulo eq true>
													<tr class="stitulo">
															<td align="left"     class="subrayados" nowrap><cf_translate key="LB_CFuncional">Centro Funcional </cf_translate></td>
															<td align="left"     class="subrayados" nowrap><cf_translate key="LB_TIPO">Tipo</cf_translate></td>
															<td align="center"     class="subrayados" nowrap><cf_translate key="LB_Mascara">M&aacute;scara </cf_translate></td>
															<td align="center" class="subrayados" nowrap>#LB_ObjetoGasto#</td>
															<td align="center" class="subrayados" nowrap><cf_translate key="LB_ContableConstruida">Cuenta Contable Construida</cf_translate></td>
															<td align="center" class="subrayados" nowrap><cf_translate key="LB_CuentaValida">¿Es Cuenta V&aacute;lida?</cf_translate></td>
													</tr>
												</cfif>
												<cfset titulo=false>
														<tr>
															<td align="left" nowrap>#uCase(rsCFmascara.CFdescripcion)#</td>
															<td align="left" nowrap>
																<cfif i eq 1>Tipos de Acci&oacute;n
																<cfelseif i eq 2>Conceptos de Pago
																<cfelseif i eq 3>	Cargas Obrero Patronales 
																</cfif>
															</td>
															<td align="left" nowrap>#rsCFmascara.cuenta# </td>
															<td align="center" nowrap>#tabla.ObjetoGasto# </td>
															<td align="center" nowrap >#LvarFormatoCuenta# </td>
															<td align="center" nowrap bgcolor="FF0000" >NO</td>
														</tr>	
														<cfset ok=true>	
														<cfset okObjeto = false>
														<cfset okAll=false>		
												</cfif>	
										</cfloop><!--- fin de cfloop--->
										
										<!--- fin de combinaciones ---->
								</cfloop>

										</tr>
								</cfif><!--- fin if  si tiene cuenta--->
						</cfloop>
		
				<cfif okAll>
						<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
						<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
						<td  align="center" colspan="6" nowrap bgcolor="00CC00"><cf_translate key="LB_Todas_Cuentas_Centro Funcional"><b>Todas las combinaciones de Cuentas Son v&aacute;lidas !!</b></cf_translate></td>			
						<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
						<tr><td colspan="6">&nbsp;&nbsp;</td></tr>	
				</cfif>		
	
			</cfif>		
		</table></td></tr>
	</table>
</cfoutput>