<cfif not isdefined('form.PEScodigo') or form.PEScodigo EQ ''>
	<cfinclude template="encPlan.cfm">
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">	
	
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfparam name="form.CILcodigo" default="">
		<cfparam name="form.CARcodigo" default="">				
		<cfparam name="form.PEScodigo" default="">
		<cfparam name="form.MPcodigo" default="">				
		<cfparam name="form.EScodigo" default="">				
		<cfparam name="form.PBLsecuencia" default="">		
		<cfparam name="form.nivel" default="2">		
		 <!--- ********************************* --->	
	
		<cfparam name="form.PDOcodigo" default="">
		<cfif form.PDOcodigo EQ "">
			<cfif isdefined('form.modoDocumentacion') and form.modoDocumentacion EQ 'ALTA'>
				<cfinclude template="planDocumentacion_form.cfm">
			<cfelse>				
				<cfinvoke component="educ.componentes.pListas" 
						  method="pListaEdu" 
						  returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="
						PlanDocumentacion mt
						, PlanEstudios m"/>
					<cfinvokeargument name="columnas" value="
						convert(varchar,PDOcodigo) as PDOcodigo					
						, convert(varchar,mt.PEScodigo) as PEScodigo
						, convert(varchar,MDOsecuencia) as MDOsecuencia
						, MDOtitulo
						, MDOdescripcion
						, T='#form.T#'
						, CILcodigo='#form.CILcodigo#'						
						, CARcodigo='#form.CARcodigo#'						
						, PEScodigo='#form.PEScodigo#'
						, EScodigo='#form.EScodigo#'
						, nivel='#form.nivel#'						
						, tabsPlan='#form.tabsPlan#'
						, modoDocumentacion = 'CAMBIO'
						, modoPES = 'MPcambio'											
						, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarDocumentacion						
						, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
						, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>
					<cfinvokeargument name="desplegar" value="borrarDocumentacion,PDOtitulo,upImg,downImg"/>
					<cfinvokeargument name="etiquetas" value="&nbsp;, Documentacion, &nbsp;, &nbsp;"/>
					<cfinvokeargument name="fparams" value="PDOcodigo"/>
					<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
					<cfinvokeargument name="filtro" value="
							Ecodigo=#session.Ecodigo#
							and mt.PEScodigo=#form.PEScodigo#
							and mt.PEScodigo = m.PEScodigo
						order by convert(int,MDOsecuencia)"/>
					<cfinvokeargument name="align" value="center,left,center,center"/>
					<cfinvokeargument name="funcionByCols" value="true"/>					
					<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
					<cfinvokeargument name="ajustar" value="N,S,N,N"/>
					<cfinvokeargument name="keys" value="PDOcodigo"/>
					<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="formName" value="formListaPlanDoc"/>
				</cfinvoke>
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modoDocumentacion") AND form.modoDocumentacion EQ "LISTA")>
			<cfparam name="form.modoDocumentacion" default="CAMBIO">
			<cfinclude template="planDocumentacion_form.cfm">
		<cfelse>
			<cfinvoke component="educ.componentes.pListas" 
					  method="pListaEdu" 
					  returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					PlanDocumentacion mt
					, PlanEstudios m"/>
				<cfinvokeargument name="columnas" value="
					convert(varchar,mt.PEScodigo) as PEScodigo
					, convert(varchar,PDOcodigo) as PDOcodigo
					, convert(varchar,MDOsecuencia) as MDOsecuencia
					, MDOtitulo
					, MDOdescripcion
					, T='#form.T#'
					, CILcodigo='#form.CILcodigo#'						
					, CARcodigo='#form.CARcodigo#'						
					, PEScodigo='#form.PEScodigo#'
					, EScodigo='#form.EScodigo#'												
					, nivel='#form.nivel#'
					, tabsPlan='#form.tabsPlan#'					
					, modoDocumentacion = 'CAMBIO'
					, modoPES = 'MPcambio'					
					, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarDocumentacion
					, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
					, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>					
				<cfinvokeargument name="desplegar" value="borrarDocumentacion,PDOtitulo,upImg,downImg"/>
				<cfinvokeargument name="etiquetas" value="&nbsp;,Documentacion,&nbsp;,&nbsp;"/>
				<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
				<cfinvokeargument name="filtro" value="
						Ecodigo=#session.Ecodigo#
						and mt.PEScodigo=#form.PEScodigo#
						and mt.PEScodigo = m.PEScodigo
					order by convert(int,PDOsecuencia)"/>
				<cfinvokeargument name="align" value="center,left,center,center"/>
				<cfinvokeargument name="fparams" value="PDOcodigo"/>				
				<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
				<cfinvokeargument name="funcionByCols" value="true"/>									
				<cfinvokeargument name="ajustar" value="N,S,N,N"/>
				<cfinvokeargument name="keys" value="PDOcodigo"/>
				<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
				<cfinvokeargument name="debug" value="N"/>				
				<cfinvokeargument name="botones" value="Nuevo"/>				
				<cfinvokeargument name="formName" value="formListaPlanDoc"/>
			</cfinvoke>
		</cfif>
	</td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
	function funcNuevo(){
		document.formListaPlanDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaPlanDoc.TABSPLAN.value = "<cfoutput>#form.tabsPlan#</cfoutput>";						
		document.formListaPlanDoc.T.value= '<cfoutput>#form.T#</cfoutput>';		
		document.formListaPlanDoc.modo.value= 'CAMBIO';		
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaPlanDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaPlanDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaPlanDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaPlanDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaPlanDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaPlanDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaPlanDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaPlanDoc.action = "planDocumentacion_SQL.cfm";
			document.formListaPlanDoc.modo.value= 'MPcambio';
		</cfif>
		document.formListaPlanDoc.MODODOCUMENTACION.value= 'ALTA';		
	}
