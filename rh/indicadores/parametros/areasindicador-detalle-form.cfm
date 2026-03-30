<cfinvoke component="sif.Componentes.Translate" Key="LB_CentroFuncional" Default="Ctro. Funcional" returnvariable="LB_Cfuncional" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" Key="LB_EstaSeguroQueDeseaEliminarElRegistro" Default="Esta seguro que desea eliminar el registro?" returnvariable="LB_EliminarReg" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" Key="LB_DebeSeleccionarElCentroFuncional" Default="Debe seleccionar el centro funcional" returnvariable="LB_SeleccionCF" method="Translate"/>

<cfset string1 = "<img src=/cfmx/rh/imagenes/Borrar01_S.gif border=0 onClick=javascript:funcEliminar(">
<cfset string2 = ")>">
<cf_dbfunction name="to_char" args="b.AreaDid" returnvariable="convertido">
<cf_dbfunction name="concat" args="'#string1#'|#convertido#|'#string2#'" returnvariable="imagen" delimiters="|">

<cfquery name="rsLista" datasource="#session.DSN#">
	select	a.AreaEid
			,b.AreaDid
			,c.CFcodigo
			,c.CFdescripcion	
			,#preservesinglequotes(imagen)# as imagen
	from AreaIndEncabezado a
		inner join AreaIndDetalle b
			on a.AreaEid = b.AreaEid
			
			inner join CFuncional c
				on b.CFid = c.CFid	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaEid#">
</cfquery>
<cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<form name="form2" method="post" action="areasindicador-detalle-sql.cfm" style="margin:0;" onSubmit="javascript: return funcValidar();">
					<input type="hidden" name="AreaEid" value="#form.AreaEid#">
					<tr>
						<td><strong>#LB_Cfuncional#:&nbsp;</strong></td>
						<td><cf_rhcfuncional form="form2"></td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="checkbox" name="incluirdependencias"><label for="incluirdependencias">
							<cf_translate key="LB_IncluirDependiencias">Incluir Dependencias</cf_translate></label>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><cf_botones modo="ALTA" exclude="Limpiar"></td>
					</tr>
				</form>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cfinvoke component="rh.Componentes.pListas" method="pListaquery" returnvariable="pListaRet">
							<cfinvokeargument name="query" 				value="#rsLista#"/>
							<cfinvokeargument name="desplegar" 			value="CFcodigo,CFdescripcion,imagen"/>
							<cfinvokeargument name="etiquetas" 			value="#LB_Codigo#,#LB_Descripcion#,&nbsp;"/>
							<cfinvokeargument name="formatos" 			value="S,S,S"/>
							<cfinvokeargument name="align" 				value="left,left,center"/>
							<cfinvokeargument name="ajustar" 			value="N"/>
							<cfinvokeargument name="keys" 			  	value="AreaDid"/>
							<cfinvokeargument name="debug" 			  	value="N"/>
							<!---<cfinvokeargument name="pageIndex" 		  	value="2"/>---->
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>	
							<cfinvokeargument name="formname" 			value="formlista"/>
							<cfinvokeargument name="showLink" 			value="false"/>							
						</cfinvoke>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript" language="javascript1.2">
	function funcEliminar(prn_id){
		if ( confirm('#LB_EliminarReg#') ){
			document.formlista.action = 'areasindicador-detalle-sql.cfm';
			document.formlista.AREADID.value = prn_id;
			document.formlista.AREAEID.value = '#form.AreaEid#';
			document.formlista.submit();
		}				
	}
	
	function funcValidar(){
		if(document.form2.CFid.value ==''){
			alert('#LB_SeleccionCF#');
			return false;
		}
		return true;
	}
</script>
</cfoutput>