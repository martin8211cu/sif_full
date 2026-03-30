<cfif not isdefined('form.PEScodigo') or form.PEScodigo EQ ''>
	<cfinclude template="encMateria.cfm">
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
	
		<cfparam name="form.MDOcodigo" default="">
		<cfif form.MDOcodigo EQ "">
			<cfif isdefined('form.modoDocumentacion') and form.modoDocumentacion EQ 'ALTA'>
				<cfinclude template="materiaDocumentacion_form.cfm">
			<cfelse>				
				<cfinvoke component="educ.componentes.pListas" 
						  method="pListaEdu" 
						  returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="
						MateriaDocumentacion mt
						, Materia m"/>
					<cfinvokeargument name="columnas" value="
						convert(varchar,MDOcodigo) as MDOcodigo					
						, convert(varchar,mt.Mcodigo) as Mcodigo
						, convert(varchar,MDOsecuencia) as MDOsecuencia
						, MDOtitulo
						, MDOdescripcion
						, T='#form.T#'
						, CILcodigo='#form.CILcodigo#'						
						, CARcodigo='#form.CARcodigo#'						
						, PEScodigo='#form.PEScodigo#'
						, EScodigo='#form.EScodigo#'
						, MPcodigo='#form.MPcodigo#'																		
						, PBLsecuencia='#form.PBLsecuencia#'						
						, nivel='#form.nivel#'						
						, tabsMateria='#form.tabsMateria#'
						, modoDocumentacion = 'CAMBIO'
						, modoPES = 'MPcambio'
						, TabsPlan=3											
						, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarDocumentacion						
						, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
						, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>
					<cfinvokeargument name="desplegar" value="borrarDocumentacion,MDOtitulo,upImg,downImg"/>
					<cfinvokeargument name="etiquetas" value="&nbsp;, Documentacion, &nbsp;, &nbsp;"/>
					<cfinvokeargument name="fparams" value="MDOcodigo"/>
					<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
					<cfinvokeargument name="filtro" value="
							Ecodigo=#session.Ecodigo#
							and mt.Mcodigo=#form.Mcodigo#
							and mt.Mcodigo = m.Mcodigo
						order by convert(int,MDOsecuencia)"/>
					<cfinvokeargument name="align" value="center,left,center,center"/>
					<cfinvokeargument name="funcionByCols" value="true"/>					
					<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
					<cfinvokeargument name="ajustar" value="N,S,N,N"/>
					<cfinvokeargument name="keys" value="MDOcodigo"/>
					<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
						<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
					<cfelse>
						<cfinvokeargument name="irA" value="materia.cfm"/>				
					</cfif>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="formName" value="formListaMateriaDoc"/>
				</cfinvoke>
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modoDocumentacion") AND form.modoDocumentacion EQ "LISTA")>
			<cfparam name="form.modoDocumentacion" default="CAMBIO">
			<cfinclude template="materiaDocumentacion_form.cfm">
		<cfelse>
			<cfinvoke component="educ.componentes.pListas" 
					  method="pListaEdu" 
					  returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					MateriaDocumentacion mt
					, Materia m"/>
				<cfinvokeargument name="columnas" value="
					convert(varchar,mt.Mcodigo) as Mcodigo
					, convert(varchar,MDOcodigo) as MDOcodigo
					, convert(varchar,MDOsecuencia) as MDOsecuencia
					, MDOtitulo
					, MDOdescripcion
					, T='#form.T#'
					, CILcodigo='#form.CILcodigo#'						
					, CARcodigo='#form.CARcodigo#'						
					, PEScodigo='#form.PEScodigo#'
					, EScodigo='#form.EScodigo#'												
					, MPcodigo='#form.MPcodigo#'																							
					, PBLsecuencia='#form.PBLsecuencia#'						
					, nivel='#form.nivel#'
					, tabsMateria='#form.tabsMateria#'					
					, modoDocumentacion = 'CAMBIO'
					, modoPES = 'MPcambio'
					, TabsPlan=3 
					, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarDocumentacion
					, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
					, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>					
				<cfinvokeargument name="desplegar" value="borrarDocumentacion,MDOtitulo,upImg,downImg"/>
				<cfinvokeargument name="etiquetas" value="&nbsp;,Documentacion,&nbsp;,&nbsp;"/>
				<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
				<cfinvokeargument name="filtro" value="
						Ecodigo=#session.Ecodigo#
						and mt.Mcodigo=#form.Mcodigo#
						and mt.Mcodigo = m.Mcodigo
					order by convert(int,MDOsecuencia)"/>
				<cfinvokeargument name="align" value="center,left,center,center"/>
				<cfinvokeargument name="fparams" value="MDOcodigo"/>				
				<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
				<cfinvokeargument name="funcionByCols" value="true"/>									
				<cfinvokeargument name="ajustar" value="N,S,N,N"/>
				<cfinvokeargument name="keys" value="MDOcodigo"/>
				<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
					<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
				<cfelse>
					<cfinvokeargument name="irA" value="materia.cfm"/>				
				</cfif>				
				<cfinvokeargument name="debug" value="N"/>				
				<cfinvokeargument name="botones" value="Nuevo"/>				
				<cfinvokeargument name="formName" value="formListaMateriaDoc"/>
			</cfinvoke>
		</cfif>
	</td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
	function funcNuevo(){
		document.formListaMateriaDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaDoc.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";						
		document.formListaMateriaDoc.T.value= '<cfoutput>#form.T#</cfoutput>';		
		document.formListaMateriaDoc.modo.value= 'CAMBIO';
		document.formListaMateriaDoc.TABSPLAN.value= 3;
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
//			document.formListaMateriaDoc.action = "materiaDocumentacion_SQL.cfm";
			document.formListaMateriaDoc.modo.value= 'MPcambio';
		</cfif>
		document.formListaMateriaDoc.MODODOCUMENTACION.value= 'ALTA';		
	}
