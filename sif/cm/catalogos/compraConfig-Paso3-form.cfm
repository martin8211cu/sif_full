<!---Define el Modo--->
<cfset MODOCAMBIO = isdefined("Session.Compras.Configuracion.CMElinea") and len(trim(Session.Compras.Configuracion.CMElinea))>
<!---Consultas--->
<!--- 1. Form --->
<cfif MODOCAMBIO>
	<cfquery datasource="#session.DSN#" name="data">
		select CMElinea, CFid, CMTScodigo, CMEtipo, coalesce(ACcodigo,-1) as ACcodigo, coalesce(ACid,-1) as ACid, 
		       coalesce(Cid,0) as Cid, coalesce(Aid, 0) as Aid, coalesce(Ccodigo, 0) as Ccodigo, coalesce(CCid,0) as CCid, ts_rversion
		from CMEspecializacionTSCF
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and CMElinea = <cfqueryparam value="#Session.Compras.Configuracion.CMElinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"/>	
	
	<cfquery datasource="#session.DSN#" name="rsArticulosCla">
		select Ccodigo, Ccodigoclas, Cdescripcion, Cnivel as Nnivel
		from Clasificaciones
		where Ccodigo = <cfqueryparam value="#data.Ccodigo#" cfsqltype="cf_sql_numeric">
		  and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsConceptosCla">
		select CCid, CCcodigo, CCdescripcion, CCnivel
		from CConceptos
		where CCid =	<cfqueryparam value="#data.CCid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!---Permisos por tipo de solicitud--->
<cfquery name="rsSolicitudPermiso" datasource="#session.DSN#">
	select CMTStarticulo, CMTSservicio, CMTSactivofijo
	from CMTiposSolicitud
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
</cfquery>

<!--- Combo Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion 
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Combo Clasificacion --->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by ACcodigo, ACdescripcion	
</cfquery>

<script language="JavaScript" type="text/JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones utilizadas en el form
	// función que oculta y muestra campos según del tipo de clasificación que desea hacerse (Artículo, Servicio, Activo fijo)
	function cambiar_tipo( tipo ) {
		if (tipo == 'A'){
			deshabilitarValidacion();
			habilitarValidacionArt();
			document.getElementById("trArticulo").style.display = '';
			document.getElementById("trServicio").style.display = 'none';
			document.getElementById("trCategoria").style.display = 'none';
			document.getElementById("trClasificacion").style.display = 'none';
			
		}
		else if (tipo == 'S'){
			deshabilitarValidacion();
			habilitarValidacionCon();
			document.getElementById("trArticulo").style.display = 'none';
			document.getElementById("trServicio").style.display = '';
			document.getElementById("trCategoria").style.display = 'none';
			document.getElementById("trClasificacion").style.display = 'none';
		}
		else{
			deshabilitarValidacion();
			habilitarValidacionAct();
			document.getElementById("trArticulo").style.display = 'none';
			document.getElementById("trServicio").style.display = 'none';
			document.getElementById("trCategoria").style.display = '';
			document.getElementById("trClasificacion").style.display = '';
		}
	}
	//función que cambia las clasificaciones correspondientes a la categoría seleccionada (valor)
	function cambiar_categoria( valor, selected ) {
		if ( valor!= "" ) {
			// clasificacion
			document.form1.ACid.length = 0;
			i = 0;
			<cfoutput query="rsClasificacion">
				if ( #Trim(rsClasificacion.ACcodigo)# == valor ){
					document.form1.ACid.length = i+1;
					document.form1.ACid.options[i].value = '#rsClasificacion.ACid#';
					document.form1.ACid.options[i].text  = '#rsClasificacion.ACdescripcion#';
					if ( selected == #Trim(rsClasificacion.ACid)# ){
						document.form1.ACid.options[i].selected=true;
					}
					i++;
				};
			</cfoutput>
		}
		return;
	}
	//función que valida el nivel del servicio o del artículo
	function validaNivel(tipo){
		var nivelmaximo = (tipo=='A')? <cfoutput>#session.Compras.NivelMaxA#</cfoutput> : <cfoutput>#session.Compras.NivelMaxS#</cfoutput>;
		var nivel = (tipo=='A')? document.form1.Nnivel : document.form1.CCnivel;
		if ( (parseInt(nivel.value)+1) != nivelmaximo ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			if ( tipo == 'A' ){
				document.form1.Ccodigo.value = '';
				document.form1.Ccodigoclas.value = '';
				document.form1.Cdescripcion.value = '';
				nivel.value = '';
			}
			else{
				document.form1.CCid.value = '';
				document.form1.CCcodigo.value = '';
				document.form1.CCdescripcion.value = '';
				nivel.value = '';
			}
		}
	}
	//función que valida el nivel de la clasificación del servicio
	function funcCCcodigo(){
		validaNivel('S')
	}
	//función que valida el nivel de la clasificación del artículo	
	function funcCcodigoclas(){
		validaNivel('A')
	}
	//-->