//---------------------------------
	function bajar(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaPlanDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaPlanDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaPlanDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaPlanDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaPlanDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaPlanDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaPlanDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaPlanDoc.modo.value= 'MPcambio';
		</cfif>	
	
		document.formListaPlanDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaPlanDoc.PDOcodigo.value = cod;
		document.formListaPlanDoc.TABSPLAN.value = "<cfoutput>#form.tabsPlan#</cfoutput>";				
		document.formListaPlanDoc._ActionTag.value = "pushDown";
		document.formListaPlanDoc.action = "planDocumentacion_SQL.cfm";
		document.formListaPlanDoc.submit();
	}
//---------------------------------
	function borrar(cod) {
		if ( confirm('Desea eliminar la Documentación ?') )	{
			<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
				document.formListaPlanDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
				document.formListaPlanDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
				document.formListaPlanDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
				document.formListaPlanDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
				document.formListaPlanDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
				document.formListaPlanDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
				document.formListaPlanDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
				document.formListaPlanDoc.modo.value= 'MPcambio';
			</cfif>		
			document.formListaPlanDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
			document.formListaPlanDoc.PDOcodigo.value = cod;
			document.formListaPlanDoc.TABSPLAN.value = "<cfoutput>#form.tabsPlan#</cfoutput>";				
			document.formListaPlanDoc._ActionTag.value = "borrarDocumentacion";
			document.formListaPlanDoc.action = "planDocumentacion_SQL.cfm";
			document.formListaPlanDoc.submit();
		}
	}	
//---------------------------------	
	function subir(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaPlanDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaPlanDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaPlanDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaPlanDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaPlanDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaPlanDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaPlanDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaPlanDoc.modo.value= 'MPcambio';
		</cfif>	
		document.formListaPlanDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaPlanDoc.PDOcodigo.value = cod;
		document.formListaPlanDoc.TABSPLAN.value = "<cfoutput>#form.tabsPlan#</cfoutput>";		
		document.formListaPlanDoc._ActionTag.value = "pushUp";
		document.formListaPlanDoc.action = "planDocumentacion_SQL.cfm";
		document.formListaPlanDoc.submit();
	}
</script>