//---------------------------------
	function bajar(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaMateriaDoc.modo.value= 'MPcambio';
		</cfif>	
	
		document.formListaMateriaDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaDoc.MDOCODIGO.value = cod;
		document.formListaMateriaDoc.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";				
		document.formListaMateriaDoc._ActionTag.value = "pushDown";
		document.formListaMateriaDoc.action = "materiaDocumentacion_SQL.cfm";
		document.formListaMateriaDoc.submit();
	}
//---------------------------------
	function borrar(cod) {
		if ( confirm('Desea eliminar la Documentación ?') )	{
			<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
				document.formListaMateriaDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
				document.formListaMateriaDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
				document.formListaMateriaDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
				document.formListaMateriaDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
				document.formListaMateriaDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
				document.formListaMateriaDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
				document.formListaMateriaDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
				document.formListaMateriaDoc.modo.value= 'MPcambio';
			</cfif>		
			document.formListaMateriaDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
			document.formListaMateriaDoc.MDOCODIGO.value = cod;
			document.formListaMateriaDoc.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";				
			document.formListaMateriaDoc._ActionTag.value = "borrarDocumentacion";
			document.formListaMateriaDoc.action = "materiaDocumentacion_SQL.cfm";
			document.formListaMateriaDoc.submit();
		}
	}	
//---------------------------------	
	function subir(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaDoc.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaDoc.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaDoc.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaDoc.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaDoc.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaDoc.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaDoc.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaMateriaDoc.modo.value= 'MPcambio';
		</cfif>	
		document.formListaMateriaDoc.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaDoc.MDOCODIGO.value = cod;
		document.formListaMateriaDoc.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";		
		document.formListaMateriaDoc._ActionTag.value = "pushUp";
		document.formListaMateriaDoc.action = "materiaDocumentacion_SQL.cfm";
		document.formListaMateriaDoc.submit();
	}
</script>