</script>

<cfoutput>
<form name="form1" action="compraConfig-Paso3-sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<!--- Linea que pinta el tipo de Compra, servicios/articulos/activos, compra directa --->
		<tr>
			<td align="right" width="40%" ><strong>Tipo:</strong>&nbsp;</td>
			<td nowrap >
				<select name="CMEtipo" onChange="javascript:cambiar_tipo(this.value);" <cfif MODOCAMBIO>disabled</cfif>   >
					<cfif rsSolicitudPermiso.CMTStarticulo eq 1><option value="A" <cfif MODOCAMBIO  and trim(data.CMEtipo) eq 'A'>selected</cfif>>Art&iacute;culo</option></cfif>
					<cfif rsSolicitudPermiso.CMTSservicio eq 1><option value="S" <cfif MODOCAMBIO  and trim(data.CMEtipo) eq 'S'>selected</cfif> >Servicio</option></cfif>
					<cfif rsSolicitudPermiso.CMTSactivofijo eq 1><option value="F"  <cfif MODOCAMBIO  and trim(data.CMEtipo) eq 'F'>selected</cfif> >Activo Fijo</option></cfif>
				</select>
			</td>
		</tr>
		
		<tr id="trArticulo" >
			<td align="right"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>	
			<td>
				<cfif MODOCAMBIO>
					<cf_sifclasificacionarticulo query="#rsArticulosCla#">
					<input type="hidden" name="_Ccodigo" value="#rsArticulosCla.Ccodigo#">
				<cfelse>
					<cf_sifclasificacionarticulo>
				</cfif>
			</td>
		</tr>
		
		<tr id="trServicio" >
			<td align="right"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>	
			<td>
				<cfif MODOCAMBIO>
					<cf_sifclasificacionconcepto query="#rsConceptosCla#">
					<input type="hidden" name="_CCid" value="#rsConceptosCla.CCid#">
				<cfelse>
					<cf_sifclasificacionconcepto>
				</cfif>
			</td>
		</tr>
		
		<tr id="trCategoria" >
			<td align="right"><strong>Categor&iacute;a:&nbsp;</strong></td>	
			<td>
				<select name="ACcodigo" onChange="javascript:cambiar_categoria(this.value, '');" >
					<cfloop query="rsCategorias">
						<cfif MODOCAMBIO>
							<option value="#rsCategorias.ACcodigo#" <cfif data.ACcodigo eq rsCategorias.ACcodigo >selected</cfif> >#rsCategorias.ACdescripcion#</option>
						<cfelse>
							<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
						</cfif>
					</cfloop>
				</select>
				<cfif MODOCAMBIO>
					<input type="hidden" name="_ACcodigo" value="#data.ACcodigo#">
				</cfif>
			</td>
		</tr>

		<tr id="trClasificacion" >
			<td align="right"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>	
			<td>
				<select name="ACid" ></select>
				<cfif MODOCAMBIO>
					<input type="hidden" name="_ACid" value="#data.ACid#">
				</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="CMElinea" value="<cfif MODOCAMBIO>#data.CMElinea#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif MODOCAMBIO>#ts#</cfif>">
	<input type="hidden" name="Baja" value="false">
	<br>
	<cf_botones values="<< Anterior, Agregar, Finalizar >>" names="Anterior,Alta,Finalizar">
