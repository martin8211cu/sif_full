<!--- Tag de Cuentas --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LstCatNivInd" Default="Lista de Catalogo de Nivel Independiente" returnvariable="LB_LstCatNivInd"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_LstCatParaNivel" Default="Lista del Catálogo para el Nivel" returnvariable="LB_LstCatParaNivel"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DepValorNivel" Default="depende del valor en el Nivel" returnvariable="LB_DepValorNivel"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FavorDigValor" Default="Favor digite primero un valor en el Nivel" returnvariable="LB_FavorDigValor"/>

<html>
<head>
<title>#LB_LstCatNivInd#</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
	<body style="margin:0;"> 
		<cfinclude template="ConlisCuentasFinancierasParams.cfm">
		<cfset fnUrlToFormParam ("Cmayor", "")>
		<cfset fnUrlToFormParam ("txt_codigo", "")>
		<cfset fnUrlToFormParam ("txt_descripcion", "")>
		<cfset fnUrlToFormParam ("nivel", "")>
		<cfset fnUrlToFormParam ("nivelDepende", "")>
		<cfset fnUrlToFormParam ("refID", "-1")>
		<cfset fnUrlToFormParam ("refValor", "")>
		<cfset fnUrlToFormParam ("Ecodigo", "")>
		
		<cfif isdefined("url.Ocodigo")>
			<cfset fnUrlToFormParam ("Ocodigo", "")>
			<cfset LvarOcodigo=form.Ocodigo>
		</cfif>		
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 99
		</cfquery>
		<!---Parametro para tomar la descripcion de la cuenta de mayor segun el idioma--->
        <cfquery datasource="#session.dsn#" name="rsParametroIdioma">
            select coalesce(Pvalor,0) as Valor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Pcodigo = 200010
        </cfquery>
        <cfset varParametroI = rsParametroIdioma.Valor>
        <cfif varParametroI EQ 1>
            <cfset vartabla = "PCECatalogo c, PCDCatalogo v 
                                    left join PCDCatalogoIdioma id 
                                        inner join Idiomas i on i.Iid = id.Iid and i.Icodigo = '#session.Idioma#'
                                    on v.PCEcatid = id.PCEcatid and v.PCDcatid = id.PCDcatid">
            <cfif rsSQL.Pvalor EQ "1">
                <cfset LvarPCDdescripcion = "coalesce(id.PCDdescripcionI,v.PCDdescripcionA,v.PCDdescripcion)">
            <cfelse>
                <cfset LvarPCDdescripcion = "coalesce(id.PCDdescripcionI,v.PCDdescripcion)">
            </cfif>
        <cfelse>
            <cfset vartabla = "PCECatalogo c, PCDCatalogo v">
            <cfif rsSQL.Pvalor EQ "1">
                <cfset LvarPCDdescripcion = "coalesce(v.PCDdescripcionA,v.PCDdescripcion)">
            <cfelse>
                <cfset LvarPCDdescripcion = "v.PCDdescripcion">
            </cfif>
        </cfif>
		<!---<cfif rsSQL.Pvalor EQ "1">
			<cfset LvarPCDdescripcion = "coalesce(v.PCDdescripcionA,v.PCDdescripcion)">
		<cfelse>
			<cfset LvarPCDdescripcion = "v.PCDdescripcion">
		</cfif>--->
		
		<cfset navegacion = GvarUrlToFormParam>
		<cfset filtro = "">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		<cfif form.RefID EQ -1 OR form.RefValor EQ "">
			<td align="center" class="tituloListas" style="font-size:11px"><cfoutput><strong>#LB_LstCatParaNivel# #form.nivel# (#LB_DepValorNivel# #form.nivelDepende#)</strong></cfoutput></td>
		<cfelse>
			<cfif Len(Trim(Form.txt_codigo))>
				<cfset filtro = filtro & " and v.PCDvalor like '%#Form.txt_codigo#%'">
			</cfif>
			<cfif Len(Trim(Form.txt_descripcion))>
				<cfset filtro = filtro & " and upper(#LvarPCDdescripcion#) like '%#UCase(Form.txt_descripcion)#%'">
			</cfif>
			
			<script language="javascript" type="text/javascript">
				function Asignar(valor, descripcion) {
					if (window.parent.sbResultadoConLisCFnivel) {
						window.parent.sbResultadoConLisCFnivel(valor, descripcion, <cfoutput>#form.nivel#</cfoutput>);
					}
				}
			</script>
		
			<cfif form.RefID 	EQ ""><cfset form.RefID		= "-1"></cfif>
			<cfif form.RefValor EQ ""><cfset form.RefValor	= "-1"></cfif>
	
			<cfquery name="rsCatPadre" datasource="#Session.DSN#">
				select PCEcodigo, PCEdescripcion, PCEempresa
				  from PCECatalogo
				 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RefID#">
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
						AND m.Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
				 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RefID#">
				   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RefValor#">
				   AND v.Ecodigo  = #session.Ecodigo#
			</cfquery>
	
			<cfif rsSQL.recordCount EQ 0>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					SELECT r.PCEdescripcion as Titulo, v.PCEcatidref, '-1' as Cmayor, r.PCEcodigo
					  FROM PCDCatalogo v 
						INNER JOIN PCECatalogo r
							 ON r.PCEcatid = v.PCEcatidref
					 WHERE v.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RefID#">
					   AND v.PCDvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RefValor#">
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
					<cf_translate  key="LB_NoSeAsignoCatalogoDeReferenciaParaElValor">No se Asignó Catálogo de Referencia para el Valor</cf_translate> '#form.refValor#' <cf_translate  key="LB_DelNivel">del Nivel</cf_translate> #form.nivelDepende#
				<cfelse>
					<cf_translate  key="LB_Nivel">Nivel</cf_translate> #form.nivel#:
					<cf_translate  key="LB_Catalogo">Catálogo</cf_translate> '#rsTitulo.PCEcodigo# - #rsTitulo.titulo#'<br>
					(<cf_translate  key="LB_DependeDelNiv">Depende del Nivel</cf_translate> #form.nivelDepende#: <cf_translate key="LB_DependeDelCat">Catálogo</cf_translate> '#rsCatPadre.PCEcodigo# - #rsCatPadre.PCEdescripcion#', <cf_translate  key="LB_DependeDelVal">Valor</cf_translate> '#form.refValor#'<cfif rsSQL.Cmayor NEQ "-1">, <cf_translate  key="LB_ParaCuentaMayor">Cuenta Mayor</cf_translate> '#rsSQL.Cmayor#'</cfif> )
				</cfif>
				</strong></cfoutput>
			</td>
	
			<cfoutput>
			<script language="javascript">
				window.parent.document.getElementById('refID#form.nivel#').value = '#LvarPCEcatidref#';
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
						</td>
					  </tr>
					</table>
				</form>
				</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td>
			
				<cfset LvarConsulta =''>
				<cfif isdefined("LvarOcodigo") and LvarOcodigo neq -1>
					<cfif len(trim(LvarOcodigo)) GT 0>
						<cfset LvarConsulta =	'and exists (Select 1 
													from PCDCatalogoValOficina vo
													where vo.PCDcatid = v.PCDcatid
													   and vo.Ocodigo = ' & #LvarOcodigo#&')' >
					</cfif>
				</cfif>			
			
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="#vartabla#"/>
					<cfinvokeargument name="columnas" value="v.PCDvalor as Valor, #LvarPCDdescripcion# as Descripcion"/>
						<cfinvokeargument name="desplegar" value="Valor, Descripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="
															   c.PCEcatid = #LvarPCEcatidref#
															   and c.PCEactivo = 1
															   and v.PCEcatid = c.PCEcatid
															   and ( (c.PCEempresa = 1 and v.Ecodigo = #form.Ecodigo#) or (c.PCEempresa = 0 and v.Ecodigo is null) )
															   and v.PCDactivo = 1
															   
															   
															   and	(
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
															   #filtro#
															   order by v.PCDvalor"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value=""/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="formName" value="listaCuentas"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="funcion" value="Asignar"/>
					<cfinvokeargument name="fparams" value="Valor, Descripcion"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			</td>
		  </tr>
		</cfif>
		<cfif form.RefID EQ -1 OR form.RefValor EQ "">
		  <tr>
				<td height="100%" align="center" valign="middle" style="font-size:14px; color:#FF0000;"><cfoutput><strong>#LB_FavorDigValor#  #form.nivelDepende#</strong></cfoutput></td>
		  </tr>
		 </cfif>
		</table>
	
	</body>
</html>
