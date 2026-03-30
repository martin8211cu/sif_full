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
	
		<cfparam name="form.MTEcodigo" default="">
		<cfif form.MTEcodigo EQ "">
			<cfif isdefined('form.modoTemas') and form.modoTemas EQ 'ALTA'>
				<cfinclude template="materiaTemas_form.cfm">
			<cfelse>				
				<cfinvoke component="educ.componentes.pListas" 
						  method="pListaEdu" 
						  returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="
						MateriaTema mt
						, Materia m"/>
					<cfinvokeargument name="columnas" value="
						convert(varchar,MTEcodigo) as MTEcodigo					
						, convert(varchar,mt.Mcodigo) as Mcodigo
						, convert(varchar,MTEsecuencia) as MTEsecuencia
						, MTEtema
						, MTEdescripcion
						, T='#form.T#'
						, CILcodigo='#form.CILcodigo#'						
						, CARcodigo='#form.CARcodigo#'						
						, PEScodigo='#form.PEScodigo#'
						, EScodigo='#form.EScodigo#'
						, MPcodigo='#form.MPcodigo#'																		
						, PBLsecuencia='#form.PBLsecuencia#'						
						, nivel='#form.nivel#'						
						, tabsMateria='#form.tabsMateria#'
						, TabsPlan=3 
						, modoTemas = 'CAMBIO'
						, modoPES = 'MPcambio'											
						, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarTema						
						, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
						, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>
					<cfinvokeargument name="desplegar" value="borrarTema,MTEtema,upImg,downImg"/>
					<cfinvokeargument name="etiquetas" value="&nbsp;, Tema, &nbsp;, &nbsp;"/>
					<cfinvokeargument name="fparams" value="MTEcodigo"/>
					<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
					<cfinvokeargument name="filtro" value="
							Ecodigo=#session.Ecodigo#
							and mt.Mcodigo=#form.Mcodigo#
							and mt.Mcodigo = m.Mcodigo
						order by convert(int,MTEsecuencia)"/>
					<cfinvokeargument name="align" value="center,left,center,center"/>
					<cfinvokeargument name="funcionByCols" value="true"/>					
					<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
					<cfinvokeargument name="ajustar" value="N,S,N,N"/>
					<cfinvokeargument name="keys" value="MTEcodigo"/>
					<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
						<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
					<cfelse>
						<cfinvokeargument name="irA" value="materia.cfm"/>				
					</cfif>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="formName" value="formListaMateriaTemas"/>
				</cfinvoke>
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modoTemas") AND form.modoTemas EQ "LISTA")>
			<cfparam name="form.modoTemas" default="CAMBIO">
			<cfinclude template="materiaTemas_form.cfm">
		<cfelse>
			<cfinvoke component="educ.componentes.pListas" 
					  method="pListaEdu" 
					  returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					MateriaTema mt
					, Materia m"/>
				<cfinvokeargument name="columnas" value="
					convert(varchar,mt.Mcodigo) as Mcodigo
					, convert(varchar,MTEcodigo) as MTEcodigo
					, convert(varchar,MTEsecuencia) as MTEsecuencia
					, MTEtema
					, MTEdescripcion
					, T='#form.T#'
					, CILcodigo='#form.CILcodigo#'						
					, CARcodigo='#form.CARcodigo#'						
					, PEScodigo='#form.PEScodigo#'
					, EScodigo='#form.EScodigo#'												
					, MPcodigo='#form.MPcodigo#'																							
					, PBLsecuencia='#form.PBLsecuencia#'						
					, nivel='#form.nivel#'
					, tabsMateria='#form.tabsMateria#'
					, TabsPlan=3 					
					, modoTemas = 'CAMBIO'
					, modoPES = 'MPcambio'					
					, '#Session.JSroot#/imagenes/iconos/delete.small.png' as borrarTema
					, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
					, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg"/>					
				<cfinvokeargument name="desplegar" value="borrarTema,MTEtema,upImg,downImg"/>
				<cfinvokeargument name="etiquetas" value="&nbsp;,Tema,&nbsp;,&nbsp;"/>
				<cfinvokeargument name="formatos" value="IMG,V,IMG,IMG"/>
				<cfinvokeargument name="filtro" value="
						Ecodigo=#session.Ecodigo#
						and mt.Mcodigo=#form.Mcodigo#
						and mt.Mcodigo = m.Mcodigo
					order by convert(int,MTEsecuencia)"/>
				<cfinvokeargument name="align" value="center,left,center,center"/>
				<cfinvokeargument name="fparams" value="MTEcodigo"/>				
				<cfinvokeargument name="funcion" value="borrar, ,subir,bajar"/>
				<cfinvokeargument name="funcionByCols" value="true"/>									
				<cfinvokeargument name="ajustar" value="N,S,N,N"/>
				<cfinvokeargument name="keys" value="MTEcodigo"/>
				<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
					<cfinvokeargument name="irA" value="CarrerasPlanes.cfm"/>				
				<cfelse>
					<cfinvokeargument name="irA" value="materia.cfm"/>				
				</cfif>				
				<cfinvokeargument name="debug" value="N"/>				
				<cfinvokeargument name="botones" value="Nuevo"/>				
				<cfinvokeargument name="formName" value="formListaMateriaTemas"/>
			</cfinvoke>
		</cfif>
	</td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
	function funcNuevo(){
		document.formListaMateriaTemas.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaTemas.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";						
		document.formListaMateriaTemas.T.value= '<cfoutput>#form.T#</cfoutput>';		
		document.formListaMateriaTemas.modo.value= 'CAMBIO';			
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaTemas.TABSPLAN.value= 3;		
			document.formListaMateriaTemas.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaTemas.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaTemas.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaTemas.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaTemas.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaTemas.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaTemas.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
//			document.formListaMateriaTemas.action = "materiaTemas_SQL.cfm";
			document.formListaMateriaTemas.modo.value= 'MPcambio';
		</cfif>
		document.formListaMateriaTemas.MODOTEMAS.value= 'ALTA';		
	}