</form>
</cfoutput>

<cfset cols = 0>
<cfif rsSolicitudPermiso.CMTStarticulo eq 1><cfset cols = cols + 1></cfif>
<cfif rsSolicitudPermiso.CMTSservicio eq 1><cfset cols = cols + 1></cfif>
<cfif rsSolicitudPermiso.CMTSactivofijo eq 1><cfset cols = cols + 1></cfif>

<!--- --->
<!---<cfif rsSolicitudPermiso.CMTStarticulo NEQ 1 and  rsSolicitudPermiso.CMTSservicio NEQ 1 and  rsSolicitudPermiso.CMTSactivofijo NEQ 1><cfset cols = cols + 1></cfif>--->
<!--- --->

<!---Listas por Tipo a 3 columnas si tiene permiso--->
<br>
<table width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
		<cfset img   = "<img border='0' src='/cfmx/sif/imagenes/Borrar01_S.gif'>">
		<cfif rsSolicitudPermiso.CMTStarticulo eq 1>
			<td width="#col_width#%" valign="top">
				<cf_web_portlet_start titulo="Artículo">
					<cfquery name="rslistaArticulo" datasource="#session.dsn#">
						select CMElinea as id, b.Ccodigoclas as codigo, b.Cdescripcion as descripcion, '#img#' as borrar, 'A' as tipo
						from CMEspecializacionTSCF a
							inner join Clasificaciones b
								on a.Ecodigo = b.Ecodigo
								and a.Ccodigo = b.Ccodigo
						where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and a.CFid = <cfqueryparam value="#Session.Compras.Configuracion.CFpk#" cfsqltype="cf_sql_numeric">
							and a.CMTScodigo = <cfqueryparam value="#Session.Compras.Configuracion.CMTScodigo#" cfsqltype="cf_sql_char">
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rslistaArticulo#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="id"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="id,tipo"/> 
						<cfinvokeargument name="PageIndex" value="1"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
		</cfif>
		<cfif rsSolicitudPermiso.CMTSservicio eq 1>
			<td width="#col_width#%" valign="top">
				<cf_web_portlet_start titulo="Servicio">
					<cfquery name="rslistaServicio" datasource="#session.dsn#">
						select CMElinea as id, b.CCcodigo as codigo, b.CCdescripcion as descripcion, '#img#' as borrar, 'S' as tipo
						from CMEspecializacionTSCF a
							inner join CConceptos b
								on a.Ecodigo = b.Ecodigo
								and a.CCid = b.CCid
						where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and a.CFid = <cfqueryparam value="#Session.Compras.Configuracion.CFpk#" cfsqltype="cf_sql_numeric">
							and a.CMTScodigo = <cfqueryparam value="#Session.Compras.Configuracion.CMTScodigo#" cfsqltype="cf_sql_char">
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rslistaServicio#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="id"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="id,tipo"/> 
						<cfinvokeargument name="PageIndex" value="2"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
		</cfif>
		<cfif rsSolicitudPermiso.CMTSactivofijo eq 1>
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<td width="#col_width#%" valign="top">
				<cf_web_portlet_start titulo="Activo Fijo">
					<cfquery name="rsCategoriaClase" datasource="#session.dsn#">
						select 	CMElinea as id,
										b.ACdescripcion #_Cat# '/' #_Cat# c.ACdescripcion as descripcion, '#img#' as borrar, 'F' as tipo
						from CMEspecializacionTSCF a
							inner join ACategoria b
								on a.Ecodigo = b.Ecodigo
								and a.ACcodigo = b.ACcodigo
							inner join AClasificacion c
								on a.Ecodigo = c.Ecodigo
								and a.ACcodigo = c.ACcodigo
								and a.ACid = c.ACid
						where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and a.CFid = <cfqueryparam value="#Session.Compras.Configuracion.CFpk#" cfsqltype="cf_sql_numeric">
							and a.CMTScodigo = <cfqueryparam value="#Session.Compras.Configuracion.CMTScodigo#" cfsqltype="cf_sql_char">
					</cfquery>
					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsCategoriaClase#"/> 
						<cfinvokeargument name="desplegar" value="descripcion, borrar"/> 
						<cfinvokeargument name="etiquetas" value=""/> 
						<cfinvokeargument name="formatos" value="S,V"/> 
						<cfinvokeargument name="align" value="left,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="compraConfig.cfm"/> 
						<cfinvokeargument name="keys" value="id"/> 
						<cfinvokeargument name="formname" value="formlista"/> 
						<cfinvokeargument name="funcion" value="funcEliminar"/> 
						<cfinvokeargument name="fparams" value="id,tipo"/> 
						<cfinvokeargument name="PageIndex" value="0"/>
					</cfinvoke> 
				<cf_web_portlet_end>
			</td>
			<td width="1%">&nbsp;</td>
		</cfif>
  </tr>
