<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Catalogo de Nivel Independiente</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
	<body style="margin:0;"> 
		<cfinclude template="ParametrosNiveles.cfm">
		<cfset fnUrlToFormParam ("Cmayor", "")>
		<cfset fnUrlToFormParam ("txt_codigo", "")>
		<cfset fnUrlToFormParam ("txt_descripcion", "")>
		<cfset fnUrlToFormParam ("nivel", "")>
		<cfset fnUrlToFormParam ("nivelDepende", "")>
		<cfset fnUrlToFormParam ("refID", "-1")>
		<cfset fnUrlToFormParam ("refValor", "")>
		<cfset fnUrlToFormParam ("Ecodigo", "")>
		<cfset navegacion = GvarUrlToFormParam>
		<cfset filtro = "">
		
		<cfset LvarOcodigo = "">
		<cfif isdefined("URL.OFICINA")>
		
			<cfquery name="rsOficina" datasource="#session.dsn#">
			Select Ocodigo
			from Oficinas
			where Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.OFICINA#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			</cfquery>
			<cfset LvarOcodigo = rsOficina.Ocodigo>	
		
		</cfif>
		
		<cfif isdefined("url.accion") and url.accion eq "exportar">
			<cfcontent type="application/msexcel">
			<cfheader name="Content-Disposition" value="attachment;filename=Datos_Niv_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" >
		
			<cfif Len(Trim(Form.txt_codigo))>
				<cfset filtro = filtro & " and v.PCDvalor like '%#Form.txt_codigo#%'">
			</cfif>
			<cfif Len(Trim(Form.txt_descripcion))>
				<cfset filtro = filtro & " and upper(v.PCDdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
			</cfif>
			
			<cfif URL.RefID 	EQ ""><cfset URL.RefID		= "-1"></cfif>
			<cfif URL.RefValor EQ ""><cfset URL.RefValor	= "-1"></cfif>
		
			<cfquery name="rsCatPadre" datasource="#Session.DSN#">
				select PCEcodigo, PCEdescripcion, PCEempresa
				  from PCECatalogo
				 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
			</cfquery>
		
			<!--- Busca Referencia por Cuenta Mayor --->
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select r.PCEdescripcion as Titulo, m.PCEcatidref, m.Cmayor, r.PCEcodigo
				  FROM PCDCatalogo v 
					INNER JOIN PCECatalogo c 
						 ON c.PCEcatid = v.PCEcatid
						AND c.PCEempresa = 1
					INNER JOIN PCDCatalogoRefMayor m
						INNER JOIN PCECatalogo r
							 ON r.PCEcatid = m.PCEcatidref
						 ON m.PCDcatid 	= v.PCDcatid
						AND m.Ecodigo	= v.Ecodigo
						AND m.Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#URL.Cmayor#">
				 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
				   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RefValor#">
				   AND v.Ecodigo  = #session.Ecodigo#
			</cfquery>
	
			<cfif rsSQL.recordCount EQ 0>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					SELECT r.PCEdescripcion as Titulo, v.PCEcatidref, '-1' as Cmayor, r.PCEcodigo
					  FROM PCDCatalogo v 
						INNER JOIN PCECatalogo r
							 ON r.PCEcatid = v.PCEcatidref
					 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
					   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RefValor#">
					<cfif rsCatPadre.PCEempresa EQ 1>
					   AND v.Ecodigo = #session.Ecodigo#
					</cfif>
				</cfquery>
			</cfif>
			<cfset rsTitulo = rsSQL>
			<cfif rsSQL.PCEcatidref EQ "">
				<cfset LvarPCEcatidref = "-1">
			<cfelse>
				<cfset LvarPCEcatidref = rsSQL.PCEcatidref>
			</cfif>

			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="C&oacute;digo"
			returnvariable="LB_CODIGO"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DESCRIPCION"
			Default="Descripci&oacute;n"
			returnvariable="LB_DESCRIPCION"/>
			
			<cfquery name="Niveles" datasource="#session.dsn#">
				select v.PCDvalor as Valor, v.PCDdescripcion as Descripcion
				from PCECatalogo c, PCDCatalogo v
				where c.PCEcatid = #LvarPCEcatidref#
					and c.PCEactivo = 1
					and v.PCEcatid = c.PCEcatid
					and ( 
						(c.PCEempresa = 1 and v.Ecodigo = #URL.Ecodigo#) or 
						(c.PCEempresa = 0 and v.Ecodigo is null) 
					   )
					
					and (
						(c.PCEoficina = 1 
						<cfif len(trim(LvarOcodigo)) GT 0>
						and exists (Select 1 
								from PCDCatalogoValOficina vo
								where vo.PCDcatid = v.PCDcatid
								   and vo.Ocodigo = #LvarOcodigo#)   
						</cfif>
						)
						or
					
						c.PCEoficina = 0 
					
					  )
										
					  and (
							(
							c.PCEvaloresxmayor = 1
							and exists (Select 1
									  from PCDCatalogoPorMayor cxm
									  where cxm.PCEcatid = c.PCEcatid
										and cxm.PCDcatid = v.PCDcatid
										and cxm.Cmayor = '#trim(form.Cmayor)#'
										and cxm.Ecodigo = #session.ecodigo#)
							)
							
							or
							
							c.PCEvaloresxmayor = 0
							
						)						
					
					and v.PCDactivo = 1
					
					#filtro#
					order by v.PCDvalor, v.PCDdescripcion
			</cfquery>
			<table>
			<tr>
				<td><cfoutput>#LB_CODIGO#</cfoutput></td>
				<td><cfoutput>#LB_DESCRIPCION#</cfoutput></td>
			</tr>
			<cfoutput query="Niveles">
			<tr>
				<td>#Valor#</td>
				<td>#Descripcion#</td>
			</tr>
			</cfoutput>
			</table>
		<cfelse>
		
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
			<cfif URL.RefID EQ -1 OR URL.RefValor EQ "">
				<td align="center" class="tituloListas" style="font-size:11px"><cfoutput><strong>Lista del Catálogo para el Nivel #URL.nivel# (depende del valor en el Nivel #URL.nivelDepende#)</strong></cfoutput></td>
			<cfelse>
				<cfif Len(Trim(Form.txt_codigo))>
					<cfset filtro = filtro & " and v.PCDvalor like '%#Form.txt_codigo#%'">
				</cfif>
				<cfif Len(Trim(Form.txt_descripcion))>
					<cfset filtro = filtro & " and upper(v.PCDdescripcion) like '%#UCase(Form.txt_descripcion)#%'">
				</cfif>
				
				<script language="javascript" type="text/javascript">
					function Asignar(CG12ID, descripcion) {
						
						<cfif url.origen EQ "R">	
					
							if (window.opener != null) {
					
									var obj = eval("window.opener.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>" )
					
									obj.value = CG12ID;
					
									window.close();
					
							}
					
						<cfelse>
					
								var obj = eval("window.parent.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>" )
					
								obj.value = CG12ID;
					
								obj.focus();
					
						</cfif>					
						
						/*
						if (window.parent.sbResultadoConLisCFnivel) {
							window.parent.sbResultadoConLisCFnivel(valor, descripcion, <cfoutput>#URL.nivel#</cfoutput>);
						}*/
					}
				</script>
			
				<cfif URL.RefID 	EQ ""><cfset URL.RefID		= "-1"></cfif>
				<cfif URL.RefValor EQ ""><cfset URL.RefValor	= "-1"></cfif>
		
				<cfquery name="rsCatPadre" datasource="#Session.DSN#">
					select PCEcodigo, PCEdescripcion, PCEempresa
					  from PCECatalogo
					 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
				</cfquery>
		
				<!--- Busca Referencia por Cuenta Mayor --->
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select r.PCEdescripcion as Titulo, m.PCEcatidref, m.Cmayor, r.PCEcodigo
					  FROM PCDCatalogo v 
						INNER JOIN PCECatalogo c 
							 ON c.PCEcatid = v.PCEcatid
							AND c.PCEempresa = 1
						INNER JOIN PCDCatalogoRefMayor m
							INNER JOIN PCECatalogo r
								 ON r.PCEcatid = m.PCEcatidref
							 ON m.PCDcatid 	= v.PCDcatid
							AND m.Ecodigo	= v.Ecodigo
							AND m.Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#URL.Cmayor#">
					 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
					   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RefValor#">
					   AND v.Ecodigo  = #session.Ecodigo#
				</cfquery>
		
				<cfif rsSQL.recordCount EQ 0>
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						SELECT r.PCEdescripcion as Titulo, v.PCEcatidref, '-1' as Cmayor, r.PCEcodigo
						  FROM PCDCatalogo v 
							INNER JOIN PCECatalogo r
								 ON r.PCEcatid = v.PCEcatidref
						 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.RefID#">
						   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.RefValor#">
						<cfif rsCatPadre.PCEempresa EQ 1>
						   AND v.Ecodigo = #session.Ecodigo#
						</cfif>
					</cfquery>
				</cfif>
				<cfset rsTitulo = rsSQL>
				<cfif rsSQL.PCEcatidref EQ "">
					<cfset LvarPCEcatidref = "-1">
				<cfelse>
					<cfset LvarPCEcatidref = rsSQL.PCEcatidref>
				</cfif>
				<td align="center" class="tituloListas" style="font-size:11px">
					<cfoutput><strong>
					<cfif LvarPCEcatidref EQ "-1">
						<cf_translate  key="LB_NoSeAsignoCatalogoDeReferenciaParaElValor">No se Asignó Catálogo de Referencia para el Valor</cf_translate> '#URL.refValor#' <cf_translate  key="LB_DelNivel">del Nivel</cf_translate> #URL.nivelDepende#
					<cfelse>
						<cf_translate  key="LB_Nivel">Nivel</cf_translate> #URL.nivel#:
						<cf_translate  key="LB_Catalogo">Catálogo</cf_translate> '#rsTitulo.PCEcodigo# - #rsTitulo.titulo#'<br>
						(<cf_translate  key="LB_DependeDelNiv">Depende del Nivel</cf_translate> #URL.nivelDepende#: <cf_translate key="LB_DependeDelCat">Catálogo</cf_translate> '#rsCatPadre.PCEcodigo# - #rsCatPadre.PCEdescripcion#', <cf_translate  key="LB_DependeDelVal">Valor</cf_translate> '#URL.refValor#'<cfif rsSQL.Cmayor NEQ "-1">, <cf_translate  key="LB_ParaCuentaMayor">Cuenta Mayor</cf_translate> '#rsSQL.Cmayor#'</cfif> )
					</cfif>
					</strong></cfoutput>
				</td>
		
				<cfoutput>
				<script language="javascript">
					window.parent.document.getElementById('refID#URL.nivel#').value = '#LvarPCEcatidref#';
				</script>
				</cfoutput>
			  </tr>
			  <tr>
				<td class="areaFiltro">
					<cfoutput>
		
					<form name="filtroCuentas" method="post" style="margin: 0;" action="#GetFileFromPath(GetTemplatePath())#">
						<cfloop collection="#Form#" item="i">
							<cfset v = StructFind(Form, i)>
							<cfif CompareNoCase(i, "txt_codigo") and CompareNoCase(i, "txt_descripcion") and Len(Trim(v))>
								<input type="hidden" name="#i#" value="#v#">
							</cfif>
						</cfloop>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_CODIGO"
						Default="C&oacute;digo"
						returnvariable="LB_CODIGO"/>
				
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_DESCRIPCION"
						Default="Descripci&oacute;n"
						returnvariable="LB_DESCRIPCION"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Buscar"
						Default="Buscar"
						returnvariable="BTN_Buscar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Exportar"
						Default="Exportar"
						returnvariable="BTN_Exportar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Imprimir"
						Default="Imprimir"
						returnvariable="BTN_Imprimir"/>
						
						<table width="100%"  border="0" cellspacing="0" cellpadding="3">
						  <tr>
							<td align="right" class="fileLabel">#LB_CODIGO#:</td>
							<td>
								<input name="txt_codigo" type="text" size="10" maxlength="10" value="<cfif isdefined('Form.txt_codigo')>#Form.txt_codigo#</cfif>">
							</td>
							<td align="right" class="fileLabel">#LB_DESCRIPCION#:</td>
							<td>
								<input name="txt_descripcion" type="text" size="40" maxlength="80" value="<cfif isdefined('Form.txt_descripcion')>#Form.txt_descripcion#</cfif>">
							</td>
							<td align="center">
								<input name="btnBuscar" type="submit" value="#BTN_Buscar#">
								&nbsp;&nbsp;&nbsp;&nbsp;<input name="btnExportar" type="button" value="#BTN_Exportar#" onclick="window.location='MuestraDatosSubNiveles.cfm?#CGI.QUERY_STRING#&accion=exportar'">
								&nbsp;&nbsp;&nbsp;&nbsp;<input name="btnImprimir" type="button" value="#BTN_Imprimir#" onclick="javascript:imprimir();">
							</td>
						  </tr>
						</table>
						<script>
							function imprimir(){
								window.print();
							}
						</script>
					</form>
					</cfoutput>
				</td>
			  </tr>
			  <tr>
				<td>
					<cfset LvarConsulta =''>
					<cfif len(trim(LvarOcodigo)) GT 0>
						<cfset LvarConsulta =	'and exists (Select 1 
													from PCDCatalogoValOficina vo
													where vo.PCDcatid = v.PCDcatid
													   and vo.Ocodigo = ' & #LvarOcodigo#&')' >
				    </cfif>				
				
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="PCECatalogo c, PCDCatalogo v"/>
						<cfinvokeargument name="columnas" value="v.PCDvalor as Valor, v.PCDdescripcion as Descripcion"/>
							<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
							<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="
																   c.PCEcatid = #LvarPCEcatidref#
																   and c.PCEactivo = 1
																   and v.PCEcatid = c.PCEcatid
																   and ( 
																		(c.PCEempresa = 1 and v.Ecodigo = #URL.Ecodigo#) or 
																		(c.PCEempresa = 0 and v.Ecodigo is null) 
																	   )
	
																   and (
																		(c.PCEoficina = 1 
																		
																		#LvarConsulta#
																					)
																		or
																
																		c.PCEoficina = 0 
																
																	  )
																	  
																  and (
																		(
																		c.PCEvaloresxmayor = 1
																		and exists (Select 1
																				  from PCDCatalogoPorMayor cxm
																				  where cxm.PCEcatid = c.PCEcatid
																					and cxm.PCDcatid = v.PCDcatid
																					and cxm.Cmayor = '#trim(form.Cmayor)#'
																					and cxm.Ecodigo = #session.ecodigo#)
																		)
																		
																		or
																		
																		c.PCEvaloresxmayor = 0
																		
																	)																			  
		  
																   and v.PCDactivo = 1
																   
																   #filtro#
																   order by v.PCDvalor, v.PCDdescripcion"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value=""/>
						<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
						<cfinvokeargument name="formName" value="listaCuentas"/>
						<cfinvokeargument name="MaxRows" value="200"/>
						<cfinvokeargument name="funcion" value="Asignar"/>
						<cfinvokeargument name="fparams" value="Valor, Descripcion"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
				</td>
			  </tr>
			</cfif>
			<cfif URL.RefID EQ -1 OR URL.RefValor EQ "">
			  <tr>
					<td height="100%" align="center" valign="middle" style="font-size:14px; color:#FF0000;"><cfoutput><strong>Favor digite primero un valor en el Nivel #URL.nivelDepende#</strong></cfoutput></td>
			  </tr>
			 </cfif>
			</table>
		</cfif>
	</body>
</html>