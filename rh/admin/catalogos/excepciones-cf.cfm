<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Excepcion_Contable_por_Centro_Funcional"
			Default="Excepcion Contable por Centro Funcional"
			returnvariable="LB_Titulo"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Centro_Funcional"
			Default="Centro Funcional"
			returnvariable="vCentroFuncional"/>
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Objeto_de_Gasto_Original"
			Default="Objeto de Gasto Original"
			returnvariable="vObjeto1"/>
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Objeto_de_Gasto_Nuevo"
			Default="Objeto de Gasto Nuevo"
			returnvariable="vObjeto2"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Desea_eliminar_el_registro"
			Default="Desea eliminar el registro"
			xmlfile="/rh/generales.xml"
			returnvariable="vEliminar"/>

		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Titulo#">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr><td><cfinclude template="excepciones-cf-form.cfm"></td></tr>
				<tr>
					<td>
						<table width="75%" align="center" cellpadding="3">
							<tr>
								<td align="center">

									<cf_dbfunction name="to_char" args="a.CFid" returnvariable="vCFid">
									<cfset parametros = "#vCFid#">
									<cf_dbfunction name="to_char" returnvariable="CFid_char" args="a.CFid">
									<cf_dbfunction name="concat" returnvariable="imagen" args="<img border=''0'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' onClick=javascript:funcEliminar('''+#CFid_char#+''',''' + rtrim(valor1) +''')>" delimiters="+">
									
									<!---
									<cfoutput>
									<img border="0" src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript:funcEliminar(#vCFid#);">
									</cfoutput>
									--->

									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="CFExcepcionCuenta a
																		inner join CFuncional b
																		on b.CFid=a.CFid
																		and b.Ecodigo=a.Ecodigo"/>
										<cfinvokeargument name="columnas" value="a.CFid as CFpk, {fn concat({fn concat(b.CFcodigo, ' - ') }, b.CFdescripcion)} as CFcodigo, b.CFdescripcion, a.valor1, a.valor2, '#imagen#' as eliminar"/>
										<cfinvokeargument name="desplegar" value="CFcodigo, valor1, valor2, eliminar"/>
										<cfinvokeargument name="etiquetas" value="#vCentroFuncional#,#vObjeto1#,#vObjeto2#,&nbsp;"/>
										<cfinvokeargument name="formatos" value=""/>
										<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo# order by b.CFcodigo, a.valor1"/>
										<cfinvokeargument name="align" value="left, left, left, center"/>
										<cfinvokeargument name="ajustar" value=""/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="excepciones-cf.cfm"/>
										<cfinvokeargument name="keys" value="CFpk,valor1"/>
										<cfinvokeargument name="showlink" value="false"/>
									</cfinvoke>
								</td>
							</tr>	
						</table>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
		<form name="formEliminar" method="post" action="excepciones-cf-sql.cfm">
			<input name="CFpk" 	 id="CFpk" 	 type="hidden" value="">
			<input name="valor1" id="valor1" type="hidden" value="">
			<input name="Baja" id="Baja" type="hidden" value="Eliminar">
		</form>
		<script type="text/javascript" language="javascript1.2">
			function funcEliminar(CFpk, valor1){
				if ( confirm('<cfoutput>#vEliminar#</cfoutput>?') ){
					document.formEliminar.CFpk.value = CFpk;
					document.formEliminar.valor1.value = valor1;
					document.formEliminar.submit();
				}
			}
		</script>
<cf_templatefooter>