</table>
<!---Validaciones con QFORMS, Otras Validaciones y Funciones en General--->
<script language="JavaScript" type="text/JavaScript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfoutput>
	objForm.CMEtipo.description="Tipo";
	objForm.Ccodigo.description="#JSStringFormat('Clasificación de Artículo')#";
	objForm.CCid.description="#JSStringFormat('Clasificación de Concepto')#";
	objForm.ACcodigo.description="#JSStringFormat('Categoría')#";
	objForm.ACid.description="#JSStringFormat('Tipo')#";
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.CMEtipo.required = true;
	}
	
	function habilitarValidacionArt(){
		objForm.CMEtipo.required = true;
		objForm.Ccodigo.required=true;
	}

	function habilitarValidacionCon(){
		objForm.CMEtipo.required = true;
		objForm.CCid.required=true;
	}

	function habilitarValidacionAct(){
		objForm.CMEtipo.required = true;
		objForm.ACcodigo.required=true;
		objForm.ACid.required=true;
	}

	function deshabilitarValidacion(){
		objForm.CMEtipo.required = false;
		objForm.Ccodigo.required=false;
		objForm.CCid.required=false;
		objForm.ACcodigo.required=false;
		objForm.ACid.required=false;
	}
	
	function funcEliminar(linea, tipo){
		var tipodesc = '';
		if (tipo=='A') tipodesc = "<cfoutput>#JSStringFormat('Artículo')#</cfoutput>";
		if (tipo=='S') tipodesc = "Servicio";
		if (tipo=='F') tipodesc = "Activo Fijo";
		if (!confirm('¿Desea eliminar el ' + tipodesc + '?')) return false;
		document.form1.CMElinea.value=linea;
		document.form1.Baja.value=1;
		document.form1.submit();
		return false;
	}

	function _iniciarform(){
		habilitarValidacion();
		cambiar_tipo( objForm.CMEtipo.obj.value );
		cambiar_categoria( objForm.ACcodigo.obj.value, "<cfif MODOCAMBIO><cfoutput>#data.ACid#</cfoutput></cfif>");
		<cfif MODOCAMBIO>
			<cfif rsSolicitudPermiso.CMTStarticulo eq 1 and data.CMEtipo eq 'A'>
				objForm.Ccodigoclas.obj.focus();
			<cfelseif rsSolicitudPermiso.CMTSservicio eq 1 and data.CMEtipo eq 'S'>
				objForm.CCcodigo.obj.focus();
			<cfelseif rsSolicitudPermiso.CMTSactivofijo eq 1 and data.CMEtipo eq 'F'>
				objForm.ACcodigo.obj.focus();
			</cfif>
		<cfelse>
			objForm.CMEtipo.obj.focus();
		</cfif>
	}
	
	function _finalizarform(){
		objForm.CMEtipo.obj.disabled = false;
	}
	
	_iniciarform();
	
	//-->
</script>