//---------------------------------
	function bajar(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaTemas.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaTemas.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaTemas.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaTemas.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaTemas.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaTemas.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaTemas.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaMateriaTemas.modo.value= 'MPcambio';
		</cfif>	
	
		document.formListaMateriaTemas.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaTemas.MTECODIGO.value = cod;
		document.formListaMateriaTemas.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";				
		document.formListaMateriaTemas._ActionTag.value = "pushDown";
		document.formListaMateriaTemas.action = "materiaTemas_SQL.cfm";
		document.formListaMateriaTemas.submit();
	}
//---------------------------------
	function borrar(cod) {
		if ( confirm('Desea eliminar el tema ?') )	{
			<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
				document.formListaMateriaTemas.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
				document.formListaMateriaTemas.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
				document.formListaMateriaTemas.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
				document.formListaMateriaTemas.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
				document.formListaMateriaTemas.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
				document.formListaMateriaTemas.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
				document.formListaMateriaTemas.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
				document.formListaMateriaTemas.modo.value= 'MPcambio';
			</cfif>		
			document.formListaMateriaTemas.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
			document.formListaMateriaTemas.MTECODIGO.value = cod;
			document.formListaMateriaTemas.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";				
			document.formListaMateriaTemas._ActionTag.value = "borrarTema";
			document.formListaMateriaTemas.action = "materiaTemas_SQL.cfm";
			document.formListaMateriaTemas.submit();
		}
	}	
//---------------------------------	
	function subir(cod) {
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formListaMateriaTemas.CILCODIGO.value= '<cfoutput>#form.CILcodigo#</cfoutput>';		
			document.formListaMateriaTemas.CARCODIGO.value= '<cfoutput>#form.CARcodigo#</cfoutput>';					
			document.formListaMateriaTemas.PESCODIGO.value= '<cfoutput>#form.PEScodigo#</cfoutput>';					
			document.formListaMateriaTemas.ESCODIGO.value= '<cfoutput>#form.EScodigo#</cfoutput>';								
			document.formListaMateriaTemas.MPCODIGO.value= '<cfoutput>#form.MPcodigo#</cfoutput>';											
			document.formListaMateriaTemas.PBLSECUENCIA.value= '<cfoutput>#form.PBLsecuencia#</cfoutput>';					
			document.formListaMateriaTemas.NIVEL.value= '<cfoutput>#form.nivel#</cfoutput>';					
			document.formListaMateriaTemas.modo.value= 'MPcambio';
		</cfif>	
		document.formListaMateriaTemas.MCODIGO.value = "<cfoutput>#form.Mcodigo#</cfoutput>";
		document.formListaMateriaTemas.MTECODIGO.value = cod;
		document.formListaMateriaTemas.TABSMATERIA.value = "<cfoutput>#form.tabsMateria#</cfoutput>";		
		document.formListaMateriaTemas._ActionTag.value = "pushUp";
		document.formListaMateriaTemas.action = "materiaTemas_SQL.cfm";
		document.formListaMateriaTemas.submit();
	}
